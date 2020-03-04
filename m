Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB521796ED
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbgCDRnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:43:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:2281 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728361AbgCDRnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 12:43:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 09:43:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="scan'208";a="244009672"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 09:43:02 -0800
Subject: Re: [RFC PATCH v2 14/22] devlink: implement DEVLINK_CMD_REGION_NEW
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-15-jacob.e.keller@intel.com>
 <20200302174106.GC2168@nanopsycho>
 <6f0023d0-a151-87f0-db3a-df01b7e6c045@intel.com>
 <20200303093043.GB2178@nanopsycho>
 <861a914b-1e3c-fdb6-a452-96a0b5a5c2c0@intel.com>
 <20200304115818.GA4558@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <7bd8a09e-0e6f-afd3-f6a1-3a52d93d2720@intel.com>
Date:   Wed, 4 Mar 2020 09:43:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304115818.GA4558@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/4/2020 3:58 AM, Jiri Pirko wrote:
> Tue, Mar 03, 2020 at 06:51:37PM CET, jacob.e.keller@intel.com wrote:
>>
>> Hm. The flow here was about supporting both with and without snapshot
>> IDs. That will be gone in the next revision and should make the code clear.
>>
>> The IDs are stored in the IDR with either a NULL, or a pointer to a
>> refcount of the number of snapshots currently using them.
>>
>> On devlink_region_snapshot_create, the id must have been allocated by
>> the devlink_region_snapshot_id_get ahead of time by the driver.
>>
>> When devlink_region_snapshot_id_get is called, a NULL is inserted into
>> the IDR at a suitable ID number (i.e. one that does not yet have a
>> refcount).
>>
>> On devlink_region_snapshot_new, the callback for the new command, the ID
>> must be specified by userspace.
>>
>> Both cases, the ID is confirmed to not be in use for that region by
>> looping over all snapshots and checking to see if one can be found that
>> has the ID.
>>
>> In __devlink_region_snapshot_create, the IDR is checked to see if it is
>> already used. If so, the refcount is incremented. If there is no
>> refcount (i.e. the IDR returns NULL), a new refcount is created, set to
>> 1, and inserted.
>>
>> The basic idea is the refcount is "how many snapshots are actually using
>> this ID". Use of devlink_region_snapshot_id_get can "pre-allocate" an ID
>> value so that future calls to devlink_region_id_get won't re-use the
>> same ID number even if no snapshot with that ID has yet been created.
>>
>> The refcount isn't actually incremented until the snapshot is created
>> with that ID.
>>
>> Userspace never uses devlink_region_snapshot_id_get now, since it always
>> requires an ID to be chosen.
>>
>> On snapshot delete, the id refcount is reduced, and when it hits zero
>> the ID is released from the IDR. This way, IDs can be re-used as long as
>> no remaining snapshots on any region point to them.
>>
>> This system enables userspace to simply treat snapshot ids as unique to
>> each region, and to provide their own values on the command line. It
>> also preserves the behavior that devlink_region_snapshot_id_get will
>> never select an ID that is used by any region on that devlink, so that
>> the id can be safely used for multiple snapshots triggered at the same time.
>>
>> This will hopefully be more clear in the next revision.
> 
> Okay, I see. The code is a bit harder to follow.
> 

I'm open to suggestions for better alternatives, or ways to improve code
legibility.

I want to preserve the following properties:

* devlink_region_snapshot_id_get must choose IDs globally for the whole
devlink, so that the ID can safely be re-used across multiple regions.

* IDs must be reusable once all snapshots associated with the IDs have
been removed

* the new DEVLINK_CMD_REGION_NEW must allow userspace to select IDs

* selecting IDs via DEVLINK_CMD_REGION_NEW should not really require the
user to check more than the current interested snapshot

* userspace should be able to re-use the same ID across multiple regions
just like devlink_region_snapshot_id_get and driver triggered snapshots

So, in a sense, the IDs must be a combination of both global and local
to the region. When using an ID, the region must ensure that no more
than one snapshot on that region uses the id.

However, when selecting a new ID for use via the
devlink_region_snapshot_id_get(), it must select one that is not yet
used by *any* region.

That's where the IDR came into use. I'm not a huge fan of this, so maybe
there's something simpler.

We could just do a brute force search across all regions to find an ID
that isn't in use by any region snapshot....

Thanks,
Jake
