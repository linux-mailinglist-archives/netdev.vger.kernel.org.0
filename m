Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C899333207
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 00:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhCIXoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 18:44:55 -0500
Received: from mga18.intel.com ([134.134.136.126]:32226 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232182AbhCIXo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 18:44:27 -0500
IronPort-SDR: hPqlTqXqTdYfEdDXM99G8skHTpWT7Q6TxiFRMcLqN6Kx3sSX+fiW/iDZUrF6g0hU6ZMP14ERqJ
 bRJ6P4zum9Pg==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="175944432"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="175944432"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 15:44:27 -0800
IronPort-SDR: agKuvYSnej3Xaxr0K2p2Srh8H8LcSYTiRL7ltArWdUJvB5aSYnGDbjk67P8JoTePzhblZKNa1f
 iMZlKkaMunPQ==
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="371715821"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.5.206]) ([10.209.5.206])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 15:44:26 -0800
Subject: Re: [RFC] devlink: health: add remediation type
To:     Jakub Kicinski <kuba@kernel.org>,
        Eran Ben Elisha <eranbe@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, saeedm@nvidia.com,
        andrew.gospodarek@broadcom.com, guglielmo.morandin@broadcom.com,
        eugenem@fb.com, eranbe@mellanox.com
References: <20210306024220.251721-1-kuba@kernel.org>
 <3d7e75bb-311d-ccd3-6852-cae5c32c9a8e@nvidia.com>
 <20210308091600.5f686fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <25fb28f1-03f9-8307-8d9b-22f81f94dfcd@nvidia.com>
 <20210309145206.43091cdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <f242ed68-d31b-527d-562f-c5a35123861a@intel.com>
Date:   Tue, 9 Mar 2021 15:44:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210309145206.43091cdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/2021 2:52 PM, Jakub Kicinski wrote:
> On Tue, 9 Mar 2021 16:18:58 +0200 Eran Ben Elisha wrote:
>>>> DLH_REMEDY_LOCAL_FIX: associated component will undergo a local
>>>> un-harmful fix attempt.
>>>> (e.g look for lost interrupt in mlx5e_tx_reporter_timeout_recover())  
>>>
>>> Should we make it more specific? Maybe DLH_REMEDY_STALL: device stall
>>> detected, resumed by re-trigerring processing, without reset?  
>>
>> Sounds good.
> 
> FWIW I ended up calling it:
> 
> + * @DLH_REMEDY_KICK: device stalled, processing will be re-triggered
> 
>>>> The assumption here is that a reporter's recovery function has one
>>>> remedy. But it can have few remedies and escalate between them. Did you
>>>> consider a bitmask?  
>>>
>>> Yes, I tried to explain in the commit message. If we wanted to support
>>> escalating remediations we'd also need separate counters etc. I think
>>> having a health reporter per remediation should actually work fairly
>>> well.  
>>
>> That would require reporter's recovery procedure failure to trigger 
>> health flow for other reporter.
>> So we can find ourselves with 2 RX reporters, sharing the same diagnose 
>> and dump callbacks, and each has other recovery flow.
>> Seems a bit counterintuitive.
> 
> Let's talk about particular cases. Otherwise it's too easy to
> misunderstand each other. I can't think of any practical case
> where escalation makes sense.
> 
>> Maybe, per reporter, exposing a counter per each supported remedy is not 
>> that bad?
> 
> It's a large change to the uAPI, and it makes vendors more likely 
> to lump different problems under a single reporter (although I take
> your point that it may cause over-splitting, but if we have to choose
> between the two my preference is "too granular").
> 


I also prefer keeping it more granular and forcing only a single
"remedy" per reporter. If that remedy fails, I liked the thought of
possibly having some way to indicate possible "hammer" remedies as some
sort of extended status.

i.e. our reporter can try one known to be effective remedy
automatically, and then if it fails it could somehow report an extended
status that indicates "we still failed to recover, and we think the
problem might be fixed with RELOAD/REBOOT/REIMAGE"

But I would keep those 3 larger remedies that require user intervention
out of the set of regular remedies, and more as some other way to
indicate they might help?

I really don't think escalation makes a lot of sense because it's far
more complicated and as an administrator I am not sure I want a remedy
which could have larger impacts like resetting the device if that could
cause other issues...

Thanks,
Jake
