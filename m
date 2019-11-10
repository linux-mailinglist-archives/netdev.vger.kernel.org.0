Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63758F6230
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 03:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfKJCkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:40:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbfKJCko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9B8A214E0;
        Sun, 10 Nov 2019 02:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353642;
        bh=s64GRie63AvxpCh2Q6I1WlA90S7QTrxx/6sBq6jqZvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bYwrobiatQhejy9OcAZ+ptyeHgIB446T92lUcV9XUYAM05k5RjOlnPaR2Q50B9Zfk
         MM2XXTQzKPtKn6CPIBNII+/djmJqlGc6mIPTb0RK2b7yg5uv8MqIyzzZhLLX5Sz4fZ
         F7YrGrZLLYxy6diDFHZr8st7h9I4UhUJNIkPeo6c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 024/191] net: cavium: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:37:26 -0500
Message-Id: <20191110024013.29782-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit ac1172dea10b6ba51de9346d3130db688b5196c5 ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c    | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c  | 5 +++--
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   | 5 +++--
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 6fb13fa73b271..304e4b9436276 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2324,7 +2324,7 @@ static inline int send_nic_timestamp_pkt(struct octeon_device *oct,
  * @returns whether the packet was transmitted to the device okay or not
  *             (NETDEV_TX_OK or NETDEV_TX_BUSY)
  */
-static int liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct lio *lio;
 	struct octnet_buf_free_info *finfo;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index b77835724dc84..d83773bc0dd7f 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1390,7 +1390,7 @@ static int send_nic_timestamp_pkt(struct octeon_device *oct,
  * @returns whether the packet was transmitted to the device okay or not
  *             (NETDEV_TX_OK or NETDEV_TX_BUSY)
  */
-static int liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct octnet_buf_free_info *finfo;
 	union octnic_cmd_setup cmdsetup;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
index c99b59fe4c8fb..a1bda1683ebfc 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -31,7 +31,8 @@
 
 static int lio_vf_rep_open(struct net_device *ndev);
 static int lio_vf_rep_stop(struct net_device *ndev);
-static int lio_vf_rep_pkt_xmit(struct sk_buff *skb, struct net_device *ndev);
+static netdev_tx_t lio_vf_rep_pkt_xmit(struct sk_buff *skb,
+				       struct net_device *ndev);
 static void lio_vf_rep_tx_timeout(struct net_device *netdev);
 static int lio_vf_rep_phys_port_name(struct net_device *dev,
 				     char *buf, size_t len);
@@ -382,7 +383,7 @@ lio_vf_rep_packet_sent_callback(struct octeon_device *oct,
 		netif_wake_queue(ndev);
 }
 
-static int
+static netdev_tx_t
 lio_vf_rep_pkt_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct lio_vf_rep_desc *vf_rep = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index bb43ddb7539e7..4b3aecf98f2af 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1268,12 +1268,13 @@ static int octeon_mgmt_stop(struct net_device *netdev)
 	return 0;
 }
 
-static int octeon_mgmt_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t
+octeon_mgmt_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct octeon_mgmt *p = netdev_priv(netdev);
 	union mgmt_port_ring_entry re;
 	unsigned long flags;
-	int rv = NETDEV_TX_BUSY;
+	netdev_tx_t rv = NETDEV_TX_BUSY;
 
 	re.d64 = 0;
 	re.s.tstamp = ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) != 0);
-- 
2.20.1

