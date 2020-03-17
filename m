Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7A1188B3A
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 17:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCQQy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 12:54:28 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42484 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgCQQy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 12:54:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=e+PNzjZD49SLlIS9YB23inFBrkx9yxdwawoibmgN9y8=; b=prMdrxLfOspQCvQv1/f6tqc0H
        B/OxDBs/9+BcXVEi0FSzOZDYWyM3w96NhVdBp8EuRIogI6zc/n8W2axpYnldVrFVUQJxNPDuYHIuo
        ujfbzgMUCI4NolgZ0PSYYkYbH8ZI1Vaw2bABuSLS+/NwTjtPFT8enbQMPkqTip1cX3XZMbgYGp8bx
        EhQeZgFHmfLSnoLMTO+Y5gbCftQ++527VM4PRN5Okxzruiwh/NRK++1inzlxxFPgJ5fiA/xFJaIQy
        SwLTaCTWNnPKNmBfKMKW79ewMsGLekdcz/dTkfVuNFmIYsbxJBuYS5dOplcqhtrCHcCPXl0TQ3vKB
        E34wlSDPA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37738)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEFTz-0008GF-3z; Tue, 17 Mar 2020 16:54:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEFTy-0002yC-Kj; Tue, 17 Mar 2020 16:54:22 +0000
Date:   Tue, 17 Mar 2020 16:54:22 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Message-ID: <20200317165422.GU25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <20200317163802.GZ24270@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317163802.GZ24270@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 05:38:02PM +0100, Andrew Lunn wrote:
> On Tue, Mar 17, 2020 at 02:52:51PM +0000, Russell King wrote:
> > *NOT FOR MERGING*
> > 
> > Add a separate set of PCS operations, which MAC drivers can use to
> > couple phylink with their associated MAC PCS layer.  The PCS
> > operations include:
> > 
> > - pcs_get_state() - reads the link up/down, resolved speed, duplex
> >    and pause from the PCS.
> > - pcs_config() - configures the PCS for the specified mode, PHY
> >    interface type, and setting the advertisement.
> > - pcs_an_restart() - restarts 802.3 in-band negotiation with the
> >    link partner
> > - pcs_link_up() - informs the PCS that link has come up, and the
> >    parameters of the link. Link parameters are used to program the
> >    PCS for fixed speed and non-inband modes.
> 
> Hi Russell
> 
> This API makes sense. But it seems quite common to have multiple
> PCS's. Rather than have MAC drivers implement their own mux, i wonder
> if there should be core support? Or at least a library to help the
> implementation?

When each PCS has different characteristics, and may not even be
available to be probed (because the hardware holds them in reset,
so they don't even respond to MDIO cycles) that becomes very
difficult.

That is the situation with LX2160A - when in 1G mode, the 10G C45
PCS does not respond.  Already tested that.

So, determining when to switch can't be known by generic code.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
