Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05019465FAC
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345841AbhLBIoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:44:09 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16335 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345662AbhLBIoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:44:07 -0500
Received: from kwepemi500004.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J4Tt22G9Sz91SQ;
        Thu,  2 Dec 2021 16:40:10 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500004.china.huawei.com (7.221.188.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:43 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:43 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 2/9] net: hns3: refactor function hns3_fill_skb_desc to simplify code
Date:   Thu, 2 Dec 2021 16:35:56 +0800
Message-ID: <20211202083603.25176-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202083603.25176-1-huangguangbin2@huawei.com>
References: <20211202083603.25176-1-huangguangbin2@huawei.com>
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

From: Peng Li <lipeng321@huawei.com>

The function hns3_fill_skb_desc is hard to read, this patch
extract 2 functions and add new a struct data to simplify the
code and Improve readability.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 147 +++++++++++-------
 1 file changed, 93 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index d6336f803e36..a6e12d81949e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1544,16 +1544,29 @@ static bool hns3_check_hw_tx_csum(struct sk_buff *skb)
 	return true;
 }
 
-static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
-			      struct sk_buff *skb, struct hns3_desc *desc,
-			      struct hns3_desc_cb *desc_cb)
+struct hns3_desc_param {
+	u32 paylen_ol4cs;
+	u32 ol_type_vlan_len_msec;
+	u32 type_cs_vlan_tso;
+	u16 mss_hw_csum;
+	u16 inner_vtag;
+	u16 out_vtag;
+};
+
+static void hns3_init_desc_data(struct sk_buff *skb, struct hns3_desc_param *pa)
+{
+	pa->paylen_ol4cs = skb->len;
+	pa->ol_type_vlan_len_msec = 0;
+	pa->type_cs_vlan_tso = 0;
+	pa->mss_hw_csum = 0;
+	pa->inner_vtag = 0;
+	pa->out_vtag = 0;
+}
+
+static int hns3_handle_vlan_info(struct hns3_enet_ring *ring,
+				 struct sk_buff *skb,
+				 struct hns3_desc_param *param)
 {
-	u32 ol_type_vlan_len_msec = 0;
-	u32 paylen_ol4cs = skb->len;
-	u32 type_cs_vlan_tso = 0;
-	u16 mss_hw_csum = 0;
-	u16 inner_vtag = 0;
-	u16 out_vtag = 0;
 	int ret;
 
 	ret = hns3_handle_vtags(ring, skb);
@@ -1561,67 +1574,93 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 		hns3_ring_stats_update(ring, tx_vlan_err);
 		return ret;
 	} else if (ret == HNS3_INNER_VLAN_TAG) {
-		inner_vtag = skb_vlan_tag_get(skb);
-		inner_vtag |= (skb->priority << VLAN_PRIO_SHIFT) &
+		param->inner_vtag = skb_vlan_tag_get(skb);
+		param->inner_vtag |= (skb->priority << VLAN_PRIO_SHIFT) &
 				VLAN_PRIO_MASK;
-		hns3_set_field(type_cs_vlan_tso, HNS3_TXD_VLAN_B, 1);
+		hns3_set_field(param->type_cs_vlan_tso, HNS3_TXD_VLAN_B, 1);
 	} else if (ret == HNS3_OUTER_VLAN_TAG) {
-		out_vtag = skb_vlan_tag_get(skb);
-		out_vtag |= (skb->priority << VLAN_PRIO_SHIFT) &
+		param->out_vtag = skb_vlan_tag_get(skb);
+		param->out_vtag |= (skb->priority << VLAN_PRIO_SHIFT) &
 				VLAN_PRIO_MASK;
-		hns3_set_field(ol_type_vlan_len_msec, HNS3_TXD_OVLAN_B,
+		hns3_set_field(param->ol_type_vlan_len_msec, HNS3_TXD_OVLAN_B,
 			       1);
 	}
+	return 0;
+}
 
-	desc_cb->send_bytes = skb->len;
+static int hns3_handle_csum_partial(struct hns3_enet_ring *ring,
+				    struct sk_buff *skb,
+				    struct hns3_desc_cb *desc_cb,
+				    struct hns3_desc_param *param)
+{
+	u8 ol4_proto, il4_proto;
+	int ret;
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		u8 ol4_proto, il4_proto;
-
-		if (hns3_check_hw_tx_csum(skb)) {
-			/* set checksum start and offset, defined in 2 Bytes */
-			hns3_set_field(type_cs_vlan_tso, HNS3_TXD_CSUM_START_S,
-				       skb_checksum_start_offset(skb) >> 1);
-			hns3_set_field(ol_type_vlan_len_msec,
-				       HNS3_TXD_CSUM_OFFSET_S,
-				       skb->csum_offset >> 1);
-			mss_hw_csum |= BIT(HNS3_TXD_HW_CS_B);
-			goto out_hw_tx_csum;
-		}
+	if (hns3_check_hw_tx_csum(skb)) {
+		/* set checksum start and offset, defined in 2 Bytes */
+		hns3_set_field(param->type_cs_vlan_tso, HNS3_TXD_CSUM_START_S,
+			       skb_checksum_start_offset(skb) >> 1);
+		hns3_set_field(param->ol_type_vlan_len_msec,
+			       HNS3_TXD_CSUM_OFFSET_S,
+			       skb->csum_offset >> 1);
+		param->mss_hw_csum |= BIT(HNS3_TXD_HW_CS_B);
+		return 0;
+	}
 
-		skb_reset_mac_len(skb);
+	skb_reset_mac_len(skb);
 
-		ret = hns3_get_l4_protocol(skb, &ol4_proto, &il4_proto);
-		if (unlikely(ret < 0)) {
-			hns3_ring_stats_update(ring, tx_l4_proto_err);
-			return ret;
-		}
+	ret = hns3_get_l4_protocol(skb, &ol4_proto, &il4_proto);
+	if (unlikely(ret < 0)) {
+		hns3_ring_stats_update(ring, tx_l4_proto_err);
+		return ret;
+	}
 
-		ret = hns3_set_l2l3l4(skb, ol4_proto, il4_proto,
-				      &type_cs_vlan_tso,
-				      &ol_type_vlan_len_msec);
-		if (unlikely(ret < 0)) {
-			hns3_ring_stats_update(ring, tx_l2l3l4_err);
-			return ret;
-		}
+	ret = hns3_set_l2l3l4(skb, ol4_proto, il4_proto,
+			      &param->type_cs_vlan_tso,
+			      &param->ol_type_vlan_len_msec);
+	if (unlikely(ret < 0)) {
+		hns3_ring_stats_update(ring, tx_l2l3l4_err);
+		return ret;
+	}
+
+	ret = hns3_set_tso(skb, &param->paylen_ol4cs, &param->mss_hw_csum,
+			   &param->type_cs_vlan_tso, &desc_cb->send_bytes);
+	if (unlikely(ret < 0)) {
+		hns3_ring_stats_update(ring, tx_tso_err);
+		return ret;
+	}
+	return 0;
+}
 
-		ret = hns3_set_tso(skb, &paylen_ol4cs, &mss_hw_csum,
-				   &type_cs_vlan_tso, &desc_cb->send_bytes);
-		if (unlikely(ret < 0)) {
-			hns3_ring_stats_update(ring, tx_tso_err);
+static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
+			      struct sk_buff *skb, struct hns3_desc *desc,
+			      struct hns3_desc_cb *desc_cb)
+{
+	struct hns3_desc_param param;
+	u8 fd_op;
+	int ret;
+
+	hns3_init_desc_data(skb, &param);
+	ret = hns3_handle_vlan_info(ring, skb, &param);
+	if (unlikely(ret < 0))
+		return ret;
+
+	desc_cb->send_bytes = skb->len;
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		ret = hns3_handle_csum_partial(ring, skb, desc_cb, &param);
+		if (ret)
 			return ret;
-		}
 	}
 
-out_hw_tx_csum:
 	/* Set txbd */
 	desc->tx.ol_type_vlan_len_msec =
-		cpu_to_le32(ol_type_vlan_len_msec);
-	desc->tx.type_cs_vlan_tso_len = cpu_to_le32(type_cs_vlan_tso);
-	desc->tx.paylen_ol4cs = cpu_to_le32(paylen_ol4cs);
-	desc->tx.mss_hw_csum = cpu_to_le16(mss_hw_csum);
-	desc->tx.vlan_tag = cpu_to_le16(inner_vtag);
-	desc->tx.outer_vlan_tag = cpu_to_le16(out_vtag);
+		cpu_to_le32(param.ol_type_vlan_len_msec);
+	desc->tx.type_cs_vlan_tso_len = cpu_to_le32(param.type_cs_vlan_tso);
+	desc->tx.paylen_ol4cs = cpu_to_le32(param.paylen_ol4cs);
+	desc->tx.mss_hw_csum = cpu_to_le16(param.mss_hw_csum);
+	desc->tx.vlan_tag = cpu_to_le16(param.inner_vtag);
+	desc->tx.outer_vlan_tag = cpu_to_le16(param.out_vtag);
 
 	return 0;
 }
-- 
2.33.0

