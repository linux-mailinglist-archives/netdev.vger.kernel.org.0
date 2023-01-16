Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AC666BBDC
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjAPKhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjAPKha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:37:30 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20524EEB;
        Mon, 16 Jan 2023 02:37:28 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9002F1BF21D;
        Mon, 16 Jan 2023 10:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673865447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fFLwBp143kB/LSaCSwLfM/ltYrhQ/PI8Cc5ar94b9Ls=;
        b=AbClFznbfLK1tHwzNMo1ZZTKkPrE2PqxhzA5su3b03jNpwuzLu/LnE7peKBjSobhwUqkG0
        9leHb8Mf6zMwXHUR9sXmR9w3a5G944U0VQlffclPECthNy2JLnZRb5BYL9XKSpFzzShZ+N
        x0IXJEorQS0lKX5X80PtA2mdCXq7am2nU72Yna4/y/ect0DBBT7AkeeUu/pwjFDuFhM9VK
        DOp/YaUz0Te5BPx3laRY6seLPz1sX/2UY44ZbZbFBYsmPIaomWj/TnxTrS8VHV8cNh59Lm
        ZK7tDhU/p5gp20ED6TR33ff/aOBIx82bC0pntSwv8RSy7hql4umCa1IOb+xF6Q==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 1/6] net: stmmac: add support to use a generic phylink_pcs as PCS
Date:   Mon, 16 Jan 2023 11:39:21 +0100
Message-Id: <20230116103926.276869-2-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116103926.276869-1-clement.leger@bootlin.com>
References: <20230116103926.276869-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the PCS is set based on the presence of the xpcs field. In
order to allow supporting other PCS, add a phylink_pcs pcs field to struct
mac_device_info which is used in stmmac_mac_select_pcs() to select the
correct PCS.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h      | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +----
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 1 +
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 6b5d96bced47..79fd67e8ab90 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -15,6 +15,7 @@
 #include <linux/netdevice.h>
 #include <linux/stmmac.h>
 #include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/pcs/pcs-xpcs.h>
 #include <linux/module.h>
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
@@ -518,6 +519,7 @@ struct mac_device_info {
 	const struct stmmac_tc_ops *tc;
 	const struct stmmac_mmc_ops *mmc;
 	struct dw_xpcs *xpcs;
+	struct phylink_pcs *phylink_pcs;
 	struct mii_regs mii;	/* MII register Addresses */
 	struct mac_link link;
 	void __iomem *pcsr;     /* vpointer to device CSRs */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c6951c976f5d..19459ef15a35 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -937,10 +937,7 @@ static struct phylink_pcs *stmmac_mac_select_pcs(struct phylink_config *config,
 {
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 
-	if (!priv->hw->xpcs)
-		return NULL;
-
-	return &priv->hw->xpcs->pcs;
+	return priv->hw->phylink_pcs;
 }
 
 static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 5f177ea80725..3e875d4664c0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -413,6 +413,7 @@ int stmmac_xpcs_setup(struct mii_bus *bus)
 		}
 
 		priv->hw->xpcs = xpcs;
+		priv->hw->phylink_pcs = &xpcs->pcs;
 		break;
 	}
 
-- 
2.39.0

