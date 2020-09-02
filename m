Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2922725B0E5
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgIBQMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgIBQMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:12:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7D8C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 09:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yy7YyyKSTz7qaxBtSbTBwetw0srqJ12M3uu0VPMnEF0=; b=eakvqaJsKq7TZZQ3ysDOFkxa4I
        nHEQkrlwJhVO9tYULbpfCjMHTSao7iRhH2/QXCrf4imJlmOB+8FZFPHHO0xupmpKzc/pecJ9epgFt
        hy8Fr/zGipYGSK8c+ZEOWSSpJMRGT4Q3u0gXzgXBgFBq4dosndGUbCZ6HPTeZGkH53J0WSD15kEbu
        Jim6NrRyPt7aSjnPsYAUiEZRNQ4Jx47M+fMoH1IXYZ7gU3YdoyhdJAhARiSwn307rXEYP/4HdqzJA
        vK0nj8Be0kY3UJVf3z8b5X1LfRhCvt6LU2vXvBcWKLmOnG0wXm/35BNUGqZh7tDr2997q0El+tOxy
        hiKjM/pw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45142 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kDVMg-0004xV-DS; Wed, 02 Sep 2020 17:12:02 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kDVMg-0000k9-6g; Wed, 02 Sep 2020 17:12:02 +0100
In-Reply-To: <20200902161007.GN1551@shell.armlinux.org.uk>
References: <20200902161007.GN1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 6/7] net: mvpp2: ptp: add interrupt handling
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kDVMg-0000k9-6g@rmk-PC.armlinux.org.uk>
Date:   Wed, 02 Sep 2020 17:12:02 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PTP interrupt handling infrastructure, which is used to read the
transmit timestamps from two hardware queues.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  8 ++++
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 44 +++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 75467411900e..50956551b336 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -463,8 +463,10 @@
 #define     MVPP22_CTRL4_QSGMII_BYPASS_ACTIVE	BIT(7)
 #define MVPP22_GMAC_INT_SUM_STAT		0xa0
 #define	    MVPP22_GMAC_INT_SUM_STAT_INTERNAL	BIT(1)
+#define	    MVPP22_GMAC_INT_SUM_STAT_PTP	BIT(2)
 #define MVPP22_GMAC_INT_SUM_MASK		0xa4
 #define     MVPP22_GMAC_INT_SUM_MASK_LINK_STAT	BIT(1)
+#define	    MVPP22_GMAC_INT_SUM_MASK_PTP	BIT(2)
 
 /* Per-port XGMAC registers. PPv2.2 only, only for GOP port 0,
  * relative to port->base.
@@ -492,9 +494,11 @@
 #define     MVPP22_XLG_CTRL3_MACMODESELECT_10G	(1 << 13)
 #define MVPP22_XLG_EXT_INT_STAT			0x158
 #define     MVPP22_XLG_EXT_INT_STAT_XLG		BIT(1)
+#define     MVPP22_XLG_EXT_INT_STAT_PTP		BIT(7)
 #define MVPP22_XLG_EXT_INT_MASK			0x15c
 #define     MVPP22_XLG_EXT_INT_MASK_XLG		BIT(1)
 #define     MVPP22_XLG_EXT_INT_MASK_GIG		BIT(2)
+#define     MVPP22_XLG_EXT_INT_MASK_PTP		BIT(7)
 #define MVPP22_XLG_CTRL4_REG			0x184
 #define     MVPP22_XLG_CTRL4_FWD_FC		BIT(5)
 #define     MVPP22_XLG_CTRL4_FWD_PFC		BIT(6)
@@ -598,7 +602,11 @@
 /* PTP registers. PPv2.2 only */
 #define MVPP22_PTP_BASE(port)			(0x7800 + (port * 0x1000))
 #define MVPP22_PTP_INT_CAUSE			0x00
+#define     MVPP22_PTP_INT_CAUSE_QUEUE1		BIT(6)
+#define     MVPP22_PTP_INT_CAUSE_QUEUE0		BIT(5)
 #define MVPP22_PTP_INT_MASK			0x04
+#define     MVPP22_PTP_INT_MASK_QUEUE1		BIT(6)
+#define     MVPP22_PTP_INT_MASK_QUEUE0		BIT(5)
 #define MVPP22_PTP_GCR				0x08
 #define     MVPP22_PTP_GCR_RX_RESET		BIT(13)
 #define     MVPP22_PTP_GCR_TX_RESET		BIT(1)
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index c20fde0fc73c..f3148e033bfe 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1379,6 +1379,10 @@ static void mvpp22_gop_setup_irq(struct mvpp2_port *port)
 {
 	u32 val;
 
+	mvpp2_modify(port->base + MVPP22_GMAC_INT_SUM_MASK,
+		     MVPP22_GMAC_INT_SUM_MASK_PTP,
+		     MVPP22_GMAC_INT_SUM_MASK_PTP);
+
 	if (port->phylink ||
 	    phy_interface_mode_is_rgmii(port->phy_interface) ||
 	    phy_interface_mode_is_8023z(port->phy_interface) ||
@@ -1392,6 +1396,10 @@ static void mvpp22_gop_setup_irq(struct mvpp2_port *port)
 		val = readl(port->base + MVPP22_XLG_INT_MASK);
 		val |= MVPP22_XLG_INT_MASK_LINK;
 		writel(val, port->base + MVPP22_XLG_INT_MASK);
+
+		mvpp2_modify(port->base + MVPP22_XLG_EXT_INT_MASK,
+			     MVPP22_XLG_EXT_INT_MASK_PTP,
+			     MVPP22_XLG_EXT_INT_MASK_PTP);
 	}
 
 	mvpp22_gop_unmask_irq(port);
@@ -2974,6 +2982,38 @@ static irqreturn_t mvpp2_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void mvpp2_isr_handle_ptp_queue(struct mvpp2_port *port, int nq)
+{
+	void __iomem *ptp_q;
+	u32 r0, r1, r2;
+
+	ptp_q = port->priv->iface_base + MVPP22_PTP_BASE(port->gop_id);
+	if (nq)
+		ptp_q += MVPP22_PTP_TX_Q1_R0 - MVPP22_PTP_TX_Q0_R0;
+
+	while (1) {
+		r0 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R0) & 0xffff;
+		if (!r0)
+			break;
+
+		r1 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R1) & 0xffff;
+		r2 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R2) & 0xffff;
+	}
+}
+
+static void mvpp2_isr_handle_ptp(struct mvpp2_port *port)
+{
+	void __iomem *ptp;
+	u32 val;
+
+	ptp = port->priv->iface_base + MVPP22_PTP_BASE(port->gop_id);
+	val = readl(ptp + MVPP22_PTP_INT_CAUSE);
+	if (val & MVPP22_PTP_INT_CAUSE_QUEUE0)
+		mvpp2_isr_handle_ptp_queue(port, 0);
+	if (val & MVPP22_PTP_INT_CAUSE_QUEUE1)
+		mvpp2_isr_handle_ptp_queue(port, 1);
+}
+
 static void mvpp2_isr_handle_link(struct mvpp2_port *port, bool link)
 {
 	struct net_device *dev = port->dev;
@@ -3049,6 +3089,8 @@ static irqreturn_t mvpp2_port_isr(int irq, void *dev_id)
 		val = readl(port->base + MVPP22_XLG_EXT_INT_STAT);
 		if (val & MVPP22_XLG_EXT_INT_STAT_XLG)
 			mvpp2_isr_handle_xlg(port);
+		if (val & MVPP22_XLG_EXT_INT_STAT_PTP)
+			mvpp2_isr_handle_ptp(port);
 	} else {
 		/* If it's not the XLG, we must be using the GMAC.
 		 * Check the summary status.
@@ -3056,6 +3098,8 @@ static irqreturn_t mvpp2_port_isr(int irq, void *dev_id)
 		val = readl(port->base + MVPP22_GMAC_INT_SUM_STAT);
 		if (val & MVPP22_GMAC_INT_SUM_STAT_INTERNAL)
 			mvpp2_isr_handle_gmac_internal(port);
+		if (val & MVPP22_GMAC_INT_SUM_STAT_PTP)
+			mvpp2_isr_handle_ptp(port);
 	}
 
 	mvpp22_gop_unmask_irq(port);
-- 
2.20.1

