Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F331A4CC380
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbiCCRQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbiCCRQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:16:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377EF197B54
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 09:15:18 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646327717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7HrmKgGF9OFAsF8rh9LZsbc2ElOejWJpegOQY5Xhhc8=;
        b=XEIDBAl+3xWDeSjywTk3uAyi4IePU5sy5gNkoxqYQWQTrAAYrYvWB1DyB7p8SOrz9zm2k1
        J42kKY3xZVgZhEpRj6Gzb6X9dUD3scnbutDGuR1xT3oAhOi+/1Nm7QNhWZOk8ZEnGWFKiW
        lU+YNFgbsEknmsYaTzWlVdDYlAiHo91lzKSqzS/m7nRXoKEmlVD8zWTgoXknOf76lH9ixK
        BllY64eGeJOSbkT1HYJ858ytB5TcWx9CptLGMeAPa6aryOBDBrYRhvsCY6vglg24xjNEil
        HOGNT1SahgKOz3teCK7wO0XVYxkYYbt39zIgSgwAzSVzZAIZf+8fu5YAyvyvRg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646327717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7HrmKgGF9OFAsF8rh9LZsbc2ElOejWJpegOQY5Xhhc8=;
        b=Svjf0LzCwu8P/AyQxCqlrOnqvlVAvsdlsd/AzLI8GadFVjUE3IgtJNerpAIpbkuPx3nzxl
        WN71BKC4XyEiFJCg==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 4/9] net: caif: Use netif_rx().
Date:   Thu,  3 Mar 2022 18:15:00 +0100
Message-Id: <20220303171505.1604775-5-bigeasy@linutronix.de>
In-Reply-To: <20220303171505.1604775-1-bigeasy@linutronix.de>
References: <20220303171505.1604775-1-bigeasy@linutronix.de>
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

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/caif/caif_serial.c | 2 +-
 net/caif/chnl_net.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 2a7af611d43a5..688075859ae47 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -196,7 +196,7 @@ static void ldisc_receive(struct tty_struct *tty, const=
 u8 *data,
 	skb_reset_mac_header(skb);
 	debugfs_rx(ser, data, count);
 	/* Push received packet up the stack. */
-	ret =3D netif_rx_ni(skb);
+	ret =3D netif_rx(skb);
 	if (!ret) {
 		ser->dev->stats.rx_packets++;
 		ser->dev->stats.rx_bytes +=3D count;
diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index 414dc5671c45e..4d63ef13a1fd7 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -99,7 +99,7 @@ static int chnl_recv_cb(struct cflayer *layr, struct cfpk=
t *pkt)
 	else
 		skb->ip_summed =3D CHECKSUM_NONE;
=20
-	netif_rx_any_context(skb);
+	netif_rx(skb);
=20
 	/* Update statistics. */
 	priv->netdev->stats.rx_packets++;
--=20
2.35.1

