Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F373F847D
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 11:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240851AbhHZJ0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 05:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbhHZJ0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 05:26:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075D0C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 02:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=W1Klj3CMNoWPAHRXpNFXpx71pl7hHS2bAkksyUM37vA=; b=mdk6FtVk1OllNPr7szkwJU/QO
        fKYPzg9rV8wOosya9uGgbWuKMwxjmQ+2a3KO4vqJu5MGzzodcrFblAgJSdPxbZFija+4J2t6V3cOh
        Nz1NMRAUj0I+BJgD+nz8cG7dsjjLh6m+TRN4B2zhJmCVXCCoWv87gRYi0xdy7qFqgbaqojoaSeFM9
        Wo4Kmy+y6MKSDbmQlx1WLfZmn23Bbqr0HOLQM+VQlO8gYtWmu9inhtQjlX5JcSlFXLKCfW6yJ5e2S
        yd2FeL+w7UfQ/IsqIZ1PakUgljZcjk5gyZtDiAWN1z3LHtsTK3VVTtV/VGMPMJhAfP0IPPgeALyca
        K5NyfFYRQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47702)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mJBdJ-0007eM-9z; Thu, 26 Aug 2021 10:25:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mJBdH-0000hW-Li; Thu, 26 Aug 2021 10:25:11 +0100
Date:   Thu, 26 Aug 2021 10:25:11 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, Nathan Rossi <nathan.rossi@digi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: phylink: Update SFP selected interface on
 advertising changes
Message-ID: <20210826092511.GQ22278@shell.armlinux.org.uk>
References: <20210826071230.11296-1-nathan@nathanrossi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826071230.11296-1-nathan@nathanrossi.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 07:12:30AM +0000, Nathan Rossi wrote:
> From: Nathan Rossi <nathan.rossi@digi.com>
> 
> Currently changes to the advertising state via ethtool do not cause any
> reselection of the configured interface mode after the SFP is already
> inserted and initially configured.
> 
> While it is not typical to change the advertised link modes for an
> interface using an SFP in certain use cases it is desirable. In the case
> of a SFP port that is capable of handling both SFP and SFP+ modules it
> will automatically select between 1G and 10G modes depending on the
> supported mode of the SFP. However if the SFP module is capable of
> working in multiple modes (e.g. a SFP+ DAC that can operate at 1G or
> 10G), one end of the cable may be attached to a SFP 1000base-x port thus
> the SFP+ end must be manually configured to the 1000base-x mode in order
> for the link to be established.
> 
> This change causes the ethtool setting of advertised mode changes to
> reselect the interface mode so that the link can be established.

This may be a better solution than the phylink_helper_basex_speed()
approach used to select between 2500 and 1000 base-X, but the config
needs to be validated after selecting a different interface mode, as
per what phylink_sfp_config() does.

I also suspect that this will allow you to select e.g. 1000base-X but
there will be no way back to 10G modes as they will be masked out of
the advertising mask from that point on, as the 1000base-X interface
mode does not allow them.

So, I think the suggested code is problematical as it stands.

phylink_sfp_config() uses a multi-step approach to selecting the
interface mode for a reason - first step is to discover what the MAC
is capable of in _any_ interface mode using _NA to reduce the supported
and advertised mask down, and then to select the interface from that.
I'm not entirely convinced that is a good idea here yet though.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
