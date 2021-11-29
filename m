Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22625461780
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348983AbhK2OKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:10:35 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:28124 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240286AbhK2OI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:08:28 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J2n9K6TsQz1DJm0;
        Mon, 29 Nov 2021 22:02:29 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:08 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 22:05:08 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 10/10] net: hns3: split function hns3_set_l2l3l4()
Date:   Mon, 29 Nov 2021 22:00:27 +0800
Message-ID: <20211129140027.23036-11-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211129140027.23036-1-huangguangbin2@huawei.com>
References: <20211129140027.23036-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Function hns3_set_l2l3l4() is a bit too long. So add two
new functions hns3_set_l3_type() and hns3_set_l4_csum_length()
to simplify code and improve code readability.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 102 ++++++++++--------
 1 file changed, 57 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5fc8f9dc6e3e..8c7707263f9d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1355,44 +1355,9 @@ static void hns3_set_outer_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 			       HNS3_TUN_NVGRE);
 }
 
-static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
-			   u8 il4_proto, u32 *type_cs_vlan_tso,
-			   u32 *ol_type_vlan_len_msec)
+static void hns3_set_l3_type(struct sk_buff *skb, union l3_hdr_info l3,
+			     u32 *type_cs_vlan_tso)
 {
-	unsigned char *l2_hdr = skb->data;
-	u32 l4_proto = ol4_proto;
-	union l4_hdr_info l4;
-	union l3_hdr_info l3;
-	u32 l2_len, l3_len;
-
-	l4.hdr = skb_transport_header(skb);
-	l3.hdr = skb_network_header(skb);
-
-	/* handle encapsulation skb */
-	if (skb->encapsulation) {
-		/* If this is a not UDP/GRE encapsulation skb */
-		if (!(ol4_proto == IPPROTO_UDP || ol4_proto == IPPROTO_GRE)) {
-			/* drop the skb tunnel packet if hardware don't support,
-			 * because hardware can't calculate csum when TSO.
-			 */
-			if (skb_is_gso(skb))
-				return -EDOM;
-
-			/* the stack computes the IP header already,
-			 * driver calculate l4 checksum when not TSO.
-			 */
-			return skb_checksum_help(skb);
-		}
-
-		hns3_set_outer_l2l3l4(skb, ol4_proto, ol_type_vlan_len_msec);
-
-		/* switch to inner header */
-		l2_hdr = skb_inner_mac_header(skb);
-		l3.hdr = skb_inner_network_header(skb);
-		l4.hdr = skb_inner_transport_header(skb);
-		l4_proto = il4_proto;
-	}
-
 	if (l3.v4->version == 4) {
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3T_S,
 			       HNS3_L3T_IPV4);
@@ -1406,15 +1371,11 @@ static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3T_S,
 			       HNS3_L3T_IPV6);
 	}
+}
 
-	/* compute inner(/normal) L2 header size, defined in 2 Bytes */
-	l2_len = l3.hdr - l2_hdr;
-	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L2LEN_S, l2_len >> 1);
-
-	/* compute inner(/normal) L3 header size, defined in 4 Bytes */
-	l3_len = l4.hdr - l3.hdr;
-	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3LEN_S, l3_len >> 2);
-
+static int hns3_set_l4_csum_length(struct sk_buff *skb, union l4_hdr_info l4,
+				   u32 l4_proto, u32 *type_cs_vlan_tso)
+{
 	/* compute inner(/normal) L4 header size, defined in 4 Bytes */
 	switch (l4_proto) {
 	case IPPROTO_TCP:
@@ -1460,6 +1421,57 @@ static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 	return 0;
 }
 
+static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
+			   u8 il4_proto, u32 *type_cs_vlan_tso,
+			   u32 *ol_type_vlan_len_msec)
+{
+	unsigned char *l2_hdr = skb->data;
+	u32 l4_proto = ol4_proto;
+	union l4_hdr_info l4;
+	union l3_hdr_info l3;
+	u32 l2_len, l3_len;
+
+	l4.hdr = skb_transport_header(skb);
+	l3.hdr = skb_network_header(skb);
+
+	/* handle encapsulation skb */
+	if (skb->encapsulation) {
+		/* If this is a not UDP/GRE encapsulation skb */
+		if (!(ol4_proto == IPPROTO_UDP || ol4_proto == IPPROTO_GRE)) {
+			/* drop the skb tunnel packet if hardware don't support,
+			 * because hardware can't calculate csum when TSO.
+			 */
+			if (skb_is_gso(skb))
+				return -EDOM;
+
+			/* the stack computes the IP header already,
+			 * driver calculate l4 checksum when not TSO.
+			 */
+			return skb_checksum_help(skb);
+		}
+
+		hns3_set_outer_l2l3l4(skb, ol4_proto, ol_type_vlan_len_msec);
+
+		/* switch to inner header */
+		l2_hdr = skb_inner_mac_header(skb);
+		l3.hdr = skb_inner_network_header(skb);
+		l4.hdr = skb_inner_transport_header(skb);
+		l4_proto = il4_proto;
+	}
+
+	hns3_set_l3_type(skb, l3, type_cs_vlan_tso);
+
+	/* compute inner(/normal) L2 header size, defined in 2 Bytes */
+	l2_len = l3.hdr - l2_hdr;
+	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L2LEN_S, l2_len >> 1);
+
+	/* compute inner(/normal) L3 header size, defined in 4 Bytes */
+	l3_len = l4.hdr - l3.hdr;
+	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L3LEN_S, l3_len >> 2);
+
+	return hns3_set_l4_csum_length(skb, l4, l4_proto, type_cs_vlan_tso);
+}
+
 static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 			     struct sk_buff *skb)
 {
-- 
2.33.0

