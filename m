Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA324C4413
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240366AbiBYMAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240369AbiBYMAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:00:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954F52782B2
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Zl13fSZrUbODfjCa52H+/YEruc6PwqqtsXH8O4FouKA=; b=rYMzcEJirhuSerewWRWeQJaVYY
        VURC8cYx0spt6vtxrThwgniqC1nsQ1LsERV0Wzak2PLJyNRjA2V+xRkUsN70q25x0sQ5Q8PxTcu8g
        U4EM4ls9kREpf/rRBenrui1LWM2YmgNqUmHVfdb0xTxiydZHO9nhec7PaC9e1E62MDaiF3/s7ZXTv
        Gun7iyuUqv/aOagNx0MUgm6Xzt/VQceC2u86J4XczXghlSxckbcEAFDCFdB+d4k3HJl7faQg74YTj
        nDGT7CJNtQWBUJGzCI6o2em6yjDbDpYjwNpkgFiLOJPLXBUyVZLFTvEfPBUHNUo7tfL8MWi3IR4zb
        kWPMwplw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57482)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNZFs-0005IY-OS; Fri, 25 Feb 2022 11:59:24 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNZFr-000321-Lt; Fri, 25 Feb 2022 11:59:23 +0000
Date:   Fri, 25 Feb 2022 11:59:23 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 0/6] net: dsa: sja1105: phylink updates
Message-ID: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series updates the phylink implementation in sja1105 to use the
supported_interfaces bitmap, convert to the mac_select_pcs() interface,
mark as non-legacy, and get rid of the validation method.

As a final step, enable switching between SGMII and 2500BASE-X as it
is a feature that Vladimir desires.

Specifically, the patches in this series:

1. Populates the supported_interfaces bitmap.
2. As a result of the supported_interfaces bitmap being populated,
   sja1105 no longer needs to check the interface mode as phylink
   will do this.
3. Switch away from using phylink_set_pcs(), using the mac_select_pcs()
   method instead.
4. Mark the driver as not-legacy
5. Fill in mac_capabilities using _exactly_ the same conditions as is
   currently used to decide which link modes to support, and convert
   to use phylink_generic_validate()
6. Add brand new support to permit switching between SGMII and
   2500BASE-X modes of operation as per Vladimir's single patch that
   performs steps 1, 2, 5 and 6 in one go.

There are some additional changes in Vladimir's single patch that I
have not included:

* validation of priv->phy_mode[] in sja1105_phylink_get_caps(). The
  driver has already validated the phy_mode for each port in
  sja1105_init_mii_settings(), and a failure here will prevent the
  driver reaching sja1105_phylink_get_caps().

* Changing the decisions on which mac_capabilities to set. Vladimir's
  patch always sets MAC_10FD | MAC_100FD | MAC_1000FD despite the
  current code clearly making the 1G speed conditional on the
  xmii_mode for the port. The change in decision making may be
  visible when in PHY_INTERFACE_MODE_INTERNAL mode, for which
  the phylink_generic_validate() will pass through all the MAC
  capabilities as ethtool link modes.

  Hence, if we have PHY_INTERFACE_MODE_INTERNAL but supports_rgmii[]
  or supports_sgmii[] is non-zero, currently we do not get 1G speeds.
  With Vladimir's additional change, we will get 1G speeds.

  While it is not clear whether that can happen, I feel changing the
  decision making should be a separate patch.

* The decision for MAC_2500FD is made differently -
  sja1105_init_mii_settings() allows PHY_INTERFACE_MODE_2500BASEX
  when supports_2500basex[] is non-zero, and is not based on any other
  condition such as supports_sgmii[] or supports_rgmii[]. Vladimir's
  patch makes it additionally conditional on those supports_.gmii[]
  settings, which is a functional change that should be made in a
  separate patch - and if desired, then sja1105_init_mii_settings()
  should also be updated at the same time.

Consequently, I believe that my previous objections to Vladimir's
single patch approach are well founded and justified, even through
Vladimir is the maintainer of this driver. I have no objection to
the additional changes, I just don't think they should all be wrapped
up into a single patch that converts the way validation is done _and_
also makes a bunch of other functional changes.

RFC->non-RFC: added Vladimir's Reviewed-by's, fixed the typo in the
commit message of patch 6, and removed the phrase at the end of a
comment as requested.

v2: fix the fscking vi fsckups when pasting in attributations.

 drivers/net/dsa/sja1105/sja1105_main.c | 100 ++++++++++++++-------------------
 1 file changed, 42 insertions(+), 58 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
