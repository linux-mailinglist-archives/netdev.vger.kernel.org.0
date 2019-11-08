Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC60F4228
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 09:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbfKHIdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 03:33:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58306 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfKHIdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 03:33:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A21A360DE9; Fri,  8 Nov 2019 08:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573201980;
        bh=Li42Bwy0+M/BNejEX2gv6nmzcZsTnhWewqmxkM3PU/I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lJhJ3pbzgpR6MVInBNLaR4+Oew/lJpScGLOfz+fYn45tamW/Bg2PApcLKKNL5Ocex
         UfEfqRpaf0/wMYRy1iSN9BqsKTNN1i2eA2l8IEMfiOeEMumAOcupjZmHkCebR0mAps
         lnnqrE/5FclHb5DYmblpch4NYYS9+y2lKLfEXbJ0=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 728C160D85;
        Fri,  8 Nov 2019 08:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573201980;
        bh=Li42Bwy0+M/BNejEX2gv6nmzcZsTnhWewqmxkM3PU/I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lJhJ3pbzgpR6MVInBNLaR4+Oew/lJpScGLOfz+fYn45tamW/Bg2PApcLKKNL5Ocex
         UfEfqRpaf0/wMYRy1iSN9BqsKTNN1i2eA2l8IEMfiOeEMumAOcupjZmHkCebR0mAps
         lnnqrE/5FclHb5DYmblpch4NYYS9+y2lKLfEXbJ0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 728C160D85
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ikjoon Jang <ikjn@chromium.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ath10k: disable cpuidle during downloading firmware.
References: <20191101054035.42101-1-ikjn@chromium.org>
        <87y2ws3lvh.fsf@kamboji.qca.qualcomm.com>
        <CAATdQgDhYWgHkujo9m1iUrhSu1Bt9A4C8eS82TD=W22_eaF80g@mail.gmail.com>
Date:   Fri, 08 Nov 2019 10:32:56 +0200
In-Reply-To: <CAATdQgDhYWgHkujo9m1iUrhSu1Bt9A4C8eS82TD=W22_eaF80g@mail.gmail.com>
        (Ikjoon Jang's message of "Thu, 7 Nov 2019 12:16:45 +0800")
Message-ID: <877e4aydhj.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ikjoon Jang <ikjn@chromium.org> writes:

> On Thu, Nov 7, 2019 at 2:23 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Ikjoon Jang <ikjn@chromium.org> writes:
>>
>> > Downloading ath10k firmware needs a large number of IOs and
>> > cpuidle's miss predictions make it worse. In the worst case,
>> > resume time can be three times longer than the average on sdio.
>> >
>> > This patch disables cpuidle during firmware downloading by
>> > applying PM_QOS_CPU_DMA_LATENCY in ath10k_download_fw().
>> >
>> > Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
>>
>> On what hardware and firmware versions did you test this? I'll add that
>> to the commit log.
>>
>> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches#guidelines
>
> Thank you for sharing it.
> It's QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00029
> on ARMv8 multi cluster platform.

Thanks, I added that to the commit log.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
