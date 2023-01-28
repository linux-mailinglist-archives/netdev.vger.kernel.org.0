Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C9267F827
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbjA1Nih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbjA1Nig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:38:36 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2356A1DB8B;
        Sat, 28 Jan 2023 05:38:35 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j5so7203809pjn.5;
        Sat, 28 Jan 2023 05:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=oI2APnegFeFVqcu8G9tQYKXTxS90VVWctbcguXYfrxQ=;
        b=Gvwk+EJXQDGb4Jv1jmrDlg56eNAkoVLc5Hl30vFIACswLRt1GmqdkkHT1ABr1Y02HY
         w4+GsaEd1fTO9OG39Unx1ugbSBuA2f6rHdS0wXlx1pfj+PZXEDgKqpS4jrsIZEwVwMoz
         3j0Uf+ZuIFsffQ++UsMxkegvgtIZ2C2FpSyr5srvCKvrtop/SuJjyOSZhRlxtsi9sris
         iaeHJHA3CCr5VpLlctPFP6Onm3CaimGo7elxL36TQQIade4/nq6UX3wBBMOfoLuL/snW
         Fpz5tW95X81w17JtHvUajVtHFs/MbM94Uz3dabqJJbD/PLm94D8ZFiTVlIoOkzoIxTpL
         SU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oI2APnegFeFVqcu8G9tQYKXTxS90VVWctbcguXYfrxQ=;
        b=RYmbEyJhijtRbBJWY4NBuhikU1fTVWpPdL7N3nj0N8nGdtNcxDVoizBTU6Wqyox46o
         DneV8p5+yjZNKkfIaolgBUzkRiYAIrOnA03+UXfBm6ljbULlUDV5cwV1LXsNkqJi1L9V
         GpRz8+L7M4nIRaZ6qYCyWXU1MWiQJWi4FFrQUyENuS7EVJAoXvgrpHqyCv61WHkqEv+E
         8FmROqcVx+u5X3C3ipYOc8TJounuAQqK6pa685KSoNvQk/1iU9Q8jqKu/K6l0amMC523
         826inQmM6OaAHw3JLoGW+X8ClzDabef+CT2v3dNeY5Aj+MpR1ViE2bxjg5MAL9ShTQkc
         2GKg==
X-Gm-Message-State: AO0yUKVjh5aYfiN7NtWz5ad1c9aC6Az8tHqihoAiBxEc6lX3VIa6OsaE
        Kgfc7Hof15aC7CuDc4tzY25xeUu/Zxo=
X-Google-Smtp-Source: AK7set/0vBQG+NtXhM10Q+4wEzG/Yp4BrGfPUAFF9+oLD7/VHcbAUHHnrDrf77a8DEl9Oot2V1Ewaw==
X-Received: by 2002:a05:6a20:698b:b0:b5:e639:2833 with SMTP id t11-20020a056a20698b00b000b5e6392833mr2718382pzk.20.1674913114209;
        Sat, 28 Jan 2023 05:38:34 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id a69-20020a621a48000000b00590163e1762sm3604391pfa.200.2023.01.28.05.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 05:38:33 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH] can: etas_es58x: do not send disable channel command if device is unplugged
Date:   Sat, 28 Jan 2023 22:38:15 +0900
Message-Id: <20230128133815.1796221-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When turning the network interface down, es58x_stop() is called and
will send a command to the ES58x device to disable the channel
c.f. es58x_ops::disable_channel().

However, if the device gets unplugged while the network interface is
still up, es58x_ops::disable_channel() will obviously fail to send the
URB command and the driver emits below error message:

  es58x_submit_urb: USB send urb failure: -ENODEV

Check the usb device state before sending the disable channel command
in order to silence above error message.

Update the documentation of es58x_stop() accordingly.

The check being added in es58x_stop() is:

  	if (es58x_dev->udev->state >= USB_STATE_UNAUTHENTICATED)

This is just the negation of the check done in usb_submit_urb()[1].

[1] usb_submit_urb(), verify usb device's state.
Link: https://elixir.bootlin.com/linux/v6.1/source/drivers/usb/core/urb.c#L384

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
As far as I know, there doesn't seem to be an helper function to check
udev->state values. If anyone is aware of such helper function, let me
know..
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 3e87f4c1547c..916bd9e2e9ea 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1817,9 +1817,10 @@ static int es58x_open(struct net_device *netdev)
  * es58x_stop() - Disable the network device.
  * @netdev: CAN network device.
  *
- * Called when the network transitions to the down state. If all the
- * channels of the device are closed, free the URB resources which are
- * not needed anymore.
+ * Called when the network interface transitions to the down
+ * state. Send a disable command to the device if it is still
+ * connected. If all the channels of the device are closed, free the
+ * URB resources which are not needed anymore.
  *
  * Return: zero on success, errno when any error occurs.
  */
@@ -1830,9 +1831,12 @@ static int es58x_stop(struct net_device *netdev)
 	int ret;
 
 	netif_stop_queue(netdev);
-	ret = es58x_dev->ops->disable_channel(priv);
-	if (ret)
-		return ret;
+
+	if (es58x_dev->udev->state >= USB_STATE_UNAUTHENTICATED) {
+		ret = es58x_dev->ops->disable_channel(priv);
+		if (ret)
+			return ret;
+	}
 
 	priv->can.state = CAN_STATE_STOPPED;
 	es58x_can_reset_echo_fifo(netdev);
-- 
2.39.1

