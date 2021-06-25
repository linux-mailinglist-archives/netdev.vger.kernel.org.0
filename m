Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D493B4206
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 13:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFYLCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 07:02:20 -0400
Received: from relay.sw.ru ([185.231.240.75]:51496 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhFYLCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 07:02:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=Y8Tmva5LSabemDAgTdVRUCEIMwXrcd8byL8UmD6LHt8=; b=jEsSz18eBqmDJtmOi/0
        A7QYi8L+sEcbp+CyBTX1AKSlBKH+l06jZcL5iXtQ1dag1AyIBEtgdSAQgqwIHAsTZTDIloaYsWdVu
        gOaPxI4ncz2CYWmVwcNoeerLQvZgJ7Y5VqM6vh4OLTWlHSRZ5zmYs9rjPnEq5EVe4o0qI8jsV7A=;
Received: from [192.168.15.9] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lWQcG-001nm6-AH; Fri, 25 Jun 2021 13:59:57 +0300
Date:   Fri, 25 Jun 2021 13:59:54 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv2 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-Id: <20210625135954.44ecba2e8875141380a52d7d@virtuozzo.com>
In-Reply-To: <20210624083647.0f173c4b@hermes.local>
References: <20210622150330.28014-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210624152812.29031-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210624083647.0f173c4b@hermes.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Jun 2021 08:36:47 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Thu, 24 Jun 2021 18:28:12 +0300
> Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:
> 
> > We started to use in-kernel filtering feature which allows to get only needed
> > tables (see iproute_dump_filter()). From the kernel side it's implemented in
> > net/ipv4/fib_frontend.c (inet_dump_fib), net/ipv6/ip6_fib.c (inet6_dump_fib).
> > The problem here is that behaviour of "ip route save" was changed after
> > c7e6371bc ("ip route: Add protocol, table id and device to dump request").
> > If filters are used, then kernel returns ENOENT error if requested table is absent,
> > but in newly created net namespace even RT_TABLE_MAIN table doesn't exist.
> > It is really allocated, for instance, after issuing "ip l set lo up".
> > 
> > Reproducer is fairly simple:
> > $ unshare -n ip route save > dump
> > Error: ipv4: FIB table does not exist.
> > Dump terminated
> > 
> > Expected result here is to get empty dump file (as it was before this change).
> > 
> > v2: reworked, so, now it takes into account NLMSGERR_ATTR_MSG
> > (see nl_dump_ext_ack_done() function). We want to suppress error messages
> > in stderr about absent FIB table from kernel too.
> > 
> > Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Stephen Hemminger <stephen@networkplumber.org>
> > Cc: Andrei Vagin <avagin@gmail.com>
> > Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> > Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> > ---
> >  include/libnetlink.h |  5 +++++
> >  ip/iproute.c         |  8 +++++++-
> >  lib/libnetlink.c     | 31 ++++++++++++++++++++++++++-----
> >  3 files changed, 38 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/libnetlink.h b/include/libnetlink.h
> > index b9073a6a..93c22a09 100644
> > --- a/include/libnetlink.h
> > +++ b/include/libnetlink.h
> > @@ -121,6 +121,11 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
> >  			void *arg, __u16 nc_flags);
> >  #define rtnl_dump_filter(rth, filter, arg) \
> >  	rtnl_dump_filter_nc(rth, filter, arg, 0)
> > +int rtnl_dump_filter_suppress_rtnl_errmsg_nc(struct rtnl_handle *rth,
> > +		     rtnl_filter_t filter,
> > +		     void *arg1, __u16 nc_flags, const int *errnos);
> > +#define rtnl_dump_filter_suppress_rtnl_errmsg(rth, filter, arg, errnos) \
> > +	rtnl_dump_filter_suppress_rtnl_errmsg_nc(rth, filter, arg, 0, errnos)
> >  int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
> >  	      struct nlmsghdr **answer)
> >  	__attribute__((warn_unused_result));
> > diff --git a/ip/iproute.c b/ip/iproute.c
> > index 5853f026..796d6d17 100644
> > --- a/ip/iproute.c
> > +++ b/ip/iproute.c
> > @@ -1734,6 +1734,8 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
> >  	char *od = NULL;
> >  	unsigned int mark = 0;
> >  	rtnl_filter_t filter_fn;
> > +	/* last 0 is array trailing */
> > +	int suppress_rtnl_errnos[2] = { 0, 0 };
> >  
> 
> The design would be clearer if there were two arguments rather than magic array of size 2.
> Also these are being used as boolean.
I've reworked that to make code cleaner and sent v3.
I decided to keep array on the stack but introduced initializer-macro SUPPRESS_ERRORS_INIT which
can be extended anytime (now it allows to suppress up to 3 errors).

In iplink_vrf.c rtnl_talk_suppress_rtnl_errmsg function is used, which allows to suppress all errors,
but sometime it may be helpful to suppress just a few errors. That's a reason why I didn't implemented
variant which allows to suppress only one errno (ENOENT) for my particular case.

Thanks,
Alex
