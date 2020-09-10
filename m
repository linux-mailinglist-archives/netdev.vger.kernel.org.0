Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11418265238
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgIJVKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:10:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:36093 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgIJVKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 17:10:24 -0400
IronPort-SDR: lVLCSwNUsHdRkNUnKRDrQzcZZLm5tUOd7oK/ViARKH4YlnhSZI9SceZNlMFnyUMLpHVCfK9oGr
 zzFsx6GNlp5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="146357987"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="146357987"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 14:10:20 -0700
IronPort-SDR: gF2fqwiNDaRP7wsVxGYlHneiIdRDfnlcWhzhH5KRzk9phFKvHEzGkCBswoxaK3nJD1RCleIvSX
 K7VQFNVzEV5g==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="505970949"
Received: from pojenhsi-mobl1.amr.corp.intel.com (HELO [10.252.128.198]) ([10.252.128.198])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 14:10:19 -0700
Subject: Re: [net-next v4 3/5] devlink: introduce flash update overwrite mask
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
 <20200909222653.32994-4-jacob.e.keller@intel.com>
 <20200910201040.GU2997@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <176ead4c-6007-8ff7-d4d1-4ae2bc7408d6@intel.com>
Date:   Thu, 10 Sep 2020 14:10:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910201040.GU2997@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 1:10 PM, Jiri Pirko wrote:
> Thu, Sep 10, 2020 at 12:26:51AM CEST, jacob.e.keller@intel.com wrote:
>> Sections of device flash may contain settings or device identifying
>> information. When performing a flash update, it is generally expected
>> that these settings and identifiers are not overwritten.
>>
>> However, it may sometimes be useful to allow overwriting these fields
>> when performing a flash update. Some examples include, 1) customizing
>> the initial device config on first programming, such as overwriting
>> default device identifying information, or 2) reverting a device
>> configuration to known good state provided in the new firmware image, or
>> 3) in case it is suspected that current firmware logic for managing the
>> preservation of fields during an update is broken.
>>
>> Although some devices are able to completely separate these types of
>> settings and fields into separate components, this is not true for all
>> hardware.
>>
>> To support controlling this behavior, a new
>> DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK is defined. This is an
>> nla_bitfield32 which will define what subset of fields in a component
>> should be overwritten during an update.
>>
>> If no bits are specified, or of the overwrite mask is not provided, then
>> an update should not overwrite anything, and should maintain the
>> settings and identifiers as they are in the previous image.
>>
>> If the overwrite mask has the DEVLINK_FLASH_OVERWRITE_SETTINGS bit set,
>> then the device should be configured to overwrite any of the settings in
>> the requested component with settings found in the provided image.
>>
>> Similarly, if the DEVLINK_FLASH_OVERWRITE_IDENTIFIERS bit is set, the
>> device should be configured to overwrite any device identifiers in the
>> requested component with the identifiers from the image.
>>
>> Multiple overwrite modes may be combined to indicate that a combination
>> of the set of fields that should be overwritten.
>>
>> Drivers which support the new overwrite mask must set the
>> DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK in the
>> supported_flash_update_params field of their devlink_ops.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>> Changes since v3
>> * split netdevsim driver changes to a new patch
>> * fixed a double-the typo in the documentation
>>
>> .../networking/devlink/devlink-flash.rst      | 28 +++++++++++++++++++
>> include/net/devlink.h                         |  4 ++-
>> include/uapi/linux/devlink.h                  | 25 +++++++++++++++++
>> net/core/devlink.c                            | 17 ++++++++++-
>> 4 files changed, 72 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/networking/devlink/devlink-flash.rst b/Documentation/networking/devlink/devlink-flash.rst
>> index 40a87c0222cb..603e732f00cc 100644
>> --- a/Documentation/networking/devlink/devlink-flash.rst
>> +++ b/Documentation/networking/devlink/devlink-flash.rst
>> @@ -16,6 +16,34 @@ Note that the file name is a path relative to the firmware loading path
>> (usually ``/lib/firmware/``). Drivers may send status updates to inform
>> user space about the progress of the update operation.
>>
>> +Overwrite Mask
>> +==============
>> +
>> +The ``devlink-flash`` command allows optionally specifying a mask indicating
>> +how the device should handle subsections of flash components when updating.
>> +This mask indicates the set of sections which are allowed to be overwritten.
>> +
>> +.. list-table:: List of overwrite mask bits
>> +   :widths: 5 95
>> +
>> +   * - Name
>> +     - Description
>> +   * - ``DEVLINK_FLASH_OVERWRITE_SETTINGS``
>> +     - Indicates that the device should overwrite settings in the components
>> +       being updated with the settings found in the provided image.
>> +   * - ``DEVLINK_FLASH_OVERWRITE_IDENTIFIERS``
>> +     - Indicates that the device should overwrite identifiers in the
>> +       components being updated with the identifiers found in the provided
>> +       image. This includes MAC addresses, serial IDs, and similar device
>> +       identifiers.
>> +
>> +Multiple overwrite bits may be combined and requested together. If no bits
>> +are provided, it is expected that the device only update firmware binaries
>> +in the components being updated. Settings and identifiers are expected to be
>> +preserved across the update. A device may not support every combination and
>> +the driver for such a device must reject any combination which cannot be
>> +faithfully implemented.
>> +
>> Firmware Loading
>> ================
>>
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 3384e901bbf0..ff4638f7e547 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -543,9 +543,11 @@ enum devlink_param_generic_id {
>> struct devlink_flash_update_params {
>> 	const char *file_name;
>> 	const char *component;
>> +	u32 overwrite_mask;
>> };
>>
>> -#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT	BIT(0)
>> +#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT		BIT(0)
>> +#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
>>
>> struct devlink_region;
>> struct devlink_info_req;
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index 40d35145c879..19a573566359 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -228,6 +228,28 @@ enum {
>> 	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
>> };
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
>> +
>> /**
>>  * enum devlink_trap_action - Packet trap action.
>>  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
>> @@ -460,6 +482,9 @@ enum devlink_attr {
>>
>> 	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
>> 	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,	/* u32 */
>> +
>> +	DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK,	/* bitfield32 */
>> +
>> 	/* add new attributes above here, update the policy in devlink.c */
>>
>> 	__DEVLINK_ATTR_MAX,
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index c61f9c8205f6..d0d38ca17ea8 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -3125,8 +3125,8 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>> 				       struct genl_info *info)
>> {
>> 	struct devlink_flash_update_params params = {};
>> +	struct nlattr *nla_component, *nla_overwrite;
>> 	struct devlink *devlink = info->user_ptr[0];
>> -	struct nlattr *nla_component;
>> 	u32 supported_params;
>>
>> 	if (!devlink->ops->flash_update)
>> @@ -3149,6 +3149,19 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>> 		params.component = nla_data(nla_component);
>> 	}
>>
>> +	nla_overwrite = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
> 
> Just a nitpick, better to name this "nla_overwrite_mask" to follow the
> name of the netlink attr.
> 
> Otherwise (extept the uapi BIT as Jakub pointed out) this looks fine to
> me.
> 

Sure, seems reasonable. Will fix in v5

Thanks,
Jake
