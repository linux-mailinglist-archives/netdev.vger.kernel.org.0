Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19FD10CCE5
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 17:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfK1QhG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 Nov 2019 11:37:06 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:52315 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726520AbfK1QhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 11:37:05 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-230-AxEAhMhqPBirovqvBRqSxg-1; Thu, 28 Nov 2019 16:37:02 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 28 Nov 2019 16:37:01 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 28 Nov 2019 16:37:01 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jesper Dangaard Brouer' <brouer@redhat.com>
CC:     'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: epoll_wait() performance
Thread-Topic: epoll_wait() performance
Thread-Index: AdWgk3jgEIFNwcnRS6+4A+/jFPxTuQEdLCCAAAAn2qAADFPagAAAV68AAChM6IAACxvV8A==
Date:   Thu, 28 Nov 2019 16:37:01 +0000
Message-ID: <b71441bb2fa14bc7b583de643a1ccf8b@AcuMS.aculab.com>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
        <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
        <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
        <20191127164821.1c41deff@carbon>
        <5eecf41c7e124d7dbc0ab363d94b7d13@AcuMS.aculab.com>
 <20191128121205.65c8dea1@carbon>
In-Reply-To: <20191128121205.65c8dea1@carbon>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: AxEAhMhqPBirovqvBRqSxg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer
> Sent: 28 November 2019 11:12
...
> > Can you test recv() as well?
> 
> Sure: https://github.com/netoptimizer/network-testing/commit/9e3c8b86a2d662
> 
> $ sudo taskset -c 1 ./udp_sink --port 9  --count $((10**6*2))
>           	run      count   	ns/pkt	pps		cycles	payload
> recvMmsg/32  	run:  0	 2000000	653.29	1530704.29	2351	18	 demux:1
> recvmsg   	run:  0	 2000000	631.01	1584760.06	2271	18	 demux:1
> read      	run:  0	 2000000	582.24	1717518.16	2096	18	 demux:1
> recvfrom  	run:  0	 2000000	547.26	1827269.12	1970	18	 demux:1
> recv      	run:  0	 2000000	547.37	1826930.39	1970	18	 demux:1
> 
> > I think it might be faster than read().
> 
> Slightly, but same speed as recvfrom.

I notice that you recvfrom() code doesn't request the source address.
So is probably identical to recv().

My test system tends to increase its clock rate when busy.
(The fans speed up immediately, the cpu has a passive heatsink and all the
case fans are connected (via buffers) to the motherboard 'cpu fan' header.)
I could probably work out how to lock the frequency, but for some tests I run:
$ while :; do :; done
Putting 1 cpu into a userspace infinite loop make them all run flat out
(until thermally throttled).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

