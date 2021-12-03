Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9B0467382
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 09:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379360AbhLCIxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 03:53:30 -0500
Received: from peace.netnation.com ([204.174.223.2]:36488 "EHLO
        peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379362AbhLCIx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 03:53:29 -0500
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Dec 2021 03:53:28 EST
Received: from sim by peace.netnation.com with local (Exim 4.92)
        (envelope-from <sim@hostway.ca>)
        id 1mt41s-0001aj-4m; Fri, 03 Dec 2021 00:34:52 -0800
Date:   Fri, 3 Dec 2021 00:34:52 -0800
From:   Simon Kirby <sim@hostway.ca>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        lvs-devel@vger.kernel.org
Subject: Re: Inability to IPVS DR with nft dnat since 9971a514ed26
Message-ID: <20211203083452.GA13536@hostway.ca>
References: <20190327062650.GA10700@hostway.ca>
 <20190327093027.gmflo27icuhr326p@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327093027.gmflo27icuhr326p@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 27, 2019 at 10:30:27AM +0100, Florian Westphal wrote:

> Simon Kirby <sim@hostway.ca> wrote:
> > We have been successfully using nft dnat and IPVS in DR mode on 4.9, 4.14
> > kernels, but since upgrading to 4.19, such rules now appear to miss the
> > IPVS input hook and instead appear to hit localhost (and "tcpdump -ni lo"
> > shows the packets) instead of being forwarded to a real server.
> > 
> > I bisected this to 9971a514ed2697e542f3984a6162eac54bb1da98 ("netfilter:
> > nf_nat: add nat type hooks to nat core").
> > 
> > It should be pretty easy to see this with a minimal setup:
> > 
> > /etc/nftables.conf:
> > 
> > table ip nat {
> >         chain prerouting {
> >                 type nat hook prerouting priority 0;
> > 
> > 		ip daddr $ext_ip dnat to $vip
> > 	}
> > 	chain postrouting {
> > 		type nat hook postrouting priority 100;
> > 
> > 		# In theory this hook no longer needed since this commit,
> > 		# but we also need to do some unrelated snatting.
> > 	}
> > }
> > 
> > /etc/sysctl.conf:
> > 	
> > net.ipv4.conf.all.accept_local = 1
> > net.ipv4.vs.conntrack = 1
> > 
> > IPVS DR setup:
> > 
> > ipvsadm -A -t $vip:80 -s wrr
> > ipvsadm -a -t $vip:80 -r $real_ip:80 -g -w 100
> 
> I have a hard time figuring out how to expand $ext_ip, $vip and $real_ip,
> and where to place those addresses on the nft machine.

I had some time to set up some test VMs for this, which I can post if
you'd like (several GB), or I can tarball up the configs.

Our setup still doesn't work in 5.15, and we have some LVS servers held
up on 4.14 kernels that are the last working stable branch.

LVS expects the VIPs to route to loopback in order to reach the ipvs
hook, and since 9971a514ed2697e542f3984a6162eac54bb1da98 ("netfilter:
nf_nat: add nat type hooks to nat core"), the nftrace output changes to
show that the ipvs_vs_dr_xmit packet is oif "lo" rather than "enp1s0".

With perf probes, I found that the reason the outbound device is changing
is that there is an nft hook that ends up calling ip_route_me_harder().

This function is not called prior to this change, but we can make it be
called even on 4.14 by hooking nat output (with no rules) or route output
with anything modifying, such as "mark set 1".

We just didn't happen to hook this previously, so it worked for us, but
after this change, all hooks (including output) are always applied.

# perf probe -a 'ip_route_me_harder%return retval=$retval'
# perf record -g -e probe:ip_route_me_harder__return -aR sleep 4
(send a test connection)
# perf script
swapper     0 [000]  1654.547622: probe:ip_route_me_harder__return: (ffffffff819ac910 <- ffffffffa002b8f6) retval=0x0
        ffffffff810564b0 kretprobe_trampoline+0x0 (vmlinux-4.14.252)
        ffffffffa0084090 nft_nat_ipv4_local_fn+0x10 ([nft_chain_nat_ipv4])
        ffffffff8193e793 nf_hook_slow+0x43 (vmlinux-4.14.252)
        ffffffffa004af2b ip_vs_dr_xmit+0x18b ([ip_vs])
        ffffffffa003fb2e ip_vs_in+0x58e ([ip_vs])
        ffffffffa00400d1 ip_vs_local_request4+0x21 ([ip_vs])
        ffffffffa00400e9 ip_vs_remote_request4+0x9 ([ip_vs])
        ffffffff8193e793 nf_hook_slow+0x43 (vmlinux-4.14.252)
        ffffffff8195c48b ip_local_deliver+0x7b (vmlinux-4.14.252)
        ffffffff8195c0b8 ip_rcv_finish+0x1f8 (vmlinux-4.14.252)
        ffffffff8195c7b7 ip_rcv+0x2e7 (vmlinux-4.14.252)
        ffffffff818dc113 __netif_receive_skb_core+0x883 (vmlinux-4.14.252)
(pruned a bit)

On 5.15, the trace is similar, but nft_nat_ipv4_local_fn is gone
(nft_nat_do_chain is inlined).

nftrace output through "nft monitor trace" shows it changing the packet
dest between filter output and nat postrouting:

...
trace id 32904fd3 ip filter output packet: oif "enp1s0" @ll,0,112 0x5254009039555254002ace280800 ip saddr 192.168.7.1 ip daddr 10.99.99.10 ip dscp 0x04 ip ecn not-ect ip ttl 63 ip id 5753 ip length 60 tcp sport 58620 tcp dport 80 tcp flags == syn tcp window 64240
trace id 32904fd3 ip filter output verdict continue
trace id 32904fd3 ip filter output policy accept
trace id 32904fd3 ip nat postrouting packet: iif "enp1s0" oif "lo" ether saddr 52:54:00:2a:ce:28 ether daddr 52:54:00:90:39:55 ip saddr 192.168.7.1 ip daddr 10.99.99.10 ip dscp 0x04 ip ecn not-ect ip ttl 63 ip id 5753 ip length 60 tcp sport 58620 tcp dport 80 tcp flags == syn tcp window 64240
trace id 32904fd3 ip nat postrouting verdict continue
trace id 32904fd3 ip nat postrouting policy accept

On 4.14 without hooking nat output, the oif for nat postrouting remains
unchanged ("enp1s0").

If we avoid the nftables dnat rule and connect directly to the LVS VIP,
it still works on newer kernels, I suspect because nf_nat_ipv4_fn()
doesn't match. If we dnat directly to the DR VIP without LVS, it works
because the dest is not loopback, as expected. It's the combination of
these two that used to work, but now doesn't.

Our specific use case here is that we're doing the dnat from public to
rfc1918 space, and the rfc1918 LVS VIPs support some hairpinning cases.

Any ideas?

Simon-
