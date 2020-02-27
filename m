Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7520171883
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 14:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgB0NTU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Feb 2020 08:19:20 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:54562 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729088AbgB0NTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 08:19:20 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-97-AtnrpEANOW2WKzaBD74Z0g-1; Thu, 27 Feb 2020 13:19:16 +0000
X-MC-Unique: AtnrpEANOW2WKzaBD74Z0g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 27 Feb 2020 13:19:15 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 27 Feb 2020 13:19:15 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     netdev <netdev@vger.kernel.org>
Subject: sys_sendto() spinning for 1.6ms
Thread-Topic: sys_sendto() spinning for 1.6ms
Thread-Index: AdXtbb8kfVfk26r1Rfib7iXWKp20CA==
Date:   Thu, 27 Feb 2020 13:19:15 +0000
Message-ID: <303c8600e4964d1593b038239779ba4b@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm looking into unexpected delays in some real time (RTP audio) processing.
Mostly they are a few 100 usecs in the softint code.

However I've just triggered in sendto() on a raw IPV4 socket taking 1.6ms.
Most of the sends take less than 32us.
The process isn't sleeping and there are no interrupts.
Any idea where it might be spinning?

I'm running ftrace monitoring scheduler events, system calls and
interrupts (hard and soft) but can't turn on anything other than
selective function trace (the trace cost is far too high).

The ftrace at the time of the sendto() is (I'm only running 4 cpu):
    pid-28219 [002] .... 1979891.159912: sys_sendto(fd: 394, buff: 7ffbcb2e2940, len: c8, flags: 0, addr: 7ffbccdc9490, addr_len: 10)
    pid-28217 [003] .... 1979891.159912: sys_recvfrom(fd: 23c, ubuf: 7ffbcb1db100, size: 748, flags: 0, addr: 7ffbcddcb5b0, addr_len: 7ffbcddcb5ac)
    pid-28218 [001] .... 1979891.159912: sys_futex(uaddr: 113d8e0, op: 80, val: 2, utime: 0, uaddr2: 113d8e0, val3: 6e3a)
    pid-28216 [000] .... 1979891.159912: sys_futex(uaddr: 113d8e0, op: 81, val: 1, utime: 7ffbce5cc920, uaddr2: 113d8e0, val3: 6e38)
    pid-28217 [003] .... 1979891.159912: sys_recvfrom -> 0xac

Cpu 2 trace is:
    pid-28219 [002] .... 1979891.159910: sys_futex(uaddr: 113d8e0, op: 81, val: 1, utime: 7ffbccdc9920, uaddr2: 113d8e0, val3: 6e3b)
    pid-28219 [002] .... 1979891.159911: sys_futex -> 0x0
    pid-28219 [002] .... 1979891.159912: sys_sendto(fd: 394, buff: 7ffbcb2e2940, len: c8, flags: 0, addr: 7ffbccdc9490, addr_len: 10)
    pid-28219 [002] .... 1979891.161647: sys_sendto -> 0xc8
    pid-28219 [002] .... 1979891.161648: sys_pread64(fd: 3ae, buf: 7ffbccdc9420, count: 1, pos: 0)
    pid-28219 [002] .... 1979891.161650: sys_pread64 -> 0x1
    pid-28219 [002] .... 1979891.161651: sys_pwrite64(fd: 3ae, buf: d495e8, count: 1, pos: 0)

The previous send on fd 394 was much earlier and that socket is only used
by that process, and only for sends (to avoid sleeping on the socket lock).

It can't be an problem with the socket send buffer - because that would sleep.

The other 3 cpu carry on processing (the futex calls return immediately).
In fact they all sleep 1.4ms before the sento() finishes.

At the moment the trace is a sample of 1 - so I don't know if the concurrent
sento() and recvfrom() are significant.
They will both be the same remote IP, and might be the same port.

Ideas before I start trying to bisect the call graph?

A rough histogram of the time (ns) for the sendto() call.
0k: 71866866
48k: 99213
80k: 3583
112k: 371
144k: 245
176k: 694
208k: 382
240k: 214
272k: 20
304k: 13
336k: 15
368k: 13
400k: 11
432k: 14
464k: 12
496k: 7
528k: 10
560k: 2
592k: 1
624k: 2
656k: 1
688k: 0 (twice)
752k: 1
784k: 0 (twice)
848k: 1
880k: 1
912k: 0 (24 times)
1680k: 1

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

