Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78323275D9D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgIWQio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIWQin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:38:43 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33F6C0613CE;
        Wed, 23 Sep 2020 09:38:42 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kL7mp-004f4D-Mx; Wed, 23 Sep 2020 16:38:31 +0000
Date:   Wed, 23 Sep 2020 17:38:31 +0100
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
Subject: Re: [PATCH 5/9] fs: remove various compat readv/writev helpers
Message-ID: <20200923163831.GO3421308@ZenIV.linux.org.uk>
References: <20200923060547.16903-1-hch@lst.de>
 <20200923060547.16903-6-hch@lst.de>
 <20200923142549.GK3421308@ZenIV.linux.org.uk>
 <20200923143251.GA14062@lst.de>
 <20200923145901.GN3421308@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923145901.GN3421308@ZenIV.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 03:59:01PM +0100, Al Viro wrote:

> > That's a very good question.  But it does not just compile but actually
> > works.  Probably because all the syscall wrappers mean that we don't
> > actually generate the normal names.  I just tried this:
> > 
> > --- a/include/linux/syscalls.h
> > +++ b/include/linux/syscalls.h
> > @@ -468,7 +468,7 @@ asmlinkage long sys_lseek(unsigned int fd, off_t offset,
> >  asmlinkage long sys_read(unsigned int fd, char __user *buf, size_t count);
> >  asmlinkage long sys_write(unsigned int fd, const char __user *buf,
> >                             size_t count);
> > -asmlinkage long sys_readv(unsigned long fd,
> > +asmlinkage long sys_readv(void *fd,
> > 
> > for fun, and the compiler doesn't care either..
> 
> Try to build it for sparc or ppc...

FWIW, declarations in syscalls.h used to serve 4 purposes:
	1) syscall table initializers needed symbols declared
	2) direct calls needed the same
	3) catching mismatches between the declarations and definitions
	4) centralized list of all syscalls

(2) has been (thankfully) reduced for some time; in any case, ksys_... is
used for the remaining ones.

(1) and (3) are served by syscalls.h in architectures other than x86, arm64
and s390.  On those 3 (1) is done otherwise (near the syscall table initializer)
and (3) is not done at all.

I wonder if we should do something like

SYSCALL_DECLARE3(readv, unsigned long, fd, const struct iovec __user *, vec,
		 unsigned long, vlen);
in syscalls.h instead, and not under that ifdef.

Let it expand to declaration of sys_...() in generic case and, on x86, into
__do_sys_...() and __ia32_sys_...()/__x64_sys_...(), with types matching
what SYSCALL_DEFINE ends up using.

Similar macro would cover compat_sys_...() declarations.  That would
restore mismatch checking for x86 and friends.  AFAICS, the cost wouldn't
be terribly high - cpp would have more to chew through in syscalls.h,
but it shouldn't be all that costly.  Famous last words, of course...

Does anybody see fundamental problems with that?
