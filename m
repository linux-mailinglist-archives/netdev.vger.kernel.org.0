Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2464CC384
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbiCCRQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbiCCRQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:16:06 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC21516EA8D
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 09:15:20 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646327718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OwjDDf387N2nqGj6mQbSWEaRcWwCy2X0eRWV7vYSTEY=;
        b=B7zhT7WLMvaKVmhcvlqgpVNEgxP5AcpGCatqqLvuLxjfOTgzUErWRO1QupO/VZ5eujKDTq
        lsFheVbvonB8TmppDTdzJC+M1he4N/syT5tcbam2Rrw+iKrGSqGoGpvI7RFJ0F08KinFGh
        OR6RVZgvJMRI5F2+Qy7eLVOPTJd1SeTi9X7Itt8Qom6qlnO7TpmatpoN4L+kqNoDQofEwP
        HgLwOZA/Uq+k5XtXGqi0froq6s0v4jZi6fTYfEpkXrv2SU0rxpBFGpZ3CzPcJTSbpxkV3k
        SfLMVixraawovJAD06wgbzoJjRUBtFqzYgs6mX0ww2aecDH3Nc7HXOvwT6ceZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646327718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OwjDDf387N2nqGj6mQbSWEaRcWwCy2X0eRWV7vYSTEY=;
        b=U1HfqwVuexiTYZAgJ8ZsXd2e/+2iPKYSr3gxrhrgxKXRZAOQVOOitwSY6c9HlGM6XZDPEe
        9o7495nq/gnearBA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 9/9] net: dev: Use netif_rx().
Date:   Thu,  3 Mar 2022 18:15:05 +0100
Message-Id: <20220303171505.1604775-10-bigeasy@linutronix.de>
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
 net/core/dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c9e54e5ad48df..59b3ab7485d65 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3858,7 +3858,7 @@ int dev_loopback_xmit(struct net *net, struct sock *s=
k, struct sk_buff *skb)
 		skb->ip_summed =3D CHECKSUM_UNNECESSARY;
 	WARN_ON(!skb_dst(skb));
 	skb_dst_force(skb);
-	netif_rx_ni(skb);
+	netif_rx(skb);
 	return 0;
 }
 EXPORT_SYMBOL(dev_loopback_xmit);
@@ -10947,11 +10947,11 @@ static int dev_cpu_dead(unsigned int oldcpu)
=20
 	/* Process offline CPU's input_pkt_queue */
 	while ((skb =3D __skb_dequeue(&oldsd->process_queue))) {
-		netif_rx_ni(skb);
+		netif_rx(skb);
 		input_queue_head_incr(oldsd);
 	}
 	while ((skb =3D skb_dequeue(&oldsd->input_pkt_queue))) {
-		netif_rx_ni(skb);
+		netif_rx(skb);
 		input_queue_head_incr(oldsd);
 	}
=20
--=20
2.35.1

