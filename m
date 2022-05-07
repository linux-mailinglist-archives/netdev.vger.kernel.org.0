Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E053851E79B
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 16:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446380AbiEGODr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 10:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiEGODq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 10:03:46 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA1B29CB9
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 06:59:59 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 741BE24010B
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 15:59:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1651931997; bh=yFqvCYHZne7q/UPkBtj7W4yKjBgYImmwkLi8nvU5Z5U=;
        h=From:To:Cc:Subject:Date:From;
        b=D7mK36YkHmpaLc+7LyPZ4S5wHFPUqY/+HUr15oIe01JuflO2i09e05dT1TKparHgj
         0eB6756XKxMKNBl2gCFOLQd+gN0laa5yyA+KkHuOxVE+gXv6rWCKSl9sH2l/6LJ7Nq
         8WBeViM7IwOUKF2b9EMBR/1Nw+WO1V0U11mMvFvU+nUmybDdy8dX0U8ajnY52tlheW
         ZszNGsGg2rs/D3qZPc1HcTUW04voWtBJmr7ZT/o8Q8YebD4pUvBixQhfBqL+8uDkJM
         J+F62DC0MhuADIm5+dUwi1ZPKb4IUcoWDlS02b/pQyii1zqK34E/5co+cKcYC84KOG
         EuqPdiTfZB7pA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4KwTZz2wkSz9rxP;
        Sat,  7 May 2022 15:59:55 +0200 (CEST)
From:   Manuel Ullmann <labre@posteo.de>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Manuel Ullmann <labre@posteo.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        ndanilov@marvell.com, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jordan Leppert <jordanleppert@protonmail.com>,
        Holger =?utf-8?Q?Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>, koo5 <kolman.jindrich@gmail.com>
Subject: Re: [PATCH v3] net: atlantic: always deep reset on pm op, fixing
 null deref regression
References: <8735hniqcm.fsf@posteo.de>
        <833f2574-daf6-1357-d865-3528436ba393@leemhuis.info>
        <87bkw91ob6.fsf@posteo.de>
        <4b99fc01-5ab4-d803-4177-a1402ac98164@leemhuis.info>
Date:   Sat, 07 May 2022 14:00:10 +0000
In-Reply-To: <4b99fc01-5ab4-d803-4177-a1402ac98164@leemhuis.info> (Thorsten
        Leemhuis's message of "Sat, 7 May 2022 15:25:51 +0200")
Message-ID: <874k211lzp.fsf@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thorsten Leemhuis <regressions@leemhuis.info> writes:

> On 07.05.22 15:10, Manuel Ullmann wrote:
>> Thorsten Leemhuis <regressions@leemhuis.info> writes:
>>=20
>>> On 06.05.22 00:09, Manuel Ullmann wrote:
>>>> >From d24052938345d456946be0e9ccc337e24d771c79 Mon Sep 17 00:00:00 2001
>>>> Date: Wed, 4 May 2022 21:30:44 +0200
>>>>
>>>> The impact of this regression is the same for resume that I saw on
>>>> thaw: the kernel hangs and nothing except SysRq rebooting can be done.
>>>>
>>>> The null deref occurs at the same position as on thaw.
>>>> BUG: kernel NULL pointer dereference
>>>> RIP: aq_ring_rx_fill+0xcf/0x210 [atlantic]
>>>>
>>>> Fixes regression in commit cbe6c3a8f8f4 ("net: atlantic: invert deep
>>>> par in pm functions, preventing null derefs"), where I disabled deep
>>>> pm resets in suspend and resume, trying to make sense of the
>>>> atl_resume_common deep parameter in the first place.
>>>>
>>>> It turns out, that atlantic always has to deep reset on pm operations
>>>> and the parameter is useless. Even though I expected that and tested
>>>> resume, I screwed up by kexec-rebooting into an unpatched kernel, thus
>>>> missing the breakage.
>>>>
>>>> This fixup obsoletes the deep parameter of atl_resume_common, but I
>>>> leave the cleanup for the maintainers to post to mainline.
>>>
>>> FWIW, this section starting here and...
>>>
>>>> PS: I'm very sorry for this regression.
>>>>
>>>> Changes in v2:
>>>> Patch formatting fixes
>>>> - Fix Fixes tag
>>>> =E2=80=93 Simplify stable Cc tag
>>>> =E2=80=93 Fix Signed-off-by tag
>>>>
>>>> Changes in v3:
>>>> =E2=80=93 Prefixed commit reference with "commit" aka I managed to use
>>>>   checkpatch.pl.
>>>> - Added Tested-by tags for the testing reporters.
>>>> =E2=80=93 People start to get annoyed by my patch revision spamming. S=
hould be
>>>>   the last one.
>>>
>>> ...ending here needs should be below the "---" line you already have
>>> below. For details see:
>>> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>
> Sorry, I caused a misunderstanding. I didn't handle the above, I'm not
> one of the net subsystem developers. Either you submit a v4 fixing this
> or hope the net maintainer take care of that when they look at it -- but
> I guess they would highly prefer it if you'd address this.

Never mind. Then I=E2=80=99ll post a v4. Thanks for handling the regzbot
tracking. I indeed just assumed this already to be correctly regzbot
tracked. Never post in a hurry.

>>> BTW, same goes for any "#regzbot" commands (like you had in
>>> cbe6c3a8f8f4), as things otherwise get confused when a patch for example
>>> is posted as part of a stable/longterm -rc review.
>> Good to know. Maybe I could patch the handling-regressions documentation
>> to include this.
>
> Yeah, I have already thought about it, but didn't get down to it yet.

Well, I could try it eventually.

> Only so much hours in a day.

I know that issue. ;)
>> submitting-patches could also link the subsystem
>> specific documentation, e.g. the netdev FAQ, since they handle patches
>> with their more bot tests. Would have helped me a bit. Might be a nice
>> exercise for properly formatted patching ;)
>
> I agree that the docs for submitting patches could need a few
> improvements and that is likely one of them.

Then I=E2=80=99ll try fixing this, too. After all most devs have scarce tim=
e for
documentation.

>>> But don't worry, no big deal, I handled that :-D Many thx for actually
>>> directly getting regzbot involved and taking care of this regression!
>> Thank you for the final cleanup and you=E2=80=99re welcome. :) Where did=
 you
>> handle this? I can=E2=80=99t seem to find the fixup anywhere, i.e. net-n=
ext,
>> net, linux-next or lkml.
>
> See above, I only handled the regzbot issue, not the issue with this
> patch. Sorry for not being clear enough in my wording.

Thanks for clearing this up.

Regards, Manuel
