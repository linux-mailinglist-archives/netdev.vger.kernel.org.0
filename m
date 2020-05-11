Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABB01CE2C9
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgEKSaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729673AbgEKSaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:30:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EBBC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+if1aZ+GBhXtvrLGnMCGFUPeuqRkfbaGoWDk5JZ3vZ8=; b=GXEIhL7pos3iTFc7Xp2y+6koO
        1MnSmfYJJAer4ZzBGoLZ6RGjcHHyKjtghJ/uxbZeXmoj76bU485uYCujjvyAsKWzf+twIUHtF7s4g
        uHw2+zDAEYtUhhrjXlAgVzf8TPMiNbkPwLwyLSCLjwpeGItIAKuSOVdKc/GWyrf8/OMuPKnfpyrls
        3eHsSFoO8R4KZ4fC0E3CoFtUR9HWzlzQaBpjgbEpwq90IGTqbn5dGAwOHwR48BhF3nGOCDgNgrn50
        /0ffWnAhLdAPGf0ddSU82Uft5ZH7ik/pxVociWjsHahZ/q5xgLR4s0m/iBQ7E3yZY/Ik/wp4qRCZ1
        LBsRgKvkw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59168)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jYDBc-0007Hv-H5; Mon, 11 May 2020 19:29:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jYDBb-0005wc-0v; Mon, 11 May 2020 19:29:55 +0100
Date:   Mon, 11 May 2020 19:29:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Julien Beraud <julien.beraud@orolia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: net: phylink: supported modes set to 0 with genphy sfp module
Message-ID: <20200511182954.GV1551@shell.armlinux.org.uk>
References: <0ee8416c-dfa2-21bc-2688-58337bfa1e2a@orolia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ee8416c-dfa2-21bc-2688-58337bfa1e2a@orolia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 05:45:02PM +0200, Julien Beraud wrote:
> Following commit:
> 
> commit 52c956003a9d5bcae1f445f9dfd42b624adb6e87
> Author: Russell King <rmk+kernel@armlinux.org.uk>
> Date:   Wed Dec 11 10:56:45 2019 +0000
> 
>     net: phylink: delay MAC configuration for copper SFP modules
> 
> 
> In function phylink_sfp_connect_phy, phylink_sfp_config is called before
> phylink_attach_phy.
> 
> In the case of a genphy, the "supported" field of the phy_device is filled
> by:
> phylink_attach_phy->phy_attach_direct->phy_probe->genphy_read_abilities.
> 
> It means that:
> 
> ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
> will have phy->supported with no bits set, and then the first call to
> phylink_validate in phylink_sfp_config will return an error:
> 
> return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
> 
> this results in putting the sfp driver in "failed" state.

Which PHY is this?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
