Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A2251E754
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 15:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385150AbiEGNNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 09:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385136AbiEGNNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 09:13:40 -0400
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5289913D46
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 06:09:53 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 74DFC240029
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 15:09:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1651928991; bh=Mvl1nfcKPlDY7R8FkACDDu+dOs/VOaKBYoYhUqCo2Vs=;
        h=From:To:Cc:Subject:Date:From;
        b=QA27jQK6LiXHIeEI6JYIHtgiuB6mu/acaR/X4jZT5E2QcfHCxf7rjd1k2nlLdF9Df
         SocS9JlRtvweOlvqaKMQA3m4/UZrrr3kTRtTjWN3Lz8MxH7XtBy26AWIX7FlO6RDSN
         mF6YvoRI7TO9ZL6PxAevjhXQXGDdnrnw/2FtwTvqv3sHqk+A5XdFcQH+VnVksC7oOn
         QvSTzBxX87fk8/ShH9LIQbS9eiymgSIFWSXKkZmajeMASf/jMRd2Pnzg4h5drTaiTh
         0ZNigGOvZErWJD5Rln5L75P+WEvEwFoUciRrb1Rliz74cZzNoZegcXQHVlXJXsy9oS
         PK9aC+kfCUONg==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4KwST853rHz6tnN;
        Sat,  7 May 2022 15:09:48 +0200 (CEST)
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
Date:   Sat, 07 May 2022 13:10:05 +0000
Message-ID: <87bkw91ob6.fsf@posteo.de>
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

> On 06.05.22 00:09, Manuel Ullmann wrote:
>>>From d24052938345d456946be0e9ccc337e24d771c79 Mon Sep 17 00:00:00 2001
>> Date: Wed, 4 May 2022 21:30:44 +0200
>>=20
>> The impact of this regression is the same for resume that I saw on
>> thaw: the kernel hangs and nothing except SysRq rebooting can be done.
>>=20
>> The null deref occurs at the same position as on thaw.
>> BUG: kernel NULL pointer dereference
>> RIP: aq_ring_rx_fill+0xcf/0x210 [atlantic]
>>=20
>> Fixes regression in commit cbe6c3a8f8f4 ("net: atlantic: invert deep
>> par in pm functions, preventing null derefs"), where I disabled deep
>> pm resets in suspend and resume, trying to make sense of the
>> atl_resume_common deep parameter in the first place.
>>=20
>> It turns out, that atlantic always has to deep reset on pm operations
>> and the parameter is useless. Even though I expected that and tested
>> resume, I screwed up by kexec-rebooting into an unpatched kernel, thus
>> missing the breakage.
>>=20
>> This fixup obsoletes the deep parameter of atl_resume_common, but I
>> leave the cleanup for the maintainers to post to mainline.
>
> FWIW, this section starting here and...
>
>> PS: I'm very sorry for this regression.
>>=20
>> Changes in v2:
>> Patch formatting fixes
>> - Fix Fixes tag
>> =E2=80=93 Simplify stable Cc tag
>> =E2=80=93 Fix Signed-off-by tag
>>=20
>> Changes in v3:
>> =E2=80=93 Prefixed commit reference with "commit" aka I managed to use
>>   checkpatch.pl.
>> - Added Tested-by tags for the testing reporters.
>> =E2=80=93 People start to get annoyed by my patch revision spamming. Sho=
uld be
>>   the last one.
>
> ...ending here needs should be below the "---" line you already have
> below. For details see:
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>
> BTW, same goes for any "#regzbot" commands (like you had in
> cbe6c3a8f8f4), as things otherwise get confused when a patch for example
> is posted as part of a stable/longterm -rc review.
Good to know. Maybe I could patch the handling-regressions documentation
to include this. submitting-patches could also link the subsystem
specific documentation, e.g. the netdev FAQ, since they handle patches
with their more bot tests. Would have helped me a bit. Might be a nice
exercise for properly formatted patching ;)

>
> But don't worry, no big deal, I handled that :-D Many thx for actually
> directly getting regzbot involved and taking care of this regression!

Thank you for the final cleanup and you=E2=80=99re welcome. :) Where did you
handle this? I can=E2=80=99t seem to find the fixup anywhere, i.e. net-next,
net, linux-next or lkml.

I actually took the time and read that and all related documentation
(stable, regressions, coding style) during my vacation a few weeks ago,
but my memory was partially overwritten by less useful (work related)
data. Instead of regression reports induced panic mode, I should have
reread the submitting-patches, especially the last section.

>> Fixes: cbe6c3a8f8f4 ("net: atlantic: invert deep par in pm functions, pr=
eventing null derefs")
>> Link: https://lore.kernel.org/regressions/9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Iz=
co4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5=
iQ=3D@protonmail.com/
>> Reported-by: Jordan Leppert <jordanleppert@protonmail.com>
>> Reported-by: Holger Hoffst=C3=A4tte <holger@applied-asynchrony.com>
>> Tested-by: Jordan Leppert <jordanleppert@protonmail.com>
>> Tested-by: Holger Hoffst=C3=A4tte <holger@applied-asynchrony.com>
>> Cc: <stable@vger.kernel.org> # 5.10+
>> Signed-off-by: Manuel Ullmann <labre@posteo.de>
>> ---
>>  drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Ciao, Thorsten
Regards, Manuel
