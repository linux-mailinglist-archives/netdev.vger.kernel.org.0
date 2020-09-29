Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B2E27D54A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgI2SAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:00:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:57221 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI2SAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 14:00:02 -0400
IronPort-SDR: jL13ofgkUssht0pT5qgfTnarolMevraNiPTNio4XID+F8snRrKrYJgXXFHTn82ASG31D3NkNOM
 DCWp5qNwTe/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="159588253"
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="159588253"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 11:00:02 -0700
IronPort-SDR: y7K4NrFtf2eDmH+s0bgb/iZ10uZXJ9EOKssRMglFveXS5zpDqh6vG5kv9I2g0ImuLUJCozsdfQ
 B0OV3tv/vC9Q==
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="492582019"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.162.133]) ([10.209.162.133])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 11:00:01 -0700
Subject: Re: [iproute2-next v4 0/2] devlink: add flash update overwrite mask
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>, Jakub Kicinski <kuba@kernel.org>
References: <20200909222842.33952-1-jacob.e.keller@intel.com>
 <198b8a34-49de-88e8-629c-408e592f42a6@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <cb936247-bdab-4712-be89-dbd8efcef0fe@intel.com>
Date:   Tue, 29 Sep 2020 11:00:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <198b8a34-49de-88e8-629c-408e592f42a6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/2020 8:33 AM, David Ahern wrote:
> On 9/9/20 3:28 PM, Jacob Keller wrote:
>> This series implements the iproute2 side of the new
>> DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK.
>>
>> This attribute is used to allow userspace to indicate what a device should
>> do with various subsections of a flash component when updating. For example,
>> a flash component might contain vital data such as the PCIe serial number or
>> configuration fields such as settings that control device bootup.
>>
>> The overwrite mask allows the user to specify what behavior they want when
>> performing an update. If nothing is specified, then the update should
>> preserve all vital fields and configuration.
>>
>> By specifying "overwrite identifiers" the user requests that the flash
>> update should overwrite any identifiers in the updated flash component with
>> identifier values from the provided flash image.
>>
>>   $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite identifiers
>>
>> By specifying "overwrite settings" the user requests that the flash update
>> should overwrite any settings in the updated flash component with setting
>> values from the provided flash image.
>>
>>   $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite settings
>>
>> These options may be combined, in which case both subsections will be sent
>> in the overwrite mask, resulting in a request to overwrite all settings and
>> identifiers stored in the updated flash components.
>>
>>   $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite settings overwrite identifiers
>>
>> Cc: Jiri Pirko <jiri@mellanox.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>>
>> Jacob Keller (2):
>>   Update devlink header for overwrite mask attribute
>>   devlink: support setting the overwrite mask
>>
>>  devlink/devlink.c            | 48 ++++++++++++++++++++++++++++++++++--
>>  include/uapi/linux/devlink.h | 27 ++++++++++++++++++++
>>  2 files changed, 73 insertions(+), 2 deletions(-)
>>
>>
>> base-commit: ad34d5fadb0b4699b0fe136fc408685e26bb1b43
>>
> 
> Jacob:
> 
> Compile fails on Ubuntu 20.04:
> 
> devlink
>     CC       devlink.o
> In file included from devlink.c:29:
> devlink.c: In function ‘flash_overwrite_section_get’:
> ../include/uapi/linux/devlink.h:249:42: warning: implicit declaration of
> function ‘_BITUL’ [-Wimplicit-function-declaration]
>   249 | #define DEVLINK_FLASH_OVERWRITE_SETTINGS
> _BITUL(DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT)
>       |                                          ^~~~~~
> devlink.c:1293:12: note: in expansion of macro
> ‘DEVLINK_FLASH_OVERWRITE_SETTINGS’
>  1293 |   *mask |= DEVLINK_FLASH_OVERWRITE_SETTINGS;
>       |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     CC       mnlg.o
>     LINK     devlink
> 
> I updated headers in -next; please redo the patch set and roll the cover
> letter details in patch 2.
> 

This appears to be because uapi/linux/const.h isn't included... I am not
sure what the correct fix here is.. should this be part of the include
chain for uapi/linux/devlink.h? I could add this to the devlink.c file
but that feels incorrect since the definition/usage is in
uapi/linux/devlink.h...

Thanks,
Jake
