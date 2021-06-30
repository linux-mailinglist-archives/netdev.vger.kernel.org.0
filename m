Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421F53B8822
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhF3SF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhF3SF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 14:05:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A896C061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 11:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DYeJRfcLwP79IVlHhpsRNSaeMYp1wqZGjmyWMzdDy+g=; b=a5I9/gNdOb66sTOWJ5ngPQYfj
        zJm9Z2KVfpJwvKYadBtabk1Kb061RLnade0plHRYO6D0wZBAkoExFwhtW0ssjiPBY9Cczz8y8UMiL
        qQ7YF/cxZknYK0bO6HiISbIH2sbe4KVHxoU/BfE2xEIo5lkpLzZW1eYmNOe/WqYLt3GltCjfolwin
        oqLUuSTD83Yo4m9MOBAp4JlUT4UoWtXQkv375JYtrUHAKf/VfZFCKdMx5b09bQiB1LiFTidbOLGKn
        NRnneW8VWgkLbNrJgFy94Hq/C9WQ/QaIALhAf2mPJUKsm1tAQ+5zyx5bDH6FJqu6s50hXxk5E1WxS
        HBUJt9ilQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45554)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lyeY2-0000MQ-34; Wed, 30 Jun 2021 19:02:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lyeXz-0003Jg-Mw; Wed, 30 Jun 2021 19:02:51 +0100
Date:   Wed, 30 Jun 2021 19:02:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: Support disabling autonegotiation
 for PCS
Message-ID: <20210630180251.GG22278@shell.armlinux.org.uk>
References: <20210630174927.1077249-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630174927.1077249-1-robert.hancock@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 11:49:27AM -0600, Robert Hancock wrote:
> The auto-negotiation state in the PCS as set by
> phylink_mii_c22_pcs_config was previously always enabled when the driver is
> configured for in-band autonegotiation, even if autonegotiation was
> disabled on the interface with ethtool. Update the code to set the
> BMCR_ANENABLE bit based on the interface's autonegotiation enabled
> state.
> 
> Update phylink_mii_c22_pcs_get_state to not check
> autonegotiation-related fields when autonegotiation is disabled.
> 
> Update phylink_mac_pcs_get_state to initialize the state based on the
> interface's configured speed, duplex and pause parameters rather than to
> unknown when autonegotiation is disabled, before calling the driver's
> pcs_get_state functions, as they are not likely to provide meaningful data
> for these fields when autonegotiation is disabled. In this case the
> driver is really just filling in the link state field.
> 
> Note that in cases where there is a downstream PHY connected, such as
> with SGMII and a copper PHY, the configuration set by ethtool is handled by
> phy_ethtool_ksettings_set and not propagated to the PCS. This is correct
> since SGMII or 1000Base-X autonegotiation with the PCS should normally
> still be used even if the copper side has disabled it.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

I definitely want to think about this _before_ it gets applied to
net-next. It's a substantial change, not a "fix" or something simple.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
