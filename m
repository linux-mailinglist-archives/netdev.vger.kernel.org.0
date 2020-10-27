Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37C129A1DF
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409786AbgJ0Aoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:44:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44164 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436545AbgJ0Acv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 20:32:51 -0400
X-Greylist: delayed 1637 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 20:32:46 EDT
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXCUL-009VwG-7r; Tue, 27 Oct 2020 00:05:21 +0000
Date:   Tue, 27 Oct 2020 00:05:21 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kyle Huey <me@kylehuey.com>,
        open list <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Robert O'Callahan <robert@ocallahan.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "open list:FILESYSTEMS (VFS and infrastructure)" 
        <linux-fsdevel@vger.kernel.org>, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION] mm: process_vm_readv testcase no longer works after
 compat_prcoess_vm_readv removed
Message-ID: <20201027000521.GD3576660@ZenIV.linux.org.uk>
References: <CAP045Aqrsb=CXHDHx4nS-pgg+MUDj14r-kN8_Jcbn-NAUziVag@mail.gmail.com>
 <70d5569e-4ad6-988a-e047-5d12d298684c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70d5569e-4ad6-988a-e047-5d12d298684c@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 05:56:11PM -0600, Jens Axboe wrote:
> On 10/26/20 4:55 PM, Kyle Huey wrote:
> > A test program from the rr[0] test suite, vm_readv_writev[1], no
> > longer works on 5.10-rc1 when compiled as a 32 bit binary and executed
> > on a 64 bit kernel. The first process_vm_readv call (on line 35) now
> > fails with EFAULT. I have bisected this to
> > c3973b401ef2b0b8005f8074a10e96e3ea093823.
> > 
> > It should be fairly straightforward to extract the test case from our
> > repository into a standalone program.
> 
> Can you check with this applied?
> 
> diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> index fd12da80b6f2..05676722d9cd 100644
> --- a/mm/process_vm_access.c
> +++ b/mm/process_vm_access.c
> @@ -273,7 +273,8 @@ static ssize_t process_vm_rw(pid_t pid,
>  		return rc;
>  	if (!iov_iter_count(&iter))
>  		goto free_iov_l;
> -	iov_r = iovec_from_user(rvec, riovcnt, UIO_FASTIOV, iovstack_r, false);
> +	iov_r = iovec_from_user(rvec, riovcnt, UIO_FASTIOV, iovstack_r,
> +				in_compat_syscall());

_ouch_

There's a bug, all right, but I'm not sure that this is all there is to it.
For now it's probably the right fix, but...  Consider the fun trying to
use that from 32bit process to access the memory of 64bit one.  IOW, we
might want to add an explicit flag for "force 64bit addresses/sizes
in rvec".
