Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95B646F821
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 01:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbhLJAmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 19:42:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35730 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhLJAmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 19:42:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B6BAB82714
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 00:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB38AC004DD;
        Fri, 10 Dec 2021 00:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639096710;
        bh=Sb3LAGXpJbXC+1BbG8AmJEvr07/8fuakDH3zuzWX9pg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zub1si5/dg2Ji/Dx6iz37BiGzub9k3FsmFJxzfLylBmsjub6Hs+VhLFVIC/C7YQwA
         bIqxx7zcbaDkL7CJegbi50tMQaPVX0ZIstgp7tp7IKEPayXBSOgzZbOlBkPlneC8C5
         dOhtOwIYr3eRh0zut+/hvENLogE/SocpFL+T1C3+Eg8uQzq+fZLnrm+mRzu+zraX7e
         7xtkf0K3GoiaFGsOIrsA/CgkX1SW864X/Wc51IRSS2a9BWhVc3TeXCbE2VxJVaE0EL
         olyTH83wFIk5T8yysomEkS1ACYGwroufDC9N7o6FzAk8XXptYh3VQnc7VyBwQcokeJ
         wfMtXF328p8Xg==
Date:   Thu, 9 Dec 2021 16:38:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com,
        iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
Message-ID: <20211209163828.223815bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1067680364.223350225.1639059024535.JavaMail.zimbra@uliege.be>
References: <20211206211758.19057-1-justin.iurman@uliege.be>
        <20211206161625.55a112bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <262812089.220024115.1638878044162.JavaMail.zimbra@uliege.be>
        <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1045511371.220520131.1638894949373.JavaMail.zimbra@uliege.be>
        <20211207090700.55725775@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1665643630.220612437.1638900313011.JavaMail.zimbra@uliege.be>
        <20211208141825.3091923c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1067680364.223350225.1639059024535.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Dec 2021 15:10:24 +0100 (CET) Justin Iurman wrote:
> > because Linux routers can run a full telemetry stack and all sort
> > of advanced SW instrumentation. The use case for reporting kernel
> > memory use via IOAM's constrained interface does not seem particularly
> > practical since it's not providing a very strong signal on what's
> > going on.  
> 
> I agree and disagree. I disagree because this value definitely tells you
> that something (potentially bad) is going on, when it increases
> significantly enough to reach a critical threshold. Basically, we need
> more skb's, but oh, the pool is exhausted. OK, not a problem, expand the
> pool. Oh wait, no memory left. Why? Is it only due to too much
> (temporary?) load? Should I put the blame on the NIC? Is it a memory
> issue? Is it something else? Or maybe several issues combined? Well, you
> might not know exactly why (though you know there is a problem), which is
> also why I agree with you. But, this is also why you have other data
> fields available (i.e., detecting a problem might require 2+ symptoms
> instead of just one).
> 
> > For switches running Linux the switch ASIC buffer occupancy can be read
> > via devlink-sb that'd seem like a better fit for me, but unfortunately
> > the devlink calls can sleep so we can't read such device info from the
> > datapath.  
> 
> Indeed, would be a better fit. I didn't know about this one, thanks for
> that. It's a shame it can't be used in this context, though. But, at the
> end of the day, we're left with nothing regarding buffer occupancy. So
> I'm wondering if "something" is not better than "nothing" in this case.
> And, for that, we're back to my previous answer on why I agree and
> disagree with what you said about its utility.

I think we're on the same page, the main problem is I've not seen
anyone use the skbuff_head_cache occupancy as a signal in practice.

I'm adding a bunch of people to the CC list, hopefully someone has
an opinion one way or the other.

Lore link to the full thread, FWIW:

https://lore.kernel.org/all/20211206211758.19057-1-justin.iurman@uliege.be/
