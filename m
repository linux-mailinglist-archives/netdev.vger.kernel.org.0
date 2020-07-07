Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DC02162F8
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 02:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgGGAYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 20:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgGGAYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 20:24:16 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA0AC061755;
        Mon,  6 Jul 2020 17:24:15 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id s21so19359142ilk.5;
        Mon, 06 Jul 2020 17:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=VfPSKiDlwbdW5XR5+Adboy9m9ASBVezCedgkiWC3Kf8=;
        b=blUs/jBjoeaD4aId8u3vk9IMIS4CjuhjiKF4xh4vEl5E26L7Yz1WqR22Zf3se+FfP9
         tAC422b1UVkZ7D9DtCZUQCoPAsVxckmUTF/acfVJ/Pz+W+pL9JJMprDzl8eXmDkYxeBT
         BR5PaMbW1vUqDATej1l2A3F6QmfBcMK/wtX8oJ3Hy/aiQAzrts1fOG+WsD27KXJT9sBJ
         TJSOi8dmLc2k4mQ2wI6lSU+iOjPOZsfMkRq0LWbGmV1LtYl2hvBeP3qZh//F7dan2vvy
         cIG2RbwrXZwcx/iV9T3kGxel5Zxh3Xewvazu2JNiD28TCjgJW7UtO873XETBwJFNcfsF
         omqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VfPSKiDlwbdW5XR5+Adboy9m9ASBVezCedgkiWC3Kf8=;
        b=TwO9VJeRKscy1SPOOWybJZfVFZ6oFDTKMUAlh9F1QK49mFC9ykloG7mD+nwxXn2d4i
         5IWG0Lh4XcUULoollwrlrkoTchdRynstOwsgkmWhRkpmgZNqS1UOlTFlyD7UrOUaJFcW
         uiRL8xU11LZf2oF6Xm8Gjz47Sar7lM7ZchiDPtjktDH1h+Zy/6hP083LP8QJps8/1N8I
         89o/owTBGJMt5F4HQyWpvDi1TwSq6to3j5zPXYG8Eb4L3A6AW8iQMPhJrQlVhJl2R7BG
         dXBj+5l2wcV8ukqjlVTJcp5cE5Yk+9gzblDU3Gu0a6zam4JoBJ2NfvK195Stcgkh29hx
         BEOw==
X-Gm-Message-State: AOAM532gk67p2ZcPN0qqHn69Tk1TMB3vdHZ0l9G0Dw0lh4ZovvBs5+Rl
        O6gb3xhu2bB+mlKI6ZbuX6zQ9Az+wtk9PRcmEBY=
X-Google-Smtp-Source: ABdhPJxMOvIOyqWFqev9TtTG0SM8LjjtHnjhtS9fnd4C/4GFAxmWXWhi5DR6lto4azrt/de/3U0/5mWtfkGaZMutRE8=
X-Received: by 2002:a92:c78d:: with SMTP id c13mr33303733ilk.85.1594081455336;
 Mon, 06 Jul 2020 17:24:15 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Healy <cphealy@gmail.com>
Date:   Mon, 6 Jul 2020 17:24:04 -0700
Message-ID: <CAFXsbZoOoOkgkxXNbG5JTXHdJiSoxu2OiHKHh39m3GfYE2jGcg@mail.gmail.com>
Subject: [PATCH net-next v2] net: sfp: Unique GPIO interrupt names
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dynamically generate a unique GPIO interrupt name, based on the
device name and the GPIO name.  For example:

103:          0   sx1503q  12 Edge      sff2-los
104:          0   sx1503q  13 Edge      sff2-tx-fault

The sffX indicates the SFP the los and tx-fault are associated with.

Signed-off-by: Chris Healy <cphealy@gmail.com>

v2:
- added net-next to PATCH part of subject line
- switched to devm_kasprintf()
---
 drivers/net/phy/sfp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 73c2969f11a4..193a124c26c4 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2239,6 +2239,7 @@ static int sfp_probe(struct platform_device *pdev)
     const struct sff_data *sff;
     struct i2c_adapter *i2c;
     struct sfp *sfp;
+    char *sfp_irq_name;
     int err, i;

     sfp = sfp_alloc(&pdev->dev);
@@ -2349,12 +2350,16 @@ static int sfp_probe(struct platform_device *pdev)
             continue;
         }

+        sfp_irq_name = devm_kasprintf(sfp->dev, GFP_KERNEL,
+                          "%s-%s", dev_name(sfp->dev),
+                          gpio_of_names[i]);
+
         err = devm_request_threaded_irq(sfp->dev, sfp->gpio_irq[i],
                         NULL, sfp_irq,
                         IRQF_ONESHOT |
                         IRQF_TRIGGER_RISING |
                         IRQF_TRIGGER_FALLING,
-                        dev_name(sfp->dev), sfp);
+                        sfp_irq_name, sfp);
         if (err) {
             sfp->gpio_irq[i] = 0;
             sfp->need_poll = true;
-- 
2.21.3
