Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A3E4CEE0E
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbiCFV7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbiCFV67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:58:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD311EAD9
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 13:58:06 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646603882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lqJLFzMNwUI3glsCEQzZp1FtzCGUjUGLW4CKX1XCqNI=;
        b=RkLwUXbPJ0v9vXqgSyrjLDGj8Zi1OEqtc/K/ulwy4tWnSxC1xv8/DK5a3CDqmn24vY74d/
        9DbgdknvIY+vxL6qCNq6sQkgtVVUaJ9ZbHUF+l8flEylzkg48O1U8eprgQhMEQ0Hwa9sHk
        BZ8z2YonjP5+paNiafmHrZ7bffRcJSmMfiwUrrRv6x0mFvn2zMGVlemV5vrJ65LhHrpv/J
        JlsMmgRAAwiPvii71HXMIoVUBjguIOg9DSjMErZIWi50vEWd2GKkwENb3oHq4QxwR6SB4L
        179sUqJQ7sLUv04idsudzOg32RP9Q0/GPcVVS1/47WRPpaQCdS0TVomJT8ZAJg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646603882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lqJLFzMNwUI3glsCEQzZp1FtzCGUjUGLW4CKX1XCqNI=;
        b=IS6+ufh2RIcEndcRg533gv94BbnaEgxb9vVYSfXKbJlwUYEop7DF85NRNVxrNKLAMVgMln
        s+jKYy9el330gUCw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Remi Denis-Courmont <courmisch@gmail.com>
Subject: [PATCH net-next 07/10] phonet: Use netif_rx().
Date:   Sun,  6 Mar 2022 22:57:50 +0100
Message-Id: <20220306215753.3156276-8-bigeasy@linutronix.de>
In-Reply-To: <20220306215753.3156276-1-bigeasy@linutronix.de>
References: <20220306215753.3156276-1-bigeasy@linutronix.de>
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

Cc: Remi Denis-Courmont <courmisch@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/phonet/af_phonet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/phonet/af_phonet.c b/net/phonet/af_phonet.c
index 65218b7ce9f94..2b582da1e88c0 100644
--- a/net/phonet/af_phonet.c
+++ b/net/phonet/af_phonet.c
@@ -146,7 +146,7 @@ EXPORT_SYMBOL(phonet_header_ops);
  * Prepends an ISI header and sends a datagram.
  */
 static int pn_send(struct sk_buff *skb, struct net_device *dev,
-			u16 dst, u16 src, u8 res, u8 irq)
+			u16 dst, u16 src, u8 res)
 {
 	struct phonethdr *ph;
 	int err;
@@ -182,7 +182,7 @@ static int pn_send(struct sk_buff *skb, struct net_devi=
ce *dev,
 	if (skb->pkt_type =3D=3D PACKET_LOOPBACK) {
 		skb_reset_mac_header(skb);
 		skb_orphan(skb);
-		err =3D (irq ? netif_rx(skb) : netif_rx_ni(skb)) ? -ENOBUFS : 0;
+		err =3D netif_rx(skb) ? -ENOBUFS : 0;
 	} else {
 		err =3D dev_hard_header(skb, dev, ntohs(skb->protocol),
 					NULL, NULL, skb->len);
@@ -214,7 +214,7 @@ static int pn_raw_send(const void *data, int len, struc=
t net_device *dev,
 	skb_reserve(skb, MAX_PHONET_HEADER);
 	__skb_put(skb, len);
 	skb_copy_to_linear_data(skb, data, len);
-	return pn_send(skb, dev, dst, src, res, 1);
+	return pn_send(skb, dev, dst, src, res);
 }
=20
 /*
@@ -269,7 +269,7 @@ int pn_skb_send(struct sock *sk, struct sk_buff *skb,
 	if (!pn_addr(src))
 		src =3D pn_object(saddr, pn_obj(src));
=20
-	err =3D pn_send(skb, dev, dst, src, res, 0);
+	err =3D pn_send(skb, dev, dst, src, res);
 	dev_put(dev);
 	return err;
=20
--=20
2.35.1

