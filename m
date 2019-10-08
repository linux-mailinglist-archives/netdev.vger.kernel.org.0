Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE05CF067
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 03:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfJHBXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 21:23:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52974 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729389AbfJHBWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 21:22:53 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4EE4D5238EA0AE084B97;
        Tue,  8 Oct 2019 09:22:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 8 Oct 2019 09:22:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next 4/6] net: hns3: add support for configuring bandwidth of VF on the host
Date:   Tue, 8 Oct 2019 09:20:07 +0800
Message-ID: <1570497609-36349-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
References: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

This patch adds support for configuring bandwidth of VF on the host
for HNS3 drivers.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  14 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  79 +++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 130 +++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  43 +++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   8 ++
 8 files changed, 280 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index ef56f37..1202bbc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -373,6 +373,8 @@ struct hnae3_ae_dev {
  * set_vf_trust
  *   Enable/disable trust for specified vf, if the vf being trusted, then
  *   it can enable promisc mode
+ * set_vf_rate
+ *   Set the max tx rate of specified vf.
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -545,6 +547,8 @@ struct hnae3_ae_ops {
 	int (*set_vf_spoofchk)(struct hnae3_handle *handle, int vf,
 			       bool enable);
 	int (*set_vf_trust)(struct hnae3_handle *handle, int vf, bool enable);
+	int (*set_vf_rate)(struct hnae3_handle *handle, int vf,
+			   int min_tx_rate, int max_tx_rate, bool force);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5c50555..5a8c316 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1850,6 +1850,18 @@ static int hns3_nic_set_vf_link_state(struct net_device *ndev, int vf,
 	return h->ae_algo->ops->set_vf_link_state(h, vf, link_state);
 }
 
+static int hns3_nic_set_vf_rate(struct net_device *ndev, int vf,
+				int min_tx_rate, int max_tx_rate)
+{
+	struct hnae3_handle *h = hns3_get_handle(ndev);
+
+	if (!h->ae_algo->ops->set_vf_rate)
+		return -EOPNOTSUPP;
+
+	return h->ae_algo->ops->set_vf_rate(h, vf, min_tx_rate, max_tx_rate,
+					    false);
+}
+
 static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_open		= hns3_nic_net_open,
 	.ndo_stop		= hns3_nic_net_stop,
@@ -1872,7 +1884,7 @@ static const struct net_device_ops hns3_nic_netdev_ops = {
 #endif
 	.ndo_get_vf_config	= hns3_nic_get_vf_config,
 	.ndo_set_vf_link_state	= hns3_nic_set_vf_link_state,
-
+	.ndo_set_vf_rate	= hns3_nic_set_vf_rate,
 };
 
 bool hns3_is_phys_func(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 265695a..3578832 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -244,7 +244,7 @@ enum hclge_opcode_type {
 	/* QCN commands */
 	HCLGE_OPC_QCN_MOD_CFG		= 0x1A01,
 	HCLGE_OPC_QCN_GRP_TMPLT_CFG	= 0x1A02,
-	HCLGE_OPC_QCN_SHAPPING_IR_CFG	= 0x1A03,
+	HCLGE_OPC_QCN_SHAPPING_CFG	= 0x1A03,
 	HCLGE_OPC_QCN_SHAPPING_BS_CFG	= 0x1A04,
 	HCLGE_OPC_QCN_QSET_LINK_CFG	= 0x1A05,
 	HCLGE_OPC_QCN_RP_STATUS_GET	= 0x1A06,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index d0128d7..0ccc8e7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1110,6 +1110,82 @@ static void hclge_dbg_dump_mac_tnl_status(struct hclge_dev *hdev)
 	}
 }
 
+static void hclge_dbg_dump_qs_shaper_single(struct hclge_dev *hdev, u16 qsid)
+{
+	struct hclge_qs_shapping_cmd *shap_cfg_cmd;
+	u8 ir_u, ir_b, ir_s, bs_b, bs_s;
+	struct hclge_desc desc;
+	u32 shapping_para;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QCN_SHAPPING_CFG, true);
+
+	shap_cfg_cmd = (struct hclge_qs_shapping_cmd *)desc.data;
+	shap_cfg_cmd->qs_id = cpu_to_le16(qsid);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"qs%u failed to get tx_rate, ret=%d\n",
+			qsid, ret);
+		return;
+	}
+
+	shapping_para = le32_to_cpu(shap_cfg_cmd->qs_shapping_para);
+	ir_b = hclge_tm_get_field(shapping_para, IR_B);
+	ir_u = hclge_tm_get_field(shapping_para, IR_U);
+	ir_s = hclge_tm_get_field(shapping_para, IR_S);
+	bs_b = hclge_tm_get_field(shapping_para, BS_B);
+	bs_s = hclge_tm_get_field(shapping_para, BS_S);
+
+	dev_info(&hdev->pdev->dev,
+		 "qs%u ir_b:%u, ir_u:%u, ir_s:%u, bs_b:%u, bs_s:%u\n",
+		 qsid, ir_b, ir_u, ir_s, bs_b, bs_s);
+}
+
+static void hclge_dbg_dump_qs_shaper_all(struct hclge_dev *hdev)
+{
+	struct hnae3_knic_private_info *kinfo;
+	struct hclge_vport *vport;
+	int vport_id, i;
+
+	for (vport_id = 0; vport_id <= pci_num_vf(hdev->pdev); vport_id++) {
+		vport = &hdev->vport[vport_id];
+		kinfo = &vport->nic.kinfo;
+
+		dev_info(&hdev->pdev->dev, "qs cfg of vport%d:\n", vport_id);
+
+		for (i = 0; i < kinfo->num_tc; i++) {
+			u16 qsid = vport->qs_offset + i;
+
+			hclge_dbg_dump_qs_shaper_single(hdev, qsid);
+		}
+	}
+}
+
+static void hclge_dbg_dump_qs_shaper(struct hclge_dev *hdev,
+				     const char *cmd_buf)
+{
+#define HCLGE_MAX_QSET_NUM 1024
+
+	u16 qsid;
+	int ret;
+
+	ret = kstrtou16(cmd_buf, 0, &qsid);
+	if (ret) {
+		hclge_dbg_dump_qs_shaper_all(hdev);
+		return;
+	}
+
+	if (qsid >= HCLGE_MAX_QSET_NUM) {
+		dev_err(&hdev->pdev->dev, "qsid(%u) out of range[0-1023]\n",
+			qsid);
+		return;
+	}
+
+	hclge_dbg_dump_qs_shaper_single(hdev, qsid);
+}
+
 int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 {
 #define DUMP_REG	"dump reg"
@@ -1145,6 +1221,9 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 					  &cmd_buf[sizeof("dump ncl_config")]);
 	} else if (strncmp(cmd_buf, "dump mac tnl status", 19) == 0) {
 		hclge_dbg_dump_mac_tnl_status(hdev);
+	} else if (strncmp(cmd_buf, "dump qs shaper", 14) == 0) {
+		hclge_dbg_dump_qs_shaper(hdev,
+					 &cmd_buf[sizeof("dump qs shaper")]);
 	} else {
 		dev_info(&hdev->pdev->dev, "unknown command\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c63f723..b88c0aa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1184,6 +1184,35 @@ static void hclge_parse_link_mode(struct hclge_dev *hdev, u8 speed_ability)
 		hclge_parse_backplane_link_mode(hdev, speed_ability);
 }
 
+static u32 hclge_get_max_speed(u8 speed_ability)
+{
+	if (speed_ability & HCLGE_SUPPORT_100G_BIT)
+		return HCLGE_MAC_SPEED_100G;
+
+	if (speed_ability & HCLGE_SUPPORT_50G_BIT)
+		return HCLGE_MAC_SPEED_50G;
+
+	if (speed_ability & HCLGE_SUPPORT_40G_BIT)
+		return HCLGE_MAC_SPEED_40G;
+
+	if (speed_ability & HCLGE_SUPPORT_25G_BIT)
+		return HCLGE_MAC_SPEED_25G;
+
+	if (speed_ability & HCLGE_SUPPORT_10G_BIT)
+		return HCLGE_MAC_SPEED_10G;
+
+	if (speed_ability & HCLGE_SUPPORT_1G_BIT)
+		return HCLGE_MAC_SPEED_1G;
+
+	if (speed_ability & HCLGE_SUPPORT_100M_BIT)
+		return HCLGE_MAC_SPEED_100M;
+
+	if (speed_ability & HCLGE_SUPPORT_10M_BIT)
+		return HCLGE_MAC_SPEED_10M;
+
+	return HCLGE_MAC_SPEED_1G;
+}
+
 static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 {
 	struct hclge_cfg_param_cmd *req;
@@ -1354,6 +1383,8 @@ static int hclge_configure(struct hclge_dev *hdev)
 
 	hclge_parse_link_mode(hdev, cfg.speed_ability);
 
+	hdev->hw.mac.max_speed = hclge_get_max_speed(cfg.speed_ability);
+
 	if ((hdev->tc_max > HNAE3_MAX_TC) ||
 	    (hdev->tc_max < 1)) {
 		dev_warn(&hdev->pdev->dev, "TC num = %d.\n",
@@ -2890,6 +2921,8 @@ static int hclge_get_vf_config(struct hnae3_handle *handle, int vf,
 	ivf->linkstate = vport->vf_info.link_state;
 	ivf->spoofchk = vport->vf_info.spoofchk;
 	ivf->trusted = vport->vf_info.trusted;
+	ivf->min_tx_rate = 0;
+	ivf->max_tx_rate = vport->vf_info.max_tx_rate;
 	ether_addr_copy(ivf->mac, vport->vf_info.mac);
 
 	return 0;
@@ -9520,6 +9553,97 @@ static int hclge_set_vf_trust(struct hnae3_handle *handle, int vf, bool enable)
 	return 0;
 }
 
+static void hclge_reset_vf_rate(struct hclge_dev *hdev)
+{
+	int ret;
+	int vf;
+
+	/* reset vf rate to default value */
+	for (vf = HCLGE_VF_VPORT_START_NUM; vf < hdev->num_alloc_vport; vf++) {
+		struct hclge_vport *vport = &hdev->vport[vf];
+
+		vport->vf_info.max_tx_rate = 0;
+		ret = hclge_tm_qs_shaper_cfg(vport, vport->vf_info.max_tx_rate);
+		if (ret)
+			dev_err(&hdev->pdev->dev,
+				"vf%d failed to reset to default, ret=%d\n",
+				vf - HCLGE_VF_VPORT_START_NUM, ret);
+	}
+}
+
+static int hclge_vf_rate_param_check(struct hclge_dev *hdev, int vf,
+				     int min_tx_rate, int max_tx_rate)
+{
+	if (min_tx_rate != 0 ||
+	    max_tx_rate < 0 || max_tx_rate > hdev->hw.mac.max_speed) {
+		dev_err(&hdev->pdev->dev,
+			"min_tx_rate:%d [0], max_tx_rate:%d [0, %u]\n",
+			min_tx_rate, max_tx_rate, hdev->hw.mac.max_speed);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hclge_set_vf_rate(struct hnae3_handle *handle, int vf,
+			     int min_tx_rate, int max_tx_rate, bool force)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	ret = hclge_vf_rate_param_check(hdev, vf, min_tx_rate, max_tx_rate);
+	if (ret)
+		return ret;
+
+	vport = hclge_get_vf_vport(hdev, vf);
+	if (!vport)
+		return -EINVAL;
+
+	if (!force && max_tx_rate == vport->vf_info.max_tx_rate)
+		return 0;
+
+	ret = hclge_tm_qs_shaper_cfg(vport, max_tx_rate);
+	if (ret)
+		return ret;
+
+	vport->vf_info.max_tx_rate = max_tx_rate;
+
+	return 0;
+}
+
+static int hclge_resume_vf_rate(struct hclge_dev *hdev)
+{
+	struct hnae3_handle *handle = &hdev->vport->nic;
+	struct hclge_vport *vport;
+	int ret;
+	int vf;
+
+	/* resume the vf max_tx_rate after reset */
+	for (vf = 0; vf < pci_num_vf(hdev->pdev); vf++) {
+		vport = hclge_get_vf_vport(hdev, vf);
+		if (!vport)
+			return -EINVAL;
+
+		/* zero means max rate, after reset, firmware already set it to
+		 * max rate, so just continue.
+		 */
+		if (!vport->vf_info.max_tx_rate)
+			continue;
+
+		ret = hclge_set_vf_rate(handle, vf, 0,
+					vport->vf_info.max_tx_rate, true);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"vf%d failed to resume tx_rate:%u, ret=%d\n",
+				vf, vport->vf_info.max_tx_rate, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static void hclge_reset_vport_state(struct hclge_dev *hdev)
 {
 	struct hclge_vport *vport = hdev->vport;
@@ -9623,6 +9747,10 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		return ret;
 
+	ret = hclge_resume_vf_rate(hdev);
+	if (ret)
+		return ret;
+
 	dev_info(&pdev->dev, "Reset done, %s driver initialization finished.\n",
 		 HCLGE_DRIVER_NAME);
 
@@ -9634,6 +9762,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	struct hclge_dev *hdev = ae_dev->priv;
 	struct hclge_mac *mac = &hdev->hw.mac;
 
+	hclge_reset_vf_rate(hdev);
 	hclge_misc_affinity_teardown(hdev);
 	hclge_state_uninit(hdev);
 
@@ -10360,6 +10489,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.set_vf_link_state = hclge_set_vf_link_state,
 	.set_vf_spoofchk = hclge_set_vf_spoofchk,
 	.set_vf_trust = hclge_set_vf_trust,
+	.set_vf_rate = hclge_set_vf_rate,
 };
 
 static struct hnae3_ae_algo ae_algo = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 66e8833..3153a96 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -258,6 +258,7 @@ struct hclge_mac {
 	u8 support_autoneg;
 	u8 speed_type;	/* 0: sfp speed, 1: active speed */
 	u32 speed;
+	u32 max_speed;
 	u32 speed_ability; /* speed ability supported by current media */
 	u32 module_type; /* sub media type, e.g. kr/cr/sr/lr */
 	u32 fec_mode; /* active fec mode */
@@ -889,6 +890,7 @@ struct hclge_vf_info {
 	int link_state;
 	u8 mac[ETH_ALEN];
 	u32 spoofchk;
+	u32 max_tx_rate;
 	u32 trusted;
 	u16 promisc_enable;
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 5cce9b7..0934954 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -511,6 +511,49 @@ static int hclge_tm_qs_bp_cfg(struct hclge_dev *hdev, u8 tc, u8 grp_id,
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
+int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate)
+{
+	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
+	struct hclge_qs_shapping_cmd *shap_cfg_cmd;
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_desc desc;
+	u8 ir_b, ir_u, ir_s;
+	u32 shaper_para;
+	int ret, i;
+
+	if (!max_tx_rate)
+		max_tx_rate = HCLGE_ETHER_MAX_RATE;
+
+	ret = hclge_shaper_para_calc(max_tx_rate, HCLGE_SHAPER_LVL_QSET,
+				     &ir_b, &ir_u, &ir_s);
+	if (ret)
+		return ret;
+
+	shaper_para = hclge_tm_get_shapping_para(ir_b, ir_u, ir_s,
+						 HCLGE_SHAPER_BS_U_DEF,
+						 HCLGE_SHAPER_BS_S_DEF);
+
+	for (i = 0; i < kinfo->num_tc; i++) {
+		hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QCN_SHAPPING_CFG,
+					   false);
+
+		shap_cfg_cmd = (struct hclge_qs_shapping_cmd *)desc.data;
+		shap_cfg_cmd->qs_id = cpu_to_le16(vport->qs_offset + i);
+		shap_cfg_cmd->qs_shapping_para = cpu_to_le32(shaper_para);
+
+		ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"vf%d, qs%u failed to set tx_rate:%d, ret=%d\n",
+				vport->vport_id, shap_cfg_cmd->qs_id,
+				max_tx_rate, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 {
 	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 8186109..95ef6e1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -96,6 +96,12 @@ struct hclge_pg_shapping_cmd {
 	__le32 pg_shapping_para;
 };
 
+struct hclge_qs_shapping_cmd {
+	__le16 qs_id;
+	u8 rsvd[2];
+	__le32 qs_shapping_para;
+};
+
 #define HCLGE_BP_GRP_NUM		32
 #define HCLGE_BP_SUB_GRP_ID_S		0
 #define HCLGE_BP_SUB_GRP_ID_M		GENMASK(4, 0)
@@ -154,4 +160,6 @@ int hclge_mac_pause_en_cfg(struct hclge_dev *hdev, bool tx, bool rx);
 int hclge_pause_addr_cfg(struct hclge_dev *hdev, const u8 *mac_addr);
 int hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
 int hclge_pfc_tx_stats_get(struct hclge_dev *hdev, u64 *stats);
+int hclge_tm_qs_shaper_cfg(struct hclge_vport *vport, int max_tx_rate);
+
 #endif
-- 
2.7.4

