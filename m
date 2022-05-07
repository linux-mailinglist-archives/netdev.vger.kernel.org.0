Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA5851E766
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 15:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385132AbiEGN3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 09:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385152AbiEGN3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 09:29:46 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D352AC65;
        Sat,  7 May 2022 06:25:59 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nnKRU-0005NM-V7; Sat, 07 May 2022 15:25:53 +0200
Message-ID: <4b99fc01-5ab4-d803-4177-a1402ac98164@leemhuis.info>
Date:   Sat, 7 May 2022 15:25:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3] net: atlantic: always deep reset on pm op, fixing null
 deref regression
Content-Language: en-US
To:     Manuel Ullmann <labre@posteo.de>
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        ndanilov@marvell.com, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jordan Leppert <jordanleppert@protonmail.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        koo5 <kolman.jindrich@gmail.com>
References: <8735hniqcm.fsf@posteo.de>
 <833f2574-daf6-1357-d865-3528436ba393@leemhuis.info>
 <87bkw91ob6.fsf@posteo.de>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <87bkw91ob6.fsf@posteo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1651929959;4f543069;
X-HE-SMSGID: 1nnKRU-0005NM-V7
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.05.22 15:10, Manuel Ullmann wrote:
> Thorsten Leemhuis <regressions@leemhuis.info> writes:
> 
>> On 06.05.22 00:09, Manuel Ullmann wrote:
>>> >From d24052938345d456946be0e9ccc337e24d771c79 Mon Sep 17 00:00:00 2001
>>> Date: Wed, 4 May 2022 21:30:44 +0200
>>>
>>> The impact of this regression is the same for resume that I saw on
>>> thaw: the kernel hangs and nothing except SysRq rebooting can be done.
>>>
>>> The null deref occurs at the same position as on thaw.
>>> BUG: kernel NULL pointer dereference
>>> RIP: aq_ring_rx_fill+0xcf/0x210 [atlantic]
>>>
>>> Fixes regression in commit cbe6c3a8f8f4 ("net: atlantic: invert deep
>>> par in pm functions, preventing null derefs"), where I disabled deep
>>> pm resets in suspend and resume, trying to make sense of the
>>> atl_resume_common deep parameter in the first place.
>>>
>>> It turns out, that atlantic always has to deep reset on pm operations
>>> and the parameter is useless. Even though I expected that and tested
>>> resume, I screwed up by kexec-rebooting into an unpatched kernel, thus
>>> missing the breakage.
>>>
>>> This fixup obsoletes the deep parameter of atl_resume_common, but I
>>> leave the cleanup for the maintainers to post to mainline.
>>
>> FWIW, this section starting here and...
>>
>>> PS: I'm very sorry for this regression.
>>>
>>> Changes in v2:
>>> Patch formatting fixes
>>> - Fix Fixes tag
>>> – Simplify stable Cc tag
>>> – Fix Signed-off-by tag
>>>
>>> Changes in v3:
>>> – Prefixed commit reference with "commit" aka I managed to use
>>>   checkpatch.pl.
>>> - Added Tested-by tags for the testing reporters.
>>> – People start to get annoyed by my patch revision spamming. Should be
>>>   the last one.
>>
>> ...ending here needs should be below the "---" line you already have
>> below. For details see:
>> https://www.kernel.org/doc/html/latest/process/submitting-patches.html

Sorry, I caused a misunderstanding. I didn't handle the above, I'm not
one of the net subsystem developers. Either you submit a v4 fixing this
or hope the net maintainer take care of that when they look at it -- but
I guess they would highly prefer it if you'd address this.

>> BTW, same goes for any "#regzbot" commands (like you had in
>> cbe6c3a8f8f4), as things otherwise get confused when a patch for example
>> is posted as part of a stable/longterm -rc review.
> Good to know. Maybe I could patch the handling-regressions documentation
> to include this.

Yeah, I have already thought about it, but didn't get down to it yet.
Only so much hours in a day.

> submitting-patches could also link the subsystem
> specific documentation, e.g. the netdev FAQ, since they handle patches
> with their more bot tests. Would have helped me a bit. Might be a nice
> exercise for properly formatted patching ;)

I agree that the docs for submitting patches could need a few
improvements and that is likely one of them.

>> But don't worry, no big deal, I handled that :-D Many thx for actually
>> directly getting regzbot involved and taking care of this regression!
> Thank you for the final cleanup and you’re welcome. :) Where did you
> handle this? I can’t seem to find the fixup anywhere, i.e. net-next,
> net, linux-next or lkml.

See above, I only handled the regzbot issue, not the issue with this
patch. Sorry for not being clear enough in my wording.

> [...]

Ciao, Thorsten
