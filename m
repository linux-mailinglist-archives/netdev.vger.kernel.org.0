Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA96222E2E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgGPVwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:52:16 -0400
Received: from mga05.intel.com ([192.55.52.43]:7026 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgGPVwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:52:16 -0400
IronPort-SDR: mNwfpj/66DOWmBsdxixewEYnLnnYJDIXHYV2MdPEnuxebRbsQwuFL59V5Yn7CdjbL8L+bw4Xjc
 9ZHz3qlwYDhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9684"; a="234351199"
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="234351199"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 14:52:15 -0700
IronPort-SDR: wwgCXGmJ2bnsD4yt7xSLjP0opnC7mk83UFSz1ZhELEr2zZS56H08AEc/kky/Ga5T7RJt5PZV0i
 oRqXyb9SFFDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="361167076"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.123.234]) ([10.209.123.234])
  by orsmga001.jf.intel.com with ESMTP; 16 Jul 2020 14:52:15 -0700
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
 <d8f88c91-57fa-9ca4-1838-5f63b6613c59@intel.com>
 <58840317-e818-af52-352a-19008b89bee7@intel.com>
 <20200716144208.4e602320@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <2ce3eb56-69e3-91fe-96a2-e5e538846e9f@intel.com>
Date:   Thu, 16 Jul 2020 14:52:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716144208.4e602320@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2020 2:42 PM, Jakub Kicinski wrote:
> On Thu, 16 Jul 2020 14:29:40 -0700 Jacob Keller wrote:
>> On 7/15/2020 5:21 PM, Jacob Keller wrote:
>>> Ok, that seems reasonable. Ofcourse we'll need to find something generic
>>> enough that it can be re-used and isn't driver specific.
>>
>> Hi Jakub,
>>
>> I think I have something that will be more clear and will be sending a
>> new RFC with the change this afternoon:
>>
>> an extension to the DEVLINK_CMD_FLASH_UPDATE with a new parameter,
>> "overwrite" with these values:
>>
>> a) "nothing" (or maybe, "firmware-only" or "binary-only"?, need a way to
>> clarify difference between settings/vital data and firmware program
>> binary) will request that we do not overwrite any settings or fields.
>> This is equivalent to the "PRESERVE_ALL" I had in the original proposal,
>> where we will maintain all settings and all vital data, but update the
>> firmware binary.
>>
>> b) "settings" will request that the firmware overwrite all the settings
>> fields with the contents from the new image. However, vital data such as
>> the PCI Serial ID, VPD section, MAC Addresses, and similar "static" data
>> will be kept (not overwritten). This is the same as the
>> "PRESERVE_LIMITED" option I had in the original proposal
>>
>> c) "all" or "everything" will request that firmware overwrite all
>> contents of the image. This means all settings and all vital data will
>> be overwritten by the contents in the new image.
> 
> Sorry but I'm still not 100% sure of what the use for this option is
> beyond an OEM. Is it possible to reset the VPD, board serial, MAC
> address etc. while flashing a FW image downloaded from a support site?
> Would that mean that if I flash a rack with one FW image all NICs will
> start reporting the same serial numbers and use the same MACs?
> 

I think the intent here is for OEMs which would generate/customize the
images, though I've also been told it may be useful to get a card out of
some situation where firmware preservation was broken.. (No, I don't
really have more details on what specifically the situation might be).
Obviously in most update cases I don't think we expect this to be used.

>> d) if we need it, a "default" that would be the current behavior of
>> doing whatever the driver default is? (since it's not clear to me what
>> other implementations do but perhaps they all behavior as either
>> "nothing" or "all"?
> 
> As a user I'd expect "nothing" to be the default. Same as your OS
> update does not wipe out your settings. I think it's also better 
> if the default is decided by Linux, not the drivers.
> 

Right, but I wasn't sure what other drivers/devices implement today and
didn't want  to end up in a "well we don't behave that way so you just
changed our behavior"..? Hmm. If they all behave this way today then
it's fine to make "nothing" the default and modify all implementations
to reject other options.

>> I think I agree that "factory" settings doesn't really belong here, and
>> I will try to push for finding an alternative way to allow access to
>> that behavior. If we wanted it we could use "from_factory" to request
>> that we overwrite the settings and  vital data "from" the factory
>> portion, but I think that is pushing the boundary here a bit...
>>
>> I am aiming to have a new patch up with this proposal
> 
> Probably best if we understand the use case more clearly, too. Since
> you have this implemented in your tooling what are the scenarios where
> factory is expected to be preferred over FW default?
> 

I'll see if I can gather any further information on both this and the
overwrite-all mode.

My understanding so far is that it is intended as a way to restore the
device settings/config to what was written in the factory. I agree from
Linux perspective having this be a separate command (without requiring
an update) would make the most sense, but that isn't how it was
implemented today.

The factory settings are stored in a separate section of flash so they
aren't modified by normal update flows. I am not sure if there is a
procedure for updating them or if it truly is write-once.

Thanks,
Jake
