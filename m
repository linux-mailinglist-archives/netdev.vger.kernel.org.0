Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFCC4CEE02
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbiCFV65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbiCFV65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:58:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D0D1C102
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 13:58:03 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646603881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K0A40sGXSRXBIm7epRwU25Rvbpc3NJ/QFvvpPO+JWnM=;
        b=MJT+IlSxOt0Q5cbBneFz70HzYhBF/q5/fcNy7odowpkGrlhx+MB79l1Xhf3+sDi8jQs3TO
        zRECftZke/Km7d3zN+hj+QP4TVP3UvL9LH0gXx3muWy3P4WaX5kP8BsozvdNo0rzHGHOYi
        CZyP4dPEWtpLjeAC3BUJ8kH1NSYNVN2t48nD0aFrg/BepF7ZwsngonTBpr3QzIiLhlnGko
        TOEntLzL0eK6rsD8xIinITSy/S42uDs5x8oG2afr+FVg6ovSzOul0c9spCDEwVf/SWnxG8
        RPIIuQh4SxJ3TK43QxS0mZJ9qVo2uaB6lBhJ3m6JkSM5a+FtgmqJMfIeQlm10A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646603881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K0A40sGXSRXBIm7epRwU25Rvbpc3NJ/QFvvpPO+JWnM=;
        b=z+BcvCChAI3dfQcKFNSXwQKoXVGF4WKW2VBPrBM/VtGuu+Bg8lefct0LU08UYL38lF19Ub
        QDT80wzgskVXcQCQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 03/10] tun: vxlan: Use netif_rx().
Date:   Sun,  6 Mar 2022 22:57:46 +0100
Message-Id: <20220306215753.3156276-4-bigeasy@linutronix.de>
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

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/tun.c              | 2 +-
 drivers/net/vxlan/vxlan_core.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index bab92e489fba9..2b9a22669a126 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1984,7 +1984,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, s=
truct tun_file *tfile,
 	} else if (!IS_ENABLED(CONFIG_4KSTACKS)) {
 		tun_rx_batched(tun, tfile, skb, more);
 	} else {
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
 	rcu_read_unlock();
=20
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 4ab09dd5a32a3..b3cbd37c4b939 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1877,7 +1877,7 @@ static int arp_reduce(struct net_device *dev, struct =
sk_buff *skb, __be32 vni)
 		reply->ip_summed =3D CHECKSUM_UNNECESSARY;
 		reply->pkt_type =3D PACKET_HOST;
=20
-		if (netif_rx_ni(reply) =3D=3D NET_RX_DROP) {
+		if (netif_rx(reply) =3D=3D NET_RX_DROP) {
 			dev->stats.rx_dropped++;
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_RX_DROPS, 0);
@@ -2036,7 +2036,7 @@ static int neigh_reduce(struct net_device *dev, struc=
t sk_buff *skb, __be32 vni)
 		if (reply =3D=3D NULL)
 			goto out;
=20
-		if (netif_rx_ni(reply) =3D=3D NET_RX_DROP) {
+		if (netif_rx(reply) =3D=3D NET_RX_DROP) {
 			dev->stats.rx_dropped++;
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_RX_DROPS, 0);
--=20
2.35.1

