Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADD5462E68
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 09:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhK3IVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 03:21:37 -0500
Received: from relay.sw.ru ([185.231.240.75]:56036 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229951AbhK3IVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 03:21:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=2wnIBgDiWd/NvnzHclv2xy3kp8AYM9EQW7Lm5q/ExzI=; b=NasbWUqM+FJdbYwqA39
        ELybBr/KhxbF0TVdytF7cEjaJEP2mHdxljdT/Ns+X4yTZ6jrM7ym1QAsZR68yKIS21jWcCC6uywXg
        IDeCkVzZ8TUh1/Yau19SlRRuN3fQ/I21IEnwSm0FszbfhQyFyR9voBCCW4TU6OeYLh7i8Ug2kSU=;
Received: from [192.168.15.149] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1mryL7-001rwn-IO; Tue, 30 Nov 2021 11:18:13 +0300
Date:   Tue, 30 Nov 2021 11:18:13 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCH net-next] rtnetlink: add RTNH_REJECT_MASK
Message-Id: <20211130111813.272af77c530a9b13152178ee@virtuozzo.com>
In-Reply-To: <YaOLt2M1hBnoVFKd@shredder>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
        <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
        <20211126134311.920808-2-alexander.mikhalitsyn@virtuozzo.com>
        <YaOLt2M1hBnoVFKd@shredder>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Nov 2021 16:01:27 +0200
Ido Schimmel <idosch@idosch.org> wrote:

> On Fri, Nov 26, 2021 at 04:43:11PM +0300, Alexander Mikhalitsyn wrote:
> > diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> > index 5888492a5257..9c065e2fdef9 100644
> > --- a/include/uapi/linux/rtnetlink.h
> > +++ b/include/uapi/linux/rtnetlink.h
> > @@ -417,6 +417,9 @@ struct rtnexthop {
> >  #define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
> >  				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
> >  
> > +/* these flags can't be set by the userspace */
> > +#define RTNH_REJECT_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN)
> > +
> >  /* Macros to handle hexthops */
> >  
> >  #define RTNH_ALIGNTO	4
> > diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> > index 4c0c33e4710d..805f5e05b56d 100644
> > --- a/net/ipv4/fib_semantics.c
> > +++ b/net/ipv4/fib_semantics.c
> > @@ -685,7 +685,7 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
> >  			return -EINVAL;
> >  		}
> >  
> > -		if (rtnh->rtnh_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
> > +		if (rtnh->rtnh_flags & RTNH_REJECT_MASK) {
> >  			NL_SET_ERR_MSG(extack,
> >  				       "Invalid flags for nexthop - can not contain DEAD or LINKDOWN");
> >  			return -EINVAL;
> > @@ -1363,7 +1363,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
> >  		goto err_inval;
> >  	}
> >  
> > -	if (cfg->fc_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
> > +	if (cfg->fc_flags & RTNH_REJECT_MASK) {
> >  		NL_SET_ERR_MSG(extack,
> >  			       "Invalid rtm_flags - can not contain DEAD or LINKDOWN");
> 
> Instead of a deny list as in the legacy nexthop code, the new nexthop
> code has an allow list (from rtm_to_nh_config()):
> 
> ```
> 	if (nhm->nh_flags & ~NEXTHOP_VALID_USER_FLAGS) {
> 		NL_SET_ERR_MSG(extack, "Invalid nexthop flags in ancillary header");
> 		goto out;
> 	}
> ```
> 
> Where:
> 
> ```
> #define NEXTHOP_VALID_USER_FLAGS RTNH_F_ONLINK
> ```
> 
> So while the legacy nexthop code allows setting flags such as
> RTNH_F_OFFLOAD, the new nexthop code denies them. I don't have a use
> case for setting these flags from user space so I don't care if we allow
> or deny them, but I believe the legacy and new nexthop code should be
> consistent.

Dear Ido,

thanks for your attention to the patches and our checkpoint/restore problem.

Yep, I've read nexthop code too and notices some inconsistencies, but
unfortunately I'm newbie here and my first goal is to fix thing and not break
something, that's why my patch is so trivial and not invasive :)

We have some discussion about these flags here:
https://lore.kernel.org/netdev/d7c2d8fa-052e-b941-2ef1-830c1ba655c1@gmail.com/#r

I've noticed, that current iproute2 code not allows us to set RTNH_F_OFFLOAD and
RTNH_F_TRAP directly. And asked If we should prohibit setting these flags from
the userspace. But huge thanks to Roopa and David here - it turned out that some
userspace code usings these flags and sets it.

So, let's decide which flags we should allow to set from the userspace side
and which not. I'm ready to prepare all needed changes for both the kernel and
iproute2 side. ;)

> 
> WDYT? Should we allow these flags in the new nexthop code as well or
> keep denying them?

IMHO, we should try to be consistent between the new nexthop code and the lagacy one.

Regards,
Alex

> 
> >  		goto err_inval;
> > -- 
> > 2.31.1
> > 


