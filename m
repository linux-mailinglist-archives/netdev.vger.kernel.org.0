Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA7C216D2B
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 14:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgGGMwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 08:52:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:59806 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgGGMwz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 08:52:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6CA2FAE68;
        Tue,  7 Jul 2020 12:52:54 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9E16460567; Tue,  7 Jul 2020 14:52:53 +0200 (CEST)
Date:   Tue, 7 Jul 2020 14:52:53 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/3] net: ethtool: Remove PHYLIB direct
 dependency
Message-ID: <20200707125253.dauwsket4eyitxkr@lion.mk-sys.cz>
References: <20200706042758.168819-1-f.fainelli@gmail.com>
 <20200706042758.168819-4-f.fainelli@gmail.com>
 <20200706114000.223e27eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200706195603.GA893522@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706195603.GA893522@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 09:56:03PM +0200, Andrew Lunn wrote:
> On Mon, Jul 06, 2020 at 11:40:00AM -0700, Jakub Kicinski wrote:
> > On Sun,  5 Jul 2020 21:27:58 -0700 Florian Fainelli wrote:
> > > +	ops = ethtool_phy_ops;
> > > +	if (!ops || !ops->start_cable_test) {
> > 
> > nit: don't think member-by-member checking is necessary. We don't
> > expect there to be any alternative versions of the ops, right?
> 
> I would not like to see anything else registering an ops. So i think
> taking an Opps would be a good indication somebody is doing something
> wrong and needs fixing.
> 
> > We could even risk a direct call:
> > 
> > #if IS_REACHABLE(CONFIG_PHYLIB)
> > static inline int do_x()
> > {
> > 	return __do_x();
> > }
> > #else
> > static inline int do_x()
> > {
> > 	if (!ops)
> > 		return -EOPNOTSUPP;
> > 	return ops->do_x();
> > }
> > #endif
> > 
> > But that's perhaps doing too much...
> 
> I would say it is too far. Two ways of doing the same thing requires
> twice as much testing. And these are not hot paths where we want to
> eliminate as many instructions and trampolines as possible.

Agreed, it seems a bit over the top.

Michal
