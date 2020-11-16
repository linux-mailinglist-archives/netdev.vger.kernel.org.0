Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E11A2B3DC0
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 08:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgKPHcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 02:32:43 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:47866 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgKPHcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 02:32:42 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1keZ09-000JE0-EL; Mon, 16 Nov 2020 08:32:37 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1keZ08-0009r6-MW; Mon, 16 Nov 2020 08:32:36 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 727CD240049;
        Mon, 16 Nov 2020 08:32:36 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id E9933240047;
        Mon, 16 Nov 2020 08:32:35 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 6F98D20115;
        Mon, 16 Nov 2020 08:32:34 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH 5/6] net/lapb: support netdev events
Date:   Mon, 16 Nov 2020 08:31:48 +0100
Message-ID: <20201116073149.23219-5-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116073149.23219-1-ms@dev.tdt.de>
References: <20201116073149.23219-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate-ID: 151534::1605511957-0001632B-23B66B13/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes it possible to handle carrier loss and detection.
In case of Carrier Loss, layer 2 is terminated
In case of Carrier Detection, we start timer t1 on a DCE interface,
and on a DTE interface we change to state LAPB_STATE_1 and start
sending SABM(E).

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/lapb/lapb_iface.c | 74 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 3c03f6512c5f..6a109c8c286f 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -418,14 +418,88 @@ int lapb_data_transmit(struct lapb_cb *lapb, struct=
 sk_buff *skb)
 	return used;
 }
=20
+/*
+ *	Handle device status changes.
+ */
+static int lapb_device_event(struct notifier_block *this, unsigned long =
event,
+			    void *ptr)
+{
+	struct net_device *dev =3D ptr;
+	struct lapb_cb *lapb;
+
+	if (!net_eq(dev_net(dev), &init_net))
+		return NOTIFY_DONE;
+
+	if (dev->type =3D=3D ARPHRD_X25) {
+		switch (event) {
+		case NETDEV_REGISTER:
+			lapb_dbg(0, "(%p): got event NETDEV_REGISTER for device: %s\n", dev, =
dev->name);
+			break;
+		case NETDEV_POST_TYPE_CHANGE:
+			lapb_dbg(0, "(%p): got event NETDEV_POST_TYPE_CHANGE for device: %s\n=
", dev, dev->name);
+			break;
+		case NETDEV_UP:
+			lapb_dbg(0, "(%p): got event NETDEV_UP for device: %s\n", dev, dev->n=
ame);
+			break;
+		case NETDEV_GOING_DOWN:
+			lapb_dbg(0, "(%p): got event NETDEV_GOING_DOWN for device: %s\n", dev=
, dev->name);
+			break;
+		case NETDEV_DOWN:
+			lapb_dbg(0, "(%p): got event NETDEV_DOWN for device: %s\n", dev, dev-=
>name);
+			break;
+		case NETDEV_PRE_TYPE_CHANGE:
+			lapb_dbg(0, "(%p): got event NETDEV_PRE_TYPE_CHANGE for device: %s\n"=
, dev, dev->name);
+			break;
+		case NETDEV_UNREGISTER:
+			lapb_dbg(0, "(%p): got event NETDEV_UNREGISTER for device: %s\n", dev=
, dev->name);
+			break;
+		case NETDEV_CHANGE:
+			lapb_dbg(0, "(%p): got event NETDEV_CHANGE for device: %s\n", dev, de=
v->name);
+			lapb =3D lapb_devtostruct(dev);
+			if (lapb) {
+				if (!netif_carrier_ok(dev)) {
+					lapb_dbg(0, "(%p): Carrier lost -> Entering LAPB_STATE_0: %s\n", de=
v, dev->name);
+					lapb_disconnect_indication(lapb, LAPB_OK);
+					lapb_clear_queues(lapb);
+					lapb->state =3D LAPB_STATE_0;
+					lapb->n2count   =3D 0;
+					lapb_stop_t1timer(lapb);
+					lapb_stop_t2timer(lapb);
+				} else {
+					lapb_dbg(0, "(%p): Carrier detected: %s\n", dev, dev->name);
+					if (lapb->mode & LAPB_DCE) {
+						lapb_start_t1timer(lapb);
+					} else {
+						if (lapb->state =3D=3D LAPB_STATE_0) {
+							lapb->state =3D LAPB_STATE_1;
+							lapb_establish_data_link(lapb);
+						}
+					}
+				}
+			}
+			break;
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block lapb_dev_notifier =3D {
+	.notifier_call =3D lapb_device_event,
+};
+
 static int __init lapb_init(void)
 {
+	register_netdevice_notifier(&lapb_dev_notifier);
+
 	return 0;
 }
=20
 static void __exit lapb_exit(void)
 {
 	WARN_ON(!list_empty(&lapb_list));
+
+	unregister_netdevice_notifier(&lapb_dev_notifier);
 }
=20
 MODULE_AUTHOR("Jonathan Naylor <g4klx@g4klx.demon.co.uk>");
--=20
2.20.1

