Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78B35AD027
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 12:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbiIEKdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 06:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236437AbiIEKc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 06:32:59 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B586A39B96;
        Mon,  5 Sep 2022 03:32:58 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oV9PV-0003SA-9P; Mon, 05 Sep 2022 12:32:57 +0200
Message-ID: <38d9783f-9b1a-69bb-4f5d-3c77239d53fc@leemhuis.info>
Date:   Mon, 5 Sep 2022 12:32:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: setns() affecting other threads in 5.10.132 and 6.0
Content-Language: en-US, de-DE
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <d9f7a7d26eb5489e93742e57e55ebc02@AcuMS.aculab.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <d9f7a7d26eb5489e93742e57e55ebc02@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1662373978;de8de917;
X-HE-SMSGID: 1oV9PV-0003SA-9P
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

[TLDR: I'm adding this regression report to the list of tracked
regressions; all text from me you find below is based on a few templates
paragraphs you might have encountered already already in similar form.]

Hi, this is your Linux kernel regression tracker. CCing the regression
mailing list, as it should be in the loop for all regressions, as
explained here:
https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html

On 04.09.22 16:05, David Laight wrote:
> Sometime after 5.10.105 (5.10.132 and 6.0) there is a change that
> makes setns(open("/proc/1/ns/net")) in the main process change
> the behaviour of other process threads.
> 
> I don't know how much is broken, but the following fails.
> 
> Create a network namespace (eg "test").
> Create a 'bond' interface (eg "test0") in the namespace.
> 
> Then /proc/net/bonding/test0 only exists inside the namespace.
> 
> However if you run a program in the "test" namespace that does:
> - create a thread.
> - change the main thread to in "init" namespace.
> - try to open /proc/net/bonding/test0 in the thread.
> then the open fails.
> 
> I don't know how much else is affected and haven't tried
> to bisect (I can't create bonds on my normal test kernel).
> 
> The test program below shows the problem.
> Compile and run as:
> # ip netns exec test strace -f test_prog /proc/net/bonding/test0
> 
> The second open by the child should succeed, but fails.
> 
> I can't see any changes to the bonding code, so I suspect
> it is something much more fundamental.
> It might only affect /proc/net, but it might also affect
> which namespace sockets get created in.
> IIRC ls -l /proc/n/task/*/ns gives the correct namespaces.
> 
> 	David
> 
> 
> #define _GNU_SOURCE
> 
> #include <fcntl.h>
> #include <unistd.h>
> #include <poll.h>
> #include <pthread.h>
> #include <sched.h>
> 
> #define delay(secs) poll(0,0, (secs) * 1000)
> 
> static void *thread_fn(void *file)
> {
>         delay(2);
>         open(file, O_RDONLY);
> 
>         delay(5);
>         open(file, O_RDONLY);
> 
>         return NULL;
> }
> 
> int main(int argc, char **argv)
> {
>         pthread_t id;
> 
>         pthread_create(&id, NULL, thread_fn, argv[1]);
> 
>         delay(1);
>         open(argv[1], O_RDONLY);
> 
>         delay(2);
>         setns(open("/proc/1/ns/net", O_RDONLY), 0);
> 
>         delay(1);
>         open(argv[1], O_RDONLY);
> 
>         delay(4);
> 
>         return 0;
> }
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

Thanks for the report. To be sure below issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
tracking bot:

#regzbot ^introduced v5.10.105..v5.10.132
#regzbot title setns() affecting other threads (also in 6.0-rc)
#regzbot ignore-activity

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
