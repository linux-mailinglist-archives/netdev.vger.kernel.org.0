Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40D51C643C
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 00:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgEEW7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 18:59:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55462 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728642AbgEEW7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 18:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588719559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pMyJmleFeAEmG89Dwq9mmL89GXqR6uFJ7G3Psqri7IU=;
        b=LzYz3RrveSv/17GPnwSmC4HptvxbOKmAQSxte17HTrAl6JBKLRfCVrR1VYbbkQz5veice/
        c8+iWROXMD3LZNrR9Yf0iKHizk8vRq7OfJKhuWrStCh2fGzzCy1FPcSo8JIDp6P/WMIF+U
        PVbeLpa3Pg3zvnPHKZGfjUsretC4XTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-Ppp8qrNzPS6Gcx4Bp06GZg-1; Tue, 05 May 2020 18:59:16 -0400
X-MC-Unique: Ppp8qrNzPS6Gcx4Bp06GZg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E10FB100960F;
        Tue,  5 May 2020 22:59:14 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EF315D9DA;
        Tue,  5 May 2020 22:59:13 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [RFC PATCH net-next v2 1/3] xfrm: bail early on slave pass over skb
Date:   Tue,  5 May 2020 18:58:36 -0400
Message-Id: <20200505225838.59505-2-jarod@redhat.com>
In-Reply-To: <20200505225838.59505-1-jarod@redhat.com>
References: <20200504145943.8841-1-jarod@redhat.com>
 <20200505225838.59505-1-jarod@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is prep work for initial support of bonding hardware encryption
pass-through support. The bonding driver will fill in the slave_dev
pointer, and we use that to know not to skb_push() again on a given
skb that was already processed on the bond device.

CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: netdev@vger.kernel.org
CC: intel-wired-lan@lists.osuosl.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 include/net/xfrm.h     |  1 +
 net/xfrm/xfrm_device.c | 34 +++++++++++++++++-----------------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 8f71c111e65a..a6ec341cd9f0 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -127,6 +127,7 @@ struct xfrm_state_walk {
=20
 struct xfrm_state_offload {
 	struct net_device	*dev;
+	struct net_device	*slave_dev;
 	unsigned long		offload_handle;
 	unsigned int		num_exthdrs;
 	u8			flags;
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 6cc7f7f1dd68..1cd31dcf59da 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -108,6 +108,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *sk=
b, netdev_features_t featur
 	struct sk_buff *skb2, *nskb, *pskb =3D NULL;
 	netdev_features_t esp_features =3D features;
 	struct xfrm_offload *xo =3D xfrm_offload(skb);
+	struct net_device *dev =3D skb->dev;
 	struct sec_path *sp;
=20
 	if (!xo)
@@ -121,6 +122,10 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *s=
kb, netdev_features_t featur
 	if (xo->flags & XFRM_GRO || x->xso.flags & XFRM_OFFLOAD_INBOUND)
 		return skb;
=20
+	/* This skb was already validated on the master dev */
+	if ((x->xso.dev !=3D dev) && (x->xso.slave_dev =3D=3D dev))
+		return skb;
+
 	local_irq_save(flags);
 	sd =3D this_cpu_ptr(&softnet_data);
 	err =3D !skb_queue_empty(&sd->xfrm_backlog);
@@ -131,25 +136,20 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *=
skb, netdev_features_t featur
 		return skb;
 	}
=20
-	if (skb_is_gso(skb)) {
-		struct net_device *dev =3D skb->dev;
-
-		if (unlikely(x->xso.dev !=3D dev)) {
-			struct sk_buff *segs;
+	if (skb_is_gso(skb) && unlikely(x->xso.dev !=3D dev)) {
+		struct sk_buff *segs;
=20
-			/* Packet got rerouted, fixup features and segment it. */
-			esp_features =3D esp_features & ~(NETIF_F_HW_ESP
-							| NETIF_F_GSO_ESP);
+		/* Packet got rerouted, fixup features and segment it. */
+		esp_features =3D esp_features & ~(NETIF_F_HW_ESP | NETIF_F_GSO_ESP);
=20
-			segs =3D skb_gso_segment(skb, esp_features);
-			if (IS_ERR(segs)) {
-				kfree_skb(skb);
-				atomic_long_inc(&dev->tx_dropped);
-				return NULL;
-			} else {
-				consume_skb(skb);
-				skb =3D segs;
-			}
+		segs =3D skb_gso_segment(skb, esp_features);
+		if (IS_ERR(segs)) {
+			kfree_skb(skb);
+			atomic_long_inc(&dev->tx_dropped);
+			return NULL;
+		} else {
+			consume_skb(skb);
+			skb =3D segs;
 		}
 	}
=20
--=20
2.20.1

