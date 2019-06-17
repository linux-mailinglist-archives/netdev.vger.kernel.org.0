Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D84147D09
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfFQI3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:29:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:62593 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbfFQI3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 04:29:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 01:29:31 -0700
X-ExtLoop1: 1
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2019 01:29:27 -0700
Subject: Re: [PATCH v4 5/5] brcmfmac: sdio: Don't tune while the card is off
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
        Franky Lin <franky.lin@broadcom.com>,
        linux-kernel@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20190613234153.59309-1-dianders@chromium.org>
 <20190613234153.59309-6-dianders@chromium.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <dac34482-cf74-5db9-ec0f-124af0ace811@intel.com>
Date:   Mon, 17 Jun 2019 11:28:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613234153.59309-6-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/19 2:41 AM, Douglas Anderson wrote:
> When Broadcom SDIO cards are idled they go to sleep and a whole
> separate subsystem takes over their SDIO communication.  This is the
> Always-On-Subsystem (AOS) and it can't handle tuning requests.
> 
> Specifically, as tested on rk3288-veyron-minnie (which reports having
> BCM4354/1 in dmesg), if I force a retune in brcmf_sdio_kso_control()
> when "on = 1" (aka we're transition from sleep to wake) by whacking:
>   bus->sdiodev->func1->card->host->need_retune = 1
> ...then I can often see tuning fail.  In this case dw_mmc reports "All
> phases bad!").  Note that I don't get 100% failure, presumably because
> sometimes the card itself has already transitioned away from the AOS
> itself by the time we try to wake it up.  If I force retuning when "on
> = 0" (AKA force retuning right before sending the command to go to
> sleep) then retuning is always OK.
> 
> NOTE: we need _both_ this patch and the patch to avoid triggering
> tuning due to CRC errors in the sleep/wake transition, AKA ("brcmfmac:
> sdio: Disable auto-tuning around commands expected to fail").  Though
> both patches handle issues with Broadcom's AOS, the problems are
> distinct:
> 1. We want to defer (but not ignore) asynchronous (like
>    timer-requested) tuning requests till the card is awake.  However,
>    we want to ignore CRC errors during the transition, we don't want
>    to queue deferred tuning request.
> 2. You could imagine that the AOS could implement retuning but we
>    could still get errors while transitioning in and out of the AOS.
>    Similarly you could imagine a seamless transition into and out of
>    the AOS (with no CRC errors) even if the AOS couldn't handle
>    tuning.
> 
> ALSO NOTE: presumably there is never a desperate need to retune in
> order to wake up the card, since doing so is impossible.  Luckily the
> only way the card can get into sleep state is if we had a good enough
> tuning to send it a sleep command, so presumably that "good enough"
> tuning is enough to wake us up, at least with a few retries.
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> 
> Changes in v4:
> - Adjust to API rename (Adrian).
> 
> Changes in v3:
> - ("brcmfmac: sdio: Don't tune while the card is off") new for v3.
> 
> Changes in v2: None
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index ee76593259a7..629140b6d7e2 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -669,6 +669,10 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
>  
>  	sdio_retune_crc_disable(bus->sdiodev->func1);
>  
> +	/* Cannot re-tune if device is asleep; defer till we're awake */
> +	if (on)
> +		sdio_retune_hold_now(bus->sdiodev->func1);
> +
>  	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
>  	/* 1st KSO write goes to AOS wake up core if device is asleep  */
>  	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
> @@ -729,6 +733,9 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
>  	if (try_cnt > MAX_KSO_ATTEMPTS)
>  		brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
>  
> +	if (on)
> +		sdio_retune_release(bus->sdiodev->func1);
> +
>  	sdio_retune_crc_enable(bus->sdiodev->func1);
>  
>  	return err;
> 

