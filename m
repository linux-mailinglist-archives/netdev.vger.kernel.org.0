Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA52B2C24DF
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 12:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733041AbgKXLnJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Nov 2020 06:43:09 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:41433 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732917AbgKXLnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 06:43:07 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-91-jyJxJe5aNJiyxE4leEQJIA-1; Tue, 24 Nov 2020 11:43:03 +0000
X-MC-Unique: jyJxJe5aNJiyxE4leEQJIA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 24 Nov 2020 11:43:02 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 24 Nov 2020 11:43:02 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Martin Schiller' <ms@dev.tdt.de>,
        "andrew.hendry@gmail.com" <andrew.hendry@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "xie.he.0141@gmail.com" <xie.he.0141@gmail.com>
CC:     "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v5 3/5] net/lapb: fix t1 timer handling for
 LAPB_STATE_0
Thread-Topic: [PATCH net-next v5 3/5] net/lapb: fix t1 timer handling for
 LAPB_STATE_0
Thread-Index: AQHWwkWB5njMObAgO0WeknXMDXzKn6nXJulw
Date:   Tue, 24 Nov 2020 11:43:02 +0000
Message-ID: <2d40b42aee314611b9ba1627e5eab30b@AcuMS.aculab.com>
References: <20201124093538.21177-1-ms@dev.tdt.de>
 <20201124093538.21177-4-ms@dev.tdt.de>
In-Reply-To: <20201124093538.21177-4-ms@dev.tdt.de>
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

From: Martin Schiller
> Sent: 24 November 2020 09:36
> 
> 1. DTE interface changes immediately to LAPB_STATE_1 and start sending
>    SABM(E).
> 
> 2. DCE interface sends N2-times DM and changes to LAPB_STATE_1
>    afterwards if there is no response in the meantime.

Seems reasonable.
It is 35 years since I wrote LAPB and I can't exactly remember
what we did.
If I stole a copy of the code it's on a QIC-150 tape cartridge!

I really don't remember having a DTE/DCE option.
It is likely that LAPB came up sending DM (response without F)
until level3 requested the link come up when it would send
N2 SABM+P hoping to get a UA+F.
It would then send DM-F until a retry request was made.

We certainly had several different types of crossover connectors
for DTE-DTE working.

	David

> 
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>
> ---
>  net/lapb/lapb_timer.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/lapb/lapb_timer.c b/net/lapb/lapb_timer.c
> index 8f5b17001a07..baa247fe4ed0 100644
> --- a/net/lapb/lapb_timer.c
> +++ b/net/lapb/lapb_timer.c
> @@ -85,11 +85,18 @@ static void lapb_t1timer_expiry(struct timer_list *t)
>  	switch (lapb->state) {
> 
>  		/*
> -		 *	If we are a DCE, keep going DM .. DM .. DM
> +		 *	If we are a DCE, send DM up to N2 times, then switch to
> +		 *	STATE_1 and send SABM(E).
>  		 */
>  		case LAPB_STATE_0:
> -			if (lapb->mode & LAPB_DCE)
> +			if (lapb->mode & LAPB_DCE &&
> +			    lapb->n2count != lapb->n2) {
> +				lapb->n2count++;
>  				lapb_send_control(lapb, LAPB_DM, LAPB_POLLOFF, LAPB_RESPONSE);
> +			} else {
> +				lapb->state = LAPB_STATE_1;
> +				lapb_establish_data_link(lapb);
> +			}
>  			break;
> 
>  		/*
> --
> 2.20.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

