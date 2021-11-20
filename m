Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD7D4580BF
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 22:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhKTWAu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 20 Nov 2021 17:00:50 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:42744 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229590AbhKTWAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 17:00:49 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-281-Al8z84NMNTav-OCe2iuMew-1; Sat, 20 Nov 2021 21:57:43 +0000
X-MC-Unique: Al8z84NMNTav-OCe2iuMew-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Sat, 20 Nov 2021 21:57:42 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Sat, 20 Nov 2021 21:57:42 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Bernard Zhao' <bernard@vivo.com>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net/bridge: replace simple_strtoul to kstrtol
Thread-Topic: [PATCH] net/bridge: replace simple_strtoul to kstrtol
Thread-Index: AQHX3Ool6Pave9KWG0WLE/Hz4Kqz0KwM94oQ
Date:   Sat, 20 Nov 2021 21:57:42 +0000
Message-ID: <a98476cd4414476980a227c0f053bea7@AcuMS.aculab.com>
References: <20211119020642.108397-1-bernard@vivo.com>
In-Reply-To: <20211119020642.108397-1-bernard@vivo.com>
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

From: Bernard Zhao
> Sent: 19 November 2021 02:07
> 
> simple_strtoull is obsolete, use kstrtol instead.

I think the death announcement of simple_strtoull() has already
been deemed premature.
kstrtol() isn't a replacment in many cases.

> Signed-off-by: Bernard Zhao <bernard@vivo.com>
> ---
>  net/bridge/br_sysfs_br.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
> index d9a89ddd0331..11c490694296 100644
> --- a/net/bridge/br_sysfs_br.c
> +++ b/net/bridge/br_sysfs_br.c
> @@ -36,15 +36,14 @@ static ssize_t store_bridge_parm(struct device *d,
>  	struct net_bridge *br = to_bridge(d);
>  	struct netlink_ext_ack extack = {0};
>  	unsigned long val;
> -	char *endp;
>  	int err;
> 
>  	if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
>  		return -EPERM;
> 
> -	val = simple_strtoul(buf, &endp, 0);
> -	if (endp == buf)
> -		return -EINVAL;
> +	err = kstrtoul(buf, 10, &val);
> +	if (err != 0)
> +		return err;

That changes the valid input strings.
So is a UAPI change.
Now it might be that no one passes in strings that now fail,
but you can't tell.

Rightfully or not it used to ignore any trailing characters.
So "10flobbs" would be treated as "10".

Did you also check what happens to 0x1234 and 012 ?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

