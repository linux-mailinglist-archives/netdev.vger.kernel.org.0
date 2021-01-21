Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579A62FF89B
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbhAUXS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:18:57 -0500
Received: from mga05.intel.com ([192.55.52.43]:48154 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbhAUXSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 18:18:08 -0500
IronPort-SDR: Z4dNHbrHWEXV75VYo24uQU8AxQI99a7Rmdn0nrIqrgE4Biq8zTnVoRC7IoWIc11xzE/NzLP6WJ
 sThAd7I6a3eA==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="264180225"
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="264180225"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 15:17:25 -0800
IronPort-SDR: 0I/TA9zVNg72KVyzosHe8A0LZ4PD5lyNjuh/oLHqisu8RolKDcGW8wDCWHZ40xudti7vBybh3j
 KnwPRoxDc3ew==
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="392126925"
Received: from amgiffor-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.212.124.114])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 15:17:25 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v2 2/8] taprio: Add support for frame
 preemption offload
In-Reply-To: <20210119182133.038fbfc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210119004028.2809425-1-vinicius.gomes@intel.com>
 <20210119004028.2809425-3-vinicius.gomes@intel.com>
 <20210119182133.038fbfc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 21 Jan 2021 15:17:14 -0800
Message-ID: <878s8lyj5x.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Mon, 18 Jan 2021 16:40:22 -0800 Vinicius Costa Gomes wrote:
>> Adds a way to configure which traffic classes are marked as
>> preemptible and which are marked as express.
>> 
>> Even if frame preemption is not a "real" offload, because it can't be
>> executed purely in software, having this information near where the
>> mapping of traffic classes to queues is specified, makes it,
>> hopefully, easier to use.
>> 
>> taprio will receive the information of which traffic classes are
>> marked as express/preemptible, and when offloading frame preemption to
>> the driver will convert the information, so the driver receives which
>> queues are marked as express/preemptible.
>> 
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>
>> @@ -1286,13 +1289,15 @@ static int taprio_disable_offload(struct net_device *dev,
>>  	offload->enable = 0;
>>  
>>  	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
>> -	if (err < 0) {
>> +	if (err < 0)
>> +		NL_SET_ERR_MSG(extack,
>> +			       "Device failed to disable offload");
>> +
>> +	err = ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT, &preempt);
>> +	if (err < 0)
>>  		NL_SET_ERR_MSG(extack,
>>  			       "Device failed to disable offload");
>
> This was meant to say something else?

Yeah, better to say which offload failed to be disabled. Will fix.


Cheers,
-- 
Vinicius
