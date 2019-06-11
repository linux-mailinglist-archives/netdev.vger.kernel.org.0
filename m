Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C983C4CA
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404254AbfFKHTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:19:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:42890 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404113AbfFKHTR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 03:19:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jun 2019 00:19:16 -0700
X-ExtLoop1: 1
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by orsmga007.jf.intel.com with ESMTP; 11 Jun 2019 00:19:11 -0700
Subject: Re: [PATCH v3 3/5] brcmfmac: sdio: Disable auto-tuning around
 commands expected to fail
To:     Doug Anderson <dianders@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        Double Lo <double.lo@cypress.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        "mka@chromium.org" <mka@chromium.org>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20190607223716.119277-1-dianders@chromium.org>
 <20190607223716.119277-4-dianders@chromium.org>
 <363DA0ED52042842948283D2FC38E4649C52F8A0@IRSMSX106.ger.corp.intel.com>
 <CAD=FV=U8eo78Ee9xjhGXJMv=8YF9o89KLX024GH3iBRnRjCRvQ@mail.gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <ccdc4c80-2fcf-6938-c68e-dc2b21a57d92@intel.com>
Date:   Tue, 11 Jun 2019 10:17:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAD=FV=U8eo78Ee9xjhGXJMv=8YF9o89KLX024GH3iBRnRjCRvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/06/19 7:50 PM, Doug Anderson wrote:
> Hi,
> 
> On Mon, Jun 10, 2019 at 1:56 AM Hunter, Adrian <adrian.hunter@intel.com> wrote:
>>
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>> @@ -16,6 +16,7 @@
>>>  #include <linux/mmc/sdio_ids.h>
>>>  #include <linux/mmc/sdio_func.h>
>>>  #include <linux/mmc/card.h>
>>> +#include <linux/mmc/core.h>
>>
>> SDIO function drivers should not really include linux/mmc/core.h
>> (Also don't know why linux/mmc/card.h is included)
> 
> OK, so I guess you're requesting an extra level of "sdio_" wrappers
> for all the functions I need to call.  I don't think the wrappers buy
> us a ton other than to abstract things a little bit and make it look
> prettier.  :-)  ...but certainly I can code that up if that's what
> everyone wants.

I guess it is really up to Ulf.

> 
> Just to make sure, I looked in "drivers/net/wireless/" and I do see
> quite a few instances of "mmc_" functions being used.  That doesn't
> mean all these instances are correct but it does appear to be
> commonplace.  Selected examples:
> 
> drivers/net/wireless/ath/ath10k/sdio.c:
>   ret = mmc_hw_reset(ar_sdio->func->card->host);
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:
>   mmc_set_data_timeout(md, func->card);
>   mmc_wait_for_req(func->card->host, mr);
> 
> drivers/net/wireless/marvell/mwifiex/sdio.c:
>   mmc_hw_reset(func->card->host);
> 
> drivers/net/wireless/rsi/rsi_91x_sdio.c:
>   err = mmc_wait_for_cmd(host, &cmd, 3);
> 
> 
> ...anyway, I'll give it a few days and if nobody else chimes in then
> I'll assume you indeed want "sdio_" wrappers for things and I'll post
> a v4.  If patch #1 happens to land in the meantime then I won't
> object.  ;-)
> 
> 
> -Doug
> 

