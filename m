Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5AFDE88
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 11:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfD2JAK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Apr 2019 05:00:10 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:33478 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727525AbfD2JAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 05:00:09 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-146-QaCPUtLbON2Tyu0lFDDIjA-1; Mon, 29 Apr 2019 10:00:03 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 29 Apr 2019 10:00:03 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 29 Apr 2019 10:00:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@idosch.org" <idosch@idosch.org>,
        Willem de Bruijn <willemb@google.com>
Subject: RE: [PATCH net] packet: validate msg_namelen in send directly
Thread-Topic: [PATCH net] packet: validate msg_namelen in send directly
Thread-Index: AQHU/GYe1snsU+6jJ02GK9D6Ic6IaKZS2rOw
Date:   Mon, 29 Apr 2019 09:00:03 +0000
Message-ID: <92f9793efb2a4d9fb7973dcb47192c4b@AcuMS.aculab.com>
References: <20190426192735.145633-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20190426192735.145633-1-willemdebruijn.kernel@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: QaCPUtLbON2Tyu0lFDDIjA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn
> Sent: 26 April 2019 20:28
> Packet sockets in datagram mode take a destination address. Verify its
> length before passing to dev_hard_header.
> 
> Prior to 2.6.14-rc3, the send code ignored sll_halen. This is
> established behavior. Directly compare msg_namelen to dev->addr_len.
> 
> Fixes: 6b8d95f1795c4 ("packet: validate address length if non-zero")
> Suggested-by: David Laight <David.Laight@aculab.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/packet/af_packet.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 9419c5cf4de5e..13301e36b4a28 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2624,10 +2624,13 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  						sll_addr)))
>  			goto out;
>  		proto	= saddr->sll_protocol;
> -		addr	= saddr->sll_halen ? saddr->sll_addr : NULL;
>  		dev = dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
> -		if (addr && dev && saddr->sll_halen < dev->addr_len)
> -			goto out_put;
> +		if (po->sk.sk_socket->type == SOCK_DGRAM) {
> +			addr = saddr->sll_addr;
> +			if (dev && msg->msg_namelen < dev->addr_len +
> +					offsetof(struct sockaddr_ll, sll_addr))
> +				goto out_put;
> +		}

IIRC you need to initialise 'addr - NULL' at the top of the functions.
I'm surprised the compiler doesn't complain.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

