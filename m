Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E682F57D8
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbhANCJq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 13 Jan 2021 21:09:46 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:43012 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728445AbhAMWZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 17:25:27 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-130-Y5JwpB2VMtaZo32AynZycg-1; Wed, 13 Jan 2021 22:23:32 +0000
X-MC-Unique: Y5JwpB2VMtaZo32AynZycg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 13 Jan 2021 22:23:31 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 13 Jan 2021 22:23:31 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Subject: RE: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
Thread-Topic: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
Thread-Index: AQHW6cgHRTEecj4eIU+21eAugdAvOaomIBlQ
Date:   Wed, 13 Jan 2021 22:23:31 +0000
Message-ID: <b0c5b2164e90492c99752584070510d7@AcuMS.aculab.com>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
In-Reply-To: <20210113161819.1155526-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet
> Sent: 13 January 2021 16:18
> 
> From: Eric Dumazet <edumazet@google.com>
> 
> Both virtio net and napi_get_frags() allocate skbs
> with a very small skb->head
> 
> While using page fragments instead of a kmalloc backed skb->head might give
> a small performance improvement in some cases, there is a huge risk of
> under estimating memory usage.

There is (or was last time I looked) also a problem with
some of the USB ethernet drivers.

IIRC one of the ASXnnnnnn (???) USB3 ones allocates 64k skb to pass
to the USB stack and then just lies about skb->truesize when passing
them into the network stack.
The USB hardware will merge TCP receives and put multiple ethernet
packets into a single USB message.
But single frames can end up in very big kernel memory buffers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

