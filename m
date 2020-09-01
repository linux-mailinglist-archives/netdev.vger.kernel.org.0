Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B529D25A1C8
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 01:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgIAW7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgIAW7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:59:21 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8511EC061244;
        Tue,  1 Sep 2020 15:59:21 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l191so1506170pgd.5;
        Tue, 01 Sep 2020 15:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Capl7CE1BoBl1tfXP6GUSFZ6V4y5GZrTYTnU4/p5G8=;
        b=aquQ1r2imoAafGDgtP1uDrWFO+WZHgX6dYvKKJ0djcZzmFRt5QxyeX4mtCo2WRXp0b
         bU8ViqrVKZq1ebCWjX0nHZnkFwEoaNoWxxW4RGQDgpx6tLuDmZaMoJ2kmTcJ8l+oFBMo
         rOLThioRL6BSGF0lucJMc0aTyLfF8H1WiEr690ubApt0UFx1PztFF4pdtKrSAGrm58O0
         WucJRvXnoQrw4yMDa74XOGWUfULG24wHKLMtlsHHylPUdfeAgLShUsP6+9gmI/hbMvLm
         xWRwLGUGW8jDAyhdkPtGVkiSCsvInkHErM6bz9qjZzfXl/9GzuPuNJHmU+3jdjfblgjL
         Nw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Capl7CE1BoBl1tfXP6GUSFZ6V4y5GZrTYTnU4/p5G8=;
        b=QJsP5QLNk4SjUowoSzV+qsyEj9mHr3RReWWmCfe2iKcFEPGltOcmBv5Ov8KCLNqEEI
         jY4zvrDjJt7CrqH53euZ+tSr7cL5/n1uTSrBuJNSHMWkodgTHH67cHYdhPRjxCqE+Hsz
         EPnWxPfkbo6Hfgt6gvactNl6z6rKkMI2vFDuXyrCrLRDC1Qs/iyUDqNEhQhgUl2dca8H
         ccGGUongy4dBxr297V5gCZhpsvJNULzLQqwyBb1C75+7qYeM9KA4IWOhJXw3WTA2Qo+g
         h+gtCxnwHXR2NP2SwWPjlAvUD/CG8fU/4noWebR12Lj4Qc6/gE1Wp5PWCfCS/n0ncU+i
         QvIw==
X-Gm-Message-State: AOAM531SiQu8WZlg+UqRw0aPpn0L1oeEAS21ZLdogVyecpWjTA6mnsDq
        gUXoQ2xB3byQawG3DhMjBR4y4xhnt7o=
X-Google-Smtp-Source: ABdhPJz4esZZ5tEpXvTY8CYviED/LtDqd9scXVJgTmOmeQLElohb5s/wa3sKzo2o9GShAcpWYN/4XQ==
X-Received: by 2002:a63:ab43:: with SMTP id k3mr3513902pgp.426.1599001160671;
        Tue, 01 Sep 2020 15:59:20 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m188sm2952750pfm.220.2020.09.01.15.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 15:59:19 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/3] net: dsa: bcm_sf2: request and handle clocks
Date:   Tue,  1 Sep 2020 15:59:12 -0700
Message-Id: <20200901225913.1587628-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200901225913.1587628-1-f.fainelli@gmail.com>
References: <20200901225913.1587628-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fetch the corresponding clock resource and enable/disable it during
suspend/resume if and only if we have no ports defined for Wake-on-LAN.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 20 ++++++++++++++++++--
 drivers/net/dsa/bcm_sf2.h |  2 ++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index bafddb35f3a9..b8fa0a46c5c9 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -14,6 +14,7 @@
 #include <linux/phy_fixed.h>
 #include <linux/phylink.h>
 #include <linux/mii.h>
+#include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
@@ -750,6 +751,9 @@ static int bcm_sf2_sw_suspend(struct dsa_switch *ds)
 			bcm_sf2_port_disable(ds, port);
 	}
 
+	if (!priv->wol_ports_mask)
+		clk_disable_unprepare(priv->clk);
+
 	return 0;
 }
 
@@ -758,6 +762,9 @@ static int bcm_sf2_sw_resume(struct dsa_switch *ds)
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	int ret;
 
+	if (!priv->wol_ports_mask)
+		clk_prepare_enable(priv->clk);
+
 	ret = bcm_sf2_sw_rst(priv);
 	if (ret) {
 		pr_err("%s: failed to software reset switch\n", __func__);
@@ -1189,10 +1196,16 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 		base++;
 	}
 
+	priv->clk = devm_clk_get_optional(&pdev->dev, "sw_switch");
+	if (IS_ERR(priv->clk))
+		return PTR_ERR(priv->clk);
+
+	clk_prepare_enable(priv->clk);
+
 	ret = bcm_sf2_sw_rst(priv);
 	if (ret) {
 		pr_err("unable to software reset switch: %d\n", ret);
-		return ret;
+		goto out_clk;
 	}
 
 	bcm_sf2_gphy_enable_set(priv->dev->ds, true);
@@ -1200,7 +1213,7 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	ret = bcm_sf2_mdio_register(ds);
 	if (ret) {
 		pr_err("failed to register MDIO bus\n");
-		return ret;
+		goto out_clk;
 	}
 
 	bcm_sf2_gphy_enable_set(priv->dev->ds, false);
@@ -1267,6 +1280,8 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 
 out_mdio:
 	bcm_sf2_mdio_unregister(priv);
+out_clk:
+	clk_disable_unprepare(priv->clk);
 	return ret;
 }
 
@@ -1280,6 +1295,7 @@ static int bcm_sf2_sw_remove(struct platform_device *pdev)
 	dsa_unregister_switch(priv->dev->ds);
 	bcm_sf2_cfp_exit(priv->dev->ds);
 	bcm_sf2_mdio_unregister(priv);
+	clk_disable_unprepare(priv->clk);
 	if (priv->type == BCM7278_DEVICE_ID && !IS_ERR(priv->rcdev))
 		reset_control_assert(priv->rcdev);
 
diff --git a/drivers/net/dsa/bcm_sf2.h b/drivers/net/dsa/bcm_sf2.h
index de386dd96d66..6dd69922e3f6 100644
--- a/drivers/net/dsa/bcm_sf2.h
+++ b/drivers/net/dsa/bcm_sf2.h
@@ -93,6 +93,8 @@ struct bcm_sf2_priv {
 	/* Mask of ports enabled for Wake-on-LAN */
 	u32				wol_ports_mask;
 
+	struct clk			*clk;
+
 	/* MoCA port location */
 	int				moca_port;
 
-- 
2.25.1

