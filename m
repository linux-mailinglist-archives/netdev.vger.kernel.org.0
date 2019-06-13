Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EF5439C2
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733176AbfFMPQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:16:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8369 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732207AbfFMNXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:23:51 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 433E3301BE65;
        Thu, 13 Jun 2019 13:23:51 +0000 (UTC)
Received: from treble.redhat.com (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C4B954216;
        Thu, 13 Jun 2019 13:23:50 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers for generated code
Date:   Thu, 13 Jun 2019 08:21:04 -0500
Message-Id: <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1560431531.git.jpoimboe@redhat.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 13 Jun 2019 13:23:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ORC unwinder can't unwind through BPF JIT generated code because
there are no ORC entries associated with the code.

If an ORC entry isn't available, try to fall back to frame pointers.  If
BPF and other generated code always do frame pointer setup (even with
CONFIG_FRAME_POINTERS=n) then this will allow ORC to unwind through most
generated code despite there being no corresponding ORC entries.

Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
Reported-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/kernel/unwind_orc.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 33b66b5c5aec..72b997eaa1fc 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -82,9 +82,9 @@ static struct orc_entry *orc_find(unsigned long ip);
  * But they are copies of the ftrace entries that are static and
  * defined in ftrace_*.S, which do have orc entries.
  *
- * If the undwinder comes across a ftrace trampoline, then find the
+ * If the unwinder comes across a ftrace trampoline, then find the
  * ftrace function that was used to create it, and use that ftrace
- * function's orc entrie, as the placement of the return code in
+ * function's orc entry, as the placement of the return code in
  * the stack will be identical.
  */
 static struct orc_entry *orc_ftrace_find(unsigned long ip)
@@ -128,6 +128,16 @@ static struct orc_entry null_orc_entry = {
 	.type = ORC_TYPE_CALL
 };
 
+/* Fake frame pointer entry -- used as a fallback for generated code */
+static struct orc_entry orc_fp_entry = {
+	.type		= ORC_TYPE_CALL,
+	.sp_reg		= ORC_REG_BP,
+	.sp_offset	= 16,
+	.bp_reg		= ORC_REG_PREV_SP,
+	.bp_offset	= -16,
+	.end		= 0,
+};
+
 static struct orc_entry *orc_find(unsigned long ip)
 {
 	static struct orc_entry *orc;
@@ -392,8 +402,16 @@ bool unwind_next_frame(struct unwind_state *state)
 	 * calls and calls to noreturn functions.
 	 */
 	orc = orc_find(state->signal ? state->ip : state->ip - 1);
-	if (!orc)
-		goto err;
+	if (!orc) {
+		/*
+		 * As a fallback, try to assume this code uses a frame pointer.
+		 * This is useful for generated code, like BPF, which ORC
+		 * doesn't know about.  This is just a guess, so the rest of
+		 * the unwind is no longer considered reliable.
+		 */
+		orc = &orc_fp_entry;
+		state->error = true;
+	}
 
 	/* End-of-stack check for kernel threads: */
 	if (orc->sp_reg == ORC_REG_UNDEFINED) {
-- 
2.20.1

