Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15745EE78B
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 19:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbfKDSm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 13:42:27 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45656 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729622AbfKDSmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 13:42:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id q13so18324779wrs.12
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 10:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZEEpLXkXqX8fWlq1ZkAGCu2RGa5j3XPcg1Oz0LRjstY=;
        b=fGOhxuK5dwI0Oyf/e972/BEqyDgUtBGkEIH+yv7YcwWrN0iymU1jbaWYJUI7uyOA0W
         wlElCtm/xxhvYw4s9Zemb5jryoYAZyYOroi593YlLhqgioaGAaG8StzM4Ydyanuxt3cL
         /tlbuOwZpJuwwk4Bianz+nosreVjROqE1bawPzXlUWO0n2aSoDLSZHaXROxxxyPGW0VR
         7SJoZRVsYyMx/iU0GKE2CvOkw16+G69HET91OEzUo/asVLjpIykMXOKta0U/O41Fq0vH
         qMqZ8WUevdvqfMnJ/AKL7Jsc5TryVyomV9S0IoliYg5/DjMNVMxwXn8YscwhxYcfTyT+
         F5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZEEpLXkXqX8fWlq1ZkAGCu2RGa5j3XPcg1Oz0LRjstY=;
        b=iTWzdPhz3YhtTNNYLwMH27JthdP3bsmOrRlPPLH+DG7J7vqP9zSTH43Fj4ua3Aa90+
         2lbh74BG4ZozPet/rln0JIBlFtzH2yx96vAn8wdY0RulKkRvtjRouId09r3X0ci7MLeW
         gylSCvlG9iAHm/FcOuhzY5kMxutxDyfU5aOanZ2Bdyy6pU5wksPB2wcDn9x071AL+Rwt
         7/jrfJhh8y7RUugkBFyYI2eSxzxVMg2tWulk7VTVVnyDrGYDxx67HY0tGH4D1KpdzFzT
         k0miz+LyZqZwjpzOivEF4b9Q6+JU5YJPkC0BiNq1VhkUogIByq9tRunoj3u1O45QVnj3
         VmHA==
X-Gm-Message-State: APjAAAWKLeMJuRYb88roQrmqbqk0ckr4lidcAee63JAgU/1S9Jrs5jcz
        Jl85aIbE4joHaNCgcurB1fpO6ZkQ
X-Google-Smtp-Source: APXvYqw4tKsmOFKB6khxoFmxLYwOW3UsnZj8Q9Jz7wnG4x0ltf+wcja7XoN4a37SUmeWfgJKZbsLow==
X-Received: by 2002:adf:fe0e:: with SMTP id n14mr4441062wrr.72.1572892942535;
        Mon, 04 Nov 2019 10:42:22 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l2sm16586993wrt.15.2019.11.04.10.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 10:42:21 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 2/2] net: dsa: bcm_sf2: Add support for optional reset controller line
Date:   Mon,  4 Nov 2019 10:42:03 -0800
Message-Id: <20191104184203.2106-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191104184203.2106-1-f.fainelli@gmail.com>
References: <20191104184203.2106-1-f.fainelli@gmail.com>
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
index 9add84c79dd6..e001c3842afb 100644
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
+	if (!IS_ERR(priv->rcdev))
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

