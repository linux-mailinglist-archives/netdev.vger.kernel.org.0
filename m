Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44324CC382
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbiCCRQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbiCCRQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:16:05 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9634197B68
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 09:15:19 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646327718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDyEXrSgu++LN+TwId7EjroyoxMIxKLh8Nb9voTrcxM=;
        b=YlUm4ayWfULACwYCma59QmgAUUpm4lNkjoUC+UkFja04DsIp0jgG2pcf5V+nEfxgo8NrmS
        BoGMYNthiJyYhjtA8uyX8nhTEAzZFd4QlcjZuX2BJRgACgAgy4d/6MjB7eM0MHYOwyVKnE
        rG1uBWdcj9ruBACNYXp2x1dBYzGLtkKTGjvt3jRhrUaWgu5+q51aUu5ZRPKz1wc/BYdhrj
        AaNB1i+viiyTBBCdoxu2aXtwR8nBUtLeZKnH64j/za7dGu5+xOJik1uNUEZTJJQ7RHnIMU
        pn9F/wCFTfW34aWzk07igHV9AprxS/RcmY390m0x5wioHIkg22T/aUNtipwqXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646327718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDyEXrSgu++LN+TwId7EjroyoxMIxKLh8Nb9voTrcxM=;
        b=jyMjlcGzl0kMUIUZmJVI9aAiWLe/gfHTIY+c1meH+92C29syrb4HBhZfxsRE7TOBB6UXaQ
        x9SXOR0xjajVY+Bw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 6/9] net: ethernet: Use netif_rx().
Date:   Thu,  3 Mar 2022 18:15:02 +0100
Message-Id: <20220303171505.1604775-7-bigeasy@linutronix.de>
In-Reply-To: <20220303171505.1604775-1-bigeasy@linutronix.de>
References: <20220303171505.1604775-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Cc: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/ethernet/asix/ax88796c_main.c             | 2 +-
 drivers/net/ethernet/davicom/dm9051.c                 | 2 +-
 drivers/net/ethernet/micrel/ks8851_spi.c              | 2 +-
 drivers/net/ethernet/microchip/enc28j60.c             | 2 +-
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 2 +-
 drivers/net/ethernet/qualcomm/qca_spi.c               | 2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c              | 2 +-
 drivers/net/ethernet/vertexcom/mse102x.c              | 2 +-
 drivers/net/ethernet/wiznet/w5100.c                   | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethern=
et/asix/ax88796c_main.c
index bf70481bb1cad..6ba5b024a7be7 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -433,7 +433,7 @@ ax88796c_skb_return(struct ax88796c_device *ax_local,
 	netif_info(ax_local, rx_status, ndev, "< rx, len %zu, type 0x%x\n",
 		   skb->len + sizeof(struct ethhdr), skb->protocol);
=20
-	status =3D netif_rx_ni(skb);
+	status =3D netif_rx(skb);
 	if (status !=3D NET_RX_SUCCESS && net_ratelimit())
 		netif_info(ax_local, rx_err, ndev,
 			   "netif_rx status %d\n", status);
diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/d=
avicom/dm9051.c
index 8ebcb35bbc0e1..a523ddda76093 100644
--- a/drivers/net/ethernet/davicom/dm9051.c
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -804,7 +804,7 @@ static int dm9051_loop_rx(struct board_info *db)
 		skb->protocol =3D eth_type_trans(skb, db->ndev);
 		if (db->ndev->features & NETIF_F_RXCSUM)
 			skb_checksum_none_assert(skb);
-		netif_rx_ni(skb);
+		netif_rx(skb);
 		db->ndev->stats.rx_bytes +=3D rxlen;
 		db->ndev->stats.rx_packets++;
 		scanrr++;
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/etherne=
t/micrel/ks8851_spi.c
index d167d93e4c12f..82d55fc27edc6 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -293,7 +293,7 @@ static void ks8851_wrfifo_spi(struct ks8851_net *ks, st=
ruct sk_buff *txp,
  */
 static void ks8851_rx_skb_spi(struct ks8851_net *ks, struct sk_buff *skb)
 {
-	netif_rx_ni(skb);
+	netif_rx(skb);
 }
=20
 /**
diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethern=
et/microchip/enc28j60.c
index db5a3edb4c3c0..559ad94a44d03 100644
--- a/drivers/net/ethernet/microchip/enc28j60.c
+++ b/drivers/net/ethernet/microchip/enc28j60.c
@@ -975,7 +975,7 @@ static void enc28j60_hw_rx(struct net_device *ndev)
 			/* update statistics */
 			ndev->stats.rx_packets++;
 			ndev->stats.rx_bytes +=3D len;
-			netif_rx_ni(skb);
+			netif_rx(skb);
 		}
 	}
 	/*
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/driver=
s/net/ethernet/microchip/lan966x/lan966x_main.c
index 4e877d9859bff..ad310c95bf5c9 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -600,7 +600,7 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, voi=
d *args)
 				skb->offload_fwd_mark =3D 0;
 		}
=20
-		netif_rx_ni(skb);
+		netif_rx(skb);
 		dev->stats.rx_bytes +=3D len;
 		dev->stats.rx_packets++;
=20
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet=
/qualcomm/qca_spi.c
index 3c5494afd3c04..c865a4be05eec 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -435,7 +435,7 @@ qcaspi_receive(struct qcaspi *qca)
 				qca->rx_skb->protocol =3D eth_type_trans(
 					qca->rx_skb, qca->rx_skb->dev);
 				skb_checksum_none_assert(qca->rx_skb);
-				netif_rx_ni(qca->rx_skb);
+				netif_rx(qca->rx_skb);
 				qca->rx_skb =3D netdev_alloc_skb_ip_align(net_dev,
 					net_dev->mtu + VLAN_ETH_HLEN);
 				if (!qca->rx_skb) {
diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/etherne=
t/qualcomm/qca_uart.c
index 27c4f43176aaa..26646cb6a20a6 100644
--- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -108,7 +108,7 @@ qca_tty_receive(struct serdev_device *serdev, const uns=
igned char *data,
 			qca->rx_skb->protocol =3D eth_type_trans(
 						qca->rx_skb, qca->rx_skb->dev);
 			skb_checksum_none_assert(qca->rx_skb);
-			netif_rx_ni(qca->rx_skb);
+			netif_rx(qca->rx_skb);
 			qca->rx_skb =3D netdev_alloc_skb_ip_align(netdev,
 								netdev->mtu +
 								VLAN_ETH_HLEN);
diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/etherne=
t/vertexcom/mse102x.c
index 25739b182ac7b..eb39a45de0121 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -362,7 +362,7 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
 		mse102x_dump_packet(__func__, skb->len, skb->data);
=20
 	skb->protocol =3D eth_type_trans(skb, mse->ndev);
-	netif_rx_ni(skb);
+	netif_rx(skb);
=20
 	mse->ndev->stats.rx_packets++;
 	mse->ndev->stats.rx_bytes +=3D rxlen;
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiz=
net/w5100.c
index ae24d6b868031..4fd7c39e11233 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -883,7 +883,7 @@ static void w5100_rx_work(struct work_struct *work)
 	struct sk_buff *skb;
=20
 	while ((skb =3D w5100_rx_skb(priv->ndev)))
-		netif_rx_ni(skb);
+		netif_rx(skb);
=20
 	w5100_enable_intr(priv);
 }
--=20
2.35.1

