Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B74066A72E
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 00:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjAMXld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 18:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjAMXlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 18:41:32 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69428CBFB
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673653291; x=1705189291;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=inIfniUrhA7Kcp3SOztVdGaFs+LAOGmS5e0FBy+I3Tc=;
  b=ZujS7jkXGHzWUCThpq0PPLfkhX1C/BRvqYZZrKhKsb4BIaYWqOTJA9FQ
   4KaOs0WeTJkdbrNWSMHlsVjeW7PoOSBTAn5fQNBXzVSHF2BxJca9lqqpK
   kld28oGTlF6JRwL9U2SANeajYKe4ZGaCUT0fEghBUbEHcSZQDmT0FmbeM
   aEYOfwogVRo4xRijWqxjP5kPWzaLWJGiTbtAsowsPhUqVWleZaZ7osJ/f
   60PHneJXPCoFRzlBOPMSTOTfaCLotv7n30u4q1+LaiQHhHzAhP+S9eLpn
   4zDdxogWiORaddpkcaIRlgtpWXoM9iCm8RU4QTvL7QpdKwV8jJrecIgyb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="326186662"
X-IronPort-AV: E=Sophos;i="5.97,215,1669104000"; 
   d="scan'208";a="326186662"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 15:41:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="690659280"
X-IronPort-AV: E=Sophos;i="5.97,215,1669104000"; 
   d="scan'208";a="690659280"
Received: from namnguy3-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.252.142.187])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 15:41:30 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH net] net/sched: sch_taprio: fix possible use-after-free
In-Reply-To: <20230113164849.4004848-1-edumazet@google.com>
References: <20230113164849.4004848-1-edumazet@google.com>
Date:   Fri, 13 Jan 2023 15:41:30 -0800
Message-ID: <871qny9f4l.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Eric Dumazet <edumazet@google.com> writes:

> syzbot reported a nasty crash [1] in net_tx_action() which
> made little sense until we got a repro.
>
> This repro installs a taprio qdisc, but providing an
> invalid TCA_RATE attribute.
>
> qdisc_create() has to destroy the just initialized
> taprio qdisc, and taprio_destroy() is called.
>
> However, the hrtimer used by taprio had already fired,
> therefore advance_sched() called __netif_schedule().
>
> Then net_tx_action was trying to use a destroyed qdisc.
>
> We can not undo the __netif_schedule(), so we must wait
> until one cpu serviced the qdisc before we can proceed.
>
> Many thanks to Alexander Potapenko for his help.
>
> [1]
> BUG: KMSAN: uninit-value in queued_spin_trylock include/asm-generic/qspinlock.h:94 [inline]
> BUG: KMSAN: uninit-value in do_raw_spin_trylock include/linux/spinlock.h:191 [inline]
> BUG: KMSAN: uninit-value in __raw_spin_trylock include/linux/spinlock_api_smp.h:89 [inline]
> BUG: KMSAN: uninit-value in _raw_spin_trylock+0x92/0xa0 kernel/locking/spinlock.c:138
>  queued_spin_trylock include/asm-generic/qspinlock.h:94 [inline]
>  do_raw_spin_trylock include/linux/spinlock.h:191 [inline]
>  __raw_spin_trylock include/linux/spinlock_api_smp.h:89 [inline]
>  _raw_spin_trylock+0x92/0xa0 kernel/locking/spinlock.c:138
>  spin_trylock include/linux/spinlock.h:359 [inline]
>  qdisc_run_begin include/net/sch_generic.h:187 [inline]
>  qdisc_run+0xee/0x540 include/net/pkt_sched.h:125
>  net_tx_action+0x77c/0x9a0 net/core/dev.c:5086
>  __do_softirq+0x1cc/0x7fb kernel/softirq.c:571
>  run_ksoftirqd+0x2c/0x50 kernel/softirq.c:934
>  smpboot_thread_fn+0x554/0x9f0 kernel/smpboot.c:164
>  kthread+0x31b/0x430 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30
>
> Uninit was created at:
>  slab_post_alloc_hook mm/slab.h:732 [inline]
>  slab_alloc_node mm/slub.c:3258 [inline]
>  __kmalloc_node_track_caller+0x814/0x1250 mm/slub.c:4970
>  kmalloc_reserve net/core/skbuff.c:358 [inline]
>  __alloc_skb+0x346/0xcf0 net/core/skbuff.c:430
>  alloc_skb include/linux/skbuff.h:1257 [inline]
>  nlmsg_new include/net/netlink.h:953 [inline]
>  netlink_ack+0x5f3/0x12b0 net/netlink/af_netlink.c:2436
>  netlink_rcv_skb+0x55d/0x6c0 net/netlink/af_netlink.c:2507
>  rtnetlink_rcv+0x30/0x40 net/core/rtnetlink.c:6108
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0xf3b/0x1270 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x1288/0x1440 net/netlink/af_netlink.c:1921
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  ____sys_sendmsg+0xabc/0xe90 net/socket.c:2482
>  ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2536
>  __sys_sendmsg net/socket.c:2565 [inline]
>  __do_sys_sendmsg net/socket.c:2574 [inline]
>  __se_sys_sendmsg net/socket.c:2572 [inline]
>  __x64_sys_sendmsg+0x367/0x540 net/socket.c:2572
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 6.0.0-rc2-syzkaller-47461-gac3859c02d7f #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
>
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  include/net/sch_generic.h | 7 +++++++
>  net/sched/sch_taprio.c    | 3 +++
>  2 files changed, 10 insertions(+)
>
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index d5517719af4ef22282f0a15b132f8e8a07ae4179..af4aa66aaa4eba8f2eacdd00bc8fef31165c6a90 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -1288,4 +1288,11 @@ void mq_change_real_num_tx(struct Qdisc *sch, unsigned int new_real_tx);
>  
>  int sch_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
>  
> +/* Make sure qdisc is no longer in SCHED state. */
> +static inline void qdisc_synchronize(const struct Qdisc *q)
> +{
> +	while (test_bit(__QDISC_STATE_SCHED, &q->state))
> +		msleep(1);
> +}
> +
>  #endif
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 570389f6cdd7dbab5749dc06d886555305cbf623..9a11a499ea2df8d18c9c062496fdcbcf5a861391 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1700,6 +1700,8 @@ static void taprio_reset(struct Qdisc *sch)
>  	int i;
>  
>  	hrtimer_cancel(&q->advance_timer);
> +	qdisc_synchronize(sch);
> +

From the commit message, I got the impression that only the one
qdisc_synchronize() in taprio_destroy() would be needed.

>  	if (q->qdiscs) {
>  		for (i = 0; i < dev->num_tx_queues; i++)
>  			if (q->qdiscs[i])
> @@ -1720,6 +1722,7 @@ static void taprio_destroy(struct Qdisc *sch)
>  	 * happens in qdisc_create(), after taprio_init() has been called.
>  	 */
>  	hrtimer_cancel(&q->advance_timer);
> +	qdisc_synchronize(sch);
>  
>  	taprio_disable_offload(dev, q, NULL);
>  
> -- 
> 2.39.0.314.g84b9a713c41-goog
>


Cheers,
-- 
Vinicius
