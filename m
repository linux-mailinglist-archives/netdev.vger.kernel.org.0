Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BB51F9583
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 13:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbgFOLoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 07:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgFOLoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 07:44:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A01CC061A0E;
        Mon, 15 Jun 2020 04:44:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jknXA-0006IH-Pq; Mon, 15 Jun 2020 13:44:12 +0200
Date:   Mon, 15 Jun 2020 13:44:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     dwilder <dwilder@us.ibm.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, wilder@us.ibm.com,
        mkubecek@suse.com
Subject: Re: [(RFC) PATCH ] NULL pointer dereference on rmmod iptable_mangle.
Message-ID: <20200615114412.GD16460@breakpoint.cc>
References: <20200603212516.22414-1-dwilder@us.ibm.com>
 <20200603220502.GD28263@breakpoint.cc>
 <72692f32471b5d2eeef9514bb2c9ba51@linux.vnet.ibm.com>
 <20200604103815.GE28263@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604103815.GE28263@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> dwilder <dwilder@us.ibm.com> wrote:
> > > Since the netns core already does an unconditional synchronize_rcu after
> > > the pre_exit hooks this would avoid the problem as well.
> > 
> > Something like this?  (un-tested)
> 
> Yes.
> 
> > diff --git a/net/ipv4/netfilter/iptable_mangle.c
> > b/net/ipv4/netfilter/iptable_mangle.c
> > index bb9266ea3785..0d448e4d5213 100644
> > --- a/net/ipv4/netfilter/iptable_mangle.c
> > +++ b/net/ipv4/netfilter/iptable_mangle.c
> > @@ -100,15 +100,26 @@ static int __net_init iptable_mangle_table_init(struct
> > net *net)
> >         return ret;
> >  }
> > 
> > +static void __net_exit iptable_mangle_net_pre_exit(struct net *net)
> > +{
> > +       struct xt_table *table = net->ipv4.iptable_mangle;
> > +
> > +       if (mangle_ops)
> > +               nf_unregister_net_hooks(net, mangle_ops,
> > +                       hweight32(table->valid_hooks));
> > +}
> 
> You probably need if (table) here, not mangle_ops.
> I'm not sure if it makes sense to add a new
> 
> xt_unregister_table_hook() helper, I guess one would have to try
> and see if that reduces copy&paste programming or not.
> 
> >  static void __net_exit iptable_mangle_net_exit(struct net *net)
> >  {
> >         if (!net->ipv4.iptable_mangle)
> >                 return;
> > -       ipt_unregister_table(net, net->ipv4.iptable_mangle, mangle_ops);
> > +       ipt_unregister_table(net, net->ipv4.iptable_mangle, NULL);
> 
> I guess the 3rd arg could be removed from the helper.
> 
> But yes, this looks like what I had in mind.

Will there be a followup?  Otherwise I will place this on my todo-list.

Thanks.
