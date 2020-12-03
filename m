Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F672CD554
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgLCMTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:19:40 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9096 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgLCMTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:19:39 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cmvxp1RGvzLxlW;
        Thu,  3 Dec 2020 20:18:22 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Dec 2020 20:18:47 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>, <huangdaode@huawei.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/3] net: hns3: refine the VLAN tag handle for port based VLAN
Date:   Thu, 3 Dec 2020 20:18:56 +0800
Message-ID: <1606997936-22166-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606997936-22166-1-git-send-email-tanhuazhong@huawei.com>
References: <1606997936-22166-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

For DEVICE_VERSION_V2, the hardware only supports max two layer
VLAN tags, including port based tag inserted by hardware, tag in
tx buffer descriptor(get from skb->tci) and tag in packet.

For tranmist packet:
If port based VLAN disabled, and vf driver gets a VLAN tag from
skb, the VLAN tag must be filled to the Outer_VLAN_TAG field
(tag near to DMAC) of tx buffer descriptor, otherwise it may
be inserted after the tag in packet.

If port based VLAN enabled, and vf driver gets a VLAN tag from
skb, the VLAN tag must be filled to the VLAN_TAG field (tag
far to DMAC) of tx buffer descriptor, otherwise it may be
conflicted with port based VLAN, and raise a msix error event.

For receive packet:
The hardware will strip the VLAN tags and fill them in the
rx buffer descriptor, no matter port based VLAN enable or not.
Because port based VLAN tag is useless for stack, so vf driver
needs to discard the port based VLAN tag get from rx buffer
descriptor when port based VLAN enabled.

So the vf must know about the port based VLAN state.

For DEVICE_VERSION_V3, the hardware provides some new
configuration to improve it.

For tranmist packet:
when enable tag shift mode, hardware will handle
the VLAN tag in Outer_VLAN_TAG field as VLAN_TAG, so it
won't conflict with port based VLAN. And hardware also
make sure the tag before the tag in packet. So vf driver
doesn't need to specify the tag position according to the
port based VLAN state anymore.

For receive packet:
when enable discard mode, hardware will strip and discard the
port based VLAN tag, so the vf driver doesn't need to
identify it from rx buffer descriptor.

So modify the port based VLAN configuration, simplify the process
for vf handling the VLAN tag.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  8 +++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  3 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 46 +++++++++++++++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    | 13 +++---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 11 +++++-
 5 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9873fc4..aef7b24 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1006,6 +1006,7 @@ static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 			     struct sk_buff *skb)
 {
 	struct hnae3_handle *handle = tx_ring->tqp->handle;
+	struct hnae3_ae_dev *ae_dev;
 	struct vlan_ethhdr *vhdr;
 	int rc;
 
@@ -1013,10 +1014,13 @@ static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 	      skb_vlan_tag_present(skb)))
 		return 0;
 
-	/* Since HW limitation, if port based insert VLAN enabled, only one VLAN
-	 * header is allowed in skb, otherwise it will cause RAS error.
+	/* For HW limitation on HNAE3_DEVICE_VERSION_V2, if port based insert
+	 * VLAN enabled, only one VLAN header is allowed in skb, otherwise it
+	 * will cause RAS error.
 	 */
+	ae_dev = pci_get_drvdata(handle->pdev);
 	if (unlikely(skb_vlan_tagged_multi(skb) &&
+		     ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 &&
 		     handle->port_base_vlan_state ==
 		     HNAE3_PORT_BASE_VLAN_ENABLE))
 		return -EINVAL;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 7ce8be1..52a6f9b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -825,6 +825,7 @@ enum hclge_mac_vlan_cfg_sel {
 #define HCLGE_CFG_NIC_ROCE_SEL_B	4
 #define HCLGE_ACCEPT_TAG2_B		5
 #define HCLGE_ACCEPT_UNTAG2_B		6
+#define HCLGE_TAG_SHIFT_MODE_EN_B	7
 #define HCLGE_VF_NUM_PER_BYTE		8
 
 struct hclge_vport_vtag_tx_cfg_cmd {
@@ -841,6 +842,8 @@ struct hclge_vport_vtag_tx_cfg_cmd {
 #define HCLGE_REM_TAG2_EN_B		1
 #define HCLGE_SHOW_TAG1_EN_B		2
 #define HCLGE_SHOW_TAG2_EN_B		3
+#define HCLGE_DISCARD_TAG1_EN_B		5
+#define HCLGE_DISCARD_TAG2_EN_B		6
 struct hclge_vport_vtag_rx_cfg_cmd {
 	u8 vport_vlan_cfg;
 	u8 vf_offset;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7d511df..cfa0be6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8617,6 +8617,8 @@ static int hclge_set_vlan_tx_offload_cfg(struct hclge_vport *vport)
 		      vcfg->insert_tag1_en ? 1 : 0);
 	hnae3_set_bit(req->vport_vlan_cfg, HCLGE_PORT_INS_TAG2_EN_B,
 		      vcfg->insert_tag2_en ? 1 : 0);
+	hnae3_set_bit(req->vport_vlan_cfg, HCLGE_TAG_SHIFT_MODE_EN_B,
+		      vcfg->tag_shift_mode_en ? 1 : 0);
 	hnae3_set_bit(req->vport_vlan_cfg, HCLGE_CFG_NIC_ROCE_SEL_B, 0);
 
 	req->vf_offset = vport->vport_id / HCLGE_VF_NUM_PER_CMD;
@@ -8654,6 +8656,10 @@ static int hclge_set_vlan_rx_offload_cfg(struct hclge_vport *vport)
 		      vcfg->vlan1_vlan_prionly ? 1 : 0);
 	hnae3_set_bit(req->vport_vlan_cfg, HCLGE_SHOW_TAG2_EN_B,
 		      vcfg->vlan2_vlan_prionly ? 1 : 0);
+	hnae3_set_bit(req->vport_vlan_cfg, HCLGE_DISCARD_TAG1_EN_B,
+		      vcfg->strip_tag1_discard_en ? 1 : 0);
+	hnae3_set_bit(req->vport_vlan_cfg, HCLGE_DISCARD_TAG2_EN_B,
+		      vcfg->strip_tag2_discard_en ? 1 : 0);
 
 	req->vf_offset = vport->vport_id / HCLGE_VF_NUM_PER_CMD;
 	bmap_index = vport->vport_id % HCLGE_VF_NUM_PER_CMD /
@@ -8681,7 +8687,10 @@ static int hclge_vlan_offload_cfg(struct hclge_vport *vport,
 		vport->txvlan_cfg.insert_tag1_en = false;
 		vport->txvlan_cfg.default_tag1 = 0;
 	} else {
-		vport->txvlan_cfg.accept_tag1 = false;
+		struct hnae3_ae_dev *ae_dev = pci_get_drvdata(vport->nic.pdev);
+
+		vport->txvlan_cfg.accept_tag1 =
+			ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3;
 		vport->txvlan_cfg.insert_tag1_en = true;
 		vport->txvlan_cfg.default_tag1 = vlan_tag;
 	}
@@ -8696,16 +8705,21 @@ static int hclge_vlan_offload_cfg(struct hclge_vport *vport,
 	vport->txvlan_cfg.accept_untag2 = true;
 	vport->txvlan_cfg.insert_tag2_en = false;
 	vport->txvlan_cfg.default_tag2 = 0;
+	vport->txvlan_cfg.tag_shift_mode_en = true;
 
 	if (port_base_vlan_state == HNAE3_PORT_BASE_VLAN_DISABLE) {
 		vport->rxvlan_cfg.strip_tag1_en = false;
 		vport->rxvlan_cfg.strip_tag2_en =
 				vport->rxvlan_cfg.rx_vlan_offload_en;
+		vport->rxvlan_cfg.strip_tag2_discard_en = false;
 	} else {
 		vport->rxvlan_cfg.strip_tag1_en =
 				vport->rxvlan_cfg.rx_vlan_offload_en;
 		vport->rxvlan_cfg.strip_tag2_en = true;
+		vport->rxvlan_cfg.strip_tag2_discard_en = true;
 	}
+
+	vport->rxvlan_cfg.strip_tag1_discard_en = false;
 	vport->rxvlan_cfg.vlan1_vlan_prionly = false;
 	vport->rxvlan_cfg.vlan2_vlan_prionly = false;
 
@@ -9000,10 +9014,14 @@ int hclge_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
 	if (vport->port_base_vlan_cfg.state == HNAE3_PORT_BASE_VLAN_DISABLE) {
 		vport->rxvlan_cfg.strip_tag1_en = false;
 		vport->rxvlan_cfg.strip_tag2_en = enable;
+		vport->rxvlan_cfg.strip_tag2_discard_en = false;
 	} else {
 		vport->rxvlan_cfg.strip_tag1_en = enable;
 		vport->rxvlan_cfg.strip_tag2_en = true;
+		vport->rxvlan_cfg.strip_tag2_discard_en = true;
 	}
+
+	vport->rxvlan_cfg.strip_tag1_discard_en = false;
 	vport->rxvlan_cfg.vlan1_vlan_prionly = false;
 	vport->rxvlan_cfg.vlan2_vlan_prionly = false;
 	vport->rxvlan_cfg.rx_vlan_offload_en = enable;
@@ -9115,6 +9133,7 @@ static u16 hclge_get_port_base_vlan_state(struct hclge_vport *vport,
 static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 				    u16 vlan, u8 qos, __be16 proto)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 	struct hclge_vlan_info vlan_info;
@@ -9144,16 +9163,25 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 	vlan_info.qos = qos;
 	vlan_info.vlan_proto = ntohs(proto);
 
-	if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state)) {
-		return hclge_update_port_base_vlan_cfg(vport, state,
-						       &vlan_info);
-	} else {
-		ret = hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
-							vport->vport_id, state,
-							vlan, qos,
-							ntohs(proto));
+	ret = hclge_update_port_base_vlan_cfg(vport, state, &vlan_info);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to update port base vlan for vf %d, ret = %d\n",
+			vfid, ret);
 		return ret;
 	}
+
+	/* for DEVICE_VERSION_V3, VF doesn't need to know abort the port base
+	 * VLAN state.
+	 */
+	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3 &&
+	    test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
+		hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
+						  vport->vport_id, state,
+						  vlan, qos,
+						  ntohs(proto));
+
+	return 0;
 }
 
 static void hclge_clear_vf_vlan(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index bd17685..03aff12 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -850,15 +850,18 @@ struct hclge_tx_vtag_cfg {
 	bool insert_tag2_en;	/* Whether insert outer vlan tag */
 	u16  default_tag1;	/* The default inner vlan tag to insert */
 	u16  default_tag2;	/* The default outer vlan tag to insert */
+	bool tag_shift_mode_en;
 };
 
 /* VPort level vlan tag configuration for RX direction */
 struct hclge_rx_vtag_cfg {
-	u8 rx_vlan_offload_en;	/* Whether enable rx vlan offload */
-	u8 strip_tag1_en;	/* Whether strip inner vlan tag */
-	u8 strip_tag2_en;	/* Whether strip outer vlan tag */
-	u8 vlan1_vlan_prionly;	/* Inner VLAN Tag up to descriptor Enable */
-	u8 vlan2_vlan_prionly;	/* Outer VLAN Tag up to descriptor Enable */
+	bool rx_vlan_offload_en; /* Whether enable rx vlan offload */
+	bool strip_tag1_en;	 /* Whether strip inner vlan tag */
+	bool strip_tag2_en;	 /* Whether strip outer vlan tag */
+	bool vlan1_vlan_prionly; /* Inner VLAN Tag up to descriptor Enable */
+	bool vlan2_vlan_prionly; /* Outer VLAN Tag up to descriptor Enable */
+	bool strip_tag1_discard_en; /* Inner VLAN Tag discard for BD enable */
+	bool strip_tag2_discard_en; /* Outer VLAN Tag discard for BD enable */
 };
 
 struct hclge_rss_tuple_cfg {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index aa67c37..740a126 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -378,7 +378,16 @@ static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
 		status = hclge_update_port_base_vlan_cfg(vport, *state,
 							 vlan_info);
 	} else if (msg_cmd->subcode == HCLGE_MBX_GET_PORT_BASE_VLAN_STATE) {
-		resp_msg->data[0] = vport->port_base_vlan_cfg.state;
+		struct hnae3_ae_dev *ae_dev = pci_get_drvdata(vport->nic.pdev);
+		/* VF needn't to know about the port base VLAN status on device
+		 * version HNAE3_DEVICE_VERSION_V3. So always return Disable
+		 * on device version HNAE3_DEVICE_VERSION_V3 if VF query the
+		 * port base VLAN states.
+		 */
+		resp_msg->data[0] =
+			ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3 ?
+			HNAE3_PORT_BASE_VLAN_DISABLE :
+			vport->port_base_vlan_cfg.state;
 		resp_msg->len = sizeof(u8);
 	}
 
-- 
2.7.4

