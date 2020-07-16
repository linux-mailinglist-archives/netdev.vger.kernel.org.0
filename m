Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDAE222DED
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgGPV3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:29:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:64349 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgGPV3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:29:41 -0400
IronPort-SDR: FUB45jLVwrOZfI7dfn7kxMcNdm9UUkGAgjBkbsc2zmPxQdZb2Dn76Q4X1//1WzcuzjPmRFOObu
 b/tl4Fjebn+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="214222593"
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="214222593"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 14:29:41 -0700
IronPort-SDR: nVvn3bIu/01vs8/TCHkX9rzEZrl7B18Y/BevvNlP72O0SahqUzSY/E5hQaBRc7plT4LVu96AW/
 z1m9U/NpC1/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="361162753"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.123.234]) ([10.209.123.234])
  by orsmga001.jf.intel.com with ESMTP; 16 Jul 2020 14:29:40 -0700
Subject: Re: [RFC PATCH net-next 6/6] ice: implement devlink parameters to
 control flash update
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
 <20200709212652.2785924-7-jacob.e.keller@intel.com>
 <20200709171913.5b779cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ee8fc0a5-6cea-2689-372c-4e733cc06056@intel.com>
 <20200710132516.24994a33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0a12dbf7-58be-b0ad-53d7-61748b081b38@intel.com>
 <4c6a39f4-5ff2-b889-086a-f7c99990bd4c@intel.com>
 <20200715162329.4224fa6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d8f88c91-57fa-9ca4-1838-5f63b6613c59@intel.com>
Organization: Intel Corporation
Message-ID: <58840317-e818-af52-352a-19008b89bee7@intel.com>
Date:   Thu, 16 Jul 2020 14:29:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d8f88c91-57fa-9ca4-1838-5f63b6613c59@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/15/2020 5:21 PM, Jacob Keller wrote:
> 
> 
> On 7/15/2020 4:23 PM, Jakub Kicinski wrote:
>> On Wed, 15 Jul 2020 14:41:04 -0700 Jacob Keller wrote:
>>> To summarize this discussion, the next spin will have the following changes:
>>>
>>> 1) remove all parameters except for the preservation_level. Both
>>> ignore_pending_flash_update and allow_downgrade_on_flash_update will be
>>> removed and change the default behavior to the most accepting case:
>>> updates will always be tried even if firmware says its a downgrade, and
>>> we will always cancel a pending update. We will now expect user space
>>> tools to be aware of this and handle the equivalent options themselves
>>> if they desire.
>>>
>>> 2) reset_after_flash_update will be removed, and we will replace it with
>>> a new interface, perhaps like the devlink reset command suggested in
>>> another thread.
>>>
>>> 3) preservation_level will remain, but I have updated the documentation
>>> slightly.
>>
>> Okay, then. But let's make it a parameter to the flash update operation
>> (extend the uAPI), rather than a devlink param, shall we?
>>
> 
> Ok, that seems reasonable. Ofcourse we'll need to find something generic
> enough that it can be re-used and isn't driver specific.
> 

Hi Jakub,

I think I have something that will be more clear and will be sending a
new RFC with the change this afternoon:

an extension to the DEVLINK_CMD_FLASH_UPDATE with a new parameter,
"overwrite" with these values:

a) "nothing" (or maybe, "firmware-only" or "binary-only"?, need a way to
clarify difference between settings/vital data and firmware program
binary) will request that we do not overwrite any settings or fields.
This is equivalent to the "PRESERVE_ALL" I had in the original proposal,
where we will maintain all settings and all vital data, but update the
firmware binary.

b) "settings" will request that the firmware overwrite all the settings
fields with the contents from the new image. However, vital data such as
the PCI Serial ID, VPD section, MAC Addresses, and similar "static" data
will be kept (not overwritten). This is the same as the
"PRESERVE_LIMITED" option I had in the original proposal

c) "all" or "everything" will request that firmware overwrite all
contents of the image. This means all settings and all vital data will
be overwritten by the contents in the new image.

d) if we need it, a "default" that would be the current behavior of
doing whatever the driver default is? (since it's not clear to me what
other implementations do but perhaps they all behavior as either
"nothing" or "all"?

I think I agree that "factory" settings doesn't really belong here, and
I will try to push for finding an alternative way to allow access to
that behavior. If we wanted it we could use "from_factory" to request
that we overwrite the settings and  vital data "from" the factory
portion, but I think that is pushing the boundary here a bit...

I am aiming to have a new patch up with this proposal

Thanks,
Jake
