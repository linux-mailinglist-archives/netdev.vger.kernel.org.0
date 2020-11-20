Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C74B2BAF0B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbgKTPd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:33:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729832AbgKTPd0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 10:33:26 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD4D122D0A;
        Fri, 20 Nov 2020 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605886405;
        bh=7jKA6lSup+TJcxhVwGA9Xv+5wzWumwLAZLeTMclvkuc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O3dxAzs/qCcSogYvPLSJi1XQBUbT8vivPx7iW2uyN0bi5XxjRR+pOjTwupQ+TaGTy
         P4R7x8fBCjtcj9DYNMLsZPI49oPrIK1GZ0qeFlV0vRInE357IR0CPdMwgkEMuj43rA
         m7K/EGGQ5HmHPZDaG27OzpGhDIOcDFKRt3H6Zp5E=
Date:   Fri, 20 Nov 2020 07:33:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
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
Message-ID: <20201120073323.53870d50@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201120125907.23ficr3er3icrg2i@pengutronix.de>
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
        <20201120125907.23ficr3er3icrg2i@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 13:59:07 +0100 Oleksij Rempel wrote:
> On Mon, Nov 16, 2020 at 04:28:44PM -0800, Jakub Kicinski wrote:
> > On Tue, 17 Nov 2020 02:10:05 +0200 Vladimir Oltean wrote:  
> > > On Mon, Nov 16, 2020 at 04:02:13PM -0800, Jakub Kicinski wrote:  
> > > > For a while now we have been pushing back on stats which have a proper
> > > > interface to be added to ethtool -S. So I'd expect the list of stats
> > > > exposed via ethtool will end up being shorter than in this patch.    
> > > 
> > > Hmm, not sure if that's ever going to be the case. Even with drivers
> > > that are going to expose standardized forms of counters, I'm not sure
> > > it's going to be nice to remove them from ethtool -S.  
> > 
> > Not remove, but also not accept adding them to new drivers.
> >   
> > > Testing teams all
> > > over the world have scripts that grep for those. Unfortunately I think
> > > ethtool -S will always remain a dumping ground of hell, and the place
> > > where you search for a counter based on its name from the hardware block
> > > guide as opposed to its standardized name/function. And that might mean
> > > there's no reason to not accept Oleksij's patch right away. Even if he
> > > might volunteer to actually follow up with a patch where he exposes the
> > > .ndo_get_stats64 from DSA towards drivers, as well as implements
> > > .ndo_has_offload_stats and .ndo_get_offload_stats within DSA, that will
> > > most likely be done as separate patches to this one, and not change in
> > > any way how this patch looks.  
> 
> Ok, so what is the plan for me? Implement .ndo_get_stats64 before this
> one?

Yup. And ethtool_ops::get_pause_stats, preferable 'cause I think you
had pause stats there, too.
