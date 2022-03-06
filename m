Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0610C4CEE0B
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiCFV7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiCFV67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:58:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2705B1C10B;
        Sun,  6 Mar 2022 13:58:06 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646603882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GUAFLtBHk3izDc+rmSdg92znyPU6liBmxT8d8PGetHs=;
        b=rYdczkJh2CASqGnjEpRaDZxqFGsinymVnuAfLziYMDLf1xW4Zm0Ze0XYuBvMOTJGirMVo9
        e7mzhJLE2z6LUURwziGfYPGncgQPGzNz3uuFDl463FPDHWP2x1dzrbxN5oHBOJU81wEcyX
        h0wpHP9/eSk8Op5SCVCtqqItDhDfKGnMs3BRlciDR7tks+ctZ/p8TyvpJC/1XBO+8wEtyq
        pZ7C3nNy8Zeb1QoIScQ30VXKXJHmDA7uMjEw1hy7x8k8cnDCuzNq1SsludiDqHy+ab/qYQ
        bANBxPEdmI7xH/Qfb7HcDpV2Y3eBe83Hx5oWf1A726pdNzQSyjjR5I74OkN33Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646603882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GUAFLtBHk3izDc+rmSdg92znyPU6liBmxT8d8PGetHs=;
        b=UtGxE3dwa4y8CFV8SsT+yVUee/GX7lk1veoy0vYYDN0/uSEjawm8HDCwrpNHcBKlLFnnDj
        igae4+EeuvLrgpDA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net-next 06/10] bluetooth: Use netif_rx().
Date:   Sun,  6 Mar 2022 22:57:49 +0100
Message-Id: <20220306215753.3156276-7-bigeasy@linutronix.de>
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

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-bluetooth@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/bluetooth/6lowpan.c   | 2 +-
 net/bluetooth/bnep/core.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 8e8c075411530..215af9b3b5895 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -240,7 +240,7 @@ static int give_skb_to_upper(struct sk_buff *skb, struc=
t net_device *dev)
 	if (!skb_cp)
 		return NET_RX_DROP;
=20
-	return netif_rx_ni(skb_cp);
+	return netif_rx(skb_cp);
 }
=20
 static int iphc_decompress(struct sk_buff *skb, struct net_device *netdev,
diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index 40baa6b7321ae..5a6a49885ab66 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -400,7 +400,7 @@ static int bnep_rx_frame(struct bnep_session *s, struct=
 sk_buff *skb)
 	dev->stats.rx_packets++;
 	nskb->ip_summed =3D CHECKSUM_NONE;
 	nskb->protocol  =3D eth_type_trans(nskb, dev);
-	netif_rx_ni(nskb);
+	netif_rx(nskb);
 	return 0;
=20
 badframe:
--=20
2.35.1

