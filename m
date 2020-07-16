Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9F42218BD
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 02:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgGPAVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 20:21:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:24972 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgGPAVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 20:21:19 -0400
IronPort-SDR: CzF0V4WejmJm6go76SkmqW1WpYSxrJL2EH53BQ9GsZsFkYaRYT4hw4XM/n5ouCm2HNdjC9EPn5
 X2suprPwg51w==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="128861453"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="128861453"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 17:21:18 -0700
IronPort-SDR: dzN1Yw3geLbAKQKBneBV6o0hdOx81rzR3AoddF1tSKejRmiDwWZijt7JxB96twr1Rp0659fWve
 HCvPFU6vnp+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="286296610"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.190.147]) ([10.209.190.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Jul 2020 17:21:17 -0700
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
 <0a12dbf7-58be-b0ad-53d7-61748b081b38@intel.com>
 <4c6a39f4-5ff2-b889-086a-f7c99990bd4c@intel.com>
 <20200715162329.4224fa6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <d8f88c91-57fa-9ca4-1838-5f63b6613c59@intel.com>
Date:   Wed, 15 Jul 2020 17:21:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715162329.4224fa6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/15/2020 4:23 PM, Jakub Kicinski wrote:
> On Wed, 15 Jul 2020 14:41:04 -0700 Jacob Keller wrote:
>> To summarize this discussion, the next spin will have the following changes:
>>
>> 1) remove all parameters except for the preservation_level. Both
>> ignore_pending_flash_update and allow_downgrade_on_flash_update will be
>> removed and change the default behavior to the most accepting case:
>> updates will always be tried even if firmware says its a downgrade, and
>> we will always cancel a pending update. We will now expect user space
>> tools to be aware of this and handle the equivalent options themselves
>> if they desire.
>>
>> 2) reset_after_flash_update will be removed, and we will replace it with
>> a new interface, perhaps like the devlink reset command suggested in
>> another thread.
>>
>> 3) preservation_level will remain, but I have updated the documentation
>> slightly.
> 
> Okay, then. But let's make it a parameter to the flash update operation
> (extend the uAPI), rather than a devlink param, shall we?
> 

Ok, that seems reasonable. Ofcourse we'll need to find something generic
enough that it can be re-used and isn't driver specific.

>> Unfortunately it looks like FACTORY_SETTINGS option is not directly
>> available without doing an update. It may work with a sort of "update to
>> the same version" but I'm not sure if or how we could implement that
>> silently in the driver. There's no other way to ask firmware to perform
>> factory reset though. Otherwise I would remove this and make it part of
>> a new command.
> 
> If the settings are restored from within the device and not the flashed
> image - it sounds like it's a matter of a FW change to add this
> functionality. Right? Maybe it's not immediately necessary if we go
> with the new option to flashing.

I'm not at all sure how the firmware handles this, but I was told "it's
not currently possible to access this without doing an update" by the
firmware engineer I talked to.

> 
>> I'd also like to clarify the reasoning behind all of the options. The
>> preservation is referring to "what to keep in the existing NVM", so
>> "PRESERVE_ALL" is the one where the most fields and data are kept by the
>> firmware when updating. In this mode, we do not change any settings,
>> device-specific fields, or other configuration. This is the default.
>> With "PRESERVE_LIMITED" the limited subset of device-specific fields are
>> preserved, but all of the settings and configuration are overwritten.
>> With PRESERVE_NONE, we simply write what is in the image.
> 
> IMO we need to come up with names for the reset levels which
> correspond to what's being reset more directly. Ones which will
> actually be meaningful without a 4-email-exchange with the developer :) 
> 

Ok.

> It makes immediate sense to me to reset any subset of { settings,
> identifying information }. But I don't see how reset to factory
> defaults fits into this. Is it controlling the source of the defaults?
> I.e. reset to factory defaults vs reset to FW build defaults?
>

So basically preservation is done via a set of data stored within the
image, associated with the PLDM record as "package" data. This data
determines how to identify what set of fields to preserve when updating.

Essentially, when we update, we overwrite a secondary bank, and after
finishing that copy, firmware needs to determine what information to
copy back in so that fields don't change.

The fields are all stored within the NVM's "Preserved Field Area". When
updating, the firmware merges the old images PFA with the new PFA from
the new image. When "ALL" is used, then the old image's TLVs are
preferred over new ones. When "LIMITED" is used, only some fields such
as the identifying information, are preferred from the old image. (So
that, after an update, you retain the same values). When "NONE" is used,
then no preservation is done on the old image PFA, so all of its data is
lost, replaced with contents from the new image.

Factory settings causes the firmware to read the PFA data from the
factory settings area, rather than from the old image.

So in my examples, it's not about "what is reset" but "what is retained".

(I'm sure I got some of the details wrong, it is pretty complicated).

Having this be a parameter of the flash update command itself seems
reasonable to me.

I don't know if I can get firmware to support a new command for
performing the factory reset operation without doing an update. If so,
then we could drop that entirely. Perhaps if the Linux interface doesn't
expose this as an option, that would put more pressure to extend the
firmware...
