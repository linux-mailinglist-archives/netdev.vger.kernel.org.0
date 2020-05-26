Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7D71E25D1
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgEZPno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbgEZPno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:43:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28FBC03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 08:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SwBYViNLad+qTHLi6nmDJs7dBCNBfBeFaiRnP428y6A=; b=it8u4q1+HuUKfjEOHwD5fHG9H
        OqXIBvauKeYwn1d3l8uS8JR4ZsFNgvwputlZOSW7wEdcvaqGIkcALidimlxlbywB9yEMu7MWFqnLe
        P4IzHUkqEaNxRsYqFTu1J6yBkjMGHs1sWMpsjAM5oY9qjlg2FjRHRpUzMlpKHONMdexEh0Cjj3OyF
        5FWSAX5+SkZYTMoKVdKskoKdB0lC294WZdXnEt2XtYJn6sLY6rjHdcG8jmOrbsgwSQvLiZ60rBXM8
        Nn8Iv2kMWRcPCeWPFbkjeYCaPhsLrZ1UAXx/riktPdRsGEUgRMhzYXRHMFstjpoLFH4lZeEpoztmM
        3WmJQzHgA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45336)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdbjs-0008DD-UR; Tue, 26 May 2020 16:43:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdbjr-0005VI-Jz; Tue, 26 May 2020 16:43:35 +0100
Date:   Tue, 26 May 2020 16:43:35 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 0/7] Clause 45 PHY probing cleanups
Message-ID: <20200526154335.GB1551@shell.armlinux.org.uk>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526142948.GY1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 03:29:48PM +0100, Russell King - ARM Linux admin wrote:
> Hi,
> 
> In response to the patch set that Jeremy posted, this is my proposal
> to expand our Clause 45 PHY probing.
> 
> I've taken a slightly different approach, with the view to avoiding
> as much behavioural change as possible.  The biggest difference is
> to do with "devices_in_package" - we were using it for two different
> purposes, which are now separated.
> 
> This is not against net-next nor net trees, but against my own private
> tree, but I'm posting it to serve as an illustration of what I think
> should be done - I knocked this up this morning.
> 
> The only potential regression that I'm expecting is with 88x3310 PHYs
> of the later revision, which have the clause 22 registers implemented.
> I haven't yet checked whether they set bit 0, but if they do, the
> various decision points that we have based on that bit could adversely
> affect this PHY - it needs testing, which I'll do when I dig out the
> appropriate hardware.  Probably also needs the 2110 PHYs checked as
> well.

Tested on the later revision of the 88x3310 PHY with some additional
prints:

orion-mdio f212a600.mdio: scanning prt 0 mmd 1...
orion-mdio f212a600.mdio: prt 0: dip=c000009a
orion-mdio f212a600.mdio: prt 0 mmd 1: id 0x002b09ab
orion-mdio f212a600.mdio: prt 0 mmd 3: id 0x002b09ab
orion-mdio f212a600.mdio: prt 0 mmd 4: id 0x01410dab
orion-mdio f212a600.mdio: prt 0 mmd 7: id 0x002b09ab
orion-mdio f212a600.mdio: prt 0 mmd 30: prs=0
orion-mdio f212a600.mdio: prt 0 mmd 31: prs=0

orion-mdio f212a600.mdio: scanning prt 8 mmd 1...
orion-mdio f212a600.mdio: prt 8: dip=c000009a
orion-mdio f212a600.mdio: prt 8 mmd 1: id 0x002b09ab
orion-mdio f212a600.mdio: prt 8 mmd 3: id 0x002b09ab
orion-mdio f212a600.mdio: prt 8 mmd 4: id 0x01410dab
orion-mdio f212a600.mdio: prt 8 mmd 7: id 0x002b09ab
orion-mdio f212a600.mdio: prt 8 mmd 30: prs=0
orion-mdio f212a600.mdio: prt 8 mmd 31: prs=0

which is what is expected from this PHY.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
