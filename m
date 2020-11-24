Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7022C2189
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731352AbgKXJg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:36:26 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:56643 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731329AbgKXJgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:36:24 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1khUkF-000677-Pd; Tue, 24 Nov 2020 10:36:19 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1khUkF-00066e-5C; Tue, 24 Nov 2020 10:36:19 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id D2FF7240041;
        Tue, 24 Nov 2020 10:36:18 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 55525240040;
        Tue, 24 Nov 2020 10:36:18 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 2590720115;
        Tue, 24 Nov 2020 10:36:18 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v5 4/5] net/x25: fix restart request/confirm handling
Date:   Tue, 24 Nov 2020 10:35:37 +0100
Message-ID: <20201124093538.21177-5-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201124093538.21177-1-ms@dev.tdt.de>
References: <20201124093538.21177-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 151534::1606210579-00017060-AA459F4E/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have to take the actual link state into account to handle
restart requests/confirms well.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/x25/x25_link.c | 41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index 11e868aa625d..f92073f3cb11 100644
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
--=20
2.20.1

