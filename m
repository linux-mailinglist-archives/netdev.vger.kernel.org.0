Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AF52EF122
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 12:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbhAHLPS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Jan 2021 06:15:18 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:59732 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbhAHLPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 06:15:17 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-175-sD4VRU_TPyetWiPTPnISpQ-1; Fri, 08 Jan 2021 11:13:38 +0000
X-MC-Unique: sD4VRU_TPyetWiPTPnISpQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 8 Jan 2021 11:13:37 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 8 Jan 2021 11:13:37 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH 5/9 next] scsi: Use iovec_import() instead of
 import_iovec().
Thread-Topic: [PATCH 5/9 next] scsi: Use iovec_import() instead of
 import_iovec().
Thread-Index: AdaLbdBrrJnvb+q4Sa6RtPibF1KBcwErGHIAFWTS8sA=
Date:   Fri, 8 Jan 2021 11:13:37 +0000
Message-ID: <881cc102501e4c1a93785f0906dbd650@AcuMS.aculab.com>
References: <27be46ece36c42d6a7dabf62c6ac7a98@AcuMS.aculab.com>
 <20200921142204.GE24515@infradead.org>
In-Reply-To: <20200921142204.GE24515@infradead.org>
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

From: Christoph Hellwig
> Sent: 21 September 2020 15:22
> 
> So looking at the various callers I'm not sure this API is the
> best.  If we want to do something fancy I'd hide the struct iovec
> instances entirely with something like:
> 
> struct iov_storage {
> 	struct iovec stack[UIO_FASTIOV], *vec;
> }
> 
> int iov_iter_import_iovec(struct iov_iter *iter, struct iov_storage *s,
> 		const struct iovec __user *vec, unsigned long nr_segs,
> 		int type);
> 
> and then add a new helper to free the thing if needed:
> 
> void iov_iter_release_iovec(struct iov_storage *s)
> {
> 	if (s->vec != s->stack)
> 		kfree(s->vec);
> }

I've been looking at this code again now most of the pending changes
are in Linus's tree.

I was actually looking at going one stage further.
The 'iov_iter' is always allocated with the 'iov_storage' *above).
Usually both are on the callers stack - possibly in different functions.

So add:
struct iovec_iter {
	struct iov_iter iter;
	struct iovec to_free;
	struct iovec stack[UIO_FASTIOV];
};

int __iovec_import(struct iovec_iter *, const struct iovec __user *vec,
	unsigned long nr_segs, int type, bool compat);

And a 'clean' function to do kfree(iovec->to_free);

This reduces the complexity of most of the callers.

I started doing the changes, but got in a mess in io_uring.c (as usual).
I think I've got a patch pending (in my brain) to simplify the io_uring code.

The plan is to add:
	if (iter->iov != xxx->to_free)
		iter->iov = xxx->stack;
Prior to every use of the iter.
This fixes up anything that got broken by a memcpy() of the fields.
The tidyup code is then always kfree(xxx->to_free).

	David

	

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

