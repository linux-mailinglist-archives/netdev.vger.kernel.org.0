Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47D06450CC
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiLGBJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiLGBJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:09:34 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEABB60E7;
        Tue,  6 Dec 2022 17:09:32 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NRfMH0SZrz8RV7G;
        Wed,  7 Dec 2022 09:09:31 +0800 (CST)
Received: from szxlzmapp05.zte.com.cn ([10.5.230.85])
        by mse-fl2.zte.com.cn with SMTP id 2B71984p063121;
        Wed, 7 Dec 2022 09:09:08 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Wed, 7 Dec 2022 09:09:09 +0800 (CST)
Date:   Wed, 7 Dec 2022 09:09:09 +0800 (CST)
X-Zmail-TransId: 2b04638fe7b575b72e87
X-Mailer: Zmail v1.0
Message-ID: <202212070909095189693@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <wg@grandegger.com>
Cc:     <mkl@pengutronix.de>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <mailhol.vincent@wanadoo.fr>, <stefan.maetje@esd.eu>,
        <socketcan@hartkopp.net>, <dzm91@hust.edu.cn>,
        <julia.lawall@inria.fr>, <gustavoars@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIGNhbjogdWNhbjogdXNlIHN0cnNjcHkoKSB0byBpbnN0ZWFkIG9mIHN0cm5jcHkoKQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B71984p063121
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 638FE7CB.000 by FangMail milter!
X-FangMail-Envelope: 1670375371/4NRfMH0SZrz8RV7G/638FE7CB.000/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 638FE7CB.000/4NRfMH0SZrz8RV7G
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
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
2.15.2
