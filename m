Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112B94CE75C
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 23:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiCEWOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 17:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbiCEWOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 17:14:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B53A517FB;
        Sat,  5 Mar 2022 14:13:18 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646518396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7uGNP9Djz1TwgueFOo46UUQ187Tk4tNDpxEJOSudrzs=;
        b=qaqgVU36NS1iGqgj6SBekZsPSycB/xGOV9gwhRL6eIAGO8hDshPhdLLU7V2CMxOVI8fSjs
        YAsqdk34Lr9WwKQF+VBc6QcAjO5bkYjMBkYYmWyFm2V+YLX004SZdBJMU51HkD68VtMaxy
        ARIXg4Xg3eN29SnPpo6DzXeO1C8fKAMCVb2vht9H+vq0+s4DcVUem0O35DmCUa8IqR0Ax7
        RHY4KcRBewCnJ7yI0CH7g4/Oof+v88WPVGCBluk9O/z3zrsYWGCwKQO/RS9Fqb8eNwWlTd
        e6Chtp2IXkIaJZcs05bhbJo+He4lX06D9z8Rqws9WT8sJryTxiA2LNL0GgN19g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646518396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7uGNP9Djz1TwgueFOo46UUQ187Tk4tNDpxEJOSudrzs=;
        b=pws7mI33hXL1DuQuAxslfc/xTZQOEqJ0rocE3Ni5uHecn3u2hK/C1uD74heb1vrt8POzAG
        DDT8jgA8d3M2yJDA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org
Subject: [PATCH net-next 2/8] can: Use netif_rx().
Date:   Sat,  5 Mar 2022 23:12:46 +0100
Message-Id: <20220305221252.3063812-3-bigeasy@linutronix.de>
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

Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: linux-can@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/can/dev/dev.c     | 2 +-
 drivers/net/can/slcan.c       | 2 +-
 drivers/net/can/spi/hi311x.c  | 6 +++---
 drivers/net/can/spi/mcp251x.c | 4 ++--
 drivers/net/can/vcan.c        | 2 +-
 drivers/net/can/vxcan.c       | 2 +-
 net/can/af_can.c              | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index c192f25f96956..e7ab45f1c43b2 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -154,7 +154,7 @@ static void can_restart(struct net_device *dev)
=20
 	cf->can_id |=3D CAN_ERR_RESTARTED;
=20
-	netif_rx_ni(skb);
+	netif_rx(skb);
=20
 restart:
 	netdev_dbg(dev, "restarted\n");
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 27783fbf011fc..ec294d0c5722c 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -221,7 +221,7 @@ static void slc_bump(struct slcan *sl)
 	if (!(cf.can_id & CAN_RTR_FLAG))
 		sl->dev->stats.rx_bytes +=3D cf.len;
=20
-	netif_rx_ni(skb);
+	netif_rx(skb);
 }
=20
 /* parse tty input stream */
diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 664b8f14d7b05..a5b2952b8d0ff 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -356,7 +356,7 @@ static void hi3110_hw_rx(struct spi_device *spi)
=20
 	can_led_event(priv->net, CAN_LED_EVENT_RX);
=20
-	netif_rx_ni(skb);
+	netif_rx(skb);
 }
=20
 static void hi3110_hw_sleep(struct spi_device *spi)
@@ -677,7 +677,7 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
 			tx_state =3D txerr >=3D rxerr ? new_state : 0;
 			rx_state =3D txerr <=3D rxerr ? new_state : 0;
 			can_change_state(net, cf, tx_state, rx_state);
-			netif_rx_ni(skb);
+			netif_rx(skb);
=20
 			if (new_state =3D=3D CAN_STATE_BUS_OFF) {
 				can_bus_off(net);
@@ -718,7 +718,7 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
 				cf->data[6] =3D hi3110_read(spi, HI3110_READ_TEC);
 				cf->data[7] =3D hi3110_read(spi, HI3110_READ_REC);
 				netdev_dbg(priv->net, "Bus Error\n");
-				netif_rx_ni(skb);
+				netif_rx(skb);
 			}
 		}
=20
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index d23edaf224204..fc747bff5eeb2 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -740,7 +740,7 @@ static void mcp251x_hw_rx(struct spi_device *spi, int b=
uf_idx)
=20
 	can_led_event(priv->net, CAN_LED_EVENT_RX);
=20
-	netif_rx_ni(skb);
+	netif_rx(skb);
 }
=20
 static void mcp251x_hw_sleep(struct spi_device *spi)
@@ -987,7 +987,7 @@ static void mcp251x_error_skb(struct net_device *net, i=
nt can_id, int data1)
 	if (skb) {
 		frame->can_id |=3D can_id;
 		frame->data[1] =3D data1;
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	} else {
 		netdev_err(net, "cannot allocate error skb\n");
 	}
diff --git a/drivers/net/can/vcan.c b/drivers/net/can/vcan.c
index c42f18845b02a..a15619d883ec2 100644
--- a/drivers/net/can/vcan.c
+++ b/drivers/net/can/vcan.c
@@ -80,7 +80,7 @@ static void vcan_rx(struct sk_buff *skb, struct net_devic=
e *dev)
 	skb->dev       =3D dev;
 	skb->ip_summed =3D CHECKSUM_UNNECESSARY;
=20
-	netif_rx_ni(skb);
+	netif_rx(skb);
 }
=20
 static netdev_tx_t vcan_tx(struct sk_buff *skb, struct net_device *dev)
diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index 47ccc15a3486b..556f1a12ec9a0 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -63,7 +63,7 @@ static netdev_tx_t vxcan_xmit(struct sk_buff *skb, struct=
 net_device *dev)
 	skb->ip_summed  =3D CHECKSUM_UNNECESSARY;
=20
 	len =3D cfd->can_id & CAN_RTR_FLAG ? 0 : cfd->len;
-	if (netif_rx_ni(skb) =3D=3D NET_RX_SUCCESS) {
+	if (netif_rx(skb) =3D=3D NET_RX_SUCCESS) {
 		srcstats->tx_packets++;
 		srcstats->tx_bytes +=3D len;
 		peerstats =3D &peer->stats;
diff --git a/net/can/af_can.c b/net/can/af_can.c
index cce2af10eb3ea..1fb49d51b25d6 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -284,7 +284,7 @@ int can_send(struct sk_buff *skb, int loop)
 	}
=20
 	if (newskb)
-		netif_rx_ni(newskb);
+		netif_rx(newskb);
=20
 	/* update statistics */
 	pkg_stats->tx_frames++;
--=20
2.35.1

