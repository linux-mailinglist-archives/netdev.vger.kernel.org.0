Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905A45BA26F
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 23:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiIOVwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 17:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiIOVwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 17:52:31 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCDB5071C;
        Thu, 15 Sep 2022 14:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663278751; x=1694814751;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=aC8XDko2Od/oVihXmArEE30uN77ZIMmtAMndXQ2rO3A=;
  b=UBiuXLFKz7UeArYnrImTVwfdwN0dD/qNcUar7BxO8RMJ1drvmEJDrf0H
   ZQ0FsMjvyB+TBuzRmGiCD12ALBL6LQz1JDCbYSaNTRaR4HfK8O1u5Hda+
   Yru8OPcgujS65zgzYffLj65TE9N5Kra/Tfi3ye9M8xB3N+30mcUh+lXcB
   Oaj7VwXf5be/0Bpftu8GIigSqRASW/eZNRukuKKoLP+GXI87iQZfcuIXx
   8IpUAdcpr5yMHizps5x7g5oJbjEk///+RAu2iERdolODYzmRB2pgihkQq
   5T1f5vCKde7TjktDqBKpz67VlidBD/c+wjBglPAKCYqMhW/PD6xJK3HBp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="281876910"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="281876910"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 14:52:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="862510330"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 14:52:29 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net 1/2] net/sched: taprio: avoid disabling offload
 when it was never enabled
In-Reply-To: <20220915100802.2308279-2-vladimir.oltean@nxp.com>
References: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
 <20220915100802.2308279-2-vladimir.oltean@nxp.com>
Date:   Thu, 15 Sep 2022 14:52:29 -0700
Message-ID: <877d24gvaa.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> In an incredibly strange API design decision, qdisc->destroy() gets
> called even if qdisc->init() never succeeded, not exclusively since
> commit 87b60cfacf9f ("net_sched: fix error recovery at qdisc creation"),
> but apparently also earlier (in the case of qdisc_create_dflt()).
>
> The taprio qdisc does not fully acknowledge this when it attempts full
> offload, because it starts off with q->flags = TAPRIO_FLAGS_INVALID in
> taprio_init(), then it replaces q->flags with TCA_TAPRIO_ATTR_FLAGS
> parsed from netlink (in taprio_change(), tail called from taprio_init()).
>
> But in taprio_destroy(), we call taprio_disable_offload(), and this
> determines what to do based on FULL_OFFLOAD_IS_ENABLED(q->flags).
>
> But looking at the implementation of FULL_OFFLOAD_IS_ENABLED()
> (a bitwise check of bit 1 in q->flags), it is invalid to call this macro
> on q->flags when it contains TAPRIO_FLAGS_INVALID, because that is set
> to U32_MAX, and therefore FULL_OFFLOAD_IS_ENABLED() will return true on
> an invalid set of flags.
>
> As a result, it is possible to crash the kernel if user space forces an
> error between setting q->flags = TAPRIO_FLAGS_INVALID, and the calling
> of taprio_enable_offload(). This is because drivers do not expect the
> offload to be disabled when it was never enabled.
>
> The error that we force here is to attach taprio as a non-root qdisc,
> but instead as child of an mqprio root qdisc:
>
> $ tc qdisc add dev swp0 root handle 1: \
> 	mqprio num_tc 8 map 0 1 2 3 4 5 6 7 \
> 	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
> $ tc qdisc replace dev swp0 parent 1:1 \
> 	taprio num_tc 8 map 0 1 2 3 4 5 6 7 \
> 	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 0 \
> 	sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
> 	flags 0x0 clockid CLOCK_TAI
> Unable to handle kernel paging request at virtual address fffffffffffffff8
> [fffffffffffffff8] pgd=0000000000000000, p4d=0000000000000000
> Internal error: Oops: 96000004 [#1] PREEMPT SMP
> Call trace:
>  taprio_dump+0x27c/0x310
>  vsc9959_port_setup_tc+0x1f4/0x460
>  felix_port_setup_tc+0x24/0x3c
>  dsa_slave_setup_tc+0x54/0x27c
>  taprio_disable_offload.isra.0+0x58/0xe0
>  taprio_destroy+0x80/0x104
>  qdisc_create+0x240/0x470
>  tc_modify_qdisc+0x1fc/0x6b0
>  rtnetlink_rcv_msg+0x12c/0x390
>  netlink_rcv_skb+0x5c/0x130
>  rtnetlink_rcv+0x1c/0x2c
>
> Fix this by keeping track of the operations we made, and undo the
> offload only if we actually did it.
>
> I've added "bool offloaded" inside a 4 byte hole between "int clockid"
> and "atomic64_t picos_per_byte". Now the first cache line looks like
> below:
>
> $ pahole -C taprio_sched net/sched/sch_taprio.o
> struct taprio_sched {
>         struct Qdisc * *           qdiscs;               /*     0     8 */
>         struct Qdisc *             root;                 /*     8     8 */
>         u32                        flags;                /*    16     4 */
>         enum tk_offsets            tk_offset;            /*    20     4 */
>         int                        clockid;              /*    24     4 */
>         bool                       offloaded;            /*    28     1 */
>
>         /* XXX 3 bytes hole, try to pack */
>
>         atomic64_t                 picos_per_byte;       /*    32     0 */
>
>         /* XXX 8 bytes hole, try to pack */
>
>         spinlock_t                 current_entry_lock;   /*    40     0 */
>
>         /* XXX 8 bytes hole, try to pack */
>
>         struct sched_entry *       current_entry;        /*    48     8 */
>         struct sched_gate_list *   oper_sched;           /*    56     8 */
>         /* --- cacheline 1 boundary (64 bytes) --- */
>
> Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
-- 
Vinicius
