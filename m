Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5E7100F5E
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 00:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfKRXTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 18:19:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbfKRXTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 18:19:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b2Hir1hLsZycjbrts7qn6Kw+wRnTKAvDC9dXsLIGpU4=; b=WRBatzPEsto3JuQB/FapzVYBY9
        9Yha/ngI7fN+1RxdQHOt6v00auwUFKVGExX4D1U5mwfp6S6AuO3HsaD2vP/6pN+zQUcZfqyjXEjNL
        4xIidwIMfTIsTiHipmX0yuAknsFxEWf2dz0fG1/teqrPpgwAEV0tiijw32mTVozvhH+0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iWqIk-0005mO-92; Tue, 19 Nov 2019 00:19:22 +0100
Date:   Tue, 19 Nov 2019 00:19:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shay Drory <shayd@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "lennart@poettering.net" <lennart@poettering.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        lorian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: Send SFP event from kernel driver to user space (UDEV)
Message-ID: <20191118231922.GB15395@lunn.ch>
References: <a041bba0-83d1-331f-d263-c8cbb0509220@mellanox.com>
 <20191118012924.GC4084@lunn.ch>
 <7dc1a44f-d15c-4181-df45-ae93cfd95438@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dc1a44f-d15c-4181-df45-ae93cfd95438@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 11:54:31AM +0000, Shay Drory wrote:
> On 11/18/2019 03:29, Andrew Lunn wrote:
> > On Sun, Nov 17, 2019 at 11:46:15AM +0000, Shay Drory wrote:
> >
> > Hi Shay
> >
> > It would be good to Cc: the generic SFP code maintainers.
> 
> The suggested solution is not targeted for SFP drivers (see below),
> but I added them to the Cc list.

Hi Shay

So you are proposing something which won't work for the generic SFP
code?  That should be an automatic NACK. Whatever you propose needs to
be generic so that it can work for any NICs that do firmware support
for SFPs, and those who let Linux handle the SFP.

> The feature is targeted to netdev users. It is expected from the
> user to query current state via ethtool -m and afterwards monitor
> for changes over UDEV.

What exactly are you interested in? What are your use cases. When
hwmon devices are created, you should get udev events. Maybe that is
sufficient? Or are you interested in some other parts of the SFP than
the diagnostic sensors?

> > Would you add just SFP insert/eject to UDEV. Or all the events which
> > get sent via netlink? Link up/down, route add/remove, etc?
> 
> It makes sense to notify all events. What do you think?

I don't particularly like two ways to get the same information. It
means we have two APIs we need to maintain forever, when just one
should be sufficient.

> > Is UDEV name space aware? Do you run a udev daemon in each network
> > name space? I assume when you open a netlink socket, it is for just
> > the current network namespace?
> 
> UDEV will follow netlink name-space.

So you do plan to have a udev daemon running in every network name
space. Does udev even support that?

I'm sceptical using udev is a good idea. But having netlink events
does sounds reasonable. And if you are willing to wait a while,
ethtool-nl does seem like a good fit. But please make sure your
solution is generic.

	 Andrew
