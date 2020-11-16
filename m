Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6AC2B4568
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbgKPOBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:01:01 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:36787 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbgKPOBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 09:01:00 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kef3w-0006Zt-Oa; Mon, 16 Nov 2020 15:00:56 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kef3v-0004cZ-Ll; Mon, 16 Nov 2020 15:00:55 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E494A240049;
        Mon, 16 Nov 2020 15:00:54 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 65F01240047;
        Mon, 16 Nov 2020 15:00:54 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id E3CCF21F0F;
        Mon, 16 Nov 2020 15:00:53 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v2 4/6] net/x25: support NETDEV_CHANGE notifier
Date:   Mon, 16 Nov 2020 14:55:24 +0100
Message-ID: <20201116135522.21791-5-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116135522.21791-1-ms@dev.tdt.de>
References: <20201116135522.21791-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-ID: 151534::1605535256-00000FB8-C62E8113/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes it possible to handle carrier lost and detection.
In case of carrier lost, we shutdown layer 3 and flush all sessions.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---

Change from v1:
fix 'subject_prefix' and 'checkpatch' warnings

---
 net/x25/af_x25.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 25726120fcc7..6a95ca11694e 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -275,6 +275,19 @@ static int x25_device_event(struct notifier_block *t=
his, unsigned long event,
 				 dev->name);
 			x25_link_device_remove(dev);
 			break;
+		case NETDEV_CHANGE:
+			pr_debug("X.25: got event NETDEV_CHANGE for device: %s\n",
+				 dev->name);
+			if (!netif_carrier_ok(dev)) {
+				pr_debug("X.25: Carrier lost -> set link state down: %s\n",
+					 dev->name);
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

