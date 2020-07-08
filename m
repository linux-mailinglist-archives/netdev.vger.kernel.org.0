Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84AD218306
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 11:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgGHJAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 05:00:09 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:56415 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727903AbgGHJAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 05:00:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594198807; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=AnP4iG40bGlOuYMKU9k6KR4SZ+SwX+sAGMkPobXSsGw=; b=Bn8SdMxcyDudTU1TvXH95a/ZVg1Flxl/6CcejEUNJdZ76UORxIUbeGWPyjZm87ZHdg9soTDw
 39gTc00NXZ3ctQMjvT5DxT/dq7FgQYC7dy+Rw5z6UC88myZzSV5z+l78nTI/NY4zq53W+2FN
 wai1fh/h2K6gPXyRtdiE+zaLdyM=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n16.prod.us-east-1.postgun.com with SMTP id
 5f058a7d71d7ca1d3a34b840 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 08 Jul 2020 08:57:33
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C913EC433CB; Wed,  8 Jul 2020 08:57:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from Pillair (unknown [183.83.71.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B358EC433C8;
        Wed,  8 Jul 2020 08:57:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B358EC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Douglas Anderson'" <dianders@chromium.org>,
        <kvalo@codeaurora.org>, <ath10k@lists.infradead.org>
Cc:     <saiprakash.ranjan@codeaurora.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <kuabhs@google.com>, "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200707101712.1.I4d2f85ffa06f38532631e864a3125691ef5ffe06@changeid>
In-Reply-To: <20200707101712.1.I4d2f85ffa06f38532631e864a3125691ef5ffe06@changeid>
Subject: RE: [PATCH] ath10k: Keep track of which interrupts fired, don't poll them
Date:   Wed, 8 Jul 2020 14:27:23 +0530
Message-ID: <002901d65505$cf84e980$6e8ebc80$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFX/AFmGClWM6hRB9/6MNyA6NEWt6n6EwpQ
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Douglas Anderson <dianders@chromium.org>
> Sent: Tuesday, July 7, 2020 10:48 PM
> To: kvalo@codeaurora.org; ath10k@lists.infradead.org
> Cc: saiprakash.ranjan@codeaurora.org; linux-arm-msm@vger.kernel.org;
> linux-wireless@vger.kernel.org; pillair@codeaurora.org;
> kuabhs@google.com; Douglas Anderson <dianders@chromium.org>; David
> S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: [PATCH] ath10k: Keep track of which interrupts fired, don't poll
> them
> 
> If we have a per CE (Copy Engine) IRQ then we have no summary
> register.  Right now the code generates a summary register by
> iterating over all copy engines and seeing if they have an interrupt
> pending.
> 
> This has a problem.  Specifically if _none_ if the Copy Engines have
> an interrupt pending then they might go into low power mode and
> reading from their address space will cause a full system crash.  This
> was seen to happen when two interrupts went off at nearly the same
> time.  Both were handled by a single call of ath10k_snoc_napi_poll()
> but, because there were two interrupts handled and thus two calls to
> napi_schedule() there was still a second call to
> ath10k_snoc_napi_poll() which ran with no interrupts pending.
> 
> Instead of iterating over all the copy engines, let's just keep track
> of the IRQs that fire.  Then we can effectively generate our own
> summary without ever needing to read the Copy Engines.
> 
> Tested-on: WCN3990 SNOC WLAN.HL.3.2.2-00490-QCAHLSWMTPL-1
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>


Reviewed-by:  Rakesh Pillai <pillair@codeaurora.org> 


> ---
> This patch continues work to try to squash all instances of the crash
> we've been seeing while reading CE registers and hopefully this patch
> addresses the true root of the issue.
> 
> The first patch that attempted to address these problems landed as
> commit 8f9ed93d09a9 ("ath10k: Wait until copy complete is actually
> done before completing").  After that Rakesh Pillai posted ("ath10k:
> Add interrupt summary based CE processing") [1] and this patch is
> based atop that one.  Both of those patches significantly reduced the
> instances of problems but didn't fully eliminate them.  Crossing my
> fingers that they're all gone now.
> 
> [1] https://lore.kernel.org/r/1593193967-29897-1-git-send-email-
> pillair@codeaurora.org
> 
>  drivers/net/wireless/ath/ath10k/ce.c   | 84 ++++++++++----------------
>  drivers/net/wireless/ath/ath10k/ce.h   | 14 ++---
>  drivers/net/wireless/ath/ath10k/snoc.c | 18 ++++--
>  drivers/net/wireless/ath/ath10k/snoc.h |  1 +
>  4 files changed, 51 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/ce.c
> b/drivers/net/wireless/ath/ath10k/ce.c
> index 1e16f263854a..84ec80c6d08f 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.c
> +++ b/drivers/net/wireless/ath/ath10k/ce.c
> @@ -481,38 +481,6 @@ static inline void
> ath10k_ce_engine_int_status_clear(struct ath10k *ar,
>  	ath10k_ce_write32(ar, ce_ctrl_addr + wm_regs->addr, mask);
>  }
> 
> -static bool ath10k_ce_engine_int_status_check(struct ath10k *ar, u32
> ce_ctrl_addr,
> -					      unsigned int mask)
> -{
> -	struct ath10k_hw_ce_host_wm_regs *wm_regs = ar->hw_ce_regs-
> >wm_regs;
> -
> -	return ath10k_ce_read32(ar, ce_ctrl_addr + wm_regs->addr) &
> mask;
> -}
> -
> -u32 ath10k_ce_gen_interrupt_summary(struct ath10k *ar)
> -{
> -	struct ath10k_hw_ce_host_wm_regs *wm_regs = ar->hw_ce_regs-
> >wm_regs;
> -	struct ath10k_ce_pipe *ce_state;
> -	struct ath10k_ce *ce;
> -	u32 irq_summary = 0;
> -	u32 ctrl_addr;
> -	u32 ce_id;
> -
> -	ce = ath10k_ce_priv(ar);
> -
> -	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
> -		ce_state = &ce->ce_states[ce_id];
> -		ctrl_addr = ce_state->ctrl_addr;
> -		if (ath10k_ce_engine_int_status_check(ar, ctrl_addr,
> -						      wm_regs->cc_mask)) {
> -			irq_summary |= BIT(ce_id);
> -		}
> -	}
> -
> -	return irq_summary;
> -}
> -EXPORT_SYMBOL(ath10k_ce_gen_interrupt_summary);
> -
>  /*
>   * Guts of ath10k_ce_send.
>   * The caller takes responsibility for any needed locking.
> @@ -1399,45 +1367,55 @@ static void
> ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state)
>  	ath10k_ce_watermark_intr_disable(ar, ctrl_addr);
>  }
> 
> -int ath10k_ce_disable_interrupts(struct ath10k *ar)
> +void ath10k_ce_disable_interrupt(struct ath10k *ar, int ce_id)
>  {
>  	struct ath10k_ce *ce = ath10k_ce_priv(ar);
>  	struct ath10k_ce_pipe *ce_state;
>  	u32 ctrl_addr;
> -	int ce_id;
> 
> -	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
> -		ce_state  = &ce->ce_states[ce_id];
> -		if (ce_state->attr_flags & CE_ATTR_POLL)
> -			continue;
> +	ce_state  = &ce->ce_states[ce_id];
> +	if (ce_state->attr_flags & CE_ATTR_POLL)
> +		return;
> 
> -		ctrl_addr = ath10k_ce_base_address(ar, ce_id);
> +	ctrl_addr = ath10k_ce_base_address(ar, ce_id);
> 
> -		ath10k_ce_copy_complete_intr_disable(ar, ctrl_addr);
> -		ath10k_ce_error_intr_disable(ar, ctrl_addr);
> -		ath10k_ce_watermark_intr_disable(ar, ctrl_addr);
> -	}
> +	ath10k_ce_copy_complete_intr_disable(ar, ctrl_addr);
> +	ath10k_ce_error_intr_disable(ar, ctrl_addr);
> +	ath10k_ce_watermark_intr_disable(ar, ctrl_addr);
> +}
> +EXPORT_SYMBOL(ath10k_ce_disable_interrupt);
> 
> -	return 0;
> +void ath10k_ce_disable_interrupts(struct ath10k *ar)
> +{
> +	int ce_id;
> +
> +	for (ce_id = 0; ce_id < CE_COUNT; ce_id++)
> +		ath10k_ce_disable_interrupt(ar, ce_id);
>  }
>  EXPORT_SYMBOL(ath10k_ce_disable_interrupts);
> 
> -void ath10k_ce_enable_interrupts(struct ath10k *ar)
> +void ath10k_ce_enable_interrupt(struct ath10k *ar, int ce_id)
>  {
>  	struct ath10k_ce *ce = ath10k_ce_priv(ar);
> -	int ce_id;
>  	struct ath10k_ce_pipe *ce_state;
> 
> +	ce_state  = &ce->ce_states[ce_id];
> +	if (ce_state->attr_flags & CE_ATTR_POLL)
> +		return;
> +
> +	ath10k_ce_per_engine_handler_adjust(ce_state);
> +}
> +EXPORT_SYMBOL(ath10k_ce_enable_interrupt);
> +
> +void ath10k_ce_enable_interrupts(struct ath10k *ar)
> +{
> +	int ce_id;
> +
>  	/* Enable interrupts for copy engine that
>  	 * are not using polling mode.
>  	 */
> -	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
> -		ce_state  = &ce->ce_states[ce_id];
> -		if (ce_state->attr_flags & CE_ATTR_POLL)
> -			continue;
> -
> -		ath10k_ce_per_engine_handler_adjust(ce_state);
> -	}
> +	for (ce_id = 0; ce_id < CE_COUNT; ce_id++)
> +		ath10k_ce_enable_interrupt(ar, ce_id);
>  }
>  EXPORT_SYMBOL(ath10k_ce_enable_interrupts);
> 
> diff --git a/drivers/net/wireless/ath/ath10k/ce.h
> b/drivers/net/wireless/ath/ath10k/ce.h
> index a440aaf74aa4..666ce384a1d8 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.h
> +++ b/drivers/net/wireless/ath/ath10k/ce.h
> @@ -255,12 +255,13 @@ int ath10k_ce_cancel_send_next(struct
> ath10k_ce_pipe *ce_state,
>  /*==================CE Interrupt Handlers====================*/
>  void ath10k_ce_per_engine_service_any(struct ath10k *ar);
>  void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id);
> -int ath10k_ce_disable_interrupts(struct ath10k *ar);
> +void ath10k_ce_disable_interrupt(struct ath10k *ar, int ce_id);
> +void ath10k_ce_disable_interrupts(struct ath10k *ar);
> +void ath10k_ce_enable_interrupt(struct ath10k *ar, int ce_id);
>  void ath10k_ce_enable_interrupts(struct ath10k *ar);
>  void ath10k_ce_dump_registers(struct ath10k *ar,
>  			      struct ath10k_fw_crash_data *crash_data);
> 
> -u32 ath10k_ce_gen_interrupt_summary(struct ath10k *ar);
>  void ath10k_ce_alloc_rri(struct ath10k *ar);
>  void ath10k_ce_free_rri(struct ath10k *ar);
> 
> @@ -376,12 +377,9 @@ static inline u32
> ath10k_ce_interrupt_summary(struct ath10k *ar)
>  {
>  	struct ath10k_ce *ce = ath10k_ce_priv(ar);
> 
> -	if (!ar->hw_params.per_ce_irq)
> -		return
> CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_GET(
> -			ce->bus_ops->read32((ar),
> CE_WRAPPER_BASE_ADDRESS +
> -			CE_WRAPPER_INTERRUPT_SUMMARY_ADDRESS));
> -	else
> -		return ath10k_ce_gen_interrupt_summary(ar);
> +	return CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_GET(
> +		ce->bus_ops->read32((ar), CE_WRAPPER_BASE_ADDRESS +
> +		CE_WRAPPER_INTERRUPT_SUMMARY_ADDRESS));
>  }
> 
>  /* Host software's Copy Engine configuration. */
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c
> b/drivers/net/wireless/ath/ath10k/snoc.c
> index 354d49b1cd45..2fc4dcbab70a 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -3,6 +3,7 @@
>   * Copyright (c) 2018 The Linux Foundation. All rights reserved.
>   */
> 
> +#include <linux/bits.h>
>  #include <linux/clk.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -1158,7 +1159,9 @@ static irqreturn_t
> ath10k_snoc_per_engine_handler(int irq, void *arg)
>  		return IRQ_HANDLED;
>  	}
> 
> -	ath10k_snoc_irq_disable(ar);
> +	ath10k_ce_disable_interrupt(ar, ce_id);
> +	set_bit(ce_id, ar_snoc->pending_ce_irqs);
> +
>  	napi_schedule(&ar->napi);
> 
>  	return IRQ_HANDLED;
> @@ -1167,20 +1170,25 @@ static irqreturn_t
> ath10k_snoc_per_engine_handler(int irq, void *arg)
>  static int ath10k_snoc_napi_poll(struct napi_struct *ctx, int budget)
>  {
>  	struct ath10k *ar = container_of(ctx, struct ath10k, napi);
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
>  	int done = 0;
> +	int ce_id;
> 
>  	if (test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags)) {
>  		napi_complete(ctx);
>  		return done;
>  	}
> 
> -	ath10k_ce_per_engine_service_any(ar);
> +	for (ce_id = 0; ce_id < CE_COUNT; ce_id++)
> +		if (test_and_clear_bit(ce_id, ar_snoc->pending_ce_irqs)) {
> +			ath10k_ce_per_engine_service(ar, ce_id);
> +			ath10k_ce_enable_interrupt(ar, ce_id);
> +		}
> +
>  	done = ath10k_htt_txrx_compl_task(ar, budget);
> 
> -	if (done < budget) {
> +	if (done < budget)
>  		napi_complete(ctx);
> -		ath10k_snoc_irq_enable(ar);
> -	}
> 
>  	return done;
>  }
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.h
> b/drivers/net/wireless/ath/ath10k/snoc.h
> index a3dd06f6ac62..5095d1893681 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.h
> +++ b/drivers/net/wireless/ath/ath10k/snoc.h
> @@ -78,6 +78,7 @@ struct ath10k_snoc {
>  	unsigned long flags;
>  	bool xo_cal_supported;
>  	u32 xo_cal_data;
> +	DECLARE_BITMAP(pending_ce_irqs, CE_COUNT_MAX);
>  };
> 
>  static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
> --
> 2.27.0.383.g050319c2ae-goog


