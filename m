Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B728315104E
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 20:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgBCTch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 14:32:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:28451 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgBCTch (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 14:32:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 11:32:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278837614"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 11:32:36 -0800
Subject: Re: [PATCH 03/15] devlink: add operation to take an immediate
 snapshot
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-4-jacob.e.keller@intel.com>
 <20200203115001.GE2260@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <6b97b131-65a2-e6d0-779e-d8ab31d5c0ae@intel.com>
Date:   Mon, 3 Feb 2020 11:32:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200203115001.GE2260@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/2020 3:50 AM, Jiri Pirko wrote:
> Thu, Jan 30, 2020 at 11:58:58PM CET, jacob.e.keller@intel.com wrote:
>> Add a new devlink command, DEVLINK_CMD_REGION_TAKE_SNAPSHOT. This
>> command is intended to enable userspace to request an immediate snapshot
>> of a region.
>>
>> Regions can enable support for requestable snapshots by implementing the
>> snapshot callback function in the region's devlink_region_ops structure.
>>
>> Implementations of this function callback should capture an immediate
>> copy of the data and return it and its destructor in the function
>> parameters. The core devlink code will generate a snapshot ID and create
>> the new snapshot while holding the devlink instance lock.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>> .../networking/devlink/devlink-region.rst     |  9 +++-
>> include/net/devlink.h                         |  7 +++
>> include/uapi/linux/devlink.h                  |  2 +
>> net/core/devlink.c                            | 46 +++++++++++++++++++
>> 4 files changed, 62 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>> index 1a7683e7acb2..262249e6c3fc 100644
>> --- a/Documentation/networking/devlink/devlink-region.rst
>> +++ b/Documentation/networking/devlink/devlink-region.rst
>> @@ -20,6 +20,11 @@ address regions that are otherwise inaccessible to the user.
>> Regions may also be used to provide an additional way to debug complex error
>> states, but see also :doc:`devlink-health`
>>
>> +Regions may optionally support capturing a snapshot on demand via the
>> +``DEVLINK_CMD_REGION_TAKE_SNAPSHOT`` netlink message. A driver wishing to
>> +allow requested snapshots must implement the ``.snapshot`` callback for the
>> +region in its ``devlink_region_ops`` structure.
>> +
>> example usage
>> -------------
>>
>> @@ -40,8 +45,8 @@ example usage
>>     # Delete a snapshot using:
>>     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
>>
>> -    # Trigger (request) a snapshot be taken:
>> -    $ devlink region trigger pci/0000:00:05.0/cr-space
>> +    # Request an immediate snapshot, if supported by the region
>> +    $ devlink region snapshot pci/0000:00:05.0/cr-space
> 
> 
> Hmm, the shapshot is now removed by user calling:
> 
> $ devlink region del DEV/REGION snapshot SNAPSHOT_ID
> That is using DEVLINK_CMD_REGION_DEL netlink command calling
> devlink_nl_cmd_region_del()
> 
> I think the creation should be symmetric. Something like:
> $ devlink region add DEV/REGION snapshot SNAPSHOT_ID
> SNAPSHOT_ID is either exact number or "any" if user does not care.
> The benefit of using user-passed ID value is that you can use this
> easily in scripts.
> 
> The existing unused netlink command DEVLINK_CMD_REGION_NEW would be used
> for this.
> 

So I have some concern trying to allow picking the snapshot id. I agree
it is useful, but want to make sure we pick the best design for how to
handle things.

Currently regions support taking a snapshot across multiple regions with
the same ID. this means that the region id value is stored per devlink
instead of per region.

If users can pick IDs, they can and probably will become sparse. This
means that we now need to be able to handle this.

If a user picks an ID, we want to ensure that the global region id
number is incremented properly so that we skip the used IDs, otherwise
those could accidentally collide.

The simplest solution is to just force the global ID to be 1 larger at a
minimum every time the userspace calls us with an ID.

But now what happens if a user requests a really large ID (U32_MAX - 1)?
and then we now overflow our region ID.

This was previously a rare occurrence, but has now become possibly common.

We could require/force the user to pick IDs within a limited range, and
have the automatic regions come from another range..

We could enhance ID selection to just pick "lowest number unused by any
region". This would allow re-using ID numbers after they've been
deleted.. I think this approach is the most robust but does require a
bit of extra computation.

Thanks,
Jake
