Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BAB67A848
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 02:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjAYBLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 20:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjAYBLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 20:11:45 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA10C301B3
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 17:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674609103; x=1706145103;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=qncDB4QX71FDulKG670LVutXjZKlsfXS3s115zvu0WY=;
  b=ZS/4REf1ttkJ0clZjDRKcPQ7lpRw9OcJlApR0OmnIyD8WO0Ks66xN+v/
   xP5Oa/GJ+c58B4PDWcQtjTwkQnEv8vXRu9LEgqfUm6iL1g0a9sOVsMBwD
   MIXNQ4W5koyZXCJCTdJVt7+JRSsbwsRiKNK1UzguCrGYJV9KyZANPw2JA
   UaRFG5MfLv4SN3rXq00L/RZxaCF1Y0sWcyFsK+bKdNk9Auxi+ss9LQnE4
   iaBy3ObUiDHQjCiIFXp/TOcaXW0FC7eXE5QFd6wjmRGWhiJ9xblupGZY9
   kRDMtEHUE8Gm3LQJBP2q0i9Vm+JmXKvRd9XB+NsuxuIlgZf4Idhy8Nxq+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="326488727"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="326488727"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 17:11:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="991098001"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="991098001"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.17])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 17:11:29 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [RFC PATCH net-next 00/11] ENETC mqprio/taprio cleanup
In-Reply-To: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
Date:   Tue, 24 Jan 2023 17:11:29 -0800
Message-ID: <87tu0fh0zi.fsf@intel.com>
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

Hi Vladimir,

Sorry for the delay. I had to sleep on this for a bit.

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> I realize that this patch set will start a flame war, but there are
> things about the mqprio qdisc that I simply don't understand, so in an
> attempt to explain how I see things should be done, I've made some
> patches to the code. I hope the reviewers will be patient enough with me :)
>
> I need to touch mqprio because I'm preparing a patch set for Frame
> Preemption (an IEEE 802.1Q feature). A disagreement started with
> Vinicius here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220816222920.1952936-3-vladimir.oltean@nxp.com/#24976672
>
> regarding how TX packet prioritization should be handled. Vinicius said
> that for some Intel NICs, prioritization at the egress scheduler stage
> is fundamentally attached to TX queues rather than traffic classes.
>
> In other words, in the "popular" mqprio configuration documented by him:
>
> $ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
>       num_tc 3 \
>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>       queues 1@0 1@1 2@2 \
>       hw 0
>
> there are 3 Linux traffic classes and 4 TX queues. The TX queues are
> organized in strict priority fashion, like this: TXQ 0 has highest prio
> (hardware dequeue precedence for TX scheduler), TXQ 3 has lowest prio.
> Packets classified by Linux to TC 2 are hashed between TXQ 2 and TXQ 3,
> but the hardware has higher precedence for TXQ2 over TXQ 3, and Linux
> doesn't know that.
>
> I am surprised by this fact, and this isn't how ENETC works at all.
> For ENETC, we try to prioritize on TCs rather than TXQs, and TC 7 has
> higher priority than TC 7. For us, groups of TXQs that map to the same
> TC have the same egress scheduling priority. It is possible (and maybe
> useful) to have 2 TXQs per TC - one TXQ per CPU). Patch 07/11 tries to
> make that more clear.
>

That makes me think, making "queues" visible on mqprio/taprio perhaps
was a mistake. Perhaps if we only had the "prio to tc" map, and relied
on drivers implementing .ndo_select_queue() that would be less
problematic. And for devices with tens/hundreds of queues, this "no
queues to the user exposed" sounds like a better model. Anyway... just
wondering.

Perhaps something to think about for mqprio/taprio/etc "the next generation" ;-)

> Furthermore (and this is really the biggest point of contention), myself
> and Vinicius have the fundamental disagreement whether the 802.1Qbv
> (taprio) gate mask should be passed to the device driver per TXQ or per
> TC. This is what patch 11/11 is about.
>

I think that I was being annoying because I believed that some
implementation detail of the netdev prio_tc_map and the way that netdev
select TX queues (the "core of how mqprio works") would leak, and it
would be easier/more correct to make other vendors adapt themselves to
the "Intel"/"queues have priorities" model. But I stand corrected, as
you (and others) have proven.

In short, I am not opposed to this idea. This capability operation
really opens some possibilities. The patches look clean.

I'll play with the patches later in the week, quite swamped at this
point.

> Again, I'm not *certain* that my opinion on this topic is correct
> (and it sure is confusing to see such a different approach for Intel).
> But I would appreciate any feedback.

And that reminds me, I owe you a beverage of your choice. For all your
effort.

>
> Vladimir Oltean (11):
>   net/sched: mqprio: refactor nlattr parsing to a separate function
>   net/sched: mqprio: refactor offloading and unoffloading to dedicated
>     functions
>   net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to
>     pkt_sched.h
>   net/sched: mqprio: allow offloading drivers to request queue count
>     validation
>   net/sched: mqprio: add extack messages for queue count validation
>   net: enetc: request mqprio to validate the queue counts
>   net: enetc: act upon the requested mqprio queue configuration
>   net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
>   net: enetc: act upon mqprio queue config in taprio offload
>   net/sched: taprio: validate that gate mask does not exceed number of
>     TCs
>   net/sched: taprio: only calculate gate mask per TXQ for igc
>
>  drivers/net/ethernet/freescale/enetc/enetc.c  |  67 ++--
>  .../net/ethernet/freescale/enetc/enetc_qos.c  |  27 +-
>  drivers/net/ethernet/intel/igc/igc_main.c     |  17 +
>  include/net/pkt_cls.h                         |  10 -
>  include/net/pkt_sched.h                       |  16 +
>  net/sched/sch_mqprio.c                        | 298 +++++++++++-------
>  net/sched/sch_taprio.c                        |  57 ++--
>  7 files changed, 310 insertions(+), 182 deletions(-)
>
> -- 
> 2.34.1
>

Cheers,
-- 
Vinicius
