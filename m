Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89F22651CB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgIJVCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:02:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:52600 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbgIJVCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 17:02:08 -0400
IronPort-SDR: fLL0wxw0KWCH12Oz8KzagKSyQnPtvHtkT5fefkwEKRTJaMXSFfXIEAEkW0mnnuMM16mc/+vxBx
 UKOYXqCcPoyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="146330396"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="146330396"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 14:01:58 -0700
IronPort-SDR: Z1nkll0zBEbh5dhOtekI37F+YjDPnVsoCKYHpQ8mAgULHEv7q750couvkXwGXstfRaiaHNFjpq
 FIjQZ+2xPXTw==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="505968802"
Received: from pojenhsi-mobl1.amr.corp.intel.com (HELO [10.252.128.198]) ([10.252.128.198])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 14:01:57 -0700
Subject: Re: [net-next v4 3/5] devlink: introduce flash update overwrite mask
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
 <20200909222653.32994-4-jacob.e.keller@intel.com>
 <20200909180310.27a19827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <3faf14a5-e7da-2ad7-bdeb-0bbb6038c349@intel.com>
Date:   Thu, 10 Sep 2020 14:01:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200909180310.27a19827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 6:03 PM, Jakub Kicinski wrote:
> On Wed,  9 Sep 2020 15:26:51 -0700 Jacob Keller wrote:
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index 40d35145c879..19a573566359 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -228,6 +228,28 @@ enum {
>>  	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
>>  };
>>  
>> +/* Specify what sections of a flash component can be overwritten when
>> + * performing an update. Overwriting of firmware binary sections is always
>> + * implicitly assumed to be allowed.
>> + *
>> + * Each section must be documented in
>> + * Documentation/networking/devlink/devlink-flash.rst
>> + *
>> + */
>> +enum {
>> +	DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT,
>> +	DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT,
>> +
>> +	__DEVLINK_FLASH_OVERWRITE_MAX_BIT,
>> +	DEVLINK_FLASH_OVERWRITE_MAX_BIT = __DEVLINK_FLASH_OVERWRITE_MAX_BIT - 1
>> +};
>> +
>> +#define DEVLINK_FLASH_OVERWRITE_SETTINGS BIT(DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT)
>> +#define DEVLINK_FLASH_OVERWRITE_IDENTIFIERS BIT(DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT)
>> +
>> +#define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
>> +	(BIT(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
> 
> I don't think you can use BIT() in uAPI headers :(
> 


Hmmm.. There are exactly 2 other uses I found by searching for 'BIT('
that already exists. We can chance this to just do the bit shift directly.

>>  /**
>>   * enum devlink_trap_action - Packet trap action.
>>   * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
>> @@ -460,6 +482,9 @@ enum devlink_attr {
>>  
>>  	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
>>  	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,	/* u32 */
>> +
>> +	DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK,	/* bitfield32 */
>> +
>>  	/* add new attributes above here, update the policy in devlink.c */
>>  
>>  	__DEVLINK_ATTR_MAX,
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index c61f9c8205f6..d0d38ca17ea8 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -3125,8 +3125,8 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>>  				       struct genl_info *info)
>>  {
>>  	struct devlink_flash_update_params params = {};
>> +	struct nlattr *nla_component, *nla_overwrite;
>>  	struct devlink *devlink = info->user_ptr[0];
>> -	struct nlattr *nla_component;
>>  	u32 supported_params;
>>  
>>  	if (!devlink->ops->flash_update)
>> @@ -3149,6 +3149,19 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>>  		params.component = nla_data(nla_component);
>>  	}
>>  
>> +	nla_overwrite = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
>> +	if (nla_overwrite) {
>> +		struct nla_bitfield32 sections;
>> +
>> +		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK)) {
>> +			NL_SET_ERR_MSG_ATTR(info->extack, nla_overwrite,
>> +					    "overwrite is not supported");
> 
> settings ... by this device ?

Sure I can fix this along with the other location either as a follow up
or a respin if this still needs it.

Thanks,
Jake

> 
>> +			return -EOPNOTSUPP;
>> +		}
>> +		sections = nla_get_bitfield32(nla_overwrite);
>> +		params.overwrite_mask = sections.value & sections.selector;
>  
> 
