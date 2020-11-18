Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97EB2B7EF0
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgKROAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:00:17 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:59597 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgKROAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:00:17 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfO0K-0003Pj-MG; Wed, 18 Nov 2020 15:00:12 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfO0J-0007Ee-I5; Wed, 18 Nov 2020 15:00:11 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 1BB43240041;
        Wed, 18 Nov 2020 15:00:11 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 9293F240040;
        Wed, 18 Nov 2020 15:00:10 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 435D020370;
        Wed, 18 Nov 2020 15:00:09 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v3 5/6] net/x25: fix restart request/confirm handling
Date:   Wed, 18 Nov 2020 14:59:18 +0100
Message-ID: <20201118135919.1447-6-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201118135919.1447-1-ms@dev.tdt.de>
References: <20201118135919.1447-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate-ID: 151534::1605708012-000037DC-5679FC1D/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have to take the actual link state into account to handle
restart requests/confirms well.

Also, the T20 timer needs to be stopped, if the link is terminated.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/x25/x25_link.c | 45 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index 92828a8a4ada..40ffc10f7a96 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -74,16 +74,43 @@ void x25_link_control(struct sk_buff *skb, struct x25=
_neigh *nb,
=20
 	switch (frametype) {
 	case X25_RESTART_REQUEST:
-		confirm =3D !x25_t20timer_pending(nb);
-		x25_stop_t20timer(nb);
-		nb->state =3D X25_LINK_STATE_3;
-		if (confirm)
+		switch (nb->state) {
+		case X25_LINK_STATE_2:
+			confirm =3D !x25_t20timer_pending(nb);
+			x25_stop_t20timer(nb);
+			nb->state =3D X25_LINK_STATE_3;
+			if (confirm)
+				x25_transmit_restart_confirmation(nb);
+			break;
+		case X25_LINK_STATE_3:
+			/* clear existing virtual calls */
+			x25_kill_by_neigh(nb);
+
 			x25_transmit_restart_confirmation(nb);
+			break;
+		}
 		break;
=20
 	case X25_RESTART_CONFIRMATION:
-		x25_stop_t20timer(nb);
-		nb->state =3D X25_LINK_STATE_3;
+		switch (nb->state) {
+		case X25_LINK_STATE_2:
+			if (x25_t20timer_pending(nb)) {
+				x25_stop_t20timer(nb);
+				nb->state =3D X25_LINK_STATE_3;
+			} else {
+				x25_transmit_restart_request(nb);
+				x25_start_t20timer(nb);
+			}
+			break;
+		case X25_LINK_STATE_3:
+			/* clear existing virtual calls */
+			x25_kill_by_neigh(nb);
+
+			x25_transmit_restart_request(nb);
+			nb->state =3D X25_LINK_STATE_2;
+			x25_start_t20timer(nb);
+			break;
+		}
 		break;
=20
 	case X25_DIAGNOSTIC:
@@ -214,8 +241,6 @@ void x25_link_established(struct x25_neigh *nb)
 {
 	switch (nb->state) {
 	case X25_LINK_STATE_0:
-		nb->state =3D X25_LINK_STATE_2;
-		break;
 	case X25_LINK_STATE_1:
 		x25_transmit_restart_request(nb);
 		nb->state =3D X25_LINK_STATE_2;
@@ -232,6 +257,10 @@ void x25_link_established(struct x25_neigh *nb)
 void x25_link_terminated(struct x25_neigh *nb)
 {
 	nb->state =3D X25_LINK_STATE_0;
+
+	if (x25_t20timer_pending(nb))
+		x25_stop_t20timer(nb);
+
 	/* Out of order: clear existing virtual calls (X.25 03/93 4.6.3) */
 	x25_kill_by_neigh(nb);
 }
--=20
2.20.1

