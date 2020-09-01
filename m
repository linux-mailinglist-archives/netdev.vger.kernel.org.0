Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D83258E2D
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 14:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgIAM0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 08:26:08 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:31902 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728115AbgIAMZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 08:25:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598963140; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=6ggmUpFUZi20zjrVfQ8keaKSiZwjYpcqjxlqq5XSN3A=; b=YazBvhUdnd22duS3BcmG6ff8Nn8iyQN+v4irijQPPsooN2sCo9yp+KKZyxVSoTA1PBti3Wvb
 0HG4K3eUUu7b8c7Ocb4grNFOqQWsi/2caQXRAI+0yiCmuUV8omlf7p63Akgg9WA5Zc8SPAjy
 u3hO8SP8PHrg83SbbhJdFoEGnv0=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f4e3b2e54e87432bef9dea2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 12:14:38
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C4F71C433A0; Tue,  1 Sep 2020 12:14:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 01D67C433C6;
        Tue,  1 Sep 2020 12:14:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 01D67C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Abhishek Kumar <kuabhs@google.com>
Subject: Re: [PATCH v2 1/2] ath10k: Keep track of which interrupts fired, don't poll them
References: <20200709082024.v2.1.I4d2f85ffa06f38532631e864a3125691ef5ffe06@changeid>
        <20200826145011.C4E48C43387@smtp.codeaurora.org>
        <CAD=FV=Uu4dnzeTB+DfecO5uZSJWjq4qbi4=Uwgy-QwPphLApBw@mail.gmail.com>
Date:   Tue, 01 Sep 2020 15:14:31 +0300
In-Reply-To: <CAD=FV=Uu4dnzeTB+DfecO5uZSJWjq4qbi4=Uwgy-QwPphLApBw@mail.gmail.com>
        (Doug Anderson's message of "Wed, 26 Aug 2020 07:59:52 -0700")
Message-ID: <87blip66e0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> On Wed, Aug 26, 2020 at 7:51 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Douglas Anderson <dianders@chromium.org> wrote:
>>
>> > If we have a per CE (Copy Engine) IRQ then we have no summary
>> > register.  Right now the code generates a summary register by
>> > iterating over all copy engines and seeing if they have an interrupt
>> > pending.
>> >
>> > This has a problem.  Specifically if _none_ if the Copy Engines have
>> > an interrupt pending then they might go into low power mode and
>> > reading from their address space will cause a full system crash.  This
>> > was seen to happen when two interrupts went off at nearly the same
>> > time.  Both were handled by a single call of ath10k_snoc_napi_poll()
>> > but, because there were two interrupts handled and thus two calls to
>> > napi_schedule() there was still a second call to
>> > ath10k_snoc_napi_poll() which ran with no interrupts pending.
>> >
>> > Instead of iterating over all the copy engines, let's just keep track
>> > of the IRQs that fire.  Then we can effectively generate our own
>> > summary without ever needing to read the Copy Engines.
>> >
>> > Tested-on: WCN3990 SNOC WLAN.HL.3.2.2-00490-QCAHLSWMTPL-1
>> >
>> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
>> > Reviewed-by: Rakesh Pillai <pillair@codeaurora.org>
>> > Reviewed-by: Brian Norris <briannorris@chromium.org>
>> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>
>> My main concern of this patch is that there's no info how it works on other
>> hardware families. For example, QCA9984 is very different from WCN3990. The
>> best would be if someone can provide a Tested-on tags for other hardware (even
>> some of them).
>
> I simply don't have access to any other Atheros hardware.  Hopefully
> others on this thread do, though?

I have the hardware but in practise no time to do the testing :/

> ...but, if nothing else, I believe code inspection shows that the only
> places that are affected by the changes here are:
>
> * Wifi devices that use "snoc.c".  The only compatible string listed
> in "snoc.c" is wcn3990.
>
> * Wifi devices that set "per_ce_irq" to true.  The only place in the
> table where this is set to true is wcn3990.
>
> While it is certainly possible that I messed up and somehow affected
> other WiFi devices, the common bits of code in "ce.c" and "ce.h" are
> fairly easy to validate so hopefully they look OK?

Basically I would like to see some evidence in the commit log that _all_
hardware families are taken into account to avoid any regressions, be it
testing or at least thorough review. I see way too many patches where
people are working just on one hardware/firmware combo and not giving a
single thought how it would work on other hardware.

But I applied the three patches now, let's hope they are ok. At least I
was not able to find any problems during review, but of course real
testing would be better than just review.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
