Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0F735C8DA
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242299AbhDLOgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242244AbhDLOf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 10:35:58 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3740C061574;
        Mon, 12 Apr 2021 07:35:39 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id k8so9534433pgf.4;
        Mon, 12 Apr 2021 07:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AlBpKb8Dmz2tPJRvVP1MfO4aijEW0cR+XghSiWKVrYc=;
        b=MpigFGoMuBg2q5u0dKYztkm0z5v2XGyiSEUQIedleCeDOUlsmdHJ6yTXOoVlM077ih
         0CGStS4OU7/Jrhw3cuI47wFsN3xq1GHyRDe/4NfoxNOnQQlfITx9V8TEVeQwbabpT1qU
         CYuJ1PjrKqI+TW5c87dIClz51OOzYqr2/9amyYWdxToHaTxqGJVAVzCvr/p2zgBVgK52
         TZhO7MCEqM+bzzM7K40gLC5Huu8lg9RdWINoOnCCUB0m+ZzycTBgPUHvqet5wDKMKyZw
         DzOHzQMP88SL5CeXaCF8boLZuyMVEtbsOVD1VTw3rLSudkJltNtNISLd3YnZMvM8dT0W
         X7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AlBpKb8Dmz2tPJRvVP1MfO4aijEW0cR+XghSiWKVrYc=;
        b=jbVhJE5uqPXsoEli9rMd3PQ3gWj5BGkKXNHjD6KcllkkW3k4KppRnk6bu3kTX3lBie
         7so00+6TmljPkCDjHBUfHYua7HXGDbdyYYk63vSq+Nl/JWdU8XJ1KkIeujGuLbPaMlo+
         SumBIkJ92+8ANK6DO6oxcfIc3a4AX45sd5v2YE/U6ZjSxfvnK0PV7Ljbc5bgeP9linlw
         cvidUmAivQBJYdvE94wxd+JMDVVhRiCkwTdH0T+pVbXT45jGJ6kNZqd9m06cD8Pbgn05
         +1DxZWx0KexQUCGzRQrQCfA7O5KB/Y+43nu3kwe4CwYmVDSDtCRXEWNbIVsLhvWqFRnL
         ShHg==
X-Gm-Message-State: AOAM530frQAcZAdQ/aUxWfCg2Art3B5Zzr7vob3LAW+pbGfwfCiVii37
        gwgpNUcUqugoWrdBWNk+mJo=
X-Google-Smtp-Source: ABdhPJxCTPcvm43rddB2yMsJeA9Q/HD6eXECmSb9cqetv/X3i76IjjjZlorOWyeOYqVDS5Kjl8yAvg==
X-Received: by 2002:a62:5f47:0:b029:244:6648:a1e with SMTP id t68-20020a625f470000b029024466480a1emr20283701pfb.37.1618238139100;
        Mon, 12 Apr 2021 07:35:39 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id f5sm6656972pfd.62.2021.04.12.07.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 07:35:38 -0700 (PDT)
Date:   Mon, 12 Apr 2021 17:35:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Marek Behun <marek.behun@nic.cz>,
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
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20210412143522.zwjsldqpme6wrcat@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad>
 <20210411185017.3xf7kxzzq2vefpwu@skbuf>
 <878s5nllgs.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878s5nllgs.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 02:46:11PM +0200, Tobias Waldekranz wrote:
> On Sun, Apr 11, 2021 at 21:50, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Sun, Apr 11, 2021 at 08:01:35PM +0200, Marek Behun wrote:
> >> On Sat, 10 Apr 2021 15:34:46 +0200
> >> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> >> 
> >> > Hi,
> >> > this is a respin of the Marek series in hope that this time we can
> >> > finally make some progress with dsa supporting multi-cpu port.
> >> > 
> >> > This implementation is similar to the Marek series but with some tweaks.
> >> > This adds support for multiple-cpu port but leave the driver the
> >> > decision of the type of logic to use about assigning a CPU port to the
> >> > various port. The driver can also provide no preference and the CPU port
> >> > is decided using a round-robin way.
> >> 
> >> In the last couple of months I have been giving some thought to this
> >> problem, and came up with one important thing: if there are multiple
> >> upstream ports, it would make a lot of sense to dynamically reallocate
> >> them to each user port, based on which user port is actually used, and
> >> at what speed.
> >> 
> >> For example on Turris Omnia we have 2 CPU ports and 5 user ports. All
> >> ports support at most 1 Gbps. Round-robin would assign:
> >>   CPU port 0 - Port 0
> >>   CPU port 1 - Port 1
> >>   CPU port 0 - Port 2
> >>   CPU port 1 - Port 3
> >>   CPU port 0 - Port 4
> >> 
> >> Now suppose that the user plugs ethernet cables only into ports 0 and 2,
> >> with 1, 3 and 4 free:
> >>   CPU port 0 - Port 0 (plugged)
> >>   CPU port 1 - Port 1 (free)
> >>   CPU port 0 - Port 2 (plugged)
> >>   CPU port 1 - Port 3 (free)
> >>   CPU port 0 - Port 4 (free)
> >> 
> >> We end up in a situation where ports 0 and 2 share 1 Gbps bandwidth to
> >> CPU, and the second CPU port is not used at all.
> >> 
> >> A mechanism for automatic reassignment of CPU ports would be ideal here.
> >> 
> >> What do you guys think?
> >
> > The reason why I don't think this is such a great idea is because the
> > CPU port assignment is a major reconfiguration step which should at the
> > very least be done while the network is down, to avoid races with the
> > data path (something which this series does not appear to handle).
> > And if you allow the static user-port-to-CPU-port assignment to change
> > every time a link goes up/down, I don't think you really want to force
> > the network down through the entire switch basically.
> >
> > So I'd be tempted to say 'tough luck' if all your ports are not up, and
> > the ones that are are assigned statically to the same CPU port. It's a
> > compromise between flexibility and simplicity, and I would go for
> > simplicity here. That's the most you can achieve with static assignment,
> > just put the CPU ports in a LAG if you want better dynamic load balancing
> > (for details read on below).
> 
> I agree. Unless you only have a few really wideband flows, a LAG will
> typically do a great job with balancing. This will happen without the
> user having to do any configuration at all. It would also perform well
> in "router-on-a-stick"-setups where the incoming and outgoing port is
> the same.
> 
> ...
> 
> > But there is something which is even more interesting about Felix with
> > the ocelot-8021q tagger. Since Marek posted his RFC and until Ansuel
> > posted the follow-up, things have happened, and now both Felix and the
> > Marvell driver support LAG offload via the bonding and/or team drivers.
> > At least for Felix, when using the ocelot-8021q tagged, it should be
> > possible to put the two CPU ports in a hardware LAG, and the two DSA
> > masters in a software LAG, and let the bond/team upper of the DSA
> > masters be the CPU port.
> >
> > I would like us to keep the door open for both alternatives, and to have
> > a way to switch between static user-to-CPU port assignment, and LAG.
> > I think that if there are multiple 'ethernet = ' phandles present in the
> > device tree, DSA should populate a list of valid DSA masters, and then
> > call into the driver to allow it to select which master it prefers for
> > each user port. This is similar to what Ansuel added with 'port_get_preferred_cpu',
> > except that I chose "DSA master" and not "CPU port" for a specific reason.
> > For LAG, the DSA master would be bond0.
> 
> I do not see why we would go through the trouble of creating a
> user-visible bond/team for this. As you detail below, it would mean
> jumping through a lot of hoops. I am not sure there is that much we can
> use from those drivers.
> 
> - We know that the CPU ports are statically up, so there is no "active
>   transmit set" to manage, it always consists of all ports.
> 
> - The LAG members are statically known at boot time via the DT, so we do
>   not need (or want, in fact) any management of that from userspace.
> 
> We could just let the drivers setup the LAG internally, and then do the
> load-balancing in dsa_slave_xmit or provide a generic helper that the
> taggers could use.

It's natural of you to lobby for LAG defined in device tree, since I
know you want to cover the problem for DSA links as well, not only for
CPU ports. That is about the only merit of this solution, however, and I
think we should thoroughly discuss DSA links in the first place, before
even claiming that it is even the best solution for them.

First of all, DSA drivers can now look at a struct net_device *bond when
they establish their link aggregation domains. If we have no struct
net_device *bond we will have to invent a new and parallel API for LAG
on CPU ports and DSA links. If we have to modify DSA anyway, I wonder
why we don't strive to converge towards a unified driver API at least.

Also, the CPU ports might be statically up, but their corresponding DSA
masters may not. You are concentrating only on the switch side, but the
DSA master side is what's more finicky. For example, I really don't want
to see DSA implement its own xmit policies, that will get old really
quick, I really appreciate being able to externalize the TX hashing to a
separate driver, for which the user already has enough knobs to
customize, than to shove that in DT.

Defining a LAG between the CPU ports in the device tree also goes
against the idea that we should not define policy in the kernel.
For that matter, I slept on the overall design and I think that if we
were really purists, we should even drop the whole idea with 'round
robin by default' in the static user-to-CPU port assignment scenario,
and let user space manage _everything_. Meaning that even if there are
multiple 'ethernet = ' phandles in the device tree, DSA will consider
them only to the point of registering CPU ports for all of them. But we
will keep the same dsa_tree_setup_default_cpu -> dsa_tree_find_first_cpu
logic, and there will be only one CPU port / DSA master until user space
requests otherwise. In this model, the crucial aspect of DSA support for
multiple CPU ports will be the ability to have that netlink reconfiguration
while the network is down (or has not even been set up yet). You can see
how, in this world view, your proposal to define a LAG in the device
tree does not smell great.

Of course, I will let Andrew be the supreme judge when it comes to
system design. Simplicity done right is an acquired taste, and I'm
absolutely open to admit that I'm not quite there yet.



As for LAG on DSA links, yes that is going to be interesting. I see two
approaches:

- Similar to how mv88e6xxx just decides all by itself to use DSA instead
  of EDSA tags on the DSA links, maybe there simply are some things that
  the software data path and control path just don't need to care about.
  So I wonder, if there isn't any known case in which it wouldn't 'just
  work' for mv88e6xxx to detect that it has multiple routing ports
  towards the same destination switch, to just go ahead and create a LAG
  between them, no DSA involvement at all.

- I come from a background where I am working with boards with disjoint
  DSA trees:

      +---------------------------------------------------------------+
      | LS1028A                                                       |
      |               +------------------------------+                |
      |               |      DSA master for Felix    |                |
      |               |(internal ENETC port 2: eno2))|                |
      |  +------------+------------------------------+-------------+  |
      |  | Felix embedded L2 switch                                |  |
      |  |                                                         |  |
      |  | +--------------+   +--------------+   +--------------+  |  |
      |  | |DSA master for|   |DSA master for|   |DSA master for|  |  |
      |  | |  SJA1105 1   |   |  SJA1105 2   |   |  SJA1105 3   |  |  |
      |  | |   (swp1)     |   |   (swp2)     |   |   (swp3)     |  |  |
      +--+-+--------------+---+--------------+---+--------------+--+--+

+-----------------------+ +-----------------------+ +-----------------------+
|   SJA1105 switch 1    | |   SJA1105 switch 2    | |   SJA1105 switch 3    |
+-----+-----+-----+-----+ +-----+-----+-----+-----+ +-----+-----+-----+-----+
|sw1p0|sw1p1|sw1p2|sw1p3| |sw2p0|sw2p1|sw2p2|sw2p3| |sw3p0|sw3p1|sw3p2|sw3p3|
+-----+-----+-----+-----+ +-----+-----+-----+-----+ +-----+-----+-----+-----+

You may find this setup to be a little bit odd, but the network
interfaces in this system are:

eno2, swp1, swp2, swp3, sw1p0-sw1p3, sw2p0-sw2p3, sw3p0-sw3p3.

This is because the Felix switch has a dsa,member property of <0 0>,
SJA1105 switch 1 is <1 0>, SJA1105 switch 2 is <2 0> and SJA1105 switch
3 is <3 0>. So each switch is the only switch within its tree. And that
makes Felix the DSA master for 3 DSA switches, while being a DSA switch
itself. This was done this way so that tag stacking 'just works': every
packet is decapsulated of the Felix tag on eno2, then of the SJA1105 tag
on swp1/swp2/swp3.

This setup gives me a lot of visibility into Ethernet port counters on
all ports. Because swp1, swp2, swp3, because are DSA masters, I see not
only their port counters, but also the port counters of the SJA1105 CPU
ports. Great.

But with the ocelot-8021q tagger, imagine a scenario where I make Felix
grok the DSA headers added by SJA1105 (which are also VLAN-based). Then
tag stacking would no longer be necessary. I could convert the swp1,
swp2, swp3 ports from being DSA masters into being out-facing DSA links,
and their net devices would disappear. But then I would lose all
visibility into them! And the strange part in my view is that this is a
100% software implementation-defined layout: if they're DSA masters
they're net devices, if they're DSA links they aren't, when in fact it
is the same hardware just configured differently.

So my idea here is maybe we could unify DSA links and disjoint DSA trees
by exposing net devices for the out-facing DSA links, just for the sake
of:
- port counters both ways
- having a hook point for LAGs

Now don't get me wrong, there are downsides too. For example, the net
device would not be useful for the actual data path. DSA will not use it
for packet processing coming from / going towards the leaves. You _could_
still xmit packets towards an out-facing DSA link, and maybe it would
even be less useless than xmitting them through a DSA master: if, when
you send a packet through the DSA master, that will be untagged, the
same isn't necessarily the case with a DSA link. You can maybe inject a
FORWARD packet encapsulated in a FROM_CPU tag, and the semantics would
be just 'do your thing'. I don't know.

So I would prefer exhausting the first approach, with private LAG setup
on DSA links done in the driver, before even considering the second one.
