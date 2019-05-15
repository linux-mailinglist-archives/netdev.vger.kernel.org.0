Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 941FE1EBE7
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 12:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfEOKPL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 May 2019 06:15:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:21146 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725953AbfEOKPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 06:15:11 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-115-74n14Y4CMIeKYIVFWXZM2w-1; Wed, 15 May 2019 11:15:08 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 15 May 2019 11:15:07 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 15 May 2019 11:15:07 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Will Deacon' <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
CC:     Zhangshaokun <zhangshaokun@hisilicon.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "huanglingyan (A)" <huanglingyan2@huawei.com>,
        "steve.capper@arm.com" <steve.capper@arm.com>
Subject: RE: [PATCH] arm64: do_csum: implement accelerated scalar version
Thread-Topic: [PATCH] arm64: do_csum: implement accelerated scalar version
Thread-Index: AQHVCwMrtYHa1Y0LVUWOb1uB691U/KZr90eg
Date:   Wed, 15 May 2019 10:15:07 +0000
Message-ID: <6e755b2daaf341128cb3b54f36172442@AcuMS.aculab.com>
References: <20190218230842.11448-1-ard.biesheuvel@linaro.org>
 <d7a16ebd-073f-f50e-9651-68606d10b01c@hisilicon.com>
 <20190412095243.GA27193@fuggles.cambridge.arm.com>
 <41b30c72-c1c5-14b2-b2e1-3507d552830d@arm.com>
 <20190515094704.GC24357@fuggles.cambridge.arm.com>
In-Reply-To: <20190515094704.GC24357@fuggles.cambridge.arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 74n14Y4CMIeKYIVFWXZM2w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...
> > 	ptr = (u64 *)(buff - offset);
> > 	shift = offset * 8;
> >
> > 	/*
> > 	 * Head: zero out any excess leading bytes. Shifting back by the same
> > 	 * amount should be at least as fast as any other way of handling the
> > 	 * odd/even alignment, and means we can ignore it until the very end.
> > 	 */
> > 	data = *ptr++;
> > #ifdef __LITTLE_ENDIAN
> > 	data = (data >> shift) << shift;
> > #else
> > 	data = (data << shift) >> shift;
> > #endif

I suspect that
#ifdef __LITTLE_ENDIAN
	data &= ~0ull << shift;
#else
	data &= ~0ull >> shift;
#endif
is likely to be better.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

