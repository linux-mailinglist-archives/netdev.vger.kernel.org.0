Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B114470C4
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 22:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhKFV5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 17:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbhKFV5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 17:57:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0823BC061714
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 14:54:59 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mjTeL-0000mc-Fr
        for netdev@vger.kernel.org; Sat, 06 Nov 2021 22:54:57 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D02316A5F73
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 21:54:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 38D2F6A5F65;
        Sat,  6 Nov 2021 21:54:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d4b670d5;
        Sat, 6 Nov 2021 21:54:50 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/8] can: j1939: j1939_can_recv(): ignore messages with invalid source address
Date:   Sat,  6 Nov 2021 22:54:43 +0100
Message-Id: <20211106215449.57946-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106215449.57946-1-mkl@pengutronix.de>
References: <20211106215449.57946-1-mkl@pengutronix.de>
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

According to SAE-J1939-82 2015 (A.3.6 Row 2), a receiver should never
send TP.CM_CTS to the global address, so we can add a check in
j1939_can_recv() to drop messages with invalid source address.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/1635431907-15617-3-git-send-email-zhangchangzhong@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 9bc55ecb37f9..8452b0fbb78c 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -75,6 +75,13 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
 	skcb->addr.pgn = (cf->can_id >> 8) & J1939_PGN_MAX;
 	/* set default message type */
 	skcb->addr.type = J1939_TP;
+
+	if (!j1939_address_is_valid(skcb->addr.sa)) {
+		netdev_err_once(priv->ndev, "%s: sa is broadcast address, ignoring!\n",
+				__func__);
+		goto done;
+	}
+
 	if (j1939_pgn_is_pdu1(skcb->addr.pgn)) {
 		/* Type 1: with destination address */
 		skcb->addr.da = skcb->addr.pgn;
-- 
2.33.0


