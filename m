Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0324B421230
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 17:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbhJDPC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 11:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhJDPCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 11:02:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7999FC061745;
        Mon,  4 Oct 2021 08:00:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mXPS9-0006bJ-Vx; Mon, 04 Oct 2021 17:00:30 +0200
Date:   Mon, 4 Oct 2021 17:00:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+7b4a6fc3e452c67173e0@syzkaller.appspotmail.com>,
        davem@davemloft.net, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Florian Westphal <fw@strlen.de>
Subject: Re: [syzbot] INFO: task hung in reg_check_chans_work (3)
Message-ID: <20211004150029.GN2935@breakpoint.cc>
References: <000000000000035e6905cd5e1c91@google.com>
 <20211004074157.1ba82e65@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004074157.1ba82e65@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> netfilter... rtnl.. workqueue... let's CC Florian..

Thanks.

> > HEAD commit:    a4e6f95a891a Merge tag 'pinctrl-v5.15-2' of git://git.kern..

This HEAD doesn't include

7970a19b71044bf4dc2c1becc200275bdf1884d4
netfilter: nf_nat_masquerade: defer conntrack walk to work queue

so, with a bit of luck this is already resolved.

> >  context_switch kernel/sched/core.c:4940 [inline]
> >  __schedule+0x940/0x26f0 kernel/sched/core.c:6287
> >  schedule+0xd3/0x270 kernel/sched/core.c:6366
> >  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
> >  __mutex_lock_common kernel/locking/mutex.c:669 [inline]
> >  __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
> >  reg_check_chans_work+0x83/0xe10 net/wireless/reg.c:2423
> >  process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297

workqueue tries to rtnl_lock()...

> > task:syz-executor.0  state:D stack:27152 pid:17047 ppid: 13518 flags:0x00004004
> > Call Trace:
> >  context_switch kernel/sched/core.c:4940 [inline]
> >  __schedule+0x940/0x26f0 kernel/sched/core.c:6287
> >  schedule+0xd3/0x270 kernel/sched/core.c:6366
> >  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
> >  __mutex_lock_common kernel/locking/mutex.c:669 [inline]
> >  __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
> >  rtnl_lock net/core/rtnetlink.c:72 [inline]
> >  rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569

... syz-executor as well ...

> > task:syz-executor.4  state:D stack:27216 pid:17052 ppid:  6665 flags:0x00004004
> > Call Trace:
> >  context_switch kernel/sched/core.c:4940 [inline]
> >  __schedule+0x940/0x26f0 kernel/sched/core.c:6287
> >  schedule+0xd3/0x270 kernel/sched/core.c:6366
> >  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
> >  __mutex_lock_common kernel/locking/mutex.c:669 [inline]
> >  __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
> >  rtnl_lock net/core/rtnetlink.c:72 [inline]
> >  rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
> >  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504

... and another syz-executor instance ...

> >  __local_bh_enable_ip+0xcd/0x120 kernel/softirq.c:371
> >  local_bh_enable include/linux/bottom_half.h:32 [inline]
> >  get_next_corpse net/netfilter/nf_conntrack_core.c:2252 [inline]
> >  nf_ct_iterate_cleanup+0x15a/0x450 net/netfilter/nf_conntrack_core.c:2275
> >  nf_ct_iterate_cleanup_net net/netfilter/nf_conntrack_core.c:2363 [inline]
> >  nf_ct_iterate_cleanup_net+0x236/0x400 net/netfilter/nf_conntrack_core.c:2347
> >  masq_device_event+0xae/0xe0 net/netfilter/nf_nat_masquerade.c:88
> >  notifier_call_chain+0xb5/0x200 kernel/notifier.c:83

... and rtnl is held by notifier call chain.

This is no longer the case in current net head,
nf_ct_iterate_cleanup() runs from workqueue without rtnl locked.
