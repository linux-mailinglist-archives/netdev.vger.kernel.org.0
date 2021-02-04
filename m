Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B8330FFA1
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhBDVts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:49:48 -0500
Received: from mga14.intel.com ([192.55.52.115]:4828 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230186AbhBDVtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 16:49:33 -0500
IronPort-SDR: hvf8eLP8Hx3P7Psh62742eQCRFi0LrG1lB1a8ISVtSwdeoLS1aElt9hPOZU02NT8sMWvMb1/i5
 Ear5qqXHO5eg==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="180557969"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="180557969"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 13:48:49 -0800
IronPort-SDR: SnW/hIjuc/0Hy3rPOK7+jjn1KAdo8dt+qKF/Zm7EFyO+UG0u2HrBx5gGv3ETmy+MI+JSg+Crgx
 4hFjQLpupy9Q==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="393459890"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.103.68]) ([10.209.103.68])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 13:48:34 -0800
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
Message-ID: <8a2d8aa2-8b94-ea71-df30-d0c02aea7355@intel.com>
Date:   Thu, 4 Feb 2021 13:48:31 -0800
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


I've spoken with some of our customer support engineers. Feedback I've
received is that this was implemented as an automatic/default/enforced
update in past products. Several customers have indicated that they want
to be in control of when this update happens, and not to have it happen
automatically.

Specifically I've been asked to ensure this update is something that
must be "opt in" and not by default, because of the issues we've
received from vendors.


> 
> Dunno, seems to me secure by default is a better approach. If admin 
> is worried you can always ship an eval build which does not bump the
> version. Or address the issues with the next release rather than roll
> back.
> 

This is how we had it implemented in previous products, but we got
significant feedback that it should be a step that can be controlled by
the admin, so that they can decide when it is appropriate.

Making this the default behavior that the driver automatically occurs
after an update is not something we want, based on the feedback we've
received in our previous products.

The feedback that we've received is that a "one size fits all" automatic
update of the minimum value is not acceptable to all of our customers.

>>
>> Ofcourse, it is plausible that most won't actually update this ever,
>> because preventing the ability to use an old firmware might not be desired.
> 
> Well, if there is a point to secure boot w/ NICs people better prevent
> replay attacks. Not every FW update is a security update, tho, so it's
> not like "going to the old version" would never be possible.
> 

After I spoke to some folks internally I believe I misstated above: it's
not about never updating this, but about being in control of when to
perform the update.

>> The goal with this series was to provide a mechanism to allow the
>> update, because existing tools based on direct flash access have support
>> for this, and we want to ensure that these tools can be ported to
>> devlink without the direct flash access that we were (ab)using before.
> 
> I'm not completely opposed to this mechanism (although you may want 
> to communicate the approach to your customers clearly, because many
> may be surprised) - but let's be clear - the goal of devlink is to
> create a replacement for vendor tooling, not be their underlying
> mechanism.
> 

We want some mechanism to allow administrators to decide when to update
this value. We do not want to have a "default" be to update because that
means the system administrators who want control over the process might
accidentally perform a non-reversible  operation. (Once you update the
value you can't lower it without physically accessing the flash chip).

I understand if the use of vendor-specific parameters here isn't
acceptable. I'm happy to help design a more generic solution that avoids
these and potentially integrates better into the flash update process.

There is also the technical question of when the update can be
performed. As is, it's a software controlled update, and must occur
after the new flash image is booted, in order to ensure we do not update
the value in a way that bricks the currently running firmware from booting.
