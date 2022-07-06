Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C77C568E63
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiGFPyk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 Jul 2022 11:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiGFPyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:54:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D33FB10AB
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 08:54:21 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-149-WXRw_waaN9Wb-VDZWhrQPw-1; Wed, 06 Jul 2022 16:54:19 +0100
X-MC-Unique: WXRw_waaN9Wb-VDZWhrQPw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 6 Jul 2022 16:54:18 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Wed, 6 Jul 2022 16:54:18 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: rawip: delayed and mis-sequenced transmits
Thread-Topic: rawip: delayed and mis-sequenced transmits
Thread-Index: AdiRRdPsy1CkLIz2RqC6CNg1z+fBBw==
Date:   Wed, 6 Jul 2022 15:54:18 +0000
Message-ID: <433be56da42f4ab2b7722c1caed3a747@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm seeing some UDP packets being significantly delayed (even 200ms)
and then being received immediately after another packet.
During the delay other packets are received on the same UDP socket.
The receiving program is very simple - so the problem must be
with the sender.

The sender is designed to send a lot of packets, but in this case
two packets are sent every 20ms.
While the two packets have the same UDP port numbers, they are
different application data streams.

The sender has a lot of threads that can send packets, each uses
a single 'rawip' socket (to avoid contention on the socket lock).
It is pretty random (but heavily biased) which threads actually send
the packets.
However it is pretty much certain that the two sends will be done
by different threads at almost exactly the same time.

I've not yet tried to find where the packets get queued, never
mind why. But my best guess is they are stuck on a queue
associated with the sending socket.

But the only reason I can see for a queue on the socket is to
allow the socket lock be dropped while a packet is passed to
the ethernet driver.
So a send from a second thread would queue a packet and it would
be picked up when the earlier transmit completes.
This is actually consistent with what I'm seeing - the end of tx
picks up a packet that was queued earlier.
But in my case the packet was queued much, much earlier.
And the earlier send was done by the same thread.

So what I think must be happening is that contention further
down the protocol stack is causing the packet be queued on the
sending socket instead of (probably) the qdisc layer.

Usually tx packets (seem to) get queued in the qdisc layer and
collected when the thread currently doing a tx setup returns
from the ethernet driver.
So I'm not at all sure why, at least sometimes, packets are
being queued on the socket.

I have got 'threaded napi' enabled (to avoid losing rx packets)
but nothing unusual is enabled on the tx side.
Ethernet is tg3 - single tx ring.

Anyone any ideas before I start digging through the kernel code?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

