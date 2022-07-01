Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF215632BC
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 13:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbiGALml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 07:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiGALmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 07:42:40 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E221823B3;
        Fri,  1 Jul 2022 04:42:32 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1o7F2b-0005HB-Ml; Fri, 01 Jul 2022 13:42:29 +0200
Message-ID: <be9290fb-addb-b880-c5b0-f2ac223d2ab9@leemhuis.info>
Date:   Fri, 1 Jul 2022 13:42:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     regressions@lists.linux.dev, kajetan.puchalski@arm.com
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [Regression] stress-ng udp-flood causes kernel panic on Ampere
 Altra #forregzbot
In-Reply-To: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1656675752;a7962714;
X-HE-SMSGID: 1o7F2b-0005HB-Ml
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[TLDR: I'm adding this regression report to the list of tracked
regressions; all text from me you find below is based on a few templates
paragraphs you might have encountered already already in similar form.]

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

Hi, this is your Linux kernel regression tracker.

On 01.07.22 13:11, Kajetan Puchalski wrote:
> Hi,
> 
> While running the udp-flood test from stress-ng on Ampere Altra (Mt.
> Jade platform) I encountered a kernel panic caused by NULL pointer
> dereference within nf_conntrack.
> 
> The issue is present in the latest mainline (5.19-rc4), latest stable
> (5.18.8), as well as multiple older stable versions. The last working
> stable version I found was 5.15.40.
> 
> Through bisecting I've traced the issue back to mainline commit
> 719774377622bc4025d2a74f551b5dc2158c6c30 (netfilter: conntrack: convert to refcount_t api),
> on kernels from before this commit the test runs fine. As far as I can tell, this commit was
> included in stable with version 5.15.41, thus causing the regression
> compared to 5.15.40. It was included in the mainline with version 5.16.

FWIW, looks like it was merged for v5.17-rc1
$ git describe --contains --tags  719774377622bc4025

v5.17-rc1~170^2~24^2~19

> The issue is very consistently reproducible as well, running this
> command resulted in the same kernel panic every time I tried it on
> different kernels from after the change in question was merged.
> 
> stress-ng --udp-flood 0 -t 1m --metrics-brief --perf
> 
> The commit was not easily revertible so I can't say whether reverting it
> on the latest mainline would fix the problem or not.
> 
> [...]
> 
> The distirbution is Ubuntu 20.04.3 LTS, the architecture is aarch64.
> 
> Please let me know if I can provide any more details or try any more
> tests.

Thanks for the report. To be sure below issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
tracking bot:

#regzbot ^introduced 719774377622bc402
#regzbot title net: netfilter: stress-ng udp-flood causes kernel panic
on Ampere Altra

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply -- ideally with also
telling regzbot about it, as explained here:
https://linux-regtracking.leemhuis.info/tracked-regression/

Reminder for developers: When fixing the issue, add 'Link:' tags
pointing to the report (the mail this one replies to), as explained for
in the Linux kernel's documentation; above webpage explains why this is
important for tracked regressions.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
