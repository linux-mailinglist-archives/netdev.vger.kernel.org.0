Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7169A347477
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 10:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbhCXJWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 05:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232017AbhCXJWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 05:22:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 075F261A01;
        Wed, 24 Mar 2021 09:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616577752;
        bh=b5iYeKxA+aYQvuo870CFsq/4+8Vj0GkQdOuTKFBvDrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i4zoxqCz5HRrve8irtOkADbzDGYRu13ICJmV+WhqHyIN3RzGaDzjfIPAEP5lGGxu8
         um5NLZGdWt2jVuAf+gu9wNsvrl4e6dM3RdqOoLB6fbjLvTTzfzVSiTnbIa4XpFARXk
         QhAwNr++cEbZcz6YOUqOT8zxN31OYHptSxae5irI=
Date:   Wed, 24 Mar 2021 10:22:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.10 104/157] mptcp: put subflow sock on connect error
Message-ID: <YFsE1cQy3tJASGob@kroah.com>
References: <20210322121933.746237845@linuxfoundation.org>
 <20210322121937.071435221@linuxfoundation.org>
 <CA+G9fYvRM+9DmGuKM0ErDnrYBOmZ6zzmMkrWevMJqOzhejWwZg@mail.gmail.com>
 <20210324090412.GB27244@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324090412.GB27244@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 10:04:12AM +0100, Florian Westphal wrote:
> Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > On Mon, 22 Mar 2021 at 18:15, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Florian Westphal <fw@strlen.de>
> > >
> > > [ Upstream commit f07157792c633b528de5fc1dbe2e4ea54f8e09d4 ]
> > >
> > > mptcp_add_pending_subflow() performs a sock_hold() on the subflow,
> > > then adds the subflow to the join list.
> > >
> > > Without a sock_put the subflow sk won't be freed in case connect() fails.
> > >
> > > unreferenced object 0xffff88810c03b100 (size 3000):
> > > [..]
> > >     sk_prot_alloc.isra.0+0x2f/0x110
> > >     sk_alloc+0x5d/0xc20
> > >     inet6_create+0x2b7/0xd30
> > >     __sock_create+0x17f/0x410
> > >     mptcp_subflow_create_socket+0xff/0x9c0
> > >     __mptcp_subflow_connect+0x1da/0xaf0
> > >     mptcp_pm_nl_work+0x6e0/0x1120
> > >     mptcp_worker+0x508/0x9a0
> > >
> > > Fixes: 5b950ff4331ddda ("mptcp: link MPC subflow into msk only after accept")
> 
> I don't see this change in 5.10, so why is this fix queued up?
> 
> > I have reported the following warnings and kernel crash on 5.10.26-rc2 [1]
> > The bisect reported that issue pointing out to this commit.
> > 
> > commit 460916534896e6d4f80a37152e0948db33376873
> > mptcp: put subflow sock on connect error
> > 
> > This problem is specific to 5.10.26-rc2.
> > 
> > Warning:
> > --------
> > [ 1040.114695] refcount_t: addition on 0; use-after-free.
> > [ 1040.119857] WARNING: CPU: 3 PID: 31925 at
> > /usr/src/kernel/lib/refcount.c:25 refcount_warn_saturate+0xd7/0x100
> > [ 1040.129769] Modules linked in: act_mirred cls_u32 sch_netem sch_etf
> > ip6table_nat xt_nat iptable_nat nf_nat ip6table_filter xt_conntrack
> > nf_conntrack nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 sch_fq
> > iptable_filter xt_mark ip_tables cls_bpf sch_ingress algif_hash
> > x86_pkg_temp_thermal fuse [last unloaded: test_blackhole_dev]
> > [ 1040.159030] CPU: 3 PID: 31925 Comm: mptcp_connect Tainted: G
> > W     K   5.10.26-rc2 #1
> > [ 1040.167459] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> > 2.2 05/23/2018
> > [ 1040.174851] RIP: 0010:refcount_warn_saturate+0xd7/0x100
> > 
> > And
> > 
> > Kernel Panic:
> > -------------
> > [ 1069.557485] BUG: kernel NULL pointer dereference, address: 0000000000000010
> > [ 1069.564446] #PF: supervisor read access in kernel mode
> > [ 1069.569583] #PF: error_code(0x0000) - not-present page
> > [ 1069.574714] PGD 0 P4D 0
> > [ 1069.577246] Oops: 0000 [#1] SMP PTI
> > > index 16adba172fb9..591546d0953f 100644
> > > --- a/net/mptcp/subflow.c
> > > +++ b/net/mptcp/subflow.c
> > > @@ -1133,6 +1133,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
> > >         spin_lock_bh(&msk->join_list_lock);
> > >         list_add_tail(&subflow->node, &msk->join_list);
> > >         spin_unlock_bh(&msk->join_list_lock);
> > > +       sock_put(mptcp_subflow_tcp_sock(subflow));
> > >
> > >         return err;
> 
> Crash is not surprising, the backport puts the socket in the 'success' path
> (list_add_tail).
> 
> I don't see why this is in -stable, the faulty commit is not there?
> 
> The upstream patch is:
>         list_del(&subflow->node);
>         spin_unlock_bh(&msk->join_list_lock);
> +	sock_put(mptcp_subflow_tcp_sock(subflow));
> 
> [ Note the 'list_del', this is in the error unwind path ]

Odd, I think something went wrong with Sasha's scripts.

I've dropped this, and the other two mptcp patches, from the 5.10 queue
and let's see if that helps.  I'll do a new -rc now as well after my
build tests finish...

thanks,

greg k-h
