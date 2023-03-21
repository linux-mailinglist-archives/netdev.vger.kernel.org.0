Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12BE6C301C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjCULSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjCULSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:18:20 -0400
Received: from out-5.mta1.migadu.com (out-5.mta1.migadu.com [IPv6:2001:41d0:203:375::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1653F23A5C
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:18:17 -0700 (PDT)
Message-ID: <10a31caf-9ceb-8d13-4cf5-b0e2ffef948d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679397493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZyhMHy39HGuEPKSTzv5x2uvFnDEx9B7nM+K4R6uC/Ek=;
        b=T4A8OosGIB1QW2yAqJL4j2hF9OA/+ZerLdbM4CKUqZhyHtYufxEwI3ht6Yqi6lvrmL9MzS
        hZawv10xGKn68SAijRkQHS32fRGhVgK10lvaVCDIdMxC/Wg1UijrYZAvLXj43olmkKSduu
        VnyIlT32f534JQP9Pr0huYeGd50tn3A=
Date:   Tue, 21 Mar 2023 11:18:09 +0000
MIME-Version: 1.0
Subject: Re: [PATCH net-next 3/3] bnxt: Enforce PTP software freq adjustments
 only when in non-RTC mode
Content-Language: en-US
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        michael.chan@broadcom.com, kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, gospo@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com, richardcochran@gmail.com
References: <20230321103227.12020-1-pavan.chebbi@broadcom.com>
 <20230321103227.12020-4-pavan.chebbi@broadcom.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20230321103227.12020-4-pavan.chebbi@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2023 10:32, Pavan Chebbi wrote:
> Currently driver performs software based frequency adjustments
> when RTC capability is not discovered or when in shared PHC mode.
> But there may be some old firmware versions that still support
> hardware freq adjustments without RTC capability being exposed.
> In this situation driver will use non-realtime mode even on single
> host NICs.
> 
> Hence enforce software frequency adjustments only when running in
> shared PHC mode. Make suitable changes for cyclecounter for the
> same.
> 
> Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Reviewed-by: Michael Chan <michael.chan@broadcom.com>
> ---
>   drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> index a3a3978a4d1c..b79a186f864c 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
> @@ -230,7 +230,7 @@ static int bnxt_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
>   						ptp_info);
>   	struct bnxt *bp = ptp->bp;
>   
> -	if (BNXT_PTP_USE_RTC(bp))
> +	if (!BNXT_MH(ptp->bp))

bp is already resolved and stored in variable, it's better to use it

>   		return bnxt_ptp_adjfine_rtc(bp, scaled_ppm);
>   
>   	spin_lock_bh(&ptp->ptp_lock);
> @@ -861,9 +861,15 @@ static void bnxt_ptp_timecounter_init(struct bnxt *bp, bool init_tc)
>   		memset(&ptp->cc, 0, sizeof(ptp->cc));
>   		ptp->cc.read = bnxt_cc_read;
>   		ptp->cc.mask = CYCLECOUNTER_MASK(48);
> -		ptp->cc.shift = BNXT_CYCLES_SHIFT;
> -		ptp->cc.mult = clocksource_khz2mult(BNXT_DEVCLK_FREQ, ptp->cc.shift);
> -		ptp->cmult = ptp->cc.mult;
> +		if (BNXT_MH(ptp->bp)) {

and here, bp is the first argument to the function, why you do resolve 
again?

> +			/* Use timecounter based non-real time mode */
> +			ptp->cc.shift = BNXT_CYCLES_SHIFT;
> +			ptp->cc.mult = clocksource_khz2mult(BNXT_DEVCLK_FREQ, ptp->cc.shift);
> +			ptp->cmult = ptp->cc.mult;
> +		} else {
> +			ptp->cc.shift = 0;
> +			ptp->cc.mult = 1;
> +		}
>   		ptp->next_overflow_check = jiffies + BNXT_PHC_OVERFLOW_PERIOD;
>   	}
>   	if (init_tc)

Otherwise looks good!

Acked-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
