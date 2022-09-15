Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE235BA275
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 23:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiIOVyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 17:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiIOVyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 17:54:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9F35071C;
        Thu, 15 Sep 2022 14:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663278855; x=1694814855;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=7pY0xV07EAduso1MOQg/k77RZEBE43kmtmng6uKuueI=;
  b=UlHjPc83CgcQ2wDIu1IhmW7dMtXBwGWS0raxluaYrFyxL2Vm+iKfQngr
   6zmI5GJCxHfgR9jqrlI9Ewoy9QDyidFgeUBea3Ywz1U5gwWddSglIWS/6
   2+3KoJKNQVEg9C3P6c5tiHNyYgKi73MxxrrE6pQ2qrwhTA0FbsduiumPH
   v7aH4YjHmyjsDINCyq+lEO4DTbZoVk2PdvDGB88PB5iGWCak519VmB1Da
   v8/tesnsKdlN/NugaBG/gWlHwzMfE7NX/5LzIVHtAp/zstaf8246+7wf9
   Ey5vP0ojIEf3f7VacTO8zOz9ImB+laCctFwu+x4ylu6/It+2FgJXGH2mU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="278576999"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="278576999"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 14:54:15 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="679716984"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 14:54:14 -0700
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
Subject: Re: [PATCH v2 net 2/2] net/sched: taprio: make qdisc_leaf() see the
 per-netdev-queue pfifo child qdiscs
In-Reply-To: <20220915100802.2308279-3-vladimir.oltean@nxp.com>
References: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
 <20220915100802.2308279-3-vladimir.oltean@nxp.com>
Date:   Thu, 15 Sep 2022 14:54:14 -0700
Message-ID: <87wna4fgmx.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> taprio can only operate as root qdisc, and to that end, there exists the
> following check in taprio_init(), just as in mqprio:
>
> 	if (sch->parent != TC_H_ROOT)
> 		return -EOPNOTSUPP;
>
> And indeed, when we try to attach taprio to an mqprio child, it fails as
> expected:
>
> $ tc qdisc add dev swp0 root handle 1: mqprio num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 \
> 	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
> $ tc qdisc replace dev swp0 parent 1:2 taprio num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 \
> 	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
> 	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
> 	flags 0x0 clockid CLOCK_TAI
> Error: sch_taprio: Can only be attached as root qdisc.
>
> (extack message added by me)
>
> But when we try to attach a taprio child to a taprio root qdisc,
> surprisingly it doesn't fail:
>
> $ tc qdisc replace dev swp0 root handle 1: taprio num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
> 	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
> 	flags 0x0 clockid CLOCK_TAI
> $ tc qdisc replace dev swp0 parent 1:2 taprio num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 \
> 	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
> 	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
> 	flags 0x0 clockid CLOCK_TAI
>
> This is because tc_modify_qdisc() behaves differently when mqprio is
> root, vs when taprio is root.
>
> In the mqprio case, it finds the parent qdisc through
> p = qdisc_lookup(dev, TC_H_MAJ(clid)), and then the child qdisc through
> q = qdisc_leaf(p, clid). This leaf qdisc q has handle 0, so it is
> ignored according to the comment right below ("It may be default qdisc,
> ignore it"). As a result, tc_modify_qdisc() goes through the
> qdisc_create() code path, and this gives taprio_init() a chance to check
> for sch_parent != TC_H_ROOT and error out.
>
> Whereas in the taprio case, the returned q = qdisc_leaf(p, clid) is
> different. It is not the default qdisc created for each netdev queue
> (both taprio and mqprio call qdisc_create_dflt() and keep them in
> a private q->qdiscs[], or priv->qdiscs[], respectively). Instead, taprio
> makes qdisc_leaf() return the _root_ qdisc, aka itself.
>
> When taprio does that, tc_modify_qdisc() goes through the qdisc_change()
> code path, because the qdisc layer never finds out about the child qdisc
> of the root. And through the ->change() ops, taprio has no reason to
> check whether its parent is root or not, just through ->init(), which is
> not called.
>
> The problem is the taprio_leaf() implementation. Even though code wise,
> it does the exact same thing as mqprio_leaf() which it is copied from,
> it works with different input data. This is because mqprio does not
> attach itself (the root) to each device TX queue, but one of the default
> qdiscs from its private array.
>
> In fact, since commit 13511704f8d7 ("net: taprio offload: enforce qdisc
> to netdev queue mapping"), taprio does this too, but just for the full
> offload case. So if we tried to attach a taprio child to a fully
> offloaded taprio root qdisc, it would properly fail too; just not to a
> software root taprio.
>
> To fix the problem, stop looking at the Qdisc that's attached to the TX
> queue, and instead, always return the default qdiscs that we've
> allocated (and to which we privately enqueue and dequeue, in software
> scheduling mode).
>
> Since Qdisc_class_ops :: leaf  is only called from tc_modify_qdisc(),
> the risk of unforeseen side effects introduced by this change is
> minimal.
>
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

I spent a long time trying to think of cases that this would break,
could not think of anything:


Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
-- 
Vinicius
