Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32237462E96
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 09:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbhK3Iim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 03:38:42 -0500
Received: from relay.sw.ru ([185.231.240.75]:57388 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234404AbhK3Iij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 03:38:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=JKjU+kifbq8rsOYzRvdWKrdX+Rjdz7pQmegLKz3ylu0=; b=Nz06Lp8dMQSJhSaS/+O
        Al/V6Ewly87+bsfWNkLv7d+dn9HGhnKaIvvU+c71Nm6mJAePEJM7DHN0qOdOmjgsp53oQCvs1TlA4
        DUSPzPAWPMIIW88s6NayvVz3KWSykFVkSR4R8XXXp1xSzEgZpf8tTQxMQwKPTlJDB+i7Acl6OnY=;
Received: from [192.168.15.149] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1mrybe-001s4B-6Z; Tue, 30 Nov 2021 11:35:18 +0300
Date:   Tue, 30 Nov 2021 11:35:17 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCH net-next] rtnetlink: add RTNH_REJECT_MASK
Message-Id: <20211130113517.35324af97e168a9b0676b751@virtuozzo.com>
In-Reply-To: <YaXZ3WdgwdeocakQ@shredder>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
        <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
        <20211126134311.920808-2-alexander.mikhalitsyn@virtuozzo.com>
        <YaOLt2M1hBnoVFKd@shredder>
        <e3d13710-2780-5dff-3cbf-fa0fd7cb5d32@gmail.com>
        <YaXZ3WdgwdeocakQ@shredder>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 09:59:25 +0200
Ido Schimmel <idosch@idosch.org> wrote:

> On Sun, Nov 28, 2021 at 05:19:38PM -0700, David Ahern wrote:
> > On 11/28/21 7:01 AM, Ido Schimmel wrote:
> > > On Fri, Nov 26, 2021 at 04:43:11PM +0300, Alexander Mikhalitsyn wrote:
> > >> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> > >> index 5888492a5257..9c065e2fdef9 100644
> > >> --- a/include/uapi/linux/rtnetlink.h
> > >> +++ b/include/uapi/linux/rtnetlink.h
> > >> @@ -417,6 +417,9 @@ struct rtnexthop {
> > >>  #define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
> > >>  				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
> > >>  
> > >> +/* these flags can't be set by the userspace */
> > >> +#define RTNH_REJECT_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN)
> > >> +
> > >>  /* Macros to handle hexthops */
> > >>  
> > >>  #define RTNH_ALIGNTO	4
> > >> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> > >> index 4c0c33e4710d..805f5e05b56d 100644
> > >> --- a/net/ipv4/fib_semantics.c
> > >> +++ b/net/ipv4/fib_semantics.c
> > >> @@ -685,7 +685,7 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
> > >>  			return -EINVAL;
> > >>  		}
> > >>  
> > >> -		if (rtnh->rtnh_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
> > >> +		if (rtnh->rtnh_flags & RTNH_REJECT_MASK) {
> > >>  			NL_SET_ERR_MSG(extack,
> > >>  				       "Invalid flags for nexthop - can not contain DEAD or LINKDOWN");
> > >>  			return -EINVAL;
> > >> @@ -1363,7 +1363,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
> > >>  		goto err_inval;
> > >>  	}
> > >>  
> > >> -	if (cfg->fc_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
> > >> +	if (cfg->fc_flags & RTNH_REJECT_MASK) {
> > >>  		NL_SET_ERR_MSG(extack,
> > >>  			       "Invalid rtm_flags - can not contain DEAD or LINKDOWN");
> > > 
> > > Instead of a deny list as in the legacy nexthop code, the new nexthop
> > > code has an allow list (from rtm_to_nh_config()):
> > > 
> > > ```
> > > 	if (nhm->nh_flags & ~NEXTHOP_VALID_USER_FLAGS) {
> > > 		NL_SET_ERR_MSG(extack, "Invalid nexthop flags in ancillary header");
> > > 		goto out;
> > > 	}
> > > ```
> > > 
> > > Where:
> > > 
> > > ```
> > > #define NEXTHOP_VALID_USER_FLAGS RTNH_F_ONLINK
> > > ```
> > > 
> > > So while the legacy nexthop code allows setting flags such as
> > > RTNH_F_OFFLOAD, the new nexthop code denies them. I don't have a use
> > > case for setting these flags from user space so I don't care if we allow
> > > or deny them, but I believe the legacy and new nexthop code should be
> > > consistent.
> > > 
> > > WDYT? Should we allow these flags in the new nexthop code as well or
> > > keep denying them?
> > > 
> > >>  		goto err_inval;
> > 
> > I like the positive naming - RTNH_VALID_USER_FLAGS.
> 
> I don't think we can move the legacy code to the same allow list as the
> new nexthop code without potentially breaking user space. The legacy
> code allows for much more flags to be set in the ancillary header than
> the new nexthop code.


Hello, Ido

agreed, let's keep this side unchanged

> 
> Looking at the patch again, what is the motivation to expose
> RTNH_REJECT_MASK to user space? iproute2 already knows that it only
> makes sense to set RTNH_F_ONLINK. Can't we just do:

Sorry, but that's not fully clear for me, why we should exclude RTNH_F_ONLINK?
I thought that we should exclude RTNH_F_DEAD and RTNH_F_LINKDOWN just because
kernel doesn't allow to set these flags.

I'd also thought about another approach - "offload" this flags filtering
problems to the kernel side for better iproute dump images compatibility.

Now we dump all routes using netlink message like this
	struct {
		struct nlmsghdr nlh;
		struct rtmsg rtm;
		char buf[128];
	} req = {
		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg)),
		.nlh.nlmsg_type = RTM_GETROUTE,
		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
...
	};

But we can introduce some "special" flag like NLM_F_FILTERED_DUMP (or something like that)
	} req = {
		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg)),
		.nlh.nlmsg_type = RTM_GETROUTE,
		.nlh.nlmsg_flags = NLM_F_FILTERED_DUMP | NLM_F_REQUEST,
...
	};

The idea here is that the kernel nows better which flags should be omitted from the dump
(<=> which flags is prohibited to set directly from the userspace side).

But that change is more "global". WDYT about this?

I'm ready to implement any of the approaches with your kind advice.

Alex

> 
> diff --git a/ip/iproute.c b/ip/iproute.c
> index 1447a5f78f49..0e6dad2b67e5 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -1632,6 +1632,8 @@ static int save_route(struct nlmsghdr *n, void *arg)
>         if (!filter_nlmsg(n, tb, host_len))
>                 return 0;
>  
> +       r->rtm_flags &= ~RTNH_F_ONLINK;
> +
>         ret = write(STDOUT_FILENO, n, n->nlmsg_len);
>         if ((ret > 0) && (ret != n->nlmsg_len)) {
>                 fprintf(stderr, "Short write while saving nlmsg\n");
> 
> > 
> > nexthop API should allow the OFFLOAD flag to be consistent; separate
> > change though.
> > 
