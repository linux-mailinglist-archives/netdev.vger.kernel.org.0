Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 050BB746A5
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 07:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfGYF4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 01:56:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfGYF4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 01:56:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4C67C6055D; Thu, 25 Jul 2019 05:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564034202;
        bh=obQivilrrq99bI/JADOtPPw40Tam6JqkCOlcQ4u07Pg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bMsF962d6/5hRs8CNVfvOuFh4McgKgeaYjwiNj3rwaaPtAP6v1KZ5KaO+5ayPT7X8
         Dk0u0GVbi2sdzFC5siDwnBU1Ll2HS92frYguPRwP1uvbB0SUBU8gLoQwBwEQ/gApbq
         43BEiRsKf6jOkmD6Y6EjXSwyN/8B3a+P3AvXqgpA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 80BD960213;
        Thu, 25 Jul 2019 05:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564034201;
        bh=obQivilrrq99bI/JADOtPPw40Tam6JqkCOlcQ4u07Pg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fk8JO0d1n7CFnbxsgD6H9t57uVvCqUoYRCA9TuaG0rfqi+Tvb2UVr3h4dHScgkhSY
         EQ6SzMH0UOjrdbwzJYMIgy6mDuQfDqre9tdHdaNcPknctiD6v44h7ISBXfHbXfxEoq
         tpwl1W30EdWY0/KUbJAxnaMqr9tlLD3iht+TUTO0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 80BD960213
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Andreas Fenkart <afenkart@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "open list\:ARM\/Rockchip SoC..." 
        <linux-rockchip@lists.infradead.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Xinming Hu <huxinming820@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] mwifiex: Make use of the new sdio_trigger_replug() API to reset
References: <20190722193939.125578-3-dianders@chromium.org>
        <20190724113508.47A356021C@smtp.codeaurora.org>
        <CAD=FV=WAsrBV9PzUz1qPzQru+AkOYZ5hsaWdhNYRTNqUfDeOmQ@mail.gmail.com>
Date:   Thu, 25 Jul 2019 08:56:35 +0300
In-Reply-To: <CAD=FV=WAsrBV9PzUz1qPzQru+AkOYZ5hsaWdhNYRTNqUfDeOmQ@mail.gmail.com>
        (Doug Anderson's message of "Wed, 24 Jul 2019 13:22:22 -0700")
Message-ID: <87imrqzmgc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> Hi,
>
> On Wed, Jul 24, 2019 at 4:35 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Douglas Anderson <dianders@chromium.org> wrote:
>>
>> > As described in the patch ("mmc: core: Add sdio_trigger_replug()
>> > API"), the current mwifiex_sdio_card_reset() is broken in the cases
>> > where we're running Bluetooth on a second SDIO func on the same card
>> > as WiFi.  The problem goes away if we just use the
>> > sdio_trigger_replug() API call.
>> >
>> > NOTE: Even though with this new solution there is less of a reason to
>> > do our work from a workqueue (the unplug / plug mechanism we're using
>> > is possible for a human to perform at any time so the stack is
>> > supposed to handle it without it needing to be called from a special
>> > context), we still need a workqueue because the Marvell reset function
>> > could called from a context where sleeping is invalid and thus we
>> > can't claim the host.  One example is Marvell's wakeup_timer_fn().
>> >
>> > Cc: Andreas Fenkart <afenkart@gmail.com>
>> > Cc: Brian Norris <briannorris@chromium.org>
>> > Fixes: b4336a282db8 ("mwifiex: sdio: reset adapter using mmc_hw_reset")
>> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
>> > Reviewed-by: Brian Norris <briannorris@chromium.org>
>>
>> I assume this is going via some other tree so I'm dropping this from my
>> queue. If I should apply this please resend once the dependency is in
>> wireless-drivers-next.
>>
>> Patch set to Not Applicable.
>
> Thanks.  For now I'll assume that Ulf will pick it up if/when he is
> happy with patch #1 in this series.  Would you be willing to provide
> your Ack on this patch to make it clear to Ulf you're OK with that?

Sure, I was planning to do that already in my previous email but forgot.

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
