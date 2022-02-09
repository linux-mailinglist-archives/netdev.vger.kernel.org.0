Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D019A4AFD06
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 20:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiBITMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 14:12:44 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiBITMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 14:12:42 -0500
Received: from smtp.smtpout.orange.fr (smtp10.smtpout.orange.fr [80.12.242.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E62C0219A3
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 11:12:32 -0800 (PST)
Received: from [192.168.1.18] ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id HsMonZMVcbnFGHsMoncX1g; Wed, 09 Feb 2022 20:11:03 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 09 Feb 2022 20:11:03 +0100
X-ME-IP: 90.126.236.122
Message-ID: <b8cd030f-817a-4938-5d61-8046e7ccd2f3@wanadoo.fr>
Date:   Wed, 9 Feb 2022 20:11:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: ethernet: cavium: use div64_u64() instead of
 do_div()
Content-Language: en-US
To:     Qing Wang <wangqing@vivo.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1644395960-4232-1-git-send-email-wangqing@vivo.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <1644395960-4232-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 09/02/2022 à 09:39, Qing Wang a écrit :
> From: Wang Qing <wangqing@vivo.com>
> 
> do_div() does a 64-by-32 division.
> When the divisor is u64, do_div() truncates it to 32 bits, this means it
> can test non-zero and be truncated to zero for division.
> 
> fix do_div.cocci warning:
> do_div() does a 64-by-32 division, please consider using div64_u64 instead.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>   drivers/net/ethernet/cavium/liquidio/lio_main.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> index ba28aa4..8e07192
> --- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> @@ -1539,7 +1539,7 @@ static int liquidio_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
>   	 * compute the delta in terms of coprocessor clocks.
>   	 */
>   	delta = (u64)ppb << 32;
> -	do_div(delta, oct->coproc_clock_rate);
> +	div64_u64(delta, oct->coproc_clock_rate);
>   
>   	spin_lock_irqsave(&lio->ptp_lock, flags);
>   	comp = lio_pci_readq(oct, CN6XXX_MIO_PTP_CLOCK_COMP);
> @@ -1672,7 +1672,7 @@ static void liquidio_ptp_init(struct octeon_device *oct)
>   	u64 clock_comp, cfg;
>   
>   	clock_comp = (u64)NSEC_PER_SEC << 32;
> -	do_div(clock_comp, oct->coproc_clock_rate);
> +	div64_u64(clock_comp, oct->coproc_clock_rate);
>   	lio_pci_writeq(oct, clock_comp, CN6XXX_MIO_PTP_CLOCK_COMP);
>   
>   	/* Enable */

I think that all your recent patches about such conversions are broken.

See [1] were it was already reported that do_div() and div64_u64() don't 
have the same calling convention.

Looks that div64_u64() and div64_ul() works the same way.


CJ

[1]: 
https://lore.kernel.org/linux-kernel/20211117112559.jix3hmx7uwqmuryg@pengutronix.de/
