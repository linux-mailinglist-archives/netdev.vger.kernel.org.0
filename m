Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189F8EEBE4
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbfKDVvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:51:54 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39247 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730624AbfKDVvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 16:51:52 -0500
Received: by mail-wm1-f67.google.com with SMTP id t26so13640255wmi.4
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 13:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qgptwM15zDPj4vHndZtT3224Bom01dw39CPcuMZnQZM=;
        b=Oho70zq+pQry6yjLaB8pTYYyNVmbYSYW9b65QIiA7ZbcHViWvyvacTUF+D6XmJXZMj
         dc9rq51KwlCRk30wDFnHA8BpTviH6qFyfEHrCipmf0WuHDiOKyPxnx62xqCd+zstmJSa
         3RMkYAD4+NM/Au+f8dRqdyrxVnAugMS98J04xkL5esq6klt9vdvcsnDY0Egex4vPkdk1
         HKjQ67AtyUwQ5xtIllYwKGL3SiHxZy1Zg85MYJ5IAWORhJwlk831tmy6ROWxUCfnhCxO
         ufZyDVA+PoJyVp/HHVafx5kaYGG5zMgomn0do977nkRlO/Aa22o9ICxMeStUB10rwdOM
         dYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qgptwM15zDPj4vHndZtT3224Bom01dw39CPcuMZnQZM=;
        b=KF9APhkfy7SZVg73YCJNatVI/7LW4Y0H1TEvX7M7UmGFhrCHBhJCRelk5rI/maRHk1
         O78TN1pE9ZiHgrfvxjwFoCz3Q3Co18lzTdr35C2jegft0ZVu1E5cPWzZV56FL7NAe2oP
         lsk+tXo2BOOPxFmyZJpnuu0TI/qnlkl31uIgjUwrDMfwaEiEkagXp09K7FXomaavdyG0
         H0+THha6zXZ3BXMbi0MkRJYHgXv4j7YIJthuiBmYAG8kVfTCTAkmplbdbfppLcr/1qeb
         lilYnxqko0NVqWiiQMgiUVPugV+Mpp+u9RNpAih+lI5vHHlDYDr3pxDv7YA852kA2mvt
         6XRQ==
X-Gm-Message-State: APjAAAVToLD7CkIHJXXX60e1zZLFlLeDshrUWoTry6g/nFswEg2LZG52
        zKxPdscqpxBkNmOT+qzxpB1R61CG
X-Google-Smtp-Source: APXvYqyj9MzlUwLYNvfP6aV8qsBVDJxA+SC6+ogS+4UhgO9W/azevPjaBI4GzjuByVw6+ToBiKEHOQ==
X-Received: by 2002:a1c:5fc4:: with SMTP id t187mr1111635wmb.142.1572904309618;
        Mon, 04 Nov 2019 13:51:49 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t133sm21439302wmb.1.2019.11.04.13.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 13:51:49 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next v2 2/2] net: dsa: bcm_sf2: Add support for optional reset controller line
Date:   Mon,  4 Nov 2019 13:51:39 -0800
Message-Id: <20191104215139.17047-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191104215139.17047-1-f.fainelli@gmail.com>
References: <20191104215139.17047-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Grab an optional and exclusive reset controller line for the switch and
manage it during probe/remove functions accordingly. For 7278 devices we
change bcm_sf2_sw_rst() to use the reset controller line since the
WATCHDOG_CTRL register does not reset the switch contrary to stated
documentation.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 19 +++++++++++++++++++
 drivers/net/dsa/bcm_sf2.h |  3 +++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 9add84c79dd6..37fc68792406 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -350,6 +350,18 @@ static int bcm_sf2_sw_rst(struct bcm_sf2_priv *priv)
 {
 	unsigned int timeout = 1000;
 	u32 reg;
+	int ret;
+
+	/* The watchdog reset does not work on 7278, we need to hit the
+	 * "external" reset line through the reset controller.
+	 */
+	if (priv->type == BCM7278_DEVICE_ID && !IS_ERR(priv->rcdev)) {
+		ret = reset_control_assert(priv->rcdev);
+		if (ret)
+			return ret;
+
+		return reset_control_deassert(priv->rcdev);
+	}
 
 	reg = core_readl(priv, CORE_WATCHDOG_CTRL);
 	reg |= SOFTWARE_RESET | EN_CHIP_RST | EN_SW_RESET;
@@ -1091,6 +1103,11 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	priv->core_reg_align = data->core_reg_align;
 	priv->num_cfp_rules = data->num_cfp_rules;
 
+	priv->rcdev = devm_reset_control_get_optional_exclusive(&pdev->dev,
+								"switch");
+	if (PTR_ERR(priv->rcdev) == -EPROBE_DEFER)
+		return PTR_ERR(priv->rcdev);
+
 	/* Auto-detection using standard registers will not work, so
 	 * provide an indication of what kind of device we are for
 	 * b53_common to work with
@@ -1223,6 +1240,8 @@ static int bcm_sf2_sw_remove(struct platform_device *pdev)
 	/* Disable all ports and interrupts */
 	bcm_sf2_sw_suspend(priv->dev->ds);
 	bcm_sf2_mdio_unregister(priv);
+	if (priv->type == BCM7278_DEVICE_ID && !IS_ERR(priv->rcdev))
+		reset_control_assert(priv->rcdev);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/bcm_sf2.h b/drivers/net/dsa/bcm_sf2.h
index 1df30ccec42d..de386dd96d66 100644
--- a/drivers/net/dsa/bcm_sf2.h
+++ b/drivers/net/dsa/bcm_sf2.h
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/if_vlan.h>
+#include <linux/reset.h>
 
 #include <net/dsa.h>
 
@@ -64,6 +65,8 @@ struct bcm_sf2_priv {
 	void __iomem			*fcb;
 	void __iomem			*acb;
 
+	struct reset_control		*rcdev;
+
 	/* Register offsets indirection tables */
 	u32 				type;
 	const u16			*reg_offsets;
-- 
2.17.1

