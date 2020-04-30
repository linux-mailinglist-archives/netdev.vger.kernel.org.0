Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951691C05E5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgD3TK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:10:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46565 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726375AbgD3TKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:10:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588273823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/G31CExp0D/v67boay0bigWI6ERnvygVLl/0mJmroU0=;
        b=ZP0AGYU1ZPXZGDMJ47Uf0kuCEPCN9u8Kr2cF4uVpGCAtJjROoQvIiUUZ3Y2LSFoJgutKhK
        gJ96OtRDx32yQIQ0b/2JRnLOaXdeqlBK0I21rYYpYpD/dNILVW1GH7apaxD3Wazd3k9JN8
        z1D0BAmvexP1zplqjvADx5liC2uKNF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-4FOHzYZaOv-IP7n1za9RVQ-1; Thu, 30 Apr 2020 15:10:21 -0400
X-MC-Unique: 4FOHzYZaOv-IP7n1za9RVQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9115A835B43;
        Thu, 30 Apr 2020 19:10:19 +0000 (UTC)
Received: from treble.redhat.com (ovpn-113-19.rdu2.redhat.com [10.10.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 477231A922;
        Thu, 30 Apr 2020 19:10:18 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] bpf: Tweak BPF jump table optimizations for objtool compatibility
Date:   Thu, 30 Apr 2020 14:07:43 -0500
Message-Id: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Objtool decodes instructions and follows all potential code branches
within a function.  But it's not an emulator, so it doesn't track
register values.  For that reason, it usually can't follow
intra-function indirect branches, unless they're using a jump table
which follows a certain format (e.g., GCC switch statement jump tables).

In most cases, the generated code for the BPF jump table looks a lot
like a GCC jump table, so objtool can follow it.  However, with
RETPOLINE=3Dn, GCC keeps the jump table address in a register, and then
does 160+ indirect jumps with it.  When objtool encounters the indirect
jumps, it can't tell which jump table is being used (or even whether
they might be sibling calls instead).

This was fixed before by disabling an optimization in ___bpf_prog_run(),
using the "optimize" function attribute.  However, that attribute is bad
news.  It doesn't append options to the command-line arguments.  Instead
it starts from a blank slate.  And according to recent GCC documentation
it's not recommended for production use.  So revert the previous fix:

  3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run=
()")

With that reverted, solve the original problem in a different way by
getting rid of the "goto select_insn" indirection, and instead just goto
the jump table directly.  This simplifies the code a bit and helps GCC
generate saner code for the jump table branches, at least in the
RETPOLINE=3Dn case.

But, in the RETPOLINE=3Dy case, this simpler code actually causes GCC to
generate far worse code, ballooning the function text size by +40%.  So
leave that code the way it was.  In fact Alexei prefers to leave *all*
the code the way it was, except where needed by objtool.  So even
non-x86 RETPOLINE=3Dn code will continue to have "goto select_insn".

This stuff is crazy voodoo, and far from ideal.  But it works for now.
Eventually, there's a plan to create a compiler plugin for annotating
jump tables.  That will make this a lot less fragile.

Fixes: 3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_pro=
g_run()")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 include/linux/compiler-gcc.h   |  2 --
 include/linux/compiler_types.h |  4 ----
 kernel/bpf/core.c              | 10 +++++++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index cf294faec2f8..2c8583eb5de8 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -176,5 +176,3 @@
 #else
 #define __diag_GCC_8(s)
 #endif
-
-#define __no_fgcse __attribute__((optimize("-fno-gcse")))
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_type=
s.h
index e970f97a7fcb..58105f1deb79 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -203,10 +203,6 @@ struct ftrace_likely_data {
 #define asm_inline asm
 #endif
=20
-#ifndef __no_fgcse
-# define __no_fgcse
-#endif
-
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof=
(b))
=20
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 916f5132a984..eec470c598ad 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1364,7 +1364,7 @@ u64 __weak bpf_probe_read_kernel(void *dst, u32 siz=
e, const void *unsafe_ptr)
  *
  * Decode and execute eBPF instructions.
  */
-static u64 __no_fgcse ___bpf_prog_run(u64 *regs, const struct bpf_insn *=
insn, u64 *stack)
+static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *=
stack)
 {
 #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] =3D &&x##_##y
 #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] =3D &&x##_=
##y##_##z
@@ -1384,11 +1384,15 @@ static u64 __no_fgcse ___bpf_prog_run(u64 *regs, =
const struct bpf_insn *insn, u6
 #undef BPF_INSN_2_LBL
 	u32 tail_call_cnt =3D 0;
=20
+#if defined(CONFIG_X86_64) && !defined(CONFIG_RETPOLINE)
+#define CONT	 ({ insn++; goto *jumptable[insn->code]; })
+#define CONT_JMP ({ insn++; goto *jumptable[insn->code]; })
+#else
 #define CONT	 ({ insn++; goto select_insn; })
 #define CONT_JMP ({ insn++; goto select_insn; })
-
 select_insn:
 	goto *jumptable[insn->code];
+#endif
=20
 	/* ALU */
 #define ALU(OPCODE, OP)			\
@@ -1547,7 +1551,7 @@ static u64 __no_fgcse ___bpf_prog_run(u64 *regs, co=
nst struct bpf_insn *insn, u6
 		 * where arg1_type is ARG_PTR_TO_CTX.
 		 */
 		insn =3D prog->insnsi;
-		goto select_insn;
+		CONT;
 out:
 		CONT;
 	}
--=20
2.21.1

