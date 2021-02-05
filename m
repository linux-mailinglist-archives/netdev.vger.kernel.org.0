Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4185531042F
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhBEEvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:51:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229849AbhBEEvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 23:51:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF5C561481;
        Fri,  5 Feb 2021 04:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612500661;
        bh=vJRLWeUh1Mxpx9gsES/hy9gXr/MIHo+q7wald6FOY/o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OVBnYPE/2s304hVQWXBqdm8QY/yauVgOmeyp0lXUKEUsMmRQEqWQTiarm1B9oaUzM
         z3fNKIb8RHfjF00JN8Pe0FUjVTJBRGLodYT7UDVney/9znuJFCQ0iV/O8aguX5mLLl
         j0CpB+9tJiQSs+reo2ygAU+yy0k+KOsaGA/CNZPs9tShIk+re4JGr19E/XNuye5P5l
         9kuPjAM1td4zXgJIbU6hKHp1skGxHxci4qN5bcfVB97F3gqjsNzwYxUtV4AjvsnSyh
         5RmXZo6Qbt4Ic6Cy8At/EvJzZaVFQ3hzNett6KAO2vNpSOLjd6Lbn4nJW7sBcP6hdj
         yeHT+tzBr2/Gw==
Date:   Thu, 4 Feb 2021 20:50:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, elder@kernel.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] net: ipa: restructure a few functions
Message-ID: <20210204205059.4b218a6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203152855.11866-2-elder@linaro.org>
References: <20210203152855.11866-1-elder@linaro.org>
        <20210203152855.11866-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Feb 2021 09:28:49 -0600 Alex Elder wrote:
> Make __gsi_channel_start() and __gsi_channel_stop() more structurally
> and semantically similar to each other:
>   - Restructure __gsi_channel_start() to always return at the end of
>     the function, similar to the way __gsi_channel_stop() does.
>   - Move the mutex calls out of gsi_channel_stop_retry() and into
>     __gsi_channel_stop().
> 
> Restructure gsi_channel_stop() to always return at the end of the
> function, like gsi_channel_start() does.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/gsi.c | 45 +++++++++++++++++++++++--------------------
>  1 file changed, 24 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 53640447bf123..2671b76ebcfe3 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -873,17 +873,17 @@ static void gsi_channel_deprogram(struct gsi_channel *channel)
>  
>  static int __gsi_channel_start(struct gsi_channel *channel, bool start)
>  {
> -	struct gsi *gsi = channel->gsi;
> -	int ret;
> +	int ret = 0;
>  
> -	if (!start)
> -		return 0;
> +	if (start) {
> +		struct gsi *gsi = channel->gsi;
>  
> -	mutex_lock(&gsi->mutex);
> +		mutex_lock(&gsi->mutex);
>  
> -	ret = gsi_channel_start_command(channel);
> +		ret = gsi_channel_start_command(channel);
>  
> -	mutex_unlock(&gsi->mutex);
> +		mutex_unlock(&gsi->mutex);
> +	}

nit: I thought just recently Willem pointed out that keeping main flow
     unindented is considered good style, maybe it doesn't apply here
     perfectly, but I'd think it still applies. Why have the entire
     body of the function indented?

>  	return ret;
>  }
> @@ -910,11 +910,8 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
>  static int gsi_channel_stop_retry(struct gsi_channel *channel)
>  {
>  	u32 retries = GSI_CHANNEL_STOP_RETRIES;
> -	struct gsi *gsi = channel->gsi;
>  	int ret;
>  
> -	mutex_lock(&gsi->mutex);
> -
>  	do {
>  		ret = gsi_channel_stop_command(channel);
>  		if (ret != -EAGAIN)
> @@ -922,19 +919,26 @@ static int gsi_channel_stop_retry(struct gsi_channel *channel)
>  		usleep_range(3 * USEC_PER_MSEC, 5 * USEC_PER_MSEC);
>  	} while (retries--);
>  
> -	mutex_unlock(&gsi->mutex);
> -
>  	return ret;
>  }
>  
>  static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
>  {
> -	int ret;
> +	int ret = 0;
>  
>  	/* Wait for any underway transactions to complete before stopping. */
>  	gsi_channel_trans_quiesce(channel);
>  
> -	ret = stop ? gsi_channel_stop_retry(channel) : 0;
> +	if (stop) {
> +		struct gsi *gsi = channel->gsi;
> +
> +		mutex_lock(&gsi->mutex);
> +
> +		ret = gsi_channel_stop_retry(channel);
> +
> +		mutex_unlock(&gsi->mutex);
> +	}
> +
>  	/* Finally, ensure NAPI polling has finished. */
>  	if (!ret)
>  		napi_synchronize(&channel->napi);
> @@ -948,15 +952,14 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
>  	struct gsi_channel *channel = &gsi->channel[channel_id];
>  	int ret;
>  
> -	/* Only disable the completion interrupt if stop is successful */
>  	ret = __gsi_channel_stop(channel, true);
> -	if (ret)
> -		return ret;
> +	if (ret) {

This inverts the logic, right? Is it intentional?

> +		/* Disable the completion interrupt and NAPI if successful */
> +		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
> +		napi_disable(&channel->napi);
> +	}
>  
> -	gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
> -	napi_disable(&channel->napi);
> -
> -	return 0;
> +	return ret;
>  }
>  
>  /* Reset and reconfigure a channel, (possibly) enabling the doorbell engine */

