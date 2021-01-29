Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819C13090B7
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhA2XnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:43:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:29035 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhA2XnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 18:43:21 -0500
IronPort-SDR: guPjTYpA+CIytSSiatj7kkG+tu2MR4MfuEGA8oG9dTMICyUsEJhyv4qy024Vk2EmAdPQnONQsW
 mWO1J4MOcDGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="180571257"
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="180571257"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 15:42:21 -0800
IronPort-SDR: CkefGfh+LEwuiLDBgw7k8G7FURdIK3z157wbd6ILH+0p6NSygcIjcyI3cs3+y/7VzorsTksM2n
 RC639m9SUVrg==
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="370581788"
Received: from ndatiri-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.145.249])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 15:42:19 -0800
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
In-Reply-To: <20210129232015.atl4336zqy4ev3bi@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-3-vinicius.gomes@intel.com>
 <20210126000924.jjkjruzmh5lgrkry@skbuf>
 <87wnvvsayz.fsf@vcostago-mobl2.amr.corp.intel.com>
 <20210129232015.atl4336zqy4ev3bi@skbuf>
Date:   Fri, 29 Jan 2021 15:42:05 -0800
Message-ID: <87zh0rqpiq.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Fri, Jan 29, 2021 at 01:13:24PM -0800, Vinicius Costa Gomes wrote:
>> > Secondly, why should at least one queue be preemptible? What's wrong
>> > with frame preemption being triggered by a tc-taprio window smaller than
>> > the packet size? This can happen regardless of traffic class.
>>
>> It's the opposite, at least one queue needs to be marked
>> express/non-preemptible.
>
> I meant to ask why should at least one queue be express. The second part
> of the question remains valid.
>
>> But as I said above, perhaps this should be handled in a per-driver
>> way. I will remove this from taprio.
>>
>> I think removing this check/limitation from taprio should solve the
>> second part of your question, right?
>
> Nope. Can you point me to either 802.1Q or 802.3 saying that at least
> one priority should go to the express MAC?

After re-reading Anex Q, I know it's informative, and
thinking/remembering things a bit better, it seems that the standard
only defines preemption of express queues/priorities over preemptible
traffic. The standard doesn't talk about preemptible pririoties
preempting other preemptible priorities.

So, if there's no express queue, no preemption is going to happen, so it
shouldn't be enabled, to avoid like an invalid/useless state.

So I am going to take back my previous email: this seems like it's
better to be kept in a centralized place.


Cheers,
-- 
Vinicius
