Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA1F2C985D
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 08:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgLAHpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 02:45:41 -0500
Received: from inva020.nxp.com ([92.121.34.13]:54706 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbgLAHpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 02:45:41 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 90AA81A0A19;
        Tue,  1 Dec 2020 08:44:54 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 963781A0A2A;
        Tue,  1 Dec 2020 08:44:52 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 806174027E;
        Tue,  1 Dec 2020 08:44:49 +0100 (CET)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] dpaa_eth: copy timestamp fields to new skb in A-050385 workaround
Date:   Tue,  1 Dec 2020 15:52:58 +0800
Message-Id: <20201201075258.1875-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timestamp fields should be copied to new skb too in
A-050385 workaround for later TX timestamping handling.

Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index d9c2859..cb7c028 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2120,6 +2120,15 @@ static int dpaa_a050385_wa(struct net_device *net_dev, struct sk_buff **s)
 	skb_copy_header(new_skb, skb);
 	new_skb->dev = skb->dev;
 
+	/* Copy relevant timestamp info from the old skb to the new */
+	if (priv->tx_tstamp) {
+		skb_shinfo(new_skb)->tx_flags = skb_shinfo(skb)->tx_flags;
+		skb_shinfo(new_skb)->hwtstamps = skb_shinfo(skb)->hwtstamps;
+		skb_shinfo(new_skb)->tskey = skb_shinfo(skb)->tskey;
+		if (skb->sk)
+			skb_set_owner_w(new_skb, skb->sk);
+	}
+
 	/* We move the headroom when we align it so we have to reset the
 	 * network and transport header offsets relative to the new data
 	 * pointer. The checksum offload relies on these offsets.
@@ -2127,7 +2136,6 @@ static int dpaa_a050385_wa(struct net_device *net_dev, struct sk_buff **s)
 	skb_set_network_header(new_skb, skb_network_offset(skb));
 	skb_set_transport_header(new_skb, skb_transport_offset(skb));
 
-	/* TODO: does timestamping need the result in the old skb? */
 	dev_kfree_skb(skb);
 	*s = new_skb;
 
-- 
2.7.4

