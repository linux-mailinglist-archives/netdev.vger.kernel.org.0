Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919A9150D01
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 17:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbgBCQkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 11:40:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:4914 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729827AbgBCQku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 11:40:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 08:40:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278795647"
Received: from unknown (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 08:40:48 -0800
Subject: Re: [PATCH 13/15] devlink: support directly reading from region
 memory
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-14-jacob.e.keller@intel.com>
 <20200203134423.GG2260@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1c281a9f-0ab2-c1ca-ee56-4fe1072eabb6@intel.com>
Date:   Mon, 3 Feb 2020 08:40:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200203134423.GG2260@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/2020 5:44 AM, Jiri Pirko wrote:
> Thu, Jan 30, 2020 at 11:59:08PM CET, jacob.e.keller@intel.com wrote:
>> @@ -508,6 +508,10 @@ struct devlink_region_ops {
>> 			struct netlink_ext_ack *extack,
>> 			u8 **data,
>> 			devlink_snapshot_data_dest_t **destructor);
>> +	int (*read)(struct devlink *devlink,
>> +		    u64 curr_offset,
>> +		    u32 data_size,
>> +		    u8 *data);
> 
> Too much wrapping.
> 

Yep, will clean it up.

> 
>> };
>>
>> struct devlink_fmsg;
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index b2b855d12a11..5831b7b78915 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -4005,6 +4005,56 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
>> 	return err;
>> }
>>
>> +static int devlink_nl_region_read_direct_fill(struct sk_buff *skb,
>> +					      struct devlink *devlink,
>> +					      struct devlink_region *region,
>> +					      struct nlattr **attrs,
>> +					      u64 start_offset,
>> +					      u64 end_offset,
>> +					      bool dump,
>> +					      u64 *new_offset)
> 
> Again.

Yep.

> 
> 
>> +{
>> +	u64 curr_offset = start_offset;
>> +	int err = 0;
>> +	u8 *data;
>> +
>> +	/* Allocate and re-use a single buffer */
>> +	data = kzalloc(DEVLINK_REGION_READ_CHUNK_SIZE, GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	*new_offset = start_offset;
>> +
>> +	if (end_offset > region->size || dump)
>> +		end_offset = region->size;
>> +
>> +	while (curr_offset < end_offset) {
>> +		u32 data_size;
>> +
>> +		if (end_offset - curr_offset < DEVLINK_REGION_READ_CHUNK_SIZE)
>> +			data_size = end_offset - curr_offset;
>> +		else
>> +			data_size = DEVLINK_REGION_READ_CHUNK_SIZE;
>> +
>> +		err = region->ops->read(devlink, curr_offset, data_size, data);
> 
> There is a lot of code duplication is this function. Perhap there could
> be a cb and cb_priv here to distinguish shapshot and direct read?
> 
> 

So, I was looking into how to do this, and I have a couple of patches to
simplify this function:

first I removed the region parameter and replaced it with "snapshot",
which enabled removing the dump and calculating the end_offset in the
caller function properly...

The main problem I found in sharing code is that snapshots didn't need
to allocate a data buffer while the raw-read does.

I'll see about doing a sort of cb/cb_priv setup... I'm not 100%
convinced yet though.

> 
> 	direct = !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
> 

Makes sense.

> 
>> +
>> +	/* Region may not support direct read access */
>> +	if (direct && !region->ops->read) {
> 
> extack msg please.
> 

Yep.

Thanks,
Jake
