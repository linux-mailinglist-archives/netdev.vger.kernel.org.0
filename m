Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6EA125025F
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 18:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgHXQbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 12:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgHXQas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 12:30:48 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925D8C061575
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 09:30:47 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c5970d68d0e0160e8a82c5fd76.dip0.t-ipconnect.de [IPv6:2003:c5:970d:68d0:e016:e8a:82c5:fd76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 64F0E6206D;
        Mon, 24 Aug 2020 18:21:15 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Jussi Kivilinna <jussi.kivilinna@haltian.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/3] batman-adv: bla: use netif_rx_ni when not in interrupt context
Date:   Mon, 24 Aug 2020 18:21:11 +0200
Message-Id: <20200824162111.29220-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200824162111.29220-1-sw@simonwunderlich.de>
References: <20200824162111.29220-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jussi Kivilinna <jussi.kivilinna@haltian.com>

batadv_bla_send_claim() gets called from worker thread context through
batadv_bla_periodic_work(), thus netif_rx_ni needs to be used in that
case. This fixes "NOHZ: local_softirq_pending 08" log messages seen
when batman-adv is enabled.

Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@haltian.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bridge_loop_avoidance.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 91a04ca373dc..8500f56cbd10 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -437,7 +437,10 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
 	batadv_add_counter(bat_priv, BATADV_CNT_RX_BYTES,
 			   skb->len + ETH_HLEN);
 
-	netif_rx(skb);
+	if (in_interrupt())
+		netif_rx(skb);
+	else
+		netif_rx_ni(skb);
 out:
 	if (primary_if)
 		batadv_hardif_put(primary_if);
-- 
2.20.1

