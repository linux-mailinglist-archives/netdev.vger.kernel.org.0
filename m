Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6A257B295
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbiGTIMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240417AbiGTILy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:11:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6FC6B268
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:11:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE4nu-0000YF-Od
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:11:34 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CAC61B5888
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:10:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4BC2DB5871;
        Wed, 20 Jul 2022 08:10:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0d2be8c7;
        Wed, 20 Jul 2022 08:10:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 01/29] can: slcan: use scnprintf() as a hardening measure
Date:   Wed, 20 Jul 2022 10:10:06 +0200
Message-Id: <20220720081034.3277385-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720081034.3277385-1-mkl@pengutronix.de>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The snprintf() function returns the number of bytes which *would* have
been copied if there were no space. So, since this code does not check
the return value, there if the buffer was not large enough then there
would be a buffer overflow two lines later when it does:

	actual = sl->tty->ops->write(sl->tty, sl->xbuff, n);

Use scnprintf() instead because that returns the number of bytes which
were actually copied.

Fixes: 52f9ac85b876 ("can: slcan: allow to send commands to the adapter")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/all/YsVA9KoY/ZSvNGYk@kili
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan/slcan-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 54d29a410ad5..92bdd49996d1 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -647,7 +647,7 @@ static int slcan_transmit_cmd(struct slcan *sl, const unsigned char *cmd)
 		return -ENODEV;
 	}
 
-	n = snprintf(sl->xbuff, sizeof(sl->xbuff), "%s", cmd);
+	n = scnprintf(sl->xbuff, sizeof(sl->xbuff), "%s", cmd);
 	set_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 	actual = sl->tty->ops->write(sl->tty, sl->xbuff, n);
 	sl->xleft = n - actual;

base-commit: e22c88799f2629088504e1357384f2ec3798da46
-- 
2.35.1


