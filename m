Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDA02754E2
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgIWJzW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Sep 2020 05:55:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:23154 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726332AbgIWJzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:55:20 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-226-PrpFg9T_NP-llOlZs_EZgQ-1; Wed, 23 Sep 2020 10:55:17 +0100
X-MC-Unique: PrpFg9T_NP-llOlZs_EZgQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 23 Sep 2020 10:55:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 23 Sep 2020 10:55:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Julian Wiedmann' <jwi@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: RE: [PATCH net-next 3/9] s390/qeth: clean up string ops in
 qeth_l3_parse_ipatoe()
Thread-Topic: [PATCH net-next 3/9] s390/qeth: clean up string ops in
 qeth_l3_parse_ipatoe()
Thread-Index: AQHWkYS+KKE+2YxBK0+f9H+Mgs75S6l1+mkQ
Date:   Wed, 23 Sep 2020 09:55:15 +0000
Message-ID: <2e439abb31e942e2a441f28439d287fa@AcuMS.aculab.com>
References: <20200923083700.44624-1-jwi@linux.ibm.com>
 <20200923083700.44624-4-jwi@linux.ibm.com>
In-Reply-To: <20200923083700.44624-4-jwi@linux.ibm.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann
> Sent: 23 September 2020 09:37
> 
> Indicate the max number of to-be-parsed characters, and avoid copying
> the address sub-string.
> 
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> ---
>  drivers/s390/net/qeth_l3_sys.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
> index ca9c95b6bf35..05fa986e30fc 100644
> --- a/drivers/s390/net/qeth_l3_sys.c
> +++ b/drivers/s390/net/qeth_l3_sys.c
> @@ -409,21 +409,22 @@ static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
>  static int qeth_l3_parse_ipatoe(const char *buf, enum qeth_prot_versions proto,
>  		  u8 *addr, int *mask_bits)
>  {
> -	const char *start, *end;
> -	char *tmp;
> -	char buffer[40] = {0, };
> +	const char *start;
> +	char *sep, *tmp;
> +	int rc;
> 
> -	start = buf;
> -	/* get address string */
> -	end = strchr(start, '/');
> -	if (!end || (end - start >= 40)) {
> +	/* Expected input pattern: %addr/%mask */
> +	sep = strnchr(buf, 40, '/');
> +	if (!sep)
>  		return -EINVAL;
> -	}
> -	strncpy(buffer, start, end - start);
> -	if (qeth_l3_string_to_ipaddr(buffer, proto, addr)) {
> -		return -EINVAL;
> -	}
> -	start = end + 1;
> +
> +	/* Terminate the %addr sub-string, and parse it: */
> +	*sep = '\0';

Is it valid to write into the input buffer here?

> +	rc = qeth_l3_string_to_ipaddr(buf, proto, addr);
> +	if (rc)
> +		return rc;
> +
> +	start = sep + 1;
>  	*mask_bits = simple_strtoul(start, &tmp, 10);

The use of strnchr() rather implies that the input
buffer may not be '\0' terminated.
If that is true then you've just run off the end of the
input buffer.

>  	if (!strlen(start) ||
>  	    (tmp == start) ||

Hmmm... delete the strlen() clause.
It ought to test start[0], but the 'tmp == start' test
covers that case.

I don't understand why simple_strtoul() is deprecated.
I don't recall any of the replacements returning the
address of the terminating character.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

