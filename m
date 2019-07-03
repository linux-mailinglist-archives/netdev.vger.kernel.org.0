Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952565E098
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 11:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfGCJKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 05:10:54 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41488 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfGCJKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 05:10:54 -0400
Received: by mail-lj1-f194.google.com with SMTP id 205so1557800ljj.8;
        Wed, 03 Jul 2019 02:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dxK+dS4JuwEveW7RMUn+qtetDdgB8UT3+1wItb58QBs=;
        b=T7c/MKHL8GJ+xUBAtBdg1dTSdeY78gn7VW80Su2Tp6ouwVZ2+dq4wkl9yDhEAvXKXO
         iFHx6jGLz7apmjtxrrMp8BQCwxSpH12N+EOth6vF9cuh1j0lBWgjqt/FIhFB4OZ5Xdl9
         l/T0REPvtUOS0yCHPtW0JE1fAIgl1JTm3iK+4GbfXZRzxhJT/GK06QfVZWTPt42UXNn3
         rncN7B8y3FpfuKWK6d9H3Ya9OHjWtAg+gYkAW9tl69KCM5HHS7Kiq181+QZ3F0rHnDxn
         x1nlCT5kiNqlPIS2LhbrToRck6Mp5OU1naQDr7l/m5F/a+t6TC5dJtp99DjcGvluCEs0
         pBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dxK+dS4JuwEveW7RMUn+qtetDdgB8UT3+1wItb58QBs=;
        b=QyItY5IdKu8kYsQmMJ2vWj2PqUxdxydyMYS0HraY6EHghJa21MxYGWZ1HWYVLUXEfI
         XZrqXE1UodA2kffeMxmCMveVJMFg0pYJiIrXu1050F9+fPS95NTdJKcHGxhSzJZUrH+U
         Js60UHHb/YZ+yVXkkIBq6vyp+0ir25AIvUcRn/zuPOYhZjzrw8VXsSbm2GBnwXDUHl2O
         3MiFdgYDDMq/woyK+dTzRKQbw4LiJXtIll/tUpanHVI6uvWUMBsoRZfQjQKH66ZR69gz
         vqCtVeb1lWzEtwE7xAQJDjWAQBAYAj8kud+D3Br/H+AJXtOow8+wyniUu1Zk6JKIlmJ/
         3uFw==
X-Gm-Message-State: APjAAAWAMBzfyRc6Qa6YYU+0v1IHbwzQ32iYjfSQyuml72IBzjeFL5ko
        f0yh6iHIVh4Ewktkmlfn154=
X-Google-Smtp-Source: APXvYqybDJGFRx5l/ZcYbNpgvLzBtneuQMzQdHC6QyEFmzEnD3HR0eH68JHNVbEGCrCuAF8gIpofgQ==
X-Received: by 2002:a2e:b0ea:: with SMTP id h10mr1928541ljl.50.1562145051967;
        Wed, 03 Jul 2019 02:10:51 -0700 (PDT)
Received: from krolik-desktop.lan ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id p87sm354745ljp.50.2019.07.03.02.10.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 02:10:51 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     paweldembicki@gmail.com, linus.walleij@linaro.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] net: dsa: vsc73xx: Assert reset if iCPU is enabled
Date:   Wed,  3 Jul 2019 11:10:48 +0200
Message-Id: <20190703091048.1962-1-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190701152723.624-4-paweldembicki@gmail.com>
References: <20190701152723.624-4-paweldembicki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver allow to use devices with disabled iCPU only.

Some devices have pre-initialised iCPU by bootloader.
That state make switch unmanaged. This patch force reset
if device is in unmanaged state. In the result chip lost
internal firmware from RAM and it can be managed.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
---
Changes in v2:
- rebase commit after changes 1-3/4 patches

 drivers/net/dsa/vitesse-vsc73xx-core.c | 36 ++++++++++++--------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 10063f31d9a3..4525702faf68 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -417,22 +417,8 @@ static int vsc73xx_detect(struct vsc73xx *vsc)
 	}
 
 	if (val == 0xffffffff) {
-		dev_info(vsc->dev, "chip seems dead, assert reset\n");
-		gpiod_set_value_cansleep(vsc->reset, 1);
-		/* Reset pulse should be 20ns minimum, according to datasheet
-		 * table 245, so 10us should be fine
-		 */
-		usleep_range(10, 100);
-		gpiod_set_value_cansleep(vsc->reset, 0);
-		/* Wait 20ms according to datasheet table 245 */
-		msleep(20);
-
-		ret = vsc73xx_read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
-				   VSC73XX_ICPU_MBOX_VAL, &val);
-		if (val == 0xffffffff) {
-			dev_err(vsc->dev, "seems not to help, giving up\n");
-			return -ENODEV;
-		}
+		dev_info(vsc->dev, "chip seems dead.\n");
+		return -EAGAIN;
 	}
 
 	ret = vsc73xx_read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
@@ -483,9 +469,8 @@ static int vsc73xx_detect(struct vsc73xx *vsc)
 	}
 	if (icpu_si_boot_en && !icpu_pi_en) {
 		dev_err(vsc->dev,
-			"iCPU enabled boots from SI, no external memory\n");
-		dev_err(vsc->dev, "no idea how to deal with this\n");
-		return -ENODEV;
+			"iCPU enabled boots from PI/SI, no external memory\n");
+		return -EAGAIN;
 	}
 	if (!icpu_si_boot_en && icpu_pi_en) {
 		dev_err(vsc->dev,
@@ -1158,6 +1143,19 @@ int vsc73xx_probe(struct vsc73xx *vsc)
 		msleep(20);
 
 	ret = vsc73xx_detect(vsc);
+	if (ret == -EAGAIN) {
+		dev_err(vsc->dev,
+			"Chip seams to be out of control. Assert reset and try again.\n");
+		gpiod_set_value_cansleep(vsc->reset, 1);
+		/* Reset pulse should be 20ns minimum, according to datasheet
+		 * table 245, so 10us should be fine
+		 */
+		usleep_range(10, 100);
+		gpiod_set_value_cansleep(vsc->reset, 0);
+		/* Wait 20ms according to datasheet table 245 */
+		msleep(20);
+		ret = vsc73xx_detect(vsc);
+	}
 	if (ret) {
 		dev_err(dev, "no chip found (%d)\n", ret);
 		return -ENODEV;
-- 
2.20.1

