Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA3F2C2187
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731337AbgKXJgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:36:23 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:36390 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731310AbgKXJgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 04:36:19 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1khUkB-000PIb-4V; Tue, 24 Nov 2020 10:36:15 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1khUkA-000AJE-9s; Tue, 24 Nov 2020 10:36:14 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 11591240041;
        Tue, 24 Nov 2020 10:36:14 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 88F5E240040;
        Tue, 24 Nov 2020 10:36:13 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 1775020115;
        Tue, 24 Nov 2020 10:36:13 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v5 3/5] net/lapb: fix t1 timer handling for LAPB_STATE_0
Date:   Tue, 24 Nov 2020 10:35:36 +0100
Message-ID: <20201124093538.21177-4-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201124093538.21177-1-ms@dev.tdt.de>
References: <20201124093538.21177-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-ID: 151534::1606210574-00016B9D-9671951C/0/0
X-purgate-type: clean
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. DTE interface changes immediately to LAPB_STATE_1 and start sending
   SABM(E).

2. DCE interface sends N2-times DM and changes to LAPB_STATE_1
   afterwards if there is no response in the meantime.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/lapb/lapb_timer.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/lapb/lapb_timer.c b/net/lapb/lapb_timer.c
index 8f5b17001a07..baa247fe4ed0 100644
--- a/net/lapb/lapb_timer.c
+++ b/net/lapb/lapb_timer.c
@@ -85,11 +85,18 @@ static void lapb_t1timer_expiry(struct timer_list *t)
 	switch (lapb->state) {
=20
 		/*
-		 *	If we are a DCE, keep going DM .. DM .. DM
+		 *	If we are a DCE, send DM up to N2 times, then switch to
+		 *	STATE_1 and send SABM(E).
 		 */
 		case LAPB_STATE_0:
-			if (lapb->mode & LAPB_DCE)
+			if (lapb->mode & LAPB_DCE &&
+			    lapb->n2count !=3D lapb->n2) {
+				lapb->n2count++;
 				lapb_send_control(lapb, LAPB_DM, LAPB_POLLOFF, LAPB_RESPONSE);
+			} else {
+				lapb->state =3D LAPB_STATE_1;
+				lapb_establish_data_link(lapb);
+			}
 			break;
=20
 		/*
--=20
2.20.1

