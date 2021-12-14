Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1E6474582
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbhLNOsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbhLNOsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:48:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951FBC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 06:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=a7DJN/RTbGnJW9axHNFqsotQAyXk9gZdKzXdxz+Mg1M=; b=lpBs/br7J8uhpIc8JzGICQaYlk
        Ac9rI4v9UnNls1N/XlBGCHn/zl85y9xaqyR/ecv4SQtk5vk8tIvkhQ0kuOg8MjlWub3pf1ZdlYHc1
        hPm/+rE9NCs0F8r98vG83pMsprFsOalyApsLJfjneYSn6mbHRfiGuS7R3ZjUW4EzWsmFQZRC4M5HH
        FwSSD1IIvnhUGf9dPNYFa9myIEK5KLUaZmqsqFL9Nr9tVfgPe2Dn7+KjFTHn1rr73e7Wp6Q+Ercmu
        cMPBW+cuqlgpuYzKEqeaLVk7koBCsmFWODIXz4mgf3jgCSRQT+B2z6Gy/Mf0c5jSSyoMQ08NqvDL4
        EG/91HZw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60484 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mx96A-00054P-SA; Tue, 14 Dec 2021 14:48:10 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mx96A-00GCdF-Ei; Tue, 14 Dec 2021 14:48:10 +0000
In-Reply-To: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
References: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next 2/7] net: phylink: add pcs_validate() method
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mx96A-00GCdF-Ei@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 14 Dec 2021 14:48:10 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a hook for PCS to validate the link parameters. This avoids MAC
drivers having to have knowledge of their PCS in their validate()
method, thereby allowing several MAC drivers to be simplfied.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 31 +++++++++++++++++++++++++++++++
 include/linux/phylink.h   | 20 ++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index c7035d65e159..420201858564 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -424,13 +424,44 @@ static int phylink_validate_mac_and_pcs(struct phylink *pl,
 					struct phylink_link_state *state)
 {
 	struct phylink_pcs *pcs;
+	int ret;
 
+	/* Get the PCS for this interface mode */
 	if (pl->mac_ops->mac_select_pcs) {
 		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
 		if (IS_ERR(pcs))
 			return PTR_ERR(pcs);
+	} else {
+		pcs = pl->pcs;
+	}
+
+	if (pcs) {
+		/* The PCS, if present, must be setup before phylink_create()
+		 * has been called. If the ops is not initialised, print an
+		 * error and backtrace rather than oopsing the kernel.
+		 */
+		if (!pcs->ops) {
+			phylink_err(pl, "interface %s: uninitialised PCS\n",
+				    phy_modes(state->interface));
+			dump_stack();
+			return -EINVAL;
+		}
+
+		/* Validate the link parameters with the PCS */
+		if (pcs->ops->pcs_validate) {
+			ret = pcs->ops->pcs_validate(pcs, supported, state);
+			if (ret < 0 || phylink_is_empty_linkmode(supported))
+				return -EINVAL;
+
+			/* Ensure the advertising mask is a subset of the
+			 * supported mask.
+			 */
+			linkmode_and(state->advertising, state->advertising,
+				     supported);
+		}
 	}
 
+	/* Then validate the link parameters with the MAC */
 	pl->mac_ops->validate(pl->config, supported, state);
 
 	return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index f44b33cddc4d..381edda618d8 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -416,6 +416,7 @@ struct phylink_pcs {
 
 /**
  * struct phylink_pcs_ops - MAC PCS operations structure.
+ * @pcs_validate: validate the link configuration.
  * @pcs_get_state: read the current MAC PCS link state from the hardware.
  * @pcs_config: configure the MAC PCS for the selected mode and state.
  * @pcs_an_restart: restart 802.3z BaseX autonegotiation.
@@ -423,6 +424,8 @@ struct phylink_pcs {
  *               (where necessary).
  */
 struct phylink_pcs_ops {
+	int (*pcs_validate)(struct phylink_pcs *pcs, unsigned long *supported,
+			    const struct phylink_link_state *state);
 	void (*pcs_get_state)(struct phylink_pcs *pcs,
 			      struct phylink_link_state *state);
 	int (*pcs_config)(struct phylink_pcs *pcs, unsigned int mode,
@@ -435,6 +438,23 @@ struct phylink_pcs_ops {
 };
 
 #if 0 /* For kernel-doc purposes only. */
+/**
+ * pcs_validate() - validate the link configuration.
+ * @pcs: a pointer to a &struct phylink_pcs.
+ * @supported: ethtool bitmask for supported link modes.
+ * @state: a const pointer to a &struct phylink_link_state.
+ *
+ * Validate the interface mode, and advertising's autoneg bit, removing any
+ * media ethtool link modes that would not be supportable from the supported
+ * mask. Phylink will propagate the changes to the advertising mask. See the
+ * &struct phylink_mac_ops validate() method.
+ *
+ * Returns -EINVAL if the interface mode/autoneg mode is not supported.
+ * Returns non-zero positive if the link state can be supported.
+ */
+int pcs_validate(struct phylink_pcs *pcs, unsigned long *supported,
+		 const struct phylink_link_state *state);
+
 /**
  * pcs_get_state() - Read the current inband link state from the hardware
  * @pcs: a pointer to a &struct phylink_pcs.
-- 
2.30.2

