Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A369E3CDEEA
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 17:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344795AbhGSPGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 11:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345883AbhGSPFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 11:05:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF79C0613E9;
        Mon, 19 Jul 2021 08:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5EyuyxdB0VvwZpwllRkhj4XH997vuxgnqyXnXfI5mIM=; b=d9QCOPubEyU4uUIQOX2S/b+lN
        cyYYjwmQtBxiI0sEBU3hGOo60r1lMy0G98AYbImwpqG18SoRY91gtSm8CltgX0yzYObjohiQStrun
        8u/eSdErIbntp+XTmYQ7iq6s+ggWPLqR7vEuX32AW3qrjXuoncc4n59H7Vha+N3v7lAqXaBncJZzu
        RYa5mQsSrTDYCIX35dWHudxbVLJqmeuFufTxwnPHow1cBNv0f62Ydyi9QdfDnabBeYUV3WJtjqww3
        vsd4ExjpzHr8xgYXoFjA3fhG3G+MC+MZEIffC9CheUjzIkqzHuSAOr16cz7XAOqrN0szdb13nTTkl
        R70Db1mew==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46328)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m5VDE-00052Y-8K; Mon, 19 Jul 2021 16:29:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m5VDC-00064u-OO; Mon, 19 Jul 2021 16:29:42 +0100
Date:   Mon, 19 Jul 2021 16:29:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Ivan T. Ivanov" <iivanov@suse.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: leds: Trigger leds only if PHY speed is known
Message-ID: <20210719152942.GQ22278@shell.armlinux.org.uk>
References: <20210716141142.12710-1-iivanov@suse.de>
 <YPGjnvB92ajEBKGJ@lunn.ch>
 <162646032060.16633.4902744414139431224@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162646032060.16633.4902744414139431224@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 09:32:00PM +0300, Ivan T. Ivanov wrote:
> Hi,
> 
> Quoting Andrew Lunn (2021-07-16 18:19:58)
> > On Fri, Jul 16, 2021 at 05:11:42PM +0300, Ivan T. Ivanov wrote:
> > > This prevents "No phy led trigger registered for speed(-1)"
> > > alert message which is coused by phy_led_trigger_chage_speed()
> > > being called during attaching phy to net_device where phy device
> > > speed could be still unknown.
> > 
> > Hi Ivan
> > 
> > It seems odd that when attaching the PHY we have link, but not the
> > speed. What PHY is this?
> 
> This is lan78xx on RPi3B+
> 
> > 
> > > -     if (phy->speed == 0)
> > > +     if (phy->speed == 0 || phy->speed == SPEED_UNKNOWN)
> > >               return;
> > 
> > This change makes sense. But i'm wondering if the original logic is
> > sound. We have link, but no speed information.
> 
> Well, probably my interpretation was not correct. The most probable
> call to phy_led_trigger_change_speed() which couses this alert is
> phy_attach_direct() -> phy_led_triggers_register(), I think. I am
> not sure that we have link at this stage or not.

This does sound weird.

When a phy_device is allocated, it's explicitly initialised with:

	dev->speed = SPEED_UNKNOWN;
	dev->duplex = DUPLEX_UNKNOWN;
	dev->link = 0;
	dev->state = PHY_DOWN;

so, unless something is causing state to be read before we've attached
the phy to a network device, this is how this state should remain. I
wonder why you are seeing dev->link be non-zero.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
