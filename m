Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197466062E1
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiJTOW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiJTOW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:22:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E0A1AE2AF
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 07:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666275776; x=1697811776;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BVU7RoDTgVJY3vZrEXcEUzRuGp8h7JwV6VHGiV/88IY=;
  b=Dz+t9eIR4XNIW5L1NuGW81J7yZ1VrfAnL53rj2HqCBhLPqHgO52hx1FY
   KZsuX4KOeHSKCLLnFgKNkLeAiZoj0miRUT+L5jtuZIsHoK+nJIXRI2EOM
   On5kgFjKz04xr1V6C1kaDvHQ98RfdE4xBen7zSjqRMGf5WM8W1EOorE63
   x39gGLMksf4pKJotS9shge4vryKdrJgIvTB60IVeh2+5IxSqBWKYpjzec
   FlWIkWkBuiEZOW7YK1SAEBTCaJkYKy+uHUmdw4mPIim/J9tQR2lSJ5HtA
   K3Ek1UjMeV1hFT7zmkEQ/GIkv+uljdhxRdQ4igJpOzaO1Y8MOg21CjJrw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="393021836"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="393021836"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 07:22:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="660945475"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="660945475"
Received: from skanchar-mobl1.gar.corp.intel.com (HELO [10.215.113.204]) ([10.215.113.204])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 07:22:49 -0700
Message-ID: <eef5cc64-190d-12e4-5318-212bbc9511b0@linux.intel.com>
Date:   Thu, 20 Oct 2022 19:52:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 2/2] net: wwan: t7xx: Add NAPI support
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        ricardo.martinez@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        sreehari.kancharla@intel.com
References: <20220909163500.5389-1-sreehari.kancharla@linux.intel.com>
 <20220909163500.5389-2-sreehari.kancharla@linux.intel.com>
 <CAMZdPi8KdWCke5s03Bvy_4NZcDsgp+jPW5dqvCHyiU2C==tsmw@mail.gmail.com>
 <40146bed-6547-f9f0-b7cf-e47f628c4dc8@linux.intel.com>
 <Y0Q4gwO1uyHFN0XT@smile.fi.intel.com>
From:   "Kancharla, Sreehari" <sreehari.kancharla@linux.intel.com>
In-Reply-To: <Y0Q4gwO1uyHFN0XT@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On 10/10/2022 8:51 PM, Andy Shevchenko wrote:
> On Mon, Oct 10, 2022 at 07:52:49PM +0530, Kancharla, Sreehari wrote:
>> On 9/12/2022 6:23 PM, Loic Poulain wrote:
>>> On Fri, 9 Sept 2022 at 18:40, Sreehari Kancharla
>>> <sreehari.kancharla@linux.intel.com> wrote:
> ...
>
>>>>           if (!rxq->que_started) {
>>>>                   atomic_set(&rxq->rx_processing, 0);
>>>> -               dev_err(dpmaif_ctrl->dev, "Work RXQ: %d has not been started\n", rxq->index);
>>>> -               return;
>>>> +               dev_err(rxq->dpmaif_ctrl->dev, "Work RXQ: %d has not been started\n", rxq->index);
>>>> +               return work_done;
>>>>           }
>>>>
>>>> -       ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
>>>> -       if (ret < 0 && ret != -EACCES)
>>>> -               return;
>>>> +       if (!rxq->sleep_lock_pending) {
>>>> +               ret = pm_runtime_resume_and_get(rxq->dpmaif_ctrl->dev);
>>> AFAIK, polling is not called in a context allowing you to sleep (e.g.
>>> performing a synced pm runtime operation).
>> Device will be in resumed state when NAPI poll is invoked from IRQ context,
>> but host/driver can trigger RPM suspend to device. so we are using pm_runtime_resume_and_get
>> here to prevent runtime suspend.
> If it's known that device is always in power on state here, there is no need to
> call all this, but what you need is to bump the reference counter. Perhaps you
> need pm_runtime_get_noresume(). I.o.w. find the proper one and check that is
> not sleeping.

Agree, incrementing the reference counter will be sufficient. we will replace
pm_runtime_resume_and_get with pm_runtime_get_noresume in v2 submission.

Regards,
Sreehari

