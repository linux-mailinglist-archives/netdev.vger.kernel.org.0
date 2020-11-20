Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD4A2BAAAB
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgKTM7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 07:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgKTM7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 07:59:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A5FC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 04:59:17 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kg60M-0002e8-GE; Fri, 20 Nov 2020 13:59:10 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kg60J-00038N-Vu; Fri, 20 Nov 2020 13:59:07 +0100
Date:   Fri, 20 Nov 2020 13:59:07 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats
 support
Message-ID: <20201120125907.23ficr3er3icrg2i@pengutronix.de>
References: <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116222146.znetv5u2q2q2vk2j@skbuf>
 <20201116143544.036baf58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116230053.ddub7p6lvvszz7ic@skbuf>
 <20201116151347.591925ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116232731.4utpige7fguzghsi@skbuf>
 <7cb26c4f-0c5d-0e08-5bbe-676f5d66a858@gmail.com>
 <20201116160213.3de5280c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201117001005.b7o7fytd2stawrm7@skbuf>
 <20201116162844.7b503b13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201116162844.7b503b13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:57:15 up 371 days,  4:15, 41 users,  load average: 0.01, 0.02,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 04:28:44PM -0800, Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 02:10:05 +0200 Vladimir Oltean wrote:
> > On Mon, Nov 16, 2020 at 04:02:13PM -0800, Jakub Kicinski wrote:
> > > For a while now we have been pushing back on stats which have a proper
> > > interface to be added to ethtool -S. So I'd expect the list of stats
> > > exposed via ethtool will end up being shorter than in this patch.  
> > 
> > Hmm, not sure if that's ever going to be the case. Even with drivers
> > that are going to expose standardized forms of counters, I'm not sure
> > it's going to be nice to remove them from ethtool -S.
> 
> Not remove, but also not accept adding them to new drivers.
> 
> > Testing teams all
> > over the world have scripts that grep for those. Unfortunately I think
> > ethtool -S will always remain a dumping ground of hell, and the place
> > where you search for a counter based on its name from the hardware block
> > guide as opposed to its standardized name/function. And that might mean
> > there's no reason to not accept Oleksij's patch right away. Even if he
> > might volunteer to actually follow up with a patch where he exposes the
> > .ndo_get_stats64 from DSA towards drivers, as well as implements
> > .ndo_has_offload_stats and .ndo_get_offload_stats within DSA, that will
> > most likely be done as separate patches to this one, and not change in
> > any way how this patch looks.

Ok, so what is the plan for me? Implement .ndo_get_stats64 before this
one?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
