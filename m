Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECC023DE45
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbgHFRYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729497AbgHFREp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:04:45 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2BEC03460D
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 05:39:13 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id ACF60C009; Thu,  6 Aug 2020 14:39:04 +0200 (CEST)
Date:   Thu, 6 Aug 2020 14:38:49 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     v9fs-developer@lists.sourceforge.net, Greg Kurz <groug@kaod.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: 9p/trans_fd lockup
Message-ID: <20200806123849.GA2640@nautica>
References: <9d8a8abf-7968-2752-89e7-bac39ae91999@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9d8a8abf-7968-2752-89e7-bac39ae91999@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexey Kardashevskiy wrote on Thu, Aug 06, 2020:
> I am seeing another bug in 9p under syzkaller, the reprocase is:
> 
> r0 = open$dir(&(0x7f0000000040)='./file0\x00', 0x88142, 0x182)
> 
> r1 = openat$null(0xffffffffffffff9c, &(0x7f0000000640)='/dev/null\x00',
> 0x0, 0x0)
> mount$9p_fd(0x0, &(0x7f0000000000)='./file0\x00',
> &(0x7f00000000c0)='9p\x00', 0x0, &(0x7f0000000100)={'trans=fd,',
> {'rfdno', 0x3d, r1}, 0x2$, {'wfdno', 0x3d, r0}})
> 
> 
> 
> The default behaviour of syzkaller is to call syscalls concurrently (I
> think), at least it forks by default and executes the same sequence in
> both threads.
> 
> In this example both threads makes it to:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/9p/client.c?h=v5.8#n757
> 
> and sit there with the only difference which is thread#1 goes via
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/9p/client.c?h=v5.8#n767
> 
> I am pretty sure things should not have gone that far but I cannot
> clearly see what needs fixing. Ideas? Thanks,

Unkillable threads there happen with the current p9_client_rpc when
there is no real server (or server bug etc); the code is really stupid.

Basically what happens is that when you send a first signal (^C or
whatever), the function catches the signal, sends a flush, and
indefinitely waits for the flush to come back.
If you send another signal there no more flush comes but it goes back to
waiting -- it's using wait_event_killable but it's a lie it's not really
killable it just loops on that wait until the flush finally comes, which
will never come in your case.
(the rpc that came by the way is probably version or whatever is first
done on mount)


Dmitry reported that to me ages ago and I have a fix which is just to
stop waiting for the flush -- just make it asynchronous, send and
forget. That removes the whole signal handling logic and it won't hang
there anymore.

I sent the patches to the list last year, but didn't get much feedback
and didn't have time to run all the tests I wanted to run on it.


I have some free time at the end of the month so I was planning to
finish it for 5.10 (e.g. won't send it for 5.9 but once 5.9 initial
merge window passed leave it in -next for a couple of months and push it
for 5.10), so your timing is pretty good :)
An extra pair of eyes would be more than appreciated.

You can find the original mails there:
https://lore.kernel.org/lkml/1544532108-21689-3-git-send-email-asmadeus@codewreck.org/

They're also in my 9p-test branch on git://github.com/martinetd/linux


Cheers & thanks for the attention,
-- 
Dominique
