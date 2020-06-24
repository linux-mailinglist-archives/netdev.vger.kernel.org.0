Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04794207F1F
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 00:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389973AbgFXWGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 18:06:25 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:37289 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389522AbgFXWGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 18:06:21 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c7740185;
        Wed, 24 Jun 2020 21:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=PTK10ChOSlmzM9Yfrj6GYKHJz
        yc=; b=dIrvSI0care4Ys/MHePuvJGjcFmjd3o1ipGaZ0lFITXLKLcv7gflJg+va
        kfFPSbEeLeN4nwnyk2ER2WyDgdil0Tg/rTDQDxHnA74dsj7ChTXVuiYXj0a+J3Qp
        Ab1iSsguMx99g7CjhDbguzuhcaIJa26h8bodYwjNnZNssTKTwzu5EcwDeGvXwbjU
        /D5WPnAs4YEmS5tmS7KChAXLmfPFO/OhaUV5fRButbDdmTSS/eDzIQTCjDXj5v9m
        rsVqLLjofXm78Fa1752wYxaMnuY35dUtUqXWJZCT8MBFSLBzpD1yPOn/c/BD5/DZ
        tWSkSuhZsNfhlVJN/YpIA3lrZ9xig==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0aa511e2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 24 Jun 2020 21:47:14 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 4/4] wil6210: account for napi_gro_receive never returning GRO_DROP
Date:   Wed, 24 Jun 2020 16:06:06 -0600
Message-Id: <20200624220606.1390542-5-Jason@zx2c4.com>
In-Reply-To: <20200624220606.1390542-1-Jason@zx2c4.com>
References: <20200624220606.1390542-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The napi_gro_receive function no longer returns GRO_DROP ever, making
handling GRO_DROP dead code. This commit removes that dead code.
Further, it's not even clear that device drivers have any business in
taking action after passing off received packets; that's arguably out of
their hands. In this case, too, the non-gro path didn't bother checking
the return value. Plus, this had some clunky debugging functions that
duplicated code from elsewhere and was generally pretty messy. So, this
commit cleans that all up too.

Fixes: 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 39 +++++++------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index bc8c15fb609d..080e5aa60bea 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -897,7 +897,6 @@ static void wil_rx_handle_eapol(struct wil6210_vif *vif, struct sk_buff *skb)
 void wil_netif_rx(struct sk_buff *skb, struct net_device *ndev, int cid,
 		  struct wil_net_stats *stats, bool gro)
 {
-	gro_result_t rc = GRO_NORMAL;
 	struct wil6210_vif *vif = ndev_to_vif(ndev);
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 	struct wireless_dev *wdev = vif_to_wdev(vif);
@@ -908,22 +907,16 @@ void wil_netif_rx(struct sk_buff *skb, struct net_device *ndev, int cid,
 	 */
 	int mcast = is_multicast_ether_addr(da);
 	struct sk_buff *xmit_skb = NULL;
-	static const char * const gro_res_str[] = {
-		[GRO_MERGED]		= "GRO_MERGED",
-		[GRO_MERGED_FREE]	= "GRO_MERGED_FREE",
-		[GRO_HELD]		= "GRO_HELD",
-		[GRO_NORMAL]		= "GRO_NORMAL",
-		[GRO_DROP]		= "GRO_DROP",
-		[GRO_CONSUMED]		= "GRO_CONSUMED",
-	};
 
 	if (wdev->iftype == NL80211_IFTYPE_STATION) {
 		sa = wil_skb_get_sa(skb);
 		if (mcast && ether_addr_equal(sa, ndev->dev_addr)) {
 			/* mcast packet looped back to us */
-			rc = GRO_DROP;
 			dev_kfree_skb(skb);
-			goto stats;
+			ndev->stats.rx_dropped++;
+			stats->rx_dropped++;
+			wil_dbg_txrx(wil, "Rx drop %d bytes\n", len);
+			return;
 		}
 	} else if (wdev->iftype == NL80211_IFTYPE_AP && !vif->ap_isolate) {
 		if (mcast) {
@@ -967,26 +960,16 @@ void wil_netif_rx(struct sk_buff *skb, struct net_device *ndev, int cid,
 			wil_rx_handle_eapol(vif, skb);
 
 		if (gro)
-			rc = napi_gro_receive(&wil->napi_rx, skb);
+			napi_gro_receive(&wil->napi_rx, skb);
 		else
 			netif_rx_ni(skb);
-		wil_dbg_txrx(wil, "Rx complete %d bytes => %s\n",
-			     len, gro_res_str[rc]);
-	}
-stats:
-	/* statistics. rc set to GRO_NORMAL for AP bridging */
-	if (unlikely(rc == GRO_DROP)) {
-		ndev->stats.rx_dropped++;
-		stats->rx_dropped++;
-		wil_dbg_txrx(wil, "Rx drop %d bytes\n", len);
-	} else {
-		ndev->stats.rx_packets++;
-		stats->rx_packets++;
-		ndev->stats.rx_bytes += len;
-		stats->rx_bytes += len;
-		if (mcast)
-			ndev->stats.multicast++;
 	}
+	ndev->stats.rx_packets++;
+	stats->rx_packets++;
+	ndev->stats.rx_bytes += len;
+	stats->rx_bytes += len;
+	if (mcast)
+		ndev->stats.multicast++;
 }
 
 void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
-- 
2.27.0

