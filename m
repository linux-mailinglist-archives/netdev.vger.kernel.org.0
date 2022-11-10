Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5140623B61
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 06:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiKJFjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 00:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiKJFjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 00:39:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E63DF28;
        Wed,  9 Nov 2022 21:39:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABFC761D77;
        Thu, 10 Nov 2022 05:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE1DC433D6;
        Thu, 10 Nov 2022 05:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668058790;
        bh=LES0Ap7+QflT+gJ3Vc/85cAxvO/j6TLOqkdoTGDc5Gg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IZaik/d19Me5chyGFULKMa4UCiPzo6U6pIpbrDEkzmZUTt8VmPeRE80at5t3Sw2Qr
         dhxKQhY3UmctBQjqkf+7e/igs/P45a1zH4EmOZpT+mM7DfusRsjnb6JeI8+Ebir1Me
         7l9rr1vi2sfTgiU9nvRtU9nnAtJPE3XkF1Kghzkg5Ks09XkDPc/bMR7zneoI3mRExC
         6Dqq4spuTSWFBKaSpQu9oBGAX4LYIegqTKRgGpw92EyxcsSsMGLAdcyJikP6OiuAaA
         nr/Di0/WnYr49AFlbbPPUMsrPj51R/MrfJR6N7AVFCYEdKfgOhIvp0AAd0BGDmAfqP
         K5GfiY9tA2yhw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org, Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v5] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port
References: <20221104163339.227432-1-marex@denx.de>
        <87o7tjszyg.fsf@kernel.org>
        <7a3b6d5c-1d73-1d31-434f-00703c250dd6@denx.de>
        <877d06g98z.fsf@kernel.org>
        <afe318c6-9a55-1df2-68b4-d554d4cecd5a@denx.de>
        <871qqccd5i.fsf@kernel.org>
        <1c37e3f3-0616-3d60-6572-36e9f5aa0d59@denx.de>
Date:   Thu, 10 Nov 2022 07:39:42 +0200
In-Reply-To: <1c37e3f3-0616-3d60-6572-36e9f5aa0d59@denx.de> (Marek Vasut's
        message of "Wed, 9 Nov 2022 19:17:35 +0100")
Message-ID: <87zgczs6zl.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> writes:

> On 11/9/22 17:20, Kalle Valo wrote:
>> Marek Vasut <marex@denx.de> writes:
>>
>>> On 11/7/22 14:54, Kalle Valo wrote:
>>>> Marek Vasut <marex@denx.de> writes:
>>>>
>>>>>> BTW did you test this on a real device?
>>>>>
>>>>> Yes, SDIO RS9116 on next-20221104 and 5.10.153 .
>>>>
>>>> Very good, thanks.
>>>>
>>>>> What prompts this question ?
>>>>
>>>> I get too much "fixes" which have been nowhere near real hardware and
>>>> can break the driver instead of fixing anything, especially syzbot
>>>> patches have been notorious. So I have become cautious.
>>>
>>> Ah, this is a real problem right here.
>>>
>>> wpa-supplicant 2.9 from OE dunfell 3.1 works.
>>> wpa-supplicant 2.10 from OE kirkstone 4.0 fails.
>>>
>>> That's how I ran into this initially. My subsequent tests were with
>>> debian wpa-supplicant 2.9 and 2.10 packages, since that was easier,
>>> they (2.10 does, 2.9 does not) trigger the problem all the same.
>>>
>>> I'm afraid this RSI driver is so poorly maintained and has so many
>>> bugs, that, there is little that can make it worse. The dealing I had
>>> with RSI has been ... long ... and very depressing. I tried to get
>>> documentation or anything which would help us fix the problems we have
>>> with this RSI driver ourselves, but RSI refused it all and suggested
>>> we instead use their downstream driver (I won't go into the quality of
>>> that). It seems RSI has little interest in maintaining the upstream
>>> driver, pity.
>>>
>>> I've been tempted to flag this driver as BROKEN for a while, to
>>> prevent others from suffering with it.
>>
>> That's a pity indeed. Should we at least mark the driver as orphaned in
>> MAINTAINERS?
>>
>> Or even better if you Marek would be willing to step up as the
>> maintainer? :)
>
> I think best mark it orphaned, to make it clear what the state of the
> driver really is.
>
> If RSI was willing to provide documentation, or at least releases
> which are not 30k+/20k- single-all-in-one-commit dumps of code, or at
> least any help, I would consider it. But not like this.

Yeah, very understandable. So let's mark the driver orphaned then, can
someone send a patch?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
