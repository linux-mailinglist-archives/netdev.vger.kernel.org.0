Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF0A47D30
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfFQIeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:34:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:45021 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfFQIeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 04:34:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 01:34:35 -0700
X-ExtLoop1: 1
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2019 01:34:31 -0700
Subject: Re: [PATCH v4 3/5] brcmfmac: sdio: Disable auto-tuning around
 commands expected to fail
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
        Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        linux-kernel@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20190613234153.59309-1-dianders@chromium.org>
 <20190613234153.59309-4-dianders@chromium.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <36770536-eb30-59ba-3f4e-b3640fc27408@intel.com>
Date:   Mon, 17 Jun 2019 11:33:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613234153.59309-4-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/19 2:41 AM, Douglas Anderson wrote:
> There are certain cases, notably when transitioning between sleep and
> active state, when Broadcom SDIO WiFi cards will produce errors on the
> SDIO bus.  This is evident from the source code where you can see that
> we try commands in a loop until we either get success or we've tried
> too many times.  The comment in the code reinforces this by saying
> "just one write attempt may fail"
> 
> Unfortunately these failures sometimes end up causing an "-EILSEQ"
> back to the core which triggers a retuning of the SDIO card and that
> blocks all traffic to the card until it's done.
> 
> Let's disable retuning around the commands we expect might fail.
> 
> Fixes: bd11e8bd03ca ("mmc: core: Flag re-tuning is needed on CRC errors")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> 
> Changes in v4:
> - Adjust to API rename (Adrian, Ulf).
> 
> Changes in v3:
> - Expect errors for all of brcmf_sdio_kso_control() (Adrian).
> 
> Changes in v2: None
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 4a750838d8cd..ee76593259a7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -667,6 +667,8 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
>  
>  	brcmf_dbg(TRACE, "Enter: on=%d\n", on);
>  
> +	sdio_retune_crc_disable(bus->sdiodev->func1);
> +
>  	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
>  	/* 1st KSO write goes to AOS wake up core if device is asleep  */
>  	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
> @@ -727,6 +729,8 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
>  	if (try_cnt > MAX_KSO_ATTEMPTS)
>  		brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
>  
> +	sdio_retune_crc_enable(bus->sdiodev->func1);
> +
>  	return err;
>  }
>  
> 

