Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E6751E2B6
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 02:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445077AbiEGAYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 20:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiEGAXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 20:23:51 -0400
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 May 2022 17:19:57 PDT
Received: from novek.ru (unknown [93.153.171.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D5B703D4
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 17:19:57 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id AE4125046C4;
        Sat,  7 May 2022 03:19:13 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru AE4125046C4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1651882755; bh=YK+epbqb0OOxHyXc5EcSIS3Zq3MapQNPr2/IiQ78tLA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=d5EGoQ34ehUNtKZixwhUWFvMqO0MSwdNaHN7B3A7B83IHGJFSq6A0c9sGIi9l/6ht
         tRRZVAI3SixKGxHhSWMBhBV6FraqyRnujmfOooZfTl8vRGkgqjCiq7F0P47zpTa1Sw
         ZwxCCa4iF/JKjJ3ZdqcSoJhYV38WBgN1HD/+u6O0=
Message-ID: <a07b0326-19c7-5756-106c-28b52975871d@novek.ru>
Date:   Sat, 7 May 2022 01:19:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] ptp: ocp: have adjtime handle negative delta_ns
 correctly
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
References: <20220505234050.3378-1-jonathan.lemon@gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220505234050.3378-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.05.2022 00:40, Jonathan Lemon wrote:
> delta_ns is a s64, but it was being passed ptp_ocp_adjtime_coarse
> as an u64.  Also, it turns out that timespec64_add_ns() only handles
> positive values, so the math needs to be updated.
> 
> Fix by passing in the correct signed value, then adding to a
> nanosecond version of the timespec.
> 
> Fixes: '90f8f4c0e3ce ("ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments")'
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>   drivers/ptp/ptp_ocp.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index dd45471f6780..65e592ec272e 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -841,16 +841,18 @@ __ptp_ocp_adjtime_locked(struct ptp_ocp *bp, u32 adj_val)
>   }
>   
>   static void
> -ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, u64 delta_ns)
> +ptp_ocp_adjtime_coarse(struct ptp_ocp *bp, s64 delta_ns)
>   {
>   	struct timespec64 ts;
>   	unsigned long flags;
>   	int err;
> +	s64 ns;
>   
>   	spin_lock_irqsave(&bp->lock, flags);
>   	err = __ptp_ocp_gettime_locked(bp, &ts, NULL);
>   	if (likely(!err)) {
> -		timespec64_add_ns(&ts, delta_ns);
> +		ns = timespec64_to_ns(&ts) + delta_ns;
> +		ts = ns_to_timespec64(ns);

Maybe use set_normalized_timespec64 instead of this ugly transformations and 
additional variable?

>   		__ptp_ocp_settime_locked(bp, &ts);
>   	}
>   	spin_unlock_irqrestore(&bp->lock, flags);

