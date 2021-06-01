Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D366396A7E
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhFAAyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:54:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232559AbhFAAxz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 20:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3341D61364;
        Tue,  1 Jun 2021 00:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622508734;
        bh=thmtUafonYJfxBh+qZjVikVs+8hrEVyZs31+MWKROxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEVzPQPdMkCfq71Ex4q1U6MrqdEchhLnNrNIneo8BxRTzNwqw4GQlNGUxwH4rsSzk
         EDWYLjbXLp18w94EHr7xGzF2qQjyUcFjgz99qJtLaYuuEt+bT6Od9EjCM+CkEFeVRi
         QAn9u09ri+/66y3Ayq/mHvVCCnFQVGbquNi8wUvi0tNOgsM8wEp4kfkZZ+uApO3Sm0
         epOZg9yA5DspB8rsN5LTaJsXImwx7a9g1dYFHf+mhiSqwkI49/Ed/53fuBJbGgkM0A
         nSGkVOYkmVEFfFBrCGfOc9dRsNuvtlVvYj7cWn/KjzMMMnr1oHN1R8immtZ1sjLIcn
         5jPDdCXDpgNKA==
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
Subject: [PATCH leds v2 07/10] leds: turris-omnia: refactor sw mode setting code into separate function
Date:   Tue,  1 Jun 2021 02:51:52 +0200
Message-Id: <20210601005155.27997-8-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210601005155.27997-1-kabel@kernel.org>
References: <20210601005155.27997-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to make trigger offloading code more readable, put the code
that sets/unsets software mode into a separate function.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/leds-turris-omnia.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-turris-omnia.c b/drivers/leds/leds-turris-omnia.c
index 2f9a289ab245..c5a40afe5d45 100644
--- a/drivers/leds/leds-turris-omnia.c
+++ b/drivers/leds/leds-turris-omnia.c
@@ -73,6 +73,13 @@ static int omnia_led_brightness_set_blocking(struct led_classdev *cdev,
 	return ret;
 }
 
+static int omnia_led_set_sw_mode(struct i2c_client *client, int led, bool sw)
+{
+	return i2c_smbus_write_byte_data(client, CMD_LED_MODE,
+					 CMD_LED_MODE_LED(led) |
+					 (sw ? CMD_LED_MODE_USER : 0));
+}
+
 static int omnia_led_register(struct i2c_client *client, struct omnia_led *led,
 			      struct device_node *np)
 {
@@ -114,9 +121,7 @@ static int omnia_led_register(struct i2c_client *client, struct omnia_led *led,
 	cdev->brightness_set_blocking = omnia_led_brightness_set_blocking;
 
 	/* put the LED into software mode */
-	ret = i2c_smbus_write_byte_data(client, CMD_LED_MODE,
-					CMD_LED_MODE_LED(led->reg) |
-					CMD_LED_MODE_USER);
+	ret = omnia_led_set_sw_mode(client, led->reg, true);
 	if (ret < 0) {
 		dev_err(dev, "Cannot set LED %pOF to software mode: %i\n", np,
 			ret);
@@ -250,8 +255,7 @@ static int omnia_leds_remove(struct i2c_client *client)
 	u8 buf[5];
 
 	/* put all LEDs into default (HW triggered) mode */
-	i2c_smbus_write_byte_data(client, CMD_LED_MODE,
-				  CMD_LED_MODE_LED(OMNIA_BOARD_LEDS));
+	omnia_led_set_sw_mode(client, OMNIA_BOARD_LEDS, false);
 
 	/* set all LEDs color to [255, 255, 255] */
 	buf[0] = CMD_LED_COLOR;
-- 
2.26.3

