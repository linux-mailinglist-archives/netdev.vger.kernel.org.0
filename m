Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4C11F79BD
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 16:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgFLOZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 10:25:42 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:58625 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgFLOZl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 10:25:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1591971941; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=6TkXm7WIXe6JmUlAyDwjFnbArqNv0j3TvAXTAuTgCHs=;
 b=f5yZSs/m6xZ9iyBo2lkAH6+FlaJjsva2Hxk2P26BaRRmfWM29iPqlGj02pFe1AvsDI0jYBiu
 fb0Nqui19Ch2VwBwxnBFZZNHOC8dNhlBfvMfOm0EsUnikfwDyB0yHNMI0it7oTbe7HoIYSDy
 Tjsk3m/8rcXthoFK0FY7Pv08u80=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n11.prod.us-east-1.postgun.com with SMTP id
 5ee39060356bcc26abfe7867 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 12 Jun 2020 14:25:36
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2E5F2C433CB; Fri, 12 Jun 2020 14:25:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 62898C433CA;
        Fri, 12 Jun 2020 14:25:35 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Jun 2020 19:55:35 +0530
From:   pillair@codeaurora.org
To:     Douglas Anderson <dianders@chromium.org>
Cc:     kvalo@codeaurora.org, kuabhs@google.com,
        saiprakash.ranjan@codeaurora.org, linux-arm-msm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ath10k: Wait until copy complete is actually done before
 completing
In-Reply-To: <20200609082015.1.Ife398994e5a0a6830e4d4a16306ef36e0144e7ba@changeid>
References: <20200609082015.1.Ife398994e5a0a6830e4d4a16306ef36e0144e7ba@changeid>
Message-ID: <775536279e60ccc833c481ad6ab6dab2@codeaurora.org>
X-Sender: pillair@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Doug,

The send callback for the CEs do check for hw_index/SRRI before trying 
to free the buffer.
But adding a check for copy-complete (before calling the individual CE 
callbacks) seems to be the better approach. Hence I agree that this 
patch should be added.

Thanks,
Rakesh Pillai.

On 2020-06-09 20:50, Douglas Anderson wrote:
> On wcn3990 we have "per_ce_irq = true".  That makes the
> ath10k_ce_interrupt_summary() function always return 0xfff. The
> ath10k_ce_per_engine_service_any() function will see this and think
> that _all_ copy engines have an interrupt.  Without checking, the
> ath10k_ce_per_engine_service() assumes that if it's called that the
> "copy complete" (cc) interrupt fired.  This combination seems bad.
> 
> Let's add a check to make sure that the "copy complete" interrupt
> actually fired in ath10k_ce_per_engine_service().
> 
> This might fix a hard-to-reproduce failure where it appears that the
> copy complete handlers run before the copy is really complete.
> Specifically a symptom was that we were seeing this on a Qualcomm
> sc7180 board:
>   arm-smmu 15000000.iommu: Unhandled context fault:
>   fsr=0x402, iova=0x7fdd45780, fsynr=0x30003, cbfrsynra=0xc1, cb=10
> 
> Even on platforms that don't have wcn3990 this still seems like it
> would be a sane thing to do.  Specifically the current IRQ handler
> comments indicate that there might be other misc interrupt sources
> firing that need to be cleared.  If one of those sources was the one
> that caused the IRQ handler to be called it would also be important to
> double-check that the interrupt we cared about actually fired.
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>


Reviewed-by: Rakesh Pillai <pillair@codeaurora.org>


> ---
> 
>  drivers/net/wireless/ath/ath10k/ce.c | 30 +++++++++++++++++++---------
>  1 file changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/ce.c
> b/drivers/net/wireless/ath/ath10k/ce.c
> index 294fbc1e89ab..ffdd4b995f33 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.c
> +++ b/drivers/net/wireless/ath/ath10k/ce.c
> @@ -481,6 +481,15 @@ static inline void
> ath10k_ce_engine_int_status_clear(struct ath10k *ar,
>  	ath10k_ce_write32(ar, ce_ctrl_addr + wm_regs->addr, mask);
>  }
> 
> +static inline bool ath10k_ce_engine_int_status_check(struct ath10k 
> *ar,
> +						     u32 ce_ctrl_addr,
> +						     unsigned int mask)
> +{
> +	struct ath10k_hw_ce_host_wm_regs *wm_regs = ar->hw_ce_regs->wm_regs;
> +
> +	return ath10k_ce_read32(ar, ce_ctrl_addr + wm_regs->addr) & mask;
> +}
> +
>  /*
>   * Guts of ath10k_ce_send.
>   * The caller takes responsibility for any needed locking.
> @@ -1301,19 +1310,22 @@ void ath10k_ce_per_engine_service(struct
> ath10k *ar, unsigned int ce_id)
> 
>  	spin_lock_bh(&ce->ce_lock);
> 
> -	/* Clear the copy-complete interrupts that will be handled here. */
> -	ath10k_ce_engine_int_status_clear(ar, ctrl_addr,
> -					  wm_regs->cc_mask);
> +	if (ath10k_ce_engine_int_status_check(ar, ctrl_addr,
> +					      wm_regs->cc_mask)) {
> +		/* Clear before handling */
> +		ath10k_ce_engine_int_status_clear(ar, ctrl_addr,
> +						  wm_regs->cc_mask);
> 
> -	spin_unlock_bh(&ce->ce_lock);
> +		spin_unlock_bh(&ce->ce_lock);
> 
> -	if (ce_state->recv_cb)
> -		ce_state->recv_cb(ce_state);
> +		if (ce_state->recv_cb)
> +			ce_state->recv_cb(ce_state);
> 
> -	if (ce_state->send_cb)
> -		ce_state->send_cb(ce_state);
> +		if (ce_state->send_cb)
> +			ce_state->send_cb(ce_state);
> 
> -	spin_lock_bh(&ce->ce_lock);
> +		spin_lock_bh(&ce->ce_lock);
> +	}
> 
>  	/*
>  	 * Misc CE interrupts are not being handled, but still need
