Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF76B4CEE0D
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbiCFV7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbiCFV67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:58:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B2A1EAD5
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 13:58:06 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646603882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HfjELwPcooFKFLjxQkftJyRT5nPeVL034Dgm8E9kFI0=;
        b=wTc1eDzoo86+fYdTrurDLL7JqCRg55ir9drOfBbYa4UwX4xn5WJVPfiDpTBis4hjtdlOaf
        mkD11APb0AYhaLkLqivvwer4UTTdeAAELGwTPAupbJOuGAG0GMI2gWoFaCGisVOvCUKTNa
        zSNGAW6MKQc98i6Kpv+xtffHsmAipW2Jnb7XzCEKFEUhCS0eYYUZdpmF/hfxZTonHo2cj3
        SRypbAyuYJ1vfP9XCr48wfaSs7MrLdXAB39mVa0ltZ+pzbPUqh6jCJukaEDgUihezsWf73
        4yMS8Z+1RUNxVqHZKoDncJbkDKvA9sGUIAGetr35Iz53WUmJuCM8EcK09PHaeg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646603882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HfjELwPcooFKFLjxQkftJyRT5nPeVL034Dgm8E9kFI0=;
        b=JGcAHoyDvUtFmx844ZkwTsngjB3p9s0CBLR5sBR+Ziw0UZL6a9gkQx+RvjE4Z91Uvuh4ui
        RuN9AJo9VNuwQwCg==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Antonio Quartulli <a@unstable.cc>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH net-next 05/10] batman-adv: Use netif_rx().
Date:   Sun,  6 Mar 2022 22:57:48 +0100
Message-Id: <20220306215753.3156276-6-bigeasy@linutronix.de>
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

Cc: Antonio Quartulli <a@unstable.cc>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/batman-adv/bridge_loop_avoidance.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge=
_loop_avoidance.c
index 337e20b6586d3..7f8a14d99cdb0 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -444,7 +444,7 @@ static void batadv_bla_send_claim(struct batadv_priv *b=
at_priv, const u8 *mac,
 	batadv_add_counter(bat_priv, BATADV_CNT_RX_BYTES,
 			   skb->len + ETH_HLEN);
=20
-	netif_rx_any_context(skb);
+	netif_rx(skb);
 out:
 	batadv_hardif_put(primary_if);
 }
--=20
2.35.1

