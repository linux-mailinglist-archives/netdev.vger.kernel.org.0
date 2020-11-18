Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00262B7EE5
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgKROAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:00:03 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:50425 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgKROAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:00:02 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfO07-0007gw-1V; Wed, 18 Nov 2020 14:59:59 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfO06-0003Cs-44; Wed, 18 Nov 2020 14:59:58 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id A88C1240041;
        Wed, 18 Nov 2020 14:59:57 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 2AD1C240040;
        Wed, 18 Nov 2020 14:59:57 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 02F3920370;
        Wed, 18 Nov 2020 14:59:57 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v3 2/6] net/lapb: fix lapb_connect_request() for DCE
Date:   Wed, 18 Nov 2020 14:59:15 +0100
Message-ID: <20201118135919.1447-3-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201118135919.1447-1-ms@dev.tdt.de>
References: <20201118135919.1447-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 151534::1605707998-0000CF01-42F1A3D6/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a DTE interface we should change to state LAPB_STATE_1 and start
sending SABM(E). But for DCE interfaces, we simply should start the
timer t1.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/lapb/lapb_iface.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 3c03f6512c5f..8dd7c420ae93 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -278,10 +278,14 @@ int lapb_connect_request(struct net_device *dev)
 	if (lapb->state =3D=3D LAPB_STATE_3 || lapb->state =3D=3D LAPB_STATE_4)
 		goto out_put;
=20
-	lapb_establish_data_link(lapb);
+	if (lapb->mode & LAPB_DCE) {
+		lapb_start_t1timer(lapb);
+	} else {
+		lapb_establish_data_link(lapb);
=20
-	lapb_dbg(0, "(%p) S0 -> S1\n", lapb->dev);
-	lapb->state =3D LAPB_STATE_1;
+		lapb_dbg(0, "(%p) S0 -> S1\n", lapb->dev);
+		lapb->state =3D LAPB_STATE_1;
+	}
=20
 	rc =3D LAPB_OK;
 out_put:
--=20
2.20.1

