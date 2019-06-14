Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3873145A82
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfFNKh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:37:57 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35676 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfFNKh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 06:37:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uXgsz32ivq+plCnT+UmeOHUjXq2RjXGmYaSwEWMrB4g=; b=o8ec0GNJ9lFPF9A4H0fJ2y3a7
        Y23Jp3PL/dJFU9dfr7UURz9bP8rI2moAFJ/k98rS23/gxf1/x0r41zT3Ku+cMtRWCwPlXK4DqAG8w
        yHEKXl41+d7V8oFVqeLZZ3mbTVmp1J6Rk5PPfgSLnwdFuBYBXVKOF8/pSfdDkMNvggmjahch/2XpC
        zVvyiwRIr45vMUrJbkCSqMk3qZa+BD6UjTwVfw7WxYzbDJALVgDJptM+ghxRyLlO4nIDqmjLnf130
        MzLeCmN9p28U4AUn+tQdF+QBAJ/zcXG2RoClTGyUV1R8DLND2MQRemlIIutaPrXGgS5f/X1Qwq4yA
        9/CgcT8/g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53044)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hbjah-0000oz-Gl; Fri, 14 Jun 2019 11:37:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hbjaf-00029Y-F9; Fri, 14 Jun 2019 11:37:49 +0100
Date:   Fri, 14 Jun 2019 11:37:49 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] net: phylink: further mac_config documentation
 improvements
Message-ID: <20190614103749.s6pahlazm4hqyurg@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reviewing the DPAA2 work, it has become apparent that we need
better documentation about which members of the phylink link state
structure are valid in the mac_config call.  Improve this
documentation.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 include/linux/phylink.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6411c624f63a..ca74f4e343c6 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -123,11 +123,20 @@ int mac_link_state(struct net_device *ndev,
  * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
  * @state: a pointer to a &struct phylink_link_state.
  *
+ * Note - not all members of @state are valid.  In particular,
+ * @state->lp_advertising, @state->link, @state->an_complete are never
+ * guaranteed to be correct, and so any mac_config() implementation must
+ * never reference these fields.
+ *
  * The action performed depends on the currently selected mode:
  *
  * %MLO_AN_FIXED, %MLO_AN_PHY:
  *   Configure the specified @state->speed, @state->duplex and
- *   @state->pause (%MLO_PAUSE_TX / %MLO_PAUSE_RX) mode.
+ *   @state->pause (%MLO_PAUSE_TX / %MLO_PAUSE_RX) modes over a link
+ *   specified by @state->interface.  @state->advertising may be used,
+ *   but is not required.  Other members of @state must be ignored.
+ *
+ *   Valid state members: interface, speed, duplex, pause, advertising.
  *
  * %MLO_AN_INBAND:
  *   place the link in an inband negotiation mode (such as 802.3z
@@ -150,6 +159,8 @@ int mac_link_state(struct net_device *ndev,
  *   responsible for reading the configuration word and configuring
  *   itself accordingly.
  *
+ *   Valid state members: interface, an_enabled, pause, advertising.
+ *
  * Implementations are expected to update the MAC to reflect the
  * requested settings - i.o.w., if nothing has changed between two
  * calls, no action is expected.  If only flow control settings have
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
