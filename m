Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2451F9B17
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 16:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730847AbgFOO4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 10:56:35 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:15472 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730405AbgFOO4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 10:56:35 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1592232994; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=RTqnmaAhKbyyX5m1MHI2x1eM5OG8zLQJxTp6BIGwfIk=; b=ffNKK/c64j1GQNR54vNuyufjjpx7JOMxPH3L+B+wmGecBfIVxfatxXH3nf2rioJbrnpPcfdJ
 0dyYxHiQbKbi7YgZiFSkvUnI6471MQgE3BunsrkSglnSyGkHd+CLAtOaeihDRBrQwZNxYewJ
 +NPn5qd8hM+W8U5nF1HGnZvEeHE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5ee78c183a8a8b20b8539e93 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 15 Jun 2020 14:56:24
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E58F7C433C8; Mon, 15 Jun 2020 14:56:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB0F6C433CA;
        Mon, 15 Jun 2020 14:56:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EB0F6C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ath10k@lists.infradead.org,
        Rakesh Pillai <pillair@codeaurora.org>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kuabhs@google.com
Subject: Re: [PATCH] ath10k: Wait until copy complete is actually done before completing
References: <20200609082015.1.Ife398994e5a0a6830e4d4a16306ef36e0144e7ba@changeid>
        <20200615143237.519F3C433C8@smtp.codeaurora.org>
        <CAD=FV=VaexjLaaZJSxndTEi6KCFaPWW=sUt6hjy9=0Qn68kH1g@mail.gmail.com>
Date:   Mon, 15 Jun 2020 17:56:19 +0300
In-Reply-To: <CAD=FV=VaexjLaaZJSxndTEi6KCFaPWW=sUt6hjy9=0Qn68kH1g@mail.gmail.com>
        (Doug Anderson's message of "Mon, 15 Jun 2020 07:39:33 -0700")
Message-ID: <87zh94idik.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> On Mon, Jun 15, 2020 at 7:32 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Douglas Anderson <dianders@chromium.org> wrote:
>>
>> > On wcn3990 we have "per_ce_irq = true".  That makes the
>> > ath10k_ce_interrupt_summary() function always return 0xfff. The
>> > ath10k_ce_per_engine_service_any() function will see this and think
>> > that _all_ copy engines have an interrupt.  Without checking, the
>> > ath10k_ce_per_engine_service() assumes that if it's called that the
>> > "copy complete" (cc) interrupt fired.  This combination seems bad.
>> >
>> > Let's add a check to make sure that the "copy complete" interrupt
>> > actually fired in ath10k_ce_per_engine_service().
>> >
>> > This might fix a hard-to-reproduce failure where it appears that the
>> > copy complete handlers run before the copy is really complete.
>> > Specifically a symptom was that we were seeing this on a Qualcomm
>> > sc7180 board:
>> >   arm-smmu 15000000.iommu: Unhandled context fault:
>> >   fsr=0x402, iova=0x7fdd45780, fsynr=0x30003, cbfrsynra=0xc1, cb=10
>> >
>> > Even on platforms that don't have wcn3990 this still seems like it
>> > would be a sane thing to do.  Specifically the current IRQ handler
>> > comments indicate that there might be other misc interrupt sources
>> > firing that need to be cleared.  If one of those sources was the one
>> > that caused the IRQ handler to be called it would also be important to
>> > double-check that the interrupt we cared about actually fired.
>> >
>> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
>> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>
>> ath10k firmwares work very differently, on what hardware and firmware did you
>> test this? I'll add that information to the commit log.
>
> I am running on a Qualcomm sc7180 SoC.

Sorry, I was unclear, I meant the ath10k hardware :) I guess WCN3990 but
what firmware version?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
