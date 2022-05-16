Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E30352925E
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbiEPUwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348583AbiEPUvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:51:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1CA2AE14
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:26:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqhIe-00068t-Ee
        for netdev@vger.kernel.org; Mon, 16 May 2022 22:26:40 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4E1697FB4A
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:26:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BEC417FB3B;
        Mon, 16 May 2022 20:26:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 23900fff;
        Mon, 16 May 2022 20:26:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Derek Will <derekrobertwill@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 4/9] can: isotp: isotp_bind(): return -EINVAL on incorrect CAN ID formatting
Date:   Mon, 16 May 2022 22:26:20 +0200
Message-Id: <20220516202625.1129281-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220516202625.1129281-1-mkl@pengutronix.de>
References: <20220516202625.1129281-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

Commit 3ea566422cbd ("can: isotp: sanitize CAN ID checks in
isotp_bind()") checks the given CAN ID address information by
sanitizing the input values.

This check (silently) removes obsolete bits by masking the given CAN
IDs.

Derek Will suggested to give a feedback to the application programmer
when the 'sanitizing' was actually needed which means the programmer
provided CAN ID content in a wrong format (e.g. SFF CAN IDs with a CAN
ID > 0x7FF).

Link: https://lore.kernel.org/all/20220515181633.76671-1-socketcan@hartkopp.net
Suggested-by: Derek Will <derekrobertwill@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 2caeeae8ec16..4a4007f10970 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1232,6 +1232,11 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	else
 		rx_id &= CAN_SFF_MASK;
 
+	/* give feedback on wrong CAN-ID values */
+	if (tx_id != addr->can_addr.tp.tx_id ||
+	    rx_id != addr->can_addr.tp.rx_id)
+		return -EINVAL;
+
 	if (!addr->can_ifindex)
 		return -ENODEV;
 
-- 
2.35.1


