Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17B32D1DC0
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 23:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgLGWuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 17:50:18 -0500
Received: from mga17.intel.com ([192.55.52.151]:13846 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgLGWuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 17:50:17 -0500
IronPort-SDR: 5knJ8AEKSCNvQXMh9dNmeN7jNZ6aLjXDZ68CHhwLeIuJeoL3HIUwmMfTb0jjYYQFmh3AXGUgHn
 wi0VInFLMV5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="153603944"
X-IronPort-AV: E=Sophos;i="5.78,400,1599548400"; 
   d="scan'208";a="153603944"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 14:49:37 -0800
IronPort-SDR: ODaUQAZ3BLah67IoOPHBxkxghvSngj6ZE1icJN47RQSI6jfpBzXINHyN680/1x7+uJG0VY1Um6
 fZyEaFblKuKw==
X-IronPort-AV: E=Sophos;i="5.78,400,1599548400"; 
   d="scan'208";a="370135684"
Received: from seherahx-mobl1.amr.corp.intel.com (HELO ellie) ([10.209.17.196])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 14:49:36 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1 0/9] ethtool: Add support for frame preemption
In-Reply-To: <20201205095021.36e1a24d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
 <20201205095021.36e1a24d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Mon, 07 Dec 2020 14:49:35 -0800
Message-ID: <87o8j5z0xs.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue,  1 Dec 2020 20:53:16 -0800 Vinicius Costa Gomes wrote:
>> $ tc qdisc replace dev $IFACE parent root handle 100 taprio \
>>       num_tc 3 \
>>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>>       queues 1@0 1@1 2@2 \
>>       base-time $BASE_TIME \
>>       sched-entry S 0f 10000000 \
>>       preempt 1110 \
>>       flags 0x2 
>> 
>> The "preempt" parameter is the only difference, it configures which
>> queues are marked as preemptible, in this example, queue 0 is marked
>> as "not preemptible", so it is express, the rest of the four queues
>> are preemptible.
>
> Does it make more sense for the individual queues to be preemptible 
> or not, or is it better controlled at traffic class level?
> I was looking at patch 2, and 32 queues isn't that many these days..
> We either need a larger type there or configure this based on classes.

I can set more future proof sizes for expressing the queues, sure, but
the issue, I think, is that frame preemption has dimishing returns with
link speed: at 2.5G the latency improvements are on the order of single
digit microseconds. At greater speeds the improvements are even less
noticeable.

The only adapters that I see that support frame preemtion have 8 queues
or less. 

The idea of configuring frame preemption based on classes is
interesting. I will play with it, and see how it looks.


Cheers,
-- 
Vinicius
