Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5CA19F660
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgDFNFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:05:10 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:59594 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728077AbgDFNFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:05:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586178309; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=TXoCw5GkV+IZIhQrsD2drq5aTCEc6Wa8f+KDKz8AGtc=; b=HAcrbhdOKb43hnRF/lGwe/x22ZsA5oDonzf8TuvnJXlIRHhPUmKLrsBhffUH3pCeBIchcVvf
 n5T7L37Kvo4KmIG1n2EOisSzRCfUavqEw4hPOBeqWPWxkL05qIS6dbeEIDPPJDD4w+li2nH1
 3sQYW8iovnx2rk3b8QJ5Dz1W+mg=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8b28ff.7f7f4c9a95e0-smtp-out-n01;
 Mon, 06 Apr 2020 13:05:03 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 64193C43637; Mon,  6 Apr 2020 13:05:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0849C433D2;
        Mon,  6 Apr 2020 13:04:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0849C433D2
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
        <87r1x0zsgk.fsf@kamboji.qca.qualcomm.com>
        <a7e3e8cceff1301f5de5fb2c9aac62b372922b3e.camel@sipsolutions.net>
Date:   Mon, 06 Apr 2020 16:04:57 +0300
In-Reply-To: <a7e3e8cceff1301f5de5fb2c9aac62b372922b3e.camel@sipsolutions.net>
        (Johannes Berg's message of "Mon, 06 Apr 2020 14:53:49 +0200")
Message-ID: <87imiczrwm.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2020-04-06 at 15:52 +0300, Kalle Valo wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> 
>> > On Mon, 2020-04-06 at 15:44 +0300, Kalle Valo wrote:
>> > > >     user-space  ieee80211_register_hw()  RX IRQ
>> > > >     +++++++++++++++++++++++++++++++++++++++++++++
>> > > >        |                    |             |
>> > > >        |<---wlan0---wiphy_register()      |
>> > > >        |----start wlan0---->|             |
>> > > >        |                    |<---IRQ---(RX packet)
>> > > >        |              Kernel crash        |
>> > > >        |              due to unallocated  |
>> > > >        |              workqueue.          |
>> > 
>> > [snip]
>> > 
>> > > I have understood that no frames should be received until mac80211 calls
>> > > struct ieee80211_ops::start:
>> > > 
>> > >  * @start: Called before the first netdevice attached to the hardware
>> > >  *         is enabled. This should turn on the hardware and must turn on
>> > >  *         frame reception (for possibly enabled monitor interfaces.)
>> > 
>> > True, but I think he's saying that you can actually add and configure an
>> > interface as soon as the wiphy is registered?
>> 
>> With '<---IRQ---(RX packet)' I assumed wcn36xx is delivering a frame to
>> mac80211 using ieee80211_rx(), but of course I'm just guessing here.
>
> Yeah, but that could be legitimate?

Ah, I misunderstood then. The way I have understood is that no rx frames
should be delivered (= calling ieee80211_rx()_ before start() is called,
but if that's not the case please ignore me :)

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
