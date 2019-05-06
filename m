Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E5C143A1
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 04:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfEFCuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 22:50:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726128AbfEFCuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 22:50:20 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9B862AD836BE2DAB8F8C;
        Mon,  6 May 2019 10:50:18 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 May 2019 10:50:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <nhorman@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 06/12] net: hns3: refactor BD filling for l2l3l4 info
Date:   Mon, 6 May 2019 10:48:46 +0800
Message-ID: <1557110932-683-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
References: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

This patch separates the inner and outer l2l3l4 len handling in
hns3_set_l2l3l4_len, this is a preparation to combine the l2l3l4
len and checksum handling for inner and outer header.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 62 +++++++++----------------
 1 file changed, 23 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 14312ff..9170743 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -741,65 +741,49 @@ static void hns3_set_l2l3l4_len(struct sk_buff *skb, u8 ol4_proto,
 				u8 il4_proto, u32 *type_cs_vlan_tso,
 				u32 *ol_type_vlan_len_msec)
 {
+	unsigned char *l2_hdr = skb->data;
+	u8 l4_proto = ol4_proto;
 	union l3_hdr_info l3;
 	union l4_hdr_info l4;
-	unsigned char *l2_hdr;
-	u8 l4_proto = ol4_proto;
-	u32 ol2_len;
-	u32 ol3_len;
-	u32 ol4_len;
 	u32 l2_len;
 	u32 l3_len;
+	u32 l4_len;
 
 	l3.hdr = skb_network_header(skb);
 	l4.hdr = skb_transport_header(skb);
 
-	/* compute L2 header size for normal packet, defined in 2 Bytes */
-	l2_len = l3.hdr - skb->data;
-	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L2LEN_S, l2_len >> 1);
-
-	/* tunnel packet*/
+	/* tunnel packet */
 	if (skb->encapsulation) {
+		/* not MAC in UDP, MAC in GRE (0x6558) */
+		if (!(ol4_proto == IPPROTO_UDP || ol4_proto == IPPROTO_GRE))
+			return;
+
 		/* compute OL2 header size, defined in 2 Bytes */
-		ol2_len = l2_len;
+		l2_len = l3.hdr - skb->data;
 		hns3_set_field(*ol_type_vlan_len_msec,
-			       HNS3_TXD_L2LEN_S, ol2_len >> 1);
+			       HNS3_TXD_L2LEN_S, l2_len >> 1);
 
 		/* compute OL3 header size, defined in 4 Bytes */
-		ol3_len = l4.hdr - l3.hdr;
+		l3_len = l4.hdr - l3.hdr;
 		hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_L3LEN_S,
-			       ol3_len >> 2);
-
-		/* MAC in UDP, MAC in GRE (0x6558)*/
-		if ((ol4_proto == IPPROTO_UDP) || (ol4_proto == IPPROTO_GRE)) {
-			/* switch MAC header ptr from outer to inner header.*/
-			l2_hdr = skb_inner_mac_header(skb);
-
-			/* compute OL4 header size, defined in 4 Bytes. */
-			ol4_len = l2_hdr - l4.hdr;
-			hns3_set_field(*ol_type_vlan_len_msec,
-				       HNS3_TXD_L4LEN_S, ol4_len >> 2);
+			       l3_len >> 2);
 
-			/* switch IP header ptr from outer to inner header */
-			l3.hdr = skb_inner_network_header(skb);
+		l2_hdr = skb_inner_mac_header(skb);
+		/* compute OL4 header size, defined in 4 Bytes. */
+		l4_len = l2_hdr - l4.hdr;
+		hns3_set_field(*ol_type_vlan_len_msec, HNS3_TXD_L4LEN_S,
+			       l4_len >> 2);
 
-			/* compute inner l2 header size, defined in 2 Bytes. */
-			l2_len = l3.hdr - l2_hdr;
-			hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L2LEN_S,
-				       l2_len >> 1);
-		} else {
-			/* skb packet types not supported by hardware,
-			 * txbd len fild doesn't be filled.
-			 */
-			return;
-		}
-
-		/* switch L4 header pointer from outer to inner */
+		/* switch to inner header */
+		l2_hdr = skb_inner_mac_header(skb);
+		l3.hdr = skb_inner_network_header(skb);
 		l4.hdr = skb_inner_transport_header(skb);
-
 		l4_proto = il4_proto;
 	}
 
+	l2_len = l3.hdr - l2_hdr;
+	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L2LEN_S, l2_len >> 1);
+
 	/* compute inner(/normal) L3 header size, defined in 4 Bytes */
 	l3_len = l4.hdr - l3.hdr;
 	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3LEN_S, l3_len >> 2);
-- 
2.7.4

