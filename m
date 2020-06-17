Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A821FCFDC
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 16:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgFQOjq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jun 2020 10:39:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:25581 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726868AbgFQOjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 10:39:45 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-195-Gpypvq5LNJmsm7HP-7qKTQ-1; Wed, 17 Jun 2020 15:39:41 +0100
X-MC-Unique: Gpypvq5LNJmsm7HP-7qKTQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 17 Jun 2020 15:39:40 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 17 Jun 2020 15:39:40 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jeremy Kerr' <jk@ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Allan Chou <allan@asix.com.tw>, Freddy Xin <freddy@asix.com.tw>,
        "Peter Fink" <pfink@christ-es.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] net: usb: ax88179_178a: fix packet alignment padding
Thread-Topic: [PATCH] net: usb: ax88179_178a: fix packet alignment padding
Thread-Index: AQHWQsBxb9lhlKPSLUytvkfxXgQEpqjc5Apg
Date:   Wed, 17 Jun 2020 14:39:40 +0000
Message-ID: <2136b5e36d804821846064fafbf72941@AcuMS.aculab.com>
References: <20200615025456.30219-1-jk@ozlabs.org>
In-Reply-To: <20200615025456.30219-1-jk@ozlabs.org>
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

From: Jeremy Kerr
> Sent: 15 June 2020 03:55

While you are looking as this driver you might want to worry
about what it sets skp->truesize to.

> --- a/drivers/net/usb/ax88179_178a.c
> +++ b/drivers/net/usb/ax88179_178a.c
> @@ -1414,10 +1414,10 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>  		}
> 
>  		if (pkt_cnt == 0) {
> -			/* Skip IP alignment psudo header */
> -			skb_pull(skb, 2);
>  			skb->len = pkt_len;
> -			skb_set_tail_pointer(skb, pkt_len);
> +			/* Skip IP alignment pseudo header */
> +			skb_pull(skb, 2);
> +			skb_set_tail_pointer(skb, skb->len);
>  			skb->truesize = pkt_len + sizeof(struct sk_buff);

IIRC the memory allocated to the packet is likely to be over 64k.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

