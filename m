Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180CF461674
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbhK2Nfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:35:36 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51654 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232948AbhK2Ndf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:33:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1ATBwiGU010651;
        Mon, 29 Nov 2021 05:30:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=q5LuzwXpfFlWnpX5HWyi2u1A6iimvDuJSEXABldh7cc=;
 b=d8VJENX4BTlTzoD6WpaA3EtIQpMo7y/daZsRTUfuE3/9kD3KkUdGwpm0416gdFwYcV1V
 x3wFixifACFPeRu2lDyuLw1F66nWCqpX5q++QstQfrKT3MQXwquAe1PuO9jMhI2pg7qJ
 uEILotvsPEIKDKm9sRnl0Br43FvGa9oG6lrLMcPmhDaRJ4rXnpd4jI7X4daGQCyyepOl
 phTc3mwADL5HrYE+wpj+hAO7rebQ3Wu9Ma4qhe9PELuQx+DJp6Venq2tilIMUWauIZBE
 EHpRx3jHNQVzOiLFHjyJS7QScvJ4rrwaPTUPWALUQHniCARJGWoefTdP1fPyMIYc211y HA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cmgkptk0e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 05:30:16 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Nov
 2021 05:30:13 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 29 Nov 2021 05:30:14 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0FEA43F70C2;
        Mon, 29 Nov 2021 05:30:14 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1ATDU3IW016156;
        Mon, 29 Nov 2021 05:30:03 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1ATDTvtj016099;
        Mon, 29 Nov 2021 05:29:57 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <irusskikh@marvell.com>,
        <dbezrukov@marvell.com>, Nikita Danilov <ndanilov@aquantia.com>
Subject: [PATCH net 2/7] atlatnic: enable Nbase-t speeds with base-t
Date:   Mon, 29 Nov 2021 05:28:24 -0800
Message-ID: <20211129132829.16038-3-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211129132829.16038-1-skalluru@marvell.com>
References: <20211129132829.16038-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: e68O08hpD1Fwa72ku4v_xyrbyh06l-Jv
X-Proofpoint-GUID: e68O08hpD1Fwa72ku4v_xyrbyh06l-Jv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_08,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@aquantia.com>

When 2.5G is advertised, N-Base should be advertised against the T-base
caps. N5G is out of use in baseline code and driver should treat both 5G
and N5G (and also 2.5G and N2.5G) equally from user perspective.

Fixes: 5cfd54d7dc186 ("net: atlantic: minimal A2 fw_ops")
Signed-off-by: Nikita Danilov <ndanilov@aquantia.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_common.h    | 25 +++++++++----------
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |  3 ---
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       |  4 +--
 3 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_common.h b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
index 23b2d390fcdd..4ad8f36fcade 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_common.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_common.h
@@ -53,20 +53,19 @@
 
 #define AQ_NIC_RATE_10G		BIT(0)
 #define AQ_NIC_RATE_5G		BIT(1)
-#define AQ_NIC_RATE_5GSR	BIT(2)
-#define AQ_NIC_RATE_2G5		BIT(3)
-#define AQ_NIC_RATE_1G		BIT(4)
-#define AQ_NIC_RATE_100M	BIT(5)
-#define AQ_NIC_RATE_10M		BIT(6)
-#define AQ_NIC_RATE_1G_HALF	BIT(7)
-#define AQ_NIC_RATE_100M_HALF	BIT(8)
-#define AQ_NIC_RATE_10M_HALF	BIT(9)
+#define AQ_NIC_RATE_2G5		BIT(2)
+#define AQ_NIC_RATE_1G		BIT(3)
+#define AQ_NIC_RATE_100M	BIT(4)
+#define AQ_NIC_RATE_10M		BIT(5)
+#define AQ_NIC_RATE_1G_HALF	BIT(6)
+#define AQ_NIC_RATE_100M_HALF	BIT(7)
+#define AQ_NIC_RATE_10M_HALF	BIT(8)
 
-#define AQ_NIC_RATE_EEE_10G	BIT(10)
-#define AQ_NIC_RATE_EEE_5G	BIT(11)
-#define AQ_NIC_RATE_EEE_2G5	BIT(12)
-#define AQ_NIC_RATE_EEE_1G	BIT(13)
-#define AQ_NIC_RATE_EEE_100M	BIT(14)
+#define AQ_NIC_RATE_EEE_10G	BIT(9)
+#define AQ_NIC_RATE_EEE_5G	BIT(10)
+#define AQ_NIC_RATE_EEE_2G5	BIT(11)
+#define AQ_NIC_RATE_EEE_1G	BIT(12)
+#define AQ_NIC_RATE_EEE_100M	BIT(13)
 #define AQ_NIC_RATE_EEE_MSK     (AQ_NIC_RATE_EEE_10G |\
 				 AQ_NIC_RATE_EEE_5G |\
 				 AQ_NIC_RATE_EEE_2G5 |\
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index eac631c45c56..4d4cfbc91e19 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -132,9 +132,6 @@ static enum hw_atl_fw2x_rate link_speed_mask_2fw2x_ratemask(u32 speed)
 	if (speed & AQ_NIC_RATE_5G)
 		rate |= FW2X_RATE_5G;
 
-	if (speed & AQ_NIC_RATE_5GSR)
-		rate |= FW2X_RATE_5G;
-
 	if (speed & AQ_NIC_RATE_2G5)
 		rate |= FW2X_RATE_2G5;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index b0e4119b9883..b7a9b0ed6df3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -154,7 +154,7 @@ static void a2_link_speed_mask2fw(u32 speed,
 {
 	link_options->rate_10G = !!(speed & AQ_NIC_RATE_10G);
 	link_options->rate_5G = !!(speed & AQ_NIC_RATE_5G);
-	link_options->rate_N5G = !!(speed & AQ_NIC_RATE_5GSR);
+	link_options->rate_N5G = link_options->rate_5G;
 	link_options->rate_2P5G = !!(speed & AQ_NIC_RATE_2G5);
 	link_options->rate_N2P5G = link_options->rate_2P5G;
 	link_options->rate_1G = !!(speed & AQ_NIC_RATE_1G);
@@ -192,8 +192,6 @@ static u32 a2_fw_lkp_to_mask(struct lkp_link_caps_s *lkp_link_caps)
 		rate |= AQ_NIC_RATE_10G;
 	if (lkp_link_caps->rate_5G)
 		rate |= AQ_NIC_RATE_5G;
-	if (lkp_link_caps->rate_N5G)
-		rate |= AQ_NIC_RATE_5GSR;
 	if (lkp_link_caps->rate_2P5G)
 		rate |= AQ_NIC_RATE_2G5;
 	if (lkp_link_caps->rate_1G)
-- 
2.27.0

