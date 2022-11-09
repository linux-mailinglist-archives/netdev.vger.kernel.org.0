Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F036762300C
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiKIQVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiKIQVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:21:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B84167E3;
        Wed,  9 Nov 2022 08:21:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7734AB81F38;
        Wed,  9 Nov 2022 16:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F4BC433C1;
        Wed,  9 Nov 2022 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668010864;
        bh=bHR3akRUdQF87PGyjO5R1BzAS7isamo5fFrvDl8bd50=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NN03LOwuihuwO3U2kE5FyxnI0xVn36SyCyISiEs6Du9U25VZR9LvS8QGUo+jh2PiL
         7bH35XwQ+SWJclX3Gdcp/p9DyviZONc6Den9VRg/zwNYL8kfGIewZ0Wo6Et9/eEHRV
         AdJAZQyBKfmy9M9o+qxy1ig+vBgncNWG3h9i3OE0UuO5kubRCf1pcWdpm865cr4ZwC
         g8bmSNlSqt2F6kqfA/gcKwlBMPBT0CC+4pLfoI0RQqgM6XD/Fl8de/0QZHnzgB8Ckr
         kHQalu3hnYlQC41AbIWkSPukxWegudVzIrNy2eu2uU6EDbFRyFK4HY7fgba5kYHuqv
         bM+AZpFaBDNbg==
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
Date:   Wed, 09 Nov 2022 18:20:57 +0200
In-Reply-To: <afe318c6-9a55-1df2-68b4-d554d4cecd5a@denx.de> (Marek Vasut's
        message of "Mon, 7 Nov 2022 15:44:55 +0100")
Message-ID: <871qqccd5i.fsf@kernel.org>
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

> On 11/7/22 14:54, Kalle Valo wrote:
>> Marek Vasut <marex@denx.de> writes:
>>
>>>> BTW did you test this on a real device?
>>>
>>> Yes, SDIO RS9116 on next-20221104 and 5.10.153 .
>>
>> Very good, thanks.
>>
>>> What prompts this question ?
>>
>> I get too much "fixes" which have been nowhere near real hardware and
>> can break the driver instead of fixing anything, especially syzbot
>> patches have been notorious. So I have become cautious.
>
> Ah, this is a real problem right here.
>
> wpa-supplicant 2.9 from OE dunfell 3.1 works.
> wpa-supplicant 2.10 from OE kirkstone 4.0 fails.
>
> That's how I ran into this initially. My subsequent tests were with
> debian wpa-supplicant 2.9 and 2.10 packages, since that was easier,
> they (2.10 does, 2.9 does not) trigger the problem all the same.
>
> I'm afraid this RSI driver is so poorly maintained and has so many
> bugs, that, there is little that can make it worse. The dealing I had
> with RSI has been ... long ... and very depressing. I tried to get
> documentation or anything which would help us fix the problems we have
> with this RSI driver ourselves, but RSI refused it all and suggested
> we instead use their downstream driver (I won't go into the quality of
> that). It seems RSI has little interest in maintaining the upstream
> driver, pity.
>
> I've been tempted to flag this driver as BROKEN for a while, to
> prevent others from suffering with it.

That's a pity indeed. Should we at least mark the driver as orphaned in
MAINTAINERS?

Or even better if you Marek would be willing to step up as the
maintainer? :)

> Until I send such a patch, you can expect real fixes coming from my
> end at least.

Great, thank you.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
