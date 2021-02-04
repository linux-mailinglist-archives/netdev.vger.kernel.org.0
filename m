Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7BC30FC4A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239665AbhBDTL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:11:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:46846 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239644AbhBDTKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 14:10:52 -0500
IronPort-SDR: p7bJTcZgXcqWT2bcdWPbbFffddNu83VNb1/o5qx2KvNNwHVLYW+jUK8EwtHlZZiI4a/4rFdwry
 k4xRyNaEDb9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="200303501"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="200303501"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 11:10:11 -0800
IronPort-SDR: vR7Omdambd6Ch9lG6wWHflaiF9NzQQCJZbJEFoDxbYuAesJ6LKaPMKEzlIp9UE+2BWd5efwb4D
 u1CTv6BYPE9g==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="393328570"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.103.68]) ([10.209.103.68])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 11:10:11 -0800
Subject: Re: [PATCH net-next 04/15] ice: add devlink parameters to read and
 write minimum security revision
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
 <20210129004332.3004826-5-anthony.l.nguyen@intel.com>
 <20210203124112.67a1e1ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c9bfca09-7fc1-08dc-750d-de604fb37e00@intel.com>
 <20210203180833.7188fbcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <3d552bf2-0d99-18aa-339a-5a6bd111c15e@intel.com>
Date:   Thu, 4 Feb 2021 11:10:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210203180833.7188fbcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/2021 6:08 PM, Jakub Kicinski wrote:
> On Wed, 3 Feb 2021 17:34:24 -0800 Jacob Keller wrote:
>> On 2/3/2021 12:41 PM, Jakub Kicinski wrote:
>>> On Thu, 28 Jan 2021 16:43:21 -0800 Tony Nguyen wrote:  
>>>> From: Jacob Keller <jacob.e.keller@intel.com>
>>>>
>>>> The ice NVM flash has a security revision field for the main NVM bank
>>>> and the Option ROM bank. In addition to the revision within the module,
>>>> the device also has a minimum security revision TLV area. This minimum
>>>> security revision field indicates the minimum value that will be
>>>> accepted for the associated security revision when loading the NVM bank.
>>>>
>>>> Add functions to read and update the minimum security revisions. Use
>>>> these functions to implement devlink parameters, "fw.undi.minsrev" and
>>>> "fw.mgmt.minsrev".
>>>>
>>>> These parameters are permanent (i.e. stored in flash), and are used to
>>>> indicate the minimum security revision of the associated NVM bank. If
>>>> the image in the bank has a lower security revision, then the flash
>>>> loader will not continue loading that flash bank.
>>>>
>>>> The new parameters allow for opting in to update the minimum security
>>>> revision to ensure that a flash image with a known security flaw cannot
>>>> be loaded.
>>>>
>>>> Note that the minimum security revision cannot be reduced, only
>>>> increased. The driver also refuses to allow an update if the currently
>>>> active image revision is lower than the requested value. This is done to
>>>> avoid potentially updating the value such that the device can no longer
>>>> start.  
>>>
>>> Hi Jake, I had a couple of conversations with people from operations
>>> and I'm struggling to find interest in writing this parameter.   
>>>> It seems like the expectation is that the min sec revision will go up  
>>> automatically after a new firmware with a higher number is flashed.
>>
>> I believe the intention is that the update is not automatic, and
>> requires the user to opt-in to enforcing the new minimum value. This is
>> because once you update this value it is not possible to lower it
>> without physical access to reflash the chip directly. It's intended as a
>> mechanism to allow a system administrator to ensure that the board is
>> unable to downgrade below a given minimum security revision.
>>
>>> Do you have a user scenario where the manual bumping is needed?
>>>   
>>
>> In our case, we have tools which would use this interface and would
>> perform the update upon request i.e. because the tool is configured to
>> perform the update.
>>
>> We don't want this field to be updated every time the board is flashed,
>> as it is supposed to be an optional "opt-in", and not forced.
>>
>> The flow is something like:
>>
>> a) device is as firmware version with SREV of 1
>> b) new firmware is flashed with SREV 2
>> c) system administrator confirms that new firmware is working and that
>> no issues have occurred
>> d) system administrator then decides to enforce new srev by updating the
>> minimum srev value.
> 
> Dunno, seems to me secure by default is a better approach. If admin 
> is worried you can always ship an eval build which does not bump the
> version. Or address the issues with the next release rather than roll
> back.
> 
>> If there was an issue at step (c), we want to still be able to roll back
>> to the old firmware. If the minimum srev is updated automatically, this
>> would not be possible.
>>
>> I've asked for further details from some of our firmware folks, and can
>> try to provide further information. The key is that making it automatic
>> is bad because it prevents rollback, so we want to ensure that it is
>> only updated after the system administrator is ready to opt-in.
>>
>> Ofcourse, it is plausible that most won't actually update this ever,
>> because preventing the ability to use an old firmware might not be desired.
> 
> Well, if there is a point to secure boot w/ NICs people better prevent
> replay attacks. Not every FW update is a security update, tho, so it's
> not like "going to the old version" would never be possible.
> 
Correct. The issue only comes up for firmware versions which have an
updated security revision, which we do not expect to occur every release.

>> The goal with this series was to provide a mechanism to allow the
>> update, because existing tools based on direct flash access have support
>> for this, and we want to ensure that these tools can be ported to
>> devlink without the direct flash access that we were (ab)using before.
> 
> I'm not completely opposed to this mechanism (although you may want 
> to communicate the approach to your customers clearly, because many
> may be surprised)
I do admit the primary motivation for this implementation was to enable
the existing tooling to function.

I'd rather see the right solution designed here, so if this isn't the
right direction I want to work with the list to figure out what makes
the most sense. (Even if that's "minimum security should update
automatically").

Perhaps some extension of the info mechanism or other solution is also
preferable so that it is more generic?

But I don't have any example from other vendors that matches this so I'm
not sure what makes the most sense here.

> but let's be clear - the goal of devlink is to
> create a replacement for vendor tooling, not be their underlying
> mechanism.
> 

The intention of modifying our tools is to help ensure existing
practices and tools can continue to work. This is primarily being done
to appease folks who "just want things to keep working as is".

I agree with the goal of devlink. But convincing everyone here to move
is a slow process that mostly involves educating folks one by one.
