Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E4B6ACDA3
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 20:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCFTNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 14:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCFTNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 14:13:09 -0500
Received: from out-26.mta0.migadu.com (out-26.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BCA2C662
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 11:13:05 -0800 (PST)
Message-ID: <d8a49972-2875-2be9-a210-92d9dac32c03@linux.dev>
Date:   Mon, 6 Mar 2023 19:12:59 +0000
MIME-Version: 1.0
Subject: Re: [PATCH net] bnxt_en: reset PHC frequency in free-running mode
Content-Language: en-US
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
References: <20230306165344.350387-1-vadfed@meta.com>
 <CALs4sv1A1eTpH45Z=kyL3qtu7Yfu8JRW6Wc2r1d+UxjvB_EEEA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <CALs4sv1A1eTpH45Z=kyL3qtu7Yfu8JRW6Wc2r1d+UxjvB_EEEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/03/2023 17:11, Pavan Chebbi wrote:
> On Mon, Mar 6, 2023 at 10:23 PM Vadim Fedorenko <vadfed@meta.com> wrote:
>>
>> When using a PHC in shared between multiple hosts, the previous
>> frequency value may not be reset and could lead to host being unable to
>> compensate the offset with timecounter adjustments. To avoid such state
>> reset the hardware frequency of PHC to zero on init. Some refactoring is
>> needed to make code readable.
>>
> Thanks for the patch.
> I see what you are trying to do. But I think we have some build issues
> with this.
> Haven't looked at the whole patch, but one error I can spot is down at
> the bottom.
> 
>> Fixes: 85036aee1938 ("bnxt_en: Add a non-real time mode to access NIC clock")
>> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
>> ---
>>   drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 +-
>>   drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +
>>   drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 57 +++++++++++--------
>>   3 files changed, 36 insertions(+), 29 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> index 5d4b1f2ebeac..8472ff79adf3 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
>> @@ -6989,11 +6989,9 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
>>                  if (flags & FUNC_QCFG_RESP_FLAGS_FW_DCBX_AGENT_ENABLED)
>>                          bp->fw_cap |= BNXT_FW_CAP_DCBX_AGENT;
>>          }
>> -       if (BNXT_PF(bp) && (flags & FUNC_QCFG_RESP_FLAGS_MULTI_HOST)) {
>> +       if (BNXT_PF(bp) && (flags & FUNC_QCFG_RESP_FLAGS_MULTI_HOST))
>>                  bp->flags |= BNXT_FLAG_MULTI_HOST;
>> -               if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
>> -                       bp->fw_cap &= ~BNXT_FW_CAP_PTP_RTC;
>> -       }
>> +
>>          if (flags & FUNC_QCFG_RESP_FLAGS_RING_MONITOR_ENABLED)
>>                  bp->fw_cap |= BNXT_FW_CAP_RING_MONITOR;
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
>> index dcb09fbe4007..41e4bb7b8acb 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
>> @@ -2000,6 +2000,8 @@ struct bnxt {
>>          u32                     fw_dbg_cap;
>>
>>   #define BNXT_NEW_RM(bp)                ((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
>> +#define BNXT_PTP_RTC(bp)       (!BNXT_MH(bp) && \
>> +                                ((bp)->fw_cap & BNXT_FW_CAP_PTP_RTC))
>>          u32                     hwrm_spec_code;
>>          u16                     hwrm_cmd_seq;
>>          u16                     hwrm_cmd_kong_seq;
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>> index 4ec8bba18cdd..99c1a53231aa 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>> @@ -63,7 +63,7 @@ static int bnxt_ptp_settime(struct ptp_clock_info *ptp_info,
>>                                                  ptp_info);
>>          u64 ns = timespec64_to_ns(ts);
>>
>> -       if (ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
>> +       if (BNXT_PTP_RTC(ptp->bp))
>>                  return bnxt_ptp_cfg_settime(ptp->bp, ns);
>>
>>          spin_lock_bh(&ptp->ptp_lock);
>> @@ -196,7 +196,7 @@ static int bnxt_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
>>          struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
>>                                                  ptp_info);
>>
>> -       if (ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
>> +       if (BNXT_PTP_RTC(ptp->bp))
>>                  return bnxt_ptp_adjphc(ptp, delta);
>>
>>          spin_lock_bh(&ptp->ptp_lock);
>> @@ -205,34 +205,39 @@ static int bnxt_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
>>          return 0;
>>   }
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
>> +       return rc;
>> +}
>> +
>>   static int bnxt_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
>>   {
>>          struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
>>                                                  ptp_info);
>> -       struct hwrm_port_mac_cfg_input *req;
>>          struct bnxt *bp = ptp->bp;
>> -       int rc = 0;
>>
>> -       if (!(ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)) {
>> -               spin_lock_bh(&ptp->ptp_lock);
>> -               timecounter_read(&ptp->tc);
>> -               ptp->cc.mult = adjust_by_scaled_ppm(ptp->cmult, scaled_ppm);
>> -               spin_unlock_bh(&ptp->ptp_lock);
>> -       } else {
>> -               s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
>> -
>> -               rc = hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG);
>> -               if (rc)
>> -                       return rc;
>> +       if (BNXT_PTP_RTC(ptp->bp))
>> +               return bnxt_ptp_adjfine_rtc(bp, scaled_ppm);
>>
>> -               req->ptp_freq_adj_ppb = cpu_to_le32(ppb);
>> -               req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_PTP_FREQ_ADJ_PPB);
>> -               rc = hwrm_req_send(ptp->bp, req);
>> -               if (rc)
>> -                       netdev_err(ptp->bp->dev,
>> -                                  "ptp adjfine failed. rc = %d\n", rc);
>> -       }
>> -       return rc;
>> +       spin_lock_bh(&ptp->ptp_lock);
>> +       timecounter_read(&ptp->tc);
>> +       ptp->cc.mult = adjust_by_scaled_ppm(ptp->cmult, scaled_ppm);
>> +       spin_unlock_bh(&ptp->ptp_lock);
>> +       return 0;
>>   }
>>
>>   void bnxt_ptp_pps_event(struct bnxt *bp, u32 data1, u32 data2)
>> @@ -879,7 +884,7 @@ int bnxt_ptp_init_rtc(struct bnxt *bp, bool phc_cfg)
>>          u64 ns;
>>          int rc;
>>
>> -       if (!bp->ptp_cfg || !(bp->fw_cap & BNXT_FW_CAP_PTP_RTC))
>> +       if (!bp->ptp_cfg || !BNXT_PTP_RTC(bp))
>>                  return -ENODEV;
>>
>>          if (!phc_cfg) {
>> @@ -932,13 +937,15 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
>>          atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
>>          spin_lock_init(&ptp->ptp_lock);
>>
>> -       if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
>> +       if (BNXT_PTP_RTC(ptp->bp)) {
>>                  bnxt_ptp_timecounter_init(bp, false);
>>                  rc = bnxt_ptp_init_rtc(bp, phc_cfg);
>>                  if (rc)
>>                          goto out;
>>          } else {
>>                  bnxt_ptp_timecounter_init(bp, true);
>> +               if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
>> +                       bnxt_ptp_adjfreq_rtc(bp, 0);
> 
> You meant bnxt_ptp_adjfine_rtc(), right.
> Anyway, let me go through the patch in detail, while you may submit
> corrections for the build.
> 
Oh, yeah, right, artefact of rebasing. Will fix it in v2, thanks.


>>          }
>>
>>          ptp->ptp_info = bnxt_ptp_caps;
>> --
>> 2.30.2
>>

