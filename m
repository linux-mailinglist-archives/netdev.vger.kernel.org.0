Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7634CC383
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbiCCRQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbiCCRQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:16:05 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E73F47ED
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 09:15:20 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646327718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ekfc/m1gUeDgqzbzoOq4tlU805jIirBBBnL0GRluSkE=;
        b=UbMgbC00q9J4LNhJMOvTENKvy3Gri3V1n229kBj6hgGjbGQICe3eYEMvI6xhFdTkClbv2r
        RM1YZBzT3GtTAWII8P3Ts9VzP591Q8o52R5x1cLNsv68yl/0pl1LfQ790b21peETOc3Pdw
        KBuDTEHPcasoFr61+HGiU5fkWVbdulo/1/0khDoLv1bgmAmWBqAJiVQAn6l+53P4/1ilpX
        dUDoS66IxZbMYtswEOazSlsP9QAdFuKQrVC8rpyL+6WbIG0WiKj8YVHAM80OzQq4GAgi25
        RnZXd+D0gv/OQkCScT/rDjoqrMpz1be6OCsfQ8UQmIfH46CdIzprMJQXxO6p0g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646327718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ekfc/m1gUeDgqzbzoOq4tlU805jIirBBBnL0GRluSkE=;
        b=q2mFoyOzA9IBZHmwMV9PJdWFOCZ2KzMNCHINJ1mDRUnl1liF35lOCv2Te4hyM8xo9sHRt8
        B8Vy/0Z9hWoV7rBA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        bridge@lists.linux-foundation.org
Subject: [PATCH net-next 8/9] net: bridge: Use netif_rx().
Date:   Thu,  3 Mar 2022 18:15:04 +0100
Message-Id: <20220303171505.1604775-9-bigeasy@linutronix.de>
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

Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: bridge@lists.linux-foundation.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/bridge/br_arp_nd_proxy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_arp_nd_proxy.c b/net/bridge/br_arp_nd_proxy.c
index 3db1def4437b3..e5e48c6e35d78 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -84,7 +84,7 @@ static void br_arp_send(struct net_bridge *br, struct net=
_bridge_port *p,
 		skb->ip_summed =3D CHECKSUM_UNNECESSARY;
 		skb->pkt_type =3D PACKET_HOST;
=20
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
 }
=20
@@ -364,7 +364,7 @@ static void br_nd_send(struct net_bridge *br, struct ne=
t_bridge_port *p,
 		reply->ip_summed =3D CHECKSUM_UNNECESSARY;
 		reply->pkt_type =3D PACKET_HOST;
=20
-		netif_rx_ni(reply);
+		netif_rx(reply);
 	}
 }
=20
--=20
2.35.1

