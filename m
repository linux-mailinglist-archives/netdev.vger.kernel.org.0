Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCED986FB2
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 04:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405465AbfHICeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 22:34:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59002 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405051AbfHICdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 22:33:35 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 24FA9DD27F72345221D1;
        Fri,  9 Aug 2019 10:33:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 9 Aug 2019 10:33:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 03/12] net: hns3: clean up for vlan handling in hns3_fill_desc_vtags
Date:   Fri, 9 Aug 2019 10:31:09 +0800
Message-ID: <1565317878-31806-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
References: <1565317878-31806-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

This patch refactors the hns3_fill_desc_vtags function
by avoiding passing too many parameters, reducing indent
level and some other clean up.

This patch also adds the hns3_fill_skb_desc function to
fill the first desc of a skb.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 167 +++++++++++++-----------
 1 file changed, 89 insertions(+), 78 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index ed05fb9..fd6a3d5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -45,6 +45,9 @@ MODULE_PARM_DESC(debug, " Network interface message level setting");
 #define DEFAULT_MSG_LEVEL (NETIF_MSG_PROBE | NETIF_MSG_LINK | \
 			   NETIF_MSG_IFDOWN | NETIF_MSG_IFUP)
 
+#define HNS3_INNER_VLAN_TAG	1
+#define HNS3_OUTER_VLAN_TAG	2
+
 /* hns3_pci_tbl - PCI Device ID Table
  *
  * Last entry must be all 0s
@@ -961,16 +964,16 @@ static void hns3_set_txbd_baseinfo(u16 *bdtp_fe_sc_vld_ra_ri, int frag_end)
 	hns3_set_field(*bdtp_fe_sc_vld_ra_ri, HNS3_TXD_VLD_B, 1U);
 }
 
-static int hns3_fill_desc_vtags(struct sk_buff *skb,
-				struct hns3_enet_ring *tx_ring,
-				u32 *inner_vlan_flag,
-				u32 *out_vlan_flag,
-				u16 *inner_vtag,
-				u16 *out_vtag)
+static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
+			     struct sk_buff *skb)
 {
-#define HNS3_TX_VLAN_PRIO_SHIFT 13
-
 	struct hnae3_handle *handle = tx_ring->tqp->handle;
+	struct vlan_ethhdr *vhdr;
+	int rc;
+
+	if (!(skb->protocol == htons(ETH_P_8021Q) ||
+	      skb_vlan_tag_present(skb)))
+		return 0;
 
 	/* Since HW limitation, if port based insert VLAN enabled, only one VLAN
 	 * header is allowed in skb, otherwise it will cause RAS error.
@@ -981,8 +984,7 @@ static int hns3_fill_desc_vtags(struct sk_buff *skb,
 		return -EINVAL;
 
 	if (skb->protocol == htons(ETH_P_8021Q) &&
-	    !(tx_ring->tqp->handle->kinfo.netdev->features &
-	    NETIF_F_HW_VLAN_CTAG_TX)) {
+	    !(handle->kinfo.netdev->features & NETIF_F_HW_VLAN_CTAG_TX)) {
 		/* When HW VLAN acceleration is turned off, and the stack
 		 * sets the protocol to 802.1q, the driver just need to
 		 * set the protocol to the encapsulated ethertype.
@@ -992,45 +994,92 @@ static int hns3_fill_desc_vtags(struct sk_buff *skb,
 	}
 
 	if (skb_vlan_tag_present(skb)) {
-		u16 vlan_tag;
-
-		vlan_tag = skb_vlan_tag_get(skb);
-		vlan_tag |= (skb->priority & 0x7) << HNS3_TX_VLAN_PRIO_SHIFT;
-
 		/* Based on hw strategy, use out_vtag in two layer tag case,
 		 * and use inner_vtag in one tag case.
 		 */
-		if (skb->protocol == htons(ETH_P_8021Q)) {
-			if (handle->port_base_vlan_state ==
-			    HNAE3_PORT_BASE_VLAN_DISABLE){
-				hns3_set_field(*out_vlan_flag,
-					       HNS3_TXD_OVLAN_B, 1);
-				*out_vtag = vlan_tag;
-			} else {
-				hns3_set_field(*inner_vlan_flag,
-					       HNS3_TXD_VLAN_B, 1);
-				*inner_vtag = vlan_tag;
-			}
-		} else {
-			hns3_set_field(*inner_vlan_flag, HNS3_TXD_VLAN_B, 1);
-			*inner_vtag = vlan_tag;
-		}
-	} else if (skb->protocol == htons(ETH_P_8021Q)) {
-		struct vlan_ethhdr *vhdr;
-		int rc;
+		if (skb->protocol == htons(ETH_P_8021Q) &&
+		    handle->port_base_vlan_state ==
+		    HNAE3_PORT_BASE_VLAN_DISABLE)
+			rc = HNS3_OUTER_VLAN_TAG;
+		else
+			rc = HNS3_INNER_VLAN_TAG;
 
-		rc = skb_cow_head(skb, 0);
-		if (unlikely(rc < 0))
-			return rc;
-		vhdr = (struct vlan_ethhdr *)skb->data;
-		vhdr->h_vlan_TCI |= cpu_to_be16((skb->priority & 0x7)
-					<< HNS3_TX_VLAN_PRIO_SHIFT);
+		skb->protocol = vlan_get_protocol(skb);
+		return rc;
 	}
 
+	rc = skb_cow_head(skb, 0);
+	if (unlikely(rc < 0))
+		return rc;
+
+	vhdr = (struct vlan_ethhdr *)skb->data;
+	vhdr->h_vlan_TCI |= cpu_to_be16((skb->priority << VLAN_PRIO_SHIFT)
+					 & VLAN_PRIO_MASK);
+
 	skb->protocol = vlan_get_protocol(skb);
 	return 0;
 }
 
+static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
+			      struct sk_buff *skb, struct hns3_desc *desc)
+{
+	u32 ol_type_vlan_len_msec = 0;
+	u32 type_cs_vlan_tso = 0;
+	u32 paylen = skb->len;
+	u16 inner_vtag = 0;
+	u16 out_vtag = 0;
+	u16 mss = 0;
+	int ret;
+
+	ret = hns3_handle_vtags(ring, skb);
+	if (unlikely(ret < 0)) {
+		return ret;
+	} else if (ret == HNS3_INNER_VLAN_TAG) {
+		inner_vtag = skb_vlan_tag_get(skb);
+		inner_vtag |= (skb->priority << VLAN_PRIO_SHIFT) &
+				VLAN_PRIO_MASK;
+		hns3_set_field(type_cs_vlan_tso, HNS3_TXD_VLAN_B, 1);
+	} else if (ret == HNS3_OUTER_VLAN_TAG) {
+		out_vtag = skb_vlan_tag_get(skb);
+		out_vtag |= (skb->priority << VLAN_PRIO_SHIFT) &
+				VLAN_PRIO_MASK;
+		hns3_set_field(ol_type_vlan_len_msec, HNS3_TXD_OVLAN_B,
+			       1);
+	}
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		u8 ol4_proto, il4_proto;
+
+		skb_reset_mac_len(skb);
+
+		ret = hns3_get_l4_protocol(skb, &ol4_proto, &il4_proto);
+		if (unlikely(ret))
+			return ret;
+
+		ret = hns3_set_l2l3l4(skb, ol4_proto, il4_proto,
+				      &type_cs_vlan_tso,
+				      &ol_type_vlan_len_msec);
+		if (unlikely(ret))
+			return ret;
+
+		ret = hns3_set_tso(skb, &paylen, &mss,
+				   &type_cs_vlan_tso);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	/* Set txbd */
+	desc->tx.ol_type_vlan_len_msec =
+		cpu_to_le32(ol_type_vlan_len_msec);
+	desc->tx.type_cs_vlan_tso_len = cpu_to_le32(type_cs_vlan_tso);
+	desc->tx.paylen = cpu_to_le32(paylen);
+	desc->tx.mss = cpu_to_le16(mss);
+	desc->tx.vlan_tag = cpu_to_le16(inner_vtag);
+	desc->tx.outer_vlan_tag = cpu_to_le16(out_vtag);
+
+	return 0;
+}
+
 static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 			  unsigned int size, int frag_end,
 			  enum hns_desc_type type)
@@ -1045,50 +1094,12 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 
 	if (type == DESC_TYPE_SKB) {
 		struct sk_buff *skb = (struct sk_buff *)priv;
-		u32 ol_type_vlan_len_msec = 0;
-		u32 type_cs_vlan_tso = 0;
-		u32 paylen = skb->len;
-		u16 inner_vtag = 0;
-		u16 out_vtag = 0;
-		u16 mss = 0;
 		int ret;
 
-		ret = hns3_fill_desc_vtags(skb, ring, &type_cs_vlan_tso,
-					   &ol_type_vlan_len_msec,
-					   &inner_vtag, &out_vtag);
+		ret = hns3_fill_skb_desc(ring, skb, desc);
 		if (unlikely(ret))
 			return ret;
 
-		if (skb->ip_summed == CHECKSUM_PARTIAL) {
-			u8 ol4_proto, il4_proto;
-
-			skb_reset_mac_len(skb);
-
-			ret = hns3_get_l4_protocol(skb, &ol4_proto, &il4_proto);
-			if (unlikely(ret))
-				return ret;
-
-			ret = hns3_set_l2l3l4(skb, ol4_proto, il4_proto,
-					      &type_cs_vlan_tso,
-					      &ol_type_vlan_len_msec);
-			if (unlikely(ret))
-				return ret;
-
-			ret = hns3_set_tso(skb, &paylen, &mss,
-					   &type_cs_vlan_tso);
-			if (unlikely(ret))
-				return ret;
-		}
-
-		/* Set txbd */
-		desc->tx.ol_type_vlan_len_msec =
-			cpu_to_le32(ol_type_vlan_len_msec);
-		desc->tx.type_cs_vlan_tso_len =	cpu_to_le32(type_cs_vlan_tso);
-		desc->tx.paylen = cpu_to_le32(paylen);
-		desc->tx.mss = cpu_to_le16(mss);
-		desc->tx.vlan_tag = cpu_to_le16(inner_vtag);
-		desc->tx.outer_vlan_tag = cpu_to_le16(out_vtag);
-
 		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
 	} else {
 		frag = (skb_frag_t *)priv;
-- 
2.7.4

