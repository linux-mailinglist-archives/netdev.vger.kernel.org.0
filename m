Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4342B63F6EF
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 18:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiLARzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 12:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLARz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 12:55:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13082714D
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 09:55:28 -0800 (PST)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1p0nmQ-0001ds-Lc; Thu, 01 Dec 2022 18:55:26 +0100
From:   Lucas Stach <l.stach@pengutronix.de>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
Subject: [PATCH 2/2] net: asix: Avoid looping when the device is diconnected
Date:   Thu,  1 Dec 2022 18:55:25 +0100
Message-Id: <20221201175525.2733125-2-l.stach@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221201175525.2733125-1-l.stach@pengutronix.de>
References: <20221201175525.2733125-1-l.stach@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: l.stach@pengutronix.de
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

We've seen device access fail with -EPROTO when the device has been
recently disconnected and before the USB core had a chance to handle
the disconnect hub event. It doesn't make sense to continue on trying
to enable host access when the adapter is gone.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/net/usb/asix_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index be1e103b7a95..28b31e4da020 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -96,7 +96,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 
 	for (i = 0; i < AX_HOST_EN_RETRIES; ++i) {
 		ret = asix_set_sw_mii(dev, in_pm);
-		if (ret == -ENODEV || ret == -ETIMEDOUT)
+		if (ret == -ENODEV || ret == -ETIMEDOUT || ret == -EPROTO)
 			break;
 		usleep_range(1000, 1100);
 		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
-- 
2.30.2

