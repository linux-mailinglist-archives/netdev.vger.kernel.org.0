Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0AD6EEDA6
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 07:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbjDZFtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 01:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239442AbjDZFsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 01:48:53 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EDE2733;
        Tue, 25 Apr 2023 22:48:22 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PKuKbS025609;
        Tue, 25 Apr 2023 22:48:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=u4vKs69wj9PBIBLxWpA9Xo/cgtMidLKkGLnzNikFw2U=;
 b=D3NAYFVv5pkF5/LVIcl6G+7lLW9jF4qL8qRqW5E4i8a0vZ/RHEB6FxM+X4XeEXNIkHiL
 jSTTqsvnW0xXaOT14reNdGemSiwnze2BqYSTiuG2HzwVR2nRgNBbIkOrXJWFO08QhC22
 lAeJLgmEwfW0bfx+kq+SUCNp+jT1TqmntcVmGlnvOqfVm401A2UHI9dB+/Bxa3XcWlnc
 jYarM+y3kJBld1Fk2XnyZQDrODOtgRze3c8EWRNllk9OGrMSf6tWYeg/22etjKZM69L+
 aJU9fUPYjnKHPdKpxtnBNHwo6tJe7IKsFH/VUBjCVkBo15KxMwweS4kM/Hs34irQa8ai Cw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3pd9kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 22:48:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 22:48:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 22:48:08 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id B681C3F7075;
        Tue, 25 Apr 2023 22:48:02 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <naveenm@marvell.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
Subject: [net-next Patch v10 5/8] octeontx2-pf: Prepare for QOS offload
Date:   Wed, 26 Apr 2023 11:17:28 +0530
Message-ID: <20230426054731.5720-6-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426054731.5720-1-hkelam@marvell.com>
References: <20230426054731.5720-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gmugjOro76A2yRtzBVuvJqkyccTe1Ffi
X-Proofpoint-GUID: gmugjOro76A2yRtzBVuvJqkyccTe1Ffi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-25_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves rate limiting definitions to a common header file and
adds csr definitions required for QOS code.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_common.h       | 28 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h | 13 +++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  | 22 ++-------------
 3 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index cbe09a33ba01..8b6dab3ef67b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -184,6 +184,21 @@ struct mbox {
 	int			up_num_msgs; /* mbox_up number of messages */
 };
 
+/* Egress rate limiting definitions */
+#define MAX_BURST_EXPONENT		0x0FULL
+#define MAX_BURST_MANTISSA		0xFFULL
+#define MAX_BURST_SIZE			130816ULL
+#define MAX_RATE_DIVIDER_EXPONENT	12ULL
+#define MAX_RATE_EXPONENT		0x0FULL
+#define MAX_RATE_MANTISSA		0xFFULL
+
+/* Bitfields in NIX_TLX_PIR register */
+#define TLX_RATE_MANTISSA		GENMASK_ULL(8, 1)
+#define TLX_RATE_EXPONENT		GENMASK_ULL(12, 9)
+#define TLX_RATE_DIVIDER_EXPONENT	GENMASK_ULL(16, 13)
+#define TLX_BURST_MANTISSA		GENMASK_ULL(36, 29)
+#define TLX_BURST_EXPONENT		GENMASK_ULL(40, 37)
+
 struct otx2_hw {
 	struct pci_dev		*pdev;
 	struct otx2_rss_info	rss_info;
@@ -252,6 +267,7 @@ struct otx2_hw {
 #define CN10K_RPM		3
 #define CN10K_PTP_ONESTEP	4
 #define CN10K_HW_MACSEC		5
+#define QOS_CIR_PIR_SUPPORT	6
 	unsigned long		cap_flag;
 
 #define LMT_LINE_SIZE		128
@@ -586,6 +602,7 @@ static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 		__set_bit(CN10K_LMTST, &hw->cap_flag);
 		__set_bit(CN10K_RPM, &hw->cap_flag);
 		__set_bit(CN10K_PTP_ONESTEP, &hw->cap_flag);
+		__set_bit(QOS_CIR_PIR_SUPPORT, &hw->cap_flag);
 	}
 
 	if (is_dev_cn10kb(pfvf->pdev))
@@ -910,6 +927,17 @@ static inline u16 otx2_get_total_tx_queues(struct otx2_nic *pfvf)
 	return pfvf->hw.non_qos_queues + pfvf->hw.tc_tx_queues;
 }
 
+static inline u64 otx2_convert_rate(u64 rate)
+{
+	u64 converted_rate;
+
+	/* Convert bytes per second to Mbps */
+	converted_rate = rate * 8;
+	converted_rate = max_t(u64, converted_rate / 1000000, 1);
+
+	return converted_rate;
+}
+
 /* MSI-X APIs */
 void otx2_free_cints(struct otx2_nic *pfvf, int n);
 void otx2_set_cints_affinity(struct otx2_nic *pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index 1b967eaf948b..45a32e4b49d1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -145,12 +145,25 @@
 #define NIX_AF_TL1X_TOPOLOGY(a)		(0xC80 | (a) << 16)
 #define NIX_AF_TL2X_PARENT(a)		(0xE88 | (a) << 16)
 #define NIX_AF_TL2X_SCHEDULE(a)		(0xE00 | (a) << 16)
+#define NIX_AF_TL2X_TOPOLOGY(a)		(0xE80 | (a) << 16)
+#define NIX_AF_TL2X_CIR(a)              (0xE20 | (a) << 16)
+#define NIX_AF_TL2X_PIR(a)              (0xE30 | (a) << 16)
 #define NIX_AF_TL3X_PARENT(a)		(0x1088 | (a) << 16)
 #define NIX_AF_TL3X_SCHEDULE(a)		(0x1000 | (a) << 16)
+#define NIX_AF_TL3X_SHAPE(a)		(0x1010 | (a) << 16)
+#define NIX_AF_TL3X_CIR(a)		(0x1020 | (a) << 16)
+#define NIX_AF_TL3X_PIR(a)		(0x1030 | (a) << 16)
+#define NIX_AF_TL3X_TOPOLOGY(a)		(0x1080 | (a) << 16)
 #define NIX_AF_TL4X_PARENT(a)		(0x1288 | (a) << 16)
 #define NIX_AF_TL4X_SCHEDULE(a)		(0x1200 | (a) << 16)
+#define NIX_AF_TL4X_SHAPE(a)		(0x1210 | (a) << 16)
+#define NIX_AF_TL4X_CIR(a)		(0x1220 | (a) << 16)
 #define NIX_AF_TL4X_PIR(a)		(0x1230 | (a) << 16)
+#define NIX_AF_TL4X_TOPOLOGY(a)		(0x1280 | (a) << 16)
 #define NIX_AF_MDQX_SCHEDULE(a)		(0x1400 | (a) << 16)
+#define NIX_AF_MDQX_SHAPE(a)		(0x1410 | (a) << 16)
+#define NIX_AF_MDQX_CIR(a)		(0x1420 | (a) << 16)
+#define NIX_AF_MDQX_PIR(a)		(0x1430 | (a) << 16)
 #define NIX_AF_MDQX_PARENT(a)		(0x1480 | (a) << 16)
 #define NIX_AF_TL3_TL2X_LINKX_CFG(a, b)	(0x1700 | (a) << 16 | (b) << 3)
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 044cc211424e..15729e9506ea 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -20,24 +20,9 @@
 #include "cn10k.h"
 #include "otx2_common.h"
 
-/* Egress rate limiting definitions */
-#define MAX_BURST_EXPONENT		0x0FULL
-#define MAX_BURST_MANTISSA		0xFFULL
-#define MAX_BURST_SIZE			130816ULL
-#define MAX_RATE_DIVIDER_EXPONENT	12ULL
-#define MAX_RATE_EXPONENT		0x0FULL
-#define MAX_RATE_MANTISSA		0xFFULL
-
 #define CN10K_MAX_BURST_MANTISSA	0x7FFFULL
 #define CN10K_MAX_BURST_SIZE		8453888ULL
 
-/* Bitfields in NIX_TLX_PIR register */
-#define TLX_RATE_MANTISSA		GENMASK_ULL(8, 1)
-#define TLX_RATE_EXPONENT		GENMASK_ULL(12, 9)
-#define TLX_RATE_DIVIDER_EXPONENT	GENMASK_ULL(16, 13)
-#define TLX_BURST_MANTISSA		GENMASK_ULL(36, 29)
-#define TLX_BURST_EXPONENT		GENMASK_ULL(40, 37)
-
 #define CN10K_TLX_BURST_MANTISSA	GENMASK_ULL(43, 29)
 #define CN10K_TLX_BURST_EXPONENT	GENMASK_ULL(47, 44)
 
@@ -264,7 +249,6 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 	struct netlink_ext_ack *extack = cls->common.extack;
 	struct flow_action *actions = &cls->rule->action;
 	struct flow_action_entry *entry;
-	u64 rate;
 	int err;
 
 	err = otx2_tc_validate_flow(nic, actions, extack);
@@ -288,10 +272,8 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 			NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
 			return -EOPNOTSUPP;
 		}
-		/* Convert bytes per second to Mbps */
-		rate = entry->police.rate_bytes_ps * 8;
-		rate = max_t(u64, rate / 1000000, 1);
-		err = otx2_set_matchall_egress_rate(nic, entry->police.burst, rate);
+		err = otx2_set_matchall_egress_rate(nic, entry->police.burst,
+						    otx2_convert_rate(entry->police.rate_bytes_ps));
 		if (err)
 			return err;
 		nic->flags |= OTX2_FLAG_TC_MATCHALL_EGRESS_ENABLED;
-- 
2.17.1

