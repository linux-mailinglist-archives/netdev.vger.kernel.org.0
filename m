Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAF66ADBC7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCGKZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCGKZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:25:15 -0500
X-Greylist: delayed 54684 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Mar 2023 02:25:13 PST
Received: from out-24.mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AB27698
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 02:25:12 -0800 (PST)
Message-ID: <aa6edec3-4be8-d1e4-159f-1659aa4e0bbe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678184710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7lTK9UGJRDX4IkJKg2UZIo69ATgMXypgW/C+oA22R/E=;
        b=j1v7QAB6REeKDnJniPEIBDPotB4oaM7v9YJmdq7ON/15bZy4Soy2wyiAZnJ7DOL+NEV09P
        lQ3cymZ/FOHwe3OMqjv/zWhiYcwu1CJPxuC7AHe+MDzJmtF1sCXo5yqx5AGkqQESR9shW1
        V+FloROpdCNKWeGNOGY0dH6y20z9AjY=
Date:   Tue, 7 Mar 2023 10:25:04 +0000
MIME-Version: 1.0
Subject: Re: [PATCH net] bnxt_en: reset PHC frequency in free-running mode
Content-Language: en-US
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
References: <20230306165344.350387-1-vadfed@meta.com>
 <CALs4sv1A1eTpH45Z=kyL3qtu7Yfu8JRW6Wc2r1d+UxjvB_EEEA@mail.gmail.com>
 <d8a49972-2875-2be9-a210-92d9dac32c03@linux.dev>
 <CALs4sv0u87c3QpkT5=pGOEtLBwuZtEhaN9Ez97jmXgPv7y3-ew@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <CALs4sv0u87c3QpkT5=pGOEtLBwuZtEhaN9Ez97jmXgPv7y3-ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2023 05:07, Pavan Chebbi wrote:
> On Tue, Mar 7, 2023 at 12:43 AM Vadim Fedorenko
> <vadim.fedorenko@linux.dev> wrote:
>>
>> On 06/03/2023 17:11, Pavan Chebbi wrote:
>>> On Mon, Mar 6, 2023 at 10:23 PM Vadim Fedorenko <vadfed@meta.com> wrote:
>>>>
>>>> @@ -932,13 +937,15 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
>>>>           atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
>>>>           spin_lock_init(&ptp->ptp_lock);
>>>>
>>>> -       if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
>>>> +       if (BNXT_PTP_RTC(ptp->bp)) {
>>>>                   bnxt_ptp_timecounter_init(bp, false);
>>>>                   rc = bnxt_ptp_init_rtc(bp, phc_cfg);
>>>>                   if (rc)
>>>>                           goto out;
>>>>           } else {
>>>>                   bnxt_ptp_timecounter_init(bp, true);
>>>> +               if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
>>>> +                       bnxt_ptp_adjfreq_rtc(bp, 0);
> 
> I am not sure if the intended objective of resetting the PHC is going
> to be achieved with this. The FW will always apply the new ppb on the
> base PHC frequency. I am not sure what you mean by "reset the hardware
> frequency of PHC to zero" in the commit message.

Well, I meant reset it to base frequency and remove any adjustments 
applied before. I'll re-phrase it in the next version.

> If you want PHC to
> start counting from 0 on init, you may use bnxt_ptp_cfg_settime() with
> 0.

That's not what we want, the current counter behavior is ok.

> Also, the RTC flag may not be set on newer firmwares running on MH
> systems. I see no harm in resetting the PHC unconditionally if we are
> not in RTC mode.

And that's perfectly fine! Each firmware upgrade requires full NIC reset 
and it will end up with reset of PHC to base frequency. But in the 
situation when we have several version of kernel running on the SLED, on 
kernel upgrade we end up with adjustment stored in the PHC using old 
kernel which was tuning RTC, but then booted into new kernel which stops 
tuning RTC. If the last stored adjustment was close to boundaries for 
some reasons, timecounter will never compensate the difference and all 
hosts in the sled will be drifting hard. The only way to bring it back 
to working state is to power reset the sled, which is disruptive action.

The fix was proved to work actually in our setup.


>>>
>>> You meant bnxt_ptp_adjfine_rtc(), right.
>>> Anyway, let me go through the patch in detail, while you may submit
>>> corrections for the build.
>>>
>> Oh, yeah, right, artefact of rebasing. Will fix it in v2, thanks.
>>
>>
>>>>           }
>>>>
>>>>           ptp->ptp_info = bnxt_ptp_caps;
>>>> --
>>>> 2.30.2
>>>>
>>

