Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E934F1C0AF8
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 01:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgD3X1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 19:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726473AbgD3X1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 19:27:20 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D27FC035494;
        Thu, 30 Apr 2020 16:27:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f13so9468306wrm.13;
        Thu, 30 Apr 2020 16:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iwGMJ3atf52D3UJ+iV0PYj51AJ7HOOV59IlkEIgFlvs=;
        b=Ho8eIrETN/C38cQG9B4TyO8NBcw5yzdnfi+ArQyZI795mD9FgdBLI/C/TjXZxKRHak
         OsPLX/RwkPL4SQjdixuTljHnUDzhWPp4234FF2Q5TXu9JGdJTmICXPvCEB2R5LVgibkj
         4pYWi0MuqTqDwss2szvhNde4ZocQ/1aiz4WGWAifLDdsWXXBNvIm2ZAuJqPARr2AQv8i
         ahxfghwCHM4lwX9ear55rCzwOOE+LQSBRKyS1azOUilaDnsi/K14LB7ypRLVCqzLiUaF
         i/VtDmKnP2k9aVDr3rPo3rClm8TQ1g9eIIgemoiMJvXJHbuZ9OEDMVnbtke3VsWLwtf7
         V6xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iwGMJ3atf52D3UJ+iV0PYj51AJ7HOOV59IlkEIgFlvs=;
        b=mHi0CeTNgvr450yKkW3Zs76/4XXcH8CmxqClIdOL1tGvsWeFK4jMmgYGid0EAec/vt
         G/BBYQ6+1ANTvRnGr9OzAS1GcdAha1DWi/EJ/rI1mvYOfk6X2N+9bEKGpB7tkW3snrwj
         3yY6YGKQNs44Rg86QNWzUgEEaikDZCBPwfwhzX23oYTlq7E2aPSx1PzR5PlTiUaH4JHy
         HLm33msgJFDcRz9VsgjRGfX9QD/kU049PdchqihXUqhwyGCpSVewh+COCVNPcsmvroti
         9UxkbYxiL0ThKzeIwXqlaffNqhF2Jfo/b2zm16oSVZPIPW0UW6PJII7PIwewKmdO/9W5
         6QCw==
X-Gm-Message-State: AGi0PuY9S38yOM0DZxsVi+BmbqdLrMO2goN7PePjCiIQQAfk/SJ14P1+
        WfvQ3qYBoR9m9G+GoQ/MMKtOVpDu
X-Google-Smtp-Source: APiQypJ9QBZ/zFuFRlJyi2lC9tZGSSLHdykCtriDR2xe9V06oEpVjemClkqN3blZOvr0hTwEo+kZqg==
X-Received: by 2002:adf:82f5:: with SMTP id 108mr964561wrc.43.1588289238808;
        Thu, 30 Apr 2020 16:27:18 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t8sm1708463wrq.88.2020.04.30.16.27.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Apr 2020 16:27:18 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next] net: bcmgenet: Move wake-up event out of side band ISR
Date:   Thu, 30 Apr 2020 16:26:51 -0700
Message-Id: <1588289211-26190-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The side band interrupt service routine is not available on chips
like 7211, or rather, it does not permit the signaling of wake-up
events due to the complex interrupt hierarchy.

Move the wake-up event accounting into a .resume_noirq function,
account for possible wake-up events and clear the MPD/HFB interrupts
from there, while leaving the hardware untouched until the resume
function proceeds with doing its usual business.

Because bcmgenet_wol_power_down_cfg() now enables the MPD and HFB
interrupts, it is invoked by a .suspend_noirq function to prevent
the servicing of interrupts after the clocks have been disabled.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 72 ++++++++++++++++++----
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  2 +
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  6 ++
 3 files changed, 67 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index ad614d7201bd..ff31da0ed846 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3270,10 +3270,7 @@ static irqreturn_t bcmgenet_isr0(int irq, void *dev_id)
 
 static irqreturn_t bcmgenet_wol_isr(int irq, void *dev_id)
 {
-	struct bcmgenet_priv *priv = dev_id;
-
-	pm_wakeup_event(&priv->pdev->dev, 0);
-
+	/* Acknowledge the interrupt */
 	return IRQ_HANDLED;
 }
 
@@ -4174,13 +4171,12 @@ static void bcmgenet_shutdown(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int bcmgenet_resume(struct device *d)
+static int bcmgenet_resume_noirq(struct device *d)
 {
 	struct net_device *dev = dev_get_drvdata(d);
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	unsigned long dma_ctrl;
-	u32 offset, reg;
 	int ret;
+	u32 reg;
 
 	if (!netif_running(dev))
 		return 0;
@@ -4190,6 +4186,34 @@ static int bcmgenet_resume(struct device *d)
 	if (ret)
 		return ret;
 
+	if (device_may_wakeup(d) && priv->wolopts) {
+		/* Account for Wake-on-LAN events and clear those events
+		 * (Some devices need more time between enabling the clocks
+		 *  and the interrupt register reflecting the wake event so
+		 *  read the register twice)
+		 */
+		reg = bcmgenet_intrl2_0_readl(priv, INTRL2_CPU_STAT);
+		reg = bcmgenet_intrl2_0_readl(priv, INTRL2_CPU_STAT);
+		if (reg & UMAC_IRQ_WAKE_EVENT)
+			pm_wakeup_event(&priv->pdev->dev, 0);
+	}
+
+	bcmgenet_intrl2_0_writel(priv, UMAC_IRQ_WAKE_EVENT, INTRL2_CPU_CLEAR);
+
+	return 0;
+}
+
+static int bcmgenet_resume(struct device *d)
+{
+	struct net_device *dev = dev_get_drvdata(d);
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	unsigned long dma_ctrl;
+	u32 offset, reg;
+	int ret;
+
+	if (!netif_running(dev))
+		return 0;
+
 	/* From WOL-enabled suspend, switch to regular clock */
 	if (device_may_wakeup(d) && priv->wolopts)
 		bcmgenet_power_up(priv, GENET_POWER_WOL_MAGIC);
@@ -4262,7 +4286,6 @@ static int bcmgenet_suspend(struct device *d)
 {
 	struct net_device *dev = dev_get_drvdata(d);
 	struct bcmgenet_priv *priv = netdev_priv(dev);
-	int ret = 0;
 	u32 offset;
 
 	if (!netif_running(dev))
@@ -4282,23 +4305,46 @@ static int bcmgenet_suspend(struct device *d)
 	priv->hfb_en[2] = bcmgenet_hfb_reg_readl(priv, offset + sizeof(u32));
 	bcmgenet_hfb_reg_writel(priv, 0, HFB_CTRL);
 
+	return 0;
+}
+
+static int bcmgenet_suspend_noirq(struct device *d)
+{
+	struct net_device *dev = dev_get_drvdata(d);
+	struct bcmgenet_priv *priv = netdev_priv(dev);
+	int ret = 0;
+
+	if (!netif_running(dev))
+		return 0;
+
 	/* Prepare the device for Wake-on-LAN and switch to the slow clock */
 	if (device_may_wakeup(d) && priv->wolopts)
 		ret = bcmgenet_power_down(priv, GENET_POWER_WOL_MAGIC);
 	else if (priv->internal_phy)
 		ret = bcmgenet_power_down(priv, GENET_POWER_PASSIVE);
 
+	/* Let the framework handle resumption and leave the clocks on */
+	if (ret)
+		return ret;
+
 	/* Turn off the clocks */
 	clk_disable_unprepare(priv->clk);
 
-	if (ret)
-		bcmgenet_resume(d);
-
-	return ret;
+	return 0;
 }
+#else
+#define bcmgenet_suspend	NULL
+#define bcmgenet_suspend_noirq	NULL
+#define bcmgenet_resume		NULL
+#define bcmgenet_resume_noirq	NULL
 #endif /* CONFIG_PM_SLEEP */
 
-static SIMPLE_DEV_PM_OPS(bcmgenet_pm_ops, bcmgenet_suspend, bcmgenet_resume);
+static const struct dev_pm_ops bcmgenet_pm_ops = {
+	.suspend	= bcmgenet_suspend,
+	.suspend_noirq	= bcmgenet_suspend_noirq,
+	.resume		= bcmgenet_resume,
+	.resume_noirq	= bcmgenet_resume_noirq,
+};
 
 static const struct acpi_device_id genet_acpi_match[] = {
 	{ "BCM6E4E", (kernel_ulong_t)&bcm2711_plat_data },
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 031d91f45067..a12cb59298f4 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -312,6 +312,8 @@ struct bcmgenet_mib_counters {
 #define UMAC_IRQ_HFB_SM			(1 << 10)
 #define UMAC_IRQ_HFB_MM			(1 << 11)
 #define UMAC_IRQ_MPD_R			(1 << 12)
+#define UMAC_IRQ_WAKE_EVENT		(UMAC_IRQ_HFB_SM | UMAC_IRQ_HFB_MM | \
+					 UMAC_IRQ_MPD_R)
 #define UMAC_IRQ_RXDMA_MBDONE		(1 << 13)
 #define UMAC_IRQ_RXDMA_PDONE		(1 << 14)
 #define UMAC_IRQ_RXDMA_BDONE		(1 << 15)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 4b9d65f392c2..4ea6a26b04f7 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -193,6 +193,12 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
 		bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
 	}
 
+	reg = UMAC_IRQ_MPD_R;
+	if (hfb_enable)
+		reg |=  UMAC_IRQ_HFB_SM | UMAC_IRQ_HFB_MM;
+
+	bcmgenet_intrl2_0_writel(priv, reg, INTRL2_CPU_MASK_CLEAR);
+
 	return 0;
 }
 
-- 
2.7.4

