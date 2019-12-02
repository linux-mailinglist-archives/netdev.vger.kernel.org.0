Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB2F10EA08
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 13:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfLBMYO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Dec 2019 07:24:14 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:34649 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727362AbfLBMYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 07:24:13 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-209-ir8GbxBaO_GtMP1WeUlcjw-1; Mon, 02 Dec 2019 12:24:10 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 2 Dec 2019 12:24:09 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 2 Dec 2019 12:24:09 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Sitnicki' <jakub@cloudflare.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "network dev" <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: RE: epoll_wait() performance
Thread-Topic: epoll_wait() performance
Thread-Index: AdWgk3jgEIFNwcnRS6+4A+/jFPxTuQEdLCCAAAAn2qAADa2dEAAA53BgAAHhYYAAIluz0ABrirS6AFywc0A=
Date:   Mon, 2 Dec 2019 12:24:09 +0000
Message-ID: <40f7b16289274e10a30f5d8c6e2cdf08@AcuMS.aculab.com>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
 <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
 <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
 <20191127164821.1c41deff@carbon>
 <0b8d7447e129539aec559fa797c07047f5a6a1b2.camel@redhat.com>
 <2f1635d9300a4bec8a0422e9e9518751@AcuMS.aculab.com>
 <313204cf-69fd-ec28-a22c-61526f1dea8b@gmail.com>
 <1265e30d04484d08b86ba2abef5f5822@AcuMS.aculab.com>
 <c46e43d1-ba7d-39d9-688f-0141931df1b0@gmail.com>
 <878snxo5kq.fsf@cloudflare.com>
In-Reply-To: <878snxo5kq.fsf@cloudflare.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: ir8GbxBaO_GtMP1WeUlcjw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>
> Sent: 30 November 2019 13:30
> On Sat, Nov 30, 2019 at 02:07 AM CET, Eric Dumazet wrote:
> > On 11/28/19 2:17 AM, David Laight wrote:
...
> >> How can you do that when all the UDP flows have different destination port numbers?
> >> These are message flows not idempotent requests.
> >> I don't really want to collect the packets before they've been processed by IP.
> >>
> >> I could write a driver that uses kernel udp sockets to generate a single message queue
> >> than can be efficiently processed from userspace - but it is a faff compiling it for
> >> the systems kernel version.
> >
> > Well if destinations ports are not under your control,
> > you also could use AF_PACKET sockets, no need for 'UDP sockets' to receive UDP traffic,
> > especially it the rate is small.
> 
> Alternatively, you could steer UDP flows coming to a certain port range
> to one UDP socket using TPROXY [0, 1].

I don't think that can work, we don't really know the list of valid UDP port
numbers ahead of time.

> TPROXY has the same downside as AF_PACKET, meaning that it requires at
> least CAP_NET_RAW to create/set up the socket.

CAP_NET_RAW wouldn't be a problem - we already send from a 'raw' socket.
(Which is a PITA for IPv4 because we have to determine the local IP address
in order to calculate the UDP checksum - so we have to have a local copy
of what (hopefully) matches the kernel routing tables.

> OTOH, with TPROXY you can gracefully co-reside with other services,
> filtering on just the destination addresses you want in iptables/nftables.

Yes, the packets need to be extracted from normal processing - otherwise
the UDP code would send ICMP port unreachable errors.

> 
> Fan-out / load-balancing with reuseport to have one socket per CPU is
> not possible, though. You would need to do that with Netfilter.

Or put different port ranges onto different sockets.
 
> [0] https://www.kernel.org/doc/Documentation/networking/tproxy.txt
> [1] https://blog.cloudflare.com/how-we-built-spectrum/

The latter explains it a bit better than the former....

I think I'll try to understand the 'ftrace' documentation enough to add some
extra trace points to those displayed by shedviz.
So far I've only found some trivial example uses, not any actual docs.
Hopefully there is a faster way than reading the kernel sources :-(

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

