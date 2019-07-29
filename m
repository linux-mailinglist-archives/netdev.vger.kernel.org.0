Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36DBB7884D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 11:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfG2JYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 05:24:31 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44155 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbfG2JYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 05:24:31 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so27683393pfe.11;
        Mon, 29 Jul 2019 02:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iEPQWdk7UY38XyqCqFUl6jqb3HHws5WOlTzCj+DZ+3o=;
        b=iyNRZMouqrwVQy8ikh4/UX/XkzexUdmL8Jh9freBH2MOw/uvaupzpUbqwY5V0BV6i9
         OzpQjODV/WTWHxhAnrP1jgn1yrfsC5XXd/BpYkeN3ydCKzFbpPMjpNe0KgK0FnHsXMB1
         Mao5Uhg2q6hAfzvjmcmRatMwOdf7AkvhLLkekAb2wZiQBdZIfFfrvqSD2x0uZszgY/Bv
         VdWWl8iv0XX4tEiE8pI4BAyxQ/XwPXvOks58Yc0E0odU1YzVRWaI6zHAkTkELRq8K401
         SkwI1U9esKkwuEBNAssWg9IznXJCbzvynfg++V4Kzx+YsxTpdFMCzA8ofylE2EXDTDpm
         USWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iEPQWdk7UY38XyqCqFUl6jqb3HHws5WOlTzCj+DZ+3o=;
        b=B8pqSGlqBhebyDnmJBsiNO2XZ+jdk0Ti2hjFS9t8CXWb6JtJceWEunMQDLQbVOaiKD
         6H0mHEizb0pTRbPYseQcQEpU2TjbixXIO0CmGBM6ZAkEwnCUYVN7GiUe7eJjspp8SEUn
         LkUI1aOnvdY8/Vdbehs5AS8/kKp2eUcTKGhiSoMvHm3LxoetUcHQGaKXARN0Xmy6bgpR
         A6gVxud9MiG3gNzfus/WKYslVFBpkc2mE8nI66H9vuRHKtoGnE4hgsRXWtCXlF7wtWri
         aR3tvdOpT1ppYfFPs1YgHbDkhrtSXQPnLssjgLH/mr1wQt2n8e9LyH+MWfR++usCoLUK
         7VYQ==
X-Gm-Message-State: APjAAAXdfcLm+gjUJKPP++CgLK+hT9Xxp526o0TemRSx4cqEKZvX9K63
        GaIRbT4wM9lsKjRXH5syCjk=
X-Google-Smtp-Source: APXvYqyXgiorjzCh5evO4TizJOF1muHqKjYiGDPnEhyAkM/ScAN9VRBGAhZex+sRhUuh7tL+z+LZ8g==
X-Received: by 2002:a17:90a:360b:: with SMTP id s11mr109650186pjb.51.1564392270649;
        Mon, 29 Jul 2019 02:24:30 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id j1sm84343495pgl.12.2019.07.29.02.24.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 02:24:30 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: phy: phy_led_triggers: Fix a possible null-pointer dereference in phy_led_trigger_change_speed()
Date:   Mon, 29 Jul 2019 17:24:24 +0800
Message-Id: <20190729092424.30928-1-baijiaju1990@gmail.com>
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

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
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

