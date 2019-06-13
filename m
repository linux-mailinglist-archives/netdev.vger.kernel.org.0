Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A813439D8
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388606AbfFMPQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:16:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732203AbfFMNXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:23:44 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE355300145F;
        Thu, 13 Jun 2019 13:23:39 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C7A3541F0;
        Thu, 13 Jun 2019 13:23:35 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: [PATCH 2/9] objtool: Fix ORC unwinding in non-JIT BPF generated code
Date:   Thu, 13 Jun 2019 08:20:59 -0500
Message-Id: <99c22bbd79e72855f4bc9049981602d537a54e70.1560431531.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560431531.git.jpoimboe@redhat.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 13 Jun 2019 13:23:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Objtool currently ignores ___bpf_prog_run() because it doesn't
understand the jump table.  This results in the ORC unwinder not being
able to unwind through non-JIT BPF code.

Luckily, the BPF jump table resembles a GCC switch jump table, which
objtool already knows how to read.

Add generic support for reading any static local jump table array named
"jump_table", and rename the BPF variable accordingly, so objtool can
generate ORC data for ___bpf_prog_run().

Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
Reported-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 kernel/bpf/core.c     |  5 ++---
 tools/objtool/check.c | 16 ++++++++++++++--
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7c473f208a10..aa546ef7dbdc 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1299,7 +1299,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 {
 #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
 #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
-	static const void *jumptable[256] = {
+	static const void *jump_table[256] = {
 		[0 ... 255] = &&default_label,
 		/* Now overwrite non-defaults ... */
 		BPF_INSN_MAP(BPF_INSN_2_LBL, BPF_INSN_3_LBL),
@@ -1315,7 +1315,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 #define CONT_JMP ({ insn++; goto select_insn; })
 
 select_insn:
-	goto *jumptable[insn->code];
+	goto *jump_table[insn->code];
 
 	/* ALU */
 #define ALU(OPCODE, OP)			\
@@ -1558,7 +1558,6 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		BUG_ON(1);
 		return 0;
 }
-STACK_FRAME_NON_STANDARD(___bpf_prog_run); /* jump table */
 
 #define PROG_NAME(stack_size) __bpf_prog_run##stack_size
 #define DEFINE_BPF_PROG_RUN(stack_size) \
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 172f99195726..8341c2fff14f 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -18,6 +18,8 @@
 
 #define FAKE_JUMP_OFFSET -1
 
+#define JUMP_TABLE_SYM_PREFIX "jump_table."
+
 struct alternative {
 	struct list_head list;
 	struct instruction *insn;
@@ -997,6 +999,7 @@ static struct rela *find_switch_table(struct objtool_file *file,
 	struct instruction *orig_insn = insn;
 	struct section *rodata_sec;
 	unsigned long table_offset;
+	struct symbol *sym;
 
 	/*
 	 * Backward search using the @first_jump_src links, these help avoid
@@ -1035,9 +1038,18 @@ static struct rela *find_switch_table(struct objtool_file *file,
 
 		/*
 		 * Make sure the .rodata address isn't associated with a
-		 * symbol.  gcc jump tables are anonymous data.
+		 * symbol.  GCC jump tables are anonymous data.
+		 *
+		 * Also support C jump tables which are in the same format as
+		 * switch jump tables.  Each jump table should be a static
+		 * local const array named "jump_table" for objtool to
+		 * recognize it.  Note: GCC will add a numbered suffix to the
+		 * ELF symbol name, like "jump_table.12345", which it does for
+		 * all static local variables.
 		 */
-		if (find_symbol_containing(rodata_sec, table_offset))
+		sym = find_symbol_containing(rodata_sec, table_offset);
+		if (sym && strncmp(sym->name, JUMP_TABLE_SYM_PREFIX,
+				   strlen(JUMP_TABLE_SYM_PREFIX)))
 			continue;
 
 		rodata_rela = find_rela_by_dest(rodata_sec, table_offset);
-- 
2.20.1

