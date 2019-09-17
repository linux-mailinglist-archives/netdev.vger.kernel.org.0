Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7D5B57DE
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 00:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfIQWC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 18:02:59 -0400
Received: from ja.ssi.bg ([178.16.129.10]:32968 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbfIQWC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 18:02:59 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x8HM2jaK007794;
        Wed, 18 Sep 2019 01:02:45 +0300
Date:   Wed, 18 Sep 2019 01:02:45 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     David Ahern <dsahern@gmail.com>
cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv4: Revert removal of rt_uses_gateway
In-Reply-To: <9afca894-3807-632a-529b-7ceee4227bcb@gmail.com>
Message-ID: <alpine.LFD.2.21.1909172339130.2649@ja.home.ssi.bg>
References: <20190917173949.19982-1-dsahern@kernel.org> <alpine.LFD.2.21.1909172148220.2649@ja.home.ssi.bg> <9afca894-3807-632a-529b-7ceee4227bcb@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Tue, 17 Sep 2019, David Ahern wrote:

> On 9/17/19 12:50 PM, Julian Anastasov wrote:
> > 
> > 	Looks good to me, thanks!
> > 
> > Reviewed-by: Julian Anastasov <ja@ssi.bg>
> > 
> 
> BTW, do you have any tests for the rt_uses_gateway paths - showing why
> it is needed?

	No special tests.

> All of the pmtu, redirect, fib tests, etc worked fine without the
> special flag. Sure, the 'ip ro get' had extra data; it seems like that
> could be handled.

	I'll explain. In the period before the route cache
was removed in 3.6, there were two fields: rt_dst and rt_gateway.
For targets on LAN both contained the target. For targets via
gateway (nh_gw), rt_dst still stores the target but rt_gateway
stored the nh_gw. In short, rt_gateway always contained the
next hop IP for neigh resolving.

	In 3.6, rt_dst was removed and only rt_gateway remained
to store nh_gw. As fnhe_rth/nh_pcpu_rth_output were used to
cache the output route, rt_gateway can not contain any IP
because the route can be used for any target on the LAN.
This is true even now, rt_gateway is 0 for cached routes
that are not DST_HOST, i.e. not for single target IP.

	Why this matters? There are users such as IPVS,
TEE, raw.c (IP_HDRINCL) that use FLOWI_FLAG_KNOWN_NH to
request route with rt_gateway != 0 to be returned, i.e.
they want rt_gateway to store a next hop IP for neigh
resolving but to put different IP in iph->daddr. This is
honoured by rt_nexthop(), it prefers rt_gateway before the
iph->daddr. With this FLOWI flag the routing will avoid
returning routes with rt_gateway = 0 (cached in NH), instead
it will allocate DST_HOST route which can safely hold IP
in rt_gateway.

	So, in 3.7 commit 155e8336c373 ("ipv4: introduce
rt_uses_gateway") was created to restore the knowledge
that rt_dst != rt_gateway means route via GW and also
commit c92b96553a80 ("ipv4: Add FLOWI_FLAG_KNOWN_NH")
to make sure packets are routed by requested next hop and
not by iph->daddr.

	You see the places that need to know if rt_gateway
contains nh_gw (via GW) or just a requested next hop (when
nh_gw is 0). It matters for cases where strict source routes
should be on connected network.

	In simple tests things are working without rt_uses_gateway
flag because it is a corner case to see above cases combined
with strict source routing or MTU locking. Not sure if we can
use some trick to support it differently without such flag.

Regards

--
Julian Anastasov <ja@ssi.bg>
