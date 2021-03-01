Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342FD328E1A
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 20:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbhCATYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 14:24:04 -0500
Received: from mail1.ugh.no ([178.79.162.34]:54924 "EHLO mail1.ugh.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241310AbhCATVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail1.ugh.no (Postfix) with ESMTP id 406632541F9;
        Mon,  1 Mar 2021 20:21:00 +0100 (CET)
Received: from mail1.ugh.no ([127.0.0.1])
        by localhost (catastrophix.ugh.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pCqYizMJhEYq; Mon,  1 Mar 2021 20:20:59 +0100 (CET)
Received: from [IPv6:2a0a:2780:4e89:40:ab5f:9818:16a8:7606] (unknown [IPv6:2a0a:2780:4e89:40:ab5f:9818:16a8:7606])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: andre@tomt.net)
        by mail.ugh.no (Postfix) with ESMTPSA id ABDB22541F6;
        Mon,  1 Mar 2021 20:20:59 +0100 (CET)
Subject: Re: Multicast routing + sch_fq not working since 4.20 (bisected)
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <4dc5ea60-a157-1af2-84db-7066b9b41da5@tomt.net>
 <CANn89iKe46i21ydMiodb1xKP3Y5EJ582ixRhufaAFx+H_vdEkA@mail.gmail.com>
 <CANn89iKvW=+Q1xMKcQYLh4Ru7L-HeK3Xp_t=5hVyRjS2oT9T3w@mail.gmail.com>
From:   Andre Tomt <andre@tomt.net>
Message-ID: <edef72c4-a141-7321-5154-127e2c7e585e@tomt.net>
Date:   Mon, 1 Mar 2021 20:20:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKvW=+Q1xMKcQYLh4Ru7L-HeK3Xp_t=5hVyRjS2oT9T3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.03.2021 18:23, Eric Dumazet wrote:
> On Mon, Mar 1, 2021 at 6:19 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Mon, Mar 1, 2021 at 6:15 PM Andre Tomt <andre@tomt.net> wrote:
>>>
>>> TLDR; Multicast routing (at least IPv4) in combination with sch_fq is
>>> not working since kernel 4.20-rc1 and up to and including 5.12-rc1.
>>> Other tested qdisc schedulers work fine (pfifo_fast, fq_codel, cake)
>>>
>>> Hello all
>>>
>>> I've been chasing a issue with multicast routing the past few days where
>>> nothing went out on the physical egress port even though:
>>> * the multicast routes were registered and resolved with the correct
>>> interfaces in ip mroute show
>>> * the reverse path was OK
>>> * data was flowing in on the ingress side
>>> * forwarding / mc_forwarding enabled
>>> * registered fine in a nftables log rule in forward (which was accepting
>>> all)
>>> * packets showed up in (local) tcpdump on egress vlan virtual interface
>>>
>>> After some digging, tracing, a bisect, and a kprint to verify, it seems
>>> as the multicast routing code is using a different clock than fq and
>>> setting skb->tstamp to something sch_fq considers far, far into the
>>> future, failing the beyond horizon check.
>>>
>>>
>>> Things immediately starts to work if I do a tc qdisc replace with a
>>> different scheduler, and stops when changing back to fq.
>>>
>>> This stopped working when fq changed to CLOCK_MONOTONIC in
>>> fb420d5d91c1274d5966917725e71f27ed092a85 tcp/fq: move back to
>>> CLOCK_MONOTONIC
>>> Reverting it on top of 4.20-rc1 restores multicast routing with fq.
>>>
>>> from debug printk in fq_enqueue when horizon check fails:
>>> tstamp skb 1614615921893669854 ktime 59949897819
>>>
>>> tstamp skb 1614615921968395652 ktime 60024624355
>>>
>>> tstamp skb 1614615922043160089 ktime 60099388127
>>>
>>>
>>> The setup is a Linux router running FRR bgpd + pimd for multicast
>>> routing. The multicast source is some TV broadcast equipment one more
>>> hop away sending a mpeg transport streams on IPv4, using 1316 byte TS
>>> datagrams (not fragmented, jumbos or anything otherwise funny.)
>>>
>>>
>>> git bisect start
>>>
>>> # bad: [993f0b0510dad98b4e6e39506834dab0d13fd539] sched/topology: Fix
>>> off by one bug
>>>
>>> git bisect bad 993f0b0510dad98b4e6e39506834dab0d13fd539
>>>
>>> # good: [84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d] Linux 4.19
>>>
>>> git bisect good 2241b8bcf2b5f1b01ebb1cbd1231bbbb72230064
>>>
>>> # bad: [50b825d7e87f4cff7070df6eb26390152bb29537] Merge
>>> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
>>>
>>> git bisect bad 50b825d7e87f4cff7070df6eb26390152bb29537
>>>
>>> # bad: [99e9acd85ccbdc8f5785f9e961d4956e96bd6aa5] Merge tag
>>> 'mlx5-updates-2018-10-17' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
>>>
>>> git bisect bad 99e9acd85ccbdc8f5785f9e961d4956e96bd6aa5
>>>
>>> # bad: [d793fb46822ff7408a1767313ef6b12e811baa55] Merge tag
>>> 'wireless-drivers-next-for-davem-2018-10-02' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
>>>
>>> git bisect bad d793fb46822ff7408a1767313ef6b12e811baa55
>>>
>>> # good: [72b0094f918294e6cb8cf5c3b4520d928fbb1a57] tcp: switch
>>> tcp_clock_ns() to CLOCK_TAI base
>>>
>>> git bisect good 72b0094f918294e6cb8cf5c3b4520d928fbb1a57
>>>
>>> # bad: [d5486377b8c526e4f373ec0506c4c5398c99082e] Merge branch '100GbE'
>>> of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue
>>>
>>> git bisect bad d5486377b8c526e4f373ec0506c4c5398c99082e
>>>
>>> # good: [d888f39666774c7debfa34e4e20ba33cf61a6d71] net-ipv4: remove 2
>>> always zero parameters from ipv4_update_pmtu()
>>>
>>> git bisect good d888f39666774c7debfa34e4e20ba33cf61a6d71
>>>
>>> # good: [041a14d2671573611ffd6412bc16e2f64469f7fb] tcp: start receiver
>>> buffer autotuning sooner
>>>
>>> git bisect good 041a14d2671573611ffd6412bc16e2f64469f7fb
>>>
>>> # good: [6871af29b3abe6d6ae3a0e28b8bdf44bd4cb8d30] net: hns3: Add reset
>>> handle for flow director
>>>
>>> git bisect good 6871af29b3abe6d6ae3a0e28b8bdf44bd4cb8d30
>>>
>>> # bad: [024926def6ca95819442699fbecc1fe376253fb9] net: phy: Convert to
>>> using %pOFn instead of device_node.name
>>>
>>> git bisect bad 024926def6ca95819442699fbecc1fe376253fb9
>>>
>>> # good: [297357d1a165cf23cc85a6a7ec32ffc854cbf13c] net: systemport:
>>> Utilize bcm_sysport_set_features() during resume/open
>>>
>>> git bisect good 297357d1a165cf23cc85a6a7ec32ffc854cbf13c
>>>
>>> # good: [a0651d8e2784b189924b4f4f41b901835feef8a4] Merge branch
>>> 'net-systemport-Turn-on-offloads-by-default'
>>>
>>> git bisect good a0651d8e2784b189924b4f4f41b901835feef8a4
>>>
>>> # good: [e3a9667a5bf7e520a1fa24eadccc6010c135ec53] hv_netvsc: Fix
>>> rndis_per_packet_info internal field initialization
>>>
>>> git bisect good e3a9667a5bf7e520a1fa24eadccc6010c135ec53
>>>
>>> # bad: [fb420d5d91c1274d5966917725e71f27ed092a85] tcp/fq: move back to
>>> CLOCK_MONOTONIC
>>>
>>> git bisect bad fb420d5d91c1274d5966917725e71f27ed092a85
>>>
>>> # good: [0ed3015c9964dab7a1693b3e40650f329c16691e] selftests/tls: Fix
>>> recv(MSG_PEEK) & splice() test cases
>>>
>>> git bisect good 0ed3015c9964dab7a1693b3e40650f329c16691e
>>>
>>> # first bad commit: [fb420d5d91c1274d5966917725e71f27ed092a85] tcp/fq:
>>> move back to CLOCK_MONOTONIC
>>>
>>
>> Yes, this change is colliding to anything in RX path forwarding
>> packets to TX path without clearing skb->tstamp
>>
>> We had numerous patches to add the missing clearing :
>>
>> git log --oneline --grep=fb420d5d9
>> c77761c8a59405cb7aa44188b30fffe13fbdd02d netfilter: nf_fwd_netdev:
>> clear timestamp in forwarding path
>> 7980d2eabde82be86c5be18aa3d07e88ec13c6a1 ipvs: clear skb->tstamp in
>> forwarding path
>> 5133498f4ad1123a5ffd4c08df6431dab882cc32 bpf: Clear skb->tstamp in
>> bpf_redirect when necessary
>> 9669fffc1415bb0c30e5d2ec98a8e1c3a418cb9c net: ensure correct
>> skb->tstamp in various fragmenters
>> af5136f95045b6c4bb8a53d2f288a905c3bd6f25 selftests/net: SO_TXTIME with
>> ETF and FQ
>> acced9d2b4dffaca5ce2228d70e6074965d54a27 Merge
>> git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
>> 916f6efae62305796e012e7c3a7884a267cbacbf netfilter: never get/set skb->tstamp
>> 41d1c8839e5f8cb781cc635f12791decee8271b7 net: clear skb->tstamp in
>> bridge forwarding path
>> 8203e2d844d34af247a151d8ebd68553a6e91785 net: clear skb->tstamp in
>> forwarding paths
>> 7236ead1b14923f3ba35cd29cce13246be83f451 act_mirred: clear skb->tstamp
>> on redirect
>> 4c16128b6271e70c8743178e90cccee147858503 net: loopback: clear
>> skb->tstamp before netif_rx()
> 
> based on your description I would try the following fix for IPV4
> 
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index 939792a3881461275b9c7fae5b3a5e0881a59584..c7d59a77c9e2267d66765169e49ff767e5134cb6
> 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -1783,6 +1783,7 @@ static inline int ipmr_forward_finish(struct net
> *net, struct sock *sk,
>          if (unlikely(opt->optlen))
>                  ip_forward_options(skb);
> 
> +       skb->tstamp = 0;
>          return dst_output(net, sk, skb);
>   }
> 

This does indeed solve the issue for IPv4 here
