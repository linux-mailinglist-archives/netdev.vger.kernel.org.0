Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC05396A78
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhFAAx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232516AbhFAAxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 20:53:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF74A6136E;
        Tue,  1 Jun 2021 00:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622508728;
        bh=zhw273xMoQcDBrWZhOAv58cvBFsHXq8mkER13wTIyW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6Ui0IpJubSyEyqovq/YjQ5ougb/os0g5Jso19mzpUH9b/ZhmOnN6TLXgl6r8Zvn5
         TgIS2NQnUm7LCJLSF4FPmXwJmLhrG76K16IErOFryY5FhNE+C45KmCOBAmo+hFnGbg
         Y00zy4Ro/CSYr1AdqxqnEYZcT3qFh+jYC9arxmn/9PzynWfs1yruTQrcxWWiFikfOU
         Mto3L2UZptPABUwQZVWUhVRSLIbQMJ5w8pOgcaNv6YxCzdCZcfYrZWkFdQNivlSoRQ
         h1VAijVTUQoXB/Y5XJ8RSC5lsPpnRQAmI4yjDcS+xrTe9eN+CAeHfPg1EDpkmXXmiB
         AfFvTxPbg9JLA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     linux-leds@vger.kernel.org
Cc:     netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH leds v2 04/10] leds: trigger: netdev: support HW offloading
Date:   Tue,  1 Jun 2021 02:51:49 +0200
Message-Id: <20210601005155.27997-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210601005155.27997-1-kabel@kernel.org>
References: <20210601005155.27997-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for HW offloading of the netdev trigger.

We are only offloading if the link is up and rx/tx blinking is
requested.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 9a98f9c5b8d0..1f1b63d5a78d 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -52,9 +52,17 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (!test_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode))
+	if (!test_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode)) {
+		led_trigger_offload_stop(led_cdev);
 		led_set_brightness(led_cdev, LED_OFF);
-	else {
+	} else {
+		bool blink = test_bit(NETDEV_LED_TX, &trigger_data->mode) ||
+			     test_bit(NETDEV_LED_RX, &trigger_data->mode);
+		/* Try offload to HW only if RX/TX blinking is requested */
+		if (blink)
+			if (!led_trigger_offload(led_cdev))
+				return;
+
 		if (test_bit(NETDEV_LED_LINK, &trigger_data->mode))
 			led_set_brightness(led_cdev,
 					   led_cdev->blink_brightness);
@@ -64,8 +72,7 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 		/* If we are looking for RX/TX start periodically
 		 * checking stats
 		 */
-		if (test_bit(NETDEV_LED_TX, &trigger_data->mode) ||
-		    test_bit(NETDEV_LED_RX, &trigger_data->mode))
+		if (blink)
 			schedule_delayed_work(&trigger_data->work, 0);
 	}
 }
-- 
2.26.3

