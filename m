Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB6B193548
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 02:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbgCZBah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 21:30:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:13096 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727574AbgCZBah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 21:30:37 -0400
IronPort-SDR: 9IsRsUCAjfJ/XFnd0Q/dwNMKUnGunmA9/r3XrCWJR0l8MWbsKIf0b5uDRwAJdMfxsY3KwGv/Ol
 /a+GgCnd7L9Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 18:30:37 -0700
IronPort-SDR: 4DGYCrHj9i+nvp3+rQtLQ4XVAEseIo7sGiS0gpQYkH4rpvKvR+AgbEgJ07eCI/6YPHHqVn2tEm
 I4Q8OEZ/2tSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="282331754"
Received: from cdalvizo-mobl1.amr.corp.intel.com (HELO [10.252.133.80]) ([10.252.133.80])
  by fmsmga002.fm.intel.com with ESMTP; 25 Mar 2020 18:30:36 -0700
Subject: Re: [PATCH 08/10] devlink: implement DEVLINK_CMD_REGION_NEW
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
 <20200324223445.2077900-9-jacob.e.keller@intel.com>
 <20200325164622.GZ11304@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <fe618551-3108-958a-ca6d-69c2b6fd43a6@intel.com>
Date:   Wed, 25 Mar 2020 18:30:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325164622.GZ11304@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/2020 9:46 AM, Jiri Pirko wrote:
> Tue, Mar 24, 2020 at 11:34:43PM CET, jacob.e.keller@intel.com wrote:
>> +
>> +	/* Check to make sure it's empty first */
>> +	if (xa_load(&devlink->snapshot_ids, id))
> 
> How this can happen? The entry was just allocated. WARN_ON.
> 

Sure, I'll add WARN_ON. I think the return should still be kept, since
it causes the caller to fail instead of accidentally overwriting the
snapshot count.

> 
>> +		return -EBUSY;
>> +
>> +	err = xa_err(xa_store(&devlink->snapshot_ids, id, xa_mk_value(0),
>> +			      GFP_KERNEL));
> 
> Just return and avoid err variable.
> 

Yep, done.


>> +
>> +	if (region->cur_snapshots == region->max_snapshots) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "The region has reached the maximum number of stored snapshots");
>> +		return -ENOMEM;
> 
> Maybe ENOBUFS or ENOSPC? ENOMEM seems odd as it is related to memory
> allocation fails which this is not.
> 

Hmmm. This actually appears to be duplicated from the snapshot_create
function which used ENOMEM. Will add a patch to clean that up first.

It seems like we end up duplicating checks from within the
__devlink_region_snapshot_create merely because we have the extack
pointer here...

> 
>> +	}
>> +
>> +	snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
>> +
>> +	if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in use");
>> +		return -EEXIST;
>> +	}
>> +
>> +	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
>> +	if (err) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in used");
> 
> Different message would be appropriate.
> 

Right. This is the "this shouldn't happen" case from above I think.

> 
>> +		return err;
>> +	}
>> +
>> +	err = region->ops->snapshot(devlink, info->extack, &data);
>> +	if (err)
>> +		goto err_decrement_snapshot_count;
>> +
>> +	err = __devlink_region_snapshot_create(region, data, snapshot_id);
>> +	if (err)
>> +		goto err_free_snapshot_data;
>> +
>> +	return 0;
>> +
>> +err_decrement_snapshot_count:
>> +	__devlink_snapshot_id_decrement(devlink, snapshot_id);
>> +err_free_snapshot_data:
> 
> In devlink the error labers are named according to actions that failed.
> Please align.
> 

Sure.

Thanks,
Jake
