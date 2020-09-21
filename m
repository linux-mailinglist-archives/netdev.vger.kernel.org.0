Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5374E272951
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 17:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbgIUPC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 11:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbgIUPC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 11:02:26 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724C2C061755;
        Mon, 21 Sep 2020 08:02:26 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKNKV-003BjE-Jk; Mon, 21 Sep 2020 15:02:11 +0000
Date:   Mon, 21 Sep 2020 16:02:11 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 02/11] mm: call import_iovec() instead of
 rw_copy_check_uvector() in process_vm_rw()
Message-ID: <20200921150211.GS3421308@ZenIV.linux.org.uk>
References: <20200921143434.707844-1-hch@lst.de>
 <20200921143434.707844-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921143434.707844-3-hch@lst.de>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 04:34:25PM +0200, Christoph Hellwig wrote:
> From: David Laight <David.Laight@ACULAB.COM>
> 
> This is the only direct call of rw_copy_check_uvector().  Removing it
> will allow rw_copy_check_uvector() to be inlined into import_iovec(),
> while only paying a minor price by setting up an otherwise unused
> iov_iter in the process_vm_readv/process_vm_writev syscalls that aren't
> in a super hot path.

> @@ -443,7 +443,7 @@ void iov_iter_init(struct iov_iter *i, unsigned int direction,
>  			const struct iovec *iov, unsigned long nr_segs,
>  			size_t count)
>  {
> -	WARN_ON(direction & ~(READ | WRITE));
> +	WARN_ON(direction & ~(READ | WRITE | CHECK_IOVEC_ONLY));
>  	direction &= READ | WRITE;

Ugh...

> -	rc = rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV,
> -				   iovstack_r, &iov_r);
> +	rc = import_iovec(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV, &iov_r,
> +			  &iter_r);
>  	if (rc <= 0)
>  		goto free_iovecs;
>  
> -	rc = process_vm_rw_core(pid, &iter, iov_r, riovcnt, flags, vm_write);
> +	rc = process_vm_rw_core(pid, &iter_l, iter_r.iov, iter_r.nr_segs,
> +				flags, vm_write);

... and ugh^2, since now you are not only setting a meaningless iov_iter,
you are creating a new place that pokes directly into struct iov_iter
guts.

Sure, moving rw_copy_check_uvector() over to lib/iov_iter.c makes sense.
But I would rather split the access_ok()-related checks out of that thing
and bury CHECK_IOVEC_ONLY.

Step 1: move the damn thing to lib/iov_iter.c (same as you do, but without
making it static)

Step 2: split it in two:

ssize_t rw_copy_check_uvector(const struct iovec __user * uvector,
                              unsigned long nr_segs, unsigned long fast_segs,
                              struct iovec *fast_pointer,
                              struct iovec **ret_pointer)
{
	unsigned long seg;
	ssize_t ret;
	struct iovec *iov = fast_pointer;

	*ret_pointer = fast_pointer;
	/*
	 * SuS says "The readv() function *may* fail if the iovcnt argument
	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
	 * traditionally returned zero for zero segments, so...
	 */
	if (nr_segs == 0)
		return 0;

	/*
	 * First get the "struct iovec" from user memory and
	 * verify all the pointers
	 */
	if (nr_segs > UIO_MAXIOV)
		return -EINVAL;

	if (nr_segs > fast_segs) {
		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
		if (!iov)
			return -ENOMEM;
		*ret_pointer = iov;
	}
	if (copy_from_user(iov, uvector, nr_segs*sizeof(*uvector)))
		return -EFAULT;

	/*
	 * According to the Single Unix Specification we should return EINVAL
	 * if an element length is < 0 when cast to ssize_t or if the
	 * total length would overflow the ssize_t return value of the
	 * system call.
	 *
	 * Linux caps all read/write calls to MAX_RW_COUNT, and avoids the
	 * overflow case.
	 */
	ret = 0;
	for (seg = 0; seg < nr_segs; seg++) {
		void __user *buf = iov[seg].iov_base;
		ssize_t len = (ssize_t)iov[seg].iov_len;

		/* see if we we're about to use an invalid len or if
		 * it's about to overflow ssize_t */
		if (len < 0)
			return -EINVAL;
		if (len > MAX_RW_COUNT - ret) {
			len = MAX_RW_COUNT - ret;
			iov[seg].iov_len = len;
		}
		ret += len;
	}
	return ret;
}

/*
 *  This is merely an early sanity check; we do _not_ rely upon
 *  it when we get to the actual memory accesses.
 */
static bool check_iovecs(const struct iovec *iov, int nr_segs)
{
        for (seg = 0; seg < nr_segs; seg++) {
                void __user *buf = iov[seg].iov_base;
                ssize_t len = (ssize_t)iov[seg].iov_len;

                if (unlikely(!access_ok(buf, len)))
                        return false;
        }
	return true;
}

ssize_t import_iovec(int type, const struct iovec __user * uvector,
                 unsigned nr_segs, unsigned fast_segs,
                 struct iovec **iov, struct iov_iter *i)
{
	struct iovec *p;
	ssize_t n;

	n = rw_copy_check_uvector(uvector, nr_segs, fast_segs, *iov, &p);
	if (n > 0 && !check_iovecs(p, nr_segs))
		n = -EFAULT;
	if (n < 0) {
		if (p != *iov)
			kfree(p);
		*iov = NULL;
		return n;
	}
	iov_iter_init(i, type, p, nr_segs, n);
	*iov = p == *iov ? NULL : p;
	return n;
}

kill CHECK_IOVEC_ONLY and use rw_copy_check_uvector() without the type
argument in mm/process_vm_access.c

Saner that way, IMO...
