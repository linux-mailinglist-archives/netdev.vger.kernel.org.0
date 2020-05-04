Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5EA1C3B5B
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgEDNfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:35:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:34982 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgEDNfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 09:35:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3AA7AAD2C;
        Mon,  4 May 2020 13:35:38 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id AFC15604EE; Mon,  4 May 2020 15:35:35 +0200 (CEST)
Date:   Mon, 4 May 2020 15:35:35 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v5 1/2] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200504133535.GC8237@lion.mk-sys.cz>
References: <20200504071214.5890-1-o.rempel@pengutronix.de>
 <20200504071214.5890-2-o.rempel@pengutronix.de>
 <20200504080417.i3d2jsjjpu2zjk4z@pengutronix.de>
 <20200504083734.GA5989@lion.mk-sys.cz>
 <20200504085556.rzkvn47q2k5iqyap@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504085556.rzkvn47q2k5iqyap@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 10:55:56AM +0200, Oleksij Rempel wrote:
> On Mon, May 04, 2020 at 10:37:34AM +0200, Michal Kubecek wrote:
> > On Mon, May 04, 2020 at 10:04:17AM +0200, Oleksij Rempel wrote:
> > > @Michal,
> > > 
> > > i noticed that linkmodes_fill_reply() some times get not enough
> > > tailroom.
> > > if data->peer_empty == 0
> > > linkmodes_reply_size() size: 476
> > > linkmodes_fill_reply() skb tailroom: 724
> > > 
> > > 
> > > if data->peer_empty == 1
> > > linkmodes_reply_size() size: 216                                      
> > > linkmodes_fill_reply() skb tailroom: 212
> > > 
> > > In the last case i won't be able to attach master_lave state and cfg
> > > fields.
> > > 
> > > It looks like this issue was not introduced by my patches. May be you
> > > have idea, what is missing?
> > 
> > It's my mistake, I'm just not sure why I never ran into this while
> > testing. Please try the patch below.
> 
> thx! it works now:
> [   82.754019] linkmodes_reply_size:103 size: 216
> [   82.758523] linkmodes_fill_reply:117 skb tailroom: 724
> 
> [  126.781892] linkmodes_reply_size:103 size: 476
> [  126.786464] linkmodes_fill_reply:117 skb tailroom: 724

Thank you. It seems so far the natural skb padding was always sufficient
to hide the broken calculation. Some time ago I had a debugging printk
in place which checked calculated an actual size but that was with an
older version of the series and the code has been rewritten few times
before it reached mainline.

I'll run some tests with additional tracing of estimated and actual
message size and if I don't find other problem, I'll submit the fix.

Michal
