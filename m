Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DC9226DE0
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389289AbgGTSJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:09:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33352 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389271AbgGTSJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:09:33 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqY2024232;
        Mon, 20 Jul 2020 11:09:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=GqTmS2WsZ7mfEx+5oWSo7fbSvHxu6Yq1I9MchuDX93Q=;
 b=DtuKLWdmzCnAqI/xt+OgzXLJYYFpJQKEX5wj75G/ZxOCV9DTBeT2SsKEkuqWzYIMpqkl
 SnGLX6yC+es5Z0NACfqi/iHUr7enKpZgVt6+NM6HPY7S4mnC8lTbRS7ZkzflqexFRy9J
 h+NF3EncDeGH/4R1TF55s0sEOZYmBvlGURCeSBAg8gEzVNU7eJduyoFQ3Yd0J1gHzxh4
 RoBe8pqLA47/MbQMSZWDUSqUEfnvNg9m7xjBgif/L4ZNzHB/MhE+aMcSNzwlOPRMNkvU
 StM2ezhPIHBnGXg93knlTgshQXEShde27NrovCuUH+rSoleRJMjRw9BRvp63cboOENaW sw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf8xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:09:26 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:09:24 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id A737B3F703F;
        Mon, 20 Jul 2020 11:09:20 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 08/16] qed: add support for Forward Error Correction
Date:   Mon, 20 Jul 2020 21:08:07 +0300
Message-ID: <20200720180815.107-9-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720180815.107-1-alobakin@marvell.com>
References: <20200720180815.107-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add all necessary routines for reading supported FEC modes from NVM and
querying FEC control to the MFW (if the running version supports it).

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c  | 54 +++++++++++++++-------
 drivers/net/ethernet/qlogic/qed/qed_hsi.h  | 24 +++++++++-
 drivers/net/ethernet/qlogic/qed/qed_main.c |  6 +++
 drivers/net/ethernet/qlogic/qed/qed_mcp.c  | 47 +++++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_mcp.h  |  4 ++
 include/linux/qed/qed_if.h                 | 13 ++++++
 6 files changed, 121 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 491a6dbb5d73..d929556247a5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3968,7 +3968,7 @@ static int qed_hw_get_resc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 
 static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
-	u32 port_cfg_addr, link_temp, nvm_cfg_addr, device_capabilities;
+	u32 port_cfg_addr, link_temp, nvm_cfg_addr, device_capabilities, fc;
 	u32 nvm_cfg1_offset, mf_mode, addr, generic_cont0, core_cfg;
 	struct qed_mcp_link_capabilities *p_caps;
 	struct qed_mcp_link_params *link;
@@ -4081,16 +4081,38 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	p_hwfn->mcp_info->link_capabilities.default_speed_autoneg =
 		link->speed.autoneg;
 
-	link_temp &= NVM_CFG1_PORT_DRV_FLOW_CONTROL_MASK;
-	link_temp >>= NVM_CFG1_PORT_DRV_FLOW_CONTROL_OFFSET;
-	link->pause.autoneg = !!(link_temp &
-				 NVM_CFG1_PORT_DRV_FLOW_CONTROL_AUTONEG);
-	link->pause.forced_rx = !!(link_temp &
-				   NVM_CFG1_PORT_DRV_FLOW_CONTROL_RX);
-	link->pause.forced_tx = !!(link_temp &
-				   NVM_CFG1_PORT_DRV_FLOW_CONTROL_TX);
+	fc = GET_MFW_FIELD(link_temp, NVM_CFG1_PORT_DRV_FLOW_CONTROL);
+	link->pause.autoneg = !!(fc & NVM_CFG1_PORT_DRV_FLOW_CONTROL_AUTONEG);
+	link->pause.forced_rx = !!(fc & NVM_CFG1_PORT_DRV_FLOW_CONTROL_RX);
+	link->pause.forced_tx = !!(fc & NVM_CFG1_PORT_DRV_FLOW_CONTROL_TX);
 	link->loopback_mode = 0;
 
+	if (p_hwfn->mcp_info->capabilities &
+	    FW_MB_PARAM_FEATURE_SUPPORT_FEC_CONTROL) {
+		switch (GET_MFW_FIELD(link_temp,
+				      NVM_CFG1_PORT_FEC_FORCE_MODE)) {
+		case NVM_CFG1_PORT_FEC_FORCE_MODE_NONE:
+			p_caps->fec_default |= QED_FEC_MODE_NONE;
+			break;
+		case NVM_CFG1_PORT_FEC_FORCE_MODE_FIRECODE:
+			p_caps->fec_default |= QED_FEC_MODE_FIRECODE;
+			break;
+		case NVM_CFG1_PORT_FEC_FORCE_MODE_RS:
+			p_caps->fec_default |= QED_FEC_MODE_RS;
+			break;
+		case NVM_CFG1_PORT_FEC_FORCE_MODE_AUTO:
+			p_caps->fec_default |= QED_FEC_MODE_AUTO;
+			break;
+		default:
+			DP_VERBOSE(p_hwfn, NETIF_MSG_LINK,
+				   "unknown FEC mode in 0x%08x\n", link_temp);
+		}
+	} else {
+		p_caps->fec_default = QED_FEC_MODE_UNSUPPORTED;
+	}
+
+	link->fec = p_caps->fec_default;
+
 	if (p_hwfn->mcp_info->capabilities & FW_MB_PARAM_FEATURE_SUPPORT_EEE) {
 		link_temp = qed_rd(p_hwfn, p_ptt, port_cfg_addr +
 				   offsetof(struct nvm_cfg1_port, ext_phy));
@@ -4122,14 +4144,12 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 		p_caps->default_eee = QED_MCP_EEE_UNSUPPORTED;
 	}
 
-	DP_VERBOSE(p_hwfn,
-		   NETIF_MSG_LINK,
-		   "Read default link: Speed 0x%08x, Adv. Speed 0x%08x, AN: 0x%02x, PAUSE AN: 0x%02x EEE: %02x [%08x usec]\n",
-		   link->speed.forced_speed,
-		   link->speed.advertised_speeds,
-		   link->speed.autoneg,
-		   link->pause.autoneg,
-		   p_caps->default_eee, p_caps->eee_lpi_timer);
+	DP_VERBOSE(p_hwfn, NETIF_MSG_LINK,
+		   "Read default link: Speed 0x%08x, Adv. Speed 0x%08x, AN: 0x%02x, PAUSE AN: 0x%02x, EEE: 0x%02x [0x%08x usec], FEC: 0x%02x\n",
+		   link->speed.forced_speed, link->speed.advertised_speeds,
+		   link->speed.autoneg, link->pause.autoneg,
+		   p_caps->default_eee, p_caps->eee_lpi_timer,
+		   p_caps->fec_default);
 
 	if (IS_LEAD_HWFN(p_hwfn)) {
 		struct qed_dev *cdev = p_hwfn->cdev;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 93d33c9cf145..7c1d4efffbff 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -11566,8 +11566,15 @@ struct eth_phy_cfg {
 #define EEE_TX_TIMER_USEC_AGGRESSIVE_TIME	0x100
 #define EEE_TX_TIMER_USEC_LATENCY_TIME		0x6000
 
-	u32 feature_config_flags;
-#define ETH_EEE_MODE_ADV_LPI		(1 << 0)
+	u32					deprecated;
+
+	u32					fec_mode;
+#define FEC_FORCE_MODE_MASK			0x000000ff
+#define FEC_FORCE_MODE_OFFSET			0
+#define FEC_FORCE_MODE_NONE			0x00
+#define FEC_FORCE_MODE_FIRECODE			0x01
+#define FEC_FORCE_MODE_RS			0x02
+#define FEC_FORCE_MODE_AUTO			0x07
 };
 
 struct port_mf_cfg {
@@ -11934,6 +11941,11 @@ struct public_port {
 #define LINK_STATUS_MAC_REMOTE_FAULT			0x02000000
 #define LINK_STATUS_UNSUPPORTED_SPD_REQ			0x04000000
 
+#define LINK_STATUS_FEC_MODE_MASK			0x38000000
+#define LINK_STATUS_FEC_MODE_NONE			(0 << 27)
+#define LINK_STATUS_FEC_MODE_FIRECODE_CL74		(1 << 27)
+#define LINK_STATUS_FEC_MODE_RS_CL91			(2 << 27)
+
 	u32 link_status1;
 	u32 ext_phy_fw_version;
 	u32 drv_phy_cfg_addr;
@@ -12553,6 +12565,7 @@ struct public_drv_mb {
 #define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_MASK		0x0000FFFF
 #define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_OFFSET	0
 #define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_EEE		0x00000002
+#define DRV_MB_PARAM_FEATURE_SUPPORT_PORT_FEC_CONTROL	0x00000004
 #define DRV_MB_PARAM_FEATURE_SUPPORT_FUNC_VLINK		0x00010000
 
 /* DRV_MSG_CODE_DEBUG_DATA_SEND parameters */
@@ -12641,6 +12654,7 @@ struct public_drv_mb {
 	/* Get MFW feature support response */
 #define FW_MB_PARAM_FEATURE_SUPPORT_SMARTLINQ		0x00000001
 #define FW_MB_PARAM_FEATURE_SUPPORT_EEE			0x00000002
+#define FW_MB_PARAM_FEATURE_SUPPORT_FEC_CONTROL		0x00000020
 #define FW_MB_PARAM_FEATURE_SUPPORT_VLINK		0x00010000
 
 #define FW_MB_PARAM_LOAD_DONE_DID_EFUSE_ERROR		BIT(0)
@@ -13091,6 +13105,12 @@ struct nvm_cfg1_port {
 #define NVM_CFG1_PORT_DRV_FLOW_CONTROL_AUTONEG			0x1
 #define NVM_CFG1_PORT_DRV_FLOW_CONTROL_RX			0x2
 #define NVM_CFG1_PORT_DRV_FLOW_CONTROL_TX			0x4
+#define NVM_CFG1_PORT_FEC_FORCE_MODE_MASK			0x000e0000
+#define NVM_CFG1_PORT_FEC_FORCE_MODE_OFFSET			17
+#define NVM_CFG1_PORT_FEC_FORCE_MODE_NONE			0x0
+#define NVM_CFG1_PORT_FEC_FORCE_MODE_FIRECODE			0x1
+#define NVM_CFG1_PORT_FEC_FORCE_MODE_RS				0x2
+#define NVM_CFG1_PORT_FEC_FORCE_MODE_AUTO			0x7
 
 	u32							phy_cfg;
 	u32							mgmt_traffic;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 2be9ed39c450..91e7cfc544f0 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1597,6 +1597,9 @@ static int qed_set_link(struct qed_dev *cdev, struct qed_link_params *params)
 		memcpy(&link_params->eee, &params->eee,
 		       sizeof(link_params->eee));
 
+	if (params->override_flags & QED_LINK_OVERRIDE_FEC_CONFIG)
+		link_params->fec = params->fec;
+
 	rc = qed_mcp_set_link(hwfn, ptt, params->link_up);
 
 	qed_ptt_release(hwfn, ptt);
@@ -1938,6 +1941,9 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 	else
 		phylink_clear(if_link->advertised_caps, Autoneg);
 
+	if_link->sup_fec = link_caps.fec_default;
+	if_link->active_fec = params.fec;
+
 	/* Fill link advertised capability */
 	qed_fill_link_capability(hwfn, ptt, params.speed.advertised_speeds,
 				 if_link->advertised_caps);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index b10a92488630..78c0d3a2d164 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -1446,6 +1446,25 @@ static void qed_mcp_handle_link_change(struct qed_hwfn *p_hwfn,
 	if (p_hwfn->mcp_info->capabilities & FW_MB_PARAM_FEATURE_SUPPORT_EEE)
 		qed_mcp_read_eee_config(p_hwfn, p_ptt, p_link);
 
+	if (p_hwfn->mcp_info->capabilities &
+	    FW_MB_PARAM_FEATURE_SUPPORT_FEC_CONTROL) {
+		switch (status & LINK_STATUS_FEC_MODE_MASK) {
+		case LINK_STATUS_FEC_MODE_NONE:
+			p_link->fec_active = QED_FEC_MODE_NONE;
+			break;
+		case LINK_STATUS_FEC_MODE_FIRECODE_CL74:
+			p_link->fec_active = QED_FEC_MODE_FIRECODE;
+			break;
+		case LINK_STATUS_FEC_MODE_RS_CL91:
+			p_link->fec_active = QED_FEC_MODE_RS;
+			break;
+		default:
+			p_link->fec_active = QED_FEC_MODE_AUTO;
+		}
+	} else {
+		p_link->fec_active = QED_FEC_MODE_UNSUPPORTED;
+	}
+
 	qed_link_update(p_hwfn, p_ptt);
 out:
 	spin_unlock_bh(&p_hwfn->mcp_info->link_lock);
@@ -1456,8 +1475,8 @@ int qed_mcp_set_link(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt, bool b_up)
 	struct qed_mcp_link_params *params = &p_hwfn->mcp_info->link_input;
 	struct qed_mcp_mb_params mb_params;
 	struct eth_phy_cfg phy_cfg;
+	u32 cmd, fec_bit = 0;
 	int rc = 0;
-	u32 cmd;
 
 	/* Set the shmem configuration according to params */
 	memset(&phy_cfg, 0, sizeof(phy_cfg));
@@ -1489,16 +1508,27 @@ int qed_mcp_set_link(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt, bool b_up)
 				   EEE_TX_TIMER_USEC_MASK;
 	}
 
+	if (p_hwfn->mcp_info->capabilities &
+	    FW_MB_PARAM_FEATURE_SUPPORT_FEC_CONTROL) {
+		if (params->fec & QED_FEC_MODE_NONE)
+			fec_bit |= FEC_FORCE_MODE_NONE;
+		else if (params->fec & QED_FEC_MODE_FIRECODE)
+			fec_bit |= FEC_FORCE_MODE_FIRECODE;
+		else if (params->fec & QED_FEC_MODE_RS)
+			fec_bit |= FEC_FORCE_MODE_RS;
+		else if (params->fec & QED_FEC_MODE_AUTO)
+			fec_bit |= FEC_FORCE_MODE_AUTO;
+
+		SET_MFW_FIELD(phy_cfg.fec_mode, FEC_FORCE_MODE, fec_bit);
+	}
+
 	p_hwfn->b_drv_link_init = b_up;
 
 	if (b_up) {
 		DP_VERBOSE(p_hwfn, NETIF_MSG_LINK,
-			   "Configuring Link: Speed 0x%08x, Pause 0x%08x, adv_speed 0x%08x, loopback 0x%08x, features 0x%08x\n",
-			   phy_cfg.speed,
-			   phy_cfg.pause,
-			   phy_cfg.adv_speed,
-			   phy_cfg.loopback_mode,
-			   phy_cfg.feature_config_flags);
+			   "Configuring Link: Speed 0x%08x, Pause 0x%08x, adv_speed 0x%08x, loopback 0x%08x, FEC 0x%08x\n",
+			   phy_cfg.speed, phy_cfg.pause, phy_cfg.adv_speed,
+			   phy_cfg.loopback_mode, phy_cfg.fec_mode);
 	} else {
 		DP_VERBOSE(p_hwfn, NETIF_MSG_LINK,
 			   "Resetting link\n");
@@ -3805,7 +3835,8 @@ int qed_mcp_set_capabilities(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	u32 mcp_resp, mcp_param, features;
 
 	features = DRV_MB_PARAM_FEATURE_SUPPORT_PORT_EEE |
-		   DRV_MB_PARAM_FEATURE_SUPPORT_FUNC_VLINK;
+		   DRV_MB_PARAM_FEATURE_SUPPORT_FUNC_VLINK |
+		   DRV_MB_PARAM_FEATURE_SUPPORT_PORT_FEC_CONTROL;
 
 	return qed_mcp_cmd(p_hwfn, p_ptt, DRV_MSG_CODE_FEATURE_SUPPORT,
 			   features, &mcp_resp, &mcp_param);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index cf678b6966f8..5e50405854e6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -38,11 +38,13 @@ struct qed_mcp_link_params {
 	struct qed_mcp_link_pause_params	pause;
 	u32					loopback_mode;
 	struct qed_link_eee_params		eee;
+	u32					fec;
 };
 
 struct qed_mcp_link_capabilities {
 	u32					speed_capabilities;
 	bool					default_speed_autoneg;
+	u32					fec_default;
 	enum qed_mcp_eee_mode			default_eee;
 	u32					eee_lpi_timer;
 	u8					eee_speed_caps;
@@ -88,6 +90,8 @@ struct qed_mcp_link_state {
 	bool					eee_active;
 	u8					eee_adv_caps;
 	u8					eee_lp_adv_caps;
+
+	u32					fec_active;
 };
 
 struct qed_mcp_function_info {
diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index dde48f206d0d..f0b4cdc79299 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -661,6 +661,14 @@ enum qed_protocol {
 	QED_PROTOCOL_FCOE,
 };
 
+enum qed_fec_mode {
+	QED_FEC_MODE_NONE			= BIT(0),
+	QED_FEC_MODE_FIRECODE			= BIT(1),
+	QED_FEC_MODE_RS				= BIT(2),
+	QED_FEC_MODE_AUTO			= BIT(3),
+	QED_FEC_MODE_UNSUPPORTED		= BIT(4),
+};
+
 struct qed_link_params {
 	bool					link_up;
 
@@ -671,6 +679,7 @@ struct qed_link_params {
 #define QED_LINK_OVERRIDE_PAUSE_CONFIG		BIT(3)
 #define QED_LINK_OVERRIDE_LOOPBACK_MODE		BIT(4)
 #define QED_LINK_OVERRIDE_EEE_CONFIG		BIT(5)
+#define QED_LINK_OVERRIDE_FEC_CONFIG		BIT(6)
 
 	bool					autoneg;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_speeds);
@@ -689,6 +698,7 @@ struct qed_link_params {
 #define QED_LINK_LOOPBACK_MAC			BIT(4)
 
 	struct qed_link_eee_params		eee;
+	u32					fec;
 };
 
 struct qed_link_output {
@@ -709,6 +719,9 @@ struct qed_link_output {
 	bool					eee_active;
 	u8					sup_caps;
 	struct qed_link_eee_params		eee;
+
+	u32					sup_fec;
+	u32					active_fec;
 };
 
 struct qed_probe_params {
-- 
2.25.1

