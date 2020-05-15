Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F42281D5BB4
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgEOVgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:36:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:57746 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgEOVga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 17:36:30 -0400
IronPort-SDR: 7gMMpYesjOreOOtFaoxTdQdGwP/K2Guk9sJDs0IcRZXBiSRmDyu7h8b7EV6s+84FPO73K+mFjD
 PaG1DivKUL4A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 14:36:22 -0700
IronPort-SDR: RY/mCS7XCwgG9Te6p3O2JPUu2ZjTPeIdYW6V1lpqZPwwqyHyHYJSBGvX8Yeq5ZY8W151mL/7IN
 kHKVHmlR5+hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="438460347"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.91.12]) ([10.212.91.12])
  by orsmga005.jf.intel.com with ESMTP; 15 May 2020 14:36:20 -0700
Subject: Re: [RFC v2] current devlink extension plan for NICs
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        parav@mellanox.com, yuvalav@mellanox.com, jgg@ziepe.ca,
        saeedm@mellanox.com, leon@kernel.org,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        moshe@mellanox.com, ayal@mellanox.com, eranbe@mellanox.com,
        vladbu@mellanox.com, kliteyn@mellanox.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, tariqt@mellanox.com,
        oss-drivers@netronome.com, snelson@pensando.io,
        drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        valex@mellanox.com, linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, sridhar.samudrala@intel.com
References: <20200501091449.GA25211@nanopsycho.orion>
 <b0f75e76-e6cb-a069-b863-d09f77bc67f6@intel.com>
 <20200515093016.GE2676@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <e3aa20ec-a47e-0b91-d6d5-1ad2020eca28@intel.com>
Date:   Fri, 15 May 2020 14:36:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200515093016.GE2676@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/2020 2:30 AM, Jiri Pirko wrote:
> Fri, May 15, 2020 at 01:52:54AM CEST, jacob.e.keller@intel.com wrote:
>>> $ devlink port add pci/0000.06.00.0/100 flavour pcisf pfnum 1 sfnum 10
>>>
>>
>> Can you clarify what sfnum means here? and why is it different from the
>> index? I get that the index is a unique number that identifies the port
>> regardless of type, so sfnum must be some sort of hardware internal
>> identifier?
> 
> Basically pfnum, sfnum and vfnum could overlap. Index is unique within
> all groups together.
> 

Right. Index is just an identifier for which port this is.

> 
>>
>> When looking at this with colleagues, there was a lot of confusion about
>> the difference between the index and the sfnum.
> 
> No confusion about index and pfnum/vfnum? They behave the same.
> Index is just a port handle.
> 

I'm less confused about the difference between index and these "nums",
and more so questioning what pfnum/vfnum/sfnum represent? Are they
similar to the vf ID that we have in the legacy SRIOV functions? I.e. a
hardware index?

I don't think in general users necessarily care which "index" they get
upfront. They obviously very much care about the index once it's
selected. I do believe the interfaces should start with the capability
for the index to be selected automatically at creation (with the
optional capability to select a specific index if desired, as shown here).

I do not think most users want to care about what to pick for this
number. (Just as they would not want to pick a number for the port index
either).

> 
>>
>>> The devlink kernel code calls down to device driver (devlink op) and asks
>>> it to create a SF port with particular attributes. Driver then instantiates
>>> the SF port in the same way it is done for VF.
>>>
>>
>> What do you mean by attributes here? what sort of attributes can be
>> requested?
> 
> In the original slice proposal, it was possible to pass the mac address
> too. However with new approach (port func subobject) that is not
> possible. I'll remove this rudiment.
> 

Ok.

> 
>>
>>>
>>> Note that it may be possible to avoid passing port index and let the
>>> kernel assign index for you:
>>> $ devlink port add pci/0000.06.00.0 flavour pcisf pfnum 1 sfnum 10
>>>
>>> This would work in a similar way as devlink region id assignment that
>>> is being pushed now.
>>>
>>
>> Sure, this makes sense to me after seeing Jakub's recent patch for
>> regions. I like this approach. Letting the user not have to pick an ID
>> ahead of time is useful.
>>
>> Is it possible to skip providing an sfnum, and let the kernel or driver
>> pick one? Or does that not make sense?
> 
> Does not. The sfnum is something that should be deterministic. The sfnum
> is then visible on the other side on the virtbus device:
> /sys/bus/virtbus/devices/mlx5_sf.1/sfnum
> and it's name is generated accordingly: enp6s0f0s10
> 

Why not have the option to say "create me an sfnum and then report it to
me" in the same way we do with region numbers now and plan to with port
indexes?

Basically: why do I as a user of the front end care what this number
actually is? What does it represent?

> 
> 
>>
>>> ==================================================================
>>> ||                                                              ||
>>> ||   VF manual creation and activation user cmdline API draft   ||
>>> ||                                                              ||
>>> ==================================================================
>>>
>>> To enter manual mode, the user has to turn off VF dummies creation:
>>> $ devlink dev set pci/0000:06:00.0 vf_dummies disabled
>>> $ devlink dev show
>>> pci/0000:06:00.0: vf_dummies disabled
>>>
>>> It is "enabled" by default in order not to break existing users.
>>>
>>> By setting the "vf_dummies" attribute to "disabled", the driver
>>> removes all dummy VFs. Only physical ports are present:
>>>
>>> $ devlink port show
>>> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>>> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
>>>
>>> Then the user is able to create them in a similar way as SFs:
>>>
>>> $ devlink port add pci/0000:06:00.0/99 flavour pcivf pfnum 1 vfnum 8
>>>
>>
>> So in this case, you have to specify the VF index to create? So this
>> vfum is very similar to the sfnum (and pfnum?) above?
> 
> Yes.
> 
> 
>>
>> What about the ability to just say "please give me a VF, but I don't
>> care which one"?
> 
> Well, that could be eventually done too, with Jakub's extension.
> 

Sure. I think that's what I was asking above as well. Ok.

>>>
>>>    $ devlink port show
>>>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>>>
>>>    If there is another parent PF, say "0000:06:00.1", that share the
>>>    same embedded switch, the aliasing is established for devlink handles.
>>>
>>>    The user can use devlink handles:
>>>    pci/0000:06:00.0
>>>    pci/0000:06:00.1
>>>    as equivalents, pointing to the same devlink instance.
>>>
>>>    Parent PFs are the ones that may be in control of managing
>>>    embedded switch, on any hierarchy leve>
>>> 2) Child PF. This is a leg of a PF put to the parent PF. It is
>>>    represented by a port a port with a netdevice and func:
>>>
>>>    $ devlink port show
>>>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>>>    pci/0000:06:00.0/1: flavour pcipf pfnum 2 type eth netdev enp6s0f0pf2
>>>        func: hw_addr aa:bb:cc:aa:bb:87 state active
>>>
>>>    This is a typical smartnic scenario. You would see this list on
>>>    the smartnic CPU. The port pci/0000:06:00.0/1 is a leg to
>>>    one of the hosts. If you send packets to enp6s0f0pf2, they will
>>>    go to the child PF.
>>>
>>>    Note that inside the host, the PF is represented again as "Parent PF"
>>>    and may be used to configure nested embedded switch.
>>>
>>>
>>
>> I'm not sure I understand this section. Child PF? Is this like a PF in
>> another host? Or representing the other side of the virtual link?
> 
> It's both actually, at the same time.
> 
> 

Ok. I still don't think I fully grasp this yet.


>> Obviously this is a TODO, but how does this differ from the current
>> port_split and port_unsplit?
> 
> Does not have anything to do with port splitting. This is about creating
> a "child PF" from the section above.
> 

Hmm. Ok so this is about internal connections in the switch, then?
