Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1831B623240
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiKISRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKISRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:17:41 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0322792B;
        Wed,  9 Nov 2022 10:17:39 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 07B4785068;
        Wed,  9 Nov 2022 19:17:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668017856;
        bh=GYHHdZB/qPzUzOwuW6NShCpuCMTDNVceWJ9RfWHi9KI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UwJyjobhTZVbPIx+LSozg/FyrgwgHbHegHRrQkPObpIRv2kzqbZsIjJCnLoKdhdUZ
         KfWEqVfr+DXktzW0eygBTf6qsKTQChOnSYvwLAYCZSEbxVcPJpK2KGBSKiTOr4RofF
         BqGFG9uyYnIONyX6JsYQrETafbbY+MueIjb1rwIgzt8ciRCRGapT11nUnePN5RDLM7
         y0wW+Amgbexz37OKHhTPICsZ3h1OSwBJMi0NJj9anG2spc/lj8arTbTEmmyVNY05gb
         /+Np/ocbOViBM/7NUzJY4N1gqO0mD8bb2JI+3ma0x3KT/e6cGNwWX0xSQCso8rrNue
         qgco517NdX3jQ==
Message-ID: <1c37e3f3-0616-3d60-6572-36e9f5aa0d59@denx.de>
Date:   Wed, 9 Nov 2022 19:17:35 +0100
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
 <871qqccd5i.fsf@kernel.org>
Content-Language: en-US
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <871qqccd5i.fsf@kernel.org>
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

On 11/9/22 17:20, Kalle Valo wrote:
> Marek Vasut <marex@denx.de> writes:
> 
>> On 11/7/22 14:54, Kalle Valo wrote:
>>> Marek Vasut <marex@denx.de> writes:
>>>
>>>>> BTW did you test this on a real device?
>>>>
>>>> Yes, SDIO RS9116 on next-20221104 and 5.10.153 .
>>>
>>> Very good, thanks.
>>>
>>>> What prompts this question ?
>>>
>>> I get too much "fixes" which have been nowhere near real hardware and
>>> can break the driver instead of fixing anything, especially syzbot
>>> patches have been notorious. So I have become cautious.
>>
>> Ah, this is a real problem right here.
>>
>> wpa-supplicant 2.9 from OE dunfell 3.1 works.
>> wpa-supplicant 2.10 from OE kirkstone 4.0 fails.
>>
>> That's how I ran into this initially. My subsequent tests were with
>> debian wpa-supplicant 2.9 and 2.10 packages, since that was easier,
>> they (2.10 does, 2.9 does not) trigger the problem all the same.
>>
>> I'm afraid this RSI driver is so poorly maintained and has so many
>> bugs, that, there is little that can make it worse. The dealing I had
>> with RSI has been ... long ... and very depressing. I tried to get
>> documentation or anything which would help us fix the problems we have
>> with this RSI driver ourselves, but RSI refused it all and suggested
>> we instead use their downstream driver (I won't go into the quality of
>> that). It seems RSI has little interest in maintaining the upstream
>> driver, pity.
>>
>> I've been tempted to flag this driver as BROKEN for a while, to
>> prevent others from suffering with it.
> 
> That's a pity indeed. Should we at least mark the driver as orphaned in
> MAINTAINERS?
> 
> Or even better if you Marek would be willing to step up as the
> maintainer? :)

I think best mark it orphaned, to make it clear what the state of the 
driver really is.

If RSI was willing to provide documentation, or at least releases which 
are not 30k+/20k- single-all-in-one-commit dumps of code, or at least 
any help, I would consider it. But not like this.
