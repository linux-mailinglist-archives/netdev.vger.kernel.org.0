Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9540A25B0E6
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIBQMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728472AbgIBQLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:11:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD7CC061247
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 09:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IWwKGSqEdbycyXBN1bosZihtk5i0CXGSLJ7ujDN1E/4=; b=ltdQLWb2rnScE9ZiNW9gDi/pnU
        JJyiSSVogQTVKUAZXnAUDFhpb4VRuN/9X4d0opEHgbqjTxX3TCeK2ZtrivIKks50LwPXu5uSdCOzg
        b3ToLbh6LN1I1RpzoOHSIPqu3icsDQBJl6NCMxR7nZdleM7QF54I4Mz1KP51anJqLK7LYqDwUTtIO
        NtFaOK0cYwBbBxOeLsoqbzW49I4rQ80Q6ozS1VE9dAjgHJthHeK64YPghWQMucBYbyQN3qed1AqM3
        VfZDWYeMxE88WZSn9d9bv5/iBhvZ8p9otUQdurXf1VXf6WwkVPkSW0IEdjCJMG+n2z609qx8Wifqj
        iUCpunvA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45136 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kDVMR-0004wo-1o; Wed, 02 Sep 2020 17:11:47 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kDVMQ-0000jX-D8; Wed, 02 Sep 2020 17:11:46 +0100
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
Subject: [PATCH net-next 3/7] net: mvpp2: check first level interrupt status
 registers
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kDVMQ-0000jX-D8@rmk-PC.armlinux.org.uk>
Date:   Wed, 02 Sep 2020 17:11:46 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check the first level interrupt status registers to determine how to
further process the port interrupt. We will need this to know whether
to invoke the link status processing and/or the PTP processing for
both XLG and GMAC.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  4 ++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 13 +++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index a2f787c83756..273c46bbf927 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -461,6 +461,8 @@
 #define     MVPP22_CTRL4_DP_CLK_SEL		BIT(5)
 #define     MVPP22_CTRL4_SYNC_BYPASS_DIS	BIT(6)
 #define     MVPP22_CTRL4_QSGMII_BYPASS_ACTIVE	BIT(7)
+#define MVPP22_GMAC_INT_SUM_STAT		0xa0
+#define	    MVPP22_GMAC_INT_SUM_STAT_INTERNAL	BIT(1)
 #define MVPP22_GMAC_INT_SUM_MASK		0xa4
 #define     MVPP22_GMAC_INT_SUM_MASK_LINK_STAT	BIT(1)
 
@@ -488,6 +490,8 @@
 #define     MVPP22_XLG_CTRL3_MACMODESELECT_MASK	(7 << 13)
 #define     MVPP22_XLG_CTRL3_MACMODESELECT_GMAC	(0 << 13)
 #define     MVPP22_XLG_CTRL3_MACMODESELECT_10G	(1 << 13)
+#define MVPP22_XLG_EXT_INT_STAT			0x158
+#define     MVPP22_XLG_EXT_INT_STAT_XLG		BIT(1)
 #define MVPP22_XLG_EXT_INT_MASK			0x15c
 #define     MVPP22_XLG_EXT_INT_MASK_XLG		BIT(1)
 #define     MVPP22_XLG_EXT_INT_MASK_GIG		BIT(2)
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 41ffae8d5357..9dc8cf3d0873 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3039,14 +3039,23 @@ static void mvpp2_isr_handle_gmac_internal(struct mvpp2_port *port)
 static irqreturn_t mvpp2_port_isr(int irq, void *dev_id)
 {
 	struct mvpp2_port *port = (struct mvpp2_port *)dev_id;
+	u32 val;
 
 	mvpp22_gop_mask_irq(port);
 
 	if (mvpp2_port_supports_xlg(port) &&
 	    mvpp2_is_xlg(port->phy_interface)) {
-		mvpp2_isr_handle_xlg(port);
+		/* Check the external status register */
+		val = readl(port->base + MVPP22_XLG_EXT_INT_STAT);
+		if (val & MVPP22_XLG_EXT_INT_STAT_XLG)
+			mvpp2_isr_handle_xlg(port);
 	} else {
-		mvpp2_isr_handle_gmac_internal(port);
+		/* If it's not the XLG, we must be using the GMAC.
+		 * Check the summary status.
+		 */
+		val = readl(port->base + MVPP22_GMAC_INT_SUM_STAT);
+		if (val & MVPP22_GMAC_INT_SUM_STAT_INTERNAL)
+			mvpp2_isr_handle_gmac_internal(port);
 	}
 
 	mvpp22_gop_unmask_irq(port);
-- 
2.20.1

