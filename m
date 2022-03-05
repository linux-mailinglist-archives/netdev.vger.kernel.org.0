Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD494CE76A
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 23:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiCEWO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 17:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbiCEWOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 17:14:12 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED957546B9;
        Sat,  5 Mar 2022 14:13:20 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646518397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TkzgyQfLm9kgDQ+XkWUyxZ9Qb4QCMdrdNbG7RC3fSuo=;
        b=XPK0RYIkEUhncesPY4LaN2z9zIftmH0UNFoO38lMyeIrVP0wZeYIb12Tf4fboKLegtoX+L
        HJ9k64vkXo+dDTW8rTt4/3CibMsZCtY69ts9eL/w2qzGPBd0Gk0jvd0mp0uc/4wUtI51oZ
        8gS4VCOnSjaEcQ6Hy72xQqQTFrBptOxLKQVNrq+h/yBvUst8DQ8k3sbvwyEhai1n7gQNQu
        8MJjANtRPCMlQj6LXZFkYrG9IxeZOYVYMVebNCd64sAaNYFr3AuinOWfSRTpLm+++YvToO
        j0oG5yWutXYc0rB8IBEw7qCsAtG832IHhleV9K7nqD1wjwEagRtqHJR3BEnSrw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646518397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TkzgyQfLm9kgDQ+XkWUyxZ9Qb4QCMdrdNbG7RC3fSuo=;
        b=qaFLfpKKnhAPRk+X569zRjNP1y/QctQQMS7icYLGKif1PaDoMTk9DeJc/drpxKb4deIqLD
        32wPHcoCsxeiySCA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Arend van Spriel <aspriel@gmail.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com,
        Wright Feng <wright.feng@infineon.com>,
        brcm80211-dev-list.pdl@broadcom.com, linux-wireless@vger.kernel.org
Subject: [PATCH net-next 6/8] wireless: brcmfmac: Use netif_rx().
Date:   Sat,  5 Mar 2022 23:12:50 +0100
Message-Id: <20220305221252.3063812-7-bigeasy@linutronix.de>
In-Reply-To: <20220305221252.3063812-1-bigeasy@linutronix.de>
References: <20220305221252.3063812-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit
   baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any co=
ntext.")

the function netif_rx() can be used in preemptible/thread context as
well as in interrupt context.

Use netif_rx().

Cc: Arend van Spriel <aspriel@gmail.com>
Cc: Chi-hsien Lin <chi-hsien.lin@infineon.com>
Cc: Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: SHA-cyfmac-dev-list@infineon.com
Cc: Wright Feng <wright.feng@infineon.com>
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 .../broadcom/brcm80211/brcmfmac/bcdc.c         |  4 ++--
 .../broadcom/brcm80211/brcmfmac/core.c         | 18 +++++-------------
 .../broadcom/brcm80211/brcmfmac/core.h         |  2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c     | 10 +++++-----
 .../broadcom/brcm80211/brcmfmac/fwsignal.h     |  2 +-
 .../broadcom/brcm80211/brcmfmac/msgbuf.c       |  5 ++---
 .../broadcom/brcm80211/brcmfmac/proto.h        |  6 +++---
 7 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 3984fd7d918e1..2c95a08a58711 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -397,9 +397,9 @@ brcmf_proto_bcdc_add_tdls_peer(struct brcmf_pub *drvr, =
int ifidx,
 }
=20
 static void brcmf_proto_bcdc_rxreorder(struct brcmf_if *ifp,
-				       struct sk_buff *skb, bool inirq)
+				       struct sk_buff *skb)
 {
-	brcmf_fws_rxreorder(ifp, skb, inirq);
+	brcmf_fws_rxreorder(ifp, skb);
 }
=20
 static void
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index fed9cd5f29a26..26fab4bee22cf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -400,7 +400,7 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 	spin_unlock_irqrestore(&ifp->netif_stop_lock, flags);
 }
=20
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb, bool inirq)
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 {
 	/* Most of Broadcom's firmwares send 802.11f ADD frame every time a new
 	 * STA connects to the AP interface. This is an obsoleted standard most
@@ -423,15 +423,7 @@ void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_bu=
ff *skb, bool inirq)
 	ifp->ndev->stats.rx_packets++;
=20
 	brcmf_dbg(DATA, "rx proto=3D0x%X\n", ntohs(skb->protocol));
-	if (inirq) {
-		netif_rx(skb);
-	} else {
-		/* If the receive is not processed inside an ISR,
-		 * the softirqd must be woken explicitly to service
-		 * the NET_RX_SOFTIRQ.  This is handled by netif_rx_ni().
-		 */
-		netif_rx_ni(skb);
-	}
+	netif_rx(skb);
 }
=20
 void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb)
@@ -480,7 +472,7 @@ void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk=
_buff *skb)
 	skb->pkt_type =3D PACKET_OTHERHOST;
 	skb->protocol =3D htons(ETH_P_802_2);
=20
-	brcmf_netif_rx(ifp, skb, false);
+	brcmf_netif_rx(ifp, skb);
 }
=20
 static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
@@ -515,7 +507,7 @@ void brcmf_rx_frame(struct device *dev, struct sk_buff =
*skb, bool handle_event,
 		return;
=20
 	if (brcmf_proto_is_reorder_skb(skb)) {
-		brcmf_proto_rxreorder(ifp, skb, inirq);
+		brcmf_proto_rxreorder(ifp, skb);
 	} else {
 		/* Process special event packets */
 		if (handle_event) {
@@ -524,7 +516,7 @@ void brcmf_rx_frame(struct device *dev, struct sk_buff =
*skb, bool handle_event,
 			brcmf_fweh_process_skb(ifp->drvr, skb,
 					       BCMILCP_SUBTYPE_VENDOR_LONG, gfp);
 		}
-		brcmf_netif_rx(ifp, skb, inirq);
+		brcmf_netif_rx(ifp, skb);
 	}
 }
=20
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/driv=
ers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 8212c9de14f1f..340346c122d32 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -208,7 +208,7 @@ void brcmf_remove_interface(struct brcmf_if *ifp, bool =
locked);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool succ=
ess);
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb, bool inirq);
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_netif_mon_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_net_detach(struct net_device *ndev, bool locked);
 int brcmf_net_mon_attach(struct brcmf_if *ifp);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 19b0f318f93ed..d58525ebe618e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -1664,7 +1664,7 @@ static void brcmf_rxreorder_get_skb_list(struct brcmf=
_ampdu_rx_reorder *rfi,
 	rfi->pend_pkts -=3D skb_queue_len(skb_list);
 }
=20
-void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt, bool i=
nirq)
+void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 {
 	struct brcmf_pub *drvr =3D ifp->drvr;
 	u8 *reorder_data;
@@ -1682,7 +1682,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct=
 sk_buff *pkt, bool inirq)
 	/* validate flags and flow id */
 	if (flags =3D=3D 0xFF) {
 		bphy_err(drvr, "invalid flags...so ignore this packet\n");
-		brcmf_netif_rx(ifp, pkt, inirq);
+		brcmf_netif_rx(ifp, pkt);
 		return;
 	}
=20
@@ -1694,7 +1694,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct=
 sk_buff *pkt, bool inirq)
 		if (rfi =3D=3D NULL) {
 			brcmf_dbg(INFO, "received flags to cleanup, but no flow (%d) yet\n",
 				  flow_id);
-			brcmf_netif_rx(ifp, pkt, inirq);
+			brcmf_netif_rx(ifp, pkt);
 			return;
 		}
=20
@@ -1719,7 +1719,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct=
 sk_buff *pkt, bool inirq)
 		rfi =3D kzalloc(buf_size, GFP_ATOMIC);
 		if (rfi =3D=3D NULL) {
 			bphy_err(drvr, "failed to alloc buffer\n");
-			brcmf_netif_rx(ifp, pkt, inirq);
+			brcmf_netif_rx(ifp, pkt);
 			return;
 		}
=20
@@ -1833,7 +1833,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct=
 sk_buff *pkt, bool inirq)
 netif_rx:
 	skb_queue_walk_safe(&reorder_list, pkt, pnext) {
 		__skb_unlink(pkt, &reorder_list);
-		brcmf_netif_rx(ifp, pkt, inirq);
+		brcmf_netif_rx(ifp, pkt);
 	}
 }
=20
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
index 50e424b5880de..b16a9d1c0508e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
@@ -42,6 +42,6 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp);
 void brcmf_fws_del_interface(struct brcmf_if *ifp);
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb);
 void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked);
-void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb, bool i=
nirq);
+void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb);
=20
 #endif /* FWSIGNAL_H_ */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/dr=
ivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 7c8e08ee8f0ff..b2d0f7570aa97 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -536,8 +536,7 @@ static int brcmf_msgbuf_hdrpull(struct brcmf_pub *drvr,=
 bool do_fws,
 	return -ENODEV;
 }
=20
-static void brcmf_msgbuf_rxreorder(struct brcmf_if *ifp, struct sk_buff *s=
kb,
-				   bool inirq)
+static void brcmf_msgbuf_rxreorder(struct brcmf_if *ifp, struct sk_buff *s=
kb)
 {
 }
=20
@@ -1191,7 +1190,7 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf =
*msgbuf, void *buf)
 	}
=20
 	skb->protocol =3D eth_type_trans(skb, ifp->ndev);
-	brcmf_netif_rx(ifp, skb, false);
+	brcmf_netif_rx(ifp, skb);
 }
=20
 static void brcmf_msgbuf_process_gen_status(struct brcmf_msgbuf *msgbuf,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h b/dri=
vers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
index f4a79e217da5b..bd08d3aaa8f4a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -32,7 +32,7 @@ struct brcmf_proto {
 			    u8 peer[ETH_ALEN]);
 	void (*add_tdls_peer)(struct brcmf_pub *drvr, int ifidx,
 			      u8 peer[ETH_ALEN]);
-	void (*rxreorder)(struct brcmf_if *ifp, struct sk_buff *skb, bool inirq);
+	void (*rxreorder)(struct brcmf_if *ifp, struct sk_buff *skb);
 	void (*add_if)(struct brcmf_if *ifp);
 	void (*del_if)(struct brcmf_if *ifp);
 	void (*reset_if)(struct brcmf_if *ifp);
@@ -109,9 +109,9 @@ static inline bool brcmf_proto_is_reorder_skb(struct sk=
_buff *skb)
 }
=20
 static inline void
-brcmf_proto_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb, bool inir=
q)
+brcmf_proto_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb)
 {
-	ifp->drvr->proto->rxreorder(ifp, skb, inirq);
+	ifp->drvr->proto->rxreorder(ifp, skb);
 }
=20
 static inline void
--=20
2.35.1

