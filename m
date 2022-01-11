Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816DF48B884
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 21:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244292AbiAKUUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 15:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244149AbiAKUU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 15:20:27 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34B0C061751
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 12:20:26 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id n30-20020a17090a5aa100b001b2b6509685so856823pji.3
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 12:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C3y1gsU53cU0M96DAP0mJZYhnckzL5l0LMIdOY1soDM=;
        b=DIBAYaAINs1ZCRwrmioj93W8oTc1wNh6GCtdd3lx0HkK1+34jZUuhSYeHcceGA5gUk
         spfkDqAXZWVKYXcMubaTtH4oIFNAx+aWLhUXk1l6BkKx23gEPoVTZ14wF9l7HrTSIKs6
         B6EQS3cIIx2f/9KGNhSZkgla9BG7blg0lFH54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C3y1gsU53cU0M96DAP0mJZYhnckzL5l0LMIdOY1soDM=;
        b=7JyPMaliyGJqzOAkJYyc0rjViZU8H9RFyx2tN0mn7FC/tQoWi7GfI/wSaZumrrJ6Bu
         UxN3ZSkGjIdkG4Xc/Bh8LJ2Y+lm7qTeWPjutjJY6Yfiy2aANbPOMMbymYPCPsu64TKUV
         O9jIQSVrAYj8okJwF55c8wlGzCOqKDsyC2eWFXvch66GPzz5x9m83bApzdkoSy4XxML4
         VF+/0B6p0jqf+sPwDCbzMUYnsl5+pATT8dqzFum4EPxrPI4lE0eGEnuoO1KV4wCKNCtS
         HWZPZ7RnvHcxH+z2z7af3lLhp4hjcOR88WhoS6RatZubjYfO/jJ5cbcA7HxtasGqcv/m
         M8bg==
X-Gm-Message-State: AOAM531c9AxS5yawrPFPvFkaTDBSMRgZOwcZc13g6ECIA5cwFfTe3RBp
        /wqw5tmPRz2RPgpd8HwkzvyvTQ==
X-Google-Smtp-Source: ABdhPJxdFw4zQYvyjcl5AtbxFlvjo9EJjjDavrF0GPgcOtKpd3UN4iOcTHrAENdb5oKbCz1XkpU/TA==
X-Received: by 2002:a17:902:e88a:b0:14a:19f6:6396 with SMTP id w10-20020a170902e88a00b0014a19f66396mr6285403plg.95.1641932426389;
        Tue, 11 Jan 2022 12:20:26 -0800 (PST)
Received: from localhost ([2620:15c:202:201:f0a7:d33a:2234:5687])
        by smtp.gmail.com with UTF8SMTPSA id p32sm178337pgb.49.2022.01.11.12.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 12:20:26 -0800 (PST)
Date:   Tue, 11 Jan 2022 12:20:24 -0800
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, jponduru@codeaurora.org,
        avuyyuru@codeaurora.org, bjorn.andersson@linaro.org,
        agross@kernel.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: ipa: prevent concurrent replenish
Message-ID: <Yd3miKw2AIY8Rr0F@google.com>
References: <20220111192150.379274-1-elder@linaro.org>
 <20220111192150.379274-3-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220111192150.379274-3-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 01:21:50PM -0600, Alex Elder wrote:
> We have seen cases where an endpoint RX completion interrupt arrives
> while replenishing for the endpoint is underway.  This causes another
> instance of replenishing to begin as part of completing the receive
> transaction.  If this occurs it can lead to transaction corruption.
> 
> Use a new atomic variable to ensure only replenish instance for an
> endpoint executes at a time.
> 
> Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa_endpoint.c | 13 +++++++++++++
>  drivers/net/ipa/ipa_endpoint.h |  2 ++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 8b055885cf3cf..a1019f5fe1748 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -1088,15 +1088,27 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
>  		return;
>  	}
>  
> +	/* If already active, just update the backlog */
> +	if (atomic_xchg(&endpoint->replenish_active, 1)) {
> +		if (add_one)
> +			atomic_inc(&endpoint->replenish_backlog);
> +		return;
> +	}
> +
>  	while (atomic_dec_not_zero(&endpoint->replenish_backlog))
>  		if (ipa_endpoint_replenish_one(endpoint))
>  			goto try_again_later;

I think there is a race here, not sure whether it's a problem: If the first
interrupt is here just when a 2nd interrupt evaluates 'replenish_active' the
latter will return, since it looks like replenishing is still active, when it
actually just finished. Would replenishing be kicked off anyway shortly after
or could the transaction be stalled until another endpoint RX completion
interrupt arrives?

> +
> +	atomic_set(&endpoint->replenish_active, 0);
> +
>  	if (add_one)
>  		atomic_inc(&endpoint->replenish_backlog);
>  
>  	return;
>  
>  try_again_later:
> +	atomic_set(&endpoint->replenish_active, 0);
> +
>  	/* The last one didn't succeed, so fix the backlog */
>  	delta = add_one ? 2 : 1;
>  	backlog = atomic_add_return(delta, &endpoint->replenish_backlog);
> @@ -1691,6 +1703,7 @@ static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
>  		 * backlog is the same as the maximum outstanding TREs.
>  		 */
>  		endpoint->replenish_enabled = false;
> +		atomic_set(&endpoint->replenish_active, 0);
>  		atomic_set(&endpoint->replenish_saved,
>  			   gsi_channel_tre_max(gsi, endpoint->channel_id));
>  		atomic_set(&endpoint->replenish_backlog, 0);
> diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
> index 0a859d10312dc..200f093214997 100644
> --- a/drivers/net/ipa/ipa_endpoint.h
> +++ b/drivers/net/ipa/ipa_endpoint.h
> @@ -53,6 +53,7 @@ enum ipa_endpoint_name {
>   * @netdev:		Network device pointer, if endpoint uses one
>   * @replenish_enabled:	Whether receive buffer replenishing is enabled
>   * @replenish_ready:	Number of replenish transactions without doorbell
> + * @replenish_active:	1 when replenishing is active, 0 otherwise
>   * @replenish_saved:	Replenish requests held while disabled
>   * @replenish_backlog:	Number of buffers needed to fill hardware queue
>   * @replenish_work:	Work item used for repeated replenish failures
> @@ -74,6 +75,7 @@ struct ipa_endpoint {
>  	/* Receive buffer replenishing for RX endpoints */
>  	bool replenish_enabled;
>  	u32 replenish_ready;
> +	atomic_t replenish_active;
>  	atomic_t replenish_saved;
>  	atomic_t replenish_backlog;
>  	struct delayed_work replenish_work;		/* global wq */
> -- 
> 2.32.0
> 
