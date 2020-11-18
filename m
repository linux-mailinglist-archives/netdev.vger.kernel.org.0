Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186552B7EF3
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgKROAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:00:24 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:54423 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgKROAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:00:23 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfO0S-0008AR-4W; Wed, 18 Nov 2020 15:00:20 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfO0R-00031n-8Y; Wed, 18 Nov 2020 15:00:19 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 8EA02240041;
        Wed, 18 Nov 2020 15:00:18 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 11011240040;
        Wed, 18 Nov 2020 15:00:18 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id CE305200D1;
        Wed, 18 Nov 2020 15:00:17 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v3 6/6] net/x25: remove x25_kill_by_device()
Date:   Wed, 18 Nov 2020 14:59:19 +0100
Message-ID: <20201118135919.1447-7-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201118135919.1447-1-ms@dev.tdt.de>
References: <20201118135919.1447-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1605708019-0000CF01-831BCBE7/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary function x25_kill_by_device().

Replace the call to x25_kill_by_device() by x25_kill_by_neigh().

Therefore, also remove the call to x25_clear_forward_by_dev() in
x25_route_device_down(), as this is already called by
x25_kill_by_neigh().

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/x25/af_x25.c    | 22 +++++-----------------
 net/x25/x25_route.c |  3 ---
 2 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 02f56386e05b..ec90956f38d4 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -199,22 +199,6 @@ static void x25_remove_socket(struct sock *sk)
 	write_unlock_bh(&x25_list_lock);
 }
=20
-/*
- *	Kill all bound sockets on a dropped device.
- */
-static void x25_kill_by_device(struct net_device *dev)
-{
-	struct sock *s;
-
-	write_lock_bh(&x25_list_lock);
-
-	sk_for_each(s, &x25_list)
-		if (x25_sk(s)->neighbour && x25_sk(s)->neighbour->dev =3D=3D dev)
-			x25_disconnect(s, ENETUNREACH, 0, 0);
-
-	write_unlock_bh(&x25_list_lock);
-}
-
 /*
  *	Handle device status changes.
  */
@@ -260,7 +244,11 @@ static int x25_device_event(struct notifier_block *t=
his, unsigned long event,
 		case NETDEV_DOWN:
 			pr_debug("X.25: got event NETDEV_DOWN for device: %s\n",
 				 dev->name);
-			x25_kill_by_device(dev);
+			nb =3D x25_get_neigh(dev);
+			if (nb) {
+				x25_kill_by_neigh(nb);
+				x25_neigh_put(nb);
+			}
 			x25_route_device_down(dev);
 			x25_link_device_down(dev);
 			break;
diff --git a/net/x25/x25_route.c b/net/x25/x25_route.c
index 00e46c9a5280..ec2a39e9b3e6 100644
--- a/net/x25/x25_route.c
+++ b/net/x25/x25_route.c
@@ -115,9 +115,6 @@ void x25_route_device_down(struct net_device *dev)
 			__x25_remove_route(rt);
 	}
 	write_unlock_bh(&x25_route_list_lock);
-
-	/* Remove any related forwarding */
-	x25_clear_forward_by_dev(dev);
 }
=20
 /*
--=20
2.20.1

