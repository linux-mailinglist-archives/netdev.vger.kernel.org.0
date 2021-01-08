Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A47F2EEB5F
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 03:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbhAHCip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 21:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbhAHCip (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 21:38:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9446E23603;
        Fri,  8 Jan 2021 02:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610073484;
        bh=u9Meeu6HfvOew9S7LGtt5CbLSm911UHLZRnTJe36nYo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fKW91XnY1Q3ArV9gMHXdmojkE3Z1SlC6HNsajZ62H9TCOlx0jdSoXgrTRmMZnR9Br
         WoSBZot/q72eHyxY2XDZwvctz0IXvKoHjhxA53exiT6D0Ytqyj8l745TwigVQ1CIkX
         ihje/YzURewbIXq/jg3jp/foxbD7Oh16okIDfXO+BT9LaL9Wuajx1/booJpFWCsw8E
         AiyIH/6VCcIVG1TALA0ejXcSO/sU68xJty6U5gfH8v21NQl5va/4nMm/0WLVd/cfWg
         zZZoFJOD0QBrU25qAO/RAUQwnvpEr5c0MWcGCm4Pu5iJDt0Mr2Ao5EDfSZCW+Es4vl
         vr5D/dBWG/bAg==
Date:   Thu, 7 Jan 2021 18:38:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: ipa: re-enable NAPI before enabling
 interrupt
Message-ID: <20210107183803.47308e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107214325.7077-3-elder@linaro.org>
References: <20210107214325.7077-1-elder@linaro.org>
        <20210107214325.7077-3-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 15:43:25 -0600 Alex Elder wrote:
> @@ -743,21 +743,21 @@ static void gsi_channel_freeze(struct gsi_channel *channel)
>  	set_bit(GSI_CHANNEL_FLAG_STOPPING, channel->flags);
>  	smp_mb__after_atomic();	/* Ensure gsi_channel_poll() sees new value */
>  
> -	napi_disable(&channel->napi);
> -
>  	gsi_irq_ieob_disable(channel->gsi, channel->evt_ring_id);
> +
> +	napi_disable(&channel->napi);
>  }

So patch 1 is entirely for the purpose of keeping the code symmetric
here? I can't think of other reason why masking this IRQ couldn't be
left after NAPI is disabled, and that should work as you expect.

>  /* Allow transactions to be used on the channel again. */
>  static void gsi_channel_thaw(struct gsi_channel *channel)
>  {
> -	gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
> -
>  	/* Allow the NAPI poll loop to re-enable interrupts again */
>  	clear_bit(GSI_CHANNEL_FLAG_STOPPING, channel->flags);
>  	smp_mb__after_atomic();	/* Ensure gsi_channel_poll() sees new value */
>  
>  	napi_enable(&channel->napi);
> +
> +	gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
>  }
