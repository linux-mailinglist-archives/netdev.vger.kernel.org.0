Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60000D2557
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388586AbfJJI57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 04:57:59 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:36271 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389266AbfJJIqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 04:46:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id B2B7A5C5;
        Thu, 10 Oct 2019 04:46:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 10 Oct 2019 04:46:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Q8h1Qq
        Xd+XDM9uv76KoUSMSQiDPzNMxFF40Ej8SLcDU=; b=R7iGH6Pw/pvMO0cc4mAR4s
        oB+T1z4mjTbwhT5uY1dKYDKroSS7FeGwNfdQCzIy0di0O36NVYLdZ/A0O1uQG3vR
        t03lcvH6NEvWH1arMv55LattzVzm6i6RVSBAc3KWFlPtB5lNtwYp0olBXGKUDZr+
        pGnElLAnVEDir4KCUMZP2xY9rK2PLfyIGai/ofBdmnPwn4VymdG9j9PlcCxLE2s8
        2MMH7zT5JtF+LMJyr9nwpRvrLMlBu88PM6mTf/G+vK3GLr4aUkRu7EEoDQpuRmql
        rnoVEmD8tZuNnB0oXD70VOlRQ1CvFHck9LJYl08bUP/NDJrABtSxGs1GmUnQoynA
        ==
X-ME-Sender: <xms:0u-eXToLQxnyKQACd489Cf9PEpbKGOyj0bi8gv4r-qnmlihZtFcInw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrieefgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:0u-eXai4Nypp8mA0V4o1BNhCWMYYlnT86Hlnd8euoFSfJLo6Fc38DQ>
    <xmx:0u-eXf9EDQIIGuWooDNPBJSsncy7ltEuW70Z6sgWoWSKyp8JopXTgg>
    <xmx:0u-eXWWqNwpeyo4YYTf0yNBrX51Hf9Bu4bCPUmfpRJSrk-TR59BI6A>
    <xmx:0u-eXRmrKTsxfNgOKTfV0-z5uuopY4BRBViyyyIc8DWk91ehFBc6Tw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BBB55D6005A;
        Thu, 10 Oct 2019 04:46:09 -0400 (EDT)
Date:   Thu, 10 Oct 2019 11:46:08 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jesse Hathaway <jesse@mbuki-mvuki.org>
Cc:     netdev@vger.kernel.org
Subject: Re: Race condition in route lookup
Message-ID: <20191010084608.GA4730@splinter>
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010083102.GA1336@splinter>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 11:31:04AM +0300, Ido Schimmel wrote:
> On Wed, Oct 09, 2019 at 11:00:07AM -0500, Jesse Hathaway wrote:
> > We have been experiencing a route lookup race condition on our internet facing
> > Linux routers. I have been able to reproduce the issue, but would love more
> > help in isolating the cause.
> > 
> > Looking up a route found in the main table returns `*` rather than the directly
> > connected interface about once for every 10-20 million requests. From my
> > reading of the iproute2 source code an asterisk is indicative of the kernel
> > returning and interface index of 0 rather than the correct directly connected
> > interface.
> > 
> > This is reproducible with the following bash snippet on 5.4-rc2:
> > 
> >   $ cat route-race
> >   #!/bin/bash
> > 
> >   # Generate 50 million individual route gets to feed as batch input to `ip`
> >   function ip-cmds() {
> >           route_get='route get 192.168.11.142 from 192.168.180.10 iif vlan180'
> >           for ((i = 0; i < 50000000; i++)); do
> >                   printf '%s\n' "${route_get}"
> >           done
> > 
> >   }
> > 
> >   ip-cmds | ip -d -o -batch - | grep -E 'dev \*' | uniq -c
> > 
> > Example output:
> > 
> >   $ ./route-race
> >         6 unicast 192.168.11.142 from 192.168.180.10 dev * table main
> > \    cache iif vlan180
> > 
> > These routers have multiple routing tables and are ingesting full BGP routing
> > tables from multiple ISPs:
> > 
> >   $ ip route show table all | wc -l
> >   3105543
> > 
> >   $ ip route show table main | wc -l
> >   54
> > 
> > Please let me know what other information I can provide, thanks in advance,
> 
> I think it's working as expected. Here is my theory:
> 
> If CPU0 is executing both the route get request and forwarding packets
> through the directly connected interface, then the following can happen:
> 
> <CPU0, t0> - In process context, per-CPU dst entry cached in the nexthop

Sorry, only output path is per-CPU. See commit d26b3a7c4b3b ("ipv4:
percpu nh_rth_output cache"). I indeed see the issue regardless of the
CPU on which I run the route get request.

> is found. Not yet dumped to user space
> 
> <Any CPU, t1> - Routes are added / removed, therefore invalidating the
> cache by bumping 'net->ipv4.rt_genid'
> 
> <CPU0, t2> - In softirq, packet is forwarded through the nexthop. The
> cached dst entry is found to be invalid. Therefore, it is replaced by a
> newer dst entry. dst_dev_put() is called on old entry which assigns the
> blackhole netdev to 'dst->dev'. This netdev has an ifindex of 0 because
> it is not registered.
> 
> <CPU0, t3> - After softirq finished executing, your route get request
> from t0 is resumed and the old dst entry is dumped to user space with
> ifindex of 0.
> 
> I tested this on my system using your script to generate the route get
> requests. I pinned it to the same CPU forwarding packets through the
> nexthop. To constantly invalidate the cache I created another script
> that simply adds and removes IP addresses from an interface.
> 
> If I stop the packet forwarding or the script that invalidates the
> cache, then I don't see any '*' answers to my route get requests.
> 
> BTW, the blackhole netdev was added in 5.3. I assume (didn't test) that
> with older kernel versions you'll see 'lo' instead of '*'.
