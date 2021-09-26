Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA834189F2
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 17:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhIZPZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 11:25:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60966 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231913AbhIZPZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 11:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FXodgzxtMmCJH6dpNMUAGkqwXazOJJIvRPo+rkQCxSw=; b=hc/czx539wFUTg/8dZDV09gXxm
        Y+CQaw1ScLKfegDL7UHZxi2NVF+g924PX49f9ejnkkcnN2IDw1aAKZDd5gCBiCyuS1LnGPUl0h4FQ
        JXAehj6p/Ln8MUqAIB528uTvNlcnGSZGuOCkghJAF23W3RfiJeEFWE2qo9N2S1nmRYQQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUW0c-008KOX-5R; Sun, 26 Sep 2021 17:24:06 +0200
Date:   Sun, 26 Sep 2021 17:24:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Beh__n <kabel@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: marvell10g: add downshift tunable
 support
Message-ID: <YVCQlul6Ar4fVtns@lunn.ch>
References: <E1mREEN-001yxo-Da@rmk-PC.armlinux.org.uk>
 <YUSp78o/vfZNFCJw@lunn.ch>
 <YUSs+efLowuhL09Q@shell.armlinux.org.uk>
 <YUsa3z8KsuqS64k8@shell.armlinux.org.uk>
 <YUvCpjql8V4FGB2s@lunn.ch>
 <YUxTvC9QVI5bGLuF@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUxTvC9QVI5bGLuF@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So, some further questions: should we be calling the set_downshift
> implementation from the .config_init as the Marvell driver does to
> ensure that downshift is correctly enabled?

The bootloader might of messed it up, so it does not seem unreasonable
to set it somewhere at startup.

> Is .config_init really
> the best place to do this? So many things with Marvell PHYs seem to
> require a reset, which bounces the link. So if one brings up the
> network interface, then sets EEE (you get a link bounce) and then
> set downshift, you get another link bounce. Each link bounce takes
> more than a second, which means the more features that need to be
> configured after bringing the interface up, the longer it takes for
> the network to become usable. Note that Marvell downshift will cause
> the link to bounce even if the values programmed into the register
> were already there - there is no check to see if we actually changed
> anything before calling genphy_soft_reset() which seems suboptimal
> given that we have phy_modify_changed() which can tell us that.

This can clearly be optimized. Add a test if the values are being
changed. Skip the reset if it is being done as part of .config_init
and there is a guarantee a later stage will perform the reset, etc.

    Andrew

