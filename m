Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D3A6B2024
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 10:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjCIJdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 04:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjCIJci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 04:32:38 -0500
Received: from out-19.mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57582E842B
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 01:32:13 -0800 (PST)
Message-ID: <38521144-ddc0-f11b-8243-636de48d0c11@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678354331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LNr9cxu0GCBKIWAwZR/NKFFGpOUc6P4kqXTQa4IwM5c=;
        b=Br48CB4dv1kckRArQKqSZcrt8UjPknVgk0wR5VlaPO1XFugOjZuYxRStiEkw8c3KcT1uxI
        Bm/2UdviWvk6I/36QYOY4wa/DVnquihcQpDE9pJ8K8eyJo0LhieyEF/0+GhBxHTgHIBXwH
        eexD7GeTyw6xFDCvaeLy09BJRWCsqxw=
Date:   Thu, 9 Mar 2023 09:32:09 +0000
MIME-Version: 1.0
Subject: Re: [PATCH net v2] bnxt_en: reset PHC frequency in free-running mode
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
References: <20230308144209.150456-1-vadfed@meta.com>
 <CALs4sv3+jKGA=z-Nb1akw2h1jkL6T7VLj4pV7KVsZwx1Gt+DnA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <CALs4sv3+jKGA=z-Nb1akw2h1jkL6T7VLj4pV7KVsZwx1Gt+DnA@mail.gmail.com>
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

On 09.03.2023 04:40, Pavan Chebbi wrote:
> On Wed, Mar 8, 2023 at 8:12 PM Vadim Fedorenko <vadfed@meta.com> wrote:
>>
>> +static int bnxt_ptp_adjfine_rtc(struct bnxt *bp, long scaled_ppm)
>> +{
>> +       s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
>> +       struct hwrm_port_mac_cfg_input *req;
>> +       int rc;
>> +
>> +       rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
>> +       if (rc)
>> +               return rc;
>> +
>> +       req->ptp_freq_adj_ppb = cpu_to_le32(ppb);
>> +       req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_ADJ_PPB);
>> +       rc = hwrm_req_send(bp, req);
>> +       if (rc)
>> +               netdev_err(bp->dev,
>> +                          "ptp adjfine failed. rc = %d\n", rc);
> 
> nit: can be a single line.
> 
>> +       return rc;
>> +}
>> +
> 
>> @@ -932,13 +937,15 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
>>          atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
>>          spin_lock_init(&ptp->ptp_lock);
>>
>> -       if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
>> +       if (BNXT_PTP_USE_RTC(ptp->bp)) {
>>                  bnxt_ptp_timecounter_init(bp, false);
>>                  rc = bnxt_ptp_init_rtc(bp, phc_cfg);
>>                  if (rc)
>>                          goto out;
>>          } else {
>>                  bnxt_ptp_timecounter_init(bp, true);
>> +               if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
> 
> I understand from your response on v1 as to why it will not affect you
> if a new firmware does not report RTC on MH.
> However, once you update the fw, any subsequent kernels upgrades will
> prevent resetting the freq stored in the PHC.
> Would changing the check to if (BNXT_MH(bp)) instead be a better option?

How will it affect hardware without RTC support? The one which doesn't have
BNXT_FW_CAP_PTP_RTC in a single-host configuration. Asking because if FW will 
not expose BNXT_FW_CAP_PTP_RTC, the check BNXT_PTP_USE_RTC() will be equal to
!BNXT_MH() and there will be no need for additional check in this else clause.


>> +                       bnxt_ptp_adjfine_rtc(bp, 0);
>>          }
>>
>>          ptp->ptp_info = bnxt_ptp_caps;
>> --
>> 2.30.2
>>

