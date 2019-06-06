Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621273816B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfFFW7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:59:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbfFFW7F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 18:59:05 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03FB730832D1;
        Thu,  6 Jun 2019 22:59:00 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A60492B9D7;
        Thu,  6 Jun 2019 22:58:56 +0000 (UTC)
Date:   Fri, 7 Jun 2019 00:58:52 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Martin Lau <kafai@fb.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        "Wei Wang" <weiwan@google.com>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Message-ID: <20190607005852.2aee8784@redhat.com>
In-Reply-To: <20190606223707.s2fyhnqnt3ygdtdj@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
        <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
        <20190606214456.orxy6274xryxyfww@kafai-mbp.dhcp.thefacebook.com>
        <20190607001747.4ced02c7@redhat.com>
        <20190606223707.s2fyhnqnt3ygdtdj@kafai-mbp.dhcp.thefacebook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 06 Jun 2019 22:59:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 22:37:11 +0000
Martin Lau <kafai@fb.com> wrote:

> On Fri, Jun 07, 2019 at 12:17:47AM +0200, Stefano Brivio wrote:
> > On Thu, 6 Jun 2019 21:44:58 +0000
> > Martin Lau <kafai@fb.com> wrote:
> >   
> > > > +	if (!(filter->flags & RTM_F_CLONED)) {
> > > > +		err = rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
> > > > +				    RTM_NEWROUTE,
> > > > +				    NETLINK_CB(arg->cb->skb).portid,
> > > > +				    arg->cb->nlh->nlmsg_seq, flags);
> > > > +		if (err)
> > > > +			return err;
> > > > +	} else {
> > > > +		flags |= NLM_F_DUMP_FILTERED;
> > > > +	}
> > > > +
> > > > +	bucket = rcu_dereference(rt->rt6i_exception_bucket);
> > > > +	if (!bucket)
> > > > +		return 0;
> > > > +
> > > > +	for (i = 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
> > > > +		hlist_for_each_entry(rt6_ex, &bucket->chain, hlist) {
> > > > +			if (rt6_check_expired(rt6_ex->rt6i))
> > > > +				continue;
> > > > +
> > > > +			err = rt6_fill_node(net, arg->skb, rt,
> > > > +					    &rt6_ex->rt6i->dst,
> > > > +					    NULL, NULL, 0, RTM_NEWROUTE,
> > > > +					    NETLINK_CB(arg->cb->skb).portid,
> > > > +					    arg->cb->nlh->nlmsg_seq, flags);    
> > > Thanks for the patch.
> > > 
> > > A question on when rt6_fill_node() returns -EMSGSIZE while dumping the
> > > exception bucket here.  Where will the next inet6_dump_fib() start?  
> > 
> > And thanks for reviewing.
> > 
> > It starts again from the same node, see fib6_dump_node(): w->leaf = rt;
> > where rt is the fib6_info where we failed dumping, so we won't skip
> > dumping any node.  
> If the same node will be dumped, does it mean that it will go through this
> loop and iterate all exceptions again?

Yes (well, all the exceptions for that node).

> > This also means that to avoid sending duplicates in the case where at
> > least one rt6_fill_node() call goes through and one fails, we would
> > need to track the last bucket and entry sent, or, alternatively, to
> > make sure we can fit the whole node before dumping.  
> My another concern is the dump may never finish.

That's not a guarantee in general, even without this, because in theory
the skb passed might be small enough that we can't even fit a single
node without exceptions.

We could add a guard on w->leaf not being the same before and after the
walk in inet6_dump_fib() and, if it is, terminate the dump. I just
wonder if we have to do this at all -- I can't find this being done
anywhere else (at a quick look at least).

By the way, we can also trigger a never-ending dump by touching the
tree frequently enough during a dump: it would always start again from
the root, see fib6_dump_table().

-- 
Stefano
