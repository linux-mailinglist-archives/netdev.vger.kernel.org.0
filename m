Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BBAA04E0
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfH1O0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:26:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50136 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbfH1OZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:25:44 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2F040E633BED0A638460;
        Wed, 28 Aug 2019 22:25:41 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 28 Aug 2019 22:25:33 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 12/12] net: hns3: not allow SSU loopback while execute ethtool -t dev
Date:   Wed, 28 Aug 2019 22:23:16 +0800
Message-ID: <1567002196-63242-13-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
References: <1567002196-63242-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The current loopback mode is to add 0x1F to the SMAC address
as the DMAC address and enable the promiscuous mode.
However, if the VF address is the same as the DMAC address,
the loopback test fails.

Loopback can be enabled in three places: SSU, MAC, and serdes.
By default, SSU loopback is enabled, so if the SMAC and the DMAC
are the same, the packets are looped back in the SSU. If SSU loopback
is disabled, packets can reach MAC even if SMAC is the same as DMAC.

Therefore, this patch disables the SSU loopback before the loopback
test. In this way, the SMAC and DMAC can be the same, and the
promiscuous mode does not need to be enabled. And this is not
valid in version 0x20.

This patch also uses a macro to replace 0x1F.

Fixes: c39c4d98dc65 ("net: hns3: Add mac loopback selftest support in hns3 driver")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  9 +++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 28 ++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 38 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  2 ++
 4 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e219bb1..c52eccc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -97,7 +97,7 @@ static int hns3_lp_setup(struct net_device *ndev, enum hnae3_loop loop, bool en)
 		break;
 	}
 
-	if (ret)
+	if (ret || h->pdev->revision >= 0x21)
 		return ret;
 
 	if (en) {
@@ -144,7 +144,10 @@ static int hns3_lp_down(struct net_device *ndev, enum hnae3_loop loop_mode)
 
 static void hns3_lp_setup_skb(struct sk_buff *skb)
 {
+#define	HNS3_NIC_LB_DST_MAC_ADDR	0x1f
+
 	struct net_device *ndev = skb->dev;
+	struct hnae3_handle *handle;
 	unsigned char *packet;
 	struct ethhdr *ethh;
 	unsigned int i;
@@ -160,7 +163,9 @@ static void hns3_lp_setup_skb(struct sk_buff *skb)
 	 * before the packet reaches mac or serdes, which will defect
 	 * the purpose of mac or serdes selftest.
 	 */
-	ethh->h_dest[5] += 0x1f;
+	handle = hns3_get_handle(ndev);
+	if (handle->pdev->revision == 0x20)
+		ethh->h_dest[5] += HNS3_NIC_LB_DST_MAC_ADDR;
 	eth_zero_addr(ethh->h_source);
 	ethh->h_proto = htons(ETH_P_ARP);
 	skb_reset_mac_header(skb);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 29979be..4821fe0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -223,6 +223,9 @@ enum hclge_opcode_type {
 	HCLGE_OPC_MAC_ETHTYPE_ADD	    = 0x1010,
 	HCLGE_OPC_MAC_ETHTYPE_REMOVE	= 0x1011,
 
+	/* MAC VLAN commands */
+	HCLGE_OPC_MAC_VLAN_SWITCH_PARAM	= 0x1033,
+
 	/* VLAN commands */
 	HCLGE_OPC_VLAN_FILTER_CTRL	    = 0x1100,
 	HCLGE_OPC_VLAN_FILTER_PF_CFG	= 0x1101,
@@ -771,6 +774,31 @@ struct hclge_vlan_filter_vf_cfg_cmd {
 	u8  vf_bitmap[16];
 };
 
+#define HCLGE_SWITCH_ANTI_SPOOF_B	0U
+#define HCLGE_SWITCH_ALW_LPBK_B		1U
+#define HCLGE_SWITCH_ALW_LCL_LPBK_B	2U
+#define HCLGE_SWITCH_ALW_DST_OVRD_B	3U
+#define HCLGE_SWITCH_NO_MASK		0x0
+#define HCLGE_SWITCH_ANTI_SPOOF_MASK	0xFE
+#define HCLGE_SWITCH_ALW_LPBK_MASK	0xFD
+#define HCLGE_SWITCH_ALW_LCL_LPBK_MASK	0xFB
+#define HCLGE_SWITCH_LW_DST_OVRD_MASK	0xF7
+
+struct hclge_mac_vlan_switch_cmd {
+	u8 roce_sel;
+	u8 rsv1[3];
+	__le32 func_id;
+	u8 switch_param;
+	u8 rsv2[3];
+	u8 param_mask;
+	u8 rsv3[11];
+};
+
+enum hclge_mac_vlan_cfg_sel {
+	HCLGE_MAC_VLAN_NIC_SEL = 0,
+	HCLGE_MAC_VLAN_ROCE_SEL,
+};
+
 #define HCLGE_ACCEPT_TAG1_B		0
 #define HCLGE_ACCEPT_UNTAG1_B		1
 #define HCLGE_PORT_INS_TAG1_EN_B	2
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dc22b84..ce4b228 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6211,6 +6211,30 @@ static void hclge_cfg_mac_mode(struct hclge_dev *hdev, bool enable)
 			"mac enable fail, ret =%d.\n", ret);
 }
 
+static int hclge_config_switch_param(struct hclge_dev *hdev, int vfid,
+				     u8 switch_param, u8 param_mask)
+{
+	struct hclge_mac_vlan_switch_cmd *req;
+	struct hclge_desc desc;
+	u32 func_id;
+	int ret;
+
+	func_id = hclge_get_port_number(HOST_PORT, 0, vfid, 0);
+	req = (struct hclge_mac_vlan_switch_cmd *)desc.data;
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MAC_VLAN_SWITCH_PARAM,
+				   false);
+	req->roce_sel = HCLGE_MAC_VLAN_NIC_SEL;
+	req->func_id = cpu_to_le32(func_id);
+	req->switch_param = switch_param;
+	req->param_mask = param_mask;
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"set mac vlan switch parameter fail, ret = %d\n", ret);
+	return ret;
+}
+
 static void hclge_phy_link_status_wait(struct hclge_dev *hdev,
 				       int link_ret)
 {
@@ -6465,6 +6489,20 @@ static int hclge_set_loopback(struct hnae3_handle *handle,
 	struct hclge_dev *hdev = vport->back;
 	int i, ret;
 
+	/* Loopback can be enabled in three places: SSU, MAC, and serdes. By
+	 * default, SSU loopback is enabled, so if the SMAC and the DMAC are
+	 * the same, the packets are looped back in the SSU. If SSU loopback
+	 * is disabled, packets can reach MAC even if SMAC is the same as DMAC.
+	 */
+	if (hdev->pdev->revision >= 0x21) {
+		u8 switch_param = en ? 0 : BIT(HCLGE_SWITCH_ALW_LPBK_B);
+
+		ret = hclge_config_switch_param(hdev, PF_VPORT_ID, switch_param,
+						HCLGE_SWITCH_ALW_LPBK_MASK);
+		if (ret)
+			return ret;
+	}
+
 	switch (loop_mode) {
 	case HNAE3_LOOP_APP:
 		ret = hclge_set_app_loopback(hdev, en);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 437a9ff..870550f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -148,6 +148,8 @@ enum HLCGE_PORT_TYPE {
 	NETWORK_PORT
 };
 
+#define PF_VPORT_ID			0
+
 #define HCLGE_PF_ID_S			0
 #define HCLGE_PF_ID_M			GENMASK(2, 0)
 #define HCLGE_VF_ID_S			3
-- 
2.7.4

