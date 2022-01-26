Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B21149C768
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbiAZK0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiAZK0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 05:26:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A0DC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 02:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=p/V5JvEJYN9rvoBvgIWPipu0NL+gRrRUBW+mG+YoDvU=; b=BQFNCKMlRw9YkHeEtNnX/EaDbi
        nEJFsDgfMZuNpv/HGUwtSVVjGuBfOzzQHyC4LHvcGvEDVjKEH2c3tTswq/uS0mY59zcSAiPdyko5z
        FpZ70yRZF/E+TwgZQxgvLTpIa2Oj1FvRmDPGV4TGTC2EDehA3cURNOen/O+glNOfSxxbPu+DARnrh
        mx/27ZplVJ0fppc89t/MhPPhC64qO2hYvTwN+uVqBqIMdTmg6RaUx2ulLX4l/7Cz/i5ZHUWhSqPhL
        LWrt0ta94hNA/rV156yqh4WUSNDG59IcilodGD5SqaR6oJwAM/RDXCQXeDKghCxH3dRZFKP5fSVdg
        9QPY97iA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35148 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nCfUx-00038I-NO; Wed, 26 Jan 2022 10:25:55 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nCfUx-005Rcu-4K; Wed, 26 Jan 2022 10:25:55 +0000
In-Reply-To: <YfEhaK7VtJ4oru03@shell.armlinux.org.uk>
References: <YfEhaK7VtJ4oru03@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/7] net: xpcs: add support for retrieving
 supported interface modes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nCfUx-005Rcu-4K@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 26 Jan 2022 10:25:55 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function to the xpcs driver to retrieve the supported PHY
interface modes, which can be used by drivers to fill in phylink's
supported_interfaces mask.

We validate the interface bit index to ensure that it fits within the
bitmap as xpcs lists PHY_INTERFACE_MODE_MAX in an entry.

Tested-by: Wong Vee Khee <vee.khee.wong@linux.intel.com> # Intel EHL            Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c   | 14 ++++++++++++++
 include/linux/pcs/pcs-xpcs.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index cd6742e6ba8b..f45821524fab 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -662,6 +662,20 @@ void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
 }
 EXPORT_SYMBOL_GPL(xpcs_validate);
 
+void xpcs_get_interfaces(struct dw_xpcs *xpcs, unsigned long *interfaces)
+{
+	int i, j;
+
+	for (i = 0; i < DW_XPCS_INTERFACE_MAX; i++) {
+		const struct xpcs_compat *compat = &xpcs->id->compat[i];
+
+		for (j = 0; j < compat->num_interfaces; j++)
+			if (compat->interface[j] < PHY_INTERFACE_MODE_MAX)
+				__set_bit(compat->interface[j], interfaces);
+	}
+}
+EXPORT_SYMBOL_GPL(xpcs_get_interfaces);
+
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns, int enable)
 {
 	int ret;
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index add077a81b21..3126a4924d92 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -33,6 +33,7 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 		   unsigned int mode);
 void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
+void xpcs_get_interfaces(struct dw_xpcs *xpcs, unsigned long *interfaces);
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
 		    int enable);
 struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
-- 
2.30.2

