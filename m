Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5FF21BCD0
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 20:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgGJSQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 14:16:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:56101 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgGJSQy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 14:16:54 -0400
IronPort-SDR: SrpesogLaZiasCG143UK0QEAp6091SSnQyG0PO8JYfp2AimNLuSg+tIfzkuknTqRZdWOKBjKeF
 i4WUzvgs7q2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="209799548"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="209799548"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 11:16:52 -0700
IronPort-SDR: E2BzUtvoiXOm56H/HCDCauw1BcW/4veBhflLmq3sAfA/HZwH52wbh4KmBVtaX/p+Nq6pEgPyph
 fVHfe4dEhc4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="306627556"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.20.152]) ([10.212.20.152])
  by fmsmga004.fm.intel.com with ESMTP; 10 Jul 2020 11:16:51 -0700
Subject: Re: [RFC v2 net-next] devlink: Add reset subcommand.
To:     Jiri Pirko <jiri@resnulli.us>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>, moshe@mellanox.com
References: <1593516846-28189-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200630125353.GA2181@nanopsycho>
 <CAACQVJqxLhmO=UiCMh_pv29WP7Qi4bAZdpU9NDk3Wq8TstM5zA@mail.gmail.com>
 <20200701055144.GB2181@nanopsycho>
 <CAACQVJqac3JGY_w2zp=thveG5Hjw9tPGagHPvfr2DM3xL4j_zg@mail.gmail.com>
 <20200701094738.GD2181@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <61c8618e-6a82-d28f-4cab-429e4a90bff6@intel.com>
Date:   Fri, 10 Jul 2020 11:16:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200701094738.GD2181@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/1/2020 2:47 AM, Jiri Pirko wrote:
> Wed, Jul 01, 2020 at 11:25:50AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> On Wed, Jul 1, 2020 at 11:21 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>>
>>> Tue, Jun 30, 2020 at 05:15:18PM CEST, vasundhara-v.volam@broadcom.com wrote:
>>>> On Tue, Jun 30, 2020 at 6:23 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>>>>
>>>>> Tue, Jun 30, 2020 at 01:34:06PM CEST, vasundhara-v.volam@broadcom.com wrote:
>>>>>> Advanced NICs support live reset of some of the hardware
>>>>>> components, that resets the device immediately with all the
>>>>>> host drivers loaded.
>>>>>>
>>>>>> Add devlink reset subcommand to support live and deferred modes
>>>>>> of reset. It allows to reset the hardware components of the
>>>>>> entire device and supports the following fields:
>>>>>>
>>>>>> component:
>>>>>> ----------
>>>>>> 1. MGMT : Management processor.
>>>>>> 2. DMA : DMA engine.
>>>>>> 3. RAM : RAM shared between multiple components.
>>>>>> 4. AP : Application processor.
>>>>>> 5. ROCE : RoCE management processor.
>>>>>> 6. All : All possible components.
>>>>>>
>>>>>> Drivers are allowed to reset only a subset of requested components.
>>>>>
>>>>> I don't understand why would user ever want to do this. He does not care
>>>>> about some magic hw entities. He just expects the hw to work. I don't
>>>>> undestand the purpose of exposing something like this. Could you please
>>>>> explain in details? Thanks!
>>>>>
>>>> If a user requests multiple components and if the driver is only able
>>>> to honor a subset, the driver will return the components unset which
>>>> it is able to reset.  For example, if a user requests MGMT, RAM and
>>>> ROCE components to be reset and driver resets only MGMT and ROCE.
>>>> Driver will unset only MGMT and ROCE bits and notifies the user that
>>>> RAM is not reset.
>>>>
>>>> This will be useful for drivers to reset only a subset of components
>>>> requested instead of returning error or silently doing only a subset
>>>> of components.
>>>>
>>>> Also, this will be helpful as user will not know the components
>>>> supported by different vendors.
>>>
>>> Your reply does not seem to be related to my question :/
>> I thought that you were referring to: "Drivers are allowed to reset
>> only a subset of requested components."
>>
>> or were you referring to components? If yes, the user can select the
>> components that he wants to go for reset. This will be useful in the
>> case where, if the user flashed only a certain component and he wants
>> to reset that particular component. For example, in the case of SOC
>> there are 2 components: MGMT and AP. If a user flashes only
>> application processor, he can choose to reset only application
>> processor.
> 
> We already have notion of "a component" in "devlink dev flash". I think
> that the reset component name should be in-sync with the flash.
> 

Right. We should re-use the component names from devlink dev info here
(just as we do in devlink dev flash).

> Thinking about it a bit more, we can extend the flash command by "reset"
> attribute that would indicate use wants to do flash&reset right away.
> 
If we add this to reload I'm not sure it's necessary. The devlink
application could be configured to request a reload after the update
completes.

> Also, thinking how this all aligns with "devlink dev reload" which we
> currently have. The purpose of it is to re-instantiate driver instances,
> but in case of mlxsw it means friggering FW reset as well.
> 
> Moshe (cced) is now working on "devlink dev reload" extension that would
> allow user to ask for a certain level of reload: driver instances only,
> fw reset too, live fw patching, etc.

Have patches for this been posted at all?

> 
> Not sure how this overlaps with your intentions. I think it would be
> great to see Moshe's RFC here as well so we can aligh the efforts.
> 

Yes.
