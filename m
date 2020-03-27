Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD13196020
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgC0U6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:58:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:48686 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbgC0U6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 16:58:05 -0400
IronPort-SDR: u3+kVBJ6sQ8n+y+u5xnPiJkL2mpOahcnb1yl1iBOXO9Pu1Gdtv14yqGVyzoYtKuk3NZ6b8hXW5
 oR1V9qEuUaFg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 13:58:04 -0700
IronPort-SDR: N18u+ekGRKSC9+8cSC3YByRl8AyUat8+5/8RL6+xDleJRUhzRefaKXPq4Eo0tto2IZCSOqiFZP
 Jzlu8OFKCGTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="266328211"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.167.177]) ([10.212.167.177])
  by orsmga002.jf.intel.com with ESMTP; 27 Mar 2020 13:58:03 -0700
Subject: Re: [PATCH net-next v3 01/11] devlink: prepare to support region
 operations
To:     tanhuazhong <tanhuazhong@huawei.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jiri Pirko <jiri@mellanox.com>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
 <20200326183718.2384349-2-jacob.e.keller@intel.com>
 <e993d962-0853-c84b-89cc-84699aed6ee2@huawei.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <f670654a-fd17-2dfa-dc58-b55f12fbed4b@intel.com>
Date:   Fri, 27 Mar 2020 13:58:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <e993d962-0853-c84b-89cc-84699aed6ee2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/2020 1:16 AM, tanhuazhong wrote:
> 
> 
> On 2020/3/27 2:37, Jacob Keller wrote:
>> Modify the devlink region code in preparation for adding new operations
>> on regions.
>>
>> Create a devlink_region_ops structure, and move the name pointer from
>> within the devlink_region structure into the ops structure (similar to
>> the devlink_health_reporter_ops).
>>
>> This prepares the regions to enable support of additional operations in
>> the future such as requesting snapshots, or accessing the region
>> directly without a snapshot.
>>
>> In order to re-use the constant strings in the mlx4 driver their
>> declaration must be changed to 'const char * const' to ensure the
>> compiler realizes that both the data and the pointer cannot change.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> Changes since RFC
>> * Picked up Jiri's Reviewed-by
>>
>>   drivers/net/ethernet/mellanox/mlx4/crdump.c | 16 +++++++++++----
>>   drivers/net/netdevsim/dev.c                 |  6 +++++-
>>   include/net/devlink.h                       | 16 +++++++++++----
>>   net/core/devlink.c                          | 22 ++++++++++-----------
>>   4 files changed, 40 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
>> index 64ed725aec28..cc2bf596c74b 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
>> @@ -38,8 +38,16 @@
>>   #define CR_ENABLE_BIT_OFFSET		0xF3F04
>>   #define MAX_NUM_OF_DUMPS_TO_STORE	(8)
>>   
>> -static const char *region_cr_space_str = "cr-space";
>> -static const char *region_fw_health_str = "fw-health";
>> +static const char * const region_cr_space_str = "cr-space";
>> +static const char * const region_fw_health_str = "fw-health";
>> +
>> +static const struct devlink_region_ops region_cr_space_ops = {
>> +	.name = region_cr_space_str,
>> +};
>> +
>> +static const struct devlink_region_ops region_fw_health_ops = {
>> +	.name = region_fw_health_str,
>> +};
>>  
> 
> 
> Hi, Jacob.
> 
> After pull net-next, I get below compiler errors:
> drivers/net/ethernet/mellanox//mlx4/crdump.c:45:10: error: initializer 
> element is not constant
>    .name = region_cr_space_str,
>            ^
> drivers/net/ethernet/mellanox//mlx4/crdump.c:45:10: note: (near 
> initialization for ‘region_cr_space_ops.name’)
> drivers/net/ethernet/mellanox//mlx4/crdump.c:50:10: error: initializer 
> element is not constant
>    .name = region_fw_health_str,
> 
> It seems the value of variables region_cr_space_str and 
> region_cr_space_str is unknown during compiling phase.
> 
> Huazhong.
> 

Based on some searching, this appears to be something where newer
versions of GCC and clang can recognize that "const char * const" is
safe to use as a constant expression, but older compilers cannot.

I'm going to submit a fix that uses a macro so that we avoid this
breakage on slightly older compilers.

Thanks,
Jake
