Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DDC2B7EE8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgKROAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:00:07 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:35239 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgKROAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:00:06 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfO0A-0001gE-KN; Wed, 18 Nov 2020 15:00:02 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfO09-0002og-Sz; Wed, 18 Nov 2020 15:00:01 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 6E30E240041;
        Wed, 18 Nov 2020 15:00:01 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id E5735240040;
        Wed, 18 Nov 2020 15:00:00 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id BE35B20370;
        Wed, 18 Nov 2020 15:00:00 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v3 3/6] net/lapb: handle carrier loss correctly
Date:   Wed, 18 Nov 2020 14:59:16 +0100
Message-ID: <20201118135919.1447-4-ms@dev.tdt.de>
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
X-purgate-ID: 151534::1605708002-00000FB8-B0D9A28E/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of carrier loss, clear all queues, enter state LABB_STATE_0 and
stop all timers.

By setting rc =3D LAPB_NOTCONNECTED, the upper layer is informed about th=
e
disconnect.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/lapb/lapb_iface.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 8dd7c420ae93..017bc169c334 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -303,6 +303,18 @@ int lapb_disconnect_request(struct net_device *dev)
 	if (!lapb)
 		goto out;
=20
+	if (!netif_carrier_ok(dev)) {
+		lapb_dbg(0, "(%p) Carrier lost!\n", lapb->dev);
+		lapb_dbg(0, "(%p) S%d -> S0\n", lapb->dev, lapb->state);
+		lapb_clear_queues(lapb);
+		lapb->state =3D LAPB_STATE_0;
+		lapb->n2count =3D 0;
+		lapb_stop_t1timer(lapb);
+		lapb_stop_t2timer(lapb);
+		rc =3D LAPB_NOTCONNECTED;
+		goto out_put;
+	}
+
 	switch (lapb->state) {
 	case LAPB_STATE_0:
 		rc =3D LAPB_NOTCONNECTED;
--=20
2.20.1

