Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B904647DD14
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346654AbhLWBPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:48 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27464 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346266AbhLWBOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=2c/X1EdWX/aLwBtKGFM16h0YJReLWDvNVnx1yZUKCwI=;
        b=Ck5t/Ozis0iqs/wTDS19vBodqbA5azVMtX0IYMOAfnjZPMWpLM3wtUoCHIRq8nFEHhEx
        jjmQuiSAxYxnoI8nqAjoHfzkRLcMkHYl6gDP158+b5Hcp/oGfWqVN2pjVWG7WDpAhP6g9s
        U5o8meQAOFrixEsD5v9I2uWiL9hoecO8R+Wnie1sDW2KXxJYwJ+zGhUQN/3myPz5UmURld
        fc2Y3k+cswTjkvDAoLJDjHUvDOFECjiJypygGFxTAK6tAq1rJJlSDDjlZSKiu9ruEpHWdY
        RO/6R7HzeUvCDOoUPLgToQnzKTjrAK9pC2f8cRV02U6RcogmGOa2l0uhctvkYr5w==
Received: by filterdrecv-75ff7b5ffb-ndqvq with SMTP id filterdrecv-75ff7b5ffb-ndqvq-1-61C3CD5F-5
        2021-12-23 01:14:07.082131275 +0000 UTC m=+9687225.682526901
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-canary-0 (SG)
        with ESMTP
        id p8gjty75SwG8apQHg0pwTw
        Thu, 23 Dec 2021 01:14:06.926 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id B72FD7009E9; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 36/50] wilc1000: introduce transmit path chip queue
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-37-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvEhJic2zkDB1r+fbU?=
 =?us-ascii?Q?c8nmpgeA7v6NrfJJORVx0hnOWe=2F=2FipO5kL0BYhA?=
 =?us-ascii?Q?sRVAYQ+iZyXl2JaXGGqJdDuCTqpBdy+2Ei+UQMX?=
 =?us-ascii?Q?cfGmYFWbsaRUl1YhSwlc=2Fg7qLO6YiF2fGzntnOl?=
 =?us-ascii?Q?tpefjMvEN6IsHer7SEIGC1EXB8LVZMVYJuDhVP?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces a chip queue that will hold packets ready to be
transferred to the chip.  A later patch will start using it.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/cfg80211.c |  3 +++
 .../net/wireless/microchip/wilc1000/netdev.h   | 18 ++++++++++++++++++
 drivers/net/wireless/microchip/wilc1000/wlan.c |  5 +++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index 6f19dee813f2a..6d3635864569f 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1716,6 +1716,9 @@ int wilc_cfg80211_init(struct wilc **wilc, struct device *dev, int io_type,
 	for (i = 0; i < NQUEUES; i++)
 		skb_queue_head_init(&wl->txq[i]);
 
+	skb_queue_head_init(&wl->chipq);
+	wl->chipq_bytes = 0;
+
 	INIT_LIST_HEAD(&wl->rxq_head.list);
 	INIT_LIST_HEAD(&wl->vif_list);
 
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index 82f38a0e20214..e168f8644c678 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -261,6 +261,24 @@ struct wilc {
 	struct wilc_tx_queue_status tx_q_limit;
 	struct rxq_entry_t rxq_head;
 
+	/* The chip queue contains sk_buffs that are ready to be
+	 * transferred to the wilc1000 chip.  In particular, they
+	 * already have the VMM and Ethernet headers (for net packets)
+	 * and they are padded to a size that is an integer-multiple
+	 * of 4 bytes.
+	 *
+	 * This queue is usually empty on return from
+	 * wilc_wlan_handle_txq().  However, when the chip does fill
+	 * up, the packets that didn't fit will be held until there is
+	 * space again.
+	 *
+	 * This queue is only accessed by the txq handler thread, so
+	 * no locking is required.
+	 */
+	struct sk_buff_head chipq;
+	/* Total number of bytes queued on the chipq: */
+	int chipq_bytes;
+
 	const struct firmware *firmware;
 
 	struct device *dev;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 18b1e7fad4d71..c3802a34defed 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1263,6 +1263,11 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	struct wilc *wilc = vif->wilc;
 
 	wilc->quit = 1;
+
+	while ((tqe = __skb_dequeue(&wilc->chipq)))
+		wilc_wlan_tx_packet_done(tqe, 0);
+	wilc->chipq_bytes = 0;
+
 	for (ac = 0; ac < NQUEUES; ac++) {
 		while ((tqe = skb_dequeue(&wilc->txq[ac])))
 			wilc_wlan_tx_packet_done(tqe, 0);
-- 
2.25.1

