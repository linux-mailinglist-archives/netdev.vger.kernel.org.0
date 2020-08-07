Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAF623EBB9
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 12:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgHGKzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 06:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbgHGKxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 06:53:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C93C0617A3
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 03:52:16 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1k3zym-0004nD-8u; Fri, 07 Aug 2020 12:52:04 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1k3zyk-0007Kt-Ch; Fri, 07 Aug 2020 12:52:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Henrique Figueira <henrislip@gmail.com>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v1 4/5] can: j1939: transport: add j1939_session_skb_find_by_offset() function
Date:   Fri,  7 Aug 2020 12:51:59 +0200
Message-Id: <20200807105200.26441-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200807105200.26441-1-o.rempel@pengutronix.de>
References: <20200807105200.26441-1-o.rempel@pengutronix.de>
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

Sometimes it makes no sense to search the skb by pkt.dpo, since we need
next the skb within the transaction block. This may happen if we have an
ETP session with CTS set to less than 255 packets.

After this patch, we will be able to work with ETP sessions where the
block size (ETP.CM_CTS byte 2) is less than 255 packets.

Reported-by: Henrique Figueira <henrislip@gmail.com>
Reported-by: https://github.com/linux-can/can-utils/issues/228
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/transport.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 30957c9a8eb7..90a2baac8a4a 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -352,17 +352,16 @@ void j1939_session_skb_queue(struct j1939_session *session,
 	skb_queue_tail(&session->skb_queue, skb);
 }
 
-static struct sk_buff *j1939_session_skb_find(struct j1939_session *session)
+static struct
+sk_buff *j1939_session_skb_find_by_offset(struct j1939_session *session,
+					  unsigned int offset_start)
 {
 	struct j1939_priv *priv = session->priv;
+	struct j1939_sk_buff_cb *do_skcb;
 	struct sk_buff *skb = NULL;
 	struct sk_buff *do_skb;
-	struct j1939_sk_buff_cb *do_skcb;
-	unsigned int offset_start;
 	unsigned long flags;
 
-	offset_start = session->pkt.dpo * 7;
-
 	spin_lock_irqsave(&session->skb_queue.lock, flags);
 	skb_queue_walk(&session->skb_queue, do_skb) {
 		do_skcb = j1939_skb_to_cb(do_skb);
@@ -382,6 +381,14 @@ static struct sk_buff *j1939_session_skb_find(struct j1939_session *session)
 	return skb;
 }
 
+static struct sk_buff *j1939_session_skb_find(struct j1939_session *session)
+{
+	unsigned int offset_start;
+
+	offset_start = session->pkt.dpo * 7;
+	return j1939_session_skb_find_by_offset(session, offset_start);
+}
+
 /* see if we are receiver
  * returns 0 for broadcasts, although we will receive them
  */
@@ -766,7 +773,7 @@ static int j1939_session_tx_dat(struct j1939_session *session)
 	int ret = 0;
 	u8 dat[8];
 
-	se_skb = j1939_session_skb_find(session);
+	se_skb = j1939_session_skb_find_by_offset(session, session->pkt.tx * 7);
 	if (!se_skb)
 		return -ENOBUFS;
 
@@ -1765,7 +1772,8 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 			    __func__, session);
 		goto out_session_cancel;
 	}
-	se_skb = j1939_session_skb_find(session);
+
+	se_skb = j1939_session_skb_find_by_offset(session, packet * 7);
 	if (!se_skb) {
 		netdev_warn(priv->ndev, "%s: 0x%p: no skb found\n", __func__,
 			    session);
-- 
2.28.0

