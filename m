Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D74F21BE78
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGJUcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:32:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:33706 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgGJUco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 16:32:44 -0400
IronPort-SDR: 9KQ6IZ4TfasSxMvWX8oVVfsw5zTYFqtZRLhxvQ7lYOJEZFMgcG4NJmKrKaXD4JDpKFSbbxioSy
 kdjvmQyyFfww==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="128351387"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="128351387"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 13:32:44 -0700
IronPort-SDR: mBllMJrAAJSMCnAPwpVKD9HSlYj8eidmBTasBEQjGQpdSUAFbgEeBtJvU+aJYFUmZOrMApDP7b
 UwVEgi5cvKWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="306660504"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.20.152]) ([10.212.20.152])
  by fmsmga004.fm.intel.com with ESMTP; 10 Jul 2020 13:32:43 -0700
Subject: Re: [RFC PATCH net-next 6/6] ice: implement devlink parameters to
 control flash update
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
 <20200709212652.2785924-7-jacob.e.keller@intel.com>
 <20200709171913.5b779cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ee8fc0a5-6cea-2689-372c-4e733cc06056@intel.com>
 <20200710132516.24994a33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <0a12dbf7-58be-b0ad-53d7-61748b081b38@intel.com>
Date:   Fri, 10 Jul 2020 13:32:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710132516.24994a33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/2020 1:25 PM, Jakub Kicinski wrote:
> On Fri, 10 Jul 2020 10:32:24 -0700 Jacob Keller wrote:
>> On 7/9/2020 5:19 PM, Jakub Kicinski wrote:
>>> On Thu,  9 Jul 2020 14:26:52 -0700 Jacob Keller wrote:  
>>>> The flash update for the ice hardware currently supports a single fixed
>>>> configuration:
>>>>
>>>> * Firmware is always asked to preserve all changeable fields
>>>> * The driver never allows downgrades
>>>> * The driver will not allow canceling a previous update that never
>>>>   completed (for example because an EMP reset never occurred)
>>>> * The driver does not attempt to trigger an EMP reset immediately.
>>>>
>>>> This default mode of operation is reasonable. However, it is often
>>>> useful to allow system administrators more control over the update
>>>> process. To enable this, implement devlink parameters that allow the
>>>> system administrator to specify the desired behaviors:
>>>>
>>>> * 'reset_after_flash_update'
>>>>   If enabled, the driver will request that the firmware immediately
>>>>   trigger an EMP reset when completing the device update. This will
>>>>   result in the device switching active banks immediately and
>>>>   re-initializing with the new firmware.  
>>>
>>> This should probably be handled through a reset API like what
>>> Vasundhara is already working on.
>>
>> Sure. I hadn't seen that work but I'll go take a look.
>>
>>>> * 'allow_downgrade_on_flash_update'
>>>>   If enabled, the driver will attempt to update device flash even when
>>>>   firmware indicates that such an update would be a downgrade.  
>>
>> There is also some trickiness here, because what this parameter does is
>> cause the driver to ignore the firmware version check. I suppose we
>> could just change the default behavior to ignoring that and assume user
>> space will check itself?
> 
> Seems only appropriate to me.
> 
> I assume this is a safety check because downgrades are sometimes
> impossible without factory reset (new FW version makes incompatible
> changes to the NVM params or such)? FWIW that's a terrible user
> experience, best avoided and handled as a exceptional circumstance
> which it should be.
> 
> The defaults should be any FW version can be installed after any FW
> version. Including downgrades, skipping versions etc.
> 
>>>> * 'ignore_pending_flash_update'
>>>>   If enabled, the device driver will cancel a previous pending update.
>>>>   A pending update is one where the steps to write the update to the NVM
>>>>   bank has finished, but the device never reset, as the system had not
>>>>   yet been rebooted.  
>>>
>>> These can be implemented in user space based on the values of running
>>> and stored versions from devlink info.  
>>
>> So, there's some trickiness here. We actually have to perform some steps
>> to cancel an update. Perhaps we should introduce a new option to request
>> that a previous update be cancelled? If we don't tell the firmware to
>> cancel the update, then future update requests will simply fail with
>> some errors.
> 
> Can't it be canceled automatically when user requests a new image to
> be flashed?
> 
> Perhaps best to think about it from the user perspective rather than
> how the internal works. User wants a new FW, they flash it. Next boot -
> the last flashed version should be activated.
> 
> If user wants to "cancel" and upgrade they will most likely flash the
> previous version of the FW.
> 
> Is the pending update/ability to cancel thing also part of the DTMF
> spec?
> 

Sure, I suppose we could simply always cancel if we detect a previous
update.

I'm not sure if it's part of the spec. I mostly focused on the file format.

>>>> * 'flash_update_preservation_level'
>>>>   The value determines the preservation mode to request from firmware,
>>>>   among the following 4 choices:
>>>>   * PRESERVE_ALL (0)
>>>>     Preserve all settings and fields in the NVM configuration
>>>>   * PRESERVE_LIMITED (1)
>>>>     Preserve only a limited set of fields, including the VPD, PCI serial
>>>>     ID, MAC address, etc. This results in permanent settings being
>>>>     reset, including changes to the port configuration, such as the
>>>>     number of physical functions created.
>>>>   * PRESERVE_FACTORY_SETTINGS (2)
>>>>     Reset all configuration fields to the factory default settings
>>>>     stored within the NVM.
>>>>   * PRESERVE_NONE (3)
>>>>     Do not perform any preservation.  
>>>
>>> Could this also be handled in a separate reset API? It seems useful to
>>> be able to reset to factory defaults at any time, not just FW upgrade..
>>
>> I'm not sure. At least the way it's described in the datasheet here is
>> that this must be done during an update. I'll have to look into this
>> further.
>>
>> For the other 3 (I kept preserve none for completeness), these are
>> referring to how much of the settings we preserve when updating to the
>> new image, so I think they only apply at update time.
> 
> Not sure what the difference is between 2 and 3.
> 

I'll ask my colleagues. It is my understanding is currently the following:

0 (ALL) -> keep all of the settings/fields that can be configured within
the flash the same. This includes things like the port configuration
(number of physical functions). This is the default behavior.

1 (SELECTIVE) -> keep only a small subset that includes the static
fields that shouldn't change.

2 (FACTORY) -> as discussed earlier, restores fields from a factory
settings section. AFAIK this is a write-once thing where it is written
at the factory.

3 (NONE) -> just write what is in the flash image, don't preserve anything.

> Not sure differentiating between 0 and 1 matters in practice. Clearly
> users will not do 0 in the field, cause they don't have new IDs assigned
> per product, and don't want to loose the IDs they put in their HW DB.
> 
> 0 is only something a OEM can use, right? OEMs presumably generate the
> image per device to flash the IDs, meaning difference between 0 and 1
> seems to be equivalent to flashing a special OEM FW package vs flashing
> a normal customer FW update...
> 

So, I think 3) would be the case where you want to jsut use what's in
the image, while the diff between 0 and 1 is that 0 will preserve more
settings, while 1 will only preserve the smallest necessary set.

I can ask for further information. This list was given to me as part of
the request.
