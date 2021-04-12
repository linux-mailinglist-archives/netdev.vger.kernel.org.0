Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4BA35D2C9
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343561AbhDLV5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:57:20 -0400
Received: from lists.nic.cz ([217.31.204.67]:58218 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238235AbhDLV5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 17:57:20 -0400
Received: from thinkpad (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 370F11407CA;
        Mon, 12 Apr 2021 23:56:58 +0200 (CEST)
Date:   Mon, 12 Apr 2021 23:56:57 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20210412235657.4cc201b5@thinkpad>
In-Reply-To: <87zgy3jhr1.fsf@waldekranz.com>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
        <20210411200135.35fb5985@thinkpad>
        <20210411185017.3xf7kxzzq2vefpwu@skbuf>
        <878s5nllgs.fsf@waldekranz.com>
        <20210412213045.4277a598@thinkpad>
        <8735vvkxju.fsf@waldekranz.com>
        <20210412213402.vwvon2fdtzf4hnrt@skbuf>
        <87zgy3jhr1.fsf@waldekranz.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Apr 2021 23:49:22 +0200
Tobias Waldekranz <tobias@waldekranz.com> wrote:

> On Tue, Apr 13, 2021 at 00:34, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Apr 12, 2021 at 11:22:45PM +0200, Tobias Waldekranz wrote:  
> >> On Mon, Apr 12, 2021 at 21:30, Marek Behun <marek.behun@nic.cz> wrote:  
> >> > On Mon, 12 Apr 2021 14:46:11 +0200
> >> > Tobias Waldekranz <tobias@waldekranz.com> wrote:
> >> >  
> >> >> I agree. Unless you only have a few really wideband flows, a LAG will
> >> >> typically do a great job with balancing. This will happen without the
> >> >> user having to do any configuration at all. It would also perform well
> >> >> in "router-on-a-stick"-setups where the incoming and outgoing port is
> >> >> the same.  
> >> >
> >> > TLDR: The problem with LAGs how they are currently implemented is that
> >> > for Turris Omnia, basically in 1/16 of configurations the traffic would
> >> > go via one CPU port anyway.
> >> >
> >> >
> >> >
> >> > One potencial problem that I see with using LAGs for aggregating CPU
> >> > ports on mv88e6xxx is how these switches determine the port for a
> >> > packet: only the src and dst MAC address is used for the hash that
> >> > chooses the port.
> >> >
> >> > The most common scenario for Turris Omnia, for example, where we have 2
> >> > CPU ports and 5 user ports, is that into these 5 user ports the user
> >> > plugs 5 simple devices (no switches, so only one peer MAC address for
> >> > port). So we have only 5 pairs of src + dst MAC addresses. If we simply
> >> > fill the LAG table as it is done now, then there is 2 * 0.5^5 = 1/16
> >> > chance that all packets would go through one CPU port.
> >> >
> >> > In order to have real load balancing in this scenario, we would either
> >> > have to recompute the LAG mask table depending on the MAC addresses, or
> >> > rewrite the LAG mask table somewhat randomly periodically. (This could
> >> > be in theory offloaded onto the Z80 internal CPU for some of the
> >> > switches of the mv88e6xxx family, but not for Omnia.)  
> >> 
> >> I thought that the option to associate each port netdev with a DSA
> >> master would only be used on transmit. Are you saying that there is a
> >> way to configure an mv88e6xxx chip to steer packets to different CPU
> >> ports depending on the incoming port?
> >> 
> >> The reason that the traffic is directed towards the CPU is that some
> >> kind of entry in the ATU says so, and the destination of that entry will
> >> either be a port vector or a LAG. Of those two, only the LAG will offer
> >> any kind of balancing. What am I missing?
> >> 
> >> Transmit is easy; you are already in the CPU, so you can use an
> >> arbitrarily fancy hashing algo/ebpf classifier/whatever to load balance
> >> in that case.  
> >
> > Say a user port receives a broadcast frame. Based on your understanding
> > where user-to-CPU port assignments are used only for TX, which CPU port
> > should be selected by the switch for this broadcast packet, and by which
> > mechanism?  
> 
> AFAIK, the only option available to you (again, if there is no LAG set
> up) is to statically choose one CPU port per entry. But hopefully Marek
> can teach me some new tricks!
> 
> So for any known (since the broadcast address is loaded in the ATU it is
> known) destination (b/m/u-cast), you can only "load balance" based on
> the DA. You would also have to make sure that unknown unicast and
> unknown multicast is only allowed to egress one of the CPU ports.
> 
> If you have a LAG OTOH, you could include all CPU ports in the port
> vectors of those same entries. The LAG mask would then do the final
> filtering so that you only send a single copy to the CPU.

The problem is that when the mv88e6xxx switch chooses the LAG entry, it
takes into account only hash(src MAC | dst MAC). There is no other
option, Marvell switches are unable to take more information into this
decision (for example hash of the IP + TCP/UDP header).

And in many usecases, there are only a couple of this (src,dst) MAC
pairs. On Turris Omnia in most cases there are only 5 such pairs,
because the user plugs into the router only 5 devices.

So for each of these 5 (src,dst) MAC pairs, there is probability 1/2
that the packet will be sent via CPU port 0. So 1/32 probability that
all packets will be sent via CPU port 0, and the same probability that
all packets will be sent via CPU port 1.

This means that in 1/16 of cases the LAG is useless in this scenario.
