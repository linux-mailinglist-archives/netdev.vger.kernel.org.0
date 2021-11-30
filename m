Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B2E463054
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 10:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbhK3J5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 04:57:19 -0500
Received: from relay.sw.ru ([185.231.240.75]:35700 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234925AbhK3J5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 04:57:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=Q6otQHLb9DK+S80Zq5uG4UiQWLhOxZ1QHUXHlkn9ddM=; b=I8UBvmS8i1VSlw27hEe
        o6dOp9wrhKqfDoApdR5kKuIeEsVdTdfhf7wVaJIiop5HjAHoPdBwPCNfYGMexYrCssUQzFdRJcnZz
        ICXqDk3C4eptgc8oudyG0MaGDugFVedXlhm5XJQrZHnJXXVbSxEjNO+LHlWp0lq3rfOmZztueow=;
Received: from [192.168.15.206] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1mrzph-001sik-Co; Tue, 30 Nov 2021 12:53:53 +0300
Date:   Tue, 30 Nov 2021 12:53:52 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Ido Schimmel <idosch@idosch.org>, Roopa Prabhu <roopa@nvidia.com>
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
Message-Id: <20211130125352.4bbcc68c01fe763c1f43bfdc@virtuozzo.com>
In-Reply-To: <YaXuwEg/hdkwNYEN@shredder>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
        <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
        <20211126134311.920808-2-alexander.mikhalitsyn@virtuozzo.com>
        <YaOLt2M1hBnoVFKd@shredder>
        <e3d13710-2780-5dff-3cbf-fa0fd7cb5d32@gmail.com>
        <YaXZ3WdgwdeocakQ@shredder>
        <20211130113517.35324af97e168a9b0676b751@virtuozzo.com>
        <YaXuwEg/hdkwNYEN@shredder>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 11:28:32 +0200
Ido Schimmel <idosch@idosch.org> wrote:

> On Tue, Nov 30, 2021 at 11:35:17AM +0300, Alexander Mikhalitsyn wrote:
> > On Tue, 30 Nov 2021 09:59:25 +0200
> > Ido Schimmel <idosch@idosch.org> wrote:
> > > Looking at the patch again, what is the motivation to expose
> > > RTNH_REJECT_MASK to user space? iproute2 already knows that it only
> > > makes sense to set RTNH_F_ONLINK. Can't we just do:
> > 
> > Sorry, but that's not fully clear for me, why we should exclude RTNH_F_ONLINK?
> > I thought that we should exclude RTNH_F_DEAD and RTNH_F_LINKDOWN just because
> > kernel doesn't allow to set these flags.
> 
> I don't think we should exclude RTNH_F_ONLINK. I'm saying that it is the
> only flag that it makes sense to send to the kernel in the ancillary
> header of RTM_NEWROUTE messages. The rest of the RNTH_F_* flags are
> either not used by the kernel or are only meant to be sent from the
> kernel to user space. Due to omission, they are mistakenly allowed.

Ah, okay, so, the patch should be like

diff --git a/ip/iproute.c b/ip/iproute.c
index 1447a5f78f49..0e6dad2b67e5 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1632,6 +1632,8 @@ static int save_route(struct nlmsghdr *n, void *arg)
        if (!filter_nlmsg(n, tb, host_len))
                return 0;
 
+       r->rtm_flags &= RTNH_F_ONLINK;
+
        ret = write(STDOUT_FILENO, n, n->nlmsg_len);
        if ((ret > 0) && (ret != n->nlmsg_len)) {
                fprintf(stderr, "Short write while saving nlmsg\n");

to filter out all flags *except* RTNH_F_ONLINK.

But what about discussion from
https://lore.kernel.org/netdev/ff405eae-21d9-35f4-1397-b6f9a29a57ff@nvidia.com/

As far as I understand Roopa, we have to save at least RTNH_F_OFFLOAD flag too,
for instance, if user uses Cumulus and want to dump/restore routes.

I'm sorry if I misunderstood something.

> 
> Therefore, I think that the only necessary patch is an iproute2 patch
> that makes sure that during save/restore you are clearing all the
> RTNH_F_* flags but RTNH_F_ONLINK.
> 
> BTW, looking at save_route() in iproute2, I think the patch only clears
> these flags from the ancillary header, but not from 'struct rtnexthop'
> that is nested in RTA_MULTIPATH for multipath routes. See this blog post
> for depiction of the message:
> http://codecave.cc/multipath-routing-in-linux-part-1.html

Sure, I will handle these nested structures too.

> 
> > 
> > I'd also thought about another approach - "offload" this flags filtering
> > problems to the kernel side for better iproute dump images compatibility.
> > 
> > Now we dump all routes using netlink message like this
> > 	struct {
> > 		struct nlmsghdr nlh;
> > 		struct rtmsg rtm;
> > 		char buf[128];
> > 	} req = {
> > 		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg)),
> > 		.nlh.nlmsg_type = RTM_GETROUTE,
> > 		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
> > ...
> > 	};
> > 
> > But we can introduce some "special" flag like NLM_F_FILTERED_DUMP (or something like that)
> > 	} req = {
> > 		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg)),
> > 		.nlh.nlmsg_type = RTM_GETROUTE,
> > 		.nlh.nlmsg_flags = NLM_F_FILTERED_DUMP | NLM_F_REQUEST,
> > ...
> > 	};
> > 
> > The idea here is that the kernel nows better which flags should be omitted from the dump
> > (<=> which flags is prohibited to set directly from the userspace side).
> > 
> > But that change is more "global". WDYT about this?
> > 
> > I'm ready to implement any of the approaches with your kind advice.
> 
> Having the kernel filter RO flags upon RTM_GETROUTE with a new special
> flag / attribute would be easiest to implement in iproute2 (especially
> if my comment about RTA_MULTIPATH is correct), but it's a quite invasive
> change that requires new uAPI.
> 
> Personally, I think that if something can be done in user space, then I
> would do it in user space instead of adding new uAPI.

agreed

