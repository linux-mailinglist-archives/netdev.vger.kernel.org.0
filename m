Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F8724E28A
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHUVSr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Aug 2020 17:18:47 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:44900 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbgHUVSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:18:46 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-180-nRitbC59MfCis-3-n_PeQw-1; Fri, 21 Aug 2020 22:18:43 +0100
X-MC-Unique: nRitbC59MfCis-3-n_PeQw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 21 Aug 2020 22:18:42 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 21 Aug 2020 22:18:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: RE: Use of genradix in sctp
Thread-Topic: Use of genradix in sctp
Thread-Index: AdZ1ckZAY2qe63tNS/O9MsxVdvHiSAALTAcAAANIG8AAkcwnAAACvT6A
Date:   Fri, 21 Aug 2020 21:18:42 +0000
Message-ID: <9f5b892bcf4f41f9b32990fb6049fce2@AcuMS.aculab.com>
References: <2ffb7752d3e8403ebb220e0a5e2cf3cd@AcuMS.aculab.com>
 <20200818213800.GJ906397@localhost.localdomain>
 <357ded60999a4957addb766a29431ad7@AcuMS.aculab.com>
 <20200821204636.GO3399@localhost.localdomain>
In-Reply-To: <20200821204636.GO3399@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: 'Marcelo Ricardo Leitner'
> Sent: 21 August 2020 21:47
...
> >
> > 2) Optimise the genradix lookup for the case where there
> >    is a single page - it can be completely inlined.
> 
> And/or our struct sizes.
> 
> __idx_to_offset() will basically do:
>         if (!is_power_of_2(obj_size)) {
>                 return (idx / objs_per_page) * PAGE_SIZE +
>                         (idx % objs_per_page) * obj_size;
>         } else {
>                 return idx * obj_size;
> 
> if we can get it to his the else block, it saves some CPU cycles already (at
> the expense of memory).

I'm penning some changes to the genradix code:
That expression can be written:
	idx * obj_size + (idx / objs_per_page) * (PAGE_SIZE % obj_size)
which is simpler and doesn't need the is_power_of_2() test.

You can then do the early test:
	if (idx * obj_size <= PAGE_SIZE - obj_size) && root && !llevel)
		return root + idx * obj_size;
in the inline function.
A slight increase in code size, but a reduction in code path.
(Better still if you increment 'level'.)
Which catches most SCTP uses and the only other place I've found it used.

There is actually a nasty bug in the genradix code.
If the cmpxchg 'fails' when adding extra root levels then the page
can get reused later - but child[0] has been set.
This could add a loop to the tree!

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

