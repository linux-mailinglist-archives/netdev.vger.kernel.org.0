Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC2134741A
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 10:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhCXJE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 05:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbhCXJEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 05:04:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576B9C061763;
        Wed, 24 Mar 2021 02:04:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lOzQy-0002RB-O8; Wed, 24 Mar 2021 10:04:12 +0100
Date:   Wed, 24 Mar 2021 10:04:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.10 104/157] mptcp: put subflow sock on connect error
Message-ID: <20210324090412.GB27244@breakpoint.cc>
References: <20210322121933.746237845@linuxfoundation.org>
 <20210322121937.071435221@linuxfoundation.org>
 <CA+G9fYvRM+9DmGuKM0ErDnrYBOmZ6zzmMkrWevMJqOzhejWwZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvRM+9DmGuKM0ErDnrYBOmZ6zzmMkrWevMJqOzhejWwZg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> On Mon, 22 Mar 2021 at 18:15, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Florian Westphal <fw@strlen.de>
> >
> > [ Upstream commit f07157792c633b528de5fc1dbe2e4ea54f8e09d4 ]
> >
> > mptcp_add_pending_subflow() performs a sock_hold() on the subflow,
> > then adds the subflow to the join list.
> >
> > Without a sock_put the subflow sk won't be freed in case connect() fails.
> >
> > unreferenced object 0xffff88810c03b100 (size 3000):
> > [..]
> >     sk_prot_alloc.isra.0+0x2f/0x110
> >     sk_alloc+0x5d/0xc20
> >     inet6_create+0x2b7/0xd30
> >     __sock_create+0x17f/0x410
> >     mptcp_subflow_create_socket+0xff/0x9c0
> >     __mptcp_subflow_connect+0x1da/0xaf0
> >     mptcp_pm_nl_work+0x6e0/0x1120
> >     mptcp_worker+0x508/0x9a0
> >
> > Fixes: 5b950ff4331ddda ("mptcp: link MPC subflow into msk only after accept")

I don't see this change in 5.10, so why is this fix queued up?

> I have reported the following warnings and kernel crash on 5.10.26-rc2 [1]
> The bisect reported that issue pointing out to this commit.
> 
> commit 460916534896e6d4f80a37152e0948db33376873
> mptcp: put subflow sock on connect error
> 
> This problem is specific to 5.10.26-rc2.
> 
> Warning:
> --------
> [ 1040.114695] refcount_t: addition on 0; use-after-free.
> [ 1040.119857] WARNING: CPU: 3 PID: 31925 at
> /usr/src/kernel/lib/refcount.c:25 refcount_warn_saturate+0xd7/0x100
> [ 1040.129769] Modules linked in: act_mirred cls_u32 sch_netem sch_etf
> ip6table_nat xt_nat iptable_nat nf_nat ip6table_filter xt_conntrack
> nf_conntrack nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 sch_fq
> iptable_filter xt_mark ip_tables cls_bpf sch_ingress algif_hash
> x86_pkg_temp_thermal fuse [last unloaded: test_blackhole_dev]
> [ 1040.159030] CPU: 3 PID: 31925 Comm: mptcp_connect Tainted: G
> W     K   5.10.26-rc2 #1
> [ 1040.167459] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [ 1040.174851] RIP: 0010:refcount_warn_saturate+0xd7/0x100
> 
> And
> 
> Kernel Panic:
> -------------
> [ 1069.557485] BUG: kernel NULL pointer dereference, address: 0000000000000010
> [ 1069.564446] #PF: supervisor read access in kernel mode
> [ 1069.569583] #PF: error_code(0x0000) - not-present page
> [ 1069.574714] PGD 0 P4D 0
> [ 1069.577246] Oops: 0000 [#1] SMP PTI
> > index 16adba172fb9..591546d0953f 100644
> > --- a/net/mptcp/subflow.c
> > +++ b/net/mptcp/subflow.c
> > @@ -1133,6 +1133,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
> >         spin_lock_bh(&msk->join_list_lock);
> >         list_add_tail(&subflow->node, &msk->join_list);
> >         spin_unlock_bh(&msk->join_list_lock);
> > +       sock_put(mptcp_subflow_tcp_sock(subflow));
> >
> >         return err;

Crash is not surprising, the backport puts the socket in the 'success' path
(list_add_tail).

I don't see why this is in -stable, the faulty commit is not there?

The upstream patch is:
        list_del(&subflow->node);
        spin_unlock_bh(&msk->join_list_lock);
+	sock_put(mptcp_subflow_tcp_sock(subflow));

[ Note the 'list_del', this is in the error unwind path ]
