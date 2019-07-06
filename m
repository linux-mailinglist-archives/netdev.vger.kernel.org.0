Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2177961223
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 18:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfGFQRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 12:17:01 -0400
Received: from smtpq1.tb.mail.iss.as9143.net ([212.54.42.164]:57208 "EHLO
        smtpq1.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726712AbfGFQRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 12:17:00 -0400
Received: from [212.54.42.117] (helo=lsmtp3.tb.mail.iss.as9143.net)
        by smtpq1.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <carlo@alinoe.com>)
        id 1hjnMv-0004vb-LO; Sat, 06 Jul 2019 18:16:57 +0200
Received: from 92-109-146-195.cable.dynamic.v4.ziggo.nl ([92.109.146.195] helo=mail9.alinoe.com)
        by lsmtp3.tb.mail.iss.as9143.net with esmtp (Exim 4.90_1)
        (envelope-from <carlo@alinoe.com>)
        id 1hjnMv-0001St-HZ; Sat, 06 Jul 2019 18:16:57 +0200
Received: from carlo by mail9.alinoe.com with local (Exim 4.86_2)
        (envelope-from <carlo@alinoe.com>)
        id 1hjnMv-0004O2-1f; Sat, 06 Jul 2019 18:16:57 +0200
Date:   Sat, 6 Jul 2019 18:16:57 +0200
From:   Carlo Wood <carlo@alinoe.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: Kernel BUG: epoll_wait() (and epoll_pwait) stall for 206 ms per
 call on sockets with a small-ish snd/rcv buffer.
Message-ID: <20190706181657.7ff57395@hikaru>
In-Reply-To: <20190706034508.43aabff0@hikaru>
References: <20190706034508.43aabff0@hikaru>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: carlo@alinoe.com
X-SA-Exim-Scanned: No (on mail9.alinoe.com); SAEximRunCond expanded to false
X-SourceIP: 92.109.146.195
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=JMuPTPCb c=1 sm=1 tr=0 a=at3gEZHPcpTZPMkiLtqVSg==:17 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10 a=wuZ7hZSPAAAA:20 a=BjFOTwK7AAAA:8 a=iakwcyFGwDD5B9_yiY4A:9 a=CjuIK1q_8ugA:10 a=N3Up1mgHhB-0MyeZKEz1:22
X-Ziggo-Spam-Status: No
X-Spam-Status: No
X-Spam-Flag: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I improved the test case a bit:

https://github.com/CarloWood/ai-evio-testsuite/blob/2a9ae49e3ae39eea7cb1d105883254370f53831b/src/epoll_bug.c

If the bug doesn't show, please increase burst_size and/or decrease
sndbuf_size and rcvbuf_size.

The output that I get with VERBOSE defined is for example:

[...snip...]
wrote 34784 bytes to 6 (total written now 9665792), now in pipe line: 34784
Read 34784 bytes from fd 5 (total read now 9665792), left in pipe line: 0
wrote 34784 bytes to 6 (total written now 9700576), now in pipe line: 34784
Read 34784 bytes from fd 5 (total read now 9700576), left in pipe line: 0
wrote 34784 bytes to 6 (total written now 9735360), now in pipe line: 34784
Read 34784 bytes from fd 5 (total read now 9735360), left in pipe line: 0
wrote 34784 bytes to 6 (total written now 9770144), now in pipe line: 34784
Read 34784 bytes from fd 5 (total read now 9770144), left in pipe line: 0
wrote 34784 bytes to 6 (total written now 9804928), now in pipe line: 34784
Read 34784 bytes from fd 5 (total read now 9804928), left in pipe line: 0
wrote 34784 bytes to 6 (total written now 9839712), now in pipe line: 34784
Read 34784 bytes from fd 5 (total read now 9839712), left in pipe line: 0
wrote 34784 bytes to 6 (total written now 9874496), now in pipe line: 34784
Read 34784 bytes from fd 5 (total read now 9874496), left in pipe line: 0
wrote 34784 bytes to 6 (total written now 9909280), now in pipe line: 34784
Read 34784 bytes from fd 5 (total read now 9909280), left in pipe line: 0
wrote 34784 bytes to 6 (total written now 9944064), now in pipe line: 34784
Read 34784 bytes from fd 5 (total read now 9944064), left in pipe line: 0
wrote 34784 bytes to 6 (total written now 9978848), now in pipe line: 34784
Read 34784 bytes from fd 5 (total read now 9978848), left in pipe line: 0
wrote 21152 bytes to 6 (total written now 10000000), now in pipe line: 21152
Read 21152 bytes from fd 5 (total read now 10000000), left in pipe line: 0
epoll_wait() stalled 193 milliseconds!
Read 21888 bytes from fd 6 (total read now 70912), left in pipe line: 21888
epoll_wait() stalled 255 milliseconds!
Read 21888 bytes from fd 6 (total read now 92800), left in pipe line: 0
write(5, buf, 9907200) = 43776 (total written now 136576), now in pipe line: 43776
epoll_wait() stalled 211 milliseconds!
Read 21888 bytes from fd 6 (total read now 114688), left in pipe line: 21888
epoll_wait() stalled 207 milliseconds!
write(5, buf, 9863424) = 38272 (total written now 174848), now in pipe line: 60160
Read 16384 bytes from fd 6 (total read now 131072), left in pipe line: 43776
epoll_wait() stalled 207 milliseconds!
Read 21888 bytes from fd 6 (total read now 152960), left in pipe line: 21888
epoll_wait() stalled 207 milliseconds!
Read 21888 bytes from fd 6 (total read now 174848), left in pipe line: 0
write(5, buf, 9825152) = 43776 (total written now 218624), now in pipe line: 43776
epoll_wait() stalled 207 milliseconds!
Read 21888 bytes from fd 6 (total read now 196736), left in pipe line: 21888
epoll_wait() stalled 211 milliseconds!
Read 21888 bytes from fd 6 (total read now 218624), left in pipe line: 0
write(5, buf, 9781376) = 43776 (total written now 262400), now in pipe line: 43776
epoll_wait() stalled 207 milliseconds!
Read 21888 bytes from fd 6 (total read now 240512), left in pipe line: 21888
epoll_wait() stalled 207 milliseconds!
Read 21888 bytes from fd 6 (total read now 262400), left in pipe line: 0
write(5, buf, 9737600) = 43776 (total written now 306176), now in pipe line: 43776
epoll_wait() stalled 207 milliseconds!
Read 21888 bytes from fd 6 (total read now 284288), left in pipe line: 21888
epoll_wait() stalled 207 milliseconds!
Read 21888 bytes from fd 6 (total read now 306176), left in pipe line: 0
write(5, buf, 9693824) = 43776 (total written now 349952), now in pipe line: 43776
epoll_wait() stalled 207 milliseconds!
Read 21888 bytes from fd 6 (total read now 328064), left in pipe line: 21888
epoll_wait() stalled 207 milliseconds!
write(5, buf, 9650048) = 38272 (total written now 388224), now in pipe line: 60160
Read 16384 bytes from fd 6 (total read now 344448), left in pipe line: 43776
epoll_wait() stalled 207 milliseconds!
... etc. etc.


It seems that the problem always occur right after stopping to write data in one
direction, and then happens for the way back.

In the case above the burst_size is set to 10000000 bytes, and it writes
that amount and reads it on the other side successfully.

What I think is going on however is that the data on the way back is stalling,
during which the "forward" burst finishes (without the epoll_wait stalling it
is VERY fast). Above you see:

Read 21152 bytes from fd 5 (total read now 10000000), left in pipe line: 0
epoll_wait() stalled 193 milliseconds!

But since we know that the stall always seems to be 207ms, I'm pretty sure
that actually it stalled 14 ms before that, and needed 14 ms to finish the
complete burst in one direction.

-- 
Carlo Wood <carlo@alinoe.com>
