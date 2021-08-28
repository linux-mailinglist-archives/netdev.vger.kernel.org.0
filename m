Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8F93FA638
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 16:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhH1OY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 10:24:28 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:47353 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhH1OY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 10:24:28 -0400
Received: from localhost.localdomain ([37.4.249.97]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MjgfT-1mi5ae3ePL-00lF7L; Sat, 28 Aug 2021 16:23:27 +0200
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Heimpold <michael.heimpold@in-tech.com>,
        netdev@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH net] net: qualcomm: fix QCA7000 checksum handling
Date:   Sat, 28 Aug 2021 16:23:15 +0200
Message-Id: <20210828142315.7971-1-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.17.1
X-Provags-ID: V03:K1:t99F4Kem/3fgJ7Z22us0H2MugnPBvjfohIjoJBoYg0Nfifm2r3p
 7fWSU8qAyecGuhr6MXmf/iME0Vb3OXXw5ER/WF+6doDRqVGEPlIkgWRtgNgsmC4sz+9uIJE
 z9BFhIqVQceWv5VNfm5soK0g8ZRJMjYDRzUxhD7ChMouy7izZsD+sGI5OipzIr7+qFMZGCm
 5JDjPrLR/PM60Rih4bzrQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rjzky3zIXWQ=:dqV1qkWmp2n0h6WcYlNx6g
 SdTWTeE2U2r2FBcTCKS+CSH7+DkTQF5NI0wBl6OkCOWs8JB0tUlaSzUpDAgK9chRgLwyOciNQ
 +TLFYHT+vNpU3xkArIM00CX0qBz4CA44DXDRjiYJrB9RovRxf/+lxPj5ZVcm4NnD40p6qGHO3
 N9gc1wOwGccEYBnXSOiNlgwBlrIgBc+lvBk7axU9mHhl4NNXNc+Ts+xEHoudM6MRY+p2OavPW
 GsANLlDnG47xU2gy7pFw+St+rD3z+hNp5rPp1biEuivDi2c58xYM0ums6rYjXEw0L1G0ok//O
 mcX7ptWhIElgnfP1E9E0givQ3yuVZibGhLL+ZeDcv0ENoWrwBLZJLx7oKpGtfjqfts7R1LQ9A
 /QoMBoQIh2ujrmPsYUV+mKNkpPLgBfeyut9WkDQss4qNthFILun+GSpiUVU/POgvpneZmnZ2T
 cY8gkKgbYNCrwRTy3CuN4k85wBwlxWy42aKopVDf2l8Lue2jfrTLF/FnjeWlO/h55EaVxN1q9
 hUpLXQNtIlwT2Hr28VhdVVPQIExXPa/xq9uXDf2csGEph3Jj4Y/vQmI18qhmmfyIUiNLKs2x+
 6FM+4c1XqfNh0YjvaDmVUUgb6pwjA4lQoMIhmQntjSd0mSEWdBuVCi2HIq8Ui48UXn/p7xa+1
 HmE1uPDIArSQUTCv4xuQVGG1d1BGrMXIeWwr2TRKkxCiolqFmy/IMa4nwQ2Lz9bC+2u1Ud+0J
 X5dJqqR5/AhI8FYApCsSDCByVoQKYovibtr+Wg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on tests the QCA7000 doesn't support checksum offloading. So assume
ip_summed is CHECKSUM_NONE and let the kernel take care of the checksum
handling. This fixes data transfer issues in noisy environments.

Reported-by: Michael Heimpold <michael.heimpold@in-tech.com>
Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 drivers/net/ethernet/qualcomm/qca_spi.c  | 2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index b64c254e00ba..8427fe1b8fd1 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -434,7 +434,7 @@ qcaspi_receive(struct qcaspi *qca)
 				skb_put(qca->rx_skb, retcode);
 				qca->rx_skb->protocol = eth_type_trans(
 					qca->rx_skb, qca->rx_skb->dev);
-				qca->rx_skb->ip_summed = CHECKSUM_UNNECESSARY;
+				skb_checksum_none_assert(qca->rx_skb);
 				netif_rx_ni(qca->rx_skb);
 				qca->rx_skb = netdev_alloc_skb_ip_align(net_dev,
 					net_dev->mtu + VLAN_ETH_HLEN);
diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ethernet/qualcomm/qca_uart.c
index bcdeca7b3366..ce3f7ce31adc 100644
--- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -107,7 +107,7 @@ qca_tty_receive(struct serdev_device *serdev, const unsigned char *data,
 			skb_put(qca->rx_skb, retcode);
 			qca->rx_skb->protocol = eth_type_trans(
 						qca->rx_skb, qca->rx_skb->dev);
-			qca->rx_skb->ip_summed = CHECKSUM_UNNECESSARY;
+			skb_checksum_none_assert(qca->rx_skb);
 			netif_rx_ni(qca->rx_skb);
 			qca->rx_skb = netdev_alloc_skb_ip_align(netdev,
 								netdev->mtu +
-- 
2.17.1

