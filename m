Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BE66271DB
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 19:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbiKMS7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 13:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiKMS7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 13:59:39 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0287B60C6;
        Sun, 13 Nov 2022 10:59:39 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 08D1784F4D;
        Sun, 13 Nov 2022 19:59:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668365977;
        bh=SgcD14pNlGB+D2FXYfYYtZpqVeLIj9nd81BTeQh2UVo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=yJEzxgDLBeOEyD52LlrRZWeu1oO3WC1kQOTp5EsFWH8MLDY63psGRCjCPq0L+4lbd
         LnXRovO/XASZ8oz32a6rXJeZ2j+jo+HBaQC8pz0b/TrlOZTJDkMP9dEBorhkY61CpK
         G/jEqvuFDoA8MXW0AsqvhGeohQSjYJS2ESXlJEF6OhF+AEV71B9n2mci7W4cQ0saZh
         k0PNlG1Ro9InurtP+gH5pJkDno6NSsYkgGGwmF9kOYR7bY5jcux2ufR+kcP+5BSscE
         IXDUJ++wRfE9Oo+shLNtjJVkzDoyNz49xhd9RlJv+95NoQWp9DGZ4J9qN+uyHhISao
         +I+7LpyTq/4FQ==
Message-ID: <da2bca7b-1289-747c-df11-fb424381c6e6@denx.de>
Date:   Sun, 13 Nov 2022 19:59:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v5] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via
 control port
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
References: <20221104163339.227432-1-marex@denx.de>
 <87o7tjszyg.fsf@kernel.org> <7a3b6d5c-1d73-1d31-434f-00703c250dd6@denx.de>
 <877d06g98z.fsf@kernel.org> <afe318c6-9a55-1df2-68b4-d554d4cecd5a@denx.de>
 <871qqccd5i.fsf@kernel.org> <1c37e3f3-0616-3d60-6572-36e9f5aa0d59@denx.de>
 <87zgczs6zl.fsf@kernel.org>
Content-Language: en-US
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <87zgczs6zl.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/22 06:39, Kalle Valo wrote:
> Marek Vasut <marex@denx.de> writes:
> 
>> On 11/9/22 17:20, Kalle Valo wrote:
>>> Marek Vasut <marex@denx.de> writes:
>>>
>>>> On 11/7/22 14:54, Kalle Valo wrote:
>>>>> Marek Vasut <marex@denx.de> writes:
>>>>>
>>>>>>> BTW did you test this on a real device?
>>>>>>
>>>>>> Yes, SDIO RS9116 on next-20221104 and 5.10.153 .
>>>>>
>>>>> Very good, thanks.
>>>>>
>>>>>> What prompts this question ?
>>>>>
>>>>> I get too much "fixes" which have been nowhere near real hardware and
>>>>> can break the driver instead of fixing anything, especially syzbot
>>>>> patches have been notorious. So I have become cautious.
>>>>
>>>> Ah, this is a real problem right here.
>>>>
>>>> wpa-supplicant 2.9 from OE dunfell 3.1 works.
>>>> wpa-supplicant 2.10 from OE kirkstone 4.0 fails.
>>>>
>>>> That's how I ran into this initially. My subsequent tests were with
>>>> debian wpa-supplicant 2.9 and 2.10 packages, since that was easier,
>>>> they (2.10 does, 2.9 does not) trigger the problem all the same.
>>>>
>>>> I'm afraid this RSI driver is so poorly maintained and has so many
>>>> bugs, that, there is little that can make it worse. The dealing I had
>>>> with RSI has been ... long ... and very depressing. I tried to get
>>>> documentation or anything which would help us fix the problems we have
>>>> with this RSI driver ourselves, but RSI refused it all and suggested
>>>> we instead use their downstream driver (I won't go into the quality of
>>>> that). It seems RSI has little interest in maintaining the upstream
>>>> driver, pity.
>>>>
>>>> I've been tempted to flag this driver as BROKEN for a while, to
>>>> prevent others from suffering with it.
>>>
>>> That's a pity indeed. Should we at least mark the driver as orphaned in
>>> MAINTAINERS?
>>>
>>> Or even better if you Marek would be willing to step up as the
>>> maintainer? :)
>>
>> I think best mark it orphaned, to make it clear what the state of the
>> driver really is.
>>
>> If RSI was willing to provide documentation, or at least releases
>> which are not 30k+/20k- single-all-in-one-commit dumps of code, or at
>> least any help, I would consider it. But not like this.
> 
> Yeah, very understandable. So let's mark the driver orphaned then, can
> someone send a patch?

Done
