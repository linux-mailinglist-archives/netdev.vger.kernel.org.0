Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEF22327B6
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 00:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgG2WtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 18:49:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:60067 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgG2WtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 18:49:06 -0400
IronPort-SDR: S6cZL1gFY59Zs6RDLaGjk91I/ff1a0p2Yr6qaOh/KEq398E/kRFSqqEVYHFwBfB5tqCvqWJx9n
 iMJkvNTptZvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="215997062"
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="215997062"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 15:49:05 -0700
IronPort-SDR: O2LHc3eGi4t/q/pvpveDHD+Wnu5DVOVuLJdxCkFD6kqLGskoIgGzJy6Z5uvUMD/fTzENTfX8YY
 p9Uz8KzXSGFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,412,1589266800"; 
   d="scan'208";a="304370869"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.162.155]) ([10.212.162.155])
  by orsmga002.jf.intel.com with ESMTP; 29 Jul 2020 15:49:05 -0700
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200721135356.GB2205@nanopsycho>
 <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200722105139.GA3154@nanopsycho>
 <02874ECE860811409154E81DA85FBB58C8AF3382@fmsmsx101.amr.corp.intel.com>
 <20200722095228.2f2c61b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <a0994590-f818-43cd-6c28-0cd628be9602@intel.com>
Date:   Wed, 29 Jul 2020 15:49:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200722095228.2f2c61b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/2020 9:52 AM, Jakub Kicinski wrote:
> On Wed, 22 Jul 2020 15:30:05 +0000 Keller, Jacob E wrote:
>>>>>> one by one and then omit the one(s) which is config (guessing which
>>>>>> one that is based on the name).
>>>>>>
>>>>>> Wouldn't this be quite inconvenient?  
>>>>>
>>>>> I see it as an extra knob that is actually somehow provides degradation
>>>>> of components.  
>>>>
>>>> Hm. We have the exact opposite view on the matter. To me components
>>>> currently correspond to separate fw/hw entities, that's a very clear
>>>> meaning. PHY firmware, management FW, UNDI. Now we would add a
>>>> completely orthogonal meaning to the same API.  
>>>
>>> I understand. My concern is, we would have a component with some
>>> "subparts". Now it is some fuzzy vagely defined "config part",
>>> in the future it might be something else. That is what I'm concerned
>>> about. Components have clear api.
>>>
>>> So perhaps we can introduce something like "component mask", which would
>>> allow to flash only part of the component. That is basically what Jacob
>>> has, I would just like to have it well defined.
>>
>> So, we could make this selection a series of masked bits instead of a
>> single enumeration value.
> 
> I'd still argue that components (as defined in devlink info) and config
> are pretty orthogonal. In my experience config is stored in its own
> section of the flash, and some of the knobs are in no obvious way
> associated with components (used by components).
> 
> That said, if we rename the "component mask" to "update mask" that's
> fine with me.
> 
> Then we'd have
> 
> bit 0 - don't overwrite config
> bit 1 - don't overwrite identifiers
> 
> ? 
> 
> Let's define a bit for "don't update program" when we actually need it.
> 

One further wrinkle I was just reminded about. The ice hardware has a
section of the flash which defines a "minimum security revision". All
NVM images also have a "security revision". The firmware will fail to
load if the NVM image's security revision is less than the mimimum
security revision.

The minimum security revision is not updated automatically. Current
tools which had direct access have an optional "opt in to minimum
security revision update" which would optionally bump the minimum
security revision after an update. The intent is that once an image is
tested and verified to be stable, an administrator can opt in to prevent
downgrade below that security revision. (Thus preventing potential
downgrade to a known insecure image).

The folks adjusting our tools would like to continue to support this. I
think the best solution would be to have both the security revision and
minimum security revision become components, i.e.
"fw.mgmt.security_revision" and "fw.mgmt.min_security_revision" (maybe
shortened like "secrev or srev?), and then use the
fw.mgmt.min_security_revision component name in the flash update request.

The security revision is tied into the management firmware image and
would always be updated when an image is updated, but the minimum
revision is only updated on an explicit request request.

In theory this could be done as part of this overwrite, but since I
suspect this is somewhat device specific, (not sure other vendors have
something similar?), and because there is a valid/known version we can
report I think a component makes the most sense.
