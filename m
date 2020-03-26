Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206D4194419
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 17:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgCZQPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 12:15:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:23568 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728069AbgCZQPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 12:15:24 -0400
IronPort-SDR: eIxUvDR5pJ9oHVDwUnsXUcJwJylx4zdOYX/V09mYsI/I5HFvmNMCZAHh3lNXwk6/p4IwxpHnFB
 svIc2baix/2A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 09:15:06 -0700
IronPort-SDR: rqzXdL1cRnNU49NskH2Weu4BUmEqCHxVMzR5eQ2VX1bfhugY6mwZoKnVv7NaMUjcFEhAvkXeUC
 9CDdjsn/6ZfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="282552200"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.179.43]) ([10.254.179.43])
  by fmsmga002.fm.intel.com with ESMTP; 26 Mar 2020 09:15:05 -0700
Subject: Re: [net-next v2 00/11] implement DEVLINK_CMD_REGION_NEW
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326075101.GK11304@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <5fd22fe6-bdd6-33dd-126e-19b83f34297f@intel.com>
Date:   Thu, 26 Mar 2020 09:15:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326075101.GK11304@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/2020 12:51 AM, Jiri Pirko wrote:
>> Changes to patches since v1:
>>
>> * devlink: prepare to support region operations
>>
>>   No changes
>>
>> * devlink: convert snapshot destructor callback to region op
>>
>>   No changes
>>
>> * devlink: trivial: fix tab in function documentation
>>
>>   No changes
>>
>> * devlink: add function to take snapshot while locked
>>
>>   Added Jakub's Reviewed-by tag.
>>
>> * <NEW> devlink: use -ENOSPC to indicate no more room for snapshots
>>
>>   New patch added to convert confusing -ENOMEM to -ENOSPC, as suggested by
>>   Jiri.
>>
>> * devlink: extract snapshot id allocation to helper function
>>
>>   No changes
>>
>> * devlink: convert snapshot id getter to return an error
>>
>>   Changed title to "devlink: report error once U32_MAX snapshot ids have
>>   been used".
>>
>>   Refactored this patch to make devlink_region_snapshot_id_get take a
>>   pointer to u32, so that the error value and id value are separated. This
>>   means that we can remove the INT_MAX limitation on id values.
>>
>> * devlink: track snapshot id usage count using an xarray
>>
>>   Fixed the xa_init to use xa_init_flags with XA_FLAGS_ALLOC, so that
>>   xa_alloc can properly be used.
>>
>>   Changed devlink_region_snapshot_id_get to use an initial count of 1
>>   instead of 0. Added a new devlink_region_snapshot_id_put function, used
>>   to release this initial count. This closes the race condition and issues
>>   caused if the driver either doesn't create a snapshot, or if userspace
>>   deletes the first snapshot before others are created.
>>
>>   Used WARN_ON in a few more checks that should not occur, such as if the
>>   xarray entry is not a value, or when the id isn't yet in the xarray.
>>
>>   Removed an unnecessary if (err) { return err; } construction.
>>
>>   Use xa_limit_32b instead of xa_limit_31b now that we don't return the
>>   snapshot id directly.
>>
>>   Cleanup the label used in __devlink_region_snapshot_create to indicate the
>>   failure cause, rather than the cleanup step.
>>
>>   Removed the unnecessary locking around xa_destroy
>>
>> * devlink: implement DEVLINK_CMD_REGION_NEW
>>
>>   Added a WARN_ON to the check in snapshot_id_insert in case the id already
>>   exists.
>>
>>   Removed an unnecessary "if (err) { return err; }" construction
>>
>>   Use -ENOSPC instead of -ENOMEM when max_snapshots is reached.
>>
>>   Cleanup label names to match style of the other labels in the file,
>>   naming after the failure cause rather than the cleanup step. Also fix a
>>   bug in the label ordering.
>>
>>   Call the new devlink_region_snapshot_id_put function in the mlx4 and
>>   netdevsim drivers.
>>
>> * netdevsim: support taking immediate snapshot via devlink
>>
>>   Create a local devlink pointer instead of calling priv_to_devlink
>>   multiple times.
>>
>>   Removed previous selftest for devlink region new without a snapshot id,
>>   as this is no longer supported. Adjusted and verified that the tests pass
>>   now.
>>
>> * ice: add a devlink region for dumping NVM contents
>>
>>   Use "dev_err" instead of "dev_warn" for a message about failure to create
>>   the devlink region.
> 
> Could you please have the changelog per-patch, as I suggested for v1?
> Much easier to review then.

What do you mean? I already broke this into a description of the change
for each patch, I thought that's what you wanted..

Do you want me to move this into the individual commit emails?
