Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A1D430C20
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 23:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344607AbhJQVEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 17:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbhJQVEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 17:04:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAB2C061769
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 14:01:53 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcDI0-0000Eh-Ak
        for netdev@vger.kernel.org; Sun, 17 Oct 2021 23:01:52 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 38AEF695EDF
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 21:01:47 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7C9A0695EAE;
        Sun, 17 Oct 2021 21:01:44 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e5515fbf;
        Sun, 17 Oct 2021 21:01:43 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Ziyang Xuan <william.xuanziyang@huawei.com>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 01/11] can: j1939: j1939_tp_rxtimer(): fix errant alert in j1939_tp_rxtimer
Date:   Sun, 17 Oct 2021 23:01:32 +0200
Message-Id: <20211017210142.2108610-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211017210142.2108610-1-mkl@pengutronix.de>
References: <20211017210142.2108610-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

When the session state is J1939_SESSION_DONE, j1939_tp_rxtimer() will
give an alert "rx timeout, send abort", but do nothing actually. Move
the alert into session active judgment condition, it is more
reasonable.

One of the scenarios is that j1939_tp_rxtimer() execute followed by
j1939_xtp_rx_abort_one(). After j1939_xtp_rx_abort_one(), the session
state is J1939_SESSION_DONE, then j1939_tp_rxtimer() give an alert.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/20210906094219.95924-1-william.xuanziyang@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index bb5c4b8979be..bfb0718d4587 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1237,12 +1237,11 @@ static enum hrtimer_restart j1939_tp_rxtimer(struct hrtimer *hrtimer)
 		session->err = -ETIME;
 		j1939_session_deactivate(session);
 	} else {
-		netdev_alert(priv->ndev, "%s: 0x%p: rx timeout, send abort\n",
-			     __func__, session);
-
 		j1939_session_list_lock(session->priv);
 		if (session->state >= J1939_SESSION_ACTIVE &&
 		    session->state < J1939_SESSION_ACTIVE_MAX) {
+			netdev_alert(priv->ndev, "%s: 0x%p: rx timeout, send abort\n",
+				     __func__, session);
 			j1939_session_get(session);
 			hrtimer_start(&session->rxtimer,
 				      ms_to_ktime(J1939_XTP_ABORT_TIMEOUT_MS),

base-commit: fac3cb82a54a4b7c49c932f96ef196cf5774344c
-- 
2.33.0


