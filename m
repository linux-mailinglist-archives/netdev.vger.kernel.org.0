Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C378357172
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfFZTTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:19:49 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43100 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbfFZTTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 15:19:49 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hgDSL-0005Y4-8x; Wed, 26 Jun 2019 21:19:45 +0200
Date:   Wed, 26 Jun 2019 21:19:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     wenxu@ucloud.cn, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3 nf-next] netfilter:nf_flow_table: Support bridge type
 flow offload
Message-ID: <20190626191945.2mktaqrcrfcrfc66@breakpoint.cc>
References: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
 <1561545148-11978-2-git-send-email-wenxu@ucloud.cn>
 <20190626183816.3ux3iifxaal4ffil@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626183816.3ux3iifxaal4ffil@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> > diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> > index 0016bb8..9af01ef 100644
> > --- a/net/netfilter/nf_flow_table_ip.c
> > +++ b/net/netfilter/nf_flow_table_ip.c
> > -	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
> > +	if (family == NFPROTO_IPV4) {
> > +		iph = ip_hdr(skb);
> > +		ip_decrease_ttl(iph);
> > +
> > +		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
> > +		skb_dst_set_noref(skb, &rt->dst);
> > +		neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
> > +	} else {
> > +		const struct net_bridge_port *p;
> > +
> > +		if (vlan_tag && (p = br_port_get_rtnl_rcu(state->in)))
> > +			__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, vlan_tag);
> > +		else
> > +			__vlan_hwaccel_clear_tag(skb);
> > +
> > +		br_dev_queue_push_xmit(state->net, state->sk, skb);
> 
> Won't that result in a module dep on bridge?
> 
> Whats the idea with this patch?
> 
> Do you see a performance improvement when bypassing bridge layer? If so,
> how much?
> 
> I just wonder if its really cheaper than not using bridge conntrack in
> the first place :-)

Addendum: Did you look at the nftables fwd expression?  Maybe you can use
it as a simpler way to speed things up?
