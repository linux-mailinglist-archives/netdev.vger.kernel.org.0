Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3EAD1689D0
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 23:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgBUWLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 17:11:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:31403 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgBUWLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 17:11:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 14:11:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,469,1574150400"; 
   d="scan'208";a="229984845"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by orsmga008.jf.intel.com with ESMTP; 21 Feb 2020 14:11:12 -0800
Subject: Re: [RFC PATCH v2 06/22] ice: add basic handler for devlink .info_get
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-7-jacob.e.keller@intel.com>
 <20200218184552.7077647b@kicinski-fedora-PC1C0HJN>
 <6b4dd025-bcf8-12de-99b0-1e05e16333e8@intel.com>
 <20200219115757.5af395c5@kicinski-fedora-PC1C0HJN>
 <70001e87-b369-bab4-f318-ad4514e7dcfb@intel.com>
 <20200219154727.5b52aa73@kicinski-fedora-PC1C0HJN>
 <1dd1cff3-dbbf-9b04-663d-15c7e4e5a3bd@intel.com>
Organization: Intel Corporation
Message-ID: <83a7a25e-50f0-862d-f535-92d64d86fd4f@intel.com>
Date:   Fri, 21 Feb 2020 14:11:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1dd1cff3-dbbf-9b04-663d-15c7e4e5a3bd@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/2020 4:06 PM, Jacob Keller wrote:
> On 2/19/2020 3:47 PM, Jakub Kicinski wrote:
>> On Wed, 19 Feb 2020 13:37:50 -0800 Jacob Keller wrote:
>>> Jakub,
>>>
>>> Thanks for your excellent feedback.
>>>
>>> On 2/19/2020 11:57 AM, Jakub Kicinski wrote:
>>>> On Wed, 19 Feb 2020 09:33:09 -0800 Jacob Keller wrote:  
>>>>> "fw.psid.api" -> what was the "nvm.psid". This I think needs a bit more
>>>>> work to define. It makes sense to me as some sort of "api" as (if I
>>>>> understand it correctly) it is the format for the parameters, but does
>>>>> not itself define the parameter contents.  
>>>>
>>>> Sounds good. So the contents of parameters would be covered by the
>>>> fw.bundle now and not have a separate version?
>>>>   
>>>
>>> I'm actually not sure if we have any way to identify the parameters.
>>> I'll ask around about that. My understanding is that these would include
>>> parameters that can be modified by the driver such as Wake on LAN
>>> settings, so I'm also not sure if they'd be covered in the fw.bundle
>>> either. The 'defaults' that were selected when the image was created
>>> would be covered, but changes to them wouldn't update the value.
>>>
>>> Hmmmmm.
>>
>> Ah, so these are just defaults, then if there's no existing version 
>> I wouldn't worry.
>>
> Ok.
> 
>>>>> The original reason for using "fw" and "nvm" was because we (internally)
>>>>> use fw to mean the management firmware.. where as these APIs really
>>>>> combine the blocks and use "fw.mgmt" for the management firmware. Thus I
>>>>> think it makes sense to move from
>>>>>
>>>>> I also have a couple other oddities that need to be sorted out. We want
>>>>> to display the DDP version (piece of "firmware" that is loaded during
>>>>> driver load, and is not permanent to the NVM). In some sense this is our
>>>>> "fw.app", but because it's loaded by driver at load and not as
>>>>> permanently stored in the NVM... I'm not really sure that makes sense to
>>>>> put this as the "fw.app", since it is not updated or really touched by
>>>>> the firmware flash update.  
>>>>
>>>> Interesting, can DDP be persisted to the flash, though? Is there some
>>>> default DDP, or is it _never_ in the flash? 
>>>
>>> There's a version of this within the flash, but it is limited, and many
>>> device features get disabled if you don't load the DDP package file.
>>> (You may have seen patches for this for implementing "safe mode").
>>>
>>> My understanding is there is no mechanism for persisting a different DDP
>>> to the flash.
>>
>> I see, so this really isn't just parser extensions.
>>
> 
> Right. I'm not entirely sure what pieces of logic the contents interact
> with.
> 
>> I'm a little surprised you guys went this way, loading FW from disk
>> becomes painful for network boot and provisioning :S  All the first
>> stage images must have it built in, which is surprisingly painful.
>>
> 
> Right. I don't have the context for why this was chosen over making it a
> portion that can be updated independently. Unfortunately I don't think
> it's a decision that can be changed, at least not easily.
> 
>> Perhaps the "safe mode" FW is enough to boot, but then I guess once
>> real FW is available there may be a loss of link as the device resets?
>>
> 
> it's enough to boot up and handle basic functionality. I'm not sure
> exactly how it would be handled in regards to device reset.
> 
>>>> Does it not have some fun implications for firmware signing to have
>>>> part of the config/ucode loaded from the host?
>>>
>>> I'm not sure how it works exactly. As far as I know, the DDP file is
>>> itself signed.
>>
>> Right, that'd make sense :)
>>
>>>> IIRC you could also load multiple of those DDP packages? Perhaps they
>>>> could get names like fw.app0, fw.app1, etc?  
>>>
>>> You can load different ones, each has their own version and name
>>> embedded. However, only one can be loaded at any given time, so I'm not
>>> sure if multiples like this make sense.
>>
>> I see. Maybe just fw.app works then..
>>
> 
> Ok
> 
>>>> Also if DDP controls a
>>>> particular part of the datapath (parser?) feel free to come up with a
>>>> more targeted name, up to you.
>>>
>>> Right, it's my understanding that this defines the parsing logic, and
>>> not the complete datapath microcode.
>>>
>>> In theory, there could be at least 3 DDP versions
>>>
>>> 1) the version in the NVM, which would be the very basic "safe mode"
>>> compatible one.
>>>
>>> 2) the version in the ddp firmware file that we search for when we load
>>>
>>> 3) the one that actually got activated. It's a sort of
>>> first-come-first-serve and sticks around until a device global reset.
>>> This should in theory always be the same as (2) unless you do something
>>> weird like load different drivers on the multiple functions.
>>>
>>> I suppose we could use "running" and "stored" for this, to have "stored"
>>> be what's in the NVM, and "running" for the active one.. but that's ugly
>>> and misusing what stored vs running is supposed to represent.
>>
>> Ouff. Having something loaded from disk breaks the running vs stored
>> comparison :( But I think Dave was pretty clear on his opinion about
>> load FW from disk and interpret it in the kernel to extract the version.
>>> Can we leave stored meaning "stored on the device" and running being
>> loaded on the chip?
>>
> 
> Yes.
> 
>> It's perfectly fine for a component to only be reported in running and
>> not stored, nfp already does that:
>>

Based on your feedback, I believe that we have settled on a set of
suitable names for this. I'm going to submit the initial ice series (the
first 7 patches) to Intel Wired LAN.

The remaining devlink patches need further feedback, but that can happen
while the ice changes are being submitted to next-queue through IWL.

Thanks,
Jake
