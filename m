Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF18D29669E
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 23:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898468AbgJVV2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 17:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507136AbgJVV2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 17:28:46 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0E9C0613CE;
        Thu, 22 Oct 2020 14:28:45 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVi8K-006V84-LA; Thu, 22 Oct 2020 21:28:28 +0000
Date:   Thu, 22 Oct 2020 22:28:28 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@lst.de>,
        David Hildenbrand <david@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: Buggy commit tracked to: "Re: [PATCH 2/9] iov_iter: move
 rw_copy_check_uvector() into lib/iov_iter.c"
Message-ID: <20201022212828.GZ3576660@ZenIV.linux.org.uk>
References: <20201022090155.GA1483166@kroah.com>
 <e04d0c5d-e834-a15b-7844-44dcc82785cc@redhat.com>
 <a1533569-948a-1d5b-e231-5531aa988047@redhat.com>
 <bc0a091865f34700b9df332c6e9dcdfd@AcuMS.aculab.com>
 <5fd6003b-55a6-2c3c-9a28-8fd3a575ca78@redhat.com>
 <20201022132342.GB8781@lst.de>
 <8f1fff0c358b4b669d51cc80098dbba1@AcuMS.aculab.com>
 <20201022164040.GV20115@casper.infradead.org>
 <CAKwvOdnq-yYLcF_coo=jMV-RH-SkuNp_kMB+KCBF5cz3PwiB8g@mail.gmail.com>
 <20201022205932.GB3613750@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022205932.GB3613750@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 01:59:32PM -0700, Eric Biggers wrote:

> Also note the following program succeeds on Linux 5.9 on x86_64.  On kernels
> that have this bug, it should fail.  (I couldn't get it to actually fail, so it
> must depend on the compiler and/or the kernel config...)

It doesn't.  See https://www.spinics.net/lists/linux-scsi/msg147836.html for
discussion of that mess.

ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
                  unsigned long vlen, loff_t *pos, rwf_t flags)
{
        struct iovec iovstack[UIO_FASTIOV];
        struct iovec *iov = iovstack;
        struct iov_iter iter;
        ssize_t ret;

        ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
        if (ret >= 0) {
                ret = do_iter_read(file, &iter, pos, flags);
                kfree(iov);
        }

        return ret;
}

and import_iovec() takes unsigned int as the third argument, so it *will*
truncate to 32 bits, no matter what.  Has done so since 0504c074b546
"switch {compat_,}do_readv_writev() to {compat_,}import_iovec()" back in
March 2015.  Yes, it was an incompatible userland ABI change, even though
nothing that used glibc/uclibc/dietlibc would've noticed.

Better yet, up until 2.1.90pre1 passing a 64bit value as the _first_ argument
of readv(2) used to fail with -EBADF if it was too large; at that point it
started to get quietly truncated to 32bit first.  And again, no libc users
would've noticed (neither would anything except deliberate regression test
looking for that specific behaviour).

Note that we also have process_madvise(2) with size_t for vlen (huh?  It's
a number of array elements, not an object size) and process_vm_{read,write}v(2),
that have unsigned long for the same thing.  And the last two *are* using
the same unsigned long from glibc POV.
