Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F5121BC46
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgGJRc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 13:32:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:56457 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbgGJRc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 13:32:26 -0400
IronPort-SDR: 0w2azESuAtZccCwY0V2Cb2ns6Fkq8DtQtEmYoKd7Nier+wzy7x2St9KO92ahkZYPBUF02UIg1N
 ZtmIftUfrY8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="166347957"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="166347957"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 10:32:25 -0700
IronPort-SDR: Vk059tayLMIrqylimehJocWnUypn1qgdhaCE3+xlTMR0dv0NZc2rE4YRqgPeIisg3hRvqq358U
 8313h1C5HxcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="306614709"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.20.152]) ([10.212.20.152])
  by fmsmga004.fm.intel.com with ESMTP; 10 Jul 2020 10:32:24 -0700
Subject: Re: [RFC PATCH net-next 6/6] ice: implement devlink parameters to
 control flash update
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
 <20200709212652.2785924-7-jacob.e.keller@intel.com>
 <20200709171913.5b779cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <ee8fc0a5-6cea-2689-372c-4e733cc06056@intel.com>
Date:   Fri, 10 Jul 2020 10:32:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200709171913.5b779cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/2020 5:19 PM, Jakub Kicinski wrote:
> On Thu,  9 Jul 2020 14:26:52 -0700 Jacob Keller wrote:
>> The flash update for the ice hardware currently supports a single fixed
>> configuration:
>>
>> * Firmware is always asked to preserve all changeable fields
>> * The driver never allows downgrades
>> * The driver will not allow canceling a previous update that never
>>   completed (for example because an EMP reset never occurred)
>> * The driver does not attempt to trigger an EMP reset immediately.
>>
>> This default mode of operation is reasonable. However, it is often
>> useful to allow system administrators more control over the update
>> process. To enable this, implement devlink parameters that allow the
>> system administrator to specify the desired behaviors:
>>
>> * 'reset_after_flash_update'
>>   If enabled, the driver will request that the firmware immediately
>>   trigger an EMP reset when completing the device update. This will
>>   result in the device switching active banks immediately and
>>   re-initializing with the new firmware.
> 
> This should probably be handled through a reset API like what
> Vasundhara is already working on.
> 

Sure. I hadn't seen that work but I'll go take a look.

>> * 'allow_downgrade_on_flash_update'
>>   If enabled, the driver will attempt to update device flash even when
>>   firmware indicates that such an update would be a downgrade.


There is also some trickiness here, because what this parameter does is
cause the driver to ignore the firmware version check. I suppose we
could just change the default behavior to ignoring that and assume user
space will check itself?

>> * 'ignore_pending_flash_update'
>>   If enabled, the device driver will cancel a previous pending update.
>>   A pending update is one where the steps to write the update to the NVM
>>   bank has finished, but the device never reset, as the system had not
>>   yet been rebooted.
> 
> These can be implemented in user space based on the values of running
> and stored versions from devlink info.

So, there's some trickiness here. We actually have to perform some steps
to cancel an update. Perhaps we should introduce a new option to request
that a previous update be cancelled? If we don't tell the firmware to
cancel the update, then future update requests will simply fail with
some errors.

> 
>> * 'flash_update_preservation_level'
>>   The value determines the preservation mode to request from firmware,
>>   among the following 4 choices:
>>   * PRESERVE_ALL (0)
>>     Preserve all settings and fields in the NVM configuration
>>   * PRESERVE_LIMITED (1)
>>     Preserve only a limited set of fields, including the VPD, PCI serial
>>     ID, MAC address, etc. This results in permanent settings being
>>     reset, including changes to the port configuration, such as the
>>     number of physical functions created.
>>   * PRESERVE_FACTORY_SETTINGS (2)
>>     Reset all configuration fields to the factory default settings
>>     stored within the NVM.
>>   * PRESERVE_NONE (3)
>>     Do not perform any preservation.
> 
> Could this also be handled in a separate reset API? It seems useful to
> be able to reset to factory defaults at any time, not just FW upgrade..
>
I'm not sure. At least the way it's described in the datasheet here is
that this must be done during an update. I'll have to look into this
further.

For the other 3 (I kept preserve none for completeness), these are
referring to how much of the settings we preserve when updating to the
new image, so I think they only apply at update time.

Thanks,
Jake
