Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93AB410B2E7
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfK0QER convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Nov 2019 11:04:17 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:34350 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbfK0QEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:04:16 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-18-Aa6kDxC7OPi54Qqo1k4BMw-1; Wed, 27 Nov 2019 16:04:12 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 27 Nov 2019 16:04:12 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 27 Nov 2019 16:04:12 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jesper Dangaard Brouer' <brouer@redhat.com>
CC:     'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: epoll_wait() performance
Thread-Topic: epoll_wait() performance
Thread-Index: AdWgk3jgEIFNwcnRS6+4A+/jFPxTuQEdLCCAAAAn2qAADFPagAAAV68A
Date:   Wed, 27 Nov 2019 16:04:12 +0000
Message-ID: <5eecf41c7e124d7dbc0ab363d94b7d13@AcuMS.aculab.com>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
        <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
        <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
 <20191127164821.1c41deff@carbon>
In-Reply-To: <20191127164821.1c41deff@carbon>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: Aa6kDxC7OPi54Qqo1k4BMw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer
> Sent: 27 November 2019 15:48
> On Wed, 27 Nov 2019 10:39:44 +0000 David Laight <David.Laight@ACULAB.COM> wrote:
> 
> > ...
> > > > While using recvmmsg() to read multiple messages might seem a good idea, it is much
> > > > slower than recv() when there is only one message (even recvmsg() is a lot slower).
> > > > (I'm not sure why the code paths are so slow, I suspect it is all the copy_from_user()
> > > > and faffing with the user iov[].)
> > > >
> > > > So using poll() we repoll the fd after calling recv() to find is there is a second message.
> > > > However the second poll has a significant performance cost (but less than using recvmmsg()).
> > >
> > > That sounds wrong. Single recvmmsg(), even when receiving only a
> > > single message, should be faster than two syscalls - recv() and
> > > poll().
> >
> > My suspicion is the extra two copy_from_user() needed for each recvmsg are a
> > significant overhead, most likely due to the crappy code that tries to stop
> > the kernel buffer being overrun.
> >
> > I need to run the tests on a system with a 'home built' kernel to see how much
> > difference this make (by seeing how much slower duplicating the copy makes it).
> >
> > The system call cost of poll() gets factored over a reasonable number of sockets.
> > So doing poll() on a socket with no data is a lot faster that the setup for recvmsg
> > even allowing for looking up the fd.
> >
> > This could be fixed by an extra flag to recvmmsg() to indicate that you only really
> > expect one message and to call the poll() function before each subsequent receive.
> >
> > There is also the 'reschedule' that Eric added to the loop in recvmmsg.
> > I don't know how much that actually costs.
> > In this case the process is likely to be running at a RT priority and pinned to a cpu.
> > In some cases the cpu is also reserved (at boot time) so that 'random' other code can't use it.
> >
> > We really do want to receive all these UDP packets in a timely manner.
> > Although very low latency isn't itself an issue.
> > The data is telephony audio with (typically) one packet every 20ms.
> > The code only looks for packets every 10ms - that helps no end since, in principle,
> > only a single poll()/epoll_wait() call (on all the sockets) is needed every 10ms.
> 
> I have a simple udp_sink tool[1] that cycle through the different
> receive socket system calls.  I gave it a quick spin on a F31 kernel
> 5.3.12-300.fc31.x86_64 on a mlx5 100G interface, and I'm very surprised
> to see a significant regression/slowdown for recvMmsg.
> 
> $ sudo ./udp_sink --port 9 --repeat 1 --count $((10**7))
>           	run      count   	ns/pkt	pps		cycles	payload
> recvMmsg/32  	run:  0	10000000	1461.41	684270.96	5261	18	 demux:1
> recvmsg   	run:  0	10000000	889.82	1123824.84	3203	18	 demux:1
> read      	run:  0	10000000	974.81	1025841.68	3509	18	 demux:1
> recvfrom  	run:  0	10000000	1056.51	946513.44	3803	18	 demux:1
> 
> Normal recvmsg almost have double performance that recvmmsg.
>  recvMmsg/32 = 684,270 pps
>  recvmsg     = 1,123,824 pps

Can you test recv() as well?
I think it might be faster than read().

...
> Found some old results (approx v4.10-rc1):
> 
> [brouer@skylake src]$ sudo taskset -c 2 ./udp_sink --count $((10**7)) --port 9 --connect
>  recvMmsg/32    run: 0 10000000 537.89  1859106.74      2155    21559353816
>  recvmsg        run: 0 10000000 552.69  1809344.44      2215    22152468673
>  read           run: 0 10000000 476.65  2097970.76      1910    19104864199
>  recvfrom       run: 0 10000000 450.76  2218492.60      1806    18066972794

That is probably nearer what I am seeing on a 4.15 Ubuntu 18.04 kernel.
recvmmsg() and recvmsg() are similar - but both a lot slower then recv().

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

