Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B273435D2BA
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343534AbhDLVvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:51:16 -0400
Received: from lists.nic.cz ([217.31.204.67]:55936 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238235AbhDLVvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 17:51:15 -0400
Received: from thinkpad (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 0E5E013FF05;
        Mon, 12 Apr 2021 23:50:55 +0200 (CEST)
Date:   Mon, 12 Apr 2021 23:50:54 +0200
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
Message-ID: <20210412235054.73754df9@thinkpad>
In-Reply-To: <8735vvkxju.fsf@waldekranz.com>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
        <20210411200135.35fb5985@thinkpad>
        <20210411185017.3xf7kxzzq2vefpwu@skbuf>
        <878s5nllgs.fsf@waldekranz.com>
        <20210412213045.4277a598@thinkpad>
        <8735vvkxju.fsf@waldekranz.com>
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

On Mon, 12 Apr 2021 23:22:45 +0200
Tobias Waldekranz <tobias@waldekranz.com> wrote:

> On Mon, Apr 12, 2021 at 21:30, Marek Behun <marek.behun@nic.cz> wrote:
> > On Mon, 12 Apr 2021 14:46:11 +0200
> > Tobias Waldekranz <tobias@waldekranz.com> wrote:
> >  
> >> I agree. Unless you only have a few really wideband flows, a LAG will
> >> typically do a great job with balancing. This will happen without the
> >> user having to do any configuration at all. It would also perform well
> >> in "router-on-a-stick"-setups where the incoming and outgoing port is
> >> the same.  
> >
> > TLDR: The problem with LAGs how they are currently implemented is that
> > for Turris Omnia, basically in 1/16 of configurations the traffic would
> > go via one CPU port anyway.
> >
> >
> >
> > One potencial problem that I see with using LAGs for aggregating CPU
> > ports on mv88e6xxx is how these switches determine the port for a
> > packet: only the src and dst MAC address is used for the hash that
> > chooses the port.
> >
> > The most common scenario for Turris Omnia, for example, where we have 2
> > CPU ports and 5 user ports, is that into these 5 user ports the user
> > plugs 5 simple devices (no switches, so only one peer MAC address for
> > port). So we have only 5 pairs of src + dst MAC addresses. If we simply
> > fill the LAG table as it is done now, then there is 2 * 0.5^5 = 1/16
> > chance that all packets would go through one CPU port.
> >
> > In order to have real load balancing in this scenario, we would either
> > have to recompute the LAG mask table depending on the MAC addresses, or
> > rewrite the LAG mask table somewhat randomly periodically. (This could
> > be in theory offloaded onto the Z80 internal CPU for some of the
> > switches of the mv88e6xxx family, but not for Omnia.)  
> 
> I thought that the option to associate each port netdev with a DSA
> master would only be used on transmit. Are you saying that there is a
> way to configure an mv88e6xxx chip to steer packets to different CPU
> ports depending on the incoming port?
>
> The reason that the traffic is directed towards the CPU is that some
> kind of entry in the ATU says so, and the destination of that entry will
> either be a port vector or a LAG. Of those two, only the LAG will offer
> any kind of balancing. What am I missing?

Via port vectors you can "load balance" by ports only, i.e. input port X
-> trasmit via CPU port Y.

When using LAGs, you are load balancing via hash(src MAC | dst mac)
only. This is better in some ways. But what I am saying is that if the
LAG mask table is static, as it is now implemented in mv88e6xxx code,
then for many scenarios there is a big probability of no load balancing
at all. For Turris Omnia for example there is 6.25% probability that
the switch chip will send all traffic to the CPU via one CPU port.
This is because the switch chooses the LAG port only from the hash of
dst+src MAC address. (By the 1/16 = 6.25% probability I mean that for
cca 1 in 16 customers, the switch would only use one port when sending
data to the CPU).

The round robin solution here is therefore better in this case.

