Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD214CE760
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 23:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiCEWOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 17:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCEWOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 17:14:11 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED73B546B3;
        Sat,  5 Mar 2022 14:13:20 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646518397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fWJ4eL0KoZxJYMwAyKWO1nG6ZN9tjd/6bd/n5PNPxCY=;
        b=HoBZTDICpvaPF0tfqo+4orcMSAM+lfs8ANaemljwkjEoLlpvJ7uiDGNmkcOnVuRipVj0LK
        pVkBKzlCwXkSm1l8nt50jeixKyrrJZBTe2NT4D4ZIu8HUuf6+5F2QRxBR+NjEOgmVhKSF/
        Lq4WgCkLO5s3c2pmTpzu3nzEOUs477vcR3/E6NS/MkMlT3PqSYhnPyfgTyOQBupykFiBGq
        vUhP6P9hGMWsFvpisaqhWos5bHQ+N+R2GoXm5LhUAVWsdPUR8jS1eWtzIOt75HtVz1IYis
        oI8O7fxDeVcvPU+AnkmZKvhygcxKI6bwoxh8tFpyyZPM+rCpFUpW6lwiCou1hA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646518397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fWJ4eL0KoZxJYMwAyKWO1nG6ZN9tjd/6bd/n5PNPxCY=;
        b=Sh8e8MO/7R2jHY088bl8kw2CFaByJjfY6Z8AwgYn9wEoBVnY0QechawADDT4wSNAVPWtmD
        wF/0l0MC1qfGa2CA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kalle Valo <kvalo@kernel.org>,
        Maya Erez <merez@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: [PATCH net-next 5/8] wireless: Atheros: Use netif_rx().
Date:   Sat,  5 Mar 2022 23:12:49 +0100
Message-Id: <20220305221252.3063812-6-bigeasy@linutronix.de>
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

Cc: Kalle Valo <kvalo@kernel.org>
Cc: Maya Erez <merez@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: wil6210@qti.qualcomm.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/ath/ath6kl/txrx.c  | 2 +-
 drivers/net/wireless/ath/wil6210/txrx.c | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/=
ath/ath6kl/txrx.c
index b22ed499f7ba7..a56fab6232a9b 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -839,7 +839,7 @@ static void ath6kl_deliver_frames_to_nw_stack(struct ne=
t_device *dev,
=20
 	skb->protocol =3D eth_type_trans(skb, skb->dev);
=20
-	netif_rx_ni(skb);
+	netif_rx(skb);
 }
=20
 static void ath6kl_alloc_netbufs(struct sk_buff_head *q, u16 num)
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless=
/ath/wil6210/txrx.c
index cc830c795b33c..5704defd7be1b 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -958,7 +958,7 @@ void wil_netif_rx(struct sk_buff *skb, struct net_devic=
e *ndev, int cid,
 		if (gro)
 			napi_gro_receive(&wil->napi_rx, skb);
 		else
-			netif_rx_ni(skb);
+			netif_rx(skb);
 	}
 	ndev->stats.rx_packets++;
 	stats->rx_packets++;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/=
ath/wil6210/wmi.c
index dd8abbb288497..98b4c189eeccb 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1199,7 +1199,7 @@ static void wmi_evt_eapol_rx(struct wil6210_vif *vif,=
 int id, void *d, int len)
 	eth->h_proto =3D cpu_to_be16(ETH_P_PAE);
 	skb_put_data(skb, evt->eapol, eapol_len);
 	skb->protocol =3D eth_type_trans(skb, ndev);
-	if (likely(netif_rx_ni(skb) =3D=3D NET_RX_SUCCESS)) {
+	if (likely(netif_rx(skb) =3D=3D NET_RX_SUCCESS)) {
 		ndev->stats.rx_packets++;
 		ndev->stats.rx_bytes +=3D sz;
 		if (stats) {
--=20
2.35.1

