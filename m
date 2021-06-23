Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE283B1E67
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 18:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFWQOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:14:07 -0400
Received: from relay.sw.ru ([185.231.240.75]:34736 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhFWQOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 12:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=+PqA5Sk3kqj3VQF46OEAnz0MRkeCTs+jD1ynou9EECg=; b=RUUcW4W8WD88Y8qIb+R
        h+TYHozv/FmVvlc2OY1Z27bI3B7ecy2JhE6VkkPSZDBua0/fw8n3Afxfz0RiIfS2OZ++WtDai3ZY0
        XTJ+HgBwfjF5pl0Zeg7Fn3ro9nJOMPdqvL/p1DMwq+kNHt3Gfk1GK+gqsZcxDQIBvDdcufLGDzc=;
Received: from [192.168.15.15] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lVmWu-001cIX-AG; Wed, 23 Jun 2021 19:11:45 +0300
Date:   Wed, 23 Jun 2021 19:11:41 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCH iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-Id: <20210623191141.c058e6ea78577d3bd54cea02@virtuozzo.com>
In-Reply-To: <042c0ec6-f347-8b82-2bb2-c4ea87cf4a6d@gmail.com>
References: <20210622150330.28014-1-alexander.mikhalitsyn@virtuozzo.com>
        <042c0ec6-f347-8b82-2bb2-c4ea87cf4a6d@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Jun 2021 09:36:29 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/22/21 9:03 AM, Alexander Mikhalitsyn wrote:
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
> 
> The above command on 5.4 kernel with corresponding iproute2 does not
> show that error. Is your kernel compiled with CONFIG_IP_MULTIPLE_TABLES
> enabled?
> 
Yes it is.
$ grep CONFIG_IP_MULTIPLE_TABLES .config
CONFIG_IP_MULTIPLE_TABLES=y

> > 
> > Expected result here is to get empty dump file (as it was before this change).
> > 
> > This affects on CRIU [1] because we use ip route save in dump process, to workaround
> > problem in tests we just put loopback interface up in each net namespace.
> > Other users also met this problem [2].
> > 
> > Links:
> > [1] https://github.com/checkpoint-restore/criu/issues/747
> > [2] https://www.spinics.net/lists/netdev/msg559739.html
> > 
> > Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")
> > 
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: Stephen Hemminger <stephen@networkplumber.org>
> > Cc: Andrei Vagin <avagin@gmail.com>
> > Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> > Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> > ---
> >  ip/iproute.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/ip/iproute.c b/ip/iproute.c
> > index 5853f026..b70acc00 100644
> > --- a/ip/iproute.c
> > +++ b/ip/iproute.c
> > @@ -1734,6 +1734,7 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
> >  	char *od = NULL;
> >  	unsigned int mark = 0;
> >  	rtnl_filter_t filter_fn;
> > +	int ret;
> >  
> >  	if (action == IPROUTE_SAVE) {
> >  		if (save_route_prep())
> > @@ -1939,7 +1940,11 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
> >  
> >  	new_json_obj(json);
> >  
> > -	if (rtnl_dump_filter(&rth, filter_fn, stdout) < 0) {
> > +	ret = rtnl_dump_filter(&rth, filter_fn, stdout);
> > +
> > +	/* Let's ignore ENOENT error if we want to dump RT_TABLE_MAIN table */
> > +	if (ret < 0 &&
> 
> ret temp variable is not needed; just add the extra checks.

Sure, thanks!
I will send v2 if all fine in general with this approach to fix the problem.

> 
> > +	    !(errno == ENOENT && filter.tb == RT_TABLE_MAIN)) {
> >  		fprintf(stderr, "Dump terminated\n");
> >  		return -2;
> >  	}
> > 
> 
> This looks fine to me, but I want clarification on the kernel config. As
> I recall with multiple tables and fib rules tables are created when net
> namespace is created.
I've traced how fib tables allocated (fib_new_table function) during
$ ip l set lo up
and stack looks like that:
ip   740 [003] 99894.075766: probe:fib_new_table: (ffffffffb08ff9a0)
        ffffffffb08ff9a1 fib_new_table+0x1 ([kernel.kallsyms])
        ffffffffb09001d1 fib_magic.isra.24+0xc1 ([kernel.kallsyms])
        ffffffffb0901b3d fib_add_ifaddr+0x16d ([kernel.kallsyms])
        ffffffffb0901be5 fib_netdev_event+0x95 ([kernel.kallsyms])
        ffffffffafed5457 notifier_call_chain+0x47 ([kernel.kallsyms])
        ffffffffb07f249b __dev_notify_flags+0x5b ([kernel.kallsyms])
        ffffffffb07f2c48 dev_change_flags+0x48 ([kernel.kallsyms])
        ffffffffb0805d34 do_setlink+0x314 ([kernel.kallsyms])
        ffffffffb080ad9d __rtnl_newlink+0x53d ([kernel.kallsyms])
        ffffffffb080b143 rtnl_newlink+0x43 ([kernel.kallsyms])
        ffffffffb08048ba rtnetlink_rcv_msg+0x22a ([kernel.kallsyms])
        ffffffffb0848dfc netlink_rcv_skb+0x4c ([kernel.kallsyms])
        ffffffffb084868d netlink_unicast+0x21d ([kernel.kallsyms])
        ffffffffb08488fe netlink_sendmsg+0x22e ([kernel.kallsyms])
        ffffffffb07cad9c sock_sendmsg+0x4c ([kernel.kallsyms])
        ffffffffb07cb0bb ____sys_sendmsg+0x1eb ([kernel.kallsyms])
        ffffffffb07cc74c ___sys_sendmsg+0x7c ([kernel.kallsyms])
        ffffffffb07cc817 __sys_sendmsg+0x57 ([kernel.kallsyms])
        ffffffffafe0279b do_syscall_64+0x5b ([kernel.kallsyms])
        ffffffffb0c000ad entry_SYSCALL_64_after_hwframe+0x65 ([kernel.kallsyms])
            7f556c716d78 __libc_sendmsg+0x18 (/usr/lib64/libc-2.28.so)

During trace of:
$ unshare -n
I see no fib_new_table() calls.

Thank you very much for your attention to the patch.

Regards,
Alex
