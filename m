Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571DF2C7051
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 19:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732863AbgK1Rzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 12:55:52 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8450 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731388AbgK1ENA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 23:13:00 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CjcxS3tVczhhdj;
        Sat, 28 Nov 2020 11:51:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Nov 2020 11:51:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 3/7] net: hns3: remove unsupported NETIF_F_GSO_UDP_TUNNEL_CSUM
Date:   Sat, 28 Nov 2020 11:51:46 +0800
Message-ID: <1606535510-44346-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
References: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, device V1 and V2 do not support segmentation
offload for UDP based tunnel packet who needs outer UDP
checksum offload, so there is a workaround in the driver
to set the checksum of the outer UDP checksum as zero. This
is not what the user wants, so remove this feature for
device V1 and V2, add support for it later(when the device
has the ability to do that).

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 904328e..34b8a7d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -723,17 +723,7 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen,
 	/* tunnel packet */
 	if (skb_shinfo(skb)->gso_type & (SKB_GSO_GRE |
 					 SKB_GSO_GRE_CSUM |
-					 SKB_GSO_UDP_TUNNEL |
-					 SKB_GSO_UDP_TUNNEL_CSUM)) {
-		if ((!(skb_shinfo(skb)->gso_type &
-		    SKB_GSO_PARTIAL)) &&
-		    (skb_shinfo(skb)->gso_type &
-		    SKB_GSO_UDP_TUNNEL_CSUM)) {
-			/* Software should clear the udp's checksum
-			 * field when tso is needed.
-			 */
-			l4.udp->check = 0;
-		}
+					 SKB_GSO_UDP_TUNNEL)) {
 		/* reset l3&l4 pointers from outer to inner headers */
 		l3.hdr = skb_inner_network_header(skb);
 		l4.hdr = skb_inner_transport_header(skb);
@@ -2357,8 +2347,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	netdev->hw_enc_features |= NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
-		NETIF_F_TSO_MANGLEID | NETIF_F_FRAGLIST;
+		NETIF_F_SCTP_CRC | NETIF_F_TSO_MANGLEID | NETIF_F_FRAGLIST;
 
 	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 
@@ -2367,23 +2356,20 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
-		NETIF_F_FRAGLIST;
+		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
 
 	netdev->vlan_features |= NETIF_F_RXCSUM |
 		NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO |
 		NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
-		NETIF_F_FRAGLIST;
+		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
 
 	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
 		NETIF_F_HW_VLAN_CTAG_RX |
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
-		NETIF_F_FRAGLIST;
+		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		netdev->hw_features |= NETIF_F_GRO_HW;
-- 
2.7.4

