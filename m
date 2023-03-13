Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6C86B7ECF
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjCMRGe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Mar 2023 13:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjCMRGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:06:20 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B57733BD
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 10:05:30 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-246-bQ2qnsRDO5aCOHhkgp0Jow-1; Mon, 13 Mar 2023 17:04:15 +0000
X-MC-Unique: bQ2qnsRDO5aCOHhkgp0Jow-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.47; Mon, 13 Mar
 2023 17:04:11 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.047; Mon, 13 Mar 2023 17:04:11 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Horatiu Vultur' <horatiu.vultur@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next 2/2] net: lan966x: Stop using packing library
Thread-Topic: [PATCH net-next 2/2] net: lan966x: Stop using packing library
Thread-Index: AQHZVSC3u0fDDFQR5EmW1hDzDWEnv6748Dbw
Date:   Mon, 13 Mar 2023 17:04:11 +0000
Message-ID: <cad1c4aac9ae4047b8ed29b181c908fd@AcuMS.aculab.com>
References: <20230312202424.1495439-1-horatiu.vultur@microchip.com>
 <20230312202424.1495439-3-horatiu.vultur@microchip.com>
In-Reply-To: <20230312202424.1495439-3-horatiu.vultur@microchip.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur
> Sent: 12 March 2023 20:24
> 
> When a frame is injected from CPU, it is required to create an IFH(Inter
> frame header) which sits in front of the frame that is transmitted.
> This IFH, contains different fields like destination port, to bypass the
> analyzer, priotity, etc. Lan966x it is using packing library to set and
> get the fields of this IFH. But this seems to be an expensive
> operations.
> If this is changed with a simpler implementation, the RX will be
> improved with ~5Mbit while on the TX is a much bigger improvement as it
> is required to set more fields. Below are the numbers for TX.
...
> +static void lan966x_ifh_set(u8 *ifh, size_t val, size_t pos, size_t length)
> +{
> +	u32 v = 0;
> +
> +	for (int i = 0; i < length ; i++) {
> +		int j = pos + i;
> +		int k = j % 8;
> +
> +		if (i == 0 || k == 0)
> +			v = ifh[IFH_LEN_BYTES - (j / 8) - 1];
> +
> +		if (val & (1 << i))
> +			v |= (1 << k);
> +
> +		if (i == (length - 1) || k == 7)
> +			ifh[IFH_LEN_BYTES - (j / 8) - 1] = v;
> +	}
> +}
> +

It has to be possible to do much better that that.
Given  that 'pos' and 'length' are always constants it looks like
each call should reduce to (something like):
	ifh[k] |= val << n;
	ifk[k + 1] |= val >> (8 - n);
	...
It might be that the compiler manages to do this, but I doubt it.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

