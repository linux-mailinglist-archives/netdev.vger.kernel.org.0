Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD62305757
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbhA0JtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:49:10 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54829 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhA0Jr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:47:27 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l4h29-0008D6-6R
        for netdev@vger.kernel.org; Wed, 27 Jan 2021 10:22:41 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3B00A5CF112
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:22:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E13745CF0D3;
        Wed, 27 Jan 2021 09:22:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 752c95bc;
        Wed, 27 Jan 2021 09:22:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [net-next 04/12] can: length: can_fd_len2dlc(): make legnth calculation readable again
Date:   Wed, 27 Jan 2021 10:22:19 +0100
Message-Id: <20210127092227.2775573-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210127092227.2775573-1-mkl@pengutronix.de>
References: <20210127092227.2775573-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 652562e5ff06 ("can: length: can_fd_len2dlc(): simplify length
calculcation") the readability of the code degraded and became more error
prone. To counteract this, partially convert that patch and replace open coded
values (of the original code) with proper defines.

Fixes: 652562e5ff06 ("can: length: can_fd_len2dlc(): simplify length calculcation")
Cc: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20210118201346.79422-1-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/length.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/length.c b/drivers/net/can/dev/length.c
index d35c4e82314d..b48140b1102e 100644
--- a/drivers/net/can/dev/length.c
+++ b/drivers/net/can/dev/length.c
@@ -27,12 +27,17 @@ static const u8 len2dlc[] = {
 	13, 13, 13, 13, 13, 13, 13, 13,	/* 25 - 32 */
 	14, 14, 14, 14, 14, 14, 14, 14,	/* 33 - 40 */
 	14, 14, 14, 14, 14, 14, 14, 14,	/* 41 - 48 */
+	15, 15, 15, 15, 15, 15, 15, 15,	/* 49 - 56 */
+	15, 15, 15, 15, 15, 15, 15, 15	/* 57 - 64 */
 };
 
 /* map the sanitized data length to an appropriate data length code */
 u8 can_fd_len2dlc(u8 len)
 {
-	if (len >= ARRAY_SIZE(len2dlc))
+	/* check for length mapping table size at build time */
+	BUILD_BUG_ON(ARRAY_SIZE(len2dlc) != CANFD_MAX_DLEN + 1);
+
+	if (unlikely(len > CANFD_MAX_DLEN))
 		return CANFD_MAX_DLC;
 
 	return len2dlc[len];
-- 
2.29.2


