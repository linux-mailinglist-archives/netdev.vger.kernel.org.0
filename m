Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B69E430C1D
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 23:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344612AbhJQVEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 17:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbhJQVEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 17:04:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1DDC061768
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 14:01:53 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcDI0-0000EY-3F
        for netdev@vger.kernel.org; Sun, 17 Oct 2021 23:01:52 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3245C695EDD
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 21:01:47 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C69D5695EB1;
        Sun, 17 Oct 2021 21:01:44 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bd36f86d;
        Sun, 17 Oct 2021 21:01:43 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 04/11] can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes
Date:   Sun, 17 Oct 2021 23:01:35 +0200
Message-Id: <20211017210142.2108610-5-mkl@pengutronix.de>
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

The receiver should abort TP if 'total message size' in TP.CM_RTS and
TP.CM_BAM is less than 9 or greater than 1785 [1], but currently the
j1939 stack only checks the upper bound and the receiver will accept
the following broadcast message:

  vcan1  18ECFF00   [8]  20 08 00 02 FF 00 23 01
  vcan1  18EBFF00   [8]  01 00 00 00 00 00 00 00
  vcan1  18EBFF00   [8]  02 00 FF FF FF FF FF FF

This patch adds check for the lower bound and abort illegal TP.

[1] SAE-J1939-82 A.3.4 Row 2 and A.3.6 Row 6.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/1634203601-3460-1-git-send-email-zhangchangzhong@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/j1939-priv.h | 1 +
 net/can/j1939/transport.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/net/can/j1939/j1939-priv.h b/net/can/j1939/j1939-priv.h
index f6df20808f5e..16af1a7f80f6 100644
--- a/net/can/j1939/j1939-priv.h
+++ b/net/can/j1939/j1939-priv.h
@@ -330,6 +330,7 @@ int j1939_session_activate(struct j1939_session *session);
 void j1939_tp_schedule_txtimer(struct j1939_session *session, int msec);
 void j1939_session_timers_cancel(struct j1939_session *session);
 
+#define J1939_MIN_TP_PACKET_SIZE 9
 #define J1939_MAX_TP_PACKET_SIZE (7 * 0xff)
 #define J1939_MAX_ETP_PACKET_SIZE (7 * 0x00ffffff)
 
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 1ea6fee3d986..6c0a0ebdd024 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1608,6 +1608,8 @@ j1939_session *j1939_xtp_rx_rts_session_new(struct j1939_priv *priv,
 			abort = J1939_XTP_ABORT_FAULT;
 		else if (len > priv->tp_max_packet_size)
 			abort = J1939_XTP_ABORT_RESOURCE;
+		else if (len < J1939_MIN_TP_PACKET_SIZE)
+			abort = J1939_XTP_ABORT_FAULT;
 	}
 
 	if (abort != J1939_XTP_NO_ABORT) {
-- 
2.33.0


