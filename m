Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0599E6129F
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 20:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfGFSTQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 6 Jul 2019 14:19:16 -0400
Received: from smtpq2.tb.mail.iss.as9143.net ([212.54.42.165]:36528 "EHLO
        smtpq2.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726915AbfGFSTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 14:19:16 -0400
Received: from [212.54.42.118] (helo=lsmtp4.tb.mail.iss.as9143.net)
        by smtpq2.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <carlo@alinoe.com>)
        id 1hjpHE-0001A5-NW; Sat, 06 Jul 2019 20:19:12 +0200
Received: from 92-109-146-195.cable.dynamic.v4.ziggo.nl ([92.109.146.195] helo=mail9.alinoe.com)
        by lsmtp4.tb.mail.iss.as9143.net with esmtp (Exim 4.90_1)
        (envelope-from <carlo@alinoe.com>)
        id 1hjpHE-0006yS-Jb; Sat, 06 Jul 2019 20:19:12 +0200
Received: from carlo by mail9.alinoe.com with local (Exim 4.86_2)
        (envelope-from <carlo@alinoe.com>)
        id 1hjpHE-00052R-2L; Sat, 06 Jul 2019 20:19:12 +0200
Date:   Sat, 6 Jul 2019 20:19:12 +0200
From:   Carlo Wood <carlo@alinoe.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: Kernel BUG: epoll_wait() (and epoll_pwait) stall for 206 ms per
 call on sockets with a small-ish snd/rcv buffer.
Message-ID: <20190706201912.435a2198@hikaru>
In-Reply-To: <20190706181657.7ff57395@hikaru>
References: <20190706034508.43aabff0@hikaru>
        <20190706181657.7ff57395@hikaru>
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: carlo@alinoe.com
X-SA-Exim-Scanned: No (on mail9.alinoe.com); SAEximRunCond expanded to false
X-SourceIP: 92.109.146.195
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=NctSKFL4 c=1 sm=1 tr=0 a=at3gEZHPcpTZPMkiLtqVSg==:17 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=0o9FgrsRnhwA:10 a=Qe8Hpcv0AAAA:8 a=wuZ7hZSPAAAA:20 a=BjFOTwK7AAAA:8 a=zeWDRvjyIi8Npy4PmSMA:9 a=QEXdDO2ut3YA:10 a=yKMzZGYFBacA:10 a=IOP3eqZidv-wVSFUCvwm:22 a=N3Up1mgHhB-0MyeZKEz1:22
X-Ziggo-Spam-Status: No
X-Spam-Status: No
X-Spam-Flag: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While investigating this further, I read on
http://www.masterraghu.com/subjects/np/introduction/unix_network_programming_v1.3/ch07lev1sec5.html
under "SO_RCVBUF and SO_SNDBUF Socket Options":

    When setting the size of the TCP socket receive buffer, the
    ordering of the function calls is important. This is because of
    TCP's window scale option (Section 2.6), which is exchanged with
    the peer on the SYN segments when the connection is established.
    For a client, this means the SO_RCVBUF socket option must be set
    before calling connect. For a server, this means the socket option
    must be set for the listening socket before calling listen. Setting
    this option for the connected socket will have no effect whatsoever
    on the possible window scale option because accept does not return
    with the connected socket until TCP's three-way handshake is
    complete. That is why this option must be set for the listening
    socket. (The sizes of the socket buffers are always inherited from
    the listening socket by the newly created connected socket: pp.
    462–463 of TCPv2.)

As mentioned in a previous post, I had already discovered about
needing to set the socket buffers before connect, but I didn't know
about setting them before the call to listen() in order to get the
buffer sizes inherited by the accepted sockets.

After fixing this in my test program, all problems disappeared when
keeping the send and receive buffers the same on both sides.

However, when only setting the send and receive buffers on the client
socket (not on the (accepted or) listen socket), epoll_wait() still
stalls 43ms. When the SO_SNDBUF is smaller than 33182 bytes.

Here is the latest version of my test program:

https://github.com/CarloWood/ai-evio-testsuite/blob/master/src/epoll_bug.c

I have to retract most of my "bug" report, it might even not really be
a bug then... but nevertheless, what remains strange is the fact
that setting the socket buffer sizes on the accepted sockets can lead
to so much crippling effect, while the quoted website states:

    Setting this option for the connected socket will have no effect
    whatsoever on the possible window scale option because accept does
    not return with the connected socket until TCP's three-way
    handshake is complete.

And when only setting the socket buffer sizes for the client socket
(that I use to send back received data; so this is the sending
side now) then why does epoll_wait() stall 43 ms per call when the
receiving side is using the default (much larger) socket buffer sizes?

That 43 ms is STILL crippling-- slowing down the transmission of the
data to a trickling speed compared to what it should be.
 
-- 
Carlo Wood <carlo@alinoe.com>
