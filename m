Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68ACA58E0B4
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbiHIUKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiHIUKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:10:16 -0400
X-Greylist: delayed 3590 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 09 Aug 2022 13:10:14 PDT
Received: from stargate.chelsio.com (stargate.chelsio.com [12.32.117.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D651F0A;
        Tue,  9 Aug 2022 13:10:14 -0700 (PDT)
Received: from localhost (raina-lt.asicdesigners.com [10.193.177.168] (may be forged))
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 279IftXR031673;
        Tue, 9 Aug 2022 11:41:57 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     linux-rdma@vger.kernel.org
Cc:     netdev@vger.kernel.org, jgg@nvidia.com, leonro@nvidia.com,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, keescook@chromium.org, bharat@chelsio.com
Subject: [PATCH for-rc] RDMA/cxgb4: fix accept failure due to increased cpl_t5_pass_accept_rpl size
Date:   Wed, 10 Aug 2022 00:11:18 +0530
Message-Id: <20220809184118.2029-1-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Potnuri Bharat Teja <bharat@chelsio.com>

Commit 'c2ed5611afd7' has increased the cpl_t5_pass_accept_rpl{} structure
size by 8B to avoid roundup. cpl_t5_pass_accept_rpl{} is a HW specific
structure and increasing its size will lead to unwanted adapter errors.
Current commit reverts the cpl_t5_pass_accept_rpl{} back to its original
and allocates zeroed skb buffer there by avoiding the memset for iss field.
Reorder code to minimize chip type checks.

Fixes: c2ed5611afd7 ("iw_cxgb4: Use memset_startat() for cpl_t5_pass_accept_rpl")
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/infiniband/hw/cxgb4/cm.c            | 25 ++++++++-------------
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |  2 +-
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index c16017f6e8db..14392c942f49 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2468,31 +2468,24 @@ static int accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 			opt2 |= CCTRL_ECN_V(1);
 	}
 
-	skb_get(skb);
-	rpl = cplhdr(skb);
 	if (!is_t4(adapter_type)) {
-		BUILD_BUG_ON(sizeof(*rpl5) != roundup(sizeof(*rpl5), 16));
-		skb_trim(skb, sizeof(*rpl5));
-		rpl5 = (void *)rpl;
-		INIT_TP_WR(rpl5, ep->hwtid);
-	} else {
-		skb_trim(skb, sizeof(*rpl));
-		INIT_TP_WR(rpl, ep->hwtid);
-	}
-	OPCODE_TID(rpl) = cpu_to_be32(MK_OPCODE_TID(CPL_PASS_ACCEPT_RPL,
-						    ep->hwtid));
-
-	if (CHELSIO_CHIP_VERSION(adapter_type) > CHELSIO_T4) {
 		u32 isn = (prandom_u32() & ~7UL) - 1;
+
+		skb = get_skb(skb, roundup(sizeof(*rpl5), 16), GFP_KERNEL);
+		rpl5 = __skb_put_zero(skb, roundup(sizeof(*rpl5), 16));
+		rpl = (void *)rpl5;
+		INIT_TP_WR_CPL(rpl5, CPL_PASS_ACCEPT_RPL, ep->hwtid);
 		opt2 |= T5_OPT_2_VALID_F;
 		opt2 |= CONG_CNTRL_V(CONG_ALG_TAHOE);
 		opt2 |= T5_ISS_F;
-		rpl5 = (void *)rpl;
-		memset_after(rpl5, 0, iss);
 		if (peer2peer)
 			isn += 4;
 		rpl5->iss = cpu_to_be32(isn);
 		pr_debug("iss %u\n", be32_to_cpu(rpl5->iss));
+	} else {
+		skb = get_skb(skb, sizeof(*rpl), GFP_KERNEL);
+		rpl = __skb_put_zero(skb, sizeof(*rpl));
+		INIT_TP_WR_CPL(rpl, CPL_PASS_ACCEPT_RPL, ep->hwtid);
 	}
 
 	rpl->opt0 = cpu_to_be64(opt0);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index 26433a62d7f0..fed5f93bf620 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -497,7 +497,7 @@ struct cpl_t5_pass_accept_rpl {
 	__be32 opt2;
 	__be64 opt0;
 	__be32 iss;
-	__be32 rsvd[3];
+	__be32 rsvd;
 };
 
 struct cpl_act_open_req {
-- 
2.31.1

