Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3153C838F
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 13:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbhGNLTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 07:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239107AbhGNLTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 07:19:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD580C06175F
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 04:16:14 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m3cs1-0004zK-SF; Wed, 14 Jul 2021 13:16:05 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m3crz-0006GJ-S7; Wed, 14 Jul 2021 13:16:03 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Xiaochen Zou <xzou017@ucr.edu>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: [PATCH v1] can: j1939: j1939_session_deactivate(): clarify lifetime of session object
Date:   Wed, 14 Jul 2021 13:16:02 +0200
Message-Id: <20210714111602.24021-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
Reported-by: Xiaochen Zou <xzou017@ucr.edu>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/transport.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index cb358646e382..cff9812a5585 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1056,11 +1056,16 @@ static bool j1939_session_deactivate_locked(struct j1939_session *session)
 
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

