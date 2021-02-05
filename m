Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A920831152E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhBEWYT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Feb 2021 17:24:19 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:33394 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231518AbhBEO1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:27:52 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-270-8he-aNJfMmyMpb8HPVFbEw-1; Fri, 05 Feb 2021 15:31:26 +0000
X-MC-Unique: 8he-aNJfMmyMpb8HPVFbEw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 5 Feb 2021 15:31:19 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 5 Feb 2021 15:31:19 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] carl9170: fix struct alignment conflict
Thread-Topic: [PATCH] carl9170: fix struct alignment conflict
Thread-Index: AQHW+xSTHrCr5fMAo0K1NzKrRUoyIapJsAIQ
Date:   Fri, 5 Feb 2021 15:31:19 +0000
Message-ID: <8e03db0fb69f4df5ad3cb24695055728@AcuMS.aculab.com>
References: <20210204162926.3262598-1-arnd@kernel.org>
In-Reply-To: <20210204162926.3262598-1-arnd@kernel.org>
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

From: Arnd Bergmann
> Sent: 04 February 2021 16:29
> 
> Multiple structures in the carl9170 driver have alignment
> impossible alignment constraints that gcc warns about when
> building with 'make W=1':
> 
> drivers/net/wireless/ath/carl9170/fwcmd.h:243:2: warning: alignment 1 of 'union <anonymous>' is less
> than 4 [-Wpacked-not-aligned]
> drivers/net/wireless/ath/carl9170/wlan.h:373:1: warning: alignment 1 of 'struct
> ar9170_rx_frame_single' is less than 2 [-Wpacked-not-aligned]
> 
> In the carl9170_cmd structure, multiple members that have an explicit
> alignment requirement of four bytes are added into a union with explicit
> byte alignment, but this in turn is part of a structure that also has
> four-byte alignment.
> 
> In the wlan.h header, multiple structures contain a ieee80211_hdr member
> that is required to be two-byte aligned to avoid alignmnet faults when
> processing network headers, but all members are forced to be byte-aligned
> using the __packed tag at the end of the struct definition.
> 
> In both cases, leaving out the packing does not change the internal
> layout of the structure but changes the alignment constraint of the
> structure itself.
> 
> Change all affected structures to only apply packing where it does
> not violate the alignment requirement of the contained structure.

I think I'd add compile-time assert that some of these structures
are exactly the expected size.
Then look at removing the outer packed/aligned attributes
and just putting the attribute on the 16/32 bit member(s)
that themselves might be misaligned.
Much the way that the 32bit aligned 64bit values are handled
in the x86 compat code in x86-64.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

