Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1C6308F22
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhA2VOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:14:23 -0500
Received: from mga07.intel.com ([134.134.136.100]:39741 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232918AbhA2VOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 16:14:19 -0500
IronPort-SDR: bzGFd2R9ddtCEJ8eD1VilS5l6q4aermBWFZ55/rnjtH7I4mi+pc94VJX6AOLa0dtpZUOx7ET/0
 0EjtvLrzqYgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="244570445"
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="244570445"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 13:13:37 -0800
IronPort-SDR: JaNwW4v4QH7/0Ro7wE3yxhf4sMkPEtmhv2deC0cRtP8dE2isQzmu4Kz1N3KmsaHucbiWMes/5c
 tqBLwFsAkVxg==
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="389464788"
Received: from ndatiri-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.145.249])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 13:13:37 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 2/8] taprio: Add support for frame
 preemption offload
In-Reply-To: <20210126000924.jjkjruzmh5lgrkry@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-3-vinicius.gomes@intel.com>
 <20210126000924.jjkjruzmh5lgrkry@skbuf>
Date:   Fri, 29 Jan 2021 13:13:24 -0800
Message-ID: <87wnvvsayz.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Fri, Jan 22, 2021 at 02:44:47PM -0800, Vinicius Costa Gomes wrote:
>> +	/* It's valid to enable frame preemption without any kind of
>> +	 * offloading being enabled, so keep it separated.
>> +	 */
>> +	if (tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]) {
>> +		u32 preempt = nla_get_u32(tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]);
>> +		struct tc_preempt_qopt_offload qopt = { };
>> +
>> +		if (preempt == U32_MAX) {
>> +			NL_SET_ERR_MSG(extack, "At least one queue must be not be preemptible");
>> +			err = -EINVAL;
>> +			goto free_sched;
>> +		}
>> +
>> +		qopt.preemptible_queues = tc_map_to_queue_mask(dev, preempt);
>> +
>> +		err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT,
>> +						    &qopt);
>> +		if (err)
>> +			goto free_sched;
>> +
>> +		q->preemptible_tcs = preempt;
>> +	}
>> +
>
> First I'm interested in the means: why check for preempt == U32_MAX when
> you determine that all traffic classes are preemptible? What if less
> than 32 traffic classes are used by the netdev? The check will be
> bypassed, won't it?

Good catch :-)

I wanted to have this (at least one express queue) handled in a
centralized way, but perhaps this should be handled best per driver.

>
> Secondly, why should at least one queue be preemptible? What's wrong
> with frame preemption being triggered by a tc-taprio window smaller than
> the packet size? This can happen regardless of traffic class.

It's the opposite, at least one queue needs to be marked
express/non-preemptible. But as I said above, perhaps this should be
handled in a per-driver way. I will remove this from taprio.

I think removing this check/limitation from taprio should solve the
second part of your question, right?


Cheers,
-- 
Vinicius
