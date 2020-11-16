Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628272B3DBB
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 08:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbgKPHcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 02:32:25 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:15007 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgKPHcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 02:32:24 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1keYzt-0009nU-2b; Mon, 16 Nov 2020 08:32:21 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1keYzs-000TJd-C9; Mon, 16 Nov 2020 08:32:20 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 21570240049;
        Mon, 16 Nov 2020 08:32:20 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 99E4A240047;
        Mon, 16 Nov 2020 08:32:19 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 4206920115;
        Mon, 16 Nov 2020 08:32:19 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH 3/6] net/x25: replace x25_kill_by_device with x25_kill_by_neigh
Date:   Mon, 16 Nov 2020 08:31:46 +0100
Message-ID: <20201116073149.23219-3-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116073149.23219-1-ms@dev.tdt.de>
References: <20201116073149.23219-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate-ID: 151534::1605511940-000035B9-6690B712/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary function x25_kill_by_device.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/x25/af_x25.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 439ae65ab7a8..d98d1145500e 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -210,22 +210,6 @@ static void x25_remove_socket(struct sock *sk)
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
@@ -266,7 +250,11 @@ static int x25_device_event(struct notifier_block *t=
his, unsigned long event,
 			break;
 		case NETDEV_DOWN:
 			pr_debug("X.25: got event NETDEV_DOWN for device: %s\n", dev->name);
-			x25_kill_by_device(dev);
+			nb =3D x25_get_neigh(dev);
+			if (nb) {
+				x25_kill_by_neigh(nb);
+				x25_neigh_put(nb);
+			}
 			x25_route_device_down(dev);
 			x25_link_device_down(dev);
 			break;
--=20
2.20.1

