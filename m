Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8CD176697
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 23:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgCBWL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 17:11:29 -0500
Received: from mga07.intel.com ([134.134.136.100]:18523 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgCBWL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 17:11:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 14:11:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="258116042"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga002.jf.intel.com with ESMTP; 02 Mar 2020 14:11:29 -0800
Subject: Re: [RFC PATCH v2 14/22] devlink: implement DEVLINK_CMD_REGION_NEW
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-15-jacob.e.keller@intel.com>
 <20200302174106.GC2168@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <dc013102-2105-d706-d12c-540cb40efd7d@intel.com>
Date:   Mon, 2 Mar 2020 14:11:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302174106.GC2168@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/2020 9:41 AM, Jiri Pirko wrote:
> Sat, Feb 15, 2020 at 12:22:13AM CET, jacob.e.keller@intel.com wrote:
>> +++ b/include/net/devlink.h
>> @@ -498,10 +498,16 @@ struct devlink_info_req;
>>  * struct devlink_region_ops - Region operations
>>  * @name: region name
>>  * @destructor: callback used to free snapshot memory when deleting
>> + * @snapshot: callback to request an immediate snapshot. On success,
>> + *            the data variable must be updated to point to the snapshot data.
>> + *            The function will be called while the devlink instance lock is
>> + *            held.
>>  */
>> struct devlink_region_ops {
>> 	const char *name;
>> 	void (*destructor)(const void *data);
>> +	int (*snapshot)(struct devlink *devlink, struct netlink_ext_ack *extack,
>> +			u8 **data);
> 
> Please have the same type here and for destructor. "u8 *" I guess.
> 
So, changing the destructor to take a const u8 * is problematic, because
it can then no longer directly take kfree, vfree, or kvfree.

I'd be happy to change the snapshot function so that it takes a void **
though.

Thanks,
Jake
