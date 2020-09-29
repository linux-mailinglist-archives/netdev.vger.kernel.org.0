Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBD727C153
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgI2Jex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:34:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727814AbgI2Jew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 05:34:52 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A15D32C30213399210C3;
        Tue, 29 Sep 2020 17:34:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:34:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/7] net: hns3: add UDP segmentation offload support
Date:   Tue, 29 Sep 2020 17:32:01 +0800
Message-ID: <1601371925-49426-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
References: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for UDP segmentation offload to the HNS3 driver
when the device can do it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index df52abb..a362516 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -696,12 +696,19 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen,
 
 	/* normal or tunnel packet */
 	l4_offset = l4.hdr - skb->data;
-	hdr_len = (l4.tcp->doff << 2) + l4_offset;
 
 	/* remove payload length from inner pseudo checksum when tso */
 	l4_paylen = skb->len - l4_offset;
-	csum_replace_by_diff(&l4.tcp->check,
-			     (__force __wsum)htonl(l4_paylen));
+
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+		hdr_len = sizeof(*l4.udp) + l4_offset;
+		csum_replace_by_diff(&l4.udp->check,
+				     (__force __wsum)htonl(l4_paylen));
+	} else {
+		hdr_len = (l4.tcp->doff << 2) + l4_offset;
+		csum_replace_by_diff(&l4.tcp->check,
+				     (__force __wsum)htonl(l4_paylen));
+	}
 
 	/* find the txbd field values */
 	*paylen = skb->len - hdr_len;
@@ -2311,6 +2318,13 @@ static void hns3_set_default_feature(struct net_device *netdev)
 			netdev->features |= NETIF_F_NTUPLE;
 		}
 	}
+
+	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps)) {
+		netdev->hw_features |= NETIF_F_GSO_UDP_L4;
+		netdev->features |= NETIF_F_GSO_UDP_L4;
+		netdev->vlan_features |= NETIF_F_GSO_UDP_L4;
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_L4;
+	}
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
-- 
2.7.4

