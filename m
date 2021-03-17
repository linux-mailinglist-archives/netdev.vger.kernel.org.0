Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8BD33F0B4
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhCQMwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:52:15 -0400
Received: from foss.arm.com ([217.140.110.172]:59700 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhCQMwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 08:52:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26F6931B;
        Wed, 17 Mar 2021 05:51:59 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.208.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ED3783F792;
        Wed, 17 Mar 2021 05:51:53 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     bpf@vger.kernel.org
Cc:     kuba@kernel.org, simon.horman@netronome.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-api@vger.kernel.org,
        Jianlin.Lv@arm.com, iecedge@gmail.com
Subject: [PATCH bpf-next] bpf: Simplify expression for identify bpf mem type
Date:   Wed, 17 Mar 2021 20:51:47 +0800
Message-Id: <20210317125147.2159512-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added BPF_SIZE_MASK macro as mask of size modifier that help to reduce
the evaluation of expressions in if statements,
and remove BPF_SIZE_MASK in netronome driver.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/main.h |  2 --
 include/uapi/linux/bpf.h                      |  1 +
 kernel/bpf/verifier.c                         | 12 ++++--------
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.h b/drivers/net/ethernet/netronome/nfp/bpf/main.h
index d0e17eebddd9..8b1c2509ce46 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.h
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.h
@@ -346,8 +346,6 @@ struct nfp_insn_meta {
 	struct list_head l;
 };
 
-#define BPF_SIZE_MASK	0x18
-
 static inline u8 mbpf_class(const struct nfp_insn_meta *meta)
 {
 	return BPF_CLASS(meta->insn.code);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2d3036e292a9..5d77675e7112 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -21,6 +21,7 @@
 #define BPF_DW		0x18	/* double word (64-bit) */
 #define BPF_ATOMIC	0xc0	/* atomic memory ops - op type in immediate */
 #define BPF_XADD	0xc0	/* exclusive add - legacy name */
+#define BPF_SIZE_MASK	0x18    /* mask of size modifier */
 
 /* alu/jmp fields */
 #define BPF_MOV		0xb0	/* mov reg to reg */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f9096b049cd6..9755bb4d7de4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11384,15 +11384,11 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 	for (i = 0; i < insn_cnt; i++, insn++) {
 		bpf_convert_ctx_access_t convert_ctx_access;
 
-		if (insn->code == (BPF_LDX | BPF_MEM | BPF_B) ||
-		    insn->code == (BPF_LDX | BPF_MEM | BPF_H) ||
-		    insn->code == (BPF_LDX | BPF_MEM | BPF_W) ||
-		    insn->code == (BPF_LDX | BPF_MEM | BPF_DW))
+		/* opcode: BPF_MEM | <size> | BPF_LDX */
+		if ((insn->code & ~BPF_SIZE_MASK) == (BPF_LDX | BPF_MEM))
 			type = BPF_READ;
-		else if (insn->code == (BPF_STX | BPF_MEM | BPF_B) ||
-			 insn->code == (BPF_STX | BPF_MEM | BPF_H) ||
-			 insn->code == (BPF_STX | BPF_MEM | BPF_W) ||
-			 insn->code == (BPF_STX | BPF_MEM | BPF_DW))
+		/* opcode: BPF_MEM | <size> | BPF_STX */
+		else if ((insn->code & ~BPF_SIZE_MASK) == (BPF_STX | BPF_MEM))
 			type = BPF_WRITE;
 		else
 			continue;
-- 
2.25.1

