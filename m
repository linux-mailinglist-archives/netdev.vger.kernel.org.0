Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4528B23E42F
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 00:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgHFW43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 18:56:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:3116 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgHFW42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 18:56:28 -0400
IronPort-SDR: z7/WKyk1KvNNl1e4TDc0T46bNGw3dIAecp6j8tnYcVkabxUwHfVP8w3pLhDa3yLZMtH7cAI08i
 cWL6Al4BCsEw==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="217287709"
X-IronPort-AV: E=Sophos;i="5.75,443,1589266800"; 
   d="scan'208";a="217287709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2020 15:56:27 -0700
IronPort-SDR: 4biT6osxqlu12+IBwULpflfdQtwXJyw8/jRRoKUvZy1cd9H/I3DAss4gQ+p7fwVqWRMeDx20R8
 ife/jJANimRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,443,1589266800"; 
   d="scan'208";a="307186190"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.186.82]) ([10.212.186.82])
  by orsmga002.jf.intel.com with ESMTP; 06 Aug 2020 15:56:27 -0700
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
References: <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
 <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
 <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
 <20200803141442.GB2290@nanopsycho>
 <20200803135703.16967635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200804100418.GA2210@nanopsycho>
 <20200804133946.7246514e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200805110258.GA2169@nanopsycho>
 <20200806112530.0588b3ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <2c1ead51-1993-1b66-2747-377b008b6f0a@intel.com>
Date:   Thu, 6 Aug 2020 15:56:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.0
MIME-Version: 1.0
In-Reply-To: <20200806112530.0588b3ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/6/2020 11:25 AM, Jakub Kicinski wrote:
> On Wed, 5 Aug 2020 13:02:58 +0200 Jiri Pirko wrote:
>> Tue, Aug 04, 2020 at 10:39:46PM CEST, kuba@kernel.org wrote:
>>> AFAIU the per-driver default is needed because we went too low 
>>> level with what the action constitutes. We need maintain the higher
>>> level actions.
>>>
>>> The user clearly did not care if FW was reset during devlink reload
>>> before this set, so what has changed? The objective user has is to  
>>
>> Well for mlxsw, the user is used to this flow:
>> devlink dev flash - flash new fw
>> devlink dev reload - new fw is activated and reset and driver instances
>> are re-created.
> 
> Ugh, if the current behavior already implies fw-activation for some
> drivers then the default has to probably be "do all the things" :S
> 
>>> activate their config / FW / move to different net ns. 
>>>
>>> Reloading the driver or resetting FW is a low level detail which
>>> achieves different things for different implementations. So it's 
>>> not a suitable abstraction -> IOW we need the driver default.  
>>
>> I'm confused. So you think we need the driver default?
> 
> No, I'm talking about the state of this patch set. _In this patchset_ 
> we need a driver default because of the unsuitable abstraction.
> 
> Better design would not require it.
> 
>>> The work flow for the user is:
>>>
>>> 0. download fw to /lib/firmware
>>> 1. devlink flash $dev $fw
>>> 2. if live activation is enabled
>>>   yes - devlink reload $dev $live-activate
>>>   no - report machine has to be drained for reboot
>>>
>>> fw-reset can't be $live-activate, because as Jake said fw-reset does
>>> not activate the new image for Intel. So will we end up per-driver
>>> defaults in the kernel space, and user space maintaining a mapping from  
>>
>> Well, that is what what is Moshe's proposal. Per-driver kernel default..
>> I'm not sure what we are arguing about then :/
> 
> The fact that if I do a pure "driver reload" it will active new
> firmware for mlxsw but not for mlx5. In this patchset for mlx5 I need
> driver reload fw-reset. And for Intel there is no suitable option.
> 

I want to clarify here, at least for ice: we *do* have a reset that can
activate firmware, but we have various level of reset which not all of
them do a fw activation. We have several levels of firmware reset,
including a "PF" reset that only resets data associated with that
function, a CORE reset which resets all functions, and then an EMP reset
which will activate the new firmware. For all of these resets, affected
PFs are notified over their firmware admin message queue. However, there
isn't a notion of negotiating beyond a message indicating what type of
reset is occurring.

I mostly wanted to clarify that "fw-reset" as a name doesn't necessarily
imply firmware activation. (hence separating fw-activate vs fw-reset).

Thanks,
Jake

>>> a driver to what a "level" of reset implies.
>>>
>>> I hope this makes things crystal clear. Please explain what problems
>>> you're seeing and extensions you're expecting. A list of user scenarios
>>> you foresee would be v. useful.  
