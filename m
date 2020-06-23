Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F04204C50
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 10:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731830AbgFWI01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 04:26:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47797 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731665AbgFWI00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 04:26:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592900784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vol2UxkFhJ/UbxwdgJACR/sH9uDf5nGs+UnfGA0Nn5k=;
        b=YL5Glnfhq6Sm6oM6cGOiFz9AhwJ/56ShGjCQ1XnONq8FM6hdRj9qPyeJdlZjPBiEAc7dKQ
        FZqDQAzkh6l6xHj0erCqxamIo+AQ73JFkJkmloR2sWF+nJjYMxaSfMfo56Kvm+67sr2JiQ
        bmuHpmp+SQ+e917K0aqlPIXup9FvDvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-UQ-Js05-O9-zkkhOBcvUaA-1; Tue, 23 Jun 2020 04:26:20 -0400
X-MC-Unique: UQ-Js05-O9-zkkhOBcvUaA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6AA418FE861;
        Tue, 23 Jun 2020 08:26:16 +0000 (UTC)
Received: from ovpn-114-234.ams2.redhat.com (ovpn-114-234.ams2.redhat.com [10.36.114.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B313171692;
        Tue, 23 Jun 2020 08:26:14 +0000 (UTC)
Message-ID: <651188bf96724d55c964fe4e3ed9e97968397eb0.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] ipv6: fib6: avoid indirect calls from
 fib6_rule_lookup
From:   Paolo Abeni <pabeni@redhat.com>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Luigi Rizzo <lrizzo@google.com>
Date:   Tue, 23 Jun 2020 10:26:13 +0200
In-Reply-To: <CAMzD94T8Sm8_8B2=3iST8P6RZOnUEAEViM4Q5FKdTh7keOpd5Q@mail.gmail.com>
References: <20200620031419.219106-1-brianvv@google.com>
         <20200620031419.219106-2-brianvv@google.com>
         <daac77afd98bd9c10c4c52309067b8dfbba3fad0.camel@redhat.com>
         <CAMzD94QUSR8T3vMAfjVf_MxCPrj_gtPYhEqNCyPqsJ1rdA=G9g@mail.gmail.com>
         <8427633745b43a1bbd9a0b288ceb2bb6f9e977aa.camel@redhat.com>
         <CAMzD94T8Sm8_8B2=3iST8P6RZOnUEAEViM4Q5FKdTh7keOpd5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-06-22 at 12:26 -0700, Brian Vazquez wrote:
> 
> 
> On Mon, Jun 22, 2020 at 11:00 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Mon, 2020-06-22 at 09:25 -0700, Brian Vazquez wrote:
> > > 
> > > Hi Paolo
> > > On Mon, Jun 22, 2020 at 3:13 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > Hi,
> > > > 
> > > > On Fri, 2020-06-19 at 20:14 -0700, Brian Vazquez wrote:
> > > > > @@ -111,11 +111,13 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
> > > > >       } else {
> > > > >               struct rt6_info *rt;
> > > > >  
> > > > > -             rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
> > > > > +             rt = pol_lookup_func(lookup,
> > > > > +                          net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
> > > > >               if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
> > > > >                       return &rt->dst;
> > > > >               ip6_rt_put_flags(rt, flags);
> > > > > -             rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
> > > > > +             rt = pol_lookup_func(lookup,
> > > > > +                          net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
> > > > >               if (rt->dst.error != -EAGAIN)
> > > > >                       return &rt->dst;
> > > > >               ip6_rt_put_flags(rt, flags);
> > > > 
> > > > Have you considered instead factoring out the slice of
> > > > fib6_rule_lookup() using indirect calls to an header file? it looks
> > > > like here (gcc 10.1.1) it sufficent let the compiler use direct calls
> > > > and will avoid the additional branches.
> > > > 
> > > 
> > > Sorry I couldn't get your point. Could you elaborate more, please? Or provide an example?
> > 
> > I mean: I think we can avoid the indirect calls even without using the
> > ICW, just moving the relevant code around - in a inline function in the
> > header files.
> 
>  
> Oh I see your point now, yeah this could work but only for the path where there's no custom_rules, right?? So we still need the ICW for the other case. 
> 
> > e.g. with the following code - rough, build-tested only experiment -
> > the gcc 10.1.1 is able to use direct calls
> > for ip6_pol_route_lookup(), ip6_pol_route_output(), etc.
> > 
> > Cheers,
> > 
> > Paolo
> > ---
> > diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
> > index 3f615a29766e..c1b5ac890cd2 100644
> > --- a/include/net/ip6_fib.h
> > +++ b/include/net/ip6_fib.h
> > @@ -430,9 +430,6 @@ struct fib6_entry_notifier_info {
> > 
> >  struct fib6_table *fib6_get_table(struct net *net, u32 id);
> >  struct fib6_table *fib6_new_table(struct net *net, u32 id);
> > -struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
> > -                                  const struct sk_buff *skb,
> > -                                  int flags, pol_lookup_t lookup);
> > 
> >  /* called with rcu lock held; can return error pointer
> >   * caller needs to select path
> > diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> > index 2a5277758379..fe1c2102ffe8 100644
> > --- a/include/net/ip6_route.h
> > +++ b/include/net/ip6_route.h
> > @@ -336,4 +336,50 @@ u32 ip6_mtu_from_fib6(const struct fib6_result *res,
> >  struct neighbour *ip6_neigh_lookup(const struct in6_addr *gw,
> >                                    struct net_device *dev, struct sk_buff *skb,
> >                                    const void *daddr);
> > +
> > +#ifdef CONFIG_IPV6_MULTIPLE_TABLES
> > +struct rt6_info *__fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
> > +                                   const struct sk_buff *skb,
> > +                                   int flags, pol_lookup_t lookup);
> > +static inline struct dst_entry *
> > +fib6_rule_lookup(struct net *net, struct flowi6 *fl6, const struct sk_buff *skb,
> > +                int flags, pol_lookup_t lookup)
> > +{
> > +       struct rt6_info *rt;
> > +
> > +       if (!net->ipv6.fib6_has_custom_rules) {
> > +               rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
> > +               if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
> > +                       return &rt->dst;
> > +               ip6_rt_put_flags(rt, flags);
> > +               rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
> > +               if (rt->dst.error != -EAGAIN)
> > +                       return &rt->dst;
> > +               ip6_rt_put_flags(rt, flags);
> > +       } else {
> > +               rt = __fib6_rule_lookup(net, fl6, skb, flags, lookup); 
> 
>  
> When we have custom rules this function will do the following stack trace:
> fib_rules_lookup
> |_  fib6_rule_action
>       |_ __fib6_rule_action
>   So we will still need the ICW in __fib6_rule_action, right?

Indeed! I originally did not notice your patch takes care also of the
custum rules code path.

I'm ok with plain usage of ICW everywhere.

Just an additional question, why this order:

+       return INDIRECT_CALL_4(lookup,
+                              ip6_pol_route_lookup,
+                              ip6_pol_route_output,
+                              ip6_pol_route_input,
+                              __ip6_route_redirect,

?

aren't *route_output and *route_input more frequent than *route_lookup?

Thanks!

Paolo

