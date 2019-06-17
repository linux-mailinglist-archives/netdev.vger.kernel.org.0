Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3027E48429
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfFQNgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:36:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18590 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726065AbfFQNgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 09:36:17 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0F39B29498399E2AB982;
        Mon, 17 Jun 2019 21:36:15 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Mon, 17 Jun 2019 21:36:06 +0800
From:   Xue Chaojing <xuechaojing@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoshaokai@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <xuechaojing@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: [PATCH net-next v4 3/3] hinic: add support for rss parameters with ethtool
Date:   Mon, 17 Jun 2019 05:46:01 +0000
Message-ID: <20190617054601.3056-4-xuechaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190617054601.3056-1-xuechaojing@huawei.com>
References: <20190617054601.3056-1-xuechaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support rss parameters with ethtool,
user can change hash key, hash indirection table, hash
function by ethtool -X, and show rss parameters by ethtool -x.

Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |   2 +
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 295 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  12 +-
 .../net/ethernet/huawei/hinic/hinic_port.c    | 126 ++++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    |  45 +++
 5 files changed, 479 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index 8926768280f2..5c9bc3319880 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -85,6 +85,8 @@ struct hinic_dev {
 	u16				num_rss;
 	u16				rss_limit;
 	struct hinic_rss_type		rss_type;
+	u8				*rss_hkey_user;
+	s32				*rss_indir_user;
 };
 
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 2cc97bfef0b8..be28a9a7f033 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -149,12 +149,307 @@ static void hinic_get_channels(struct net_device *netdev,
 	channels->combined_count = 0;
 }
 
+static int hinic_get_rss_hash_opts(struct hinic_dev *nic_dev,
+				   struct ethtool_rxnfc *cmd)
+{
+	struct hinic_rss_type rss_type = { 0 };
+	int err;
+
+	cmd->data = 0;
+
+	if (!(nic_dev->flags & HINIC_RSS_ENABLE))
+		return 0;
+
+	err = hinic_get_rss_type(nic_dev, nic_dev->rss_tmpl_idx,
+				 &rss_type);
+	if (err)
+		return err;
+
+	cmd->data = RXH_IP_SRC | RXH_IP_DST;
+	switch (cmd->flow_type) {
+	case TCP_V4_FLOW:
+		if (rss_type.tcp_ipv4)
+			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
+	case TCP_V6_FLOW:
+		if (rss_type.tcp_ipv6)
+			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
+	case UDP_V4_FLOW:
+		if (rss_type.udp_ipv4)
+			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
+	case UDP_V6_FLOW:
+		if (rss_type.udp_ipv6)
+			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
+	case IPV4_FLOW:
+	case IPV6_FLOW:
+		break;
+	default:
+		cmd->data = 0;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int set_l4_rss_hash_ops(struct ethtool_rxnfc *cmd,
+			       struct hinic_rss_type *rss_type)
+{
+	u8 rss_l4_en = 0;
+
+	switch (cmd->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
+	case 0:
+		rss_l4_en = 0;
+		break;
+	case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+		rss_l4_en = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (cmd->flow_type) {
+	case TCP_V4_FLOW:
+		rss_type->tcp_ipv4 = rss_l4_en;
+		break;
+	case TCP_V6_FLOW:
+		rss_type->tcp_ipv6 = rss_l4_en;
+		break;
+	case UDP_V4_FLOW:
+		rss_type->udp_ipv4 = rss_l4_en;
+		break;
+	case UDP_V6_FLOW:
+		rss_type->udp_ipv6 = rss_l4_en;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hinic_set_rss_hash_opts(struct hinic_dev *nic_dev,
+				   struct ethtool_rxnfc *cmd)
+{
+	struct hinic_rss_type *rss_type = &nic_dev->rss_type;
+	int err;
+
+	if (!(nic_dev->flags & HINIC_RSS_ENABLE)) {
+		cmd->data = 0;
+		return -EOPNOTSUPP;
+	}
+
+	/* RSS does not support anything other than hashing
+	 * to queues on src and dst IPs and ports
+	 */
+	if (cmd->data & ~(RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 |
+		RXH_L4_B_2_3))
+		return -EINVAL;
+
+	/* We need at least the IP SRC and DEST fields for hashing */
+	if (!(cmd->data & RXH_IP_SRC) || !(cmd->data & RXH_IP_DST))
+		return -EINVAL;
+
+	err = hinic_get_rss_type(nic_dev,
+				 nic_dev->rss_tmpl_idx, rss_type);
+	if (err)
+		return -EFAULT;
+
+	switch (cmd->flow_type) {
+	case TCP_V4_FLOW:
+	case TCP_V6_FLOW:
+	case UDP_V4_FLOW:
+	case UDP_V6_FLOW:
+		err = set_l4_rss_hash_ops(cmd, rss_type);
+		if (err)
+			return err;
+		break;
+	case IPV4_FLOW:
+		rss_type->ipv4 = 1;
+		break;
+	case IPV6_FLOW:
+		rss_type->ipv6 = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	err = hinic_set_rss_type(nic_dev, nic_dev->rss_tmpl_idx,
+				 *rss_type);
+	if (err)
+		return -EFAULT;
+
+	return 0;
+}
+
+static int __set_rss_rxfh(struct net_device *netdev,
+			  const u32 *indir, const u8 *key)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	int err;
+
+	if (indir) {
+		if (!nic_dev->rss_indir_user) {
+			nic_dev->rss_indir_user =
+				kzalloc(sizeof(u32) * HINIC_RSS_INDIR_SIZE,
+					GFP_KERNEL);
+			if (!nic_dev->rss_indir_user)
+				return -ENOMEM;
+		}
+
+		memcpy(nic_dev->rss_indir_user, indir,
+		       sizeof(u32) * HINIC_RSS_INDIR_SIZE);
+
+		err = hinic_rss_set_indir_tbl(nic_dev,
+					      nic_dev->rss_tmpl_idx, indir);
+		if (err)
+			return -EFAULT;
+	}
+
+	if (key) {
+		if (!nic_dev->rss_hkey_user) {
+			nic_dev->rss_hkey_user =
+				kzalloc(HINIC_RSS_KEY_SIZE * 2, GFP_KERNEL);
+
+			if (!nic_dev->rss_hkey_user)
+				return -ENOMEM;
+		}
+
+		memcpy(nic_dev->rss_hkey_user, key, HINIC_RSS_KEY_SIZE);
+
+		err = hinic_rss_set_template_tbl(nic_dev,
+						 nic_dev->rss_tmpl_idx, key);
+		if (err)
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int hinic_get_rxnfc(struct net_device *netdev,
+			   struct ethtool_rxnfc *cmd, u32 *rule_locs)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	int err = 0;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_GRXRINGS:
+		cmd->data = nic_dev->num_qps;
+		break;
+	case ETHTOOL_GRXFH:
+		err = hinic_get_rss_hash_opts(nic_dev, cmd);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int hinic_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	int err = 0;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_SRXFH:
+		err = hinic_set_rss_hash_opts(nic_dev, cmd);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int hinic_get_rxfh(struct net_device *netdev,
+			  u32 *indir, u8 *key, u8 *hfunc)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	u8 hash_engine_type = 0;
+	int err = 0;
+
+	if (!(nic_dev->flags & HINIC_RSS_ENABLE))
+		return -EOPNOTSUPP;
+
+	if (hfunc) {
+		err = hinic_rss_get_hash_engine(nic_dev,
+						nic_dev->rss_tmpl_idx,
+						&hash_engine_type);
+		if (err)
+			return -EFAULT;
+
+		*hfunc = hash_engine_type ? ETH_RSS_HASH_TOP : ETH_RSS_HASH_XOR;
+	}
+
+	if (indir) {
+		err = hinic_rss_get_indir_tbl(nic_dev,
+					      nic_dev->rss_tmpl_idx, indir);
+		if (err)
+			return -EFAULT;
+	}
+
+	if (key)
+		err = hinic_rss_get_template_tbl(nic_dev,
+						 nic_dev->rss_tmpl_idx, key);
+
+	return err;
+}
+
+static int hinic_set_rxfh(struct net_device *netdev, const u32 *indir,
+			  const u8 *key, const u8 hfunc)
+{
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+	int err = 0;
+
+	if (!(nic_dev->flags & HINIC_RSS_ENABLE))
+		return -EOPNOTSUPP;
+
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE) {
+		if (hfunc != ETH_RSS_HASH_TOP && hfunc != ETH_RSS_HASH_XOR)
+			return -EOPNOTSUPP;
+
+		nic_dev->rss_hash_engine = (hfunc == ETH_RSS_HASH_XOR) ?
+			HINIC_RSS_HASH_ENGINE_TYPE_XOR :
+			HINIC_RSS_HASH_ENGINE_TYPE_TOEP;
+		err = hinic_rss_set_hash_engine
+			(nic_dev, nic_dev->rss_tmpl_idx,
+			nic_dev->rss_hash_engine);
+		if (err)
+			return -EFAULT;
+	}
+
+	err = __set_rss_rxfh(netdev, indir, key);
+
+	return err;
+}
+
+static u32 hinic_get_rxfh_key_size(struct net_device *netdev)
+{
+	return HINIC_RSS_KEY_SIZE;
+}
+
+static u32 hinic_get_rxfh_indir_size(struct net_device *netdev)
+{
+	return HINIC_RSS_INDIR_SIZE;
+}
+
 static const struct ethtool_ops hinic_ethtool_ops = {
 	.get_link_ksettings = hinic_get_link_ksettings,
 	.get_drvinfo = hinic_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = hinic_get_ringparam,
 	.get_channels = hinic_get_channels,
+	.get_rxnfc = hinic_get_rxnfc,
+	.set_rxnfc = hinic_set_rxnfc,
+	.get_rxfh_key_size = hinic_get_rxfh_key_size,
+	.get_rxfh_indir_size = hinic_get_rxfh_indir_size,
+	.get_rxfh = hinic_get_rxfh,
+	.set_rxfh = hinic_set_rxfh,
 };
 
 void hinic_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 9c55374077f7..7f854392f4e7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -54,11 +54,21 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_SET_RX_CSUM	= 26,
 
+	HINIC_PORT_CMD_GET_RSS_TEMPLATE_INDIR_TBL = 37,
+
 	HINIC_PORT_CMD_SET_PORT_STATE   = 41,
 
 	HINIC_PORT_CMD_SET_RSS_TEMPLATE_TBL = 43,
 
-	HINIC_PORT_CMD_SET_RSS_HASH_ENGINE  = 45,
+	HINIC_PORT_CMD_GET_RSS_TEMPLATE_TBL = 44,
+
+	HINIC_PORT_CMD_SET_RSS_HASH_ENGINE = 45,
+
+	HINIC_PORT_CMD_GET_RSS_HASH_ENGINE = 46,
+
+	HINIC_PORT_CMD_GET_RSS_CTX_TBL  = 47,
+
+	HINIC_PORT_CMD_SET_RSS_CTX_TBL  = 48,
 
 	HINIC_PORT_CMD_RSS_TEMP_MGR	= 49,
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 92a0ec00f1b7..04ec2251fa22 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -625,6 +625,36 @@ int hinic_rss_set_indir_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
 	return err;
 }
 
+int hinic_rss_get_indir_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
+			    u32 *indir_table)
+{
+	struct hinic_rss_indir_table rss_cfg = { 0 };
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size = sizeof(rss_cfg);
+	int err = 0, i;
+
+	rss_cfg.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	rss_cfg.template_id = (u8)tmpl_idx;
+
+	err = hinic_port_msg_cmd(hwdev,
+				 HINIC_PORT_CMD_GET_RSS_TEMPLATE_INDIR_TBL,
+				 &rss_cfg, sizeof(rss_cfg), &rss_cfg,
+				 &out_size);
+	if (err || !out_size || rss_cfg.status) {
+		dev_err(&pdev->dev, "Failed to get indir table, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, rss_cfg.status, out_size);
+		return -EINVAL;
+	}
+
+	hinic_be32_to_cpu(rss_cfg.indir, HINIC_RSS_INDIR_SIZE);
+	for (i = 0; i < HINIC_RSS_INDIR_SIZE; i++)
+		indir_table[i] = rss_cfg.indir[i];
+
+	return 0;
+}
+
 int hinic_set_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
 		       struct hinic_rss_type rss_type)
 {
@@ -685,6 +715,44 @@ int hinic_set_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
 	return 0;
 }
 
+int hinic_get_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
+		       struct hinic_rss_type *rss_type)
+{
+	struct hinic_rss_context_table ctx_tbl = { 0 };
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size = sizeof(ctx_tbl);
+	int err;
+
+	if (!hwdev || !rss_type)
+		return -EINVAL;
+
+	ctx_tbl.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	ctx_tbl.template_id = (u8)tmpl_idx;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_RSS_CTX_TBL,
+				 &ctx_tbl, sizeof(ctx_tbl),
+				 &ctx_tbl, &out_size);
+	if (err || !out_size || ctx_tbl.status) {
+		dev_err(&pdev->dev, "Failed to get hash type, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, ctx_tbl.status, out_size);
+		return -EINVAL;
+	}
+
+	rss_type->ipv4          = HINIC_RSS_TYPE_GET(ctx_tbl.context, IPV4);
+	rss_type->ipv6          = HINIC_RSS_TYPE_GET(ctx_tbl.context, IPV6);
+	rss_type->ipv6_ext      = HINIC_RSS_TYPE_GET(ctx_tbl.context, IPV6_EXT);
+	rss_type->tcp_ipv4      = HINIC_RSS_TYPE_GET(ctx_tbl.context, TCP_IPV4);
+	rss_type->tcp_ipv6      = HINIC_RSS_TYPE_GET(ctx_tbl.context, TCP_IPV6);
+	rss_type->tcp_ipv6_ext  = HINIC_RSS_TYPE_GET(ctx_tbl.context,
+						     TCP_IPV6_EXT);
+	rss_type->udp_ipv4      = HINIC_RSS_TYPE_GET(ctx_tbl.context, UDP_IPV4);
+	rss_type->udp_ipv6      = HINIC_RSS_TYPE_GET(ctx_tbl.context, UDP_IPV6);
+
+	return 0;
+}
+
 int hinic_rss_set_template_tbl(struct hinic_dev *nic_dev, u32 template_id,
 			       const u8 *temp)
 {
@@ -712,6 +780,36 @@ int hinic_rss_set_template_tbl(struct hinic_dev *nic_dev, u32 template_id,
 	return 0;
 }
 
+int hinic_rss_get_template_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
+			       u8 *temp)
+{
+	struct hinic_rss_template_key temp_key = { 0 };
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size = sizeof(temp_key);
+	int err;
+
+	if (!hwdev || !temp)
+		return -EINVAL;
+
+	temp_key.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	temp_key.template_id = (u8)tmpl_idx;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_RSS_TEMPLATE_TBL,
+				 &temp_key, sizeof(temp_key),
+				 &temp_key, &out_size);
+	if (err || !out_size || temp_key.status) {
+		dev_err(&pdev->dev, "Failed to set hash key, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, temp_key.status, out_size);
+		return -EINVAL;
+	}
+
+	memcpy(temp, temp_key.key, HINIC_RSS_KEY_SIZE);
+
+	return 0;
+}
+
 int hinic_rss_set_hash_engine(struct hinic_dev *nic_dev, u8 template_id,
 			      u8 type)
 {
@@ -739,6 +837,34 @@ int hinic_rss_set_hash_engine(struct hinic_dev *nic_dev, u8 template_id,
 	return 0;
 }
 
+int hinic_rss_get_hash_engine(struct hinic_dev *nic_dev, u8 tmpl_idx, u8 *type)
+{
+	struct hinic_rss_engine_type hash_type = { 0 };
+	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	struct hinic_hwif *hwif = hwdev->hwif;
+	struct pci_dev *pdev = hwif->pdev;
+	u16 out_size = sizeof(hash_type);
+	int err;
+
+	if (!hwdev || !type)
+		return -EINVAL;
+
+	hash_type.func_id = HINIC_HWIF_FUNC_IDX(hwif);
+	hash_type.template_id = tmpl_idx;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_RSS_HASH_ENGINE,
+				 &hash_type, sizeof(hash_type),
+				 &hash_type, &out_size);
+	if (err || !out_size || hash_type.status) {
+		dev_err(&pdev->dev, "Failed to get hash engine, err: %d, status: 0x%x, out size: 0x%x\n",
+			err, hash_type.status, out_size);
+		return -EINVAL;
+	}
+
+	*type = hash_type.hash_engine;
+	return 0;
+}
+
 int hinic_rss_cfg(struct hinic_dev *nic_dev, u8 rss_en, u8 template_id)
 {
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index dafa3ca18af4..f177945d64ae 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -242,6 +242,17 @@ struct hinic_rss_template_mgmt {
 	u8	rsvd1[4];
 };
 
+struct hinic_rss_template_key {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_id;
+	u8	template_id;
+	u8	rsvd1;
+	u8	key[HINIC_RSS_KEY_SIZE];
+};
+
 struct hinic_rss_context_tbl {
 	u32 group_index;
 	u32 offset;
@@ -250,6 +261,17 @@ struct hinic_rss_context_tbl {
 	u32 ctx;
 };
 
+struct hinic_rss_context_table {
+	u8      status;
+	u8      version;
+	u8      rsvd0[6];
+
+	u16     func_id;
+	u8      template_id;
+	u8      rsvd1;
+	u32     context;
+};
+
 struct hinic_rss_indirect_tbl {
 	u32 group_index;
 	u32 offset;
@@ -258,6 +280,17 @@ struct hinic_rss_indirect_tbl {
 	u8 entry[HINIC_RSS_INDIR_SIZE];
 };
 
+struct hinic_rss_indir_table {
+	u8      status;
+	u8      version;
+	u8      rsvd0[6];
+
+	u16     func_id;
+	u8      template_id;
+	u8      rsvd1;
+	u8      indir[HINIC_RSS_INDIR_SIZE];
+};
+
 struct hinic_rss_key {
 	u8	status;
 	u8	version;
@@ -348,4 +381,16 @@ int hinic_rss_template_alloc(struct hinic_dev *nic_dev, u8 *tmpl_idx);
 int hinic_rss_template_free(struct hinic_dev *nic_dev, u8 tmpl_idx);
 
 void hinic_set_ethtool_ops(struct net_device *netdev);
+
+int hinic_get_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
+		       struct hinic_rss_type *rss_type);
+
+int hinic_rss_get_indir_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
+			    u32 *indir_table);
+
+int hinic_rss_get_template_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
+			       u8 *temp);
+
+int hinic_rss_get_hash_engine(struct hinic_dev *nic_dev, u8 tmpl_idx,
+			      u8 *type);
 #endif
-- 
2.17.1

