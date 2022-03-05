Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B389E4CE769
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 23:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiCEWO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 17:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbiCEWOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 17:14:12 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085CA54BDB;
        Sat,  5 Mar 2022 14:13:21 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646518398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4XzxBTWfxgqMCSYhgP5LMH1pYJhDeR5dXrU0AuykAk=;
        b=3QBryap7XfWXyWZkXLFO+OVfYIG5/e/6nxu/u9ZWFQiiq2WxnrcS/IMsygSqX+PcwYxTp3
        MoAQOc+D8jjPosSwcWh9vkHprjRDw87MPkDfxOpZLSiOg6GW9t3q4PC2PogjDVa3cx3zdF
        5FgdRwreChSuIeve7XGnN/CQhk4L4YL20qB3cwxQ0ewCchh8wPKkQ58bXz38B7Koq1MauP
        qVbOd6t47V6hoStZZbTKmDKrfxfLEsOMdb9vXcrQTTwiTSNP0ArLhpHZKTQlrkHaY7wYP+
        PFKDqI6pFc9B9U3T7sdBdcuM58uO2WHA9wQQou6vrLQJlKZxY5O+hU2cZywfjg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646518398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4XzxBTWfxgqMCSYhgP5LMH1pYJhDeR5dXrU0AuykAk=;
        b=cfuaTMFIm0ua/pZt76t/8KA9b+V9MD3D/8KEHwYFjdlpTTSKYzzMKp3ScFpvHfn/tCm0tH
        arLhyEpK9ZDJmmDA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH net-next 7/8] wireless: Marvell: Use netif_rx().
Date:   Sat,  5 Mar 2022 23:12:51 +0100
Message-Id: <20220305221252.3063812-8-bigeasy@linutronix.de>
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

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Ganapathi Bhat <ganapathi017@gmail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Sharvari Harisangam <sharvari.harisangam@nxp.com>
Cc: Xinming Hu <huxinming820@gmail.com>
Cc: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/marvell/libertas/rx.c      | 4 ++--
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/util.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/rx.c b/drivers/net/wirel=
ess/marvell/libertas/rx.c
index 9f24b0760e1f7..c34d30f7cbe03 100644
--- a/drivers/net/wireless/marvell/libertas/rx.c
+++ b/drivers/net/wireless/marvell/libertas/rx.c
@@ -147,7 +147,7 @@ int lbs_process_rxed_packet(struct lbs_private *priv, s=
truct sk_buff *skb)
 	dev->stats.rx_packets++;
=20
 	skb->protocol =3D eth_type_trans(skb, dev);
-	netif_rx_any_context(skb);
+	netif_rx(skb);
=20
 	ret =3D 0;
 done:
@@ -262,7 +262,7 @@ static int process_rxed_802_11_packet(struct lbs_privat=
e *priv,
 	dev->stats.rx_packets++;
=20
 	skb->protocol =3D eth_type_trans(skb, priv->dev);
-	netif_rx_any_context(skb);
+	netif_rx(skb);
=20
 	ret =3D 0;
=20
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c b/drivers/net/=
wireless/marvell/mwifiex/uap_txrx.c
index 245ff644f81e3..4e49ed21c5ced 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
@@ -350,7 +350,7 @@ int mwifiex_uap_recv_packet(struct mwifiex_private *pri=
v,
 		skb->truesize +=3D (skb->len - MWIFIEX_RX_DATA_BUF_SIZE);
=20
 	/* Forward multicast/broadcast packet to upper layer*/
-	netif_rx_any_context(skb);
+	netif_rx(skb);
 	return 0;
 }
=20
diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wire=
less/marvell/mwifiex/util.c
index d583fa600a296..d5edb1e89f5bd 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -488,7 +488,7 @@ int mwifiex_recv_packet(struct mwifiex_private *priv, s=
truct sk_buff *skb)
 	    (skb->truesize > MWIFIEX_RX_DATA_BUF_SIZE))
 		skb->truesize +=3D (skb->len - MWIFIEX_RX_DATA_BUF_SIZE);
=20
-	netif_rx_any_context(skb);
+	netif_rx(skb);
 	return 0;
 }
=20
--=20
2.35.1

