Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69842432F3C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhJSHWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:22:10 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:15188 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbhJSHWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 03:22:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634627997; h=Content-Type: MIME-Version: Message-ID: Date:
 References: In-Reply-To: Subject: Cc: To: From: Sender;
 bh=uMYO89HCqmvjMOPfezlrMm2RtJkAxmAYfrETwCAbYcI=; b=RLVpvwREQAqv7hkDQUFkKEWMaV9Ts5369s0zRAP9hNOlBHimSRvi5EJJ3+kIUekwA4bjkdRR
 +veHMmywD6WJqHdKhOfaiv1/s2Tl7GCGCTPW+pYVyGWECUh357DaXDBU8OIoxVPr471F9W4u
 +BZguAOzziQl3RccLe1n/D7f3G4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 616e71933416c2cb7067ece7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 19 Oct 2021 07:19:47
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A57ADC43617; Tue, 19 Oct 2021 07:19:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 302F4C4338F;
        Tue, 19 Oct 2021 07:19:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 302F4C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Nick Hainke <vincent@systemli.org>, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>
Subject: Re: [RFC v2] mt76: mt7615: mt7622: fix ibss and meshpoint
In-Reply-To: <569d434d-cf5b-6ab0-5931-41b21ab047b7@nbd.name> (Felix Fietkau's
        message of "Mon, 18 Oct 2021 12:16:00 +0200")
References: <20211007225725.2615-1-vincent@systemli.org>
        <87czoe61kh.fsf@codeaurora.org>
        <569d434d-cf5b-6ab0-5931-41b21ab047b7@nbd.name>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Tue, 19 Oct 2021 10:19:35 +0300
Message-ID: <87bl3lqy60.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 2021-10-09 10:32, Kalle Valo wrote:
>> Nick Hainke <vincent@systemli.org> writes:
>>
>>> Fixes: d8d59f66d136 ("mt76: mt7615: support 16 interfaces").
>>
>> The fixes tag should be in the end, before Signed-off-by tags. But I can
>> fix that during commit.
>>
>>> commit 7f4b7920318b ("mt76: mt7615: add ibss support") introduced IBSS
>>> and commit f4ec7fdf7f83 ("mt76: mt7615: enable support for mesh")
>>> meshpoint support.
>>>
>>> Both used in the "get_omac_idx"-function:
>>>
>>> 	if (~mask & BIT(HW_BSSID_0))
>>> 		return HW_BSSID_0;
>>>
>>> With commit d8d59f66d136 ("mt76: mt7615: support 16 interfaces") the
>>> ibss and meshpoint mode should "prefer hw bssid slot 1-3". However,
>>> with that change the ibss or meshpoint mode will not send any beacon on
>>> the mt7622 wifi anymore. Devices were still able to exchange data but
>>> only if a bssid already existed. Two mt7622 devices will never be able
>>> to communicate.
>>>
>>> This commits reverts the preferation of slot 1-3 for ibss and
>>> meshpoint. Only NL80211_IFTYPE_STATION will still prefer slot 1-3.
>>>
>>> Tested on Banana Pi R64.
>>>
>>> Signed-off-by: Nick Hainke <vincent@systemli.org>
>>
>> Felix, can I take this to wireless-drivers? Ack?
>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Thanks. We are in -rc6 now and I'm not planning to send any more fixes
to v5.15 (unless very critical), so I'll take this to
wireless-drivers-next instead.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
