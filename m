Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C905017823D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733079AbgCCSJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:09:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:55204 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732015AbgCCRvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 12:51:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 09:51:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="229005582"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2020 09:51:37 -0800
Subject: Re: [RFC PATCH v2 14/22] devlink: implement DEVLINK_CMD_REGION_NEW
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-15-jacob.e.keller@intel.com>
 <20200302174106.GC2168@nanopsycho>
 <6f0023d0-a151-87f0-db3a-df01b7e6c045@intel.com>
 <20200303093043.GB2178@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <861a914b-1e3c-fdb6-a452-96a0b5a5c2c0@intel.com>
Date:   Tue, 3 Mar 2020 09:51:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303093043.GB2178@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/3/2020 1:30 AM, Jiri Pirko wrote:
> Mon, Mar 02, 2020 at 08:38:12PM CET, jacob.e.keller@intel.com wrote:
>> On 3/2/2020 9:41 AM, Jiri Pirko wrote:
>>> Without ID? I would personally require snapshot id always. Without it,
>>> it looks like you are creating region.
>>>
>>
>> Not specifying an ID causes the ID to be auto-selected. I suppose
>> support for that doesn't need to be kept.
> 
> Yeah, I would avoid it.
> 
> 

Done.

>>> Please have the same type here and for destructor. "u8 *" I guess.
>>>
>> Sure. My only concern would be if that causes a compiler warning when
>> passing kfree/vfree to the destructor pointer. Alternatively we could
>> use void **data, but it's definitely interpreted as a byte stream by the
>> devlink core code.
> 
> I see. Leave it as is then.
> 

Ok.


>>> In devlink.c, please don't wrap here.
>>>
>>
>> For any of these?
> 
> Yep.
> 

Done.

> 
>>
>>>
>>>> +				   "The requested region does not exist");
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	if (!region->ops->snapshot) {
>>>> +		NL_SET_ERR_MSG_MOD(info->extack,
>>>> +				   "The requested region does not support taking an immediate snapshot");
>>>> +		return -EOPNOTSUPP;
>>>> +	}
>>>> +
>>>> +	if (region->cur_snapshots == region->max_snapshots) {
>>>> +		NL_SET_ERR_MSG_MOD(info->extack,
>>>> +				   "The region has reached the maximum number of stored snapshots");
>>>> +		return -ENOMEM;
>>>> +	}
>>>> +
>>>> +	if (info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>>>> +		/* __devlink_region_snapshot_create will take care of
>>>> +		 * inserting the snapshot id into the IDR if necessary.
>>>> +		 */
>>>> +		snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
>>>> +
>>>> +		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>>>> +			NL_SET_ERR_MSG_MOD(info->extack,
>>>> +					   "The requested snapshot id is already in use");
>>>> +			return -EEXIST;
>>>> +		}
>>>> +	} else {
>>>> +		snapshot_id = __devlink_region_snapshot_id_get(devlink);
>>>> +	}
>>>> +
>>>> +	err = region->ops->snapshot(devlink, info->extack, &data);
>>>
>>> Don't you put the "id"? Looks like a leak.
>>>
>>
>> The id is put into the devlink_region_snapshot_create, the driver code
>> doesn't need to know about it as far as I can tell.
>>
>> Currently the ids are managed by an IDR which stores a reference count
>> of how many snapshots use it.
>>
>> Use of "NULL" is done so that devlink_region_snapshot_id_get can
>> "pre-allocate" the ID without assigning snapshots, assuming that a later
>> call to the devlink_region_snapshot_create will find that id and create
>> or increment it's refcount.
>>
>> This complexity comes from the fact that the current code requires the
>> ability to re-use the same snapshot id for different regions in the same
>> devlink. This devlink_region_snapshot_id_get must return IDs which are
>> unique across all regions. If a user does DEVLINK_CMD_REGION_NEW with an
>> ID, it would only be used by a single snapshot. We need to make sure
>> that this doesn't confuse devlink_region_snapshot_id_get. Additionally,
>> I wanted to make sure that the snapshot IDs could be re-used once the
>> related snapshots have been deleted.
> 
> Okay, I see. I'm just worried about possible scenario when user does
> alloc up to max of u32 and always hits the error path.
> 

Hm. The flow here was about supporting both with and without snapshot
IDs. That will be gone in the next revision and should make the code clear.

The IDs are stored in the IDR with either a NULL, or a pointer to a
refcount of the number of snapshots currently using them.

On devlink_region_snapshot_create, the id must have been allocated by
the devlink_region_snapshot_id_get ahead of time by the driver.

When devlink_region_snapshot_id_get is called, a NULL is inserted into
the IDR at a suitable ID number (i.e. one that does not yet have a
refcount).

On devlink_region_snapshot_new, the callback for the new command, the ID
must be specified by userspace.

Both cases, the ID is confirmed to not be in use for that region by
looping over all snapshots and checking to see if one can be found that
has the ID.

In __devlink_region_snapshot_create, the IDR is checked to see if it is
already used. If so, the refcount is incremented. If there is no
refcount (i.e. the IDR returns NULL), a new refcount is created, set to
1, and inserted.

The basic idea is the refcount is "how many snapshots are actually using
this ID". Use of devlink_region_snapshot_id_get can "pre-allocate" an ID
value so that future calls to devlink_region_id_get won't re-use the
same ID number even if no snapshot with that ID has yet been created.

The refcount isn't actually incremented until the snapshot is created
with that ID.

Userspace never uses devlink_region_snapshot_id_get now, since it always
requires an ID to be chosen.

On snapshot delete, the id refcount is reduced, and when it hits zero
the ID is released from the IDR. This way, IDs can be re-used as long as
no remaining snapshots on any region point to them.

This system enables userspace to simply treat snapshot ids as unique to
each region, and to provide their own values on the command line. It
also preserves the behavior that devlink_region_snapshot_id_get will
never select an ID that is used by any region on that devlink, so that
the id can be safely used for multiple snapshots triggered at the same time.

This will hopefully be more clear in the next revision.
