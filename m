Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A34D4CC381
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbiCCRQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiCCRQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:16:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37084179268
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 09:15:18 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646327716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6avL7gFEL0Bm+XKhuKhhXsuKw8YShUKlLrcuALpbyM=;
        b=SZ9JOl5+nFbEL8S7OasPe7GOeXis6i/XKgnc8LMuOJBeNXbfWWwm1iW1EjVmwhctJU6U3s
        8BRcGXeLYQPxgnnX9SKoZdl2r/QMYKzYCCF59krhoaxJ9twe2KeznXaav986MZ0G1ZPkXb
        OjU5ncZMtKqK/AykIK25UTfhCHfGUlzUX/NCwU0eDa6gbIOX121tZzqQxZZt0+7HxYc0WA
        sZuFFMrLESP849Ici5CYdsln5EYigq5yg0u+SjFtlUyUnHBsU71OYwvdxrqyIJJT4AWcis
        dLKfOK8P0hpbMdr8hu1U5QAxFtA5Wa53aWQX8QABIokUEFrmFUVe1c0LuWBdXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646327716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6avL7gFEL0Bm+XKhuKhhXsuKw8YShUKlLrcuALpbyM=;
        b=PXJSuMnvz5EYmvW8/QBZHOzWYN7JI+q1bNeRNfuUtNimn4nwfycGX3y0oEHXeh0heDaY1z
        YGvwp6lwN8lsjbBw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH net-next 2/9] net: xtensa: Use netif_rx().
Date:   Thu,  3 Mar 2022 18:14:58 +0100
Message-Id: <20220303171505.1604775-3-bigeasy@linutronix.de>
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

Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/xtensa/platforms/iss/network.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/is=
s/network.c
index 962e5e1452097..9fb99d18e3c22 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -304,7 +304,7 @@ static int iss_net_rx(struct net_device *dev)
=20
 		lp->stats.rx_bytes +=3D skb->len;
 		lp->stats.rx_packets++;
-		netif_rx_ni(skb);
+		netif_rx(skb);
 		return pkt_len;
 	}
 	kfree_skb(skb);
--=20
2.35.1

