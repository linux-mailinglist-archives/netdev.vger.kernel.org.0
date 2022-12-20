Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3C1652395
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 16:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiLTPSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 10:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLTPSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 10:18:12 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A0D0765A;
        Tue, 20 Dec 2022 07:18:11 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 48B6B35023;
        Tue, 20 Dec 2022 17:18:09 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id DE98434F96;
        Tue, 20 Dec 2022 17:18:03 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id DB4243C07CC;
        Tue, 20 Dec 2022 17:18:00 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 2BKFHvIe064995;
        Tue, 20 Dec 2022 17:17:58 +0200
Date:   Tue, 20 Dec 2022 17:17:57 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     Jon Maxwell <jmaxwell37@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
In-Reply-To: <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
Message-ID: <4ed37beb-7562-f5e4-8d8-4665a653b8c2@ssi.bg>
References: <20221218234801.579114-1-jmaxwell37@gmail.com> <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Tue, 20 Dec 2022, Paolo Abeni wrote:

> On Mon, 2022-12-19 at 10:48 +1100, Jon Maxwell wrote:
> > Sending Ipv6 packets in a loop via a raw socket triggers an issue where a 
> > route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly 
> > consumes the Ipv6 max_size threshold which defaults to 4096 resulting in 
> > these warnings:
> > 
> > [1]   99.187805] dst_alloc: 7728 callbacks suppressed
> > [2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> > .
> > .
> > [300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
> 
> If I read correctly, the maximum number of dst that the raw socket can
> use this way is limited by the number of packets it allows via the
> sndbuf limit, right?
> 
> Are other FLOWI_FLAG_KNOWN_NH users affected, too? e.g. nf_dup_ipv6,
> ipvs, seg6?

	For IPVS there is no sndbuf limit. IPVS uses this flag
when receiving packets from world (destined to some local Virtual
IP) and then diverts/redirects the packets (without changing daddr)
to one of its backend servers on the LAN (no RTF_GATEWAY on such routes).
So, for each packet IPVS requests output route with FLOWI_FLAG_KNOWN_NH
flag and then sends the packet to backend server (nexthop) using
this route attached to the skb. Packet rate is usually high. The goal is 
nexthop to be used from the route, not from the IP header. KNOWN_NH 
means "nexthop is provided in route, not in daddr". As for the 
implementation details in ipv6, I can not comment. But all users that
set the flag wants this, to send packet where daddr can be != nexthop.

> @DavidA: why do we need to create RTF_CACHE clones for KNOWN_NH flows?

Regards

--
Julian Anastasov <ja@ssi.bg>

