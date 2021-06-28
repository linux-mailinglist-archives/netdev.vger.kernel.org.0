Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8611B3B5926
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 08:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhF1GeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 02:34:02 -0400
Received: from relay.sw.ru ([185.231.240.75]:59590 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230134AbhF1GeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 02:34:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=YArVMin5Uut/hE7wbY4tZjoiYdp600teAAPpPCpZA/E=; b=sKo0rJx0E/NEZKfRTku
        C/nKrcr14kaQITpD5k/sAb0AJ0vZoDGjo6YobzL5BxyzqZruZiaAciYUUdnaIycDWTINgZwSqtwSX
        dpVkU4qlZZU4axa3JexCXd+L4jQ1dHUhBfe/xE4KWpzDeFqFqSKyJj2orlj8wAe1T1dgknxIDX0=;
Received: from [192.168.15.15] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lXRrA-0020eJ-Gk; Mon, 28 Jun 2021 09:31:33 +0300
Date:   Mon, 28 Jun 2021 09:31:32 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv3 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-Id: <20210628093132.fe747541cbf0c708ac4da640@virtuozzo.com>
In-Reply-To: <20210627145424.181beae5@hermes.local>
References: <20210624152812.29031-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210627145424.181beae5@hermes.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Jun 2021 14:54:24 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Fri, 25 Jun 2021 13:44:40 +0300
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
> > v3: reworked to make code clearer. Introduced rtnl_suppressed_errors(),
> > rtnl_suppress_error() helpers. User may suppress up to 3 errors (may be
> > easily extened by changing SUPPRESS_ERRORS_INIT macro).
> > 
> > Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Stephen Hemminger <stephen@networkplumber.org>
> > Cc: Andrei Vagin <avagin@gmail.com>
> > Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> > Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> > ---
> >  include/libnetlink.h | 37 +++++++++++++++++++++++++++++++++++++
> >  ip/iproute.c         |  7 ++++++-
> >  lib/libnetlink.c     | 27 ++++++++++++++++++++++-----
> >  3 files changed, 65 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/libnetlink.h b/include/libnetlink.h
> > index b9073a6a..c41f714a 100644
> > --- a/include/libnetlink.h
> > +++ b/include/libnetlink.h
> > @@ -121,6 +121,43 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
> >  			void *arg, __u16 nc_flags);
> >  #define rtnl_dump_filter(rth, filter, arg) \
> >  	rtnl_dump_filter_nc(rth, filter, arg, 0)
> > +int rtnl_dump_filter_suppress_rtnl_errmsg_nc(struct rtnl_handle *rth,
> > +		     rtnl_filter_t filter,
> > +		     void *arg1, __u16 nc_flags, const int *errnos);
> > +#define rtnl_dump_filter_suppress_rtnl_errmsg(rth, filter, arg, errnos) \
> > +	rtnl_dump_filter_suppress_rtnl_errmsg_nc(rth, filter, arg, 0, errnos)
> 
> Sorry, this is getting really ugly.

Sorry, I apparently overdid it in refactoring ;)

> 
> It is almost as bad as looking at Windows source code with the extremely long
> function names.

Sure, I will choose shorter names.

> 
> It would be better to refactor the already overload  rtnl_dump_filter into sub
> components and different parts could use the sub functions as needed.
> 
> > +#define SUPPRESS_ERRORS_INIT { 0, 0, 0, 0 }
> 
> Why do you need a special macro just use {} in those places.

It seems like I wrongly interpreted you words about "magic array of size 2"
>>The design would be clearer if there were two arguments rather than magic array of size 2.
If I understand you correctly, you wanted to say that it's not fully convenient to read and
see "magic" initializator { 0, 0, 0, 0 } or similar. (why four zeroes? why not 3 or 1?)
So, I've decided to make macro for this initializer like we have macros for linked lists
initializators in kernel, for instance. Another reason is that If someone need to skip more than
3 errors, he can change initializer size and helper function rtnl_suppress_error() will
take new size into account.

What I want to implement:
1. Possibility to skip several errors in rtnl_dump_filter
2. Not use malloc for allocation of "errors" array (because array is really small and
malloc needs free, so it's easier to make errors with memleak in the future)
3. I'm trying not to change original function rtnl_dump_filter() signature because
it's used in other places and that's a stable API.
4. We want to allow programmer to dynamically add skipped errors. It means that
user not specifying array of skipped errors directly like { ENOENT, ENOSUPP, 0 }, but
can write something like:
if (ignore_old_kernel_errors)
    rtnl_suppress_error(errors, ENOSUPP)
if (some_another_reason)
    rtnl_suppress_error(errors, ENOENT)


Maybe some of my points not valid for us and I can throw it?

Thank you for review! ;)

Alex.

> 
> 
> > +static inline int rtnl_suppressed_error(const int *errnos, int err_no)
> 
> Inline is unnecessary here.
> 
> > +{
> > +	/* errnos is 0 terminated array or NULL */
> > +	while (errnos && *errnos) {
> > +		if (err_no == *errnos)
> > +			return 1;
> > +
> > +		errnos++;
> > +	}
> > +
> > +	return 0;
> > +}
> > +static inline void rtnl_suppress_error(int *errnos, int err_no)
> Blank line between functions, Again no inline
> 
> > +{
> > +	/* last 0 is trailing for errnos array */
> > +	int max = sizeof((int[])SUPPRESS_ERRORS_INIT) /
> > +			sizeof(int) - 1;
> > +
> > +	if (errnos == NULL)
> > +		return;
> > +
> > +	for (int i = 0; i < max; i++) {
> > +		if (errnos[i] == err_no)
> > +			break;
> > +
> > +		if (!errnos[i]) {
> > +			errnos[i] = err_no;
> > +			break;
> > +		}
> > +	}
> > +}
> >  int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
> >  	      struct nlmsghdr **answer)
> >  	__attribute__((warn_unused_result));
> > diff --git a/ip/iproute.c b/ip/iproute.c
> > index 5853f026..532ca724 100644
> > --- a/ip/iproute.c
> > +++ b/ip/iproute.c
> > @@ -1734,6 +1734,7 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
> >  	char *od = NULL;
> >  	unsigned int mark = 0;
> >  	rtnl_filter_t filter_fn;
> > +	int suppress_rtnl_errnos[] = SUPPRESS_ERRORS_INIT;
> >  
> >  	if (action == IPROUTE_SAVE) {
> >  		if (save_route_prep())
> > @@ -1939,7 +1940,11 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
> >  
> >  	new_json_obj(json);
> >  
> > -	if (rtnl_dump_filter(&rth, filter_fn, stdout) < 0) {
> > +	if (filter.tb == RT_TABLE_MAIN)
> > +		rtnl_suppress_error(suppress_rtnl_errnos, ENOENT);
> > +
> > +	if (rtnl_dump_filter_suppress_rtnl_errmsg(&rth, filter_fn, stdout,
> > +						  suppress_rtnl_errnos) < 0) {
> >  		fprintf(stderr, "Dump terminated\n");
> >  		return -2;
> >  	}
> > diff --git a/lib/libnetlink.c b/lib/libnetlink.c
> > index c958aa57..5c5a19bb 100644
> > --- a/lib/libnetlink.c
> > +++ b/lib/libnetlink.c
> > @@ -673,7 +673,7 @@ int rtnl_dump_request_n(struct rtnl_handle *rth, struct nlmsghdr *n)
> >  	return sendmsg(rth->fd, &msg, 0);
> >  }
> >  
> > -static int rtnl_dump_done(struct nlmsghdr *h)
> > +static int rtnl_dump_done(struct nlmsghdr *h, const int *errnos)
> >  {
> >  	int len = *(int *)NLMSG_DATA(h);
> >  
> > @@ -683,11 +683,15 @@ static int rtnl_dump_done(struct nlmsghdr *h)
> >  	}
> >  
> >  	if (len < 0) {
> > +		errno = -len;
> > +
> > +		if (rtnl_suppressed_error(errnos, errno))
> > +			return 0;
> > +
> >  		/* check for any messages returned from kernel */
> >  		if (nl_dump_ext_ack_done(h, len))
> >  			return len;
> >  
> > -		errno = -len;
> >  		switch (errno) {
> >  		case ENOENT:
> >  		case EOPNOTSUPP:
> > @@ -789,7 +793,8 @@ static int rtnl_recvmsg(int fd, struct msghdr *msg, char **answer)
> >  }
> >  
> >  static int rtnl_dump_filter_l(struct rtnl_handle *rth,
> > -			      const struct rtnl_dump_filter_arg *arg)
> > +			      const struct rtnl_dump_filter_arg *arg,
> > +			      const int *errnos)
> >  {
> >  	struct sockaddr_nl nladdr;
> >  	struct iovec iov;
> > @@ -834,7 +839,7 @@ static int rtnl_dump_filter_l(struct rtnl_handle *rth,
> >  					dump_intr = 1;
> >  
> >  				if (h->nlmsg_type == NLMSG_DONE) {
> > -					err = rtnl_dump_done(h);
> > +					err = rtnl_dump_done(h, errnos);
> >  					if (err < 0) {
> >  						free(buf);
> >  						return -1;
> > @@ -891,7 +896,19 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
> >  		{ .filter = NULL,   .arg1 = NULL, .nc_flags = 0, },
> >  	};
> >  
> > -	return rtnl_dump_filter_l(rth, a);
> > +	return rtnl_dump_filter_l(rth, a, NULL);
> > +}
> > +
> > +int rtnl_dump_filter_suppress_rtnl_errmsg_nc(struct rtnl_handle *rth,
> > +		     rtnl_filter_t filter,
> > +		     void *arg1, __u16 nc_flags, const int *errnos)
> > +{
> > +	const struct rtnl_dump_filter_arg a[2] = {
> > +		{ .filter = filter, .arg1 = arg1, .nc_flags = nc_flags, },
> > +		{ .filter = NULL,   .arg1 = NULL, .nc_flags = 0, },
> > +	};
> > +
> > +	return rtnl_dump_filter_l(rth, a, errnos);
> >  }
> >  
> >  static void rtnl_talk_error(struct nlmsghdr *h, struct nlmsgerr *err,
> 
