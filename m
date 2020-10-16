Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1000E290BCA
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 20:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404010AbgJPSwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 14:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403993AbgJPSwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 14:52:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48FE42065C;
        Fri, 16 Oct 2020 18:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602874342;
        bh=A7zZGWRfTPgHv2W/P7bhldL+fcnGv2TC7ECKIEEdj/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LpD5TMU1EAv09SqpvGHXT4gQ1YaI+jT2qxNutul3CbPeWLD2p+uC03AqOgjB6Bjds
         MSLjcQeA8Wl+D0DCEPxgkR7F9T+2/XNrg5CG8B1+iHfJPQ4yjopdt0/M9WO4nm5yIn
         Z+IWdjeeIuiNwYYuTHRTdOYyElGuKrVnMBX4Vqg4=
Date:   Fri, 16 Oct 2020 11:52:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
Message-ID: <20201016115220.771c7169@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016181319.2jrbdp5h7avzjczj@skbuf>
References: <20201014161719.30289-1-ceggers@arri.de>
        <4467366.g9nP7YU7d8@n95hx1g2>
        <20201016090527.tbzmjkraok5k7pwb@skbuf>
        <1655621.YBUmbkoM4d@n95hx1g2>
        <20201016155645.kmlehweenqdue6q2@skbuf>
        <20201016110311.6a43e10d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201016181319.2jrbdp5h7avzjczj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 21:13:19 +0300 Vladimir Oltean wrote:
> On Fri, Oct 16, 2020 at 11:03:11AM -0700, Jakub Kicinski wrote:
> > On Fri, 16 Oct 2020 18:56:45 +0300 Vladimir Oltean wrote:  
> > > > 3. "Manually" unsharing in dsa_slave_xmit(), reserving enough tailroom
> > > > for the tail tag (and ETH_ZLEN?). Would moving the "else" clause from
> > > > ksz_common_xmit()  to dsa_slave_xmit() do the job correctly?    
> > > 
> > > I was thinking about something like that, indeed. DSA knows everything
> > > about the tagger: its overhead, whether it's a tail tag or not. The xmit
> > > callback of the tagger should only be there to populate the tag where it
> > > needs to be. But reallocation, padding, etc etc, should all be dealt
> > > with by the common DSA xmit procedure. We want the taggers to be simple
> > > and reuse as much logic as possible, not to be bloated.  
> > 
> > FWIW if you want to avoid the reallocs you may want to set
> > needed_tailroom on the netdev.  
> 
> Tell me more about that, I've been meaning since forever to try it out.
> I read about needed_headroom and needed_tailroom, and it's one of the
> reasons why I added the .tail_tag option in the DSA tagger (to
> distinguish whether a switch needs headroom or tailroom), but I can't
> figure out, just from static analysis of the code, where exactly is the
> needed tailroom being accounted for. 

My understanding that the tail tag use case matches pretty well,
needed_tailroom is supposed to be a hit to the higher layers of 
the stack to leave some extra space at the end.

Now, it's probably of limited use in practice since I'd imagine 
most data comes in fragments. 

> For example, if I'm in Christian's
> situation, e.g. I have a packet smaller than ETH_ZLEN, would the
> tailroom be enough to hold just the dev->needed_tailroom, or would there
> be enough space in the skb for the entire ETH_ZLEN + dev->needed_tailroom?

I don't think we account for padding in general. Also looking at
__pskb_pull_tail() we're already seem to be provisioning some extra 
128B. So I guess it won't matter and the DSA tags are too small to
need the head/tailroom hints anyway..
