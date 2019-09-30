Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7327C2467
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 17:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732074AbfI3Pfq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Sep 2019 11:35:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:26885 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731276AbfI3Pfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 11:35:46 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-171-6gbYdDGuMiuY3reOFp0ISg-1; Mon, 30 Sep 2019 16:35:43 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 30 Sep 2019 16:35:42 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 30 Sep 2019 16:35:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Denis Efremov' <efremov@linux.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Pontus Fuchs <pontus.fuchs@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] ar5523: check NULL before memcpy() in ar5523_cmd()
Thread-Topic: [PATCH] ar5523: check NULL before memcpy() in ar5523_cmd()
Thread-Index: AQHVd5eyJR20opeapUCX0TL00aRlGadEWhCg
Date:   Mon, 30 Sep 2019 15:35:42 +0000
Message-ID: <230cd4f790544b01a26afa26e4186454@AcuMS.aculab.com>
References: <20190930140207.28638-1-efremov@linux.com>
In-Reply-To: <20190930140207.28638-1-efremov@linux.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 6gbYdDGuMiuY3reOFp0ISg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov
> Sent: 30 September 2019 15:02
> 
> memcpy() call with "idata == NULL && ilen == 0" results in undefined
> behavior in ar5523_cmd(). For example, NULL is passed in callchain
> "ar5523_stat_work() -> ar5523_cmd_write() -> ar5523_cmd()". This patch
> adds idata check before memcpy() call in ar5523_cmd() to prevent an
> undefined behavior.
> 
...
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/net/wireless/ath/ar5523/ar5523.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
> index b94759daeacc..f25af5bc5282 100644
> --- a/drivers/net/wireless/ath/ar5523/ar5523.c
> +++ b/drivers/net/wireless/ath/ar5523/ar5523.c
> @@ -255,7 +255,8 @@ static int ar5523_cmd(struct ar5523 *ar, u32 code, const void *idata,
> 
>  	if (flags & AR5523_CMD_FLAG_MAGIC)
>  		hdr->magic = cpu_to_be32(1 << 24);
> -	memcpy(hdr + 1, idata, ilen);
> +	if (idata)
> +		memcpy(hdr + 1, idata, ilen);

That would be better as if (ilen) ...

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

