Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1DA3F8DCD
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfKLLQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:16:40 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41209 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfKLLQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:16:39 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9T-0003FB-Oi; Tue, 12 Nov 2019 12:16:03 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9S-0004ym-Ct; Tue, 12 Nov 2019 12:16:02 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 5/9] can: j1939: transport: make sure the aborted session will be deactivated only once
Date:   Tue, 12 Nov 2019 12:15:56 +0100
Message-Id: <20191112111600.18719-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191112111600.18719-1-o.rempel@pengutronix.de>
References: <20191112111600.18719-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

j1939_session_cancel() was modifying session->state without protecting
it by locks and without checking actual state of the session.

This patch moves j1939_tp_set_rxtimeout() into j1939_session_cancel()
and adds the missing locking.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/transport.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index e5f1a56994c6..ecdedfc0b10c 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1042,12 +1042,13 @@ j1939_session_deactivate_activate_next(struct j1939_session *session)
 		j1939_sk_queue_activate_next(session);
 }
 
-static void j1939_session_cancel(struct j1939_session *session,
+static void __j1939_session_cancel(struct j1939_session *session,
 				 enum j1939_xtp_abort err)
 {
 	struct j1939_priv *priv = session->priv;
 
 	WARN_ON_ONCE(!err);
+	lockdep_assert_held(&session->priv->active_session_list_lock);
 
 	session->err = j1939_xtp_abort_to_errno(priv, err);
 	/* do not send aborts on incoming broadcasts */
@@ -1062,6 +1063,20 @@ static void j1939_session_cancel(struct j1939_session *session,
 		j1939_sk_send_loop_abort(session->sk, session->err);
 }
 
+static void j1939_session_cancel(struct j1939_session *session,
+				 enum j1939_xtp_abort err)
+{
+	j1939_session_list_lock(session->priv);
+
+	if (session->state >= J1939_SESSION_ACTIVE &&
+	    session->state < J1939_SESSION_WAITING_ABORT) {
+		j1939_tp_set_rxtimeout(session, J1939_XTP_ABORT_TIMEOUT_MS);
+		__j1939_session_cancel(session, err);
+	}
+
+	j1939_session_list_unlock(session->priv);
+}
+
 static enum hrtimer_restart j1939_tp_txtimer(struct hrtimer *hrtimer)
 {
 	struct j1939_session *session =
@@ -1108,8 +1123,6 @@ static enum hrtimer_restart j1939_tp_txtimer(struct hrtimer *hrtimer)
 		netdev_alert(priv->ndev, "%s: 0x%p: tx aborted with unknown reason: %i\n",
 			     __func__, session, ret);
 		if (session->skcb.addr.type != J1939_SIMPLE) {
-			j1939_tp_set_rxtimeout(session,
-					       J1939_XTP_ABORT_TIMEOUT_MS);
 			j1939_session_cancel(session, J1939_XTP_ABORT_OTHER);
 		} else {
 			session->err = ret;
@@ -1169,7 +1182,7 @@ static enum hrtimer_restart j1939_tp_rxtimer(struct hrtimer *hrtimer)
 			hrtimer_start(&session->rxtimer,
 				      ms_to_ktime(J1939_XTP_ABORT_TIMEOUT_MS),
 				      HRTIMER_MODE_REL_SOFT);
-			j1939_session_cancel(session, J1939_XTP_ABORT_TIMEOUT);
+			__j1939_session_cancel(session, J1939_XTP_ABORT_TIMEOUT);
 		}
 		j1939_session_list_unlock(session->priv);
 	}
@@ -1375,7 +1388,6 @@ j1939_xtp_rx_cts_one(struct j1939_session *session, struct sk_buff *skb)
 
  out_session_cancel:
 	j1939_session_timers_cancel(session);
-	j1939_tp_set_rxtimeout(session, J1939_XTP_ABORT_TIMEOUT_MS);
 	j1939_session_cancel(session, err);
 }
 
@@ -1572,7 +1584,6 @@ static int j1939_xtp_rx_rts_session_active(struct j1939_session *session,
 
 		/* RTS on active session */
 		j1939_session_timers_cancel(session);
-		j1939_tp_set_rxtimeout(session, J1939_XTP_ABORT_TIMEOUT_MS);
 		j1939_session_cancel(session, J1939_XTP_ABORT_BUSY);
 	}
 
@@ -1583,7 +1594,6 @@ static int j1939_xtp_rx_rts_session_active(struct j1939_session *session,
 			     session->last_cmd);
 
 		j1939_session_timers_cancel(session);
-		j1939_tp_set_rxtimeout(session, J1939_XTP_ABORT_TIMEOUT_MS);
 		j1939_session_cancel(session, J1939_XTP_ABORT_BUSY);
 
 		return -EBUSY;
@@ -1785,7 +1795,6 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 
  out_session_cancel:
 	j1939_session_timers_cancel(session);
-	j1939_tp_set_rxtimeout(session, J1939_XTP_ABORT_TIMEOUT_MS);
 	j1939_session_cancel(session, J1939_XTP_ABORT_FAULT);
 	j1939_session_put(session);
 }
-- 
2.24.0.rc1

