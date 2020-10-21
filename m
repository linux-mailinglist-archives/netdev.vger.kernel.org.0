Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4067294A8F
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 11:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437778AbgJUJbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 05:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391228AbgJUJbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 05:31:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29258C0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 02:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BmRfw/C65jo5cRCkZXJr4KlhRbn/yU1/lj/vnXnK5UY=; b=G86Ly8dVXzutPuho+J5lqYMKO
        D1kfB5bjjEbT8NLVeeCTj3S+Wpuqg/IsXBHAjxSeC2MMPsG6eVRZ/6cvyHQ7fgm+rNWcOPmJQFfMR
        9lLwdmoy5sFdmOhtYAM8Xu1bjBf1l5WYh9SBeiThq4nzhN72DLeU5lYzPR+eL7gwRqWw3TH6VVlda
        +Kah+y4fxhTs1Lclelb6cV90ePmttjyHZDWe1XcooMjB3gGeWst+YDOfk1F8rJrfGgRc6mn9rc4ky
        bKz23+M9gIUXZjZqTfeHqwI+Bq4nzwYBT5ijwFbIA7zbLvSlbpe0/Ev0VWebaiDrgoTZxhranpjWV
        w6KTh95xQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49038)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kVASU-0000KU-LA; Wed, 21 Oct 2020 10:31:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kVASS-0006Gi-81; Wed, 21 Oct 2020 10:31:00 +0100
Date:   Wed, 21 Oct 2020 10:31:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] net: phy: marvell: add special handling of Finisar
 modules with 88E1111
Message-ID: <20201021093100.GJ1551@shell.armlinux.org.uk>
References: <20201021001821.783249-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021001821.783249-1-robert.hancock@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 06:18:21PM -0600, Robert Hancock wrote:
> The Finisar FCLF8520P2BTL 1000BaseT SFP module uses a Marvel 88E1111 PHY
> with a modified PHY ID. Add support for this ID using the 88E1111
> methods.
> 
> By default these modules do not have 1000BaseX auto-negotiation enabled,
> which is not generally desirable with Linux networking drivers. Add
> handling to enable 1000BaseX auto-negotiation when these modules are
> used in 1000BaseX mode. Also, some special handling is required to ensure
> that 1000BaseT auto-negotiation is enabled properly when desired.
> 
> Based on existing handling in the AMD xgbe driver and the information in
> the Finisar FAQ:
> https://www.finisar.com/sites/default/files/resources/an-2036_1000base-t_sfp_faqreve1.pdf
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

One minor issue remains - sorry I didn't spot it last time.  Feel free
to fix that and retain the reviewed by above, no need for an immediate
v4 posting

Please resend when net-next is open, thanks.

> @@ -629,6 +632,51 @@ static int marvell_config_aneg_fiber(struct phy_device *phydev)
>  	return genphy_check_and_restart_aneg(phydev, changed);
>  }
>  
> +static int m88e1111_config_aneg(struct phy_device *phydev)
> +{
> +	int err;
> +	int extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);

This should be in reverse christmas tree order.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
