Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AA2305816
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbhA0KSE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Jan 2021 05:18:04 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:40593 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235732AbhA0KPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 05:15:53 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-29-zmoLVMLnMvui0pT--GB9Ew-1; Wed, 27 Jan 2021 10:14:12 +0000
X-MC-Unique: zmoLVMLnMvui0pT--GB9Ew-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 27 Jan 2021 10:14:10 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 27 Jan 2021 10:14:10 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xie He' <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: RE: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB
 frames
Thread-Topic: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB
 frames
Thread-Index: AQHW9I1sli8DbRQswEiQZfQBLL+Jnqo7Omkg
Date:   Wed, 27 Jan 2021 10:14:10 +0000
Message-ID: <77971dffcff441c3ad3d257825dc214b@AcuMS.aculab.com>
References: <20210127090747.364951-1-xie.he.0141@gmail.com>
In-Reply-To: <20210127090747.364951-1-xie.he.0141@gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He
> Sent: 27 January 2021 09:08
> 
> An HDLC hardware driver may call netif_stop_queue to temporarily stop
> the TX queue when the hardware is busy sending a frame, and after the
> hardware has finished sending the frame, call netif_wake_queue to
> resume the TX queue.
> 
> However, the LAPB module doesn't know about this. Whether or not the
> hardware driver has stopped the TX queue, the LAPB module still feeds
> outgoing frames to the hardware driver for transmission. This can cause
> frames to be dropped by the hardware driver.
> 
> It's not easy to fix this issue in the LAPB module. We can indeed let the
> LAPB module check whether the TX queue has been stopped before feeding
> each frame to the hardware driver, but when the hardware driver resumes
> the TX queue, it's not easy to immediately notify the LAPB module and ask
> it to resume transmission.
> 
> Instead, we can fix this issue at the hdlc_x25 layer, by using qdisc TX
> queues to queue outgoing LAPB frames. The qdisc TX queue will then
> automatically be controlled by netif_stop_queue and netif_wake_queue.
> 
> This way, when sending, we will use the qdisc queue to queue and send
> the data twice: once as the L3 packet and then (after processed by the
> LAPB module) as an LAPB (L2) frame. This does not make the logic of the
> code messy, because when receiving, data are already "received" on the
> device twice: once as an LAPB (L2) frame and then (after processed by
> the LAPB module) as the L3 packet.

If I read this correctly it adds a (potentially big) queue between the
LAPB code that adds the sequence numbers to the frames and the hardware
that actually sends them.

IIRC [1] there is a general expectation that the NR in a transmitted frame
will be the same as the last received NS unless acks are being delayed
for flow control reasons.

You definitely want to be able to ack a received frame while transmitting
back-to-back I-frames.

This really means that you only want 2 frames in the hardware driver.
The one being transmitted and the next one - so it gets sent with a
shared flag.
There is no point sending an RR unless the hardware link is actually idle.

[1] I've been doing to much SS7 MTP2 recently, I can't quite remember
all of LAPB!

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

