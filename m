Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B0D467F85
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 22:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383311AbhLCVw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 16:52:26 -0500
Received: from mg.ssi.bg ([193.238.174.37]:41494 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344131AbhLCVwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 16:52:25 -0500
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 6173524B47;
        Fri,  3 Dec 2021 23:48:56 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 7002E24BA8;
        Fri,  3 Dec 2021 23:48:53 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id EE0E43C0332;
        Fri,  3 Dec 2021 23:48:52 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 1B3LmpVc038846;
        Fri, 3 Dec 2021 23:48:52 +0200
Date:   Fri, 3 Dec 2021 23:48:51 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Kirby <sim@hostway.ca>
cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org
Subject: Re: Inability to IPVS DR with nft dnat since 9971a514ed26
In-Reply-To: <20211203083452.GA13536@hostway.ca>
Message-ID: <ae4d64a5-8742-a392-4866-edce08e3bdd@ssi.bg>
References: <20190327062650.GA10700@hostway.ca> <20190327093027.gmflo27icuhr326p@breakpoint.cc> <20211203083452.GA13536@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Fri, 3 Dec 2021, Simon Kirby wrote:

> I had some time to set up some test VMs for this, which I can post if
> you'd like (several GB), or I can tarball up the configs.
> 
> Our setup still doesn't work in 5.15, and we have some LVS servers held
> up on 4.14 kernels that are the last working stable branch.
> 
> LVS expects the VIPs to route to loopback in order to reach the ipvs
> hook, and since 9971a514ed2697e542f3984a6162eac54bb1da98 ("netfilter:
> nf_nat: add nat type hooks to nat core"), the nftrace output changes to
> show that the ipvs_vs_dr_xmit packet is oif "lo" rather than "enp1s0".
> 
> With perf probes, I found that the reason the outbound device is changing
> is that there is an nft hook that ends up calling ip_route_me_harder().

	Yes, this call is supposed to route locally generated
packets after daddr is translated by Netfilter. But IPVS uses
LOCAL_OUT hook to post packets to real servers. If you use
DR method, daddr is not changed (remains VIP) but packet's route
points to the real server (different from VIP). Any rerouting
will assign wrong route.

	Such code that compares tuple.dst.u3.ip with
tuple.src.u3.ip (for !dir) in nf_nat_ipv4_local_fn() is present
in old kernels. So, I'm not sure how you escaped it. The
only possible way is if net.ipv4.vs.conntrack is 0 because
in this case ip_vs_send_or_cont() calls ip_vs_notrack() to set 
IP_CT_UNTRACKED and ct becomes NULL (untracked skb is skipped
by NAT).

> This function is not called prior to this change, but we can make it be
> called even on 4.14 by hooking nat output (with no rules) or route output
> with anything modifying, such as "mark set 1".

	In this case it hits the mangle code (ipt_mangle_out).

> We just didn't happen to hook this previously, so it worked for us, but
> after this change, all hooks (including output) are always applied.
> 
> # perf probe -a 'ip_route_me_harder%return retval=$retval'
> # perf record -g -e probe:ip_route_me_harder__return -aR sleep 4
> (send a test connection)
> # perf script
> swapper     0 [000]  1654.547622: probe:ip_route_me_harder__return: (ffffffff819ac910 <- ffffffffa002b8f6) retval=0x0
>         ffffffff810564b0 kretprobe_trampoline+0x0 (vmlinux-4.14.252)
>         ffffffffa0084090 nft_nat_ipv4_local_fn+0x10 ([nft_chain_nat_ipv4])
>         ffffffff8193e793 nf_hook_slow+0x43 (vmlinux-4.14.252)
>         ffffffffa004af2b ip_vs_dr_xmit+0x18b ([ip_vs])
>         ffffffffa003fb2e ip_vs_in+0x58e ([ip_vs])
>         ffffffffa00400d1 ip_vs_local_request4+0x21 ([ip_vs])
>         ffffffffa00400e9 ip_vs_remote_request4+0x9 ([ip_vs])
>         ffffffff8193e793 nf_hook_slow+0x43 (vmlinux-4.14.252)
>         ffffffff8195c48b ip_local_deliver+0x7b (vmlinux-4.14.252)
>         ffffffff8195c0b8 ip_rcv_finish+0x1f8 (vmlinux-4.14.252)
>         ffffffff8195c7b7 ip_rcv+0x2e7 (vmlinux-4.14.252)
>         ffffffff818dc113 __netif_receive_skb_core+0x883 (vmlinux-4.14.252)
> (pruned a bit)
> 
> On 5.15, the trace is similar, but nft_nat_ipv4_local_fn is gone
> (nft_nat_do_chain is inlined).
> 
> nftrace output through "nft monitor trace" shows it changing the packet
> dest between filter output and nat postrouting:
> 
> ...
> trace id 32904fd3 ip filter output packet: oif "enp1s0" @ll,0,112 0x5254009039555254002ace280800 ip saddr 192.168.7.1 ip daddr 10.99.99.10 ip dscp 0x04 ip ecn not-ect ip ttl 63 ip id 5753 ip length 60 tcp sport 58620 tcp dport 80 tcp flags == syn tcp window 64240
> trace id 32904fd3 ip filter output verdict continue
> trace id 32904fd3 ip filter output policy accept
> trace id 32904fd3 ip nat postrouting packet: iif "enp1s0" oif "lo" ether saddr 52:54:00:2a:ce:28 ether daddr 52:54:00:90:39:55 ip saddr 192.168.7.1 ip daddr 10.99.99.10 ip dscp 0x04 ip ecn not-ect ip ttl 63 ip id 5753 ip length 60 tcp sport 58620 tcp dport 80 tcp flags == syn tcp window 64240
> trace id 32904fd3 ip nat postrouting verdict continue
> trace id 32904fd3 ip nat postrouting policy accept
> 
> On 4.14 without hooking nat output, the oif for nat postrouting remains
> unchanged ("enp1s0").

	Is net.ipv4.vs.conntrack set in 4.14 ?

> If we avoid the nftables dnat rule and connect directly to the LVS VIP,
> it still works on newer kernels, I suspect because nf_nat_ipv4_fn()
> doesn't match. If we dnat directly to the DR VIP without LVS, it works

	The problem is that the DNAT rule schedules translation
which is detected by this check:

	if (ct->tuplehash[dir].tuple.dst.u3.ip !=
	    ct->tuplehash[!dir].tuple.src.u3.ip) {
		err = ip_route_me_harder(state->net, state->sk, skb, RTN_UNSPEC);

	But it happens if ct is not NULL (vs/conntrack=1).

> because the dest is not loopback, as expected. It's the combination of
> these two that used to work, but now doesn't.
> 
> Our specific use case here is that we're doing the dnat from public to
> rfc1918 space, and the rfc1918 LVS VIPs support some hairpinning cases.
> 
> Any ideas?

	As nf_nat_ipv4_local_fn is just for LOCAL_OUT, an additional
skb->dev check can help to skip the code when packet comes from
network (not from local stack):

	if (ret != NF_ACCEPT || skb->dev)
		return ret;

	But I'm not sure if such hack breaks something.

	Second option is to check if daddr/dport actually changed
in our call to nf_nat_ipv4_fn() but it is more complex.
It will catch that packet was already DNAT-ed in PRE_ROUTING,
it was already routed locally and now it is passed on LOCAL_OUT
by IPVS for second DNAT+rerouting which is not wanted by IPVS.

Regards

--
Julian Anastasov <ja@ssi.bg>

