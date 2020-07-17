Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2873122390D
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgGQKNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgGQKNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:13:52 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B658FC061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:13:51 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jwNNE-0000bd-5c; Fri, 17 Jul 2020 12:13:48 +0200
Date:   Fri, 17 Jul 2020 12:13:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        aconole@redhat.com, sbrivio@redhat.com
Subject: Re: [PATCH net-next 2/3] vxlan: allow to disable path mtu learning
 on encap socket
Message-ID: <20200717101348.GS32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
 <20200712200705.9796-3-fw@strlen.de>
 <20200716123301.07a1c723@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716123301.07a1c723@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Sun, 12 Jul 2020 22:07:04 +0200 Florian Westphal wrote:
> > While its already possible to configure VXLAN to never set the DF bit
> > on packets that it sends, it was not yet possible to tell kernel to
> > not update the encapsulation sockets path MTU.
> > 
> > This can be used to tell ip stack to always use the interface MTU
> > when VXLAN wants to send a packet.
> > 
> > When packets are routed, VXLAN use skbs existing dst entries to
> > propagate the MTU update to the overlay, but on a bridge this doesn't
> > work (no routing, no dst entry, and no ip forwarding takes place, so
> > nothing emits icmp packet w. mtu update to sender).
> > 
> > This is only useful when VXLAN is used as a bridge port and the
> > network is known to accept packets up to the link MTU to avoid bogus
> > pmtu icmp packets from stopping tunneled traffic.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Seems like a general problem for L2 tunnels, could you broaden the CC
> list a little, perhaps? Maybe there is a best practice here we can
> follow?

Yes, this is a general problem.
I will send a v2 with an expanded cover letter/cc list.

> > diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> > index a43c97b13924..ceb2940a2a62 100644
> > --- a/drivers/net/vxlan.c
> > +++ b/drivers/net/vxlan.c
> > @@ -3316,6 +3316,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
> >  	[IFLA_VXLAN_REMCSUM_NOPARTIAL]	= { .type = NLA_FLAG },
> >  	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
> >  	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
> > +	[IFLA_VXLAN_PMTUDISC]	= { .type = NLA_U8 },
> 
> NLA_POLICY_RANGE?

Done.

> Also I'm not seeing .strict_start_type here.

Did not know this was established practice to set it unconditionally
for new attributes.  Will make this change.

> > +	if (data[IFLA_VXLAN_PMTUDISC]) {
> > +		int pmtuv = nla_get_u8(data[IFLA_VXLAN_PMTUDISC]);
> > +
> > +		if (pmtuv < IP_PMTUDISC_DONT) {
> > +			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_PMTUDISC], "PMTUDISC Value < 0");
> > +			return -EOPNOTSUPP;
> > +		}
> > +		if (pmtuv > IP_PMTUDISC_OMIT) {
> > +			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_PMTUDISC], "PMTUDISC Value > IP_PMTUDISC_OMIT");
> > +			return -EOPNOTSUPP;
> > +		}
> > +
> > +		conf->pmtudisc = 1;
> > +		conf->pmtudiscv = pmtuv;
> > +	}
> 
> Can these conflict with DF settings?

Not really.  DF setting only controls wheter outer header has
DF set or not.

So, for DF-clear mode, this patch isn't needed from a functional
point of view, as endpoint will fragment packets.

For inherit/set mode, traffic will get blocked forever.

There are two cases to consider:
1. Setup is known to handle MTU-sized packets, but something
   generates a bogus route exception (perhaps during some
   reconfiguration in the datacenter..?).
2. The route exception is genuine, i.e. ignoring the exception
   doesn't solve anything and tunneled traffic will be tossed/dropped
   by middlebox.

For 2) we will need something else entirely, but what/where/who
is reponsible to handle this is unknown at the moment.

So, this is just about 1).  I will rewrite the cover letter to make
this more clear.

> > diff --git a/include/net/vxlan.h b/include/net/vxlan.h
> > index 3a41627cbdfe..1414cfa2005f 100644
> > --- a/include/net/vxlan.h
> > +++ b/include/net/vxlan.h
> > @@ -220,6 +220,8 @@ struct vxlan_config {
> >  	unsigned long		age_interval;
> >  	unsigned int		addrmax;
> >  	bool			no_share;
> > +	u8			pmtudisc:1;
> > +	u8			pmtudiscv:3;
> 
> I must say for my myopic eyes discerning pmtudisc vs pmtudiscv took an
> effort. Could you find better names?

Ugh, I'm not good at that.  I went with 'set_pmtudisc' and
'pmtudisc_value' for now.

Thanks for reviewing.
