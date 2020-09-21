Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455112729E5
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 17:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgIUPVl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Sep 2020 11:21:41 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:58431 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726471AbgIUPVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 11:21:40 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-41-5DRnBW58M5Cy2UEM3fkX0w-1; Mon, 21 Sep 2020 16:21:36 +0100
X-MC-Unique: 5DRnBW58M5Cy2UEM3fkX0w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 21 Sep 2020 16:21:35 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 21 Sep 2020 16:21:35 +0100
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
        <linux-security-module@vger.kernel.org>
Subject: RE: [PATCH 02/11] mm: call import_iovec() instead of
 rw_copy_check_uvector() in process_vm_rw()
Thread-Topic: [PATCH 02/11] mm: call import_iovec() instead of
 rw_copy_check_uvector() in process_vm_rw()
Thread-Index: AQHWkCg9ha58Xpw3RkmKZfc82fYDTKlzMiEw
Date:   Mon, 21 Sep 2020 15:21:35 +0000
Message-ID: <ef67787edb2f48548d69caaaff6997ba@AcuMS.aculab.com>
References: <20200921143434.707844-1-hch@lst.de>
 <20200921143434.707844-3-hch@lst.de>
 <20200921150211.GS3421308@ZenIV.linux.org.uk>
In-Reply-To: <20200921150211.GS3421308@ZenIV.linux.org.uk>
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
> Sent: 21 September 2020 16:02
> 
> On Mon, Sep 21, 2020 at 04:34:25PM +0200, Christoph Hellwig wrote:
> > From: David Laight <David.Laight@ACULAB.COM>
> >
> > This is the only direct call of rw_copy_check_uvector().  Removing it
> > will allow rw_copy_check_uvector() to be inlined into import_iovec(),
> > while only paying a minor price by setting up an otherwise unused
> > iov_iter in the process_vm_readv/process_vm_writev syscalls that aren't
> > in a super hot path.
> 
> > @@ -443,7 +443,7 @@ void iov_iter_init(struct iov_iter *i, unsigned int direction,
> >  			const struct iovec *iov, unsigned long nr_segs,
> >  			size_t count)
> >  {
> > -	WARN_ON(direction & ~(READ | WRITE));
> > +	WARN_ON(direction & ~(READ | WRITE | CHECK_IOVEC_ONLY));
> >  	direction &= READ | WRITE;
> 
> Ugh...
> 
> > -	rc = rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV,
> > -				   iovstack_r, &iov_r);
> > +	rc = import_iovec(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV, &iov_r,
> > +			  &iter_r);
> >  	if (rc <= 0)
> >  		goto free_iovecs;
> >
> > -	rc = process_vm_rw_core(pid, &iter, iov_r, riovcnt, flags, vm_write);
> > +	rc = process_vm_rw_core(pid, &iter_l, iter_r.iov, iter_r.nr_segs,
> > +				flags, vm_write);
> 
> ... and ugh^2, since now you are not only setting a meaningless iov_iter,
> you are creating a new place that pokes directly into struct iov_iter
> guts.
> 
> Sure, moving rw_copy_check_uvector() over to lib/iov_iter.c makes sense.
> But I would rather split the access_ok()-related checks out of that thing
> and bury CHECK_IOVEC_ONLY.
> 
> Step 1: move the damn thing to lib/iov_iter.c (same as you do, but without
> making it static)
> 
> Step 2: split it in two:
> 
> ssize_t rw_copy_check_uvector(const struct iovec __user * uvector,
>                               unsigned long nr_segs, unsigned long fast_segs,
>                               struct iovec *fast_pointer,
>                               struct iovec **ret_pointer)
> {
> 	unsigned long seg;
...
> 	ret = 0;
> 	for (seg = 0; seg < nr_segs; seg++) {
> 		void __user *buf = iov[seg].iov_base;
> 		ssize_t len = (ssize_t)iov[seg].iov_len;
> 
> 		/* see if we we're about to use an invalid len or if
> 		 * it's about to overflow ssize_t */
> 		if (len < 0)
> 			return -EINVAL;
> 		if (len > MAX_RW_COUNT - ret) {
> 			len = MAX_RW_COUNT - ret;
> 			iov[seg].iov_len = len;
> 		}
> 		ret += len;
> 	}
> 	return ret;
> }
> 
> /*
>  *  This is merely an early sanity check; we do _not_ rely upon
>  *  it when we get to the actual memory accesses.
>  */
> static bool check_iovecs(const struct iovec *iov, int nr_segs)
> {
>         for (seg = 0; seg < nr_segs; seg++) {
>                 void __user *buf = iov[seg].iov_base;
>                 ssize_t len = (ssize_t)iov[seg].iov_len;
> 
>                 if (unlikely(!access_ok(buf, len)))
>                         return false;
>         }
> 	return true;
> }

You really don't want to be looping through the array twice.
In fact you don't really want to be doing all those tests at all.
This code makes a significant fraction of the not-insignificant
difference between the 'costs' of send() and sendmsg().

I think the 'length' check can be optimised to do something like:
	for (...) {
		ssize_t len = (ssize_t)iov[seg].iov_len;
		ret += len;
		len_hi += (unsigned long)len >> 20;
	}
	if (len_hi) {
		/* Something potentially odd in the lengths.
		 * Might just be a very long fragment.
		 * Check the individial values. */
		Add the exiting loop here.
	}

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

