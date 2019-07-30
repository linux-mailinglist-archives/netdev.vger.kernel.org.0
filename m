Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FBD7A2CD
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 10:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730847AbfG3II3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 04:08:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44404 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730839AbfG3II3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 04:08:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id i18so29639168pgl.11;
        Tue, 30 Jul 2019 01:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=C634oO1Vvg8gLOtxb4yBVodzYW9QR1/y80u/tow7L2k=;
        b=b0yfxootDJhcs8CuJf+eEBmeq1XhR6C/6+5PDI6ssvqskLe8vuVMIBeOawiBL6fZxM
         8lpStI2oTnwv+ygzfO7bamEMEOIt8wjKPXXBGzDvTDCuCoI/eGI1oZl+xucyt+iHQHpg
         01wxQcZznUzy88gdJN6yu+7mt3dPa6UYdBpq7Zw8VbxKXk3wt2+Tl+1mo4MMrJPiSbEM
         Kvzf6SOg6c2O8icIX6emc9XGtCyT6widBEKdtNzMjgJ7PC6Q+BhLBNX43lYNzS+ERZ3n
         T6QRhxlvxavNldq0zemUoBxVOdiC6hEcJUGJRkg7RrhRDZ+AwDTvHOGHx7WGG35SbocC
         EpDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=C634oO1Vvg8gLOtxb4yBVodzYW9QR1/y80u/tow7L2k=;
        b=VLc9fRMPiUtkDRcsMayL2KlpQdbRj0kPoWjQOIDbvQwOw5y9njuDoH/LxPcySqLS6N
         gM6Ge+k+mOUZMQtVFsGHouLquxOIcsLmGr/RCtP2rsvFf5wBFi6+vxKwSbOhnmk6JtHG
         wj6xq5vxlj2aX4KfO0EDwRa9J32VANQk/Q7C5z5hR1tiydrWvkpz106WFZ1zJxiplFjm
         bUNAVhXv13FP1BPGTodQkdtq7YRfLJkuPfhaeyy9c1rbH2sUke6EgYDQ5hBIlufQAnej
         s3QPaxQ9HpEEOlfDXvHO+2L2LqdOvtKG89YHy7DfjcMZ8oeT7bPBblnrj+m/hwwUIWAi
         isXw==
X-Gm-Message-State: APjAAAXF0NhFBbeZMcmty9TqDOmZnWJwd+G9ArK+di1ZyJifY+e/7wyi
        nvOPQe2VWshlItBM6xX3f+0=
X-Google-Smtp-Source: APXvYqwVaja96IEggB/T9248aVYwNZGJvrKt7ibuuT+K/CSoSQHQ9PfoYCfZyYNiW5iVRX/pEnUtKA==
X-Received: by 2002:a62:e901:: with SMTP id j1mr41448608pfh.189.1564474108960;
        Tue, 30 Jul 2019 01:08:28 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id q198sm67159888pfq.155.2019.07.30.01.08.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 01:08:28 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2] net: phy: phy_led_triggers: Fix a possible null-pointer dereference in phy_led_trigger_change_speed()
Date:   Tue, 30 Jul 2019 16:08:13 +0800
Message-Id: <20190730080813.15363-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In phy_led_trigger_change_speed(), there is an if statement on line 48
to check whether phy->last_triggered is NULL: 
    if (!phy->last_triggered)

When phy->last_triggered is NULL, it is used on line 52:
    led_trigger_event(&phy->last_triggered->trigger, LED_OFF);

Thus, a possible null-pointer dereference may occur.

To fix this bug, led_trigger_event(&phy->last_triggered->trigger,
LED_OFF) is called when phy->last_triggered is not NULL.

This bug is found by a static analysis tool STCheck written by
the OSLAB group in Tsinghua University.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
v2:
* Add the organization of the tool's authors.
  Thank David and Andrew for helpful advice.

---
 drivers/net/phy/phy_led_triggers.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_led_triggers.c b/drivers/net/phy/phy_led_triggers.c
index b86a4b2116f8..59a94e07e7c5 100644
--- a/drivers/net/phy/phy_led_triggers.c
+++ b/drivers/net/phy/phy_led_triggers.c
@@ -48,8 +48,9 @@ void phy_led_trigger_change_speed(struct phy_device *phy)
 		if (!phy->last_triggered)
 			led_trigger_event(&phy->led_link_trigger->trigger,
 					  LED_FULL);
+		else
+			led_trigger_event(&phy->last_triggered->trigger, LED_OFF);
 
-		led_trigger_event(&phy->last_triggered->trigger, LED_OFF);
 		led_trigger_event(&plt->trigger, LED_FULL);
 		phy->last_triggered = plt;
 	}
-- 
2.17.0

