Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFE95FA01D
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 16:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiJJOXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 10:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJJOXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 10:23:00 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C8C7198C
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 07:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665411778; x=1696947778;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vfggAFX2vWHIrKgdI5ANpK0zVAybRFUQN/EZ+bqwuwY=;
  b=OFssVa2L65twF0D8D1EdRDHRKXwClF7VWTLdU9XhCqbPl2Vl6YdhN8l6
   IC6QoFmCypluu/g5QeV9khHRrtH9MGvCBQDJX3xiUIQvqarDrdhPC0R+F
   SYv0ac8mucPfTJlV70XaT+C66x2ngsQ/rYHbHd/0JXsKLdPjJXZxs1Aug
   h2y2XkzTy0e1flCXmjB4eNXCa2/xu8kw9MkqMzEaTwF2eMIRjw/+cv9qy
   qfw4REm5hGMYR9K3baLiqplztRJJnjIzjMB16hCK7YkJgBhJxMJL+HlS7
   A3qTB2rTvZiiUsqhoubGKVJU2L/3/TnXkpeXxOtdtnG4BpN1gZDv1plcY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="287473781"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="287473781"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 07:22:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="659164079"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="659164079"
Received: from skanchar-mobl1.gar.corp.intel.com (HELO [10.215.200.161]) ([10.215.200.161])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 07:22:52 -0700
Message-ID: <40146bed-6547-f9f0-b7cf-e47f628c4dc8@linux.intel.com>
Date:   Mon, 10 Oct 2022 19:52:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 2/2] net: wwan: t7xx: Add NAPI support
Content-Language: en-US
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        sreehari.kancharla@intel.com
References: <20220909163500.5389-1-sreehari.kancharla@linux.intel.com>
 <20220909163500.5389-2-sreehari.kancharla@linux.intel.com>
 <CAMZdPi8KdWCke5s03Bvy_4NZcDsgp+jPW5dqvCHyiU2C==tsmw@mail.gmail.com>
From:   "Kancharla, Sreehari" <sreehari.kancharla@linux.intel.com>
In-Reply-To: <CAMZdPi8KdWCke5s03Bvy_4NZcDsgp+jPW5dqvCHyiU2C==tsmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On 9/12/2022 6:23 PM, Loic Poulain wrote:
> Hi Sreehari,
>
>
> On Fri, 9 Sept 2022 at 18:40, Sreehari Kancharla
> <sreehari.kancharla@linux.intel.com> wrote:
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> Replace the work queue based RX flow with a NAPI implementation
>> Remove rx_thread and dpmaif_rxq_work.
>> Introduce dummy network device. its responsibility is
>>      - Binds one NAPI object for each DL HW queue and acts as
>>        the agent of all those network devices.
>>      - Use NAPI object to poll DL packets.
>>      - Helps to dispatch each packet to the network interface.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
>> Signed-off-by: Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>> Acked-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Acked-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>> ---
>>   drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h    |  14 +-
>>   drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 220 +++++++--------------
>>   drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h |   1 +
>>   drivers/net/wwan/t7xx/t7xx_netdev.c        |  93 ++++++++-
>>   drivers/net/wwan/t7xx/t7xx_netdev.h        |   5 +
>>   5 files changed, 167 insertions(+), 166 deletions(-)
>>
>> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
>> index 1225ca0ed51e..0ce4505e813d 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h
>> @@ -20,6 +20,7 @@
> [...]
>
>> -static void t7xx_dpmaif_rxq_work(struct work_struct *work)
>> +int t7xx_dpmaif_napi_rx_poll(struct napi_struct *napi, const int budget)
>>   {
>> -       struct dpmaif_rx_queue *rxq = container_of(work, struct dpmaif_rx_queue, dpmaif_rxq_work);
>> -       struct dpmaif_ctrl *dpmaif_ctrl = rxq->dpmaif_ctrl;
>> -       int ret;
>> +       struct dpmaif_rx_queue *rxq = container_of(napi, struct dpmaif_rx_queue, napi);
>> +       struct t7xx_pci_dev *t7xx_dev = rxq->dpmaif_ctrl->t7xx_dev;
>> +       int ret, once_more = 0, work_done = 0;
>>
>>          atomic_set(&rxq->rx_processing, 1);
>>          /* Ensure rx_processing is changed to 1 before actually begin RX flow */
>> @@ -917,22 +840,54 @@ static void t7xx_dpmaif_rxq_work(struct work_struct *work)
>>
>>          if (!rxq->que_started) {
>>                  atomic_set(&rxq->rx_processing, 0);
>> -               dev_err(dpmaif_ctrl->dev, "Work RXQ: %d has not been started\n", rxq->index);
>> -               return;
>> +               dev_err(rxq->dpmaif_ctrl->dev, "Work RXQ: %d has not been started\n", rxq->index);
>> +               return work_done;
>>          }
>>
>> -       ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
>> -       if (ret < 0 && ret != -EACCES)
>> -               return;
>> +       if (!rxq->sleep_lock_pending) {
>> +               ret = pm_runtime_resume_and_get(rxq->dpmaif_ctrl->dev);
> AFAIK, polling is not called in a context allowing you to sleep (e.g.
> performing a synced pm runtime operation).

Device will be in resumed state when NAPI poll is invoked from IRQ context,
but host/driver can trigger RPM suspend to device. so we are using pm_runtime_resume_and_get
here to prevent runtime suspend.

>
>> +               if (ret < 0 && ret != -EACCES)
>> +                       return work_done;
>>
>> -       t7xx_pci_disable_sleep(dpmaif_ctrl->t7xx_dev);
>> -       if (t7xx_pci_sleep_disable_complete(dpmaif_ctrl->t7xx_dev))
>> -               t7xx_dpmaif_do_rx(dpmaif_ctrl, rxq);
>> +               t7xx_pci_disable_sleep(t7xx_dev);
>> +       }
>>
>> -       t7xx_pci_enable_sleep(dpmaif_ctrl->t7xx_dev);
>> -       pm_runtime_mark_last_busy(dpmaif_ctrl->dev);
>> -       pm_runtime_put_autosuspend(dpmaif_ctrl->dev);
>> +       ret = try_wait_for_completion(&t7xx_dev->sleep_lock_acquire);
> The logic seems odd, why not simply scheduling napi polling when you
> are really ready to handle it, i.e when you have awake condition & rx
> ready.

we are using device lock inside the NAPI poll to prevent device to
enter into low power mode when there are pending RX. once packet is
collected we release the device lock so that device can go to low power mode.

>
>> +       if (!ret) {
>> +               napi_complete_done(napi, work_done);
>> +               rxq->sleep_lock_pending = true;
>> +               napi_reschedule(napi);
>> +               return work_done;
>> +       }
>> +
> [...]
>
> Regards,
> Loic

Regards,
Sreehari

