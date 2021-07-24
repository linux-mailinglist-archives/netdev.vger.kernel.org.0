Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8333D48D4
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhGXQjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 12:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhGXQjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 12:39:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C7DC061765
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 10:20:04 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m7LJi-0002Uf-Sw
        for netdev@vger.kernel.org; Sat, 24 Jul 2021 19:20:02 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0B1A96569DF
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 17:19:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 18C776569AF;
        Sat, 24 Jul 2021 17:19:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ee14ced9;
        Sat, 24 Jul 2021 17:19:53 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>,
        Xiaochen Zou <xzou017@ucr.edu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 3/6] can: j1939: j1939_session_deactivate(): clarify lifetime of session object
Date:   Sat, 24 Jul 2021 19:19:44 +0200
Message-Id: <20210724171947.547867-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724171947.547867-1-mkl@pengutronix.de>
References: <20210724171947.547867-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

The j1939_session_deactivate() is decrementing the session ref-count and
potentially can free() the session. This would cause use-after-free
situation.

However, the code calling j1939_session_deactivate() does always hold
another reference to the session, so that it would not be free()ed in
this code path.

This patch adds a comment to make this clear and a WARN_ON, to ensure
that future changes will not violate this requirement. Further this
patch avoids dereferencing the session pointer as a precaution to avoid
use-after-free if the session is actually free()ed.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/r/20210714111602.24021-1-o.rempel@pengutronix.de
Reported-by: Xiaochen Zou <xzou017@ucr.edu>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index c3946c355882..bb1092c3e7e3 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1075,11 +1075,16 @@ static bool j1939_session_deactivate_locked(struct j1939_session *session)
 
 static bool j1939_session_deactivate(struct j1939_session *session)
 {
+	struct j1939_priv *priv = session->priv;
 	bool active;
 
-	j1939_session_list_lock(session->priv);
+	j1939_session_list_lock(priv);
+	/* This function should be called with a session ref-count of at
+	 * least 2.
+	 */
+	WARN_ON_ONCE(kref_read(&session->kref) < 2);
 	active = j1939_session_deactivate_locked(session);
-	j1939_session_list_unlock(session->priv);
+	j1939_session_list_unlock(priv);
 
 	return active;
 }
-- 
2.30.2


