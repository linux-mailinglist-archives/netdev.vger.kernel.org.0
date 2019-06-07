Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A145538A7C
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 14:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfFGMkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 08:40:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:12214 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbfFGMkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 08:40:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 05:40:03 -0700
X-ExtLoop1: 1
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2019 05:39:55 -0700
Subject: Re: [PATCH v2 3/3] brcmfmac: sdio: Disable auto-tuning around
 commands expected to fail
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Doug Anderson <dianders@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Double Lo <double.lo@cypress.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Franky Lin <franky.lin@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Michael Trimarchi <michael@amarulasolutions.com>
References: <20190603183740.239031-1-dianders@chromium.org>
 <20190603183740.239031-4-dianders@chromium.org>
 <42fc30b1-adab-7fa8-104c-cbb7855f2032@intel.com>
 <CAD=FV=UPfCOr-syAbVZ-FjHQy7bgQf5BS5pdV-Bwd3hquRqEGg@mail.gmail.com>
 <16b305a7110.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <ff0e7b7a-6a58-8bec-b182-944a8b64236d@intel.com>
Date:   Fri, 7 Jun 2019 15:38:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <16b305a7110.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/06/19 8:12 AM, Arend Van Spriel wrote:
> On June 6, 2019 11:37:22 PM Doug Anderson <dianders@chromium.org> wrote:
>>
>> In the case of dw_mmc, which I'm most familiar with, we don't have any
>> sort of automated or timed-based retuning.  ...so we'll only re-tune
>> when we see the CRC error.  If I'm understanding things correctly then
>> that for dw_mmc my solution and yours behave the same.  That means the
>> difference is how we deal with other retuning requests, either ones
>> that come about because of an interrupt that the host controller
>> provided or because of a timer.  Did I get that right?
> 
> Right.
> 
>> ...and I guess the reason we have to deal specially with these cases
>> is because any time that SDIO card is "sleeping" we don't want to
>> retune because it won't work.  Right?  NOTE: the solution that would
>> come to my mind first to solve this would be to hold the retuning for
>> the whole time that the card was sleeping and then release it once the
>> card was awake again.  ...but I guess we don't truly need to do that
>> because tuning only happens as a side effect of sending a command to
>> the card and the only command we send to the card is the "wake up"
>> command.  That's why your solution to hold tuning while sending the
>> "wake up" command works, right?
> 
> Yup.
> 
>> ---
>>
>> OK, so assuming all the above is correct, I feel like we're actually
>> solving two problems and in fact I believe we actually need both our
>> approaches to solve everything correctly.  With just your patch in
>> place there's a problem because we will clobber any external retuning
>> requests that happened while we were waking up the card.  AKA, imagine
>> this:
>>
>> A) brcmf_sdio_kso_control(on=True) gets called; need_retune starts as 0
>>
>> B) We call sdio_retune_hold_now()
>>
>> C) A retuning timer goes off or the SD Host controller tells us to retune
>>
>> D) We get to the end of brcmf_sdio_kso_control() and clear the "retune
>> needed" since need_retune was 0 at the start.
>>
>> ...so we dropped the retuning request from C), right?
>>
>>
>> What we truly need is:
>>
>> 1. CRC errors shouldn't trigger a retuning request when we're in
>> brcmf_sdio_kso_control()
>>
>> 2. A separate patch that holds any retuning requests while the SDIO
>> card is off.  This patch _shouldn't_ do any clearing of retuning
>> requests, just defer them.
>>
>>
>> Does that make sense to you?  If so, I can try to code it up...
> 
> FWIW it does make sense to me. However, I am still not sure if our sdio
> hardware supports retuning. Have to track down an asic designer who can tell
> or dive into vhdl myself.

The card supports re-tuning if is handles CMD19, which it does.  It is not
the card that does any tuning, only the host.  The card just helps by
providing a known data pattern in response to CMD19.  It can be that a card
provides good enough signals that the host should not need to re-tune.  I
don't know if that can be affected by the board design though.
