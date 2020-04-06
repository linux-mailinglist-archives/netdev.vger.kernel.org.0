Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEFE419F625
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgDFMxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:53:24 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:29246 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728151AbgDFMxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:53:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586177603; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=SkosyJUm7vVYnO35iFNm2T5LbebuBXAANUFwoGPZCAg=; b=OCgguHSttnUKqA3tkxe3r1NNfBHvPixJLYVgMtnVVbkaFqu4uvAI/EIZ3d6apflvLw+RdUN9
 eE3pCgIJiLcTvpllZrQJBaxbCLZSEXHOSOaIdAIF7sHwKZzKJk+Mc/aUlezV3Ky7RPGql0fF
 Ig2JUofKch8OHWVdl2oowA4+CLc=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8b2632.7f509e960f10-smtp-out-n02;
 Mon, 06 Apr 2020 12:53:06 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E0CEDC4478C; Mon,  6 Apr 2020 12:53:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F1C66C433F2;
        Mon,  6 Apr 2020 12:53:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F1C66C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Sumit Garg <sumit.garg@linaro.org>, linux-wireless@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthias.schoepfer@ithinx.io,
        Philipp.Berg@liebherr.com, Michael.Weitner@liebherr.com,
        daniel.thompson@linaro.org, loic.poulain@linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
        <87ftdgokao.fsf@tynnyri.adurom.net>
        <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
Date:   Mon, 06 Apr 2020 15:52:59 +0300
In-Reply-To: <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
        (Johannes Berg's message of "Mon, 06 Apr 2020 14:47:43 +0200")
Message-ID: <87r1x0zsgk.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2020-04-06 at 15:44 +0300, Kalle Valo wrote:
>> 
>> >     user-space  ieee80211_register_hw()  RX IRQ
>> >     +++++++++++++++++++++++++++++++++++++++++++++
>> >        |                    |             |
>> >        |<---wlan0---wiphy_register()      |
>> >        |----start wlan0---->|             |
>> >        |                    |<---IRQ---(RX packet)
>> >        |              Kernel crash        |
>> >        |              due to unallocated  |
>> >        |              workqueue.          |
>
> [snip]
>
>> I have understood that no frames should be received until mac80211 calls
>> struct ieee80211_ops::start:
>> 
>>  * @start: Called before the first netdevice attached to the hardware
>>  *         is enabled. This should turn on the hardware and must turn on
>>  *         frame reception (for possibly enabled monitor interfaces.)
>
> True, but I think he's saying that you can actually add and configure an
> interface as soon as the wiphy is registered?

With '<---IRQ---(RX packet)' I assumed wcn36xx is delivering a frame to
mac80211 using ieee80211_rx(), but of course I'm just guessing here.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
