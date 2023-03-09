Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E866B21D6
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCIKu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCIKuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:50:54 -0500
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [IPv6:2001:41d0:1004:224b::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC44E190E
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 02:50:53 -0800 (PST)
Message-ID: <a2e3f3d3-f53c-d270-0495-e67624c3db96@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678359051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PSqgn+LyqwaqKiKtPnUad7I6dC3asQqsbSuS/YLaXug=;
        b=w0eJPpbDPsPbaSetgRfL+cppmXrLCXzuSidpApkEIFVTMBQWA9aFCPhtFbqeqeyqY/bwnf
        /lJvu/PuyFCRJGYoWrrgwVX+mtUs9xDLARmghxgV6m8Te7WzAJxqF+MrBpTE11geKkUTMC
        fGQobEJcCVcszOoowtkvsN8NdQQMMGM=
Date:   Thu, 9 Mar 2023 10:50:48 +0000
MIME-Version: 1.0
Subject: Re: [PATCH net v2] bnxt_en: reset PHC frequency in free-running mode
Content-Language: en-US
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
References: <20230308144209.150456-1-vadfed@meta.com>
 <CALs4sv3+jKGA=z-Nb1akw2h1jkL6T7VLj4pV7KVsZwx1Gt+DnA@mail.gmail.com>
 <38521144-ddc0-f11b-8243-636de48d0c11@linux.dev>
 <CALs4sv2cOFEVFwJ_UgV5T0iJOAzM7X=jvDqsdAtjiuQjTs5U8g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <CALs4sv2cOFEVFwJ_UgV5T0iJOAzM7X=jvDqsdAtjiuQjTs5U8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03/2023 10:11, Pavan Chebbi wrote:
> On Thu, Mar 9, 2023 at 3:02 PM Vadim Fedorenko
> <vadim.fedorenko@linux.dev> wrote:
>>
>> On 09.03.2023 04:40, Pavan Chebbi wrote:
>>> On Wed, Mar 8, 2023 at 8:12 PM Vadim Fedorenko <vadfed@meta.com> wrote:
> 
>>>> @@ -932,13 +937,15 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
>>>>           atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
>>>>           spin_lock_init(&ptp->ptp_lock);
>>>>
>>>> -       if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
>>>> +       if (BNXT_PTP_USE_RTC(ptp->bp)) {
>>>>                   bnxt_ptp_timecounter_init(bp, false);
>>>>                   rc = bnxt_ptp_init_rtc(bp, phc_cfg);
>>>>                   if (rc)
>>>>                           goto out;
>>>>           } else {
>>>>                   bnxt_ptp_timecounter_init(bp, true);
>>>> +               if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
>>>
>>> I understand from your response on v1 as to why it will not affect you
>>> if a new firmware does not report RTC on MH.
>>> However, once you update the fw, any subsequent kernels upgrades will
>>> prevent resetting the freq stored in the PHC.
>>> Would changing the check to if (BNXT_MH(bp)) instead be a better option?
>>
>> How will it affect hardware without RTC support? The one which doesn't have
>> BNXT_FW_CAP_PTP_RTC in a single-host configuration. Asking because if FW will
> 
> For single hosts, it should not matter if we reset the PHC frequency.
> bnxt_ptp_init() is [re]initializing the host-timecounter, and this
> function being called on a single host means everything is going to
> [re]start from scratch.
> 
>> not expose BNXT_FW_CAP_PTP_RTC, the check BNXT_PTP_USE_RTC() will be equal to
>> !BNXT_MH() and there will be no need for additional check in this else clause.
> 
> You are right, hence my original suggestion of resetting the PHC freq
> unconditionally is better.
> One more thing, the function bnxt_ptp_adjfine() should select
> non-realtime adjustments only for MH systems.
> You may need to flip the check, something like
> 
> if (!BNXT_MH(ptp->bp))
>      return bnxt_ptp_adjfine_rtc(bp, scaled_ppm);
> 
> This is because there can be a very old firmware which does not have
> RTC on single hosts but we still want to make HW adjustments.

Well, I just want to be sure that we will support all possible 
combinations of FW in the driver. AFAIU, there 3 different options:

1. Very old firmware. Doesn't have RTC support and doesn't expose 
BNXT_FW_CAP_PTP_RTC. Call to bnxt_ptp_adjfine_rtc on this variant may 
make HW unusable. We MUST not call it in this case. The timecounter is 
also not supported in this configuration, right?
2. Firmware which supports RTC and exposes BNXT_FW_CAP_PTP_RTC. 
Timecounter should be used only in MH case then.
3. Firmware which supports RTC, but doesn't expose BNXT_FW_CAP_PTP_RTC 
for MH configuration. How can we understand that it's not variant 1 in 
MH configuration? Or are we sure FUNC_QCAPS_RESP_FLAGS_PTP_SUPPORTED is 
not set on old firmware?

