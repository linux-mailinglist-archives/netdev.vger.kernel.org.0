Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBBF4D4439
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 11:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbiCJKHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 05:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbiCJKHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 05:07:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F2513C244;
        Thu, 10 Mar 2022 02:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26A1DB8257B;
        Thu, 10 Mar 2022 10:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5059C340EC;
        Thu, 10 Mar 2022 10:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646906758;
        bh=ZB0Y7Z+2Ou6Nqam8tSjvOtOle2fii9Lnw44DFOuOFmI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HnELMryBkJ8+AIisKOhSdaaVLncNsWXxhw3J+DhyTsSNEiQ1yy0/+RpFM5l4+P7/a
         PPiWCiaTwYgpXJx+jmFXCCcVj5oC+G4RjfLYLafQyiQ9+r8abgRodfhPTgrcLj3Ymm
         P/qr/gzGdfDM8aC+kHGBxArHyDQRVQVZ7lL/oXsUEOtZlkeTFyAHxxkJ1YL5nQtZey
         VCas8KDqrCADG/vTYi+IO3pk/7+rOKX6HTPVqf7r2seSeBjixNujpAzEAAJlJpMVUm
         9wP8ASjId5xU2f059mmUH+iEOw+GJyfFg1611Y29uHgtKHKIdc0IIEWEe4xTi4P1BF
         MC+dY9HYG0ecw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Abhishek Kumar <kuabhs@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: search for default BDF name provided in DT
References: <20220107200417.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
        <CAD=FV=W5fHP8K-PcoYWxYHiDWnPUVQQzOzw=REbuJSSqGeVVfg@mail.gmail.com>
Date:   Thu, 10 Mar 2022 12:05:53 +0200
In-Reply-To: <CAD=FV=W5fHP8K-PcoYWxYHiDWnPUVQQzOzw=REbuJSSqGeVVfg@mail.gmail.com>
        (Doug Anderson's message of "Fri, 7 Jan 2022 13:22:45 -0800")
Message-ID: <87sfrqqfzy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> Hi,
>
> On Fri, Jan 7, 2022 at 12:05 PM Abhishek Kumar <kuabhs@chromium.org> wrote:
>>
>> There can be cases where the board-2.bin does not contain
>> any BDF matching the chip-id+board-id+variant combination.
>> This causes the wlan probe to fail and renders wifi unusable.
>> For e.g. if the board-2.bin has default BDF as:
>> bus=snoc,qmi-board-id=67 but for some reason the board-id
>> on the wlan chip is not programmed and read 0xff as the
>> default value. In such cases there won't be any matching BDF
>> because the board-2.bin will be searched with following:
>> bus=snoc,qmi-board-id=ff

I just checked, in ath10k-firmware WCN3990/hw1.0/board-2.bin we have
that entry:

BoardNames[1]: 'bus=snoc,qmi-board-id=ff'

>> To address these scenarios, there can be an option to provide
>> fallback default BDF name in the device tree. If none of the
>> BDF names match then the board-2.bin file can be searched with
>> default BDF names assigned in the device tree.
>>
>> The default BDF name can be set as:
>> wifi@a000000 {
>>         status = "okay";
>>         qcom,ath10k-default-bdf = "bus=snoc,qmi-board-id=67";
>
> Rather than add a new device tree property, wouldn't it be good enough
> to leverage the existing variant?

I'm not thrilled either adding this to Device Tree, we should keep the
bindings as simple as possible.

> Right now I think that the board file contains:
>
> 'bus=snoc,qmi-board-id=67.bin'
> 'bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_LAZOR.bin'
> 'bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_POMPOM.bin'
> 'bus=snoc,qmi-board-id=67,qmi-chip-id=4320,variant=GO_LAZOR.bin'
> 'bus=snoc,qmi-board-id=67,qmi-chip-id=4320,variant=GO_POMPOM.bin'
>
> ...and, on lazor for instance, we have:
>
> qcom,ath10k-calibration-variant = "GO_LAZOR";
>
> The problem you're trying to solve is that on some early lazor
> prototype hardware we didn't have the "board-id" programmed we could
> get back 0xff from the hardware. As I understand it 0xff always means
> "unprogrammed".
>
> It feels like you could just have a special case such that if the
> hardware reports board ID of 0xff and you don't get a "match" that you
> could just treat 0xff as a wildcard. That means that you'd see the
> "variant" in the device tree and pick one of the "GO_LAZOR" entries.
>
> Anyway, I guess it's up to the people who spend more time in this file
> which they'd prefer, but that seems like it'd be simple and wouldn't
> require a bindings addition...

In ath11k we need something similar for that I have been thinking like
this:

'bus=snoc,qmi-board-id=67,qmi-chip-id=320,variant=GO_LAZOR'

'bus=snoc,qmi-board-id=67,qmi-chip-id=320'

'bus=snoc,qmi-board-id=67'

'bus=snoc'

Ie. we drop one attribute at a time and try to find a suitable board
file. Though I'm not sure if it's possible to find a board file which
works with many different hardware, but the principle would be at least
that. Would something like that work in your case?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
