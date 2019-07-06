Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F37A60E7A
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 04:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfGFCFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 22:05:15 -0400
Received: from smtpq1.tb.mail.iss.as9143.net ([212.54.42.164]:46824 "EHLO
        smtpq1.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725878AbfGFCFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 22:05:15 -0400
X-Greylist: delayed 1204 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jul 2019 22:05:14 EDT
Received: from [212.54.42.116] (helo=lsmtp2.tb.mail.iss.as9143.net)
        by smtpq1.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <carlo@alinoe.com>)
        id 1hjZlE-0005ru-Ur; Sat, 06 Jul 2019 03:45:08 +0200
Received: from 92-109-146-195.cable.dynamic.v4.ziggo.nl ([92.109.146.195] helo=mail9.alinoe.com)
        by lsmtp2.tb.mail.iss.as9143.net with esmtp (Exim 4.90_1)
        (envelope-from <carlo@alinoe.com>)
        id 1hjZlE-0000XQ-RB; Sat, 06 Jul 2019 03:45:08 +0200
Received: from carlo by mail9.alinoe.com with local (Exim 4.86_2)
        (envelope-from <carlo@alinoe.com>)
        id 1hjZlE-0008Mn-Ay; Sat, 06 Jul 2019 03:45:08 +0200
Date:   Sat, 6 Jul 2019 03:45:08 +0200
From:   Carlo Wood <carlo@alinoe.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Subject: epoll_wait() (and epoll_pwait) stall for 206 ms per call on sockets
 with a small-ish snd/rcv buffer.
Message-ID: <20190706034508.43aabff0@hikaru>
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
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=T6A4sMCQ c=1 sm=1 tr=0 a=at3gEZHPcpTZPMkiLtqVSg==:17 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10 a=wuZ7hZSPAAAA:20 a=BjFOTwK7AAAA:8 a=oT9XYXiVWPge-gFa0EkA:9 a=B5CQuviRsAY1c27Y:21 a=3ffTBhku1zIx7Z6q:21 a=CjuIK1q_8ugA:10 a=N3Up1mgHhB-0MyeZKEz1:22
X-Ziggo-Spam-Status: No
X-Spam-Status: No
X-Spam-Flag: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

hopefully I'm reporting this in the right place.

While working on my C++ networking library, I ran into a problem that
I have traced back to the kernel itself.

The problem is related to setting a socket buffer size (snd/rcv).

At first I noticed the problem while trying to test the thread-safety
of my lock free stream buffer implementation, with std::streambuf
interface, that allows reading and writing by different threads
at the same time. In order to test this, I read data from a socket
into a buffer and write that back to the same socket from the
same buffer. This resulted in a speed of only a few 10kB/s bandwidth,
and after investigation turned out to be caused by epoll_pwait()
not returning until 205 to 208 ms had passed, even though data was
already available.

At first I thought it could be a bug in libev that I was using as
wrapper around epoll - so I ripped that out and wrote my own code to
interface with epoll, but with the same result. Next I changed the test
into a one-way stream: just send data from one socket to another (not
back); also with the same result. Then I wrote a test application that
was standalone, single threaded and in C. Here I discovered that first
calling connect() on a socket and then (immediately after) setting the
socket buffer sizes caused the stall to occur. Assuming that this
is not allowed I thought I had solved it.

But, back to sending data back and forth over the TCP connection
caused the problem to return.

I wrote again a standalone C program, single threaded, that
reproduces the problem.

You can find this program here (I'm scared to trigger spam filters
by attaching it here, but let me know if that is OK):
https://github.com/CarloWood/ai-evio-testsuite/blob/e6e36b66256ec5d1760d2b7b96b34d60a12477aa/src/epoll_bug.c

With socket snd/rcv buffers smaller than 32kB I always get
the problem, but using 64kB (65536 bytes) I don't, on my box.

I tested this with kernels 4.15, 5.2.0-rc7 and had someone
else confirm it with 5.1.15.

When running the program as-is, it will start printing a flood
of "epoll_wait() was delayed!" meaning that epoll_wait() didn't
return within 10 ms. The actual delay can be seen with for
example strace -T. You can also uncomment the commented printf's
which will print what is the amount of bytes written to and read
from each socket and therefore what is the number of bytes that
are still "in the pipe line".

What I observe is that the number of bytes in the pipe line is
very constant (because this just writes till no more can be
written, and then - on the other end - reads till there is nothing
to be read anymore - and that single threaded) until suddenly
that amount jumps UP to about 2.5 MB - then is SLOWLY eaten till
a say 1.5 MB (without that epoll says more can be written)
when suddenly more can be written and it fills up the pipe line
again.

I have no idea where those mega bytes of data are buffered; the
socket buffers are WAY smaller.

Obviously I have no idea if this is a problem with epoll itself,
or that there is a problem with TCP/IP for this case.
But I am not a kernel hacker, so all I could to was provide this
little test case that allows you to reproduce it.

-- 
Carlo Wood <carlo@alinoe.com>
