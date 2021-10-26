Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF25643AFB5
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbhJZKIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbhJZKIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 06:08:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA505C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 03:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k12oGGo7fj3rCB2JV0kMNUgWOdQCV+sWY4aIqmStjlo=; b=t7WjK2guc6JquC2B6L+iOUitdf
        Y7/86jKK0E576MKgNgEFkmwEpJH3iRclHqWNAIrjvSQUZMMiEeb66mmYxv1FQFw6mwJIVsc53Dq2N
        umu9xJezXjGaTomJp8mV8H0F1gAEPFKBC1LMj6p92fIM5eBn+zvgRT1BCcRGf3i3tlkrj7otPNDyi
        XRMqF6S7n2uRpgPyqaTGyzU6twDzuDhxx88jYykoLpyb3CECC36bTH5qoZgEGPcEBYGAF13NB1rlK
        qTU+HjzW1bo4td/OG9iCvW87OFr+Dmd3j4ZfDNt8sX7XilvWmB0YcJeCHtD7Ueoplv6Lsr1jsNi1k
        jQJW8/Lw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53002 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfJLQ-0005D7-Bg; Tue, 26 Oct 2021 11:06:12 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfJLP-001KXZ-SI; Tue, 26 Oct 2021 11:06:11 +0100
In-Reply-To: <YXfS8K/7c14UFIyq@shell.armlinux.org.uk>
References: <YXfS8K/7c14UFIyq@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] net: phylink: use supported_interfaces for
 phylink validation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mfJLP-001KXZ-SI@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 26 Oct 2021 11:06:11 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the network device supplies a supported interface bitmap, we can use
that during phylink's validation to simplify MAC drivers in two ways by
using the supported_interfaces bitmap to:

1. reject unsupported interfaces before calling into the MAC driver.
2. generate the set of all supported link modes across all supported
   interfaces (used mainly for SFP, but also some 10G PHYs.)

Suggested-by: Sean Anderson <sean.anderson@seco.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   | 12 ++++++++++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 14c7d73790b4..6da245dacca4 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -166,9 +166,45 @@ static const char *phylink_an_mode_str(unsigned int mode)
 	return mode < ARRAY_SIZE(modestr) ? modestr[mode] : "unknown";
 }
 
+static int phylink_validate_any(struct phylink *pl, unsigned long *supported,
+				struct phylink_link_state *state)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(all_adv) = { 0, };
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(all_s) = { 0, };
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(s);
+	struct phylink_link_state t;
+	int intf;
+
+	for (intf = 0; intf < PHY_INTERFACE_MODE_MAX; intf++) {
+		if (test_bit(intf, pl->config->supported_interfaces)) {
+			linkmode_copy(s, supported);
+
+			t = *state;
+			t.interface = intf;
+			pl->mac_ops->validate(pl->config, s, &t);
+			linkmode_or(all_s, all_s, s);
+			linkmode_or(all_adv, all_adv, t.advertising);
+		}
+	}
+
+	linkmode_copy(supported, all_s);
+	linkmode_copy(state->advertising, all_adv);
+
+	return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
+}
+
 static int phylink_validate(struct phylink *pl, unsigned long *supported,
 			    struct phylink_link_state *state)
 {
+	if (!phy_interface_empty(pl->config->supported_interfaces)) {
+		if (state->interface == PHY_INTERFACE_MODE_NA)
+			return phylink_validate_any(pl, supported, state);
+
+		if (!test_bit(state->interface,
+			      pl->config->supported_interfaces))
+			return -EINVAL;
+	}
+
 	pl->mac_ops->validate(pl->config, supported, state);
 
 	return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index bc4b866cd99b..f037470b6fb3 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -67,6 +67,8 @@ enum phylink_op_type {
  * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
  * @get_fixed_state: callback to execute to determine the fixed link state,
  *		     if MAC link is at %MLO_AN_FIXED mode.
+ * @supported_interfaces: bitmap describing which PHY_INTERFACE_MODE_xxx
+ *                        are supported by the MAC/PCS.
  */
 struct phylink_config {
 	struct device *dev;
@@ -134,8 +136,14 @@ struct phylink_mac_ops {
  * based on @state->advertising and/or @state->speed and update
  * @state->interface accordingly. See phylink_helper_basex_speed().
  *
- * When @state->interface is %PHY_INTERFACE_MODE_NA, phylink expects the
- * MAC driver to return all supported link modes.
+ * When @config->supported_interfaces has been set, phylink will iterate
+ * over the supported interfaces to determine the full capability of the
+ * MAC. The validation function must not print errors if @state->interface
+ * is set to an unexpected value.
+ *
+ * When @config->supported_interfaces is empty, phylink will call this
+ * function with @state->interface set to %PHY_INTERFACE_MODE_NA, and
+ * expects the MAC driver to return all supported link modes.
  *
  * If the @state->interface mode is not supported, then the @supported
  * mask must be cleared.
-- 
2.30.2

