Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550685FE6A
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 00:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfGDW3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 18:29:35 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44565 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbfGDW3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 18:29:33 -0400
Received: by mail-lf1-f68.google.com with SMTP id r15so5047773lfm.11;
        Thu, 04 Jul 2019 15:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LbcpmzZuVuCYIwe6Ub1LYoVGaUsDBMeYG2A+mWra32E=;
        b=qjtX/WFXMIZPHyO+PalMhVFWoplWh0AqkH/4Oh9KY5KsvLugMPtWwrlIHQvTlF3esq
         bgyVy729oTar9G5Y5TvL5tqTYvVa2aar2pCJ1VYBUnppZxYm1mRKD5dMQiHiBhywBz2s
         /hj0zDfJ0hHsc3lP69z6UziL/EA1EhciDsj8KjpvzCfWPz1aI6/yZ1FzN/JQ3psrqNh+
         VPf+I5QrgqKMSP9Qc1CqriyzZrWclDg+Ryp104i15UpePAgBeAQaQr/dbIYQRAJj3+13
         G7SiM6Oz8vY7BMO1dDRxws/p6G+wvDyc6MLMJGGYLS1ZyEhNJX4Li2iTqyvazznnjmv6
         LizQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LbcpmzZuVuCYIwe6Ub1LYoVGaUsDBMeYG2A+mWra32E=;
        b=oHBa9YpSKrjoeoBGf8AXa+Xlj/mrI4PjdUa7/kgFzZx+wDuB1ZLPVBsDVCg5wtB+uu
         S7MD8TvYwK1cSG51YJubQPzntE9R5myQQZhSUtK3bYMOU3lU38LSDFCnfJjzGIVjAX08
         aKmemqup7WXXdHuC23P5PpwtVv+0vL0r22yktg6eYYYmMji3YEjaWJAWQg+3NJCgKWFr
         Pll3AcBf+73pmK/3hFxiKEVEg7g8UV3gF5ng8hVkvf80CrkSVm4KNU3XJww/9Ynf2Sop
         XmjlE2wbQGBcxOYqIgscaM3ncUevR2GuDD/zwlkFJKl9w55vI/X4/OfAxf8JcpvvF+er
         5pZw==
X-Gm-Message-State: APjAAAUUukLSZ4Tox6YLb33e1fcLrpKIjzRmp7sC+3xuORqjMSlqdnDe
        kZHH9hOpeCWBQlC8vUbmpJc=
X-Google-Smtp-Source: APXvYqwYhRJDl0CsCYnHCN9cujZDOBaWsm1DpXpmtLHcHq2+gyGPQQ536hA694JLnY5L+6btjFmc3g==
X-Received: by 2002:ac2:54a6:: with SMTP id w6mr366136lfk.108.1562279370982;
        Thu, 04 Jul 2019 15:29:30 -0700 (PDT)
Received: from krolik-desktop.lan ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id t25sm403645lfg.7.2019.07.04.15.29.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 15:29:30 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>, linus.walleij@linaro.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] net: dsa: vsc73xx: Assert reset if iCPU is enabled
Date:   Fri,  5 Jul 2019 00:29:07 +0200
Message-Id: <20190704222907.2888-5-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190704222907.2888-1-paweldembicki@gmail.com>
References: <20190704222907.2888-1-paweldembicki@gmail.com>
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
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 36 ++++++++++++--------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 10063f31d9a3..614377ef7956 100644
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
+			"Chip seems to be out of control. Assert reset and try again.\n");
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

