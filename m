Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012CB14F224
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgAaS1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:27:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:47358 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgAaS1v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:27:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 10:27:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="377419792"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2020 10:27:50 -0800
Subject: Re: [PATCH 13/15] devlink: support directly reading from region
 memory
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-14-jacob.e.keller@intel.com>
 <20200131100744.61ec7632@cakuba.hsd1.ca.comcast.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <ac873daa-cf78-94cc-b088-e6992a4d9a32@intel.com>
Date:   Fri, 31 Jan 2020 10:27:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200131100744.61ec7632@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/2020 10:07 AM, Jakub Kicinski wrote:
> On Thu, 30 Jan 2020 14:59:08 -0800, Jacob Keller wrote:
>> Add a new region operation for directly reading from a region, without
>> taking a full snapshot.
>>
>> Extend the DEVLINK_CMD_REGION_READ to allow directly reading from
>> a region, if supported. Instead of reporting a missing snapshot id as
>> invalid, check to see if direct reading is implemented for the region.
>> If so, use the direct read operation to grab the current contents of the
>> region.
>>
>> This new behavior of DEVLINK_CMD_REGION_READ should be backwards
>> compatible. Previously, all kernels rejected such
>> a DEVLINK_CMD_REGION_READ with -EINVAL, and will now either accept the
>> call or report -EOPNOTSUPP for regions which do not implement direct
>> access.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
>> +static int devlink_nl_region_read_direct_fill(struct sk_buff *skb,
>> +					      struct devlink *devlink,
>> +					      struct devlink_region *region,
>> +					      struct nlattr **attrs,
>> +					      u64 start_offset,
>> +					      u64 end_offset,
>> +					      bool dump,
>> +					      u64 *new_offset)
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
> 
> Also known as min() ?
> 

Heh. Yep.

>> +		err = region->ops->read(devlink, curr_offset, data_size, data);
>> +		if (err)
>> +			break;
>> +
>> +		err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
>> +							    data, data_size,
>> +							    curr_offset);
>> +		if (err)
>> +			break;
>> +
>> +		curr_offset += data_size;
>> +	}
>> +	*new_offset = curr_offset;
>> +
>> +	kfree(data);
>> +
>> +	return err;
>> +}
>> +
>>  static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>>  					     struct netlink_callback *cb)
>>  {
> 
>> +	/* Region may not support direct read access */
>> +	if (direct && !region->ops->read) {
> 
> for missing trigger you added an extack, perhaps makes sense here, too?
> 

Sure.

>> +		err = -EOPNOTSUPP;
>> +		goto out_unlock;
>> +	}
>> +
>>  	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
>>  			  &devlink_nl_family, NLM_F_ACK | NLM_F_MULTI,
>>  			  DEVLINK_CMD_REGION_READ);
> 
> Generally all the devlink parts look quite reasonable to me 👍
> 
