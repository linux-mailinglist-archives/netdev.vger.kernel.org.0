Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A7A51C609
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 19:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241201AbiEER30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 13:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiEER3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 13:29:25 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953121CB3D
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651771545; x=1683307545;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=D+BqhT70vbLafzy+DK3O9NAC4LWB46z53YNgbk8g8fU=;
  b=im/AsqPSi98G425QlPapoHN/jxeKsykr6gUFcuvPC9hIkKsC0cxSbb5p
   g57Gz6cYXrRf95x7ImQdLjqSwFJbOSkN/lzHLF2E996cunn3jfuqxqnbE
   paxbIgCiRGOfZ7W/71+sKcq39XAyyI4DdXCU3wGzo8aa7ND8QlwsKcFBJ
   dIueXZWTnBlvJ3kQawnlEYwrHLW1egojNAU1G/n2tX8NlKZkPzZSo8ecS
   25fKyu/06ZgPcJ6Utb2J0wyrqF5nmCGRxtERGG/z0a9YpDiBpy3I1m8H4
   wYtvb90WH4SjV+ShSc7P1nvoHHzG+LceAurrLrFMzF2YLmMJiseKgHXJH
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328731949"
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="328731949"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 10:25:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="735002972"
Received: from lkhorgan-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.22.233])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 10:25:44 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [RFC PATCH net] net/sched: taprio: account for L1 overhead when
 calculating transmit time
In-Reply-To: <20220505160357.298794-1-vladimir.oltean@nxp.com>
References: <20220505160357.298794-1-vladimir.oltean@nxp.com>
Date:   Thu, 05 May 2022 10:25:44 -0700
Message-ID: <87bkwbj3hj.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> The taprio scheduler underestimates the packet transmission time, which
> means that packets can be scheduled for transmission in time slots in
> which they are never going to fit.
>
> When this function was added in commit 4cfd5779bd6e ("taprio: Add
> support for txtime-assist mode"), the only implication was that time
> triggered packets would overrun its time slot and eat from the next one,
> because with txtime-assist there isn't really any emulation of a "gate
> close" event that would stop a packet from being transmitted.
>
> However, commit b5b73b26b3ca ("taprio: Fix allowing too small
> intervals") started using this function too, in all modes of operation
> (software, txtime-assist and full offload). So we now accept time slots
> which we know we won't be ever able to fulfill.
>
> It's difficult to say which issue is more pressing, I'd say both are
> visible with testing, even though the second would be more obvious
> because of a black&white result (trying to send small packets in an
> insufficiently large window blocks the queue).
>
> Issue found through code inspection, the code was not even compile
> tested.
>
> The L1 overhead chosen here is an approximation, because various network
> equipment has configurable IFG, however I don't think Linux is aware of
> this.

When testing CBS, I remember using tc-stab: 

https://man7.org/linux/man-pages/man8/tc-stab.8.html

To set the 'overhead' to some value.

That value should be used in the calculation.

I agree that it's not ideal, in the ideal world we would have a way to
retrieve the link overhead from the netdevice. But I would think that it
gets complicated really quickly when using netdevices that are not
Ethernet-based.

>
> Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/sched/sch_taprio.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index b9c71a304d39..8c8681c37d4f 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -176,7 +176,10 @@ static ktime_t get_interval_end_time(struct sched_gate_list *sched,
>  
>  static int length_to_duration(struct taprio_sched *q, int len)
>  {
> -	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
> +	/* The duration of frame transmission should account for L1 overhead
> +	 * (12 octets IFG, 7 octets of preamble, 1 octet SFD, 4 octets FCS)
> +	 */
> +	return div_u64((24 + len) * atomic64_read(&q->picos_per_byte), 1000);
>  }
>  
>  /* Returns the entry corresponding to next available interval. If
> -- 
> 2.25.1
>

-- 
Vinicius
