Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906C5B4C0D
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 12:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfIQKg0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Sep 2019 06:36:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:47216 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726169AbfIQKg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 06:36:26 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-3-80eFz-5rN5idwkxVP-i0-g-1; Tue, 17 Sep 2019 11:36:22 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 17 Sep 2019 11:36:21 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 17 Sep 2019 11:36:21 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jose Abreu' <Jose.Abreu@synopsys.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        David Bolvansky <david.bolvansky@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: -Wsizeof-array-div warnings in ethernet drivers
Thread-Topic: -Wsizeof-array-div warnings in ethernet drivers
Thread-Index: AQHVbSoo2sCm+b6KbUmq34Z8Q4HTw6cvgEiggAAsi+A=
Date:   Tue, 17 Sep 2019 10:36:21 +0000
Message-ID: <510d777024554eab846ef93d05998b63@AcuMS.aculab.com>
References: <20190917073232.GA14291@archlinux-threadripper>
 <BN8PR12MB3266AFAFF3FAAA9C10FB1C1FD38F0@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266AFAFF3FAAA9C10FB1C1FD38F0@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 80eFz-5rN5idwkxVP-i0-g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu
> Sent: 17 September 2019 08:59
> From: Nathan Chancellor <natechancellor@gmail.com>
> Date: Sep/17/2019, 08:32:32 (UTC+00:00)
> 
> > Hi all,
> >
> > Clang recently added a new diagnostic in r371605, -Wsizeof-array-div,
> > that tries to warn when sizeof(X) / sizeof(Y) does not compute the
> > number of elements in an array X (i.e., sizeof(Y) is wrong). See that
> > commit for more details:
...
> > ../drivers/net/ethernet/amd/xgbe/xgbe-dev.c:361:49: warning: expression
> > does not compute the number of elements in this array; element type is
> > 'u8' (aka 'unsigned char'), not 'u32' (aka 'unsigned int')
> > [-Wsizeof-array-div]
> >         unsigned int key_regs = sizeof(pdata->rss_key) / sizeof(u32);
> >                                        ~~~~~~~~~~~~~~  ^
...
> > What is the reasoning behind having the key being an array of u8s but
> > seemlingly converting it into an array of u32s? It's not immediately
> > apparent from reading over the code but I am not familiar with it so I
> > might be making a mistake. I assume this is intentional? If so, the
> > warning can be silenced and we'll send patches to do so but we want to
> > make sure we aren't actually papering over a mistake.
> 
> This is because we write 32 bits at a time to the reg but internally the
> driver uses 8 bits to store the array. If you look at
> dwxgmac2_rss_configure() you'll see that cfg->key is casted to u32 which
> is the value we use in HW writes. Then the for loop just does the math
> to check how many u32's has to write.

That stinks of a possible misaligned data access.....

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

