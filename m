Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C853D554985
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345399AbiFVKlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 06:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353850AbiFVK2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 06:28:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456CEE4B;
        Wed, 22 Jun 2022 03:28:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1o3xan-0002Cj-GJ; Wed, 22 Jun 2022 12:28:13 +0200
Date:   Wed, 22 Jun 2022 12:28:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net] net: ensure all external references are released in
 deferred skbuffs
Message-ID: <20220622102813.GA24844@breakpoint.cc>
References: <20220619003919.394622-1-i.maximets@ovn.org>
 <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:
> On Sun, Jun 19, 2022 at 2:39 AM Ilya Maximets <i.maximets@ovn.org> wrote:
> >
> > Open vSwitch system test suite is broken due to inability to
> > load/unload netfilter modules.  kworker thread is getting trapped
> > in the infinite loop while running a net cleanup inside the
> > nf_conntrack_cleanup_net_list, because deferred skbuffs are still
> > holding nfct references and not being freed by their CPU cores.
> >
> > In general, the idea that we will have an rx interrupt on every
> > CPU core at some point in a near future doesn't seem correct.
> > Devices are getting created and destroyed, interrupts are getting
> > re-scheduled, CPUs are going online and offline dynamically.
> > Any of these events may leave packets stuck in defer list for a
> > long time.  It might be OK, if they are just a piece of memory,
> > but we can't afford them holding references to any other resources.
> >
> > In case of OVS, nfct reference keeps the kernel thread in busy loop
> > while holding a 'pernet_ops_rwsem' semaphore.  That blocks the
> > later modprobe request from user space:
> >
> >   # ps
> >    299 root  R  99.3  200:25.89 kworker/u96:4+
> >
> >   # journalctl
> >   INFO: task modprobe:11787 blocked for more than 1228 seconds.
> >         Not tainted 5.19.0-rc2 #8
> >   task:modprobe     state:D
> >   Call Trace:
> >    <TASK>
> >    __schedule+0x8aa/0x21d0
> >    schedule+0xcc/0x200
> >    rwsem_down_write_slowpath+0x8e4/0x1580
> >    down_write+0xfc/0x140
> >    register_pernet_subsys+0x15/0x40
> >    nf_nat_init+0xb6/0x1000 [nf_nat]
> >    do_one_initcall+0xbb/0x410
> >    do_init_module+0x1b4/0x640
> >    load_module+0x4c1b/0x58d0
> >    __do_sys_init_module+0x1d7/0x220
> >    do_syscall_64+0x3a/0x80
> >    entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >
> > At this point OVS testsuite is unresponsive and never recover,
> > because these skbuffs are never freed.
> >
> > Solution is to make sure no external references attached to skb
> > before pushing it to the defer list.  Using skb_release_head_state()
> > for that purpose.  The function modified to be re-enterable, as it
> > will be called again during the defer list flush.
> >
> > Another approach that can fix the OVS use-case, is to kick all
> > cores while waiting for references to be released during the net
> > cleanup.  But that sounds more like a workaround for a current
> > issue rather than a proper solution and will not cover possible
> > issues in other parts of the code.
> >
> > Additionally checking for skb_zcopy() while deferring.  This might
> > not be necessary, as I'm not sure if we can actually have zero copy
> > packets on this path, but seems worth having for completeness as we
> > should never defer such packets regardless.
> >
> > CC: Eric Dumazet <edumazet@google.com>
> > Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
> > Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> > ---
> >  net/core/skbuff.c | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> I do not think this patch is doing the right thing.
> 
> Packets sitting in TCP receive queues should not hold state that is
> not relevant for TCP recvmsg().

Agree, but tcp_v4/6_rcv() already call nf_reset_ct(), else it would
not be possible to remove nf_conntrack module in practice.

I wonder where the deferred skbs are coming from, any and all
queued skbs need the conntrack state dropped.

I don't mind a new helper that does a combined dst+ct release though.
