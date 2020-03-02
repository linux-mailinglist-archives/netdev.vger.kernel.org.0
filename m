Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53E41766DB
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 23:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgCBWZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 17:25:19 -0500
Received: from mga17.intel.com ([192.55.52.151]:31863 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgCBWZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 17:25:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 14:25:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="258119664"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga002.jf.intel.com with ESMTP; 02 Mar 2020 14:25:16 -0800
Subject: Re: [RFC PATCH v2 11/22] devlink: add functions to take snapshot
 while locked
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-12-jacob.e.keller@intel.com>
 <20200302174355.GG2168@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <2261c128-7a8c-a8ae-0bdc-3b856995aabb@intel.com>
Date:   Mon, 2 Mar 2020 14:25:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302174355.GG2168@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/2020 9:43 AM, Jiri Pirko wrote:
> Sat, Feb 15, 2020 at 12:22:10AM CET, jacob.e.keller@intel.com wrote:
>> A future change is going to add a new devlink command to request
>> a snapshot on demand. This function will want to call the
>> devlink_region_snapshot_id_get and devlink_region_snapshot_create
>> functions while already holding the devlink instance lock.
>>
>> Extract the logic of these two functions into static functions prefixed
>> by `__` to indicate they are internal helper functions. Modify the
>> original functions to be implemented in terms of the new locked
>> functions.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> 
> 
>> ---
>> net/core/devlink.c | 93 ++++++++++++++++++++++++++++++----------------
>> 1 file changed, 61 insertions(+), 32 deletions(-)
>>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index fef93f48028c..0e94887713f4 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -3760,6 +3760,65 @@ static void devlink_nl_region_notify(struct devlink_region *region,
>> 	nlmsg_free(msg);
>> }
>>
>> +/**
>> + *	__devlink_region_snapshot_id_get - get snapshot ID
>> + *	@devlink: devlink instance
>> + *
>> + *	Returns a new snapshot id. Must be called while holding the
>> + *	devlink instance lock.
>> + */
> 
> You don't need this docu comment for static functions.
> 
> 

I like having these for all functions. I'll remove it if you feel
strongly, though.

Thanks,
Jake
