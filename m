Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3FFB47D20
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfFQIb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:31:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:62728 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbfFQIb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 04:31:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 01:31:57 -0700
X-ExtLoop1: 1
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2019 01:31:52 -0700
Subject: Re: [PATCH v4 2/5] mmc: core: API to temporarily disable retuning for
 SDIO CRC errors
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
        Jiong Wu <lohengrin1024@gmail.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Allison Randal <allison@lohutok.net>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Avri Altman <avri.altman@wdc.com>
References: <20190613234153.59309-1-dianders@chromium.org>
 <20190613234153.59309-3-dianders@chromium.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <480eddd9-4094-c99f-751c-9bda8b672c11@intel.com>
Date:   Mon, 17 Jun 2019 11:30:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613234153.59309-3-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/19 2:41 AM, Douglas Anderson wrote:
> Normally when the MMC core sees an "-EILSEQ" error returned by a host
> controller then it will trigger a retuning of the card.  This is
> generally a good idea.
> 
> However, if a command is expected to sometimes cause transfer errors
> then these transfer errors shouldn't cause a re-tuning.  This
> re-tuning will be a needless waste of time.  One example case where a
> transfer is expected to cause errors is when transitioning between
> idle (sometimes referred to as "sleep" in Broadcom code) and active
> state on certain Broadcom WiFi SDIO cards.  Specifically if the card
> was already transitioning between states when the command was sent it
> could cause an error on the SDIO bus.
> 
> Let's add an API that the SDIO function drivers can call that will
> temporarily disable the auto-tuning functionality.  Then we can add a
> call to this in the Broadcom WiFi driver and any other driver that
> might have similar needs.
> 
> NOTE: this makes the assumption that the card is already tuned well
> enough that it's OK to disable the auto-retuning during one of these
> error-prone situations.  Presumably the driver code performing the
> error-prone transfer knows how to recover / retry from errors.  ...and
> after we can get back to a state where transfers are no longer
> error-prone then we can enable the auto-retuning again.  If we truly
> find ourselves in a case where the card needs to be retuned sometimes
> to handle one of these error-prone transfers then we can always try a
> few transfers first without auto-retuning and then re-try with
> auto-retuning if the first few fail.
> 
> Without this change on rk3288-veyron-minnie I periodically see this in
> the logs of a machine just sitting there idle:
>   dwmmc_rockchip ff0d0000.dwmmc: Successfully tuned phase to XYZ
> 
> Fixes: bd11e8bd03ca ("mmc: core: Flag re-tuning is needed on CRC errors")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

Not withstanding Ulf's comments:

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> 
> Changes in v4:
> - Moved to SDIO API only (Adrian, Ulf).
> - Renamed to make it less generic, now retune_crc_disable (Ulf).
> - Function header makes it clear host must be claimed (Ulf).
> - No more WARN_ON (Ulf).
> 
> Changes in v3:
> - Took out the spinlock since I believe this is all in one context.
> 
> Changes in v2:
> - Updated commit message to clarify based on discussion of v1.
> 
>  drivers/mmc/core/core.c       |  5 +++--
>  drivers/mmc/core/sdio_io.c    | 36 +++++++++++++++++++++++++++++++++++
>  include/linux/mmc/core.h      |  2 ++
>  include/linux/mmc/host.h      |  1 +
>  include/linux/mmc/sdio_func.h |  3 +++
>  5 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 6db36dc870b5..9020cb2490f7 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -144,8 +144,9 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
>  	int err = cmd->error;
>  
>  	/* Flag re-tuning needed on CRC errors */
> -	if ((cmd->opcode != MMC_SEND_TUNING_BLOCK &&
> -	    cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200) &&
> +	if (cmd->opcode != MMC_SEND_TUNING_BLOCK &&
> +	    cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200 &&
> +	    !host->retune_crc_disable &&
>  	    (err == -EILSEQ || (mrq->sbc && mrq->sbc->error == -EILSEQ) ||
>  	    (mrq->data && mrq->data->error == -EILSEQ) ||
>  	    (mrq->stop && mrq->stop->error == -EILSEQ)))
> diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
> index f79f0b0caab8..f822a9630b0e 100644
> --- a/drivers/mmc/core/sdio_io.c
> +++ b/drivers/mmc/core/sdio_io.c
> @@ -734,3 +734,39 @@ int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags)
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(sdio_set_host_pm_flags);
> +
> +/**
> + *	sdio_retune_crc_disable - temporarily disable retuning on CRC errors
> + *	@func: SDIO function attached to host
> + *
> + *	If the SDIO card is known to be in a state where it might produce
> + *	CRC errors on the bus in response to commands (like if we know it is
> + *	transitioning between power states), an SDIO function driver can
> + *	call this function to temporarily disable the SD/MMC core behavior of
> + *	triggering an automatic retuning.
> + *
> + *	This function should be called while the host is claimed and the host
> + *	should remain claimed until sdio_retune_crc_enable() is called.
> + *	Specifically, the expected sequence of calls is:
> + *	- sdio_claim_host()
> + *	- sdio_retune_crc_disable()
> + *	- some number of calls like sdio_writeb() and sdio_readb()
> + *	- sdio_release_host()
> + */
> +void sdio_retune_crc_disable(struct sdio_func *func)
> +{
> +	func->card->host->retune_crc_disable = true;
> +}
> +EXPORT_SYMBOL_GPL(sdio_retune_crc_disable);
> +
> +/**
> + *	sdio_retune_crc_enable - reneable retuning on CRC errors
> + *	@func: SDIO function attached to host
> + *
> + *	This is the compement to sdio_retune_crc_disable().
> + */
> +void sdio_retune_crc_enable(struct sdio_func *func)
> +{
> +	func->card->host->retune_crc_disable = false;
> +}
> +EXPORT_SYMBOL_GPL(sdio_retune_crc_enable);
> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> index 134a6483347a..02a13abf0cda 100644
> --- a/include/linux/mmc/core.h
> +++ b/include/linux/mmc/core.h
> @@ -178,6 +178,8 @@ int mmc_wait_for_cmd(struct mmc_host *host, struct mmc_command *cmd,
>  
>  int mmc_hw_reset(struct mmc_host *host);
>  int mmc_sw_reset(struct mmc_host *host);
> +void mmc_expect_errors_begin(struct mmc_host *host);
> +void mmc_expect_errors_end(struct mmc_host *host);
>  void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card);
>  
>  #endif /* LINUX_MMC_CORE_H */
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 43d0f0c496f6..ecb7972e2423 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -398,6 +398,7 @@ struct mmc_host {
>  	unsigned int		retune_now:1;	/* do re-tuning at next req */
>  	unsigned int		retune_paused:1; /* re-tuning is temporarily disabled */
>  	unsigned int		use_blk_mq:1;	/* use blk-mq */
> +	unsigned int		retune_crc_disable:1; /* don't trigger retune upon crc */
>  
>  	int			rescan_disable;	/* disable card detection */
>  	int			rescan_entered;	/* used with nonremovable devices */
> diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
> index e9dfdd501cd1..4820e6d09dac 100644
> --- a/include/linux/mmc/sdio_func.h
> +++ b/include/linux/mmc/sdio_func.h
> @@ -167,4 +167,7 @@ extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
>  extern mmc_pm_flag_t sdio_get_host_pm_caps(struct sdio_func *func);
>  extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
>  
> +extern void sdio_retune_crc_disable(struct sdio_func *func);
> +extern void sdio_retune_crc_enable(struct sdio_func *func);
> +
>  #endif /* LINUX_MMC_SDIO_FUNC_H */
> 

