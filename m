Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BCA5B9133
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiINX6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiINX57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:57:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3659895DA;
        Wed, 14 Sep 2022 16:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A57C61F98;
        Wed, 14 Sep 2022 23:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C2BC433C1;
        Wed, 14 Sep 2022 23:57:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="YJt+iQVD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663199874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WoDIT5eIztxN/A5cr/eafHeb7HBI3yPmyon5uDYG+OQ=;
        b=YJt+iQVDKX8Sb0eSFn7QZK4SwRRKchE/f/BgUTiNpqBroqhDCxsulraGwcFROK1nvueJoK
        7pH30TfvydSFp3oJrOwNKCrQKgJ1LoBYbkyI3XP7IZvmuKziB0ysfIPhhJJeNL4AxXpNXm
        bfeaOH4VKBsCDgMlK1qOckYQdsFF8hs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 91a8dbcc (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 14 Sep 2022 23:57:53 +0000 (UTC)
Date:   Thu, 15 Sep 2022 00:57:50 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     loic.poulain@linaro.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] wcn36xx: Add RX frame SNR as a source of system
 entropy
Message-ID: <YyJqfsXLESDWDBvR@zx2c4.com>
References: <20220914212841.1407497-1-bryan.odonoghue@linaro.org>
 <20220914212841.1407497-2-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220914212841.1407497-2-bryan.odonoghue@linaro.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 10:28:41PM +0100, Bryan O'Donoghue wrote:
> The signal-to-noise-ratio SNR is returned by the wcn36xx firmware for each
> received frame. SNR represents all of the unwanted interference signal
> after filtering out the fundamental frequency and harmonics of the
> frequency.
> 
> Noise can come from various electromagnetic sources, from temperature
> affecting the performance hardware components or quantization effects
> converting from analog to digital domains.
> 
> The SNR value returned by the WiFi firmware then is a good source of
> entropy.
> 
> Other WiFi drivers offer up the noise component of the FFT as an entropy
> source for the random pool e.g.
> 
> commit 2aa56cca3571 ("ath9k: Mix the received FFT bins to the random pool")
> 
> I attended Jason's talk on sources of randomness at Plumbers and it
> occurred to me that SNR is a reasonable candidate to add.

Neat!

> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/txrx.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
> index 8da3955995b6e..b73229776af8b 100644
> --- a/drivers/net/wireless/ath/wcn36xx/txrx.c
> +++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
> @@ -16,6 +16,7 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/random.h>
>  #include "txrx.h"
>  
>  static inline int get_rssi0(struct wcn36xx_rx_bd *bd)
> @@ -297,6 +298,8 @@ static void wcn36xx_update_survey(struct wcn36xx *wcn, int rssi, int snr,
>  	wcn->chan_survey[idx].rssi = rssi;
>  	wcn->chan_survey[idx].snr = snr;
>  	spin_unlock(&wcn->survey_lock);
> +
> +	add_device_randomness(&snr, sizeof(s8));

Won't this break on big endian? Just have an assignment handle it:

    u8 snr_sample = snr & 0xff;
    add_device_randomness(&snr_sample, sizeof(snr_sample);

That & 0xff is redundant, but it doesn't hurt to be explicit.

Jason
