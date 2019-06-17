Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F72047D37
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfFQIff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:35:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:30939 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfFQIfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 04:35:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 01:35:33 -0700
X-ExtLoop1: 1
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2019 01:35:29 -0700
Subject: Re: [PATCH v4 4/5] mmc: core: Add sdio_retune_hold_now() and
 sdio_retune_release()
To:     Douglas Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        linux-wireless@vger.kernel.org,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev@vger.kernel.org, brcm80211-dev-list@cypress.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Avri Altman <avri.altman@wdc.com>
References: <20190613234153.59309-1-dianders@chromium.org>
 <20190613234153.59309-5-dianders@chromium.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <d46161e8-cf2b-0aa0-1445-2d92580bf1a6@intel.com>
Date:   Mon, 17 Jun 2019 11:34:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613234153.59309-5-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/19 2:41 AM, Douglas Anderson wrote:
> We want SDIO drivers to be able to temporarily stop retuning when the
> driver knows that the SDIO card is not in a state where retuning will
> work (maybe because the card is asleep).  We'll move the relevant
> functions to a place where drivers can call them.
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> 
> Changes in v4:
> - Moved retune hold/release to SDIO API (Adrian).
> 
> Changes in v3:
> - ("mmc: core: Export mmc_retune_hold_now() mmc_retune_release()") new for v3.
> 
> Changes in v2: None
> 
>  drivers/mmc/core/sdio_io.c    | 40 +++++++++++++++++++++++++++++++++++
>  include/linux/mmc/sdio_func.h |  3 +++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
> index f822a9630b0e..1b6fe737bd72 100644
> --- a/drivers/mmc/core/sdio_io.c
> +++ b/drivers/mmc/core/sdio_io.c
> @@ -15,6 +15,7 @@
>  #include "sdio_ops.h"
>  #include "core.h"
>  #include "card.h"
> +#include "host.h"
>  
>  /**
>   *	sdio_claim_host - exclusively claim a bus for a certain SDIO function
> @@ -770,3 +771,42 @@ void sdio_retune_crc_enable(struct sdio_func *func)
>  	func->card->host->retune_crc_disable = false;
>  }
>  EXPORT_SYMBOL_GPL(sdio_retune_crc_enable);
> +
> +/**
> + *	sdio_retune_hold_now - start deferring retuning requests till release
> + *	@func: SDIO function attached to host
> + *
> + *	This function can be called if it's currently a bad time to do
> + *	a retune of the SDIO card.  Retune requests made during this time
> + *	will be held and we'll actually do the retune sometime after the
> + *	release.
> + *
> + *	This function could be useful if an SDIO card is in a power state
> + *	where it can respond to a small subset of commands that doesn't
> + *	include the retuning command.  Care should be taken when using
> + *	this function since (presumably) the retuning request we might be
> + *	deferring was made for a good reason.
> + *
> + *	This function should be called while the host is claimed.
> + */
> +void sdio_retune_hold_now(struct sdio_func *func)
> +{
> +	mmc_retune_hold_now(func->card->host);
> +}
> +EXPORT_SYMBOL_GPL(sdio_retune_hold_now);
> +
> +/**
> + *	sdio_retune_release - signal that it's OK to retune now
> + *	@func: SDIO function attached to host
> + *
> + *	This is the complement to sdio_retune_hold_now().  Calling this
> + *	function won't make a retune happen right away but will allow
> + *	them to be scheduled normally.
> + *
> + *	This function should be called while the host is claimed.
> + */
> +void sdio_retune_release(struct sdio_func *func)
> +{
> +	mmc_retune_release(func->card->host);
> +}
> +EXPORT_SYMBOL_GPL(sdio_retune_release);
> diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
> index 4820e6d09dac..5a177f7a83c3 100644
> --- a/include/linux/mmc/sdio_func.h
> +++ b/include/linux/mmc/sdio_func.h
> @@ -170,4 +170,7 @@ extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
>  extern void sdio_retune_crc_disable(struct sdio_func *func);
>  extern void sdio_retune_crc_enable(struct sdio_func *func);
>  
> +extern void sdio_retune_hold_now(struct sdio_func *func);
> +extern void sdio_retune_release(struct sdio_func *func);
> +
>  #endif /* LINUX_MMC_SDIO_FUNC_H */
> 

