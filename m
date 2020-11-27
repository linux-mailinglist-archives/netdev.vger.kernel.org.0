Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E5A2C612C
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgK0IsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 03:48:08 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7743 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727342AbgK0Irn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:47:43 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cj7Xw3PT6zkhBM;
        Fri, 27 Nov 2020 16:47:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Fri, 27 Nov 2020 16:47:33 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/7] net: hns3: remove unsupported NETIF_F_GSO_UDP_TUNNEL_CSUM
Date:   Fri, 27 Nov 2020 16:47:18 +0800
Message-ID: <1606466842-57749-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
References: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
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
index e022bea..850cd3fa 100644
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

