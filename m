Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72B0430C24
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 23:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344611AbhJQVEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 17:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbhJQVEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 17:04:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7328AC06161C
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 14:01:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcDI0-0000F2-P6
        for netdev@vger.kernel.org; Sun, 17 Oct 2021 23:01:52 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8882E695EE6
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 21:01:47 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A7C5B695EB0;
        Sun, 17 Oct 2021 21:01:44 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c8a2bdca;
        Sun, 17 Oct 2021 21:01:43 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 03/11] can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length
Date:   Sun, 17 Oct 2021 23:01:34 +0200
Message-Id: <20211017210142.2108610-4-mkl@pengutronix.de>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
cancel session when receive unexpected TP.DT message.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index bfb0718d4587..1ea6fee3d986 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1788,6 +1788,7 @@ static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
 static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 				 struct sk_buff *skb)
 {
+	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
 	struct j1939_priv *priv = session->priv;
 	struct j1939_sk_buff_cb *skcb, *se_skcb;
 	struct sk_buff *se_skb = NULL;
@@ -1802,9 +1803,11 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
 
 	skcb = j1939_skb_to_cb(skb);
 	dat = skb->data;
-	if (skb->len <= 1)
+	if (skb->len != 8) {
 		/* makes no sense */
+		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
 		goto out_session_cancel;
+	}
 
 	switch (session->last_cmd) {
 	case 0xff:
@@ -1903,7 +1906,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
  out_session_cancel:
 	kfree_skb(se_skb);
 	j1939_session_timers_cancel(session);
-	j1939_session_cancel(session, J1939_XTP_ABORT_FAULT);
+	j1939_session_cancel(session, abort);
 	j1939_session_put(session);
 }
 
-- 
2.33.0


