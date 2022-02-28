Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5044C766D
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 19:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiB1SEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 13:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240101AbiB1SDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 13:03:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315999EB8A
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:46:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F95060916
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 17:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962A3C340E7;
        Mon, 28 Feb 2022 17:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646070387;
        bh=YChP7/0H7ZrSEyPXri27DT3g6AVkRnkgsTUf7Ji6YVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qgUX8xmdSn6GZqMy2i3z2S8hLVVkbSc8WHJqlI+mEmeJ+0zPJn0Mpw95ZZArJ/1fx
         1jIV6Ikvw2+LQHkNmLC+bQF2cxWht+NKFoY74J9hvZu7HrYTz3jO7C5xQI6wQUIRmF
         ZO96YJunELFAss4DFtV0wWnHSJbxBNpXVHKTw2ceaKgIykF5it9XY+mOnb4JUT+4pI
         W83VbO/DV4W6JWqKu2ZvIZGFNUVLc2agHKiTfuoihNaaA9fzGFiZ3oPg0I9VDGUWFL
         BbRW7zfu4H2IL7cer5Hlf9Cxc+OnEzSmpQazwMZ0IGf2kk24iasbd98v+bCUw/RlMT
         fVQ14vt3LeAGg==
Date:   Mon, 28 Feb 2022 09:46:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: Regression are sometimes merged slowly, maybe optimize the
 downstream interaction?
Message-ID: <20220228094626.7e116e2c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <37349299-c47b-1f67-2229-78ae9b9b4488@leemhuis.info>
References: <37349299-c47b-1f67-2229-78ae9b9b4488@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 14:45:47 +0100 Thorsten Leemhuis wrote:
> Hi Jakub, Hi Dave!

Let's CC Luiz and Steffen.

> I was wondering if you and your downstream maintainers could consider
> slightly optimizing your working habits to get regression fixes from
> downstream git repos a bit quicker into mainline. A slightly different
> timing afaics might already help a lot; or some timing optimizations in
> the interaction with downstream maintainers.
> 
> I ask, because in my regression tracking work I noticed that quite a few
> regression fixes take a long time towards mainline when they need to go
> through net.git; that imho is especially bad for regressions caused by
> commits in earlier development cycles, as they can only be fixed in new
> stable releases after the fix was mainlined.
> 
> Often the fixes progress slowly due to the habits of the downstream
> maintainers -- some for example are imho not asking you often enough to
> pull fixes. I guess that might need to be discussed down the road as
> well, but there is something else that imho needs to be addressed first.
> 
> At least from the outside it often looks like bad timing is the reason
> why some fixes take quite long journey to mainline. Take for example the
> latest pull requests for bluetooth and ipsec:
> 
> https://lore.kernel.org/netdev/20220224210838.197787-1-luiz.dentz@gmail.com/
> https://lore.kernel.org/netdev/20220225074733.118664-1-steffen.klassert@secunet.com/

Yeah, we also narrowly missed the BPF pr a week back :/
Or should I say BPF pr missed the net pr..

> One is from Thursday, the other from early Friday; both contain fixes
> for regressions in earlier mainline releases that afaics need to get
> backported to stable and longterm releases to finally get the regression
> erased from this world. The ipsec fix has been in -next already for a
> while, the bluetooth fix afaics wasn't.
> 
> Sadly, both patch sets missed rc6 as Jakub already had sent his pull
> request to Linus on Thursday:
> https://lore.kernel.org/all/20220224195305.1584666-1-kuba@kernel.org/
> 
> This is not the first time I noticed such bad timing. That made me
> wonder: would it be possible for you to optimize the workflow here?
> Maybe a simple advice to downstream maintainers could do the trick, e.g.
> "ideally sent pull request by Friday morning[some timezone] at the
> latest, as then the net maintainers can review, merge, and sent them
> onwards to Linus in a pull request later that day".

These are fair complaints. We've been sending PRs with fixes every
Thursday for, I'd say, a year or so now. If the sub-tree PR is posted 
by Wednesday it will definitely make the cut. Either folks don't know 
this or they want changes to sit in the networking tree for a couple
of days? Hm.

> FWIW, I don't know anything about the inner working of your subsystem,
> if you need more time to review or process merge requests from
> downstream maintainers the "Friday morning" obviously needs to be adjusted.
> 
> Or is there something like that already and the timing just has been bad
> a few times when I looked closer?

I think it's a particularly unfortunate time with a few "missed prs"
in a short span of time. When Dave was handling all the prs he used
to decide the timing based on contents of the tree, maybe that's 
a better model for prioritizing fixes getting to Linus, but I lack 
the skills necessary to make such calls.

I'll try to advertise the Wednesday rule more, although creating
deadlines has proven to lead to rushed work. Which IMHO is much 
worse :(

BTW there's also something weird with the flow of fixes lately.
Maybe it's just my perception but I feel like it has been disrupted
in Dec and hasn't fully recovered. Normally we get an influx of "new
code / regression fixes" after rc2, and they peter out around rc5.
This release it feels like the fixes _started_ flowing at rc5 :S

Anyway, thanks for raising the issue, and please keep us posted on how
things look from your perspective. It's a balancing act, it'd be great
if we can improve things over time without sudden changes.

Thanks again!
