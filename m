Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBA4E6E5
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfD2Ptt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Apr 2019 11:49:49 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:20797 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728555AbfD2Ptt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:49:49 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-136-YSGrpRl2NJGAFtors4MtGw-1; Mon, 29 Apr 2019 16:49:45 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon,
 29 Apr 2019 16:49:44 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 29 Apr 2019 16:49:44 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        Willem de Bruijn <willemb@google.com>
Subject: RE: [PATCH net v2] packet: in recvmsg msg_name return at least sizeof
 sockaddr_ll
Thread-Topic: [PATCH net v2] packet: in recvmsg msg_name return at least
 sizeof sockaddr_ll
Thread-Index: AQHU/qLJGSalImNgVECbMd4Y1mb2BKZTSOSA
Date:   Mon, 29 Apr 2019 15:49:44 +0000
Message-ID: <b4a396b7c2f5467a97433d7c52530924@AcuMS.aculab.com>
References: <20190429154655.9141-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20190429154655.9141-1-willemdebruijn.kernel@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: YSGrpRl2NJGAFtors4MtGw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn
> Sent: 29 April 2019 16:47
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
> Change v1->v2: do not overwrite zeroed padding again. use copy_len.
> 
> Fixes: 0fb375fb9b93 ("[AF_PACKET]: Allow for > 8 byte hardware addresses.")
> Suggested-by: David Laight <David.Laight@aculab.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/packet/af_packet.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index e726aaba73b9f..5fe3d75b6212d 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -3348,20 +3348,29 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>  	sock_recv_ts_and_drops(msg, sk, skb);
> 
>  	if (msg->msg_name) {
> +		int copy_len;
> +
>  		/* If the address length field is there to be filled
>  		 * in, we fill it in now.
>  		 */
>  		if (sock->type == SOCK_PACKET) {
>  			__sockaddr_check_size(sizeof(struct sockaddr_pkt));
>  			msg->msg_namelen = sizeof(struct sockaddr_pkt);
> +			copy_len = msg->msg_namelen;
>  		} else {
>  			struct sockaddr_ll *sll = &PACKET_SKB_CB(skb)->sa.ll;
> 
>  			msg->msg_namelen = sll->sll_halen +
>  				offsetof(struct sockaddr_ll, sll_addr);
> +			copy_len = msg->msg_namelen;
> +			if (msg->msg_namelen < sizeof(struct sockaddr_ll)) {
> +				memset(msg->msg_name +
> +				       offsetof(struct sockaddr_ll, sll_addr),
> +				       0, sizeof(sll->sll_addr));
> +				msg->msg_namelen = sizeof(struct sockaddr_ll);
> +			}
>  		}
> -		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa,
> -		       msg->msg_namelen);
> +		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
>  	}
> 
>  	if (pkt_sk(sk)->auxdata) {
> --
> 2.21.0.593.g511ec345e18-goog

Looks ok to me, not tried to compile it though.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

