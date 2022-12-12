Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F25649DD3
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiLLLcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbiLLLbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647B2632D
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:05 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1T-0000SV-K4
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:03 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E17A813CC07
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4156113CBC4;
        Mon, 12 Dec 2022 11:30:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a7a0bdb6;
        Mon, 12 Dec 2022 11:30:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Xu Panda <xu.panda@zte.com.cn>,
        Yang Yang <yang.yang29@zte.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 22/39] can: ucan: use strscpy() to instead of strncpy()
Date:   Mon, 12 Dec 2022 12:30:28 +0100
Message-Id: <20221212113045.222493-23-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Panda <xu.panda@zte.com.cn>

The implementation of strscpy() is more robust and safer.
That's now the recommended way to copy NUL terminated strings.

Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>
Link: https://lore.kernel.org/all/202212070909095189693@zte.com.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/ucan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index ffa38f533c35..159e25ffa337 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1534,9 +1534,8 @@ static int ucan_probe(struct usb_interface *intf,
 				     sizeof(union ucan_ctl_payload));
 	if (ret > 0) {
 		/* copy string while ensuring zero termination */
-		strncpy(firmware_str, up->ctl_msg_buffer->raw,
-			sizeof(union ucan_ctl_payload));
-		firmware_str[sizeof(union ucan_ctl_payload)] = '\0';
+		strscpy(firmware_str, up->ctl_msg_buffer->raw,
+			sizeof(union ucan_ctl_payload) + 1);
 	} else {
 		strcpy(firmware_str, "unknown");
 	}
-- 
2.35.1


