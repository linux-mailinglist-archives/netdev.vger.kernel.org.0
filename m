Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0612727D7
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgIUOiL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Sep 2020 10:38:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:44130 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727610AbgIUOiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:38:07 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-140-oNDip4LCObWi5fVxcGZ2UA-1; Mon, 21 Sep 2020 15:38:02 +0100
X-MC-Unique: oNDip4LCObWi5fVxcGZ2UA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 21 Sep 2020 15:38:02 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 21 Sep 2020 15:38:02 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH 4/9 next] fs/io_uring Don't use the return value from
 import_iovec().
Thread-Topic: [PATCH 4/9 next] fs/io_uring Don't use the return value from
 import_iovec().
Thread-Index: AdaLbe1b5RzSfSnfQoqJG9wxedvDFgEq0XAAAALSu0A=
Date:   Mon, 21 Sep 2020 14:38:02 +0000
Message-ID: <4b204a3e4db74cb2bd8c81e31f6b359b@AcuMS.aculab.com>
References: <0dc67994b6b2478caa3d96a9e24d2bfb@AcuMS.aculab.com>
 <20200921141456.GD24515@infradead.org>
In-Reply-To: <20200921141456.GD24515@infradead.org>
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
> Sent: 21 September 2020 15:15
> 
> On Tue, Sep 15, 2020 at 02:55:20PM +0000, David Laight wrote:
> >
> > This is the only code that relies on import_iovec() returning
> > iter.count on success.
> > This allows a better interface to import_iovec().
> 
> This looks generall sane, but a comment below:
> 
> > @@ -3123,7 +3123,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
> >  	if (ret < 0)
> >  		return ret;
> >  	iov_count = iov_iter_count(iter);
> > -	io_size = ret;
> > +	io_size = iov_count;
> >  	req->result = io_size;
> >  	ret = 0;
> >
> > @@ -3246,7 +3246,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
> >  	if (ret < 0)
> >  		return ret;
> >  	iov_count = iov_iter_count(iter);
> > -	io_size = ret;
> > +	io_size = iov_count;
> >  	req->result = io_size;
> 
> I tink the local iov_count variable can go away in both functions,
> as io_size only changes after the last use of iov_count (io_read) or
> not at all (io_write).

Yes, the compiler will probably make that optimisation.
I did a minimal change because my head hurts whenever I look at io_uring.c.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

