Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF166133D9
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJaKn7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 31 Oct 2022 06:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiJaKn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:43:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413EAD85
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 03:43:54 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-6-rBZvUtp9O5ulsghvKmsCxA-1; Mon, 31 Oct 2022 10:43:50 +0000
X-MC-Unique: rBZvUtp9O5ulsghvKmsCxA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 31 Oct
 2022 10:43:47 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Mon, 31 Oct 2022 10:43:47 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Horatiu Vultur' <horatiu.vultur@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net v2 0/3] net: lan966x: Fixes for when MTU is changed
Thread-Topic: [PATCH net v2 0/3] net: lan966x: Fixes for when MTU is changed
Thread-Index: AQHY7Kcu7Ao/FHDvc0OFOxRqKUrPo64oT9Iw
Date:   Mon, 31 Oct 2022 10:43:47 +0000
Message-ID: <b75a7136030846f587e555763ef2750e@AcuMS.aculab.com>
References: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur
> Sent: 30 October 2022 21:37
> 
> There were multiple problems in different parts of the driver when
> the MTU was changed.
> The first problem was that the HW was missing to configure the correct
> value, it was missing ETH_HLEN and ETH_FCS_LEN. The second problem was
> when vlan filtering was enabled/disabled, the MRU was not adjusted
> corretly. While the last issue was that the FDMA was calculated wrongly
> the correct maximum MTU.

IIRC all these lengths are 1514, 1518 and maybe 1522?
How long are the actual receive buffers?
I'd guess they have to be rounded up to a whole number of cache lines
(especially on non-coherent systems) so are probably 1536 bytes.

If driver does support 8k+ jumbo frames just set the hardware
frame length to match the receive buffer size.

There is no real need to exactly police the receive MTU.
There are definitely situations where the transmit MTU has
to be limited (eg to avoid ptmu blackholes) but where some
systems still send 'full sized' packets.

There is also the possibility of receiving PPPoE encapsulated
full sized ethernet packets.
I can remember how big that header is - something like 8 bytes.
There is no real reason to discard them if they'd fit in the buffer.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

