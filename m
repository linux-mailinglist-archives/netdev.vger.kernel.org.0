Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2167145A49B
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 15:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbhKWOMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 09:12:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47982 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237489AbhKWOMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 09:12:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WSo+W1WHsXUlt8awdNXOk/b3i1YgPAZX1pmGmGv77l4=; b=WhEx1Lou3Gc7W7mgKvd3XBpwTN
        P3KD3eMFTtcG3ZuTX1s6VtVAI1b9HoHcwB4ODdkYyju1rA0uF5bvEJ50ZdJ8rR5RP5507QgsI8nxk
        TO2EEI+XMqFIG96Yq9TgryG6ZW1L3Lu95WT7pjio7YB7MrwSQQPAvWG5031t9pGoTgfg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mpWTo-00EPxB-6y; Tue, 23 Nov 2021 15:09:04 +0100
Date:   Tue, 23 Nov 2021 15:09:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alessandro B Maurici <abmaurici@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] phy: fix possible double lock calling link changed
 handler
Message-ID: <YZz2AJ+wqasknw2p@lunn.ch>
References: <20211122235548.38b3fc7c@work>
 <YZxrhhm0YdfoJcAu@lunn.ch>
 <20211123014946.1ec2d7ee@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123014946.1ec2d7ee@work>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 01:49:46AM -0300, Alessandro B Maurici wrote:
> On Tue, 23 Nov 2021 05:18:14 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Mon, Nov 22, 2021 at 11:55:48PM -0300, Alessandro B Maurici wrote:
> > > From: Alessandro B Maurici <abmaurici@gmail.com>
> > > 
> > > Releases the phy lock before calling phy_link_change to avoid any worker
> > > thread lockup. Some network drivers(eg Microchip's LAN743x), make a call to
> > > phy_ethtool_get_link_ksettings inside the link change handler  
> > 
> > I think we need to take a step back here and answer the question, why
> > does it call phy_ethtool_get_link_ksettings in the link change
> > handler. I'm not aware of any other MAC driver which does this.
> > 
> > 	 Andrew
> 
> I agree, the use in the lan743x seems related to the PTP, that driver seems
> to be the only one using it, at least in the Linus tree. 
> I think that driver could be patched as there are other ways to do it,
> but my take on the problem itself is that the PHY device interface opens
> a way to break the flow and this behavior does not seem to be documented,
> so, instead of documenting a possible harmful interface while in the callback,
> we should just get rid of the problem itself, and calling a callback without
> any locks held seems to be a good alternative.

That is a really bad alternative. It is only because the lock is held
can the MAC driver actually trust anything passed to it. The callback
needs phydev->speed, phydev->duplex, etc, and they can change at any
time when the lock is not held. The values can be inconsistent with
each other, etc, unless the lock is held.

The callback has always had the lock held, so is safe. However,
recently a few bugs have been reported and fixed for functions like
phy_ethtool_get_link_ksettings() and phy_ethtool_set_link_ksettings()
where they have accessed phydev members without the lock and got
inconsistent values in race condition. These are hard race conditions
to reproduce, but a deadlock like this is very obvious, easy to fix. I
would also say that _ethtool_ in the function name is also a good hit
this is intended to be used for an ethtool callback.

Lets remove the inappropriate use of phy_ethtool_get_link_ksettings()
here.

     Andrew
