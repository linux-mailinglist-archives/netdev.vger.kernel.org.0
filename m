Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF56E48C31
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfFQSj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:39:27 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:37875 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfFQSj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:39:27 -0400
Received: by mail-vs1-f66.google.com with SMTP id v6so6839008vsq.4
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HrHPxKrferT1JAd/MlzxZwSuGBA6gb0ENjpbrrRdk7w=;
        b=SV7VogTP85EMqFS3Mzv6FQo/JuabZthZ0z2+w+f7x6cgdpjYwsindOdSBj6DYL7muZ
         Ga32lSPxZzQMNTqIEKijrS3U0njBt8U1FGuYY4Bn4rgrKgquOm2fNDP7UUQXEBYolnJI
         tn7JP7FeZbZ7RVkn3KRu0VDYevg8MpiDclJsfbC/y/ZrEIOggA73s9uvPuFHFS8yA2CC
         heFrSIiAspsjbKU9EDZhdgXpre73gO+mIjJxiUOamg5k40ct/femc0WlL7O6TSLb3A4G
         NRNKGp3iBcehgOVQvRCRA+xB8ZQD3fwNi1wkLzgmuBNRk4xNZhqIfi/sgaDYqDvi0YmT
         6ceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HrHPxKrferT1JAd/MlzxZwSuGBA6gb0ENjpbrrRdk7w=;
        b=e3TDnMi3DpVBdsAb7CFSgFyyYqHC9XM5juI1EaqYGQxlQyZO8BUXdRpkf5TbVVm089
         rrEItkPEHO8CUKfDYAf4jtJ8yy5Qw/1M4WxF2icMhsHZKIvcZ6Mml/JkPSkUp/GSayo3
         lfq+2PksTWjh/GGV77iUqB3cno1ft3VkfPuA5F8yXqJwYGUdGVFa5WJXZyHAI9mNgwWX
         c8ArTtCxSSf74x2auRq8mwUaVX36+jLIXzHIUZ8S4ZduzZ/YL3cA359MTa+Yj/qhd3TV
         kMRkpdQvrx3GTM2XS9aJ2Mtc5+K/mEdRlA3ICP85n+8TZzcQArhaZ5aDkAR+ZVU3wiaM
         lE8w==
X-Gm-Message-State: APjAAAXY20rwCMwsrE1rbUh431Qs+kmZHgYBbprCtIdePbEpl6ER3Odi
        01x/8hO4Dzu9QfKfaZEqS/DZZaNqbkmkdP+rsogfvA==
X-Google-Smtp-Source: APXvYqy0hy2tVDS6IPNJlT9E1K+7AzXLT3TMlyyG420beOQJMtebGkOnRtHj86zAn/Yfs7K2PHcRzwGpAQjwvWrfiXQ=
X-Received: by 2002:a67:ee5b:: with SMTP id g27mr1171014vsp.165.1560796765659;
 Mon, 17 Jun 2019 11:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190617175653.21756-1-dianders@chromium.org>
In-Reply-To: <20190617175653.21756-1-dianders@chromium.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 17 Jun 2019 20:38:49 +0200
Message-ID: <CAPDyKFpaX6DSM_BjtghAHUf7qYCyEG+wMagXPUdgz3Eutovqfw@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] brcmfmac: sdio: Deal better w/ transmission errors
 related to idle
To:     Douglas Anderson <dianders@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
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
        YueHaibing <yuehaibing@huawei.com>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Ondrej Jirman <megous@megous.com>,
        Jiong Wu <lohengrin1024@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019 at 19:57, Douglas Anderson <dianders@chromium.org> wrote:
>
> This series attempts to deal better with the expected transmission
> errors related to the idle states (handled by the Always-On-Subsystem
> or AOS) on the SDIO-based WiFi on rk3288-veyron-minnie,
> rk3288-veyron-speedy, and rk3288-veyron-mickey.
>
> Some details about those errors can be found in
> <https://crbug.com/960222>, but to summarize it here: if we try to
> send the wakeup command to the WiFi card at the same time it has
> decided to wake up itself then it will behave badly on the SDIO bus.
> This can cause timeouts or CRC errors.
>
> When I tested on 4.19 and 4.20 these CRC errors can be seen to cause
> re-tuning.  Since I am currently developing on 4.19 this was the
> original problem I attempted to solve.
>
> On mainline it turns out that you don't see the retuning errors but
> you see tons of spam about timeouts trying to wakeup from sleep.  I
> tracked down the commit that was causing that and have partially
> reverted it here.  I have no real knowledge about Broadcom WiFi, but
> the commit that was causing problems sounds (from the descriptioin) to
> be a hack commit penalizing all Broadcom WiFi users because of a bug
> in a Cypress SD controller.  I will let others comment if this is
> truly the case and, if so, what the right solution should be.
>
> For v3 of this series I have added 2 patches to the end of the series
> to address errors that would show up on systems with these same SDIO
> WiFi cards when used on controllers that do periodic retuning.  These
> systems need an extra fix to prevent the retuning from happening when
> the card is asleep.
>
> I believe v5 of this series is all ready to go assuming Kalle Valo is
> good with it.  I've added after-the-cut notes to patches awaiting his
> Ack and have added other tags collected so far.
>
> Changes in v5:
> - Add missing sdio_retune_crc_enable() in comments (Ulf).
> - /s/reneable/re-enable (Ulf).
> - Remove leftover prototypes: mmc_expect_errors_begin() / end() (Ulf).
> - Rewording of "sleep command" in commit message (Arend).
>
> Changes in v4:
> - Moved to SDIO API only (Adrian, Ulf).
> - Renamed to make it less generic, now retune_crc_disable (Ulf).
> - Function header makes it clear host must be claimed (Ulf).
> - No more WARN_ON (Ulf).
> - Adjust to API rename (Adrian, Ulf).
> - Moved retune hold/release to SDIO API (Adrian).
> - Adjust to API rename (Adrian).
>
> Changes in v3:
> - Took out the spinlock since I believe this is all in one context.
> - Expect errors for all of brcmf_sdio_kso_control() (Adrian).
> - ("mmc: core: Export mmc_retune_hold_now() mmc_retune_release()") new for v3.
> - ("brcmfmac: sdio: Don't tune while the card is off") new for v3.
>
> Changes in v2:
> - A full revert, not just a partial one (Arend).  ...with explicit Cc.
> - Updated commit message to clarify based on discussion of v1.
>
> Douglas Anderson (5):
>   Revert "brcmfmac: disable command decode in sdio_aos"
>   mmc: core: API to temporarily disable retuning for SDIO CRC errors
>   brcmfmac: sdio: Disable auto-tuning around commands expected to fail
>   mmc: core: Add sdio_retune_hold_now() and sdio_retune_release()
>   brcmfmac: sdio: Don't tune while the card is off
>
>  drivers/mmc/core/core.c                       |  5 +-
>  drivers/mmc/core/sdio_io.c                    | 77 +++++++++++++++++++
>  .../broadcom/brcm80211/brcmfmac/sdio.c        | 17 ++--
>  include/linux/mmc/host.h                      |  1 +
>  include/linux/mmc/sdio_func.h                 |  6 ++
>  5 files changed, 99 insertions(+), 7 deletions(-)
>
> --
> 2.22.0.410.gd8fdbe21b5-goog
>

Applied for fixes, thanks!

Some minor changes:
1) Dropped the a few "commit notes", that was more related to version
and practical information about the series.
2) Dropped fixes tags for patch 2->5, but instead put a stable tag
targeted for v4.18+.

Awaiting an ack from Kalle before sending the PR to Linus.

Kalle, perhaps you prefer to pick patch 1, as it could go separate.
Then please tell - and/or if there is anything else you want me to
change.

Kind regards
Uffe
