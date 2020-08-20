Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFA824AC77
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 02:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgHTA6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 20:58:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:58520 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgHTA6p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 20:58:45 -0400
IronPort-SDR: loICRunhvDHatnWe/lP5VT/PQ9yVn7SNRl7X7uLEYdabi1s0V1Im/UWl7NOzvZJWlM/YhnsMP4
 b5wPKhVqTTLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="155191456"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="155191456"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 17:58:45 -0700
IronPort-SDR: wClf4+WLudkLZJxrUjmzhUul2ouBVI+8BLyu9fgdCzBwnDIcJTi2tuO8lfmWEA4JZNbwah/fae
 bOVWh5wPo6Og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="497429600"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.62.21]) ([10.254.62.21])
  by fmsmga006.fm.intel.com with ESMTP; 19 Aug 2020 17:58:44 -0700
Subject: Re: [net-next v3 1/4] devlink: check flash_update parameter support
 in net core
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com, luobin9@huawei.com,
        saeedm@mellanox.com, leon@kernel.org, idosch@mellanox.com,
        danieller@mellanox.com
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
 <20200819002821.2657515-2-jacob.e.keller@intel.com>
 <20200819.163610.793690736242734635.davem@davemloft.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <2eb17b37-3bb2-12ac-2ea5-956537e45e45@intel.com>
Date:   Wed, 19 Aug 2020 17:58:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200819.163610.793690736242734635.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/2020 4:36 PM, David Miller wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> Date: Tue, 18 Aug 2020 17:28:15 -0700
> 
>> @@ -991,6 +993,12 @@ enum devlink_trap_group_generic_id {
>>  	}
>>  
>>  struct devlink_ops {
>> +	/**
>> +	 * @supported_flash_update_params:
>> +	 * mask of parameters supported by the driver's .flash_update
>> +	 * implemementation.
>> +	 */
>> +	u32 supported_flash_update_params;
>>  	int (*reload_down)(struct devlink *devlink, bool netns_change,
>>  			   struct netlink_ext_ack *extack);
>>  	int (*reload_up)(struct devlink *devlink,
> 
> Jakub asked if this gave W=1 warnings.  Then you responded that you didn't
> see any warnings with allmodconfig nor allyesconfig, but that isn't the
> question Jakub asked.
> 

Ah, yes I should have been more specific:

> Are you building with W=1 explicitly added to the build?
>

I did

$ make allyesconfig
$ make W=1 &>allyes.txt
$ cat allyes.txt | grep warning | grep devlink
drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c:917: warning: Function
parameter or member 'devlink' not described in 'hinic_init_hwdev'



and
$ make allmodconfig
$ make W=1 *>allmod.txt
$ cat allyes.txt | grep warning | grep devlink
drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c:917: warning: Function
parameter or member 'devlink' not described in 'hinic_init_hwdev'
I also looked at those manually, there's about 15k warnings with W=1 on
allyesconfig, but none of them appear to be related to the changes in
this patch.

> The issue is this kerneldoc might not be formatted correctly, and such
> warnings won't be presented without doing a W=1 build.
> 
> Thank you.
> 

Sure.

I also manually ran:

$ ./scripts/kernel-doc -v -none include/uapi/linux/devlink.h
include/uapi/linux/devlink.h:232: info: Scanning doc for enum
devlink_trap_action
include/uapi/linux/devlink.h:246: info: Scanning doc for enum
devlink_trap_type

Hope this helps clarify.

Thanks,
Jake
