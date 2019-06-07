Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF1338A4F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 14:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbfFGM3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 08:29:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:39844 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728597AbfFGM3m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 08:29:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 05:29:41 -0700
X-ExtLoop1: 1
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2019 05:29:35 -0700
Subject: Re: [PATCH v2 3/3] brcmfmac: sdio: Disable auto-tuning around
 commands expected to fail
To:     Doug Anderson <dianders@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <2e9f80af-aa26-5590-9ff0-9889400068d6@intel.com>
Date:   Fri, 7 Jun 2019 15:28:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAD=FV=UPfCOr-syAbVZ-FjHQy7bgQf5BS5pdV-Bwd3hquRqEGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/06/19 12:37 AM, Doug Anderson wrote:
> Hi,
> 
> On Thu, Jun 6, 2019 at 7:00 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>
>> On 3/06/19 9:37 PM, Douglas Anderson wrote:
>>> There are certain cases, notably when transitioning between sleep and
>>> active state, when Broadcom SDIO WiFi cards will produce errors on the
>>> SDIO bus.  This is evident from the source code where you can see that
>>> we try commands in a loop until we either get success or we've tried
>>> too many times.  The comment in the code reinforces this by saying
>>> "just one write attempt may fail"
>>>
>>> Unfortunately these failures sometimes end up causing an "-EILSEQ"
>>> back to the core which triggers a retuning of the SDIO card and that
>>> blocks all traffic to the card until it's done.
>>>
>>> Let's disable retuning around the commands we expect might fail.
>>
>> It seems to me that re-tuning needs to be prevented before the
>> first access otherwise it might be attempted there,
> 
> By this I think you mean I wasn't starting my section early enough to
> catch the "1st KSO write".  Oops.  Thanks!
> 
> 
>> and it needs
>> to continue to be prevented during the transition when it might
>> reasonably be expected to fail.
>>
>> What about something along these lines:
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> index 4e15ea57d4f5..d932780ef56e 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> @@ -664,9 +664,18 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
>>         int err = 0;
>>         int err_cnt = 0;
>>         int try_cnt = 0;
>> +       int need_retune = 0;
>> +       bool retune_release = false;
>>
>>         brcmf_dbg(TRACE, "Enter: on=%d\n", on);
>>
>> +       /* Cannot re-tune if device is asleep */
>> +       if (on) {
>> +               need_retune = sdio_retune_get_needed(bus->sdiodev->func1); // TODO: host->can_retune ? host->need_retune : 0
>> +               sdio_retune_hold_now(bus->sdiodev->func1); // TODO: add sdio_retune_hold_now()
>> +               retune_release = true;
>> +       }
> 
> The code below still has retries even for the "!on" case.  That
> implies that you could still get CRC errors from the card in the "!on"
> direction too.  Any reason why we shouldn't just hold retuning even
> for the !on case?

No

> 
> 
>> +
>>         wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
>>         /* 1st KSO write goes to AOS wake up core if device is asleep  */
>>         brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
>> @@ -711,8 +720,16 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
>>                         err_cnt = 0;
>>                 }
>>                 /* bail out upon subsequent access errors */
>> -               if (err && (err_cnt++ > BRCMF_SDIO_MAX_ACCESS_ERRORS))
>> -                       break;
>> +               if (err && (err_cnt++ > BRCMF_SDIO_MAX_ACCESS_ERRORS)) {
>> +                       if (!retune_release)
>> +                               break;
>> +                       /*
>> +                        * Allow one more retry with re-tuning released in case
>> +                        * it helps.
>> +                        */
>> +                       sdio_retune_release(bus->sdiodev->func1);
>> +                       retune_release = false;
> 
> I would be tempted to wait before adding this logic until we actually
> see that it's needed.  Sure, doing one more transfer probably won't
> really hurt, but until we know that it actually helps it seems like
> we're just adding extra complexity?

Depends, what is the downside of unnecessarily returning an error from
brcmf_sdio_kso_control() in that case?

> 
> 
>> +               }
>>
>>                 udelay(KSO_WAIT_US);
>>                 brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val,
>> @@ -727,6 +744,18 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
>>         if (try_cnt > MAX_KSO_ATTEMPTS)
>>                 brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
>>
>> +       if (retune_release) {
>> +               /*
>> +                * CRC errors are not unexpected during the transition but they
>> +                * also trigger re-tuning. Clear that here to avoid an
>> +                * unnecessary re-tune if it wasn't already triggered to start
>> +                * with.
>> +                */
>> +               if (!need_retune)
>> +                       sdio_retune_clear_needed(bus->sdiodev->func1); // TODO: host->need_retune = 0
>> +               sdio_retune_release(bus->sdiodev->func1); // TODO: add sdio_retune_release()
>> +       }
> 
> Every time I re-look at this I have to re-figure out all the subtle
> differences between the variables and functions involved here.  Let me
> see if I got everything right:
> 
> * need_retune: set to 1 if we can retune and some event happened that
> makes us truly believe that we need to be retuned, like we got a CRC
> error or a timer expired or our host controller told us to retune.
> 
> * retune_now: set to 1 it's an OK time to be retuning.  Specifically
> if retune_now is false we won't send any retuning commands but we'll
> still keep track of the need to retune.
> 
> * hold_retune: If this gets set to 1 by mmc_retune_hold_now() then a
> future call to mmc_retune_hold() will _not_ schedule a retune by
> setting retune_now (because mmc_retune_hold() will see that
> hold_retune was already 1).  ...and a future call to
> mmc_retune_recheck() between mmc_hold() and mmc_release() will also
> not schedule a retune because hold_retune will be 2 (or generally >
> 1).
> 
> ---
> 
> So overall trying to summarize what I think are the differences
> between your patch and my patch.
> 
> 1. If we needed to re-tune _before_ calling brcmf_sdio_kso_control(),
> with your patch we'll make sure that we don't actually attempt to
> retune until brcmf_sdio_kso_control() finishes.
> 
> 2. If we needed to retune during brcmf_sdio_kso_control() (because a
> timer expired?) then we wouldn't trigger that retune while
> brcmf_sdio_kso_control() is running.
> 
> In the case of dw_mmc, which I'm most familiar with, we don't have any
> sort of automated or timed-based retuning.  ...so we'll only re-tune
> when we see the CRC error.  If I'm understanding things correctly then
> that for dw_mmc my solution and yours behave the same.  That means the
> difference is how we deal with other retuning requests, either ones
> that come about because of an interrupt that the host controller
> provided or because of a timer.  Did I get that right?
> 
> ...and I guess the reason we have to deal specially with these cases
> is because any time that SDIO card is "sleeping" we don't want to
> retune because it won't work.  Right?  NOTE: the solution that would
> come to my mind first to solve this would be to hold the retuning for
> the whole time that the card was sleeping and then release it once the
> card was awake again.  ...but I guess we don't truly need to do that
> because tuning only happens as a side effect of sending a command to
> the card and the only command we send to the card is the "wake up"
> command.  That's why your solution to hold tuning while sending the
> "wake up" command works, right?
> 
> ---
> 
> OK, so assuming all the above is correct, I feel like we're actually
> solving two problems and in fact I believe we actually need both our
> approaches to solve everything correctly.  With just your patch in
> place there's a problem because we will clobber any external retuning
> requests that happened while we were waking up the card.  AKA, imagine
> this:
> 
> A) brcmf_sdio_kso_control(on=True) gets called; need_retune starts as 0
> 
> B) We call sdio_retune_hold_now()
> 
> C) A retuning timer goes off or the SD Host controller tells us to retune
> 
> D) We get to the end of brcmf_sdio_kso_control() and clear the "retune
> needed" since need_retune was 0 at the start.
> 
> ...so we dropped the retuning request from C), right?

True

> 
> 
> What we truly need is:
> 
> 1. CRC errors shouldn't trigger a retuning request when we're in
> brcmf_sdio_kso_control()
> 
> 2. A separate patch that holds any retuning requests while the SDIO
> card is off.  This patch _shouldn't_ do any clearing of retuning
> requests, just defer them.
> 
> 
> Does that make sense to you?  If so, I can try to code it up...

Sounds good :-)
