Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325D148546F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240809AbiAEOZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:50 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34879 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240698AbiAEOZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:21 -0500
Received: from kwepemi100009.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JTWvx5CgWzccMP;
        Wed,  5 Jan 2022 22:24:45 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100009.china.huawei.com (7.221.188.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:19 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:19 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 15/15] net: hns3: create new common cmd code for PF and VF modules
Date:   Wed, 5 Jan 2022 22:20:15 +0800
Message-ID: <20220105142015.51097-16-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220105142015.51097-1-huangguangbin2@huawei.com>
References: <20220105142015.51097-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently PF and VF use two sets of command code for modules to interact
with firmware. These codes values are same espect the macro names. It is
redundent to keep two sets of command code for same functions between PF
and VF.

So this patch firstly creates a unified command code for PF and VF module.
We keep the macro name same with the PF command code name to avoid too many
meaningless modifications. Secondly the new common command codes are used
to replace the old ones in VF and deletes the old ones.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hns3/hns3_common/hclge_comm_cmd.c         |  29 +-
 .../hns3/hns3_common/hclge_comm_cmd.h         | 277 ++++++++++++++++--
 .../hns3/hns3_common/hclge_comm_rss.c         |  11 +-
 .../hns3/hns3_common/hclge_comm_tqp_stats.c   |   6 +-
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         | 246 +---------------
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       |  27 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  12 +-
 7 files changed, 279 insertions(+), 329 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index d3e16e5764a0..c15ca710dabb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -61,7 +61,7 @@ static void hclge_comm_set_default_capability(struct hnae3_ae_dev *ae_dev,
 }
 
 void hclge_comm_cmd_setup_basic_desc(struct hclge_desc *desc,
-				     enum hclge_comm_opcode_type opcode,
+				     enum hclge_opcode_type opcode,
 				     bool is_read)
 {
 	memset((void *)desc, 0, sizeof(struct hclge_desc));
@@ -80,8 +80,7 @@ int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev,
 	struct hclge_desc desc;
 	u32 compat = 0;
 
-	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_COMM_OPC_IMP_COMPAT_CFG,
-					false);
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_IMP_COMPAT_CFG, false);
 
 	if (en) {
 		req = (struct hclge_comm_firmware_compat_cmd *)desc.data;
@@ -205,7 +204,7 @@ int hclge_comm_cmd_query_version_and_capability(struct hnae3_ae_dev *ae_dev,
 	struct hclge_desc desc;
 	int ret;
 
-	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_COMM_OPC_QUERY_FW_VER, 1);
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_FW_VER, 1);
 	resp = (struct hclge_comm_query_version_cmd *)desc.data;
 	resp->api_caps = hclge_comm_build_api_caps();
 
@@ -227,17 +226,17 @@ int hclge_comm_cmd_query_version_and_capability(struct hnae3_ae_dev *ae_dev,
 	return ret;
 }
 
-static const u16 spec_opcode[] = { HCLGE_COMM_OPC_STATS_64_BIT,
-				   HCLGE_COMM_OPC_STATS_32_BIT,
-				   HCLGE_COMM_OPC_STATS_MAC,
-				   HCLGE_COMM_OPC_STATS_MAC_ALL,
-				   HCLGE_COMM_OPC_QUERY_32_BIT_REG,
-				   HCLGE_COMM_OPC_QUERY_64_BIT_REG,
-				   HCLGE_COMM_QUERY_CLEAR_MPF_RAS_INT,
-				   HCLGE_COMM_QUERY_CLEAR_PF_RAS_INT,
-				   HCLGE_COMM_QUERY_CLEAR_ALL_MPF_MSIX_INT,
-				   HCLGE_COMM_QUERY_CLEAR_ALL_PF_MSIX_INT,
-				   HCLGE_COMM_QUERY_ALL_ERR_INFO };
+static const u16 spec_opcode[] = { HCLGE_OPC_STATS_64_BIT,
+				   HCLGE_OPC_STATS_32_BIT,
+				   HCLGE_OPC_STATS_MAC,
+				   HCLGE_OPC_STATS_MAC_ALL,
+				   HCLGE_OPC_QUERY_32_BIT_REG,
+				   HCLGE_OPC_QUERY_64_BIT_REG,
+				   HCLGE_QUERY_CLEAR_MPF_RAS_INT,
+				   HCLGE_QUERY_CLEAR_PF_RAS_INT,
+				   HCLGE_QUERY_CLEAR_ALL_MPF_MSIX_INT,
+				   HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT,
+				   HCLGE_QUERY_ALL_ERR_INFO };
 
 static bool hclge_comm_is_special_opcode(u16 opcode)
 {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index 72976eed930a..876650eddac4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -55,6 +55,256 @@
 #define HCLGE_COMM_NIC_CMQ_DESC_NUM		1024
 #define HCLGE_COMM_CMDQ_TX_TIMEOUT		30000
 
+enum hclge_opcode_type {
+	/* Generic commands */
+	HCLGE_OPC_QUERY_FW_VER		= 0x0001,
+	HCLGE_OPC_CFG_RST_TRIGGER	= 0x0020,
+	HCLGE_OPC_GBL_RST_STATUS	= 0x0021,
+	HCLGE_OPC_QUERY_FUNC_STATUS	= 0x0022,
+	HCLGE_OPC_QUERY_PF_RSRC		= 0x0023,
+	HCLGE_OPC_QUERY_VF_RSRC		= 0x0024,
+	HCLGE_OPC_GET_CFG_PARAM		= 0x0025,
+	HCLGE_OPC_PF_RST_DONE		= 0x0026,
+	HCLGE_OPC_QUERY_VF_RST_RDY	= 0x0027,
+
+	HCLGE_OPC_STATS_64_BIT		= 0x0030,
+	HCLGE_OPC_STATS_32_BIT		= 0x0031,
+	HCLGE_OPC_STATS_MAC		= 0x0032,
+	HCLGE_OPC_QUERY_MAC_REG_NUM	= 0x0033,
+	HCLGE_OPC_STATS_MAC_ALL		= 0x0034,
+
+	HCLGE_OPC_QUERY_REG_NUM		= 0x0040,
+	HCLGE_OPC_QUERY_32_BIT_REG	= 0x0041,
+	HCLGE_OPC_QUERY_64_BIT_REG	= 0x0042,
+	HCLGE_OPC_DFX_BD_NUM		= 0x0043,
+	HCLGE_OPC_DFX_BIOS_COMMON_REG	= 0x0044,
+	HCLGE_OPC_DFX_SSU_REG_0		= 0x0045,
+	HCLGE_OPC_DFX_SSU_REG_1		= 0x0046,
+	HCLGE_OPC_DFX_IGU_EGU_REG	= 0x0047,
+	HCLGE_OPC_DFX_RPU_REG_0		= 0x0048,
+	HCLGE_OPC_DFX_RPU_REG_1		= 0x0049,
+	HCLGE_OPC_DFX_NCSI_REG		= 0x004A,
+	HCLGE_OPC_DFX_RTC_REG		= 0x004B,
+	HCLGE_OPC_DFX_PPP_REG		= 0x004C,
+	HCLGE_OPC_DFX_RCB_REG		= 0x004D,
+	HCLGE_OPC_DFX_TQP_REG		= 0x004E,
+	HCLGE_OPC_DFX_SSU_REG_2		= 0x004F,
+
+	HCLGE_OPC_QUERY_DEV_SPECS	= 0x0050,
+
+	/* MAC command */
+	HCLGE_OPC_CONFIG_MAC_MODE	= 0x0301,
+	HCLGE_OPC_CONFIG_AN_MODE	= 0x0304,
+	HCLGE_OPC_QUERY_LINK_STATUS	= 0x0307,
+	HCLGE_OPC_CONFIG_MAX_FRM_SIZE	= 0x0308,
+	HCLGE_OPC_CONFIG_SPEED_DUP	= 0x0309,
+	HCLGE_OPC_QUERY_MAC_TNL_INT	= 0x0310,
+	HCLGE_OPC_MAC_TNL_INT_EN	= 0x0311,
+	HCLGE_OPC_CLEAR_MAC_TNL_INT	= 0x0312,
+	HCLGE_OPC_COMMON_LOOPBACK       = 0x0315,
+	HCLGE_OPC_CONFIG_FEC_MODE	= 0x031A,
+	HCLGE_OPC_QUERY_ROH_TYPE_INFO	= 0x0389,
+
+	/* PTP commands */
+	HCLGE_OPC_PTP_INT_EN		= 0x0501,
+	HCLGE_OPC_PTP_MODE_CFG		= 0x0507,
+
+	/* PFC/Pause commands */
+	HCLGE_OPC_CFG_MAC_PAUSE_EN      = 0x0701,
+	HCLGE_OPC_CFG_PFC_PAUSE_EN      = 0x0702,
+	HCLGE_OPC_CFG_MAC_PARA          = 0x0703,
+	HCLGE_OPC_CFG_PFC_PARA          = 0x0704,
+	HCLGE_OPC_QUERY_MAC_TX_PKT_CNT  = 0x0705,
+	HCLGE_OPC_QUERY_MAC_RX_PKT_CNT  = 0x0706,
+	HCLGE_OPC_QUERY_PFC_TX_PKT_CNT  = 0x0707,
+	HCLGE_OPC_QUERY_PFC_RX_PKT_CNT  = 0x0708,
+	HCLGE_OPC_PRI_TO_TC_MAPPING     = 0x0709,
+	HCLGE_OPC_QOS_MAP               = 0x070A,
+
+	/* ETS/scheduler commands */
+	HCLGE_OPC_TM_PG_TO_PRI_LINK	= 0x0804,
+	HCLGE_OPC_TM_QS_TO_PRI_LINK     = 0x0805,
+	HCLGE_OPC_TM_NQ_TO_QS_LINK      = 0x0806,
+	HCLGE_OPC_TM_RQ_TO_QS_LINK      = 0x0807,
+	HCLGE_OPC_TM_PORT_WEIGHT        = 0x0808,
+	HCLGE_OPC_TM_PG_WEIGHT          = 0x0809,
+	HCLGE_OPC_TM_QS_WEIGHT          = 0x080A,
+	HCLGE_OPC_TM_PRI_WEIGHT         = 0x080B,
+	HCLGE_OPC_TM_PRI_C_SHAPPING     = 0x080C,
+	HCLGE_OPC_TM_PRI_P_SHAPPING     = 0x080D,
+	HCLGE_OPC_TM_PG_C_SHAPPING      = 0x080E,
+	HCLGE_OPC_TM_PG_P_SHAPPING      = 0x080F,
+	HCLGE_OPC_TM_PORT_SHAPPING      = 0x0810,
+	HCLGE_OPC_TM_PG_SCH_MODE_CFG    = 0x0812,
+	HCLGE_OPC_TM_PRI_SCH_MODE_CFG   = 0x0813,
+	HCLGE_OPC_TM_QS_SCH_MODE_CFG    = 0x0814,
+	HCLGE_OPC_TM_BP_TO_QSET_MAPPING = 0x0815,
+	HCLGE_OPC_TM_NODES		= 0x0816,
+	HCLGE_OPC_ETS_TC_WEIGHT		= 0x0843,
+	HCLGE_OPC_QSET_DFX_STS		= 0x0844,
+	HCLGE_OPC_PRI_DFX_STS		= 0x0845,
+	HCLGE_OPC_PG_DFX_STS		= 0x0846,
+	HCLGE_OPC_PORT_DFX_STS		= 0x0847,
+	HCLGE_OPC_SCH_NQ_CNT		= 0x0848,
+	HCLGE_OPC_SCH_RQ_CNT		= 0x0849,
+	HCLGE_OPC_TM_INTERNAL_STS	= 0x0850,
+	HCLGE_OPC_TM_INTERNAL_CNT	= 0x0851,
+	HCLGE_OPC_TM_INTERNAL_STS_1	= 0x0852,
+
+	/* Packet buffer allocate commands */
+	HCLGE_OPC_TX_BUFF_ALLOC		= 0x0901,
+	HCLGE_OPC_RX_PRIV_BUFF_ALLOC	= 0x0902,
+	HCLGE_OPC_RX_PRIV_WL_ALLOC	= 0x0903,
+	HCLGE_OPC_RX_COM_THRD_ALLOC	= 0x0904,
+	HCLGE_OPC_RX_COM_WL_ALLOC	= 0x0905,
+	HCLGE_OPC_RX_GBL_PKT_CNT	= 0x0906,
+
+	/* TQP management command */
+	HCLGE_OPC_SET_TQP_MAP		= 0x0A01,
+
+	/* TQP commands */
+	HCLGE_OPC_CFG_TX_QUEUE		= 0x0B01,
+	HCLGE_OPC_QUERY_TX_POINTER	= 0x0B02,
+	HCLGE_OPC_QUERY_TX_STATS	= 0x0B03,
+	HCLGE_OPC_TQP_TX_QUEUE_TC	= 0x0B04,
+	HCLGE_OPC_CFG_RX_QUEUE		= 0x0B11,
+	HCLGE_OPC_QUERY_RX_POINTER	= 0x0B12,
+	HCLGE_OPC_QUERY_RX_STATS	= 0x0B13,
+	HCLGE_OPC_STASH_RX_QUEUE_LRO	= 0x0B16,
+	HCLGE_OPC_CFG_RX_QUEUE_LRO	= 0x0B17,
+	HCLGE_OPC_CFG_COM_TQP_QUEUE	= 0x0B20,
+	HCLGE_OPC_RESET_TQP_QUEUE	= 0x0B22,
+
+	/* PPU commands */
+	HCLGE_OPC_PPU_PF_OTHER_INT_DFX	= 0x0B4A,
+
+	/* TSO command */
+	HCLGE_OPC_TSO_GENERIC_CONFIG	= 0x0C01,
+	HCLGE_OPC_GRO_GENERIC_CONFIG    = 0x0C10,
+
+	/* RSS commands */
+	HCLGE_OPC_RSS_GENERIC_CONFIG	= 0x0D01,
+	HCLGE_OPC_RSS_INDIR_TABLE	= 0x0D07,
+	HCLGE_OPC_RSS_TC_MODE		= 0x0D08,
+	HCLGE_OPC_RSS_INPUT_TUPLE	= 0x0D02,
+
+	/* Promisuous mode command */
+	HCLGE_OPC_CFG_PROMISC_MODE	= 0x0E01,
+
+	/* Vlan offload commands */
+	HCLGE_OPC_VLAN_PORT_TX_CFG	= 0x0F01,
+	HCLGE_OPC_VLAN_PORT_RX_CFG	= 0x0F02,
+
+	/* Interrupts commands */
+	HCLGE_OPC_ADD_RING_TO_VECTOR	= 0x1503,
+	HCLGE_OPC_DEL_RING_TO_VECTOR	= 0x1504,
+
+	/* MAC commands */
+	HCLGE_OPC_MAC_VLAN_ADD		    = 0x1000,
+	HCLGE_OPC_MAC_VLAN_REMOVE	    = 0x1001,
+	HCLGE_OPC_MAC_VLAN_TYPE_ID	    = 0x1002,
+	HCLGE_OPC_MAC_VLAN_INSERT	    = 0x1003,
+	HCLGE_OPC_MAC_VLAN_ALLOCATE	    = 0x1004,
+	HCLGE_OPC_MAC_ETHTYPE_ADD	    = 0x1010,
+	HCLGE_OPC_MAC_ETHTYPE_REMOVE	= 0x1011,
+
+	/* MAC VLAN commands */
+	HCLGE_OPC_MAC_VLAN_SWITCH_PARAM	= 0x1033,
+
+	/* VLAN commands */
+	HCLGE_OPC_VLAN_FILTER_CTRL	    = 0x1100,
+	HCLGE_OPC_VLAN_FILTER_PF_CFG	= 0x1101,
+	HCLGE_OPC_VLAN_FILTER_VF_CFG	= 0x1102,
+	HCLGE_OPC_PORT_VLAN_BYPASS	= 0x1103,
+
+	/* Flow Director commands */
+	HCLGE_OPC_FD_MODE_CTRL		= 0x1200,
+	HCLGE_OPC_FD_GET_ALLOCATION	= 0x1201,
+	HCLGE_OPC_FD_KEY_CONFIG		= 0x1202,
+	HCLGE_OPC_FD_TCAM_OP		= 0x1203,
+	HCLGE_OPC_FD_AD_OP		= 0x1204,
+	HCLGE_OPC_FD_CNT_OP		= 0x1205,
+	HCLGE_OPC_FD_USER_DEF_OP	= 0x1207,
+	HCLGE_OPC_FD_QB_CTRL		= 0x1210,
+	HCLGE_OPC_FD_QB_AD_OP		= 0x1211,
+
+	/* MDIO command */
+	HCLGE_OPC_MDIO_CONFIG		= 0x1900,
+
+	/* QCN commands */
+	HCLGE_OPC_QCN_MOD_CFG		= 0x1A01,
+	HCLGE_OPC_QCN_GRP_TMPLT_CFG	= 0x1A02,
+	HCLGE_OPC_QCN_SHAPPING_CFG	= 0x1A03,
+	HCLGE_OPC_QCN_SHAPPING_BS_CFG	= 0x1A04,
+	HCLGE_OPC_QCN_QSET_LINK_CFG	= 0x1A05,
+	HCLGE_OPC_QCN_RP_STATUS_GET	= 0x1A06,
+	HCLGE_OPC_QCN_AJUST_INIT	= 0x1A07,
+	HCLGE_OPC_QCN_DFX_CNT_STATUS    = 0x1A08,
+
+	/* Mailbox command */
+	HCLGEVF_OPC_MBX_PF_TO_VF	= 0x2000,
+	HCLGEVF_OPC_MBX_VF_TO_PF	= 0x2001,
+
+	/* Led command */
+	HCLGE_OPC_LED_STATUS_CFG	= 0xB000,
+
+	/* clear hardware resource command */
+	HCLGE_OPC_CLEAR_HW_RESOURCE	= 0x700B,
+
+	/* NCL config command */
+	HCLGE_OPC_QUERY_NCL_CONFIG	= 0x7011,
+
+	/* IMP stats command */
+	HCLGE_OPC_IMP_STATS_BD		= 0x7012,
+	HCLGE_OPC_IMP_STATS_INFO		= 0x7013,
+	HCLGE_OPC_IMP_COMPAT_CFG		= 0x701A,
+
+	/* SFP command */
+	HCLGE_OPC_GET_SFP_EEPROM	= 0x7100,
+	HCLGE_OPC_GET_SFP_EXIST		= 0x7101,
+	HCLGE_OPC_GET_SFP_INFO		= 0x7104,
+
+	/* Error INT commands */
+	HCLGE_MAC_COMMON_INT_EN		= 0x030E,
+	HCLGE_TM_SCH_ECC_INT_EN		= 0x0829,
+	HCLGE_SSU_ECC_INT_CMD		= 0x0989,
+	HCLGE_SSU_COMMON_INT_CMD	= 0x098C,
+	HCLGE_PPU_MPF_ECC_INT_CMD	= 0x0B40,
+	HCLGE_PPU_MPF_OTHER_INT_CMD	= 0x0B41,
+	HCLGE_PPU_PF_OTHER_INT_CMD	= 0x0B42,
+	HCLGE_COMMON_ECC_INT_CFG	= 0x1505,
+	HCLGE_QUERY_RAS_INT_STS_BD_NUM	= 0x1510,
+	HCLGE_QUERY_CLEAR_MPF_RAS_INT	= 0x1511,
+	HCLGE_QUERY_CLEAR_PF_RAS_INT	= 0x1512,
+	HCLGE_QUERY_MSIX_INT_STS_BD_NUM	= 0x1513,
+	HCLGE_QUERY_CLEAR_ALL_MPF_MSIX_INT	= 0x1514,
+	HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT	= 0x1515,
+	HCLGE_QUERY_ALL_ERR_BD_NUM		= 0x1516,
+	HCLGE_QUERY_ALL_ERR_INFO		= 0x1517,
+	HCLGE_CONFIG_ROCEE_RAS_INT_EN	= 0x1580,
+	HCLGE_QUERY_CLEAR_ROCEE_RAS_INT = 0x1581,
+	HCLGE_ROCEE_PF_RAS_INT_CMD	= 0x1584,
+	HCLGE_QUERY_ROCEE_ECC_RAS_INFO_CMD	= 0x1585,
+	HCLGE_QUERY_ROCEE_AXI_RAS_INFO_CMD	= 0x1586,
+	HCLGE_IGU_EGU_TNL_INT_EN	= 0x1803,
+	HCLGE_IGU_COMMON_INT_EN		= 0x1806,
+	HCLGE_TM_QCN_MEM_INT_CFG	= 0x1A14,
+	HCLGE_PPP_CMD0_INT_CMD		= 0x2100,
+	HCLGE_PPP_CMD1_INT_CMD		= 0x2101,
+	HCLGE_MAC_ETHERTYPE_IDX_RD      = 0x2105,
+	HCLGE_NCSI_INT_EN		= 0x2401,
+
+	/* ROH MAC commands */
+	HCLGE_OPC_MAC_ADDR_CHECK	= 0x9004,
+
+	/* PHY command */
+	HCLGE_OPC_PHY_LINK_KSETTING	= 0x7025,
+	HCLGE_OPC_PHY_REG		= 0x7026,
+
+	/* Query link diagnosis info command */
+	HCLGE_OPC_QUERY_LINK_DIAGNOSIS	= 0x702A,
+};
+
 enum hclge_comm_cmd_return_status {
 	HCLGE_COMM_CMD_EXEC_SUCCESS	= 0,
 	HCLGE_COMM_CMD_NO_AUTH		= 1,
@@ -70,20 +320,6 @@ enum hclge_comm_cmd_return_status {
 	HCLGE_COMM_CMD_INVALID		= 11,
 };
 
-enum hclge_comm_special_cmd {
-	HCLGE_COMM_OPC_STATS_64_BIT		= 0x0030,
-	HCLGE_COMM_OPC_STATS_32_BIT		= 0x0031,
-	HCLGE_COMM_OPC_STATS_MAC		= 0x0032,
-	HCLGE_COMM_OPC_STATS_MAC_ALL		= 0x0034,
-	HCLGE_COMM_OPC_QUERY_32_BIT_REG		= 0x0041,
-	HCLGE_COMM_OPC_QUERY_64_BIT_REG		= 0x0042,
-	HCLGE_COMM_QUERY_CLEAR_MPF_RAS_INT	= 0x1511,
-	HCLGE_COMM_QUERY_CLEAR_PF_RAS_INT	= 0x1512,
-	HCLGE_COMM_QUERY_CLEAR_ALL_MPF_MSIX_INT	= 0x1514,
-	HCLGE_COMM_QUERY_CLEAR_ALL_PF_MSIX_INT	= 0x1515,
-	HCLGE_COMM_QUERY_ALL_ERR_INFO		= 0x1517,
-};
-
 enum HCLGE_COMM_CAP_BITS {
 	HCLGE_COMM_CAP_UDP_GSO_B,
 	HCLGE_COMM_CAP_QB_B,
@@ -108,17 +344,6 @@ enum HCLGE_COMM_API_CAP_BITS {
 	HCLGE_COMM_API_CAP_FLEX_RSS_TBL_B,
 };
 
-enum hclge_comm_opcode_type {
-	HCLGE_COMM_OPC_QUERY_FW_VER		= 0x0001,
-	HCLGE_COMM_OPC_QUERY_TX_STATUS		= 0x0B03,
-	HCLGE_COMM_OPC_QUERY_RX_STATUS		= 0x0B13,
-	HCLGE_COMM_OPC_RSS_GENERIC_CFG		= 0x0D01,
-	HCLGE_COMM_OPC_RSS_INPUT_TUPLE		= 0x0D02,
-	HCLGE_COMM_OPC_RSS_INDIR_TABLE		= 0x0D07,
-	HCLGE_COMM_OPC_RSS_TC_MODE		= 0x0D08,
-	HCLGE_COMM_OPC_IMP_COMPAT_CFG		= 0x701A,
-};
-
 /* capabilities bits map between imp firmware and local driver */
 struct hclge_comm_caps_bit_map {
 	u16 imp_bit;
@@ -221,7 +446,7 @@ int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev,
 				      struct hclge_comm_hw *hw, bool en);
 void hclge_comm_free_cmd_desc(struct hclge_comm_cmq_ring *ring);
 void hclge_comm_cmd_setup_basic_desc(struct hclge_desc *desc,
-				     enum hclge_comm_opcode_type opcode,
+				     enum hclge_opcode_type opcode,
 				     bool is_read);
 void hclge_comm_cmd_uninit(struct hnae3_ae_dev *ae_dev,
 			   struct hclge_comm_hw *hw);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
index 700d1f4dc090..e23729ac3bb8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
@@ -89,8 +89,7 @@ int hclge_comm_set_rss_tc_mode(struct hclge_comm_hw *hw, u16 *tc_offset,
 
 	req = (struct hclge_comm_rss_tc_mode_cmd *)desc.data;
 
-	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_COMM_OPC_RSS_TC_MODE,
-					false);
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_RSS_TC_MODE, false);
 	for (i = 0; i < HCLGE_COMM_MAX_TC_NUM; i++) {
 		u16 mode = 0;
 
@@ -159,7 +158,7 @@ int hclge_comm_set_rss_tuple(struct hnae3_ae_dev *ae_dev,
 		return -EINVAL;
 
 	req = (struct hclge_comm_rss_input_tuple_cmd *)desc.data;
-	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_COMM_OPC_RSS_INPUT_TUPLE,
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_RSS_INPUT_TUPLE,
 					false);
 
 	ret = hclge_comm_init_rss_tuple_cmd(rss_cfg, nfc, ae_dev, req);
@@ -300,7 +299,7 @@ int hclge_comm_set_rss_indir_table(struct hnae3_ae_dev *ae_dev,
 
 	for (i = 0; i < rss_cfg_tbl_num; i++) {
 		hclge_comm_cmd_setup_basic_desc(&desc,
-						HCLGE_COMM_OPC_RSS_INDIR_TABLE,
+						HCLGE_OPC_RSS_INDIR_TABLE,
 						false);
 
 		req->start_table_index =
@@ -331,7 +330,7 @@ int hclge_comm_set_rss_input_tuple(struct hnae3_handle *nic,
 	struct hclge_desc desc;
 	int ret;
 
-	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_COMM_OPC_RSS_INPUT_TUPLE,
+	hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_RSS_INPUT_TUPLE,
 					false);
 
 	req = (struct hclge_comm_rss_input_tuple_cmd *)desc.data;
@@ -405,7 +404,7 @@ int hclge_comm_set_rss_algo_key(struct hclge_comm_hw *hw, const u8 hfunc,
 
 	while (key_counts) {
 		hclge_comm_cmd_setup_basic_desc(&desc,
-						HCLGE_COMM_OPC_RSS_GENERIC_CFG,
+						HCLGE_OPC_RSS_GENERIC_CONFIG,
 						false);
 
 		req->hash_config |= (hfunc & HCLGE_COMM_RSS_HASH_ALGO_MASK);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
index 3a73cbb3eee1..0c60f41fca8a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
@@ -68,8 +68,7 @@ int hclge_comm_tqps_update_stats(struct hnae3_handle *handle,
 
 	for (i = 0; i < kinfo->num_tqps; i++) {
 		tqp = container_of(kinfo->tqp[i], struct hclge_comm_tqp, q);
-		hclge_comm_cmd_setup_basic_desc(&desc,
-						HCLGE_COMM_OPC_QUERY_RX_STATUS,
+		hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_RX_STATS,
 						true);
 
 		desc.data[0] = cpu_to_le32(tqp->index);
@@ -83,8 +82,7 @@ int hclge_comm_tqps_update_stats(struct hnae3_handle *handle,
 		tqp->tqp_stats.rcb_rx_ring_pktnum_rcd +=
 			le32_to_cpu(desc.data[1]);
 
-		hclge_comm_cmd_setup_basic_desc(&desc,
-						HCLGE_COMM_OPC_QUERY_TX_STATUS,
+		hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_TX_STATS,
 						true);
 
 		desc.data[0] = cpu_to_le32(tqp->index & 0x1ff);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index a28d45e8f986..f9d89511eb32 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -20,252 +20,8 @@ struct hclge_misc_vector {
 	char name[HNAE3_INT_NAME_LEN];
 };
 
-enum hclge_opcode_type {
-	/* Generic commands */
-	HCLGE_OPC_QUERY_FW_VER		= 0x0001,
-	HCLGE_OPC_CFG_RST_TRIGGER	= 0x0020,
-	HCLGE_OPC_GBL_RST_STATUS	= 0x0021,
-	HCLGE_OPC_QUERY_FUNC_STATUS	= 0x0022,
-	HCLGE_OPC_QUERY_PF_RSRC		= 0x0023,
-	HCLGE_OPC_QUERY_VF_RSRC		= 0x0024,
-	HCLGE_OPC_GET_CFG_PARAM		= 0x0025,
-	HCLGE_OPC_PF_RST_DONE		= 0x0026,
-	HCLGE_OPC_QUERY_VF_RST_RDY	= 0x0027,
-
-	HCLGE_OPC_STATS_64_BIT		= 0x0030,
-	HCLGE_OPC_STATS_32_BIT		= 0x0031,
-	HCLGE_OPC_STATS_MAC		= 0x0032,
-	HCLGE_OPC_QUERY_MAC_REG_NUM	= 0x0033,
-	HCLGE_OPC_STATS_MAC_ALL		= 0x0034,
-
-	HCLGE_OPC_QUERY_REG_NUM		= 0x0040,
-	HCLGE_OPC_QUERY_32_BIT_REG	= 0x0041,
-	HCLGE_OPC_QUERY_64_BIT_REG	= 0x0042,
-	HCLGE_OPC_DFX_BD_NUM		= 0x0043,
-	HCLGE_OPC_DFX_BIOS_COMMON_REG	= 0x0044,
-	HCLGE_OPC_DFX_SSU_REG_0		= 0x0045,
-	HCLGE_OPC_DFX_SSU_REG_1		= 0x0046,
-	HCLGE_OPC_DFX_IGU_EGU_REG	= 0x0047,
-	HCLGE_OPC_DFX_RPU_REG_0		= 0x0048,
-	HCLGE_OPC_DFX_RPU_REG_1		= 0x0049,
-	HCLGE_OPC_DFX_NCSI_REG		= 0x004A,
-	HCLGE_OPC_DFX_RTC_REG		= 0x004B,
-	HCLGE_OPC_DFX_PPP_REG		= 0x004C,
-	HCLGE_OPC_DFX_RCB_REG		= 0x004D,
-	HCLGE_OPC_DFX_TQP_REG		= 0x004E,
-	HCLGE_OPC_DFX_SSU_REG_2		= 0x004F,
-
-	HCLGE_OPC_QUERY_DEV_SPECS	= 0x0050,
-
-	/* MAC command */
-	HCLGE_OPC_CONFIG_MAC_MODE	= 0x0301,
-	HCLGE_OPC_CONFIG_AN_MODE	= 0x0304,
-	HCLGE_OPC_QUERY_LINK_STATUS	= 0x0307,
-	HCLGE_OPC_CONFIG_MAX_FRM_SIZE	= 0x0308,
-	HCLGE_OPC_CONFIG_SPEED_DUP	= 0x0309,
-	HCLGE_OPC_QUERY_MAC_TNL_INT	= 0x0310,
-	HCLGE_OPC_MAC_TNL_INT_EN	= 0x0311,
-	HCLGE_OPC_CLEAR_MAC_TNL_INT	= 0x0312,
-	HCLGE_OPC_COMMON_LOOPBACK       = 0x0315,
-	HCLGE_OPC_CONFIG_FEC_MODE	= 0x031A,
-
-	/* PTP commands */
-	HCLGE_OPC_PTP_INT_EN		= 0x0501,
-	HCLGE_OPC_PTP_MODE_CFG		= 0x0507,
-
-	/* PFC/Pause commands */
-	HCLGE_OPC_CFG_MAC_PAUSE_EN      = 0x0701,
-	HCLGE_OPC_CFG_PFC_PAUSE_EN      = 0x0702,
-	HCLGE_OPC_CFG_MAC_PARA          = 0x0703,
-	HCLGE_OPC_CFG_PFC_PARA          = 0x0704,
-	HCLGE_OPC_QUERY_MAC_TX_PKT_CNT  = 0x0705,
-	HCLGE_OPC_QUERY_MAC_RX_PKT_CNT  = 0x0706,
-	HCLGE_OPC_QUERY_PFC_TX_PKT_CNT  = 0x0707,
-	HCLGE_OPC_QUERY_PFC_RX_PKT_CNT  = 0x0708,
-	HCLGE_OPC_PRI_TO_TC_MAPPING     = 0x0709,
-	HCLGE_OPC_QOS_MAP               = 0x070A,
-
-	/* ETS/scheduler commands */
-	HCLGE_OPC_TM_PG_TO_PRI_LINK	= 0x0804,
-	HCLGE_OPC_TM_QS_TO_PRI_LINK     = 0x0805,
-	HCLGE_OPC_TM_NQ_TO_QS_LINK      = 0x0806,
-	HCLGE_OPC_TM_RQ_TO_QS_LINK      = 0x0807,
-	HCLGE_OPC_TM_PORT_WEIGHT        = 0x0808,
-	HCLGE_OPC_TM_PG_WEIGHT          = 0x0809,
-	HCLGE_OPC_TM_QS_WEIGHT          = 0x080A,
-	HCLGE_OPC_TM_PRI_WEIGHT         = 0x080B,
-	HCLGE_OPC_TM_PRI_C_SHAPPING     = 0x080C,
-	HCLGE_OPC_TM_PRI_P_SHAPPING     = 0x080D,
-	HCLGE_OPC_TM_PG_C_SHAPPING      = 0x080E,
-	HCLGE_OPC_TM_PG_P_SHAPPING      = 0x080F,
-	HCLGE_OPC_TM_PORT_SHAPPING      = 0x0810,
-	HCLGE_OPC_TM_PG_SCH_MODE_CFG    = 0x0812,
-	HCLGE_OPC_TM_PRI_SCH_MODE_CFG   = 0x0813,
-	HCLGE_OPC_TM_QS_SCH_MODE_CFG    = 0x0814,
-	HCLGE_OPC_TM_BP_TO_QSET_MAPPING = 0x0815,
-	HCLGE_OPC_TM_NODES		= 0x0816,
-	HCLGE_OPC_ETS_TC_WEIGHT		= 0x0843,
-	HCLGE_OPC_QSET_DFX_STS		= 0x0844,
-	HCLGE_OPC_PRI_DFX_STS		= 0x0845,
-	HCLGE_OPC_PG_DFX_STS		= 0x0846,
-	HCLGE_OPC_PORT_DFX_STS		= 0x0847,
-	HCLGE_OPC_SCH_NQ_CNT		= 0x0848,
-	HCLGE_OPC_SCH_RQ_CNT		= 0x0849,
-	HCLGE_OPC_TM_INTERNAL_STS	= 0x0850,
-	HCLGE_OPC_TM_INTERNAL_CNT	= 0x0851,
-	HCLGE_OPC_TM_INTERNAL_STS_1	= 0x0852,
-
-	/* Packet buffer allocate commands */
-	HCLGE_OPC_TX_BUFF_ALLOC		= 0x0901,
-	HCLGE_OPC_RX_PRIV_BUFF_ALLOC	= 0x0902,
-	HCLGE_OPC_RX_PRIV_WL_ALLOC	= 0x0903,
-	HCLGE_OPC_RX_COM_THRD_ALLOC	= 0x0904,
-	HCLGE_OPC_RX_COM_WL_ALLOC	= 0x0905,
-	HCLGE_OPC_RX_GBL_PKT_CNT	= 0x0906,
-
-	/* TQP management command */
-	HCLGE_OPC_SET_TQP_MAP		= 0x0A01,
-
-	/* TQP commands */
-	HCLGE_OPC_CFG_TX_QUEUE		= 0x0B01,
-	HCLGE_OPC_QUERY_TX_POINTER	= 0x0B02,
-	HCLGE_OPC_QUERY_TX_STATS	= 0x0B03,
-	HCLGE_OPC_TQP_TX_QUEUE_TC	= 0x0B04,
-	HCLGE_OPC_CFG_RX_QUEUE		= 0x0B11,
-	HCLGE_OPC_QUERY_RX_POINTER	= 0x0B12,
-	HCLGE_OPC_QUERY_RX_STATS	= 0x0B13,
-	HCLGE_OPC_STASH_RX_QUEUE_LRO	= 0x0B16,
-	HCLGE_OPC_CFG_RX_QUEUE_LRO	= 0x0B17,
-	HCLGE_OPC_CFG_COM_TQP_QUEUE	= 0x0B20,
-	HCLGE_OPC_RESET_TQP_QUEUE	= 0x0B22,
-
-	/* PPU commands */
-	HCLGE_OPC_PPU_PF_OTHER_INT_DFX	= 0x0B4A,
-
-	/* TSO command */
-	HCLGE_OPC_TSO_GENERIC_CONFIG	= 0x0C01,
-	HCLGE_OPC_GRO_GENERIC_CONFIG    = 0x0C10,
-
-	/* RSS commands */
-	HCLGE_OPC_RSS_GENERIC_CONFIG	= 0x0D01,
-	HCLGE_OPC_RSS_INDIR_TABLE	= 0x0D07,
-	HCLGE_OPC_RSS_TC_MODE		= 0x0D08,
-	HCLGE_OPC_RSS_INPUT_TUPLE	= 0x0D02,
-
-	/* Promisuous mode command */
-	HCLGE_OPC_CFG_PROMISC_MODE	= 0x0E01,
-
-	/* Vlan offload commands */
-	HCLGE_OPC_VLAN_PORT_TX_CFG	= 0x0F01,
-	HCLGE_OPC_VLAN_PORT_RX_CFG	= 0x0F02,
-
-	/* Interrupts commands */
-	HCLGE_OPC_ADD_RING_TO_VECTOR	= 0x1503,
-	HCLGE_OPC_DEL_RING_TO_VECTOR	= 0x1504,
-
-	/* MAC commands */
-	HCLGE_OPC_MAC_VLAN_ADD		    = 0x1000,
-	HCLGE_OPC_MAC_VLAN_REMOVE	    = 0x1001,
-	HCLGE_OPC_MAC_VLAN_TYPE_ID	    = 0x1002,
-	HCLGE_OPC_MAC_VLAN_INSERT	    = 0x1003,
-	HCLGE_OPC_MAC_VLAN_ALLOCATE	    = 0x1004,
-	HCLGE_OPC_MAC_ETHTYPE_ADD	    = 0x1010,
-	HCLGE_OPC_MAC_ETHTYPE_REMOVE	= 0x1011,
-
-	/* MAC VLAN commands */
-	HCLGE_OPC_MAC_VLAN_SWITCH_PARAM	= 0x1033,
-
-	/* VLAN commands */
-	HCLGE_OPC_VLAN_FILTER_CTRL	    = 0x1100,
-	HCLGE_OPC_VLAN_FILTER_PF_CFG	= 0x1101,
-	HCLGE_OPC_VLAN_FILTER_VF_CFG	= 0x1102,
-	HCLGE_OPC_PORT_VLAN_BYPASS	= 0x1103,
-
-	/* Flow Director commands */
-	HCLGE_OPC_FD_MODE_CTRL		= 0x1200,
-	HCLGE_OPC_FD_GET_ALLOCATION	= 0x1201,
-	HCLGE_OPC_FD_KEY_CONFIG		= 0x1202,
-	HCLGE_OPC_FD_TCAM_OP		= 0x1203,
-	HCLGE_OPC_FD_AD_OP		= 0x1204,
-	HCLGE_OPC_FD_CNT_OP		= 0x1205,
-	HCLGE_OPC_FD_USER_DEF_OP	= 0x1207,
-
-	/* MDIO command */
-	HCLGE_OPC_MDIO_CONFIG		= 0x1900,
-
-	/* QCN commands */
-	HCLGE_OPC_QCN_MOD_CFG		= 0x1A01,
-	HCLGE_OPC_QCN_GRP_TMPLT_CFG	= 0x1A02,
-	HCLGE_OPC_QCN_SHAPPING_CFG	= 0x1A03,
-	HCLGE_OPC_QCN_SHAPPING_BS_CFG	= 0x1A04,
-	HCLGE_OPC_QCN_QSET_LINK_CFG	= 0x1A05,
-	HCLGE_OPC_QCN_RP_STATUS_GET	= 0x1A06,
-	HCLGE_OPC_QCN_AJUST_INIT	= 0x1A07,
-	HCLGE_OPC_QCN_DFX_CNT_STATUS    = 0x1A08,
-
-	/* Mailbox command */
-	HCLGEVF_OPC_MBX_PF_TO_VF	= 0x2000,
-
-	/* Led command */
-	HCLGE_OPC_LED_STATUS_CFG	= 0xB000,
-
-	/* clear hardware resource command */
-	HCLGE_OPC_CLEAR_HW_RESOURCE	= 0x700B,
-
-	/* NCL config command */
-	HCLGE_OPC_QUERY_NCL_CONFIG	= 0x7011,
-
-	/* IMP stats command */
-	HCLGE_OPC_IMP_STATS_BD		= 0x7012,
-	HCLGE_OPC_IMP_STATS_INFO		= 0x7013,
-	HCLGE_OPC_IMP_COMPAT_CFG		= 0x701A,
-
-	/* SFP command */
-	HCLGE_OPC_GET_SFP_EEPROM	= 0x7100,
-	HCLGE_OPC_GET_SFP_EXIST		= 0x7101,
-	HCLGE_OPC_GET_SFP_INFO		= 0x7104,
-
-	/* Error INT commands */
-	HCLGE_MAC_COMMON_INT_EN		= 0x030E,
-	HCLGE_TM_SCH_ECC_INT_EN		= 0x0829,
-	HCLGE_SSU_ECC_INT_CMD		= 0x0989,
-	HCLGE_SSU_COMMON_INT_CMD	= 0x098C,
-	HCLGE_PPU_MPF_ECC_INT_CMD	= 0x0B40,
-	HCLGE_PPU_MPF_OTHER_INT_CMD	= 0x0B41,
-	HCLGE_PPU_PF_OTHER_INT_CMD	= 0x0B42,
-	HCLGE_COMMON_ECC_INT_CFG	= 0x1505,
-	HCLGE_QUERY_RAS_INT_STS_BD_NUM	= 0x1510,
-	HCLGE_QUERY_CLEAR_MPF_RAS_INT	= 0x1511,
-	HCLGE_QUERY_CLEAR_PF_RAS_INT	= 0x1512,
-	HCLGE_QUERY_MSIX_INT_STS_BD_NUM	= 0x1513,
-	HCLGE_QUERY_CLEAR_ALL_MPF_MSIX_INT	= 0x1514,
-	HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT	= 0x1515,
-	HCLGE_QUERY_ALL_ERR_BD_NUM		= 0x1516,
-	HCLGE_QUERY_ALL_ERR_INFO		= 0x1517,
-	HCLGE_CONFIG_ROCEE_RAS_INT_EN	= 0x1580,
-	HCLGE_QUERY_CLEAR_ROCEE_RAS_INT = 0x1581,
-	HCLGE_ROCEE_PF_RAS_INT_CMD	= 0x1584,
-	HCLGE_QUERY_ROCEE_ECC_RAS_INFO_CMD	= 0x1585,
-	HCLGE_QUERY_ROCEE_AXI_RAS_INFO_CMD	= 0x1586,
-	HCLGE_IGU_EGU_TNL_INT_EN	= 0x1803,
-	HCLGE_IGU_COMMON_INT_EN		= 0x1806,
-	HCLGE_TM_QCN_MEM_INT_CFG	= 0x1A14,
-	HCLGE_PPP_CMD0_INT_CMD		= 0x2100,
-	HCLGE_PPP_CMD1_INT_CMD		= 0x2101,
-	HCLGE_MAC_ETHERTYPE_IDX_RD      = 0x2105,
-	HCLGE_NCSI_INT_EN		= 0x2401,
-
-	/* PHY command */
-	HCLGE_OPC_PHY_LINK_KSETTING	= 0x7025,
-	HCLGE_OPC_PHY_REG		= 0x7026,
-
-	/* Query link diagnosis info command */
-	HCLGE_OPC_QUERY_LINK_DIAGNOSIS	= 0x702A,
-};
-
 #define hclge_cmd_setup_basic_desc(desc, opcode, is_read) \
-	hclge_comm_cmd_setup_basic_desc(desc, (enum hclge_comm_opcode_type)opcode, \
-					is_read)
+	hclge_comm_cmd_setup_basic_desc(desc, opcode, is_read)
 
 #define HCLGE_TQP_REG_OFFSET		0x80000
 #define HCLGE_TQP_REG_SIZE		0x200
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index cbf620bcf31c..537b887fa0a2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -16,30 +16,6 @@ struct hclgevf_dev;
 
 #define HCLGEVF_SYNC_RX_RING_HEAD_EN_B	4
 
-enum hclgevf_opcode_type {
-	/* Generic command */
-	HCLGEVF_OPC_QUERY_FW_VER	= 0x0001,
-	HCLGEVF_OPC_QUERY_VF_RSRC	= 0x0024,
-	HCLGEVF_OPC_QUERY_DEV_SPECS	= 0x0050,
-
-	/* TQP command */
-	HCLGEVF_OPC_QUERY_TX_STATUS	= 0x0B03,
-	HCLGEVF_OPC_QUERY_RX_STATUS	= 0x0B13,
-	HCLGEVF_OPC_CFG_COM_TQP_QUEUE	= 0x0B20,
-	/* GRO command */
-	HCLGEVF_OPC_GRO_GENERIC_CONFIG  = 0x0C10,
-	/* RSS cmd */
-	HCLGEVF_OPC_RSS_GENERIC_CONFIG	= 0x0D01,
-	HCLGEVF_OPC_RSS_INPUT_TUPLE     = 0x0D02,
-	HCLGEVF_OPC_RSS_INDIR_TABLE	= 0x0D07,
-	HCLGEVF_OPC_RSS_TC_MODE		= 0x0D08,
-	/* Mailbox cmd */
-	HCLGEVF_OPC_MBX_VF_TO_PF	= 0x2001,
-
-	/* IMP stats command */
-	HCLGEVF_OPC_IMP_COMPAT_CFG	= 0x701A,
-};
-
 #define HCLGEVF_TQP_REG_OFFSET		0x80000
 #define HCLGEVF_TQP_REG_SIZE		0x200
 
@@ -133,8 +109,7 @@ struct hclgevf_cfg_tx_queue_pointer_cmd {
 #define HCLGEVF_QUERY_DEV_SPECS_BD_NUM		4
 
 #define hclgevf_cmd_setup_basic_desc(desc, opcode, is_read) \
-	hclge_comm_cmd_setup_basic_desc(desc, (enum hclge_comm_opcode_type)opcode, \
-					is_read)
+	hclge_comm_cmd_setup_basic_desc(desc, opcode, is_read)
 
 struct hclgevf_dev_specs_0_cmd {
 	__le32 rsv0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5b2379252478..7df87610ad96 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -838,8 +838,7 @@ static int hclgevf_tqp_enable_cmd_send(struct hclgevf_dev *hdev, u16 tqp_id,
 
 	req = (struct hclgevf_cfg_com_tqp_queue_cmd *)desc.data;
 
-	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_CFG_COM_TQP_QUEUE,
-				     false);
+	hclgevf_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_COM_TQP_QUEUE, false);
 	req->tqp_id = cpu_to_le16(tqp_id & HCLGEVF_RING_ID_MASK);
 	req->stream_id = cpu_to_le16(stream_id);
 	if (enable)
@@ -2127,7 +2126,7 @@ static int hclgevf_config_gro(struct hclgevf_dev *hdev)
 	if (!hnae3_dev_gro_supported(hdev))
 		return 0;
 
-	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_GRO_GENERIC_CONFIG,
+	hclgevf_cmd_setup_basic_desc(&desc, HCLGE_OPC_GRO_GENERIC_CONFIG,
 				     false);
 	req = (struct hclgevf_cfg_gro_status_cmd *)desc.data;
 
@@ -2638,7 +2637,7 @@ static int hclgevf_query_vf_resource(struct hclgevf_dev *hdev)
 	struct hclge_desc desc;
 	int ret;
 
-	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_QUERY_VF_RSRC, true);
+	hclgevf_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_VF_RSRC, true);
 	ret = hclgevf_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
@@ -2748,11 +2747,10 @@ static int hclgevf_query_dev_specs(struct hclgevf_dev *hdev)
 
 	for (i = 0; i < HCLGEVF_QUERY_DEV_SPECS_BD_NUM - 1; i++) {
 		hclgevf_cmd_setup_basic_desc(&desc[i],
-					     HCLGEVF_OPC_QUERY_DEV_SPECS, true);
+					     HCLGE_OPC_QUERY_DEV_SPECS, true);
 		desc[i].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	}
-	hclgevf_cmd_setup_basic_desc(&desc[i], HCLGEVF_OPC_QUERY_DEV_SPECS,
-				     true);
+	hclgevf_cmd_setup_basic_desc(&desc[i], HCLGE_OPC_QUERY_DEV_SPECS, true);
 
 	ret = hclgevf_cmd_send(&hdev->hw, desc, HCLGEVF_QUERY_DEV_SPECS_BD_NUM);
 	if (ret)
-- 
2.33.0

