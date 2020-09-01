Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB9125A1C3
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgIAW7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgIAW7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:59:23 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103A8C061245;
        Tue,  1 Sep 2020 15:59:23 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x18so1312672pll.6;
        Tue, 01 Sep 2020 15:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f3rJB4drqUi57W2zR2kdhntilYhVPNgozy2dTXPbHcs=;
        b=J9FXqU4PszduwFId3UoISoVbsj4bfjHCIRoQ3Xe4vyKyfM17IeciOco3HvJbneLLRY
         yNfvkPqSyz2kBHjnNqj5HLABJYao6Zm9XbzbGqiYuXaUY/LFhRl9s426NI3PyIcFBaA3
         xm08Z0krZ3qaXgmrJ8uEp55OGEr196A2Dip3nbrFTHpWCQ4V8/e1SCLDwx315gI9oNIb
         I5/v59GTGU0VNRBsTvsbJ9Qeo4xaXwvvGedopn3NgQ6GZicL/HuTA73xB0EBLeL6GHQW
         n1v8Z3Nb/z90xTLyYyeQ97rez8nY43zIBIZPbrle1uS1Emj6wytl507eA1YDqsj+QURE
         zfCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f3rJB4drqUi57W2zR2kdhntilYhVPNgozy2dTXPbHcs=;
        b=NLNLxZiu4h03x4wfxNZ3BEnkA7Z7kK4NIA7nId1hJxhX/K5zNlGpg6j2NhQVBNtMWx
         942Yr+kpBg/ERDYuDs43R0JtqfondAmYaS6yu0BhiIzpf5Q9MAcu3Z7M7hXHnd2liwov
         YIOJ8bzoleAZePgqKPENrDG7Vol6gBoUEj/jddKaa1iA+nMvyRi8jvNbVwa37t5pOoW6
         qcL0Mqz5tWc6wng3VFc2jOtqFW2vVar+8p90WRhuba/nvMaY/6k/994I70jKHLyV9cXz
         EvGoHCI3xR1zlI7K2UUM4CudX86AMhbNQBVqMesEZtUOmVTVv8JKItIqaKfhwHBCOpAn
         I2BA==
X-Gm-Message-State: AOAM532bs/zuOxcv1g0O+u9CBJ6+fUksfVhyW0mJakVuOXG6P2lqMa1b
        fpwsxWciaB4MCBV0g/ppGFQBRaFRJ4A=
X-Google-Smtp-Source: ABdhPJwsgC2sRABGdRk4rHWd2vt07HY3fSJduie2IvJSESSzn1qMsSH4WIEiuLC6gRL/Im/AW8T1fw==
X-Received: by 2002:a17:902:9a45:: with SMTP id x5mr3407809plv.243.1599001162102;
        Tue, 01 Sep 2020 15:59:22 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m188sm2952750pfm.220.2020.09.01.15.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 15:59:21 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 3/3] net: dsa: bcm_sf2: recalculate switch clock rate based on ports
Date:   Tue,  1 Sep 2020 15:59:13 -0700
Message-Id: <20200901225913.1587628-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200901225913.1587628-1-f.fainelli@gmail.com>
References: <20200901225913.1587628-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever a port gets enabled/disabled, recalcultate the required switch
clock rate to make sure it always gets set to the expected rate
targeting our switch use case. This is only done for the BCM7445 switch
as there is no clocking profile available for BCM7278.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 68 +++++++++++++++++++++++++++++++++++++--
 drivers/net/dsa/bcm_sf2.h |  2 ++
 2 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index b8fa0a46c5c9..1c7fbb6f0447 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -32,6 +32,49 @@
 #include "b53/b53_priv.h"
 #include "b53/b53_regs.h"
 
+/* Return the number of active ports, not counting the IMP (CPU) port */
+static unsigned int bcm_sf2_num_active_ports(struct dsa_switch *ds)
+{
+	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
+	unsigned int port, count = 0;
+
+	for (port = 0; port < ARRAY_SIZE(priv->port_sts); port++) {
+		if (dsa_is_cpu_port(ds, port))
+			continue;
+		if (priv->port_sts[port].enabled)
+			count++;
+	}
+
+	return count;
+}
+
+static void bcm_sf2_recalc_clock(struct dsa_switch *ds)
+{
+	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
+	unsigned long new_rate;
+	unsigned int ports_active;
+	/* Frequenty in Mhz */
+	const unsigned long rate_table[] = {
+		59220000,
+		60820000,
+		62500000,
+		62500000,
+	};
+
+	ports_active = bcm_sf2_num_active_ports(ds);
+	if (ports_active == 0 || !priv->clk_mdiv)
+		return;
+
+	/* If we overflow our table, just use the recommended operational
+	 * frequency
+	 */
+	if (ports_active > ARRAY_SIZE(rate_table))
+		new_rate = 90000000;
+	else
+		new_rate = rate_table[ports_active - 1];
+	clk_set_rate(priv->clk_mdiv, new_rate);
+}
+
 static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
@@ -83,6 +126,8 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 		reg &= ~(RX_DIS | TX_DIS);
 		core_writel(priv, reg, CORE_G_PCTL_PORT(port));
 	}
+
+	priv->port_sts[port].enabled = true;
 }
 
 static void bcm_sf2_gphy_enable_set(struct dsa_switch *ds, bool enable)
@@ -168,6 +213,10 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
 	if (!dsa_is_user_port(ds, port))
 		return 0;
 
+	priv->port_sts[port].enabled = true;
+
+	bcm_sf2_recalc_clock(ds);
+
 	/* Clear the memory power down */
 	reg = core_readl(priv, CORE_MEM_PSM_VDD_CTRL);
 	reg &= ~P_TXQ_PSM_VDD(port);
@@ -261,6 +310,10 @@ static void bcm_sf2_port_disable(struct dsa_switch *ds, int port)
 	reg = core_readl(priv, CORE_MEM_PSM_VDD_CTRL);
 	reg |= P_TXQ_PSM_VDD(port);
 	core_writel(priv, reg, CORE_MEM_PSM_VDD_CTRL);
+
+	priv->port_sts[port].enabled = false;
+
+	bcm_sf2_recalc_clock(ds);
 }
 
 
@@ -1202,10 +1255,18 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 
 	clk_prepare_enable(priv->clk);
 
+	priv->clk_mdiv = devm_clk_get_optional(&pdev->dev, "sw_switch_mdiv");
+	if (IS_ERR(priv->clk_mdiv)) {
+		ret = PTR_ERR(priv->clk_mdiv);
+		goto out_clk;
+	}
+
+	clk_prepare_enable(priv->clk_mdiv);
+
 	ret = bcm_sf2_sw_rst(priv);
 	if (ret) {
 		pr_err("unable to software reset switch: %d\n", ret);
-		goto out_clk;
+		goto out_clk_mdiv;
 	}
 
 	bcm_sf2_gphy_enable_set(priv->dev->ds, true);
@@ -1213,7 +1274,7 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	ret = bcm_sf2_mdio_register(ds);
 	if (ret) {
 		pr_err("failed to register MDIO bus\n");
-		goto out_clk;
+		goto out_clk_mdiv;
 	}
 
 	bcm_sf2_gphy_enable_set(priv->dev->ds, false);
@@ -1280,6 +1341,8 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 
 out_mdio:
 	bcm_sf2_mdio_unregister(priv);
+out_clk_mdiv:
+	clk_disable_unprepare(priv->clk_mdiv);
 out_clk:
 	clk_disable_unprepare(priv->clk);
 	return ret;
@@ -1295,6 +1358,7 @@ static int bcm_sf2_sw_remove(struct platform_device *pdev)
 	dsa_unregister_switch(priv->dev->ds);
 	bcm_sf2_cfp_exit(priv->dev->ds);
 	bcm_sf2_mdio_unregister(priv);
+	clk_disable_unprepare(priv->clk_mdiv);
 	clk_disable_unprepare(priv->clk);
 	if (priv->type == BCM7278_DEVICE_ID && !IS_ERR(priv->rcdev))
 		reset_control_assert(priv->rcdev);
diff --git a/drivers/net/dsa/bcm_sf2.h b/drivers/net/dsa/bcm_sf2.h
index 6dd69922e3f6..1ed901a68536 100644
--- a/drivers/net/dsa/bcm_sf2.h
+++ b/drivers/net/dsa/bcm_sf2.h
@@ -45,6 +45,7 @@ struct bcm_sf2_hw_params {
 
 struct bcm_sf2_port_status {
 	unsigned int link;
+	bool enabled;
 };
 
 struct bcm_sf2_cfp_priv {
@@ -94,6 +95,7 @@ struct bcm_sf2_priv {
 	u32				wol_ports_mask;
 
 	struct clk			*clk;
+	struct clk			*clk_mdiv;
 
 	/* MoCA port location */
 	int				moca_port;
-- 
2.25.1

