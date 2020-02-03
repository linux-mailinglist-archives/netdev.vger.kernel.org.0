Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB379150E64
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgBCRKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:10:11 -0500
Received: from mga17.intel.com ([192.55.52.151]:18792 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbgBCRKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 12:10:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 09:10:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278802407"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 09:10:10 -0800
Subject: Re: [PATCH 01/15] devlink: prepare to support region operations
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-2-jacob.e.keller@intel.com>
 <20200203113529.GC2260@nanopsycho>
 <375672b9-5464-c25e-da7b-e435cc505a5c@intel.com>
Organization: Intel Corporation
Message-ID: <91f0e32d-4992-d954-d315-09fdc8382883@intel.com>
Date:   Mon, 3 Feb 2020 09:10:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <375672b9-5464-c25e-da7b-e435cc505a5c@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/2020 9:07 AM, Jacob Keller wrote:
> On 2/3/2020 3:35 AM, Jiri Pirko wrote:
>> Thu, Jan 30, 2020 at 11:58:56PM CET, jacob.e.keller@intel.com wrote:
>>> Modify the devlink region code in preparation for adding new operations
>>> on regions.
>>>
>>> Create a devlink_region_ops structure, and move the name pointer from
>>> within the devlink_region structure into the ops structure (similar to
>>> the devlink_health_reporter_ops).
>>>
>>> This prepares the regions to enable support of additional operations in
>>> the future such as requesting snapshots, or accessing the region
>>> directly without a snapshot.
>>>
>>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>>> ---
>>> drivers/net/ethernet/mellanox/mlx4/crdump.c | 25 ++++++++++++---------
>>> drivers/net/netdevsim/dev.c                 |  6 ++++-
>>> include/net/devlink.h                       | 17 ++++++++++----
>>> net/core/devlink.c                          | 23 ++++++++++---------
>>> 4 files changed, 45 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
>>> index 64ed725aec28..4cea64033919 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
>>> @@ -38,8 +38,13 @@
>>> #define CR_ENABLE_BIT_OFFSET		0xF3F04
>>> #define MAX_NUM_OF_DUMPS_TO_STORE	(8)
>>>
>>> -static const char *region_cr_space_str = "cr-space";
>>> -static const char *region_fw_health_str = "fw-health";
>>
>> Just leave these as are and use in ops and messages. It is odd to use
>> ops.name in the message.
>>
> 
> So this produces the following errors, not 100% sure how to resolve:
> 
> 
>> drivers/net/ethernet/mellanox/mlx4/crdump.c:45:10: error: initializer element is not constant
>>    45 |  .name = region_cr_space_str,
>>       |          ^~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/mellanox/mlx4/crdump.c:45:10: note: (near initialization for ‘region_cr_space_ops.name’)
>> drivers/net/ethernet/mellanox/mlx4/crdump.c:49:10: error: initializer element is not constant
>>    49 |  .name = region_fw_health_str,
>>       |          ^~~~~~~~~~~~~~~~~~~~
> 
> 
> Thanks,
> Jake
> 

Heh, this is fixed by using static const char * const <name>, to ensure
that the compiler realizes both the pointer and the contents are constant.

Thanks,
Jake
