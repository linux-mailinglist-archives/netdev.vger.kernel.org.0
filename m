Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AF669EF90
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 08:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjBVHqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 02:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjBVHqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 02:46:51 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C2727D7F;
        Tue, 21 Feb 2023 23:46:48 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pUjpv-0006im-51; Wed, 22 Feb 2023 08:46:47 +0100
Message-ID: <aa452e7d-9670-46f5-171f-71d60b841eb0@leemhuis.info>
Date:   Wed, 22 Feb 2023 08:46:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Content-Language: en-US, de-DE
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Gaurav Jain <gaurav.jain@nxp.com>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: [regression] Bug 217064 - Kernel TLS with CAAM is Broken
 (net/tls/tls_sw.c)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1677052008;16d35da8;
X-HE-SMSGID: 1pUjpv-0006im-51
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

I noticed a regression report in bugzilla.kernel.org. As many (most?)
kernel developer don't keep an eye on it, I decided to forward it by
mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=217064 :

>  Gaurav Jain 2023-02-21 07:07:22 UTC
> 
> I am running Kernel TLS with CAAM on iMX8M board.
> KTLS + CAAM is broken in 6.1 kernel when async and zero copy is true.
> 
> **Commit id causing the issue: **
> 
> commit cbbdee9918a2662914f411aa999f2f80bf044a30
> Author: Jakub Kicinski kuba@kernel.org
> Date:   Thu Jul 14 22:22:34 2022 -0700
> 
>     tls: rx: async: don't put async zc on the list
> 
>     The "zero-copy" path in SW TLS will engage either for no skbs or
>     for all but last. If the recvmsg parameters are right and the
>     socket can do ZC we'll ZC until the iterator can't fit a full
>     record at which point we'll decrypt one more record and copy
>     over the necessary bits to fill up the request.
> 
>     The only reason we hold onto the ZC skbs which went thru the async
>     path until the end of recvmsg() is to count bytes. We need an accurate
>     count of zc'ed bytes so that we can calculate how much of the non-zc'd
>     data to copy. To allow freeing input skbs on the ZC path count only
>     how much of the list we'll need to consume.
> 
>     Signed-off-by: Jakub Kicinski kuba@kernel.org
>     Signed-off-by: David S. Miller davem@davemloft.net



See the ticket for more details.


[TLDR for the rest of this mail: I'm adding this report to the list of
tracked Linux kernel regressions; the text you find below is based on a
few templates paragraphs you might have encountered already in similar
form.]

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: cbbdee9918a2
https://bugzilla.kernel.org/show_bug.cgi?id=217064
#regzbot title: net/ktls: Kernel TLS with CAAM is Broken
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (e.g. the buzgzilla ticket and maybe this mail as well, if
this thread sees some discussion). See page linked in footer for details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
