Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E271651BC
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 22:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgBSVhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 16:37:51 -0500
Received: from mga17.intel.com ([192.55.52.151]:41725 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbgBSVhv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 16:37:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 13:37:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="229930938"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 19 Feb 2020 13:37:50 -0800
Subject: Re: [RFC PATCH v2 06/22] ice: add basic handler for devlink .info_get
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-7-jacob.e.keller@intel.com>
 <20200218184552.7077647b@kicinski-fedora-PC1C0HJN>
 <6b4dd025-bcf8-12de-99b0-1e05e16333e8@intel.com>
 <20200219115757.5af395c5@kicinski-fedora-PC1C0HJN>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <70001e87-b369-bab4-f318-ad4514e7dcfb@intel.com>
Date:   Wed, 19 Feb 2020 13:37:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200219115757.5af395c5@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub,

Thanks for your excellent feedback.

On 2/19/2020 11:57 AM, Jakub Kicinski wrote:
> On Wed, 19 Feb 2020 09:33:09 -0800 Jacob Keller wrote:
>> "fw.psid.api" -> what was the "nvm.psid". This I think needs a bit more
>> work to define. It makes sense to me as some sort of "api" as (if I
>> understand it correctly) it is the format for the parameters, but does
>> not itself define the parameter contents.
> 
> Sounds good. So the contents of parameters would be covered by the
> fw.bundle now and not have a separate version?
> 

I'm actually not sure if we have any way to identify the parameters.
I'll ask around about that. My understanding is that these would include
parameters that can be modified by the driver such as Wake on LAN
settings, so I'm also not sure if they'd be covered in the fw.bundle
either. The 'defaults' that were selected when the image was created
would be covered, but changes to them wouldn't update the value.

Hmmmmm.

>> The original reason for using "fw" and "nvm" was because we (internally)
>> use fw to mean the management firmware.. where as these APIs really
>> combine the blocks and use "fw.mgmt" for the management firmware. Thus I
>> think it makes sense to move from
>>
>> I also have a couple other oddities that need to be sorted out. We want
>> to display the DDP version (piece of "firmware" that is loaded during
>> driver load, and is not permanent to the NVM). In some sense this is our
>> "fw.app", but because it's loaded by driver at load and not as
>> permanently stored in the NVM... I'm not really sure that makes sense to
>> put this as the "fw.app", since it is not updated or really touched by
>> the firmware flash update.
> 
> Interesting, can DDP be persisted to the flash, though? Is there some
> default DDP, or is it _never_ in the flash? 
> 

There's a version of this within the flash, but it is limited, and many
device features get disabled if you don't load the DDP package file.
(You may have seen patches for this for implementing "safe mode").

My understanding is there is no mechanism for persisting a different DDP
to the flash.

> Does it not have some fun implications for firmware signing to have
> part of the config/ucode loaded from the host?
> 

I'm not sure how it works exactly. As far as I know, the DDP file is
itself signed.

> IIRC you could also load multiple of those DDP packages? Perhaps they
> could get names like fw.app0, fw.app1, etc?

You can load different ones, each has their own version and name
embedded. However, only one can be loaded at any given time, so I'm not
sure if multiples like this make sense.

> Also if DDP controls a
> particular part of the datapath (parser?) feel free to come up with a
> more targeted name, up to you.
> 

Right, it's my understanding that this defines the parsing logic, and
not the complete datapath microcode.

In theory, there could be at least 3 DDP versions

1) the version in the NVM, which would be the very basic "safe mode"
compatible one.

2) the version in the ddp firmware file that we search for when we load

3) the one that actually got activated. It's a sort of
first-come-first-serve and sticks around until a device global reset.
This should in theory always be the same as (2) unless you do something
weird like load different drivers on the multiple functions.

I suppose we could use "running" and "stored" for this, to have "stored"
be what's in the NVM, and "running" for the active one.. but that's ugly
and misusing what stored vs running is supposed to represent.

>> Finally we also have a component we call the "netlist", which I'm still
>> not fully up to speed on exactly what it represents, but it has multiple
>> pieces of data including a 2-digit Major.Minor version of the base, a
>> type field indicating the format, and a 2-digit revision field that is
>> incremented on internal and external changes to the contents. Finally
>> there is a hash that I think might *actually* be something like a psid
>> or a bundle to uniquely represent this component. I haven't included
>> this component yet because I'm still trying to grasp exactly what it
>> represents and how best to describe each piece.
> 
> Hmm. netlist is a Si term, perhaps it's chip init data? nfp had
> something called chip.init which I think loaded all the very low 
> level Si configs.
> 

I'm asking some colleagues to provide further details on this. Right now
the "version" for a netlist is just a display of all these fields munged
together "a.b.c-d.e.f", which I'd rather avoid.

> My current guess is that psid is more of the serdes and maybe clock
> data. 
> 
> Thinking about it now, it seems these versions mirror the company
> structure. chip.init comes from the Si team. psid comes from the 
> board design guys. fw.mgmt comes from the BSP/FW team.
> 
> None of them are really fixed but the frequency of changes increases
> from chip.init changing very rarely to mgmt fw having a regular release
> cadence.
> 

Without further information I don't know for sure, but I don't think
chip.init makes sense. I'll try to find out more.

Thanks,
Jake
