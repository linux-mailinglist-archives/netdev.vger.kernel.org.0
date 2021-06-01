Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC65396A81
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbhFAAyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232398AbhFAAx5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 20:53:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 515DD61374;
        Tue,  1 Jun 2021 00:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622508737;
        bh=O5Y4AT4esPTiPEG+/lih5Kns+T03xStg/IARP4QSYJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCEbiBarnn6WMMuGmZdXend06qn+Fg/GWkqHJ5TMzNfk4q5WYP4dhoemg2s1y3Toj
         D7k4lFJ9R1zAD5uTIilLHOQ32FaHjUgKoapwTW0FfgBw+wlxnk9qnYRmA0enaKA9Qn
         7FsAYYf2MZiOk6D9yLUAdcbOQZRWSjMWErOy+9l6cStzcpQvS+Au6XOKQ3so6169tN
         ZS0Ill8rlOy7h5YxhTelpkj18ALgweTPTrDjOLPkFLu4tMiB6SoEYDMMkpGWmSRErD
         0EH7icd7po/Xrr3Xij3tnztaMfehHqvhrivv7ZC4bjPUeQv52kwlJ07N8v12NsCFuK
         ktUkuQCA6FFyg==
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
Subject: [PATCH leds v2 08/10] leds: turris-omnia: refactor brightness setting function
Date:   Tue,  1 Jun 2021 02:51:53 +0200
Message-Id: <20210601005155.27997-9-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210601005155.27997-1-kabel@kernel.org>
References: <20210601005155.27997-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the code of brightness setting function guarded by mutex into
separate function. This will be useful when used from trigger offload
method.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/leds/leds-turris-omnia.c | 35 +++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/leds/leds-turris-omnia.c b/drivers/leds/leds-turris-omnia.c
index c5a40afe5d45..2b51c14b8363 100644
--- a/drivers/leds/leds-turris-omnia.c
+++ b/drivers/leds/leds-turris-omnia.c
@@ -41,32 +41,43 @@ struct omnia_leds {
 	struct omnia_led leds[];
 };
 
-static int omnia_led_brightness_set_blocking(struct led_classdev *cdev,
-					     enum led_brightness brightness)
+static int omnia_led_brightness_set(struct i2c_client *client,
+				    struct omnia_led *led,
+				    enum led_brightness brightness)
 {
-	struct led_classdev_mc *mc_cdev = lcdev_to_mccdev(cdev);
-	struct omnia_leds *leds = dev_get_drvdata(cdev->dev->parent);
-	struct omnia_led *led = to_omnia_led(mc_cdev);
 	u8 buf[5], state;
 	int ret;
 
-	mutex_lock(&leds->lock);
-
 	led_mc_calc_color_components(&led->mc_cdev, brightness);
 
 	buf[0] = CMD_LED_COLOR;
 	buf[1] = led->reg;
-	buf[2] = mc_cdev->subled_info[0].brightness;
-	buf[3] = mc_cdev->subled_info[1].brightness;
-	buf[4] = mc_cdev->subled_info[2].brightness;
+	buf[2] = led->mc_cdev.subled_info[0].brightness;
+	buf[3] = led->mc_cdev.subled_info[1].brightness;
+	buf[4] = led->mc_cdev.subled_info[2].brightness;
 
 	state = CMD_LED_STATE_LED(led->reg);
 	if (buf[2] || buf[3] || buf[4])
 		state |= CMD_LED_STATE_ON;
 
-	ret = i2c_smbus_write_byte_data(leds->client, CMD_LED_STATE, state);
+	ret = i2c_smbus_write_byte_data(client, CMD_LED_STATE, state);
 	if (ret >= 0 && (state & CMD_LED_STATE_ON))
-		ret = i2c_master_send(leds->client, buf, 5);
+		ret = i2c_master_send(client, buf, 5);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int omnia_led_brightness_set_blocking(struct led_classdev *cdev,
+					     enum led_brightness brightness)
+{
+	struct led_classdev_mc *mc_cdev = lcdev_to_mccdev(cdev);
+	struct omnia_leds *leds = dev_get_drvdata(cdev->dev->parent);
+	struct omnia_led *led = to_omnia_led(mc_cdev);
+	int ret;
+
+	mutex_lock(&leds->lock);
+
+	ret = omnia_led_brightness_set(leds->client, led, brightness);
 
 	mutex_unlock(&leds->lock);
 
-- 
2.26.3

