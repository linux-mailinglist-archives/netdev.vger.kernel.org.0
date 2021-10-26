Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9CE43BB0E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhJZTk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:40:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3928 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230441AbhJZTk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 15:40:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QI7DcE014687;
        Tue, 26 Oct 2021 12:38:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=hdBLIPE9ghUd/gls7Zy1c3Sy08//LNqSPaGULZtQ0Nw=;
 b=R4WzhbFCUvpZ66m/gdj2dVqddFVMkUHG1RBXc9lsvcn8DIJmZL0mCn90xv/RJXlSbTOn
 dxe2l4nXh1QsQo5odi5+qjwqh8mikyHsgxLenaMbRJ+02F+AzYRawLDX9Wt4h0fdLNv7
 RgppVslusyxJVsM9PSjFvGNkWx8G8zYQ1Ir8PFun6Eyv6MRaoRg7CVpcy3xV3bTM9HlZ
 xquAMvUMdTwSo84RolGhaOczhrX9esJsY0zMxSkP74kMjmknydVK4FLqoYb0h84zzu3C
 dof+gjjKw3l2zDwbHor3ruSoN2CbmNk9SH/+5/oSQIpZ3qkeFP8QHCVHVRmsYTU69FoB fw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bxfv8jcrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 12:38:01 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 12:37:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 12:37:59 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 431B73F7065;
        Tue, 26 Oct 2021 12:37:59 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19QJbdu0002703;
        Tue, 26 Oct 2021 12:37:39 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19QJbJab002693;
        Tue, 26 Oct 2021 12:37:19 -0700
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stable@vger.kernel.org>,
        <aelior@marvell.com>, <skalluru@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>,
        <okulkarni@marvell.com>, <njavali@marvell.com>,
        <GR-everest-linux-l2@marvell.com>
Subject: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Date:   Tue, 26 Oct 2021 12:37:16 -0700
Message-ID: <20211026193717.2657-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: UafCjp-8nvhUaW4y2ZIgraOKz1sRE7q3
X-Proofpoint-ORIG-GUID: UafCjp-8nvhUaW4y2ZIgraOKz1sRE7q3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0050dcf3e848 ("bnx2x: Add FW 7.13.20.0") added a new .bin
firmware file to linux-firmware.git tree. This new firmware addresses
few important issues and enhancements as mentioned below -

- Support direct invalidation of FP HSI Ver per function ID, required for
  invalidating FP HSI Ver prior to each VF start, as there is no VF start
- BRB hardware block parity error detection support for the driver
- Fix the FCOE underrun flow
- Fix PSOD during FCoE BFS over the NIC ports after preboot driver

This patch incorporates this new firmware 7.13.20.0 in bnx2x driver.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 .../ethernet/broadcom/bnx2x/bnx2x_fw_defs.h   | 148 ++++++++++--------
 .../net/ethernet/broadcom/bnx2x/bnx2x_hsi.h   |  13 +-
 2 files changed, 91 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
index 3f8435208bf4..5ee46c4234fb 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
@@ -32,31 +32,34 @@
 	* IRO[142].m2) + ((sbId) * IRO[142].m3))
 #define CSTORM_IGU_MODE_OFFSET (IRO[161].base)
 #define CSTORM_ISCSI_CQ_SIZE_OFFSET(pfId) \
-	(IRO[324].base + ((pfId) * IRO[324].m1))
-#define CSTORM_ISCSI_CQ_SQN_SIZE_OFFSET(pfId) \
 	(IRO[325].base + ((pfId) * IRO[325].m1))
+#define CSTORM_ISCSI_CQ_SQN_SIZE_OFFSET(pfId) \
+	(IRO[326].base + ((pfId) * IRO[326].m1))
 #define CSTORM_ISCSI_EQ_CONS_OFFSET(pfId, iscsiEqId) \
-	(IRO[317].base + ((pfId) * IRO[317].m1) + ((iscsiEqId) * IRO[317].m2))
+	(IRO[318].base + ((pfId) * IRO[318].m1) + ((iscsiEqId) * IRO[318].m2))
 #define CSTORM_ISCSI_EQ_NEXT_EQE_ADDR_OFFSET(pfId, iscsiEqId) \
-	(IRO[319].base + ((pfId) * IRO[319].m1) + ((iscsiEqId) * IRO[319].m2))
+	(IRO[320].base + ((pfId) * IRO[320].m1) + ((iscsiEqId) * IRO[320].m2))
 #define CSTORM_ISCSI_EQ_NEXT_PAGE_ADDR_OFFSET(pfId, iscsiEqId) \
-	(IRO[318].base + ((pfId) * IRO[318].m1) + ((iscsiEqId) * IRO[318].m2))
+	(IRO[319].base + ((pfId) * IRO[319].m1) + ((iscsiEqId) * IRO[319].m2))
+
 #define CSTORM_ISCSI_EQ_NEXT_PAGE_ADDR_VALID_OFFSET(pfId, iscsiEqId) \
-	(IRO[320].base + ((pfId) * IRO[320].m1) + ((iscsiEqId) * IRO[320].m2))
+	(IRO[321].base + ((pfId) * IRO[321].m1) + ((iscsiEqId) * IRO[321].m2))
 #define CSTORM_ISCSI_EQ_PROD_OFFSET(pfId, iscsiEqId) \
-	(IRO[316].base + ((pfId) * IRO[316].m1) + ((iscsiEqId) * IRO[316].m2))
+	(IRO[317].base + ((pfId) * IRO[317].m1) + ((iscsiEqId) * IRO[317].m2))
 #define CSTORM_ISCSI_EQ_SB_INDEX_OFFSET(pfId, iscsiEqId) \
-	(IRO[322].base + ((pfId) * IRO[322].m1) + ((iscsiEqId) * IRO[322].m2))
+	(IRO[323].base + ((pfId) * IRO[323].m1) + ((iscsiEqId) * IRO[323].m2))
 #define CSTORM_ISCSI_EQ_SB_NUM_OFFSET(pfId, iscsiEqId) \
-	(IRO[321].base + ((pfId) * IRO[321].m1) + ((iscsiEqId) * IRO[321].m2))
+	(IRO[322].base + ((pfId) * IRO[322].m1) + ((iscsiEqId) * IRO[322].m2))
+
 #define CSTORM_ISCSI_HQ_SIZE_OFFSET(pfId) \
-	(IRO[323].base + ((pfId) * IRO[323].m1))
+	(IRO[324].base + ((pfId) * IRO[324].m1))
 #define CSTORM_ISCSI_NUM_OF_TASKS_OFFSET(pfId) \
-	(IRO[315].base + ((pfId) * IRO[315].m1))
+	(IRO[316].base + ((pfId) * IRO[316].m1))
 #define CSTORM_ISCSI_PAGE_SIZE_LOG_OFFSET(pfId) \
-	(IRO[314].base + ((pfId) * IRO[314].m1))
+	(IRO[315].base + ((pfId) * IRO[315].m1))
 #define CSTORM_ISCSI_PAGE_SIZE_OFFSET(pfId) \
-	(IRO[313].base + ((pfId) * IRO[313].m1))
+	(IRO[314].base + ((pfId) * IRO[314].m1))
+
 #define CSTORM_RECORD_SLOW_PATH_OFFSET(funcId) \
 	(IRO[155].base + ((funcId) * IRO[155].m1))
 #define CSTORM_SP_STATUS_BLOCK_DATA_OFFSET(pfId) \
@@ -90,90 +93,92 @@
 #define CSTORM_VF_TO_PF_OFFSET(funcId) \
 	(IRO[154].base + ((funcId) * IRO[154].m1))
 #define TSTORM_APPROXIMATE_MATCH_MULTICAST_FILTERING_OFFSET(pfId) \
-	(IRO[207].base + ((pfId) * IRO[207].m1))
+	(IRO[208].base + ((pfId) * IRO[208].m1))
 #define TSTORM_ASSERT_LIST_INDEX_OFFSET	(IRO[102].base)
 #define TSTORM_ASSERT_LIST_OFFSET(assertListEntry) \
 	(IRO[101].base + ((assertListEntry) * IRO[101].m1))
 #define TSTORM_FUNCTION_COMMON_CONFIG_OFFSET(pfId) \
-	(IRO[205].base + ((pfId) * IRO[205].m1))
+	(IRO[206].base + ((pfId) * IRO[206].m1))
 #define TSTORM_FUNC_EN_OFFSET(funcId) \
 	(IRO[107].base + ((funcId) * IRO[107].m1))
 #define TSTORM_ISCSI_ERROR_BITMAP_OFFSET(pfId) \
-	(IRO[279].base + ((pfId) * IRO[279].m1))
-#define TSTORM_ISCSI_L2_ISCSI_OOO_CID_TABLE_OFFSET(pfId) \
 	(IRO[280].base + ((pfId) * IRO[280].m1))
-#define TSTORM_ISCSI_L2_ISCSI_OOO_CLIENT_ID_TABLE_OFFSET(pfId) \
+#define TSTORM_ISCSI_L2_ISCSI_OOO_CID_TABLE_OFFSET(pfId) \
 	(IRO[281].base + ((pfId) * IRO[281].m1))
-#define TSTORM_ISCSI_L2_ISCSI_OOO_PROD_OFFSET(pfId) \
+#define TSTORM_ISCSI_L2_ISCSI_OOO_CLIENT_ID_TABLE_OFFSET(pfId) \
 	(IRO[282].base + ((pfId) * IRO[282].m1))
+#define TSTORM_ISCSI_L2_ISCSI_OOO_PROD_OFFSET(pfId) \
+	(IRO[283].base + ((pfId) * IRO[283].m1))
 #define TSTORM_ISCSI_NUM_OF_TASKS_OFFSET(pfId) \
-	(IRO[278].base + ((pfId) * IRO[278].m1))
+	(IRO[279].base + ((pfId) * IRO[279].m1))
 #define TSTORM_ISCSI_PAGE_SIZE_LOG_OFFSET(pfId) \
-	(IRO[277].base + ((pfId) * IRO[277].m1))
+	(IRO[278].base + ((pfId) * IRO[278].m1))
 #define TSTORM_ISCSI_PAGE_SIZE_OFFSET(pfId) \
-	(IRO[276].base + ((pfId) * IRO[276].m1))
+	(IRO[277].base + ((pfId) * IRO[277].m1))
 #define TSTORM_ISCSI_RQ_SIZE_OFFSET(pfId) \
-	(IRO[275].base + ((pfId) * IRO[275].m1))
+	(IRO[276].base + ((pfId) * IRO[276].m1))
+
 #define TSTORM_ISCSI_TCP_LOCAL_ADV_WND_OFFSET(pfId) \
-	(IRO[285].base + ((pfId) * IRO[285].m1))
+	(IRO[286].base + ((pfId) * IRO[286].m1))
 #define TSTORM_ISCSI_TCP_VARS_FLAGS_OFFSET(pfId) \
-	(IRO[271].base + ((pfId) * IRO[271].m1))
-#define TSTORM_ISCSI_TCP_VARS_LSB_LOCAL_MAC_ADDR_OFFSET(pfId) \
 	(IRO[272].base + ((pfId) * IRO[272].m1))
-#define TSTORM_ISCSI_TCP_VARS_MID_LOCAL_MAC_ADDR_OFFSET(pfId) \
+#define TSTORM_ISCSI_TCP_VARS_LSB_LOCAL_MAC_ADDR_OFFSET(pfId) \
 	(IRO[273].base + ((pfId) * IRO[273].m1))
-#define TSTORM_ISCSI_TCP_VARS_MSB_LOCAL_MAC_ADDR_OFFSET(pfId) \
+#define TSTORM_ISCSI_TCP_VARS_MID_LOCAL_MAC_ADDR_OFFSET(pfId) \
 	(IRO[274].base + ((pfId) * IRO[274].m1))
+#define TSTORM_ISCSI_TCP_VARS_MSB_LOCAL_MAC_ADDR_OFFSET(pfId) \
+	(IRO[275].base + ((pfId) * IRO[275].m1))
 #define TSTORM_MAC_FILTER_CONFIG_OFFSET(pfId) \
-	(IRO[206].base + ((pfId) * IRO[206].m1))
+	(IRO[207].base + ((pfId) * IRO[207].m1))
 #define TSTORM_RECORD_SLOW_PATH_OFFSET(funcId) \
 	(IRO[109].base + ((funcId) * IRO[109].m1))
 #define TSTORM_TCP_MAX_CWND_OFFSET(pfId) \
-	(IRO[224].base + ((pfId) * IRO[224].m1))
+	(IRO[225].base + ((pfId) * IRO[225].m1))
 #define TSTORM_VF_TO_PF_OFFSET(funcId) \
 	(IRO[108].base + ((funcId) * IRO[108].m1))
-#define USTORM_AGG_DATA_OFFSET (IRO[213].base)
-#define USTORM_AGG_DATA_SIZE (IRO[213].size)
+#define USTORM_AGG_DATA_OFFSET (IRO[214].base)
+#define USTORM_AGG_DATA_SIZE (IRO[214].size)
 #define USTORM_ASSERT_LIST_INDEX_OFFSET	(IRO[181].base)
 #define USTORM_ASSERT_LIST_OFFSET(assertListEntry) \
 	(IRO[180].base + ((assertListEntry) * IRO[180].m1))
 #define USTORM_ETH_PAUSE_ENABLED_OFFSET(portId) \
 	(IRO[187].base + ((portId) * IRO[187].m1))
 #define USTORM_FCOE_EQ_PROD_OFFSET(pfId) \
-	(IRO[326].base + ((pfId) * IRO[326].m1))
+	(IRO[327].base + ((pfId) * IRO[327].m1))
 #define USTORM_FUNC_EN_OFFSET(funcId) \
 	(IRO[182].base + ((funcId) * IRO[182].m1))
 #define USTORM_ISCSI_CQ_SIZE_OFFSET(pfId) \
-	(IRO[290].base + ((pfId) * IRO[290].m1))
-#define USTORM_ISCSI_CQ_SQN_SIZE_OFFSET(pfId) \
 	(IRO[291].base + ((pfId) * IRO[291].m1))
+#define USTORM_ISCSI_CQ_SQN_SIZE_OFFSET(pfId) \
+	(IRO[292].base + ((pfId) * IRO[292].m1))
 #define USTORM_ISCSI_ERROR_BITMAP_OFFSET(pfId) \
-	(IRO[295].base + ((pfId) * IRO[295].m1))
+	(IRO[296].base + ((pfId) * IRO[296].m1))
 #define USTORM_ISCSI_GLOBAL_BUF_PHYS_ADDR_OFFSET(pfId) \
-	(IRO[292].base + ((pfId) * IRO[292].m1))
+	(IRO[293].base + ((pfId) * IRO[293].m1))
 #define USTORM_ISCSI_NUM_OF_TASKS_OFFSET(pfId) \
-	(IRO[288].base + ((pfId) * IRO[288].m1))
+	(IRO[289].base + ((pfId) * IRO[289].m1))
 #define USTORM_ISCSI_PAGE_SIZE_LOG_OFFSET(pfId) \
-	(IRO[287].base + ((pfId) * IRO[287].m1))
+	(IRO[288].base + ((pfId) * IRO[288].m1))
 #define USTORM_ISCSI_PAGE_SIZE_OFFSET(pfId) \
-	(IRO[286].base + ((pfId) * IRO[286].m1))
+	(IRO[287].base + ((pfId) * IRO[287].m1))
+
 #define USTORM_ISCSI_R2TQ_SIZE_OFFSET(pfId) \
-	(IRO[289].base + ((pfId) * IRO[289].m1))
+	(IRO[290].base + ((pfId) * IRO[290].m1))
 #define USTORM_ISCSI_RQ_BUFFER_SIZE_OFFSET(pfId) \
-	(IRO[293].base + ((pfId) * IRO[293].m1))
-#define USTORM_ISCSI_RQ_SIZE_OFFSET(pfId) \
 	(IRO[294].base + ((pfId) * IRO[294].m1))
+#define USTORM_ISCSI_RQ_SIZE_OFFSET(pfId) \
+	(IRO[295].base + ((pfId) * IRO[295].m1))
 #define USTORM_MEM_WORKAROUND_ADDRESS_OFFSET(pfId) \
 	(IRO[186].base + ((pfId) * IRO[186].m1))
 #define USTORM_RECORD_SLOW_PATH_OFFSET(funcId) \
 	(IRO[184].base + ((funcId) * IRO[184].m1))
 #define USTORM_RX_PRODS_E1X_OFFSET(portId, clientId) \
-	(IRO[216].base + ((portId) * IRO[216].m1) + ((clientId) * \
-	IRO[216].m2))
+	(IRO[217].base + ((portId) * IRO[217].m1) + ((clientId) * \
+	IRO[217].m2))
 #define USTORM_RX_PRODS_E2_OFFSET(qzoneId) \
-	(IRO[217].base + ((qzoneId) * IRO[217].m1))
-#define USTORM_TPA_BTR_OFFSET (IRO[214].base)
-#define USTORM_TPA_BTR_SIZE (IRO[214].size)
+	(IRO[218].base + ((qzoneId) * IRO[218].m1))
+#define USTORM_TPA_BTR_OFFSET (IRO[215].base)
+#define USTORM_TPA_BTR_SIZE (IRO[215].size)
 #define USTORM_VF_TO_PF_OFFSET(funcId) \
 	(IRO[183].base + ((funcId) * IRO[183].m1))
 #define XSTORM_AGG_INT_FINAL_CLEANUP_COMP_TYPE (IRO[67].base)
@@ -183,44 +188,49 @@
 	(IRO[50].base + ((assertListEntry) * IRO[50].m1))
 #define XSTORM_CMNG_PER_PORT_VARS_OFFSET(portId) \
 	(IRO[43].base + ((portId) * IRO[43].m1))
+#define XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(functionId) \
+	(IRO[205].base + ((functionId) * IRO[205].m1))
 #define XSTORM_FAIRNESS_PER_VN_VARS_OFFSET(pfId) \
 	(IRO[45].base + ((pfId) * IRO[45].m1))
 #define XSTORM_FUNC_EN_OFFSET(funcId) \
 	(IRO[47].base + ((funcId) * IRO[47].m1))
 #define XSTORM_ISCSI_HQ_SIZE_OFFSET(pfId) \
-	(IRO[303].base + ((pfId) * IRO[303].m1))
+	(IRO[304].base + ((pfId) * IRO[304].m1))
 #define XSTORM_ISCSI_LOCAL_MAC_ADDR0_OFFSET(pfId) \
-	(IRO[306].base + ((pfId) * IRO[306].m1))
-#define XSTORM_ISCSI_LOCAL_MAC_ADDR1_OFFSET(pfId) \
 	(IRO[307].base + ((pfId) * IRO[307].m1))
-#define XSTORM_ISCSI_LOCAL_MAC_ADDR2_OFFSET(pfId) \
+#define XSTORM_ISCSI_LOCAL_MAC_ADDR1_OFFSET(pfId) \
 	(IRO[308].base + ((pfId) * IRO[308].m1))
-#define XSTORM_ISCSI_LOCAL_MAC_ADDR3_OFFSET(pfId) \
+#define XSTORM_ISCSI_LOCAL_MAC_ADDR2_OFFSET(pfId) \
 	(IRO[309].base + ((pfId) * IRO[309].m1))
-#define XSTORM_ISCSI_LOCAL_MAC_ADDR4_OFFSET(pfId) \
+#define XSTORM_ISCSI_LOCAL_MAC_ADDR3_OFFSET(pfId) \
 	(IRO[310].base + ((pfId) * IRO[310].m1))
-#define XSTORM_ISCSI_LOCAL_MAC_ADDR5_OFFSET(pfId) \
+#define XSTORM_ISCSI_LOCAL_MAC_ADDR4_OFFSET(pfId) \
 	(IRO[311].base + ((pfId) * IRO[311].m1))
-#define XSTORM_ISCSI_LOCAL_VLAN_OFFSET(pfId) \
+#define XSTORM_ISCSI_LOCAL_MAC_ADDR5_OFFSET(pfId) \
 	(IRO[312].base + ((pfId) * IRO[312].m1))
+#define XSTORM_ISCSI_LOCAL_VLAN_OFFSET(pfId) \
+	(IRO[313].base + ((pfId) * IRO[313].m1))
 #define XSTORM_ISCSI_NUM_OF_TASKS_OFFSET(pfId) \
-	(IRO[302].base + ((pfId) * IRO[302].m1))
+	(IRO[303].base + ((pfId) * IRO[303].m1))
 #define XSTORM_ISCSI_PAGE_SIZE_LOG_OFFSET(pfId) \
-	(IRO[301].base + ((pfId) * IRO[301].m1))
+	(IRO[302].base + ((pfId) * IRO[302].m1))
 #define XSTORM_ISCSI_PAGE_SIZE_OFFSET(pfId) \
-	(IRO[300].base + ((pfId) * IRO[300].m1))
+	(IRO[301].base + ((pfId) * IRO[301].m1))
+
 #define XSTORM_ISCSI_R2TQ_SIZE_OFFSET(pfId) \
-	(IRO[305].base + ((pfId) * IRO[305].m1))
+	(IRO[306].base + ((pfId) * IRO[306].m1))
 #define XSTORM_ISCSI_SQ_SIZE_OFFSET(pfId) \
-	(IRO[304].base + ((pfId) * IRO[304].m1))
+	(IRO[305].base + ((pfId) * IRO[305].m1))
+
 #define XSTORM_ISCSI_TCP_VARS_ADV_WND_SCL_OFFSET(pfId) \
-	(IRO[299].base + ((pfId) * IRO[299].m1))
+	(IRO[300].base + ((pfId) * IRO[300].m1))
 #define XSTORM_ISCSI_TCP_VARS_FLAGS_OFFSET(pfId) \
-	(IRO[298].base + ((pfId) * IRO[298].m1))
+	(IRO[299].base + ((pfId) * IRO[299].m1))
 #define XSTORM_ISCSI_TCP_VARS_TOS_OFFSET(pfId) \
-	(IRO[297].base + ((pfId) * IRO[297].m1))
+	(IRO[298].base + ((pfId) * IRO[298].m1))
 #define XSTORM_ISCSI_TCP_VARS_TTL_OFFSET(pfId) \
-	(IRO[296].base + ((pfId) * IRO[296].m1))
+	(IRO[297].base + ((pfId) * IRO[297].m1))
+
 #define XSTORM_RATE_SHAPING_PER_VN_VARS_OFFSET(pfId) \
 	(IRO[44].base + ((pfId) * IRO[44].m1))
 #define XSTORM_RECORD_SLOW_PATH_OFFSET(funcId) \
@@ -233,12 +243,12 @@
 #define XSTORM_SPQ_PROD_OFFSET(funcId) \
 	(IRO[31].base + ((funcId) * IRO[31].m1))
 #define XSTORM_TCP_GLOBAL_DEL_ACK_COUNTER_ENABLED_OFFSET(portId) \
-	(IRO[218].base + ((portId) * IRO[218].m1))
-#define XSTORM_TCP_GLOBAL_DEL_ACK_COUNTER_MAX_COUNT_OFFSET(portId) \
 	(IRO[219].base + ((portId) * IRO[219].m1))
+#define XSTORM_TCP_GLOBAL_DEL_ACK_COUNTER_MAX_COUNT_OFFSET(portId) \
+	(IRO[220].base + ((portId) * IRO[220].m1))
 #define XSTORM_TCP_TX_SWS_TIMER_VAL_OFFSET(pfId) \
-	(IRO[221].base + (((pfId)>>1) * IRO[221].m1) + (((pfId)&1) * \
-	IRO[221].m2))
+	(IRO[222].base + (((pfId) >> 1) * IRO[222].m1) + (((pfId) & 1) * \
+	IRO[222].m2))
 #define XSTORM_VF_TO_PF_OFFSET(funcId) \
 	(IRO[48].base + ((funcId) * IRO[48].m1))
 #define COMMON_ASM_INVALID_ASSERT_OPCODE 0x0
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
index 622fadc50316..bcc3fefca7ab 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
@@ -2393,6 +2393,17 @@ struct shmem2_region {
 
 	/* mini dump driver info */
 	struct mdump_driver_info drv_info;			/* 0x218 */
+
+	/* written by mfw, read by driver, eg. feature capability support */
+	u32 mfw_flags;						/* 0x22c */
+	#define DISABLE_EMBEDDED_LLDP_SUPPORT	0x00000001
+	/* DEBUG DATA (EDDC) is enabled */
+	#define DEBUG_DATA_SUPPORT		0x00000002
+
+	/* Internal mask similar to the drv_status in the drv_mb
+	 * which used by MFW to sync message
+	 */
+	u32 drv_status_do_not_ack[E2_FUNC_MAX];			/* 0x230 */
 };
 
 
@@ -3024,7 +3035,7 @@ struct afex_stats {
 
 #define BCM_5710_FW_MAJOR_VERSION			7
 #define BCM_5710_FW_MINOR_VERSION			13
-#define BCM_5710_FW_REVISION_VERSION		15
+#define BCM_5710_FW_REVISION_VERSION		20
 #define BCM_5710_FW_ENGINEERING_VERSION		0
 #define BCM_5710_FW_COMPILE_FLAGS			1
 
-- 
2.27.0

