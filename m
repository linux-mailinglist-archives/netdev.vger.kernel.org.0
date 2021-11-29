Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4C246177E
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344135AbhK2OKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:10:31 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16316 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240180AbhK2OI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:08:27 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J2nCn47cWz91S4;
        Mon, 29 Nov 2021 22:04:37 +0800 (CST)
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
Subject: [PATCH net-next 09/10] net: hns3: split function hns3_handle_bdinfo()
Date:   Mon, 29 Nov 2021 22:00:26 +0800
Message-ID: <20211129140027.23036-10-huangguangbin2@huawei.com>
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

Function hns3_handle_bdinfo() is a bit too long. So add two
new functions hns3_handle_rx_ts_info() and hns3_handle_rx_vlan_tag(
to simplify code and improve code readability.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 54 ++++++++++++-------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index fe1f5ead1be4..5fc8f9dc6e3e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4043,6 +4043,39 @@ static void hns3_set_rx_skb_rss_type(struct hns3_enet_ring *ring,
 	skb_set_hash(skb, rss_hash, rss_type);
 }
 
+static void hns3_handle_rx_ts_info(struct net_device *netdev,
+				   struct hns3_desc *desc, struct sk_buff *skb,
+				   u32 bd_base_info)
+{
+	if (unlikely(bd_base_info & BIT(HNS3_RXD_TS_VLD_B))) {
+		struct hnae3_handle *h = hns3_get_handle(netdev);
+		u32 nsec = le32_to_cpu(desc->ts_nsec);
+		u32 sec = le32_to_cpu(desc->ts_sec);
+
+		if (h->ae_algo->ops->get_rx_hwts)
+			h->ae_algo->ops->get_rx_hwts(h, skb, nsec, sec);
+	}
+}
+
+static void hns3_handle_rx_vlan_tag(struct hns3_enet_ring *ring,
+				    struct hns3_desc *desc, struct sk_buff *skb,
+				    u32 l234info)
+{
+	struct net_device *netdev = ring_to_netdev(ring);
+
+	/* Based on hw strategy, the tag offloaded will be stored at
+	 * ot_vlan_tag in two layer tag case, and stored at vlan_tag
+	 * in one layer tag case.
+	 */
+	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+		u16 vlan_tag;
+
+		if (hns3_parse_vlan_tag(ring, desc, l234info, &vlan_tag))
+			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+					       vlan_tag);
+	}
+}
+
 static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 {
 	struct net_device *netdev = ring_to_netdev(ring);
@@ -4065,26 +4098,9 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	ol_info = le32_to_cpu(desc->rx.ol_info);
 	csum = le16_to_cpu(desc->csum);
 
-	if (unlikely(bd_base_info & BIT(HNS3_RXD_TS_VLD_B))) {
-		struct hnae3_handle *h = hns3_get_handle(netdev);
-		u32 nsec = le32_to_cpu(desc->ts_nsec);
-		u32 sec = le32_to_cpu(desc->ts_sec);
-
-		if (h->ae_algo->ops->get_rx_hwts)
-			h->ae_algo->ops->get_rx_hwts(h, skb, nsec, sec);
-	}
+	hns3_handle_rx_ts_info(netdev, desc, skb, bd_base_info);
 
-	/* Based on hw strategy, the tag offloaded will be stored at
-	 * ot_vlan_tag in two layer tag case, and stored at vlan_tag
-	 * in one layer tag case.
-	 */
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
-		u16 vlan_tag;
-
-		if (hns3_parse_vlan_tag(ring, desc, l234info, &vlan_tag))
-			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-					       vlan_tag);
-	}
+	hns3_handle_rx_vlan_tag(ring, desc, skb, l234info);
 
 	if (unlikely(!desc->rx.pkt_len || (l234info & (BIT(HNS3_RXD_TRUNCAT_B) |
 				  BIT(HNS3_RXD_L2E_B))))) {
-- 
2.33.0

