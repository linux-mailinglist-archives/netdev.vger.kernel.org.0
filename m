Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFC157F3F8
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiGXIVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiGXIVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:21:32 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9968311D
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:21:31 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26O6xPdO002124;
        Sun, 24 Jul 2022 01:21:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=4F+dzPTfuaj4y1wH5KOIJD20EKIuBKxUMbhfxnO6o4Y=;
 b=Pg+CuOU3sFy3Jo08qAwsHyFOohA4w/Qt3J0XcJAuTfb4C+7d5FALG38dlNgESz64Mo6a
 ntEP84uE8KhqDkP4QyzwFHIjTKCPC0c8CYrLD60MrjxVZUus1YaYYptJhdf+EttqHyfy
 7p/+C5IqXGqFbcoDxEcpPSjlw7HDKndaZCA3M0AgGInBw0VRwiTUjdkLrDj/Y9m/djj5
 c+akmcJOowoBatwlZj4oXGmo3jFF+S/oRAfpkc4BOW+Y9amJUtKaKdPcbXnAV3e5+Ri9
 nA08SRyq8EfWlmDAQ0gyJk21a/4dfpVzFHG/3Uqstrn/glAkGg+e2Qctw9o3VnlbEHU3 yg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hgebq2cgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jul 2022 01:21:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Jul
 2022 01:21:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Jul 2022 01:21:22 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 95E633F7048;
        Sun, 24 Jul 2022 01:21:20 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 1/2] octeontx2-pf: cn10k: Fix egress ratelimit configuration
Date:   Sun, 24 Jul 2022 13:51:13 +0530
Message-ID: <1658650874-16459-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658650874-16459-1-git-send-email-sbhatta@marvell.com>
References: <1658650874-16459-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: eLjRAxPvzOobI--hmzpt9sZWoyqsACl1
X-Proofpoint-ORIG-GUID: eLjRAxPvzOobI--hmzpt9sZWoyqsACl1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-23_02,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

NIX_AF_TLXX_PIR/CIR register format has changed from OcteonTx2
to CN10K. CN10K supports larger burst size. Fix burst exponent
and burst mantissa configuration for CN10K.

Also fixed 'maxrate' from u32 to u64 since 'police.rate_bytes_ps'
passed by stack is also u64.

Fixes: e638a83f167e ("octeontx2-pf: TC_MATCHALL egress ratelimiting offload")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 76 ++++++++++++++++------
 1 file changed, 55 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 28b1994..fa83cf2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -28,6 +28,9 @@
 #define MAX_RATE_EXPONENT		0x0FULL
 #define MAX_RATE_MANTISSA		0xFFULL
 
+#define CN10K_MAX_BURST_MANTISSA	0x7FFFULL
+#define CN10K_MAX_BURST_SIZE		8453888ULL
+
 /* Bitfields in NIX_TLX_PIR register */
 #define TLX_RATE_MANTISSA		GENMASK_ULL(8, 1)
 #define TLX_RATE_EXPONENT		GENMASK_ULL(12, 9)
@@ -35,6 +38,9 @@
 #define TLX_BURST_MANTISSA		GENMASK_ULL(36, 29)
 #define TLX_BURST_EXPONENT		GENMASK_ULL(40, 37)
 
+#define CN10K_TLX_BURST_MANTISSA	GENMASK_ULL(43, 29)
+#define CN10K_TLX_BURST_EXPONENT	GENMASK_ULL(47, 44)
+
 struct otx2_tc_flow_stats {
 	u64 bytes;
 	u64 pkts;
@@ -77,33 +83,42 @@ int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic)
 }
 EXPORT_SYMBOL(otx2_tc_alloc_ent_bitmap);
 
-static void otx2_get_egress_burst_cfg(u32 burst, u32 *burst_exp,
-				      u32 *burst_mantissa)
+static void otx2_get_egress_burst_cfg(struct otx2_nic *nic, u32 burst,
+				      u32 *burst_exp, u32 *burst_mantissa)
 {
+	int max_burst, max_mantissa;
 	unsigned int tmp;
 
+	if (is_dev_otx2(nic->pdev)) {
+		max_burst = MAX_BURST_SIZE;
+		max_mantissa = MAX_BURST_MANTISSA;
+	} else {
+		max_burst = CN10K_MAX_BURST_SIZE;
+		max_mantissa = CN10K_MAX_BURST_MANTISSA;
+	}
+
 	/* Burst is calculated as
 	 * ((256 + BURST_MANTISSA) << (1 + BURST_EXPONENT)) / 256
 	 * Max supported burst size is 130,816 bytes.
 	 */
-	burst = min_t(u32, burst, MAX_BURST_SIZE);
+	burst = min_t(u32, burst, max_burst);
 	if (burst) {
 		*burst_exp = ilog2(burst) ? ilog2(burst) - 1 : 0;
 		tmp = burst - rounddown_pow_of_two(burst);
-		if (burst < MAX_BURST_MANTISSA)
+		if (burst < max_mantissa)
 			*burst_mantissa = tmp * 2;
 		else
 			*burst_mantissa = tmp / (1ULL << (*burst_exp - 7));
 	} else {
 		*burst_exp = MAX_BURST_EXPONENT;
-		*burst_mantissa = MAX_BURST_MANTISSA;
+		*burst_mantissa = max_mantissa;
 	}
 }
 
-static void otx2_get_egress_rate_cfg(u32 maxrate, u32 *exp,
+static void otx2_get_egress_rate_cfg(u64 maxrate, u32 *exp,
 				     u32 *mantissa, u32 *div_exp)
 {
-	unsigned int tmp;
+	u64 tmp;
 
 	/* Rate calculation by hardware
 	 *
@@ -132,21 +147,44 @@ static void otx2_get_egress_rate_cfg(u32 maxrate, u32 *exp,
 	}
 }
 
-static int otx2_set_matchall_egress_rate(struct otx2_nic *nic, u32 burst, u32 maxrate)
+static u64 otx2_get_txschq_rate_regval(struct otx2_nic *nic,
+				       u64 maxrate, u32 burst)
 {
-	struct otx2_hw *hw = &nic->hw;
-	struct nix_txschq_config *req;
 	u32 burst_exp, burst_mantissa;
 	u32 exp, mantissa, div_exp;
+	u64 regval = 0;
+
+	/* Get exponent and mantissa values from the desired rate */
+	otx2_get_egress_burst_cfg(nic, burst, &burst_exp, &burst_mantissa);
+	otx2_get_egress_rate_cfg(maxrate, &exp, &mantissa, &div_exp);
+
+	if (is_dev_otx2(nic->pdev)) {
+		regval = FIELD_PREP(TLX_BURST_EXPONENT, (u64)burst_exp) |
+				FIELD_PREP(TLX_BURST_MANTISSA, (u64)burst_mantissa) |
+				FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
+				FIELD_PREP(TLX_RATE_EXPONENT, exp) |
+				FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	} else {
+		regval = FIELD_PREP(CN10K_TLX_BURST_EXPONENT, (u64)burst_exp) |
+				FIELD_PREP(CN10K_TLX_BURST_MANTISSA, (u64)burst_mantissa) |
+				FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
+				FIELD_PREP(TLX_RATE_EXPONENT, exp) |
+				FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	}
+
+	return regval;
+}
+
+static int otx2_set_matchall_egress_rate(struct otx2_nic *nic,
+					 u32 burst, u64 maxrate)
+{
+	struct otx2_hw *hw = &nic->hw;
+	struct nix_txschq_config *req;
 	int txschq, err;
 
 	/* All SQs share the same TL4, so pick the first scheduler */
 	txschq = hw->txschq_list[NIX_TXSCH_LVL_TL4][0];
 
-	/* Get exponent and mantissa values from the desired rate */
-	otx2_get_egress_burst_cfg(burst, &burst_exp, &burst_mantissa);
-	otx2_get_egress_rate_cfg(maxrate, &exp, &mantissa, &div_exp);
-
 	mutex_lock(&nic->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_txschq_cfg(&nic->mbox);
 	if (!req) {
@@ -157,11 +195,7 @@ static int otx2_set_matchall_egress_rate(struct otx2_nic *nic, u32 burst, u32 ma
 	req->lvl = NIX_TXSCH_LVL_TL4;
 	req->num_regs = 1;
 	req->reg[0] = NIX_AF_TL4X_PIR(txschq);
-	req->regval[0] = FIELD_PREP(TLX_BURST_EXPONENT, burst_exp) |
-			 FIELD_PREP(TLX_BURST_MANTISSA, burst_mantissa) |
-			 FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
-			 FIELD_PREP(TLX_RATE_EXPONENT, exp) |
-			 FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+	req->regval[0] = otx2_get_txschq_rate_regval(nic, maxrate, burst);
 
 	err = otx2_sync_mbox_msg(&nic->mbox);
 	mutex_unlock(&nic->mbox.lock);
@@ -230,7 +264,7 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 	struct netlink_ext_ack *extack = cls->common.extack;
 	struct flow_action *actions = &cls->rule->action;
 	struct flow_action_entry *entry;
-	u32 rate;
+	u64 rate;
 	int err;
 
 	err = otx2_tc_validate_flow(nic, actions, extack);
@@ -256,7 +290,7 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 		}
 		/* Convert bytes per second to Mbps */
 		rate = entry->police.rate_bytes_ps * 8;
-		rate = max_t(u32, rate / 1000000, 1);
+		rate = max_t(u64, rate / 1000000, 1);
 		err = otx2_set_matchall_egress_rate(nic, entry->police.burst, rate);
 		if (err)
 			return err;
-- 
2.7.4

