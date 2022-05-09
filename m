Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698A0520346
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239703AbiEIRLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239678AbiEIRLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:11:51 -0400
Received: from smtpcmd12132.aruba.it (smtpcmd12132.aruba.it [62.149.156.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2105D1A29FF
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:07:50 -0700 (PDT)
Received: from localhost.localdomain ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id o6rMnQWIJPF2eo6rNnMWrE; Mon, 09 May 2022 19:07:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1652116069; bh=zvVK/aJmzUqFc4aX2Dp9ESZBj1t6/6l/2t/r1bpWoG8=;
        h=From:To:Subject:Date:MIME-Version;
        b=lQ157Da+dz0osRvnK56TRcyoleZNnP4wCa/jp5k+RTv9jWe0TnIU0peTyk0X8djMs
         XQmesQJTINHx3MSp5H1hagtyqIDWjoXKWjes3V4DZXK7cQbK+scmdFBg3o6AznqZ3c
         MyouYpVCH9bhTzFYfZXmwQHo9/cquYCiXZ9/garwLif+QRrAwD/0YG2h9RNEIiUxV5
         FfKjVbpQXaGjAt8YrCjVLV5p1pNjzVvoV+l53+A97yWnFyhJoYGB6enNa0r3kEcIFj
         67uBHeOBp3I6anpZBnT5rXOwit8/NfcPKXL6lluQsaChhsQSwCiCnXCnnknyf/lIMb
         TNK5it2ifcyqg==
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Subject: [PATCH RESEND 2/2] can: j1939: make sure that sent CTL frames are marked as TX
Date:   Mon,  9 May 2022 19:07:46 +0200
Message-Id: <20220509170746.29893-3-devid.filoni@egluetechnologies.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220509170746.29893-1-devid.filoni@egluetechnologies.com>
References: <20220509170746.29893-1-devid.filoni@egluetechnologies.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfF2xFHXIDDCHho1rSwAjnvHsr7MldqGXEXI/b06PUrL496M8myXTv1OYev0GlY3MhHta2oerXL+X3ejE9wxBNBRWHhDg8gnJeBe6Zt7lbA5xl+qb8WJy
 9YS6eDR+qU4jExyX2T4gcH9ypA/BfT6VQ2lMPcM36m2QGW9CACGUemajuzJSsjqAOcnVH8+nN0X9Gf2z5Srt6/Pz21IVh2pwa+FP9HqX42SkYml+IQb2a4nE
 TN5WNQWGhzDrA/XN18oCuHdfd4O/ZJkwAzfJ0EqMsrFiFAC+Yi3+6FMahBz7aCV/Q6UnUPaOhucYZ3ZrFFC1n1FZj9wf6vuqsw67eu4y5a+PQ2mnP6HMbDSH
 E5xsrS7JqJmRG7eIjt0cJt0sTpOIS8heGcVUYiK/s8XlFW3b3CTd1KCaJ3FNcdYysR45qknJoFdBvguIkYTmiRp/js/y3g+NrhJZ3y9K5n6F+tGcvx8uKECh
 mfkLbaagIFG1o2AMXEJbpcjRs7OW0NQgEa58XvOMFOWicByCMoNfwIkNEXWHmLS/ZsE3JWcteS2o5xVwvwrJhGVNSbFJgVHBQLJYeRIncxK4O56sJ3pM7f6A
 hqnDgp09+rSA8OTzkWjgyIQXKon7VQDf02RMToDorF6lK9eyB19MKbEuXNC8f4wJUXIPRSCTGR7X/ZIsBy2hxuQe3nn8gFXOSbrssuXC/MyXTQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 9d71dd0 ("can: add support of SAE J1939 protocol")
Signed-off-by: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
---
 net/can/j1939/transport.c | 55 +++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 030f5fe901e1..b8368f9c78c2 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -648,6 +648,7 @@ static int j1939_tp_tx_dat(struct j1939_session *session,
 }
 
 static int j1939_xtp_do_tx_ctl(struct j1939_priv *priv,
+			       struct sock *re_sk,
 			       const struct j1939_sk_buff_cb *re_skcb,
 			       bool swap_src_dst, pgn_t pgn, const u8 *dat)
 {
@@ -661,6 +662,8 @@ static int j1939_xtp_do_tx_ctl(struct j1939_priv *priv,
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
+	can_skb_set_owner(skb, re_sk);
+
 	skdat = skb_put(skb, 8);
 	memcpy(skdat, dat, 5);
 	skdat[5] = (pgn >> 0);
@@ -674,13 +677,26 @@ static inline int j1939_tp_tx_ctl(struct j1939_session *session,
 				  bool swap_src_dst, const u8 *dat)
 {
 	struct j1939_priv *priv = session->priv;
+	struct sk_buff *se_skb = j1939_session_skb_get(session);
+	struct sock *se_skb_sk = NULL;
+	int ret;
+
+	if (se_skb)
+		se_skb_sk = se_skb->sk;
 
-	return j1939_xtp_do_tx_ctl(priv, &session->skcb,
-				   swap_src_dst,
-				   session->skcb.addr.pgn, dat);
+	ret = j1939_xtp_do_tx_ctl(priv, se_skb_sk, &session->skcb,
+				  swap_src_dst,
+				  session->skcb.addr.pgn, dat);
+
+	if (ret)
+		kfree_skb(se_skb);
+	else
+		consume_skb(se_skb);
+	return ret;
 }
 
 static int j1939_xtp_tx_abort(struct j1939_priv *priv,
+			      struct sock *re_sk,
 			      const struct j1939_sk_buff_cb *re_skcb,
 			      bool swap_src_dst,
 			      enum j1939_xtp_abort err,
@@ -694,7 +710,7 @@ static int j1939_xtp_tx_abort(struct j1939_priv *priv,
 	memset(dat, 0xff, sizeof(dat));
 	dat[0] = J1939_TP_CMD_ABORT;
 	dat[1] = err;
-	return j1939_xtp_do_tx_ctl(priv, re_skcb, swap_src_dst, pgn, dat);
+	return j1939_xtp_do_tx_ctl(priv, re_sk, re_skcb, swap_src_dst, pgn, dat);
 }
 
 void j1939_tp_schedule_txtimer(struct j1939_session *session, int msec)
@@ -1117,6 +1133,8 @@ static void __j1939_session_cancel(struct j1939_session *session,
 				   enum j1939_xtp_abort err)
 {
 	struct j1939_priv *priv = session->priv;
+	struct sk_buff *se_skb;
+	struct sock *se_skb_sk = NULL;
 
 	WARN_ON_ONCE(!err);
 	lockdep_assert_held(&session->priv->active_session_list_lock);
@@ -1125,9 +1143,15 @@ static void __j1939_session_cancel(struct j1939_session *session,
 	session->state = J1939_SESSION_WAITING_ABORT;
 	/* do not send aborts on incoming broadcasts */
 	if (!j1939_cb_is_broadcast(&session->skcb)) {
-		j1939_xtp_tx_abort(priv, &session->skcb,
-				   !session->transmission,
-				   err, session->skcb.addr.pgn);
+		se_skb = j1939_session_skb_get(session);
+		if (se_skb)
+			se_skb_sk = se_skb->sk;
+		if (j1939_xtp_tx_abort(priv, se_skb_sk, &session->skcb,
+				       !session->transmission,
+				       err, session->skcb.addr.pgn))
+			kfree_skb(se_skb);
+		else
+			consume_skb(se_skb);
 	}
 
 	if (session->sk)
@@ -1274,6 +1298,8 @@ static bool j1939_xtp_rx_cmd_bad_pgn(struct j1939_session *session,
 	const struct j1939_sk_buff_cb *skcb = j1939_skb_to_cb(skb);
 	pgn_t pgn = j1939_xtp_ctl_to_pgn(skb->data);
 	struct j1939_priv *priv = session->priv;
+	struct sk_buff *se_skb;
+	struct sock *se_skb_sk = NULL;
 	enum j1939_xtp_abort abort = J1939_XTP_NO_ABORT;
 	u8 cmd = skb->data[0];
 
@@ -1318,8 +1344,15 @@ static bool j1939_xtp_rx_cmd_bad_pgn(struct j1939_session *session,
 
 	netdev_warn(priv->ndev, "%s: 0x%p: CMD 0x%02x with PGN 0x%05x for running session with different PGN 0x%05x.\n",
 		    __func__, session, cmd, pgn, session->skcb.addr.pgn);
-	if (abort != J1939_XTP_NO_ABORT)
-		j1939_xtp_tx_abort(priv, skcb, true, abort, pgn);
+	if (abort != J1939_XTP_NO_ABORT) {
+		se_skb = j1939_session_skb_get(session);
+		if (se_skb)
+			se_skb_sk = se_skb->sk;
+		if (j1939_xtp_tx_abort(priv, se_skb_sk, skcb, true, abort, pgn))
+			kfree_skb(se_skb);
+		else
+			consume_skb(se_skb);
+	}
 
 	return true;
 }
@@ -1625,13 +1658,13 @@ j1939_session *j1939_xtp_rx_rts_session_new(struct j1939_priv *priv,
 	}
 
 	if (abort != J1939_XTP_NO_ABORT) {
-		j1939_xtp_tx_abort(priv, &skcb, true, abort, pgn);
+		j1939_xtp_tx_abort(priv, skb->sk, &skcb, true, abort, pgn);
 		return NULL;
 	}
 
 	session = j1939_session_fresh_new(priv, len, &skcb);
 	if (!session) {
-		j1939_xtp_tx_abort(priv, &skcb, true,
+		j1939_xtp_tx_abort(priv, skb->sk, &skcb, true,
 				   J1939_XTP_ABORT_RESOURCE, pgn);
 		return NULL;
 	}
-- 
2.25.1

