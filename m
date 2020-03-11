Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0030181ABB
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgCKOFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 10:05:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:59082 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgCKOFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:05:22 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jC1z4-0006YO-9Y; Wed, 11 Mar 2020 15:05:18 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jC1z3-0008E4-SM; Wed, 11 Mar 2020 15:05:17 +0100
Subject: Re: [PATCH nf-next 3/3] netfilter: Introduce egress hook
To:     Lukas Wunner <lukas@wunner.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>
References: <cover.1583927267.git.lukas@wunner.de>
 <14ab7e5af20124a34a50426fd570da7d3b0369ce.1583927267.git.lukas@wunner.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a57687ae-2da6-ca2a-1c84-e4332a5e4556@iogearbox.net>
Date:   Wed, 11 Mar 2020 15:05:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <14ab7e5af20124a34a50426fd570da7d3b0369ce.1583927267.git.lukas@wunner.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25748/Wed Mar 11 12:08:41 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/20 12:59 PM, Lukas Wunner wrote:
> Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
> handle_ing() under unique static key") introduced the ability to
> classify packets on ingress.
> 
> Allow the same on egress.  Position the hook immediately before a packet
> is handed to tc and then sent out on an interface, thereby mirroring the
> ingress order.  This order allows marking packets in the netfilter
> egress hook and subsequently using the mark in tc.  Another benefit of
> this order is consistency with a lot of existing documentation which
> says that egress tc is performed after netfilter hooks.
> 
> Egress hooks already exist for the most common protocols, such as
> NF_INET_LOCAL_OUT or NF_ARP_OUT, and those are to be preferred because
> they are executed earlier during packet processing.  However for more
> exotic protocols, there is currently no provision to apply netfilter on
> egress.  A common workaround is to enslave the interface to a bridge and

Sorry for late reply, but still NAK. The primary use-case for this patch set
is out of tree module which you mentioned last time [0] ...

   There's another reason I chose netfilter over tc:  I need to activate the
   filter from a kernel module, hence need an in-kernel (rather than user space)
   API.

   netfilter provides that via nf_register_net_hook(), I couldn't find
   anything similar for tc.  And an egress netfilter hook seemed like
   an obvious missing feature given the presence of an ingress hook.

   The module I need this for is out-of-tree:
   https://github.com/RevolutionPi/piControl/commit/da199ccd2099

   In my experience the argument that a feature is needed for an out-of-tree
   module holds zero value upstream.  If there's no in-tree user, the feature
   isn't merged, I've seen this more than enough.  Which is why I didn't mention
   it in the first place.

   For our use case I wouldn't even need the nft user space support which I
   posted separately, I just implemented it for completeness and to increase
   acceptability of the present series.

... and as you mentioned there's local out and post routing already where you
can mark packets, so no need to make the fast-path slower for exotic protocols
which can be solved through other means.

   [0] https://lore.kernel.org/netdev/20191123142305.g2kkaudhhyui22fq@wunner.de/

> use ebtables, or to resort to tc.  But when the ingress hook was
> introduced, consensus was that users should be given the choice to use
> netfilter or tc, whichever tool suits their needs best:
> https://lore.kernel.org/netdev/20150430153317.GA3230@salvia/
> 
> There have also been occasional user requests for a netfilter egress
> hook in the past, e.g.:
> https://www.spinics.net/lists/netfilter/msg50038.html
> 
> Performance measurements with pktgen surprisingly show a speedup rather
> than a slowdown with this commit:
> 
> * Without this commit:
>    Result: OK: 34240933(c34238375+d2558) usec, 100000000 (60byte,0frags)
>    2920481pps 1401Mb/sec (1401830880bps) errors: 0
> 
> * With this commit:
>    Result: OK: 33997299(c33994193+d3106) usec, 100000000 (60byte,0frags)
>    2941410pps 1411Mb/sec (1411876800bps) errors: 0

So you are suggesting that we've just optimized the stack by adding more
hooks to it ...?

> * Without this commit + tc egress:
>    Result: OK: 39022386(c39019547+d2839) usec, 100000000 (60byte,0frags)
>    2562631pps 1230Mb/sec (1230062880bps) errors: 0
> 
> * With this commit + tc egress:
>    Result: OK: 37604447(c37601877+d2570) usec, 100000000 (60byte,0frags)
>    2659259pps 1276Mb/sec (1276444320bps) errors: 0
> 
> * With this commit + nft egress:
>    Result: OK: 41436689(c41434088+d2600) usec, 100000000 (60byte,0frags)
>    2413320pps 1158Mb/sec (1158393600bps) errors: 0
> 
> Tested on a bare-metal Core i7-3615QM, each measurement was performed
> three times to verify that the numbers are stable.
> 
> Commands to perform a measurement:
> modprobe pktgen
> echo "add_device lo@3" > /proc/net/pktgen/kpktgend_3
> samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh -i 'lo@3' -n 100000000
> 
> Commands for testing tc egress:
> tc qdisc add dev lo clsact
> tc filter add dev lo egress protocol ip prio 1 u32 match ip dst 4.3.2.1/32
> 
> Commands for testing nft egress:
> nft add table netdev t
> nft add chain netdev t co \{ type filter hook egress device lo priority 0 \; \}
> nft add rule netdev t co ip daddr 4.3.2.1/32 drop
> 
> All testing was performed on the loopback interface to avoid distorting
> measurements by the packet handling in the low-level Ethernet driver.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
