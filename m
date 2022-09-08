Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62CE5B21A3
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 17:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbiIHPJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 11:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbiIHPJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 11:09:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CEBE3D73
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 08:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662649756; x=1694185756;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xk7V8D/GmTDWtDK8d23dxkcyF6DyDJWOhRcUMF72v1o=;
  b=mGRb4fW3rxlTJy4VuRPiEMMr+ylSSwBSa0EaJVSyakp9fmI/V5fQcJGx
   GWdd6aBk85OFjHKIEJHLDxeCJLml8Z8DaX/1/yDKZCCyaVog06STMDPED
   4NVl1Yp3d9PrqXpui0Nu0kn8qgUDJY56sp1qisUYdMGVqktCO+RLX6TLH
   pngumH/APHLpjpFXpVR4h4CTuDZcx5A+AHRfPGu246ShY7jzFC2GKQeim
   DUVvXr0HzAgGYjhpP6thuJr1JkhfJPYKEOckz1eMvET6yTiAp1Bi8VmUY
   kVuMMKBncb3x+quhKXWxxpFW2IP2gQCl8YK83/puXROF2dsYQ44gygaBM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="276938665"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="276938665"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 08:08:25 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="645121693"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.215.123.179]) ([10.215.123.179])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 08:08:22 -0700
Message-ID: <3f683628-6f4b-c678-9137-38bdbe4a68ea@linux.intel.com>
Date:   Thu, 8 Sep 2022 20:38:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 4/5] net: wwan: t7xx: Enable devlink based fw
 flashing and coredump collection
Content-Language: en-US
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
References: <20220816042405.2416972-1-m.chetan.kumar@intel.com>
 <CAHNKnsT1E1A25iNN143kRZ=R5cC=P6zDJ+RkXhKYZopG4i38yQ@mail.gmail.com>
 <8458896f-9207-e548-f485-6218201c9099@linux.intel.com>
 <CAHNKnsRY2cRS8LggQbpFaPGoOT_hSZSecT8QtKxW=D7Gq7Ug+A@mail.gmail.com>
 <CAMZdPi_xNyt9JAihaRSPUgUy4h43oMxw-JjA_K3VVMmEuS55Og@mail.gmail.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <CAMZdPi_xNyt9JAihaRSPUgUy4h43oMxw-JjA_K3VVMmEuS55Og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/2022 8:53 PM, Loic Poulain wrote:
> On Wed, 7 Sept 2022 at 01:25, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>>
>> On Sat, Sep 3, 2022 at 11:32 AM Kumar, M Chetan
>> <m.chetan.kumar@linux.intel.com> wrote:
>>> On 8/30/2022 7:51 AM, Sergey Ryazanov wrote:
>>>> On Tue, Aug 16, 2022 at 7:12 AM <m.chetan.kumar@intel.com> wrote:
>>>>> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>>>>
>>>>> This patch brings-in support for t7xx wwan device firmware flashing &
>>>>> coredump collection using devlink.
>>>>>
>>>>> Driver Registers with Devlink framework.
>>>>> Implements devlink ops flash_update callback that programs modem firmware.
>>>>> Creates region & snapshot required for device coredump log collection.
>>>>> On early detection of wwan device in fastboot mode driver sets up CLDMA0 HW
>>>>> tx/rx queues for raw data transfer then registers with devlink framework.
>>>>> Upon receiving firmware image & partition details driver sends fastboot
>>>>> commands for flashing the firmware.
>>>>>
>>>>> In this flow the fastboot command & response gets exchanged between driver
>>>>> and device. Once firmware flashing is success completion status is reported
>>>>> to user space application.
>>>>>
>>>>> Below is the devlink command usage for firmware flashing
>>>>>
>>>>> $devlink dev flash pci/$BDF file ABC.img component ABC
>>>>>
>>>>> Note: ABC.img is the firmware to be programmed to "ABC" partition.
>>>>>
>>>>> In case of coredump collection when wwan device encounters an exception
>>>>> it reboots & stays in fastboot mode for coredump collection by host driver.
>>>>> On detecting exception state driver collects the core dump, creates the
>>>>> devlink region & reports an event to user space application for dump
>>>>> collection. The user space application invokes devlink region read command
>>>>> for dump collection.
>>>>>
>>>>> Below are the devlink commands used for coredump collection.
>>>>>
>>>>> devlink region new pci/$BDF/mr_dump
>>>>> devlink region read pci/$BDF/mr_dump snapshot $ID address $ADD length $LEN
>>>>> devlink region del pci/$BDF/mr_dump snapshot $ID
>>>>>
>>>>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>>>> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
>>>>> Signed-off-by: Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
>>>>
>>>> [skipped]
>>>>
>>>>> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>>>>> index 9c222809371b..00e143c8d568 100644
>>>>> --- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>>>>> +++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
>>>>
>>>> [skipped]
>>>>
>>>>> @@ -239,8 +252,16 @@ static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int
>>>>>                           return;
>>>>>                   }
>>>>>
>>>>> +               if (lk_event == LK_EVENT_CREATE_PD_PORT)
>>>>> +                       port->dl->mode = T7XX_FB_DUMP_MODE;
>>>>> +               else
>>>>> +                       port->dl->mode = T7XX_FB_DL_MODE;
>>>>>                   port->port_conf->ops->enable_chl(port);
>>>>>                   t7xx_cldma_start(md_ctrl);
>>>>> +               if (lk_event == LK_EVENT_CREATE_PD_PORT)
>>>>> +                       t7xx_uevent_send(dev, T7XX_UEVENT_MODEM_FASTBOOT_DUMP_MODE);
>>>>> +               else
>>>>> +                       t7xx_uevent_send(dev, T7XX_UEVENT_MODEM_FASTBOOT_DL_MODE);
>>>>>                   break;
>>>>>
>>>>>           case LK_EVENT_RESET:
>>>>
>>>> [skipped]
>>>>
>>>>> @@ -318,6 +349,7 @@ static void fsm_routine_ready(struct t7xx_fsm_ctl *ctl)
>>>>>
>>>>>           ctl->curr_state = FSM_STATE_READY;
>>>>>           t7xx_fsm_broadcast_ready_state(ctl);
>>>>> +       t7xx_uevent_send(&md->t7xx_dev->pdev->dev, T7XX_UEVENT_MODEM_READY);
>>>>>           t7xx_md_event_notify(md, FSM_READY);
>>>>>    }
>>>>
>>>> These UEVENT things look at least unrelated to the patch. If the
>>>> deriver is really need it, please factor out it into a separate patch
>>>> with a comment describing why userspace wants to see these events.
>>>>
>>>> On the other hand, this looks like a custom tracing implementation. It
>>>> might be better to use simple debug messages instead or even the
>>>> tracing API, which is much more powerful than any uevent.
>>>
>>> Driver is reporting modem status (up, down, exception, etc) via uevent.
>>> The wwan user space services use these states for taking some action.
>>> So we have choose uevent for reporting modem status to user space.
>>>
>>> Is it ok we retain this logic ? I will drop it from this patch and send
>>> it as a separate patch for review.
>>
>> Usually some subsystem generates common events for served devices. And
>> it is quite unusual for drivers to generate custom uevents. I found
>> only a few examples of such drivers.
>>
>> I am not against the uevent usage, I just doubt that some userspace
>> software could benefit from custom driver uevents. If this case is
>> special, then please send these uevent changes as a separate patch
>> with a comment describing why userspace wants to see them.
> 
> Yes, would be good to avoid new custom uevents if possible. I'm not
> familiar with devlink but in the case of firmware flashing I assume
> the device state is fully managed internally by the driver, and the
> command terminates with success (or not), so we don't really need to
> report async events. For firmware state, maybe having a 'state' sysfs
> prop would be a good start (as for remoteproc), with generic state
> names like "running", "crashed"...

Driver needs a way to report custom events to user space.
If sysfs is a way to report custom events will change the
implementation to it.

new 'state' entry will be created under dev and modem status
will be written to it. So user space could get the modem status.

> 
> BTW, don't remember if we already mention/address this, but isn't the
> device coredump framework more appropriate for such dump?

Devlink region provides similar capability as dev coredump.
It allows the driver to collect the dump snapshot and can be
easily accessed via devlink region read or dump commands.

Since for firmware flashing we are using devlink interface we
also choose devlink region for dump collection.

I hope it is ok to continue with devlink region.

-- 
Chetan
