Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246CA2EF19D
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 12:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbhAHLvJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Jan 2021 06:51:09 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:53947 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726792AbhAHLvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 06:51:07 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-227-JrkSGbMLN9-FUY2lxHNdvQ-1; Fri, 08 Jan 2021 11:49:28 +0000
X-MC-Unique: JrkSGbMLN9-FUY2lxHNdvQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 8 Jan 2021 11:49:27 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 8 Jan 2021 11:49:27 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>
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
        <linux-security-module@vger.kernel.org>
Subject: RE: [PATCH 05/11] iov_iter: merge the compat case into
 rw_copy_check_uvector
Thread-Topic: [PATCH 05/11] iov_iter: merge the compat case into
 rw_copy_check_uvector
Thread-Index: AQHWkCRUvpDO9SBAlU68E+WeFLSma6oeR04A
Date:   Fri, 8 Jan 2021 11:49:27 +0000
Message-ID: <7167a94511a84f30b18733d56007a7a5@AcuMS.aculab.com>
References: <20200921143434.707844-1-hch@lst.de>
 <20200921143434.707844-6-hch@lst.de>
In-Reply-To: <20200921143434.707844-6-hch@lst.de>
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

From: Christoph Hellwig <hch@lst.de>
> Sent: 21 September 2020 15:34
> 
> Stop duplicating the iovec verify code, and instead add add a
> __import_iovec helper that does the whole verify and import, but takes
> a bool compat to decided on the native or compat layout.  This also
> ends up massively simplifying the calling conventions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  lib/iov_iter.c | 195 ++++++++++++++++++-------------------------------
>  1 file changed, 70 insertions(+), 125 deletions(-)
> 
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index a64867501a7483..8bfa47b63d39aa 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -10,6 +10,7 @@
>  #include <net/checksum.h>
>  #include <linux/scatterlist.h>
>  #include <linux/instrumented.h>
> +#include <linux/compat.h>
> 
>  #define PIPE_PARANOIA /* for now */
> 
> @@ -1650,43 +1651,76 @@ const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags)
>  }
>  EXPORT_SYMBOL(dup_iter);
> 
> -static ssize_t rw_copy_check_uvector(int type,
> -		const struct iovec __user *uvector, unsigned long nr_segs,
> -		unsigned long fast_segs, struct iovec *fast_pointer,
> -		struct iovec **ret_pointer)
> +static int compat_copy_iovecs_from_user(struct iovec *iov,
> +		const struct iovec __user *uvector, unsigned long nr_segs)
> +{
> +	const struct compat_iovec __user *uiov =
> +		(const struct compat_iovec __user *)uvector;
> +	unsigned long i;
> +	int ret = -EFAULT;
> +
> +	if (!user_access_begin(uvector, nr_segs * sizeof(*uvector)))
> +		return -EFAULT;

I little bit late, but the above isn't quite right.
It should be sizeof(*iouv) - the length is double what it should be.

Not that access_ok() can fail for compat addresses
and the extra length won't matter for architectures that
need the address/length to open an address hole into userspace.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

