Return-Path: <netdev+bounces-3484-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CAF707864
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 05:21:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4418B28176F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 03:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530B3392;
	Thu, 18 May 2023 03:21:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B8D19B
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB86C433EF;
	Thu, 18 May 2023 03:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684380085;
	bh=EYMWlWANNq/47Y0VDfYo8pFapPyAX0zQyQaaoeZ6duI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NEm3QyJNhXSg2XN8ICpgGn/dsdjbjmVMsoG5cthm/Qyb45X0dUnGsTrHMmyCzj62g
	 SE/6tju0IatDCexF8O3qdBQhQnjgCO6wKUWT1WgiDl+3iMpBs+5wyZooX0GxH5hW7p
	 x7efSZs2ahjTDDt8obEqU8gqdkylJGjok6GHeClAYVSB9QPD+OzZFvpFl+hXNjFLlq
	 F9r7aD0S4A9IXBTGGlwlkeNjCc+8d5Qkx9LgwcKIGfaocciwdqhy2bgiv1+AkKy2e4
	 70qQQqpnBOatB1vUGBg01muKi3EtZq9d5koc3RDFmGciJc/56YA03gpUiX3/4BMb/W
	 G4EifmciGXx2g==
Message-ID: <61248e45-c619-d5f2-95a0-5971593fbe8d@kernel.org>
Date: Wed, 17 May 2023 21:21:24 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [RFC PATCH net-next v2 0/2] Mitigate the Issue of Expired Routes
 in Linux IPv6 Routing Tables
Content-Language: en-US
To: Kui-Feng Lee <thinker.li@gmail.com>, netdev@vger.kernel.org,
 ast@kernel.org, martin.lau@linux.dev, kernel-team@meta.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc: Kui-Feng Lee <kuifeng@meta.com>, Ido Schimmel <idosch@idosch.org>
References: <20230517183337.190591-1-kuifeng@meta.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230517183337.190591-1-kuifeng@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/23 12:33 PM, Kui-Feng Lee wrote:
> This RFC is resent to ensure maintainers getting awared.  Also remove
> some forward declarations that we don't use anymore.
> 
> The size of a Linux IPv6 routing table can become a big problem if not
> managed appropriately.  Now, Linux has a garbage collector to remove
> expired routes periodically.  However, this may lead to a situation in
> which the routing path is blocked for a long period due to an
> excessive number of routes.

I take it this problem was seen internally to your org? Can you give
representative numbers on how many routes, stats on the blocked time,
and reason for the large time block (I am guessing the notifier)?

> 
> For example, years ago, there is a commit about "ICMPv6 Packet too big
> messages".  The root cause is that malicious ICMPv6 packets were sent
> back for every small packet sent to them. These packets have to
> lookup/insert a new route, putting hosts under high stress due to
> contention on a spinlock while one is stuck in fib6_run_gc().
> 
> Why Route Expires
> =================
> 
> Users can add IPv6 routes with an expiration time manually. However,
> the Neighbor Discovery protocol may also generate routes that can
> expire.  For example, Router Advertisement (RA) messages may create a
> default route with an expiration time. [RFC 4861] For IPv4, it is not
> possible to set an expiration time for a route, and there is no RA, so
> there is no need to worry about such issues.
> 
> Create Routes with Expires
> ==========================
> 
> You can create routes with expires with the  command.
> 
> For example,
> 
>     ip -6 route add 2001:b000:591::3 via fe80::5054:ff:fe12:3457 \ 
>         dev enp0s3 expires 30


> 
> The route that has been generated will be deleted automatically in 30
> seconds.
> 
> GC of FIB6
> ==========
> 
> The function called fib6_run_gc() is responsible for performing
> garbage collection (GC) for the Linux IPv6 stack. It checks for the
> expiration of every route by traversing the tries of routing
> tables. The time taken to traverse a routing table increases with its
> size. Holding the routing table lock during traversal is particularly
> undesirable. Therefore, it is preferable to keep the lock for the
> shortest possible duration.
> 
> Solution
> ========
> 
> The cause of the issue is keeping the routing table locked during the
> traversal of large tries. To address this, the patchset eliminates
> garbage collection that does the tries traversal and introduces
> individual timers for each route that eventually expires.  Walking
> trials are no longer necessary with the timers. Additionally, the time
> required to handle a timer is consistent.

And then for the number of routes mentioned above what does that mean
for having a timer per route? If this is 10's or 100's of 1000s of
expired routes what does that mean for the timer subsystem dealing with
that number of entries on top of other timers and the impact on the
timer softirq? ie., are you just moving the problem around.

did you consider other solutions? e.g., if it is the notifier, then
perhaps the entries can be deleted from the fib and then put into a list
for cleanup in a worker thread.

> 
> If the expiration time is long, the timer becomes less precise. The
> drawback is that the longer the expiration time, the less accurate the
> timer.
> 
> Kui-Feng Lee (2):
>   net: Remove expired routes with separated timers.
>   net: Remove unused code and variables.
> 
>  include/net/ip6_fib.h    |  21 ++---
>  include/net/ip6_route.h  |   2 -
>  include/net/netns/ipv6.h |   6 --
>  net/ipv6/addrconf.c      |   8 +-
>  net/ipv6/ip6_fib.c       | 162 ++++++++++++++++++---------------------
>  net/ipv6/ndisc.c         |   4 +-
>  net/ipv6/route.c         | 120 ++---------------------------
>  7 files changed, 95 insertions(+), 228 deletions(-)
> 


