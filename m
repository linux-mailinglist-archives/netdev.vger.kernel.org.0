Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166E74B93F6
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 23:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbiBPWoi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Feb 2022 17:44:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237471AbiBPWoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 17:44:37 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0294E28ADAD
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 14:44:23 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-19-9coR4DLVNQeYdzpxCI8mZQ-1; Wed, 16 Feb 2022 22:44:20 +0000
X-MC-Unique: 9coR4DLVNQeYdzpxCI8mZQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Wed, 16 Feb 2022 22:44:20 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Wed, 16 Feb 2022 22:44:19 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Guillaume Nault' <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC iproute2] tos: interpret ToS in natural numeral system
Thread-Topic: [RFC iproute2] tos: interpret ToS in natural numeral system
Thread-Index: AQHYI4PoKjWHbtmmC0aOBpeA6eR/AayWxL7g
Date:   Wed, 16 Feb 2022 22:44:19 +0000
Message-ID: <0b4b5a8f8e9e48248bee3208d8f13286@AcuMS.aculab.com>
References: <20220216194205.3780848-1-kuba@kernel.org>
 <20220216222352.GA3432@pc-4.home>
In-Reply-To: <20220216222352.GA3432@pc-4.home>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault
> Sent: 16 February 2022 22:24
> 
> On Wed, Feb 16, 2022 at 11:42:05AM -0800, Jakub Kicinski wrote:
> > Silently forcing a base numeral system is very painful for users.
> > ip currently interprets tos 10 as 0x10. Imagine user's bash script
> > does:
> >
> >   .. tos $((TOS * 2)) ..
> >
> > or any numerical operation on the ToS.
> >
> > This patch breaks existing scripts if they expect 10 to be 0x10.
> 
> I agree that we shouldn't have forced base 16 in the first place.
> But after so many years I find it a bit dangerous to change that.

Aren't the TOS values made up of several multi-bit fields and
very likely to be documented in hex?
I'm not sure $((TOS * 2)) (or even + 2) makes any sense at all.

What it more horrid that that base 0 treats numbers that start
with a 0 as octal - has anyone really used octal since the 1970s
(except for file permissions).

I have written command line parsers that treat 0tnnn as decimal
while defaulting to hex.
That does make it easier to use shell arithmetic for field (like
addresses) that you would never normally specify in decimal.

> 
> What about just printing a warning when the value isn't prefixed with
> '0x'? Something like (completely untested):
> 
> @@ -535,6 +535,12 @@ int rtnl_dsfield_a2n(__u32 *id, const char *arg)
>  	if (!end || end == arg || *end || res > 255)
>  		return -1;
>  	*id = res;
> +
> +	if (strncmp("0x", arg, 2))
> +		fprintf(stderr,
> +			"Warning: dsfield and tos parameters are interpreted as hexadecimal values\n"
> +			"Use 'dsfield 0x%02x' to avoid this message\n", res);

Ugg.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

