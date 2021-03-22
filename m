Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097EC344BBF
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhCVQiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:38:18 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:24880 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhCVQhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:37:52 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4F40Xn37YXz9txkS;
        Mon, 22 Mar 2021 17:37:45 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id jd0ggnH-0fRy; Mon, 22 Mar 2021 17:37:45 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4F40Xn2GR1z9txkL;
        Mon, 22 Mar 2021 17:37:45 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 005AC8B7A3;
        Mon, 22 Mar 2021 17:37:50 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id BbAqe78Pxeh8; Mon, 22 Mar 2021 17:37:50 +0100 (CET)
Received: from po16121vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B678F8B79C;
        Mon, 22 Mar 2021 17:37:50 +0100 (CET)
Received: by po16121vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 9946B675F4; Mon, 22 Mar 2021 16:37:50 +0000 (UTC)
Message-Id: <608faa1dc3ecfead649e15392abd07b00313d2ba.1616430991.git.christophe.leroy@csgroup.eu>
In-Reply-To: <cover.1616430991.git.christophe.leroy@csgroup.eu>
References: <cover.1616430991.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH v2 5/8] powerpc/bpf: Change values of SEEN_ flags
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Mon, 22 Mar 2021 16:37:50 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because PPC32 will use more non volatile registers,
move SEEN_ flags to positions 0-2 which corresponds to special
registers.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/net/bpf_jit.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index b34abfce15a6..fb4656986fb9 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -108,18 +108,18 @@ static inline bool is_nearbranch(int offset)
 #define COND_LT		(CR0_LT | COND_CMP_TRUE)
 #define COND_LE		(CR0_GT | COND_CMP_FALSE)
 
-#define SEEN_FUNC	0x1000 /* might call external helpers */
-#define SEEN_STACK	0x2000 /* uses BPF stack */
-#define SEEN_TAILCALL	0x4000 /* uses tail calls */
+#define SEEN_FUNC	0x20000000 /* might call external helpers */
+#define SEEN_STACK	0x40000000 /* uses BPF stack */
+#define SEEN_TAILCALL	0x80000000 /* uses tail calls */
 
 struct codegen_context {
 	/*
 	 * This is used to track register usage as well
 	 * as calls to external helpers.
 	 * - register usage is tracked with corresponding
-	 *   bits (r3-r10 and r27-r31)
+	 *   bits (r3-r31)
 	 * - rest of the bits can be used to track other
-	 *   things -- for now, we use bits 16 to 23
+	 *   things -- for now, we use bits 0 to 2
 	 *   encoded in SEEN_* macros above
 	 */
 	unsigned int seen;
-- 
2.25.0

