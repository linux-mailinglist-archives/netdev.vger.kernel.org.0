Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4586275A45
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgIWOia convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Sep 2020 10:38:30 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:28248 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbgIWOi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:38:29 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-165-Nw6nj9OTOPCDM2jdlTcJwQ-1; Wed, 23 Sep 2020 15:38:25 +0100
X-MC-Unique: Nw6nj9OTOPCDM2jdlTcJwQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 23 Sep 2020 15:38:24 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 23 Sep 2020 15:38:24 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Al Viro' <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: RE: [PATCH 3/9] iov_iter: refactor rw_copy_check_uvector and
 import_iovec
Thread-Topic: [PATCH 3/9] iov_iter: refactor rw_copy_check_uvector and
 import_iovec
Thread-Index: AQHWkbQ2JliFoXXebU2Mp2qBncEZ86l2SGTw
Date:   Wed, 23 Sep 2020 14:38:24 +0000
Message-ID: <200cf2b9ce5e408f8838948fda7ce9a0@AcuMS.aculab.com>
References: <20200923060547.16903-1-hch@lst.de>
 <20200923060547.16903-4-hch@lst.de>
 <20200923141654.GJ3421308@ZenIV.linux.org.uk>
In-Reply-To: <20200923141654.GJ3421308@ZenIV.linux.org.uk>
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

From: Al Viro
> Sent: 23 September 2020 15:17
> 
> On Wed, Sep 23, 2020 at 08:05:41AM +0200, Christoph Hellwig wrote:
> 
> > +struct iovec *iovec_from_user(const struct iovec __user *uvec,
> > +		unsigned long nr_segs, unsigned long fast_segs,
> 
> Hmm...  For fast_segs unsigned long had always been ridiculous
> (4G struct iovec on caller stack frame?), but that got me wondering about
> nr_segs and I wish I'd thought of that when introducing import_iovec().
> 
> The thing is, import_iovec() takes unsigned int there.  Which is fine
> (hell, the maximal value that can be accepted in 1024), except that
> we do pass unsigned long syscall argument to it in some places.

It will make diddly-squit difference.
The parameters end up in registers on most calling conventions.
Plausibly you get an extra 'REX' byte on x86 for the 64bit value.
What you want to avoid is explicit sign/zero extension and value
masking after arithmetic.

On x86-64 the 'horrid' type is actually 'signed int'.
It often needs sign extending to 64bits (eg when being
used as an array subscript).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

