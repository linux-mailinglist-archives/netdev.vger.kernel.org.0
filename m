Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B351D89C3
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 23:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgERVFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 17:05:48 -0400
Received: from mga12.intel.com ([192.55.52.136]:56245 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgERVFs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 17:05:48 -0400
IronPort-SDR: Lsv/qmRHIb2wY/6W4wtPY2twmy0L/aEH0NlANlyltppTDOJyxS0p/V7hle+hNgy8s1ApEJl9Uu
 cuAo7D5fAsNw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 14:05:46 -0700
IronPort-SDR: kyxGZf14RQ2K/BjZTltKnE4wp33b2dSeCDW2741qtJB0o6yEGb1RFqgp8fPIE1fjmdnHH3KczD
 /sKmBRil6YYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="253024732"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.70.65]) ([10.209.70.65])
  by orsmga007.jf.intel.com with ESMTP; 18 May 2020 14:05:45 -0700
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
 <e3aa20ec-a47e-0b91-d6d5-1ad2020eca28@intel.com>
 <20200518065207.GA2193@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <17405a27-cd38-03c6-5ee3-0c9f8b643bfc@intel.com>
Date:   Mon, 18 May 2020 14:05:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200518065207.GA2193@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/17/2020 11:52 PM, Jiri Pirko wrote:
> Fri, May 15, 2020 at 11:36:19PM CEST, jacob.e.keller@intel.com wrote:
>>
>>
>> On 5/15/2020 2:30 AM, Jiri Pirko wrote:
>>> Fri, May 15, 2020 at 01:52:54AM CEST, jacob.e.keller@intel.com wrote:
>>>>> $ devlink port add pci/0000.06.00.0/100 flavour pcisf pfnum 1 sfnum 10
>>>>>
>>>>
>>>> Can you clarify what sfnum means here? and why is it different from the
>>>> index? I get that the index is a unique number that identifies the port
>>>> regardless of type, so sfnum must be some sort of hardware internal
>>>> identifier?
>>>
>>> Basically pfnum, sfnum and vfnum could overlap. Index is unique within
>>> all groups together.
>>>
>>
>> Right. Index is just an identifier for which port this is.
>>

Ok, so whether or not a driver uses this internally is an implementation
detail that doesn't matter to the interface.


>>>
>>>>
>>>> When looking at this with colleagues, there was a lot of confusion about
>>>> the difference between the index and the sfnum.
>>>
>>> No confusion about index and pfnum/vfnum? They behave the same.
>>> Index is just a port handle.
>>>
>>
>> I'm less confused about the difference between index and these "nums",
>> and more so questioning what pfnum/vfnum/sfnum represent? Are they
>> similar to the vf ID that we have in the legacy SRIOV functions? I.e. a
>> hardware index?
>>
>> I don't think in general users necessarily care which "index" they get
>> upfront. They obviously very much care about the index once it's
>> selected. I do believe the interfaces should start with the capability
>> for the index to be selected automatically at creation (with the
>> optional capability to select a specific index if desired, as shown here).
>>
>> I do not think most users want to care about what to pick for this
>> number. (Just as they would not want to pick a number for the port index
>> either).
> 
> I see your point. However I don't think it is always the right
> scenario. The "nums" are used for naming of the netdevices, both the
> eswitch port representor and the actual SF (in case of SF).
> 
> I think that in lot of usecases is more convenient for user to select
> the "num" on the cmdline.
> 

Agreed, based on the below statements. Basically "let users specify or
get it automatically chosen", just like with the port identifier and
with the region numbers now.


Thanks for the explanations!

>>
>>>> Obviously this is a TODO, but how does this differ from the current
>>>> port_split and port_unsplit?
>>>
>>> Does not have anything to do with port splitting. This is about creating
>>> a "child PF" from the section above.
>>>
>>
>> Hmm. Ok so this is about internal connections in the switch, then?
> 
> Yes. Take the smartnic as an example. On the smartnic cpu, the
> eswitch management is being done. There's devlink instance with all
> eswitch port visible as devlink ports. One PF-type devlink port per
> host. That are the "child PFs".
> 
> Now from perspective of the host, there are 2 scenarios:
> 1) have the "simple dumb" PF, which just exposes 1 netdev for host to
>    run traffic over. smartnic cpu manages the VFs/SFs and sees the
>    devlink ports for them. This is 1 level switch - merged switch
> 
> 2) PF manages a sub-switch/nested-switch. The devlink/devlink ports are
>    created on the host and the devlink ports for SFs/VFs are created
>    there. This is multi-level eswitch. Each "child PF" on a parent
>    manages a nested switch. And could in theory have other PF child with
>    another nested switch.
> 

Ok. So in the smart NIC CPU, we'd see the primary PF and some child PFs,
and in the host system we'd see a "primary PF" that is the other end of
the associated Child PF, and might be able to manage its own subswitch.

Ok this is making more sense now.

I think I had imagined that was what subfuntions were. But really
subfunctions are a bit different, they're more similar to expanded VFs?

Thanks,
Jake
