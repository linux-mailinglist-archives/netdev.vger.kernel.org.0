Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC3743B06F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbhJZKrg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Oct 2021 06:47:36 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:40547 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235192AbhJZKrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 06:47:32 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-72-s2bWjJjJN9a05U3F78k5GQ-1; Tue, 26 Oct 2021 11:45:05 +0100
X-MC-Unique: s2bWjJjJN9a05U3F78k5GQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.24; Tue, 26 Oct 2021 11:45:05 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.024; Tue, 26 Oct 2021 11:45:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jeremy Kerr' <jk@codeconstruct.com.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Eugene Syromiatnikov <esyr@redhat.com>
Subject: RE: [PATCH net-next v6] mctp: Implement extended addressing
Thread-Topic: [PATCH net-next v6] mctp: Implement extended addressing
Thread-Index: AQHXygzktovb2Gkqtk2NwlM084EoaqvlFoLw
Date:   Tue, 26 Oct 2021 10:45:05 +0000
Message-ID: <f5b11b52cf0644088a919fb2a1a07c18@AcuMS.aculab.com>
References: <20211026015728.3006286-1-jk@codeconstruct.com.au>
In-Reply-To: <20211026015728.3006286-1-jk@codeconstruct.com.au>
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

From: Jeremy Kerr
> 
> This change allows an extended address struct - struct sockaddr_mctp_ext
> - to be passed to sendmsg/recvmsg. This allows userspace to specify
> output ifindex and physical address information (for sendmsg) or receive
> the input ifindex/physaddr for incoming messages (for recvmsg). This is
> typically used by userspace for MCTP address discovery and assignment
> operations.
> 
...
> diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
> index 6acd4ccafbf7..07b0318716fc 100644
> --- a/include/uapi/linux/mctp.h
> +++ b/include/uapi/linux/mctp.h
> @@ -11,6 +11,7 @@
> 
>  #include <linux/types.h>
>  #include <linux/socket.h>
> +#include <linux/netdevice.h>
> 
>  typedef __u8			mctp_eid_t;
> 
> @@ -28,6 +29,14 @@ struct sockaddr_mctp {
>  	__u8			__smctp_pad1;
>  };
> 
> +struct sockaddr_mctp_ext {
> +	struct sockaddr_mctp	smctp_base;
> +	int			smctp_ifindex;
> +	__u8			smctp_halen;
> +	__u8			__smctp_pad0[3];
> +	__u8			smctp_haddr[MAX_ADDR_LEN];
> +};

You'd be better off 8-byte aligning smctp_haddr.
I also suspect that always copying the 32 bytes will be faster
and generate less code than the memset() + memcpy().

Oh and how did MAX_ADDR_LEN ever get into a uapi header??

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

