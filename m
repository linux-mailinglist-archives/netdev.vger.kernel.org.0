Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD31F2B4551
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 14:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbgKPN4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 08:56:40 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:26269 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729475AbgKPN4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 08:56:39 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1keezj-0006O1-5o; Mon, 16 Nov 2020 14:56:35 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1keezi-0003me-A6; Mon, 16 Nov 2020 14:56:34 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 10B0B240049;
        Mon, 16 Nov 2020 14:56:34 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 87CE4240047;
        Mon, 16 Nov 2020 14:56:33 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 73878200AE;
        Mon, 16 Nov 2020 14:56:32 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v2 1/6] net/x25: handle additional netdev events
Date:   Mon, 16 Nov 2020 14:55:18 +0100
Message-ID: <20201116135522.21791-2-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116135522.21791-1-ms@dev.tdt.de>
References: <20201116135522.21791-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate: clean
X-purgate-ID: 151534::1605534994-0001FA9D-D7499192/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add / remove x25_link_device by NETDEV_REGISTER/UNREGISTER and also by
NETDEV_POST_TYPE_CHANGE/NETDEV_PRE_TYPE_CHANGE.

This change is needed so that the x25_neigh struct for an interface is
already created when it shows up and is kept independently if the
interface goes UP or DOWN.

This is used in the next commit, where x25 params of an neighbour will
get configurable through ioctls.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---

Change from v1:
fix 'subject_prefix' and 'checkpatch' warnings

---
 include/net/x25.h  |  2 ++
 net/x25/af_x25.c   | 26 ++++++++++++++++++++++++++
 net/x25/x25_link.c | 45 +++++++++++++++++++++++++++++++++++++++------
 3 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/include/net/x25.h b/include/net/x25.h
index d7d6c2b4ffa7..4c1502e8b2b2 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -231,6 +231,8 @@ int x25_backlog_rcv(struct sock *, struct sk_buff *);
=20
 /* x25_link.c */
 void x25_link_control(struct sk_buff *, struct x25_neigh *, unsigned sho=
rt);
+void x25_link_device_add(struct net_device *dev);
+void x25_link_device_remove(struct net_device *dev);
 void x25_link_device_up(struct net_device *);
 void x25_link_device_down(struct net_device *);
 void x25_link_established(struct x25_neigh *);
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 046d3fee66a9..d2a52c254cca 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -233,10 +233,24 @@ static int x25_device_event(struct notifier_block *=
this, unsigned long event,
 #endif
 	 ) {
 		switch (event) {
+		case NETDEV_REGISTER:
+			pr_debug("X.25: got event NETDEV_REGISTER for device: %s\n",
+				 dev->name);
+			x25_link_device_add(dev);
+			break;
+		case NETDEV_POST_TYPE_CHANGE:
+			pr_debug("X.25: got event NETDEV_POST_TYPE_CHANGE for device: %s\n",
+				 dev->name);
+			x25_link_device_add(dev);
+			break;
 		case NETDEV_UP:
+			pr_debug("X.25: got event NETDEV_UP for device: %s\n",
+				 dev->name);
 			x25_link_device_up(dev);
 			break;
 		case NETDEV_GOING_DOWN:
+			pr_debug("X.25: got event NETDEV_GOING_DOWN for device: %s\n",
+				 dev->name);
 			nb =3D x25_get_neigh(dev);
 			if (nb) {
 				x25_terminate_link(nb);
@@ -244,10 +258,22 @@ static int x25_device_event(struct notifier_block *=
this, unsigned long event,
 			}
 			break;
 		case NETDEV_DOWN:
+			pr_debug("X.25: got event NETDEV_DOWN for device: %s\n",
+				 dev->name);
 			x25_kill_by_device(dev);
 			x25_route_device_down(dev);
 			x25_link_device_down(dev);
 			break;
+		case NETDEV_PRE_TYPE_CHANGE:
+			pr_debug("X.25: got event NETDEV_PRE_TYPE_CHANGE for device: %s\n",
+				 dev->name);
+			x25_link_device_remove(dev);
+			break;
+		case NETDEV_UNREGISTER:
+			pr_debug("X.25: got event NETDEV_UNREGISTER for device: %s\n",
+				 dev->name);
+			x25_link_device_remove(dev);
+			break;
 		}
 	}
=20
diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index fdae054b7dc1..92828a8a4ada 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -239,9 +239,17 @@ void x25_link_terminated(struct x25_neigh *nb)
 /*
  *	Add a new device.
  */
-void x25_link_device_up(struct net_device *dev)
+void x25_link_device_add(struct net_device *dev)
 {
-	struct x25_neigh *nb =3D kmalloc(sizeof(*nb), GFP_ATOMIC);
+	struct x25_neigh *nb =3D x25_get_neigh(dev);
+
+	/* Check, if we already have a neighbour for this device */
+	if (nb) {
+		x25_neigh_put(nb);
+		return;
+	}
+
+	nb =3D kmalloc(sizeof(*nb), GFP_ATOMIC);
=20
 	if (!nb)
 		return;
@@ -268,6 +276,20 @@ void x25_link_device_up(struct net_device *dev)
 	write_unlock_bh(&x25_neigh_list_lock);
 }
=20
+/* A device is coming up */
+void x25_link_device_up(struct net_device *dev)
+{
+	struct x25_neigh *nb =3D x25_get_neigh(dev);
+
+	if (!nb)
+		return;
+
+	nb->state =3D X25_LINK_STATE_1;
+	x25_establish_link(nb);
+
+	x25_neigh_put(nb);
+}
+
 /**
  *	__x25_remove_neigh - remove neighbour from x25_neigh_list
  *	@nb: - neigh to remove
@@ -277,9 +299,6 @@ void x25_link_device_up(struct net_device *dev)
  */
 static void __x25_remove_neigh(struct x25_neigh *nb)
 {
-	skb_queue_purge(&nb->queue);
-	x25_stop_t20timer(nb);
-
 	if (nb->node.next) {
 		list_del(&nb->node);
 		x25_neigh_put(nb);
@@ -289,7 +308,7 @@ static void __x25_remove_neigh(struct x25_neigh *nb)
 /*
  *	A device has been removed, remove its links.
  */
-void x25_link_device_down(struct net_device *dev)
+void x25_link_device_remove(struct net_device *dev)
 {
 	struct x25_neigh *nb;
 	struct list_head *entry, *tmp;
@@ -308,6 +327,20 @@ void x25_link_device_down(struct net_device *dev)
 	write_unlock_bh(&x25_neigh_list_lock);
 }
=20
+/* A device is going down */
+void x25_link_device_down(struct net_device *dev)
+{
+	struct x25_neigh *nb =3D x25_get_neigh(dev);
+
+	if (!nb)
+		return;
+
+	skb_queue_purge(&nb->queue);
+	x25_stop_t20timer(nb);
+
+	x25_neigh_put(nb);
+}
+
 /*
  *	Given a device, return the neighbour address.
  */
--=20
2.20.1

