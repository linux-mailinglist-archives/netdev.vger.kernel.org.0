Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74685627F4B
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 13:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbiKNM50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 07:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237567AbiKNM5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 07:57:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6429627CE1;
        Mon, 14 Nov 2022 04:57:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0347061175;
        Mon, 14 Nov 2022 12:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10023C433D7;
        Mon, 14 Nov 2022 12:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668430640;
        bh=uon6Krd1MvkrDak6DwqUCaNp/DwejxOIsxkc2HYJQwI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LDJfw7R3m5F7ffSJYBsrmlsz45BIKmNI2WJRFhdhJ5S2NcvEU8y59iXuR2SU4bGo+
         r9TobxQ3khv7cRqLxnWUHYx0jmgS+kTgWkWx8NzJxHp4JYZDkK9GAjfzCfBfdCTbEj
         OnaR/N29Q+eZGQA8upobvzlPJC3lCD1g2NuR9Ksm3EqBLibYMM9iV85xB8zENY67Ye
         P8EO6xVDzwU3ytcqpbVgKQyXiusfarBB198ZbeVuJ/K1pXyYfedhPtyXWj3eJm7Bjm
         5vx/D2UEDvJ6i9SUljC6aML7scWntWQl7+7W71XjGIJC1GBmzWJn2WWWXybj/LHTaX
         WMos9HNgFE5yg==
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
        <87zgczs6zl.fsf@kernel.org>
        <da2bca7b-1289-747c-df11-fb424381c6e6@denx.de>
Date:   Mon, 14 Nov 2022 14:57:15 +0200
In-Reply-To: <da2bca7b-1289-747c-df11-fb424381c6e6@denx.de> (Marek Vasut's
        message of "Sun, 13 Nov 2022 19:59:36 +0100")
Message-ID: <87iljhbsno.fsf@kernel.org>
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

> On 11/10/22 06:39, Kalle Valo wrote:
>
>> Marek Vasut <marex@denx.de> writes:
>>
>>> On 11/9/22 17:20, Kalle Valo wrote:
>>>
>>>> That's a pity indeed. Should we at least mark the driver as orphaned in
>>>> MAINTAINERS?
>>>>
>>>> Or even better if you Marek would be willing to step up as the
>>>> maintainer? :)
>>>
>>> I think best mark it orphaned, to make it clear what the state of the
>>> driver really is.
>>>
>>> If RSI was willing to provide documentation, or at least releases
>>> which are not 30k+/20k- single-all-in-one-commit dumps of code, or at
>>> least any help, I would consider it. But not like this.
>>
>> Yeah, very understandable. So let's mark the driver orphaned then, can
>> someone send a patch?
>
> Done

Great, thank you very much.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
