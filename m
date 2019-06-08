Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B6C39B61
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 08:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfFHGkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 02:40:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfFHGkA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 02:40:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E49D03082E64;
        Sat,  8 Jun 2019 06:39:54 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C2DF01001B08;
        Sat,  8 Jun 2019 06:39:51 +0000 (UTC)
Date:   Sat, 8 Jun 2019 08:39:47 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Martin Lau <kafai@fb.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        "Wei Wang" <weiwan@google.com>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Message-ID: <20190608083947.6ee972e6@redhat.com>
In-Reply-To: <20190608061548.yhy3xkunxllnjrsr@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1559872578.git.sbrivio@redhat.com>
        <3bf118a6a3870e72011b6105b63fa0d012094394.1559872578.git.sbrivio@redhat.com>
        <20190608061548.yhy3xkunxllnjrsr@kafai-mbp.dhcp.thefacebook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sat, 08 Jun 2019 06:40:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 8 Jun 2019 06:15:51 +0000
Martin Lau <kafai@fb.com> wrote:

> > @@ -473,12 +473,22 @@ static int fib6_dump_node(struct fib6_walker *w)
> >  	struct fib6_info *rt;
> >  
> >  	for_each_fib6_walker_rt(w) {
> > -		res = rt6_dump_route(rt, w->args);
> > -		if (res < 0) {
> > +		res = rt6_dump_route(rt, w->args, w->skip_in_node);
> > +		if (res) {
> >  			/* Frame is full, suspend walking */
> >  			w->leaf = rt;
> > +
> > +			/* We'll restart from this node, so if some routes were
> > +			 * already dumped, skip them next time.
> > +			 */
> > +			if (res > 0)
> > +				w->skip_in_node += res;
> > +			else
> > +				w->skip_in_node = 0;  
> I am likely missing something.  It is not obvious to me why skip_in_node
> can go backward to 0 here when res < 0.

I'm not taking into account the case where we initially manage to dump
routes, and on a second attempt the buffer is smaller so we can't dump
any, so here I considered that -1 would only happen the first time we
hit a given node.

> Should skip_in_node be strictly increasing to ensure forward progress?

Yes, I guess that would be more robust. I'll change that.

> Would it be more intuitive to change the return value of
> rt6_dump_route() such that
> -1: done with this node
> >=0: number of routes filled in this round but still some more to be done?  
> 
> then:
> if (res >= 0) {
> 	w->leaf = rt;
> 	w->skip_in_node += res;
> 	return 1;
> }

Hm, maybe, I don't really have a preference. Returning 0 on success
looked more canonical, but your version is a bit more terse after all.
Sure, I can turn it that way.

> > @@ -4871,20 +4875,69 @@ int rt6_dump_route(struct fib6_info *rt, void *p_arg)
> >  	if ((filter->flags & RTM_F_PREFIX) &&
> >  	    !(rt->fib6_flags & RTF_PREFIX_RT)) {
> >  		/* success since this is not a prefix route */
> > -		return 1;
> > +		return 0;
> >  	}
> >  	if (filter->filter_set) {
> >  		if ((filter->rt_type && rt->fib6_type != filter->rt_type) ||
> >  		    (filter->dev && !fib6_info_uses_dev(rt, filter->dev)) ||
> >  		    (filter->protocol && rt->fib6_protocol != filter->protocol)) {
> > -			return 1;
> > +			return 0;
> >  		}
> >  		flags |= NLM_F_DUMP_FILTERED;
> >  	}
> >  
> > -	return rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
> > -			     RTM_NEWROUTE, NETLINK_CB(arg->cb->skb).portid,
> > -			     arg->cb->nlh->nlmsg_seq, flags);
> > +	if (!(filter->flags & RTM_F_CLONED)) {
> > +		if (skip) {
> > +			skip--;
> > +		} else if (rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL,
> > +					 0, RTM_NEWROUTE,
> > +					 NETLINK_CB(arg->cb->skb).portid,
> > +					 arg->cb->nlh->nlmsg_seq, flags)) {
> > +			return -1;
> > +		} else {  
> If the v1 email thread will be concluded to dump exceptions only when cloned
> flag is set, it may need some changes in this function.

Indeed, it would also look less ugly (skip_in_node is only for
exceptions at that point).

-- 
Stefano
