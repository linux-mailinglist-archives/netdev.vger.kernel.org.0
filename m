Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC29519F6EB
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgDFN1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:27:24 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:18215 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728193AbgDFN1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:27:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586179642; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=sg0YR1A5Pef3VRnFaQiwEzT6F8DEIg+uQHeuwoU6nms=; b=vHsrIhjYN63wFKbB0GJxOfG18aUbWk2JB1UZtLxcf0M3rAjhgK9zomhHQGC5QP9BQ5532lyK
 xmkwKIpQq6auuGM+fRDXl6ZiSBmmmDghJkJRRPBgOgorv2jHehG/1QQxZwesfawPkaBtGp8U
 CuXx3VfBI1rPl7PH6nFcvMhNHfY=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8b2e2b.7fc892fc7f80-smtp-out-n02;
 Mon, 06 Apr 2020 13:27:07 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A120AC44788; Mon,  6 Apr 2020 13:27:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF11EC433BA;
        Mon,  6 Apr 2020 13:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DF11EC433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthias-Peter =?utf-8?Q?Sch=C3=B6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp \(HAU-EDS\)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael \(HAU-EDS\)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
        <87ftdgokao.fsf@tynnyri.adurom.net>
        <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
        <87r1x0zsgk.fsf@kamboji.qca.qualcomm.com>
        <a7e3e8cceff1301f5de5fb2c9aac62b372922b3e.camel@sipsolutions.net>
        <87imiczrwm.fsf@kamboji.qca.qualcomm.com>
        <ee168acb768d87776db2be4e978616f9187908d0.camel@sipsolutions.net>
        <CAFA6WYOjU_iDyAn5PMGe=usg-2sPtupSQEYwcomUcHZBAPnURA@mail.gmail.com>
Date:   Mon, 06 Apr 2020 16:27:00 +0300
In-Reply-To: <CAFA6WYOjU_iDyAn5PMGe=usg-2sPtupSQEYwcomUcHZBAPnURA@mail.gmail.com>
        (Sumit Garg's message of "Mon, 6 Apr 2020 18:51:04 +0530")
Message-ID: <87v9mcycbf.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sumit Garg <sumit.garg@linaro.org> writes:

> On Mon, 6 Apr 2020 at 18:38, Johannes Berg <johannes@sipsolutions.net> wrote:
>>
>> On Mon, 2020-04-06 at 16:04 +0300, Kalle Valo wrote:
>> > Johannes Berg <johannes@sipsolutions.net> writes:
>> >
>> > > On Mon, 2020-04-06 at 15:52 +0300, Kalle Valo wrote:
>> > > > Johannes Berg <johannes@sipsolutions.net> writes:
>> > > >
>> > > > > On Mon, 2020-04-06 at 15:44 +0300, Kalle Valo wrote:
>> > > > > > >     user-space  ieee80211_register_hw()  RX IRQ
>> > > > > > >     +++++++++++++++++++++++++++++++++++++++++++++
>> > > > > > >        |                    |             |
>> > > > > > >        |<---wlan0---wiphy_register()      |
>> > > > > > >        |----start wlan0---->|             |
>> > > > > > >        |                    |<---IRQ---(RX packet)
>> > > > > > >        |              Kernel crash        |
>> > > > > > >        |              due to unallocated  |
>> > > > > > >        |              workqueue.          |
>> > > > >
>> > > > > [snip]
>> > > > >
>> > > > > > I have understood that no frames should be received until mac80211 calls
>> > > > > > struct ieee80211_ops::start:
>> > > > > >
>> > > > > >  * @start: Called before the first netdevice attached to the hardware
>> > > > > >  *         is enabled. This should turn on the hardware and must turn on
>> > > > > >  *         frame reception (for possibly enabled monitor interfaces.)
>> > > > >
>> > > > > True, but I think he's saying that you can actually add and configure an
>> > > > > interface as soon as the wiphy is registered?
>> > > >
>> > > > With '<---IRQ---(RX packet)' I assumed wcn36xx is delivering a frame to
>> > > > mac80211 using ieee80211_rx(), but of course I'm just guessing here.
>> > >
>> > > Yeah, but that could be legitimate?
>> >
>> > Ah, I misunderstood then. The way I have understood is that no rx frames
>> > should be delivered (= calling ieee80211_rx()_ before start() is called,
>> > but if that's not the case please ignore me :)
>>
>> No no, that _is_ the case. But I think the "start wlan0" could end up
>> calling it?
>>
>
> Sorry if I wasn't clear enough via the sequence diagram. It's a common
> RX packet that arrives via ieee80211_tasklet_handler() which is
> enabled via call to "struct ieee80211_ops::start" api.

Ah sorry, I didn't realise that. So wcn36xx is not to be blamed then,
thanks for the clarification.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
