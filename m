Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39129DE9F
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 11:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfD2JDK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Apr 2019 05:03:10 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:31597 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727123AbfD2JDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 05:03:09 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-14-DCMFxBo9PYOf08F6OYEdtg-1; Mon, 29 Apr 2019 10:03:05 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 29 Apr 2019 10:03:04 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 29 Apr 2019 10:03:04 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        Willem de Bruijn <willemb@google.com>
Subject: RE: [PATCH net] packet: in recvmsg msg_name return at least
 sockaddr_ll
Thread-Topic: [PATCH net] packet: in recvmsg msg_name return at least
 sockaddr_ll
Thread-Index: AQHU/GZvSQrCFfAZB0iZHUe9Gb/AfaZS22Wg
Date:   Mon, 29 Apr 2019 09:03:03 +0000
Message-ID: <d57c87e402354163a7ed311d6d27aa4f@AcuMS.aculab.com>
References: <20190426192954.146301-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20190426192954.146301-1-willemdebruijn.kernel@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: DCMFxBo9PYOf08F6OYEdtg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn [mailto:willemdebruijn.kernel@gmail.com]
> Sent: 26 April 2019 20:30
> Packet send checks that msg_name is at least sizeof sockaddr_ll.
> Packet recv must return at least this length, so that its output
> can be passed unmodified to packet send.
> 
> This ceased to be true since adding support for lladdr longer than
> sll_addr. Since, the return value uses true address length.
> 
> Always return at least sizeof sockaddr_ll, even if address length
> is shorter. Zero the padding bytes.
> 
> Fixes: 0fb375fb9b93 ("[AF_PACKET]: Allow for > 8 byte hardware addresses.")
> Suggested-by: David Laight <David.Laight@aculab.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/packet/af_packet.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 13301e36b4a28..ca38e75c702e7 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -3358,9 +3358,14 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>  			msg->msg_namelen = sizeof(struct sockaddr_pkt);
>  		} else {
>  			struct sockaddr_ll *sll = &PACKET_SKB_CB(skb)->sa.ll;
> -
>  			msg->msg_namelen = sll->sll_halen +
>  				offsetof(struct sockaddr_ll, sll_addr);
> +			if (msg->msg_namelen < sizeof(struct sockaddr_ll)) {
> +				memset(msg->msg_name +
> +				       offsetof(struct sockaddr_ll, sll_addr),
> +				       0, sizeof(sll->sll_addr));
> +				msg->msg_namelen = sizeof(struct sockaddr_ll);
> +			}
>  		}
>  		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa,
>  		       msg->msg_namelen);

That memcpy() carefully overwrites the zeroed bytes.
You need a separate 'copy_len' that isn't updated (from 18 to 20).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

