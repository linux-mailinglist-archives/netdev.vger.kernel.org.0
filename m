Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD02E72E
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfD2QBs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Apr 2019 12:01:48 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:54181 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728506AbfD2QBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:01:48 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-226-5llsNYZ-NwuSveKxwifTrQ-1; Mon, 29 Apr 2019 17:01:45 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 29 Apr 2019 17:01:43 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 29 Apr 2019 17:01:43 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Subject: RE: [PATCH net v2] packet: validate msg_namelen in send directly
Thread-Topic: [PATCH net v2] packet: validate msg_namelen in send directly
Thread-Index: AQHU/qOsnKDPErqEvkqlFzq1BUGVXKZTTEmA
Date:   Mon, 29 Apr 2019 16:01:43 +0000
Message-ID: <afaeff665f994174bf5751fc9068fe6e@AcuMS.aculab.com>
References: <20190429155318.20433-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20190429155318.20433-1-willemdebruijn.kernel@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 5llsNYZ-NwuSveKxwifTrQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn
> Sent: 29 April 2019 16:53
> Packet sockets in datagram mode take a destination address. Verify its
> length before passing to dev_hard_header.
> 
> Prior to 2.6.14-rc3, the send code ignored sll_halen. This is
> established behavior. Directly compare msg_namelen to dev->addr_len.
> 
> Change v1->v2: initialize addr in all paths
> 
> Fixes: 6b8d95f1795c4 ("packet: validate address length if non-zero")
> Suggested-by: David Laight <David.Laight@aculab.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/packet/af_packet.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 9419c5cf4de5e..a43876b374da2 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2602,8 +2602,8 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  	void *ph;
>  	DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
>  	bool need_wait = !(msg->msg_flags & MSG_DONTWAIT);
> +	unsigned char *addr = NULL;
>  	int tp_len, size_max;
> -	unsigned char *addr;
>  	void *data;
>  	int len_sum = 0;
>  	int status = TP_STATUS_AVAILABLE;
> @@ -2614,7 +2614,6 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  	if (likely(saddr == NULL)) {
>  		dev	= packet_cached_dev_get(po);
>  		proto	= po->num;
> -		addr	= NULL;
>  	} else {
>  		err = -EINVAL;
>  		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
> @@ -2624,10 +2623,13 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  						sll_addr)))
>  			goto out;
>  		proto	= saddr->sll_protocol;
> -		addr	= saddr->sll_halen ? saddr->sll_addr : NULL;
>  		dev = dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
> -		if (addr && dev && saddr->sll_halen < dev->addr_len)
> -			goto out_put;
> +		if (po->sk.sk_socket->type == SOCK_DGRAM) {
> +			if (dev && msg->msg_namelen < dev->addr_len +
> +				   offsetof(struct sockaddr_ll, sll_addr))
> +				goto out_put;
> +			addr = saddr->sll_addr;
> +		}
>  	}
> 
>  	err = -ENXIO;
> @@ -2799,7 +2801,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  	struct sk_buff *skb;
>  	struct net_device *dev;
>  	__be16 proto;
> -	unsigned char *addr;
> +	unsigned char *addr = NULL;
>  	int err, reserve = 0;
>  	struct sockcm_cookie sockc;
>  	struct virtio_net_hdr vnet_hdr = { 0 };
> @@ -2816,7 +2818,6 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  	if (likely(saddr == NULL)) {
>  		dev	= packet_cached_dev_get(po);
>  		proto	= po->num;
> -		addr	= NULL;
>  	} else {
>  		err = -EINVAL;
>  		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
> @@ -2824,10 +2825,13 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  		if (msg->msg_namelen < (saddr->sll_halen + offsetof(struct sockaddr_ll, sll_addr)))
>  			goto out;
>  		proto	= saddr->sll_protocol;
> -		addr	= saddr->sll_halen ? saddr->sll_addr : NULL;
>  		dev = dev_get_by_index(sock_net(sk), saddr->sll_ifindex);
> -		if (addr && dev && saddr->sll_halen < dev->addr_len)
> -			goto out_unlock;
> +		if (sock->type == SOCK_DGRAM) {
> +			if (dev && msg->msg_namelen < dev->addr_len +
> +				   offsetof(struct sockaddr_ll, sll_addr))
> +				goto out_unlock;
> +			addr = saddr->sll_addr;
> +		}
>  	}
> 
>  	err = -ENXIO;
> --
> 2.21.0.593.g511ec345e18-goog

LGTM

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

