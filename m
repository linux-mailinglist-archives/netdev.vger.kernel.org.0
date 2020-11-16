Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8050E2B3DBE
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 08:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgKPHcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 02:32:33 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:52677 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgKPHcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 02:32:32 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1keYzz-0007TU-Rk; Mon, 16 Nov 2020 08:32:27 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1keYzy-0000GH-O6; Mon, 16 Nov 2020 08:32:26 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 51584240049;
        Mon, 16 Nov 2020 08:32:26 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id C9173240047;
        Mon, 16 Nov 2020 08:32:25 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id A0FEE20115;
        Mon, 16 Nov 2020 08:32:25 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH 4/6] net/x25: support NETDEV_CHANGE notifier
Date:   Mon, 16 Nov 2020 08:31:47 +0100
Message-ID: <20201116073149.23219-4-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116073149.23219-1-ms@dev.tdt.de>
References: <20201116073149.23219-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-ID: 151534::1605511947-00000FB8-DEB0FE5B/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes it possible to handle carrier lost and detection.
In case of carrier lost, we shutdown layer 3 and flush all sessions.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/x25/af_x25.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index d98d1145500e..d61a154b94e4 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -266,6 +266,17 @@ static int x25_device_event(struct notifier_block *t=
his, unsigned long event,
 			pr_debug("X.25: got event NETDEV_UNREGISTER for device: %s\n", dev->n=
ame);
 			x25_link_device_remove(dev);
 			break;
+		case NETDEV_CHANGE:
+			pr_debug("X.25: got event NETDEV_CHANGE for device: %s\n", dev->name)=
;
+			if (!netif_carrier_ok(dev)) {
+				pr_debug("X.25: Carrier lost -> set link state down: %s\n", dev->nam=
e);
+				nb =3D x25_get_neigh(dev);
+				if (nb) {
+					x25_link_terminated(nb);
+					x25_neigh_put(nb);
+				}
+			}
+			break;
 		}
 	}
=20
--=20
2.20.1

