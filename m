Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A9E47C826
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 21:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbhLUUNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 15:13:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59606 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbhLUUNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 15:13:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1476B819CB
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 20:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC307C36AE8;
        Tue, 21 Dec 2021 20:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640117588;
        bh=NdnUAoqQwJKijxwrJbnAwiMROZ0LA6bBUFaKxwVopMM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tpxtdi4gjIBqfAwnjjSizZTGpP26++pDQ5s20F2tcXDuJJWOPFvIs+DrVZPxG/HfP
         SFdc4w6iDW9H/QVs0QwldELu2/4zsXQVBQMv8Q/JNB2YJ0gkTeUigrhEwM8FUJn7Ww
         JF9O1vmjr1P8k7jj/gUHj9XpIKV3jrn39BHsD24++C7bncdFMZ3K4PBKw46LtoHWs7
         WgF0e8gUBpqS8sM4mY+/Vj2Pgcjx5WtuklcopmgwLVNXAI+f3uQSvSpvHgWH93XxOY
         CmU6gE6WBduBmfCucRVtKHB6xSgDXb+2PhkiJw6mwt9FIfDF3YTtv55HoiPa8ViOH1
         lo4/NjrKJpAPg==
Date:   Tue, 21 Dec 2021 12:13:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        linux-mm@kvack.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
Message-ID: <20211221121306.487799cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211221172337.kvqlkf3jqx2uqclm@skbuf>
References: <20211206211758.19057-1-justin.iurman@uliege.be>
        <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1045511371.220520131.1638894949373.JavaMail.zimbra@uliege.be>
        <20211207090700.55725775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1665643630.220612437.1638900313011.JavaMail.zimbra@uliege.be>
        <20211208141825.3091923c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1067680364.223350225.1639059024535.JavaMail.zimbra@uliege.be>
        <20211209163828.223815bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1065685246.241690721.1640106399663.JavaMail.zimbra@uliege.be>
        <20211221172337.kvqlkf3jqx2uqclm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 19:23:37 +0200 Vladimir Oltean wrote:
> On Tue, Dec 21, 2021 at 06:06:39PM +0100, Justin Iurman wrote:
> > On Dec 10, 2021, at 1:38 AM, Jakub Kicinski kuba@kernel.org wrote:  
> > > I think we're on the same page, the main problem is I've not seen
> > > anyone use the skbuff_head_cache occupancy as a signal in practice.
> > > 
> > > I'm adding a bunch of people to the CC list, hopefully someone has
> > > an opinion one way or the other.  
> > 
> > It looks like we won't have more opinions on that, unfortunately.
> > 
> > @Jakub - Should I submit it as a PATCH and see if we receive more
> > feedback there?  
> 
> I know nothing about OAM and therefore did not want to comment, but I
> think the point raised about the metric you propose being irrelevant in
> the context of offloaded data paths is quite important. The "devlink-sb"
> proposal was dismissed very quickly on grounds of requiring sleepable
> context, is that a deal breaker, and if it is, why? Not only offloaded
> interfaces like switches/routers can report buffer occupancy. Plain NICs
> also have buffer pools, DMA RX/TX rings, MAC FIFOs, etc, that could
> indicate congestion or otherwise high load. Maybe slab information could
> be relevant, for lack of a better option, on virtual interfaces, but if
> they're physical, why limit ourselves on reporting that? The IETF draft
> you present says "This field indicates the current status of the
> occupancy of the common buffer pool used by a set of queues." It appears
> to me that we could try to get a reporting that has better granularity
> (per interface, per queue) than just something based on
> skbuff_head_cache. What if someone will need that finer granularity in
> the future.

Indeed.

In my experience finding meaningful metrics is heard, the chances that
something that seems useful on the surface actually provides meaningful
signal in deployments is a lot lower than one may expect. And the
commit message reads as if the objective was checking a box in the
implemented IOAM metrics, rather exporting relevant information. 

We can do a roll call on people CCed but I read their silence as nobody
thinks this metric is useful. Is there any experimental data you can
point to which proves the signal strength?
