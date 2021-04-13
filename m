Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B731135D95F
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240980AbhDMHxj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Apr 2021 03:53:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:44276 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241154AbhDMHxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:53:36 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-217-9A0sWgifMA2Wbbm2cF54Qg-1; Tue, 13 Apr 2021 08:53:15 +0100
X-MC-Unique: 9A0sWgifMA2Wbbm2cF54Qg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 13 Apr 2021 08:53:14 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Tue, 13 Apr 2021 08:53:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Matteo Croce' <mcroce@linux.microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: RE: [PATCH net-next v2 0/3] introduce skb_for_each_frag()
Thread-Topic: [PATCH net-next v2 0/3] introduce skb_for_each_frag()
Thread-Index: AQHXLzQg5WXC8qIcg0CtZzWZRcsCQaqyElmA
Date:   Tue, 13 Apr 2021 07:53:14 +0000
Message-ID: <75045c087db24b6e87b7ed14aa5a721c@AcuMS.aculab.com>
References: <20210412003802.51613-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210412003802.51613-1-mcroce@linux.microsoft.com>
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

From: Matteo Croce
> Sent: 12 April 2021 01:38
> 
> Introduce skb_for_each_frag, an helper macro to iterate over the SKB frags.

The real question is why, the change is:

-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+	skb_for_each_frag(skb, i) {

The existing code isn't complicated or obscure and 'does what it
says on the tin'.
The 'helper' requires you go and look up its definition to see
what it is really doing.

Unless you have a cunning plan to change the definition
there is zero point.

A more interesting change would be something that generated:
	unsigned int nr_frags = skb_shinfo(skb)->nr_frags;
	for (i = 0; i < nr_frags; i++) {
since that will run faster for most loops.
But that is ~impossible to do since you can't declare
variables inside the (...) that are scoped to the loop.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

