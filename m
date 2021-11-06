Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA944470BE
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 22:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhKFV5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 17:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhKFV5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 17:57:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EBAC061714
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 14:54:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mjTeK-0000km-CL
        for netdev@vger.kernel.org; Sat, 06 Nov 2021 22:54:56 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7EE106A5F69
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 21:54:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 814B86A5F5D;
        Sat,  6 Nov 2021 21:54:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2395a274;
        Sat, 6 Nov 2021 21:54:50 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/8] can: j1939: j1939_tp_cmd_recv(): ignore abort message in the BAM transport
Date:   Sat,  6 Nov 2021 22:54:42 +0100
Message-Id: <20211106215449.57946-2-mkl@pengutronix.de>
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

This patch prevents BAM transport from being closed by receiving abort
message, as specified in SAE-J1939-82 2015 (A.3.3 Row 4).

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/1635431907-15617-2-git-send-email-zhangchangzhong@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 6c0a0ebdd024..05eb3d059e17 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2085,6 +2085,12 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
 		break;
 
 	case J1939_ETP_CMD_ABORT: /* && J1939_TP_CMD_ABORT */
+		if (j1939_cb_is_broadcast(skcb)) {
+			netdev_err_once(priv->ndev, "%s: abort to broadcast (%02x), ignoring!\n",
+					__func__, skcb->addr.sa);
+			return;
+		}
+
 		if (j1939_tp_im_transmitter(skcb))
 			j1939_xtp_rx_abort(priv, skb, true);
 

base-commit: 70bf363d7adb3a428773bc905011d0ff923ba747
-- 
2.33.0


