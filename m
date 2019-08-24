Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8CA9BACD
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 04:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfHXCBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 22:01:01 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44139 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfHXCBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 22:01:01 -0400
Received: by mail-qk1-f195.google.com with SMTP id d79so9836790qke.11
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 19:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QqTFank3U+X+be7SMnnTniSSOTRxjGndBYM6C6l/uNI=;
        b=XGU0l5g5aLsvHCp32bkMnEB/YeneYHO6eFAHgc/9txfEBUkwn2ahz1O6d2NP1Wqba4
         TCR6vQ8Zh5+de/o4sySvI1Yvtqkw51EoO89YWE+AsdpTA8YV3e61dBP9NTVt+nQpMvDi
         abHC+z3Uobb5MrTVaVY7pHleq667787QsFlVLzemkFSnKjcvTEUvzMfBG4dVmiB+wCzw
         NoHsC8OEmzzvR7v2vRbV9MW48CWeebJ1Mwr7HKL5Q4/k6hB3bMBIRDJGB0ksCVa79jcD
         QqJDSfZ3E9JCykncPXc21AbuBPDCZPGiUuAUkl88b+1obivL2OJa2kM0gIiSclv8obOB
         vZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QqTFank3U+X+be7SMnnTniSSOTRxjGndBYM6C6l/uNI=;
        b=doI+hR64ZhvkOzyGKN4megHpL7bbrcFMgCADqvoSzkHWkpPwKB1ECeT42my6ycbRJt
         UPeBFgMLF4VYWCZc7tJFSl+iUFaMFOrcJU05RbzQHhrlpuKjgkKAsbJRtYn/UZE4K4Kj
         oMUvRUP0wXlmk9/7PcdlaAxwIOzrrQOMaZnctAuFnlBUo3cLYKACYwmQOfPAlPmuBTcv
         jtygWJkpvYZWk1IBRHjKuRgE4qFANv+Vi3+HbU3fuf6CSg3zZHzuOStgGHh0eSNRyiGJ
         YOTFSxPZzkd6Jw4fykiag5pyH7OtNG1bQOjCtMv63ASydZoL1sGPCYBf7XciKqbTGgaJ
         c2Mg==
X-Gm-Message-State: APjAAAVAkvgxphwCst735vZriD8T0v1Cx9TchQvUG/nwV1o1uyVJ7hEK
        mJPXkzOMTbunY61KZKj/Bp7h2A==
X-Google-Smtp-Source: APXvYqx9mi9o5mgjgtJDCV6Q677J5vjJQM09jqO6qaq8p8IpqOxBlrq/mltBFtuS/oYThNSX/ZVYeg==
X-Received: by 2002:ae9:e845:: with SMTP id a66mr7044918qkg.451.1566612060149;
        Fri, 23 Aug 2019 19:01:00 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m13sm2199824qka.92.2019.08.23.19.00.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 19:00:59 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf] nfp: bpf: fix latency bug when updating stack index register
Date:   Fri, 23 Aug 2019 19:00:28 -0700
Message-Id: <20190824020028.6242-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiong Wang <jiong.wang@netronome.com>

NFP is using Local Memory to model stack. LM_addr could be used as base of
a 16 32-bit word region of Local Memory. Then, if the stack offset is
beyond the current region, the local index needs to be updated. The update
needs at least three cycles to take effect, therefore the sequence normally
looks like:

  local_csr_wr[ActLMAddr3, gprB_5]
  nop
  nop
  nop

If the local index switch happens on a narrow loads, then the instruction
preparing value to zero high 32-bit of the destination register could be
counted as one cycle, the sequence then could be something like:

  local_csr_wr[ActLMAddr3, gprB_5]
  nop
  nop
  immed[gprB_5, 0]

However, we have zero extension optimization that zeroing high 32-bit could
be eliminated, therefore above IMMED insn won't be available for which case
the first sequence needs to be generated.

Fixes: 0b4de1ff19bf ("nfp: bpf: eliminate zero extension code-gen")
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/jit.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/jit.c b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
index 4054b70d7719..5afcb3c4c2ef 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/jit.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
@@ -1163,7 +1163,7 @@ mem_op_stack(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 	     bool clr_gpr, lmem_step step)
 {
 	s32 off = nfp_prog->stack_frame_depth + meta->insn.off + ptr_off;
-	bool first = true, last;
+	bool first = true, narrow_ld, last;
 	bool needs_inc = false;
 	swreg stack_off_reg;
 	u8 prev_gpr = 255;
@@ -1209,13 +1209,22 @@ mem_op_stack(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 
 		needs_inc = true;
 	}
+
+	narrow_ld = clr_gpr && size < 8;
+
 	if (lm3) {
+		unsigned int nop_cnt;
+
 		emit_csr_wr(nfp_prog, imm_b(nfp_prog), NFP_CSR_ACT_LM_ADDR3);
-		/* For size < 4 one slot will be filled by zeroing of upper. */
-		wrp_nops(nfp_prog, clr_gpr && size < 8 ? 2 : 3);
+		/* For size < 4 one slot will be filled by zeroing of upper,
+		 * but be careful, that zeroing could be eliminated by zext
+		 * optimization.
+		 */
+		nop_cnt = narrow_ld && meta->flags & FLAG_INSN_DO_ZEXT ? 2 : 3;
+		wrp_nops(nfp_prog, nop_cnt);
 	}
 
-	if (clr_gpr && size < 8)
+	if (narrow_ld)
 		wrp_zext(nfp_prog, meta, gpr);
 
 	while (size) {
-- 
2.21.0

