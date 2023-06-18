Return-Path: <netdev+bounces-11787-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 084C673474F
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:41:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B72E92810A6
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 17:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D37EC6FB9;
	Sun, 18 Jun 2023 17:41:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C386C6D39
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 17:41:00 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39B4E4E
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 10:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
	Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Content-Disposition:In-Reply-To:References;
	bh=eSo8/pS4QcJszK71pDrv98OGM4hXhc+j5ZJoP9B8Sxo=; b=sGC6ud4RqZiX+rm+Zo+EmFpiQE
	mwsSk+pVyqcyOvSHZ3+aNRbTI4rIAHMASKuoqEsaz8GwWj3TOd1tmpqRcfWwwuzkV5TdKTGwZcRHE
	SFc/Q+YwtTV2sV4+iBBm45fQ3yo58EjuyJcabzOgPZnmCsQD5gujQ1Hq7UxGoasxcL6w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAwOR-00Gqpv-Gn; Sun, 18 Jun 2023 19:40:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: ansuelsmth@gmail.com,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v0 1/3] led: trig: netdev: Fix requesting offload device
Date: Sun, 18 Jun 2023 19:39:35 +0200
Message-Id: <20230618173937.4016322-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When the netdev trigger is activates, it tries to determine what
device the LED blinks for, and what the current blink mode is.

The documentation for hw_control_get() says:

	 * Return 0 on success, a negative error number on failing parsing the
	 * initial mode. Error from this function is NOT FATAL as the device
	 * may be in a not supported initial state by the attached LED trigger.
	 */

For the Marvell PHY and the Armada 370-rd board, the initial LED blink
mode is not supported by the trigger, so it returns an error. This
resulted in not getting the device the LED is blinking for. As a
result, the device is unknown and offloaded is never performed.

Change to condition to always get the device if offloading is
supported, and reduce the scope of testing for an error from
hw_control_get() to skip setting trigger internal state if there is an
error.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/leds/trigger/ledtrig-netdev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 2311dae7f070..df61977f1fa2 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -471,15 +471,17 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	/* Check if hw control is active by default on the LED.
 	 * Init already enabled mode in hw control.
 	 */
-	if (supports_hw_control(led_cdev) &&
-	    !led_cdev->hw_control_get(led_cdev, &mode)) {
+	if (supports_hw_control(led_cdev)) {
 		dev = led_cdev->hw_control_get_device(led_cdev);
 		if (dev) {
 			const char *name = dev_name(dev);
 
 			set_device_name(trigger_data, name, strlen(name));
 			trigger_data->hw_control = true;
-			trigger_data->mode = mode;
+
+			rc = led_cdev->hw_control_get(led_cdev, &mode);
+			if (!rc)
+				trigger_data->mode = mode;
 		}
 	}
 
-- 
2.40.1


