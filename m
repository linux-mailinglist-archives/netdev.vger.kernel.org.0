Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674A1272914
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgIUOuI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Sep 2020 10:50:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:23203 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727833AbgIUOuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:50:07 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-86-4QhIQ9m2OJi1xwkLWjnc0A-1; Mon, 21 Sep 2020 15:50:02 +0100
X-MC-Unique: 4QhIQ9m2OJi1xwkLWjnc0A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 21 Sep 2020 15:50:01 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 21 Sep 2020 15:50:01 +0100
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
Thread-Index: AdaLbdBrrJnvb+q4Sa6RtPibF1KBcwErGHIAAAK0UcA=
Date:   Mon, 21 Sep 2020 14:50:01 +0000
Message-ID: <ce03301db65f4fee8c9da25a6bc980f7@AcuMS.aculab.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
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

I didn't think of going that far.
There are 2 call sites (in scsi) that don't pass the cache.

Given that the 'buffer to free' address probably needs to
be spilled to stack forcing in into an on-stack structure
that is already passed by address is probably a good idea.

The iov_iter_release_iovec() should be static inline and just:
	if (s->vec)
		kfree(s->vec);
You want the test because 99.99% of the time it will be NULL.
The kernel iov[] to use is iter.iov not part of the cache.

That will be a bigger change on the io_uring code.
(The patch I didn't write.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

