Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB546276152
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgIWTsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgIWTsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 15:48:07 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18231C0613CE;
        Wed, 23 Sep 2020 12:48:07 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLAk7-004l0B-Ms; Wed, 23 Sep 2020 19:47:55 +0000
Date:   Wed, 23 Sep 2020 20:47:55 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Networking <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 5/9] fs: remove various compat readv/writev helpers
Message-ID: <20200923194755.GR3421308@ZenIV.linux.org.uk>
References: <20200923060547.16903-1-hch@lst.de>
 <20200923060547.16903-6-hch@lst.de>
 <20200923142549.GK3421308@ZenIV.linux.org.uk>
 <20200923143251.GA14062@lst.de>
 <20200923145901.GN3421308@ZenIV.linux.org.uk>
 <20200923163831.GO3421308@ZenIV.linux.org.uk>
 <CAK8P3a3nkLUOkR+jwz2_2LcYTUTqdVf8JOtZqKWbtEDotNhFZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3nkLUOkR+jwz2_2LcYTUTqdVf8JOtZqKWbtEDotNhFZA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 08:45:51PM +0200, Arnd Bergmann wrote:
> On Wed, Sep 23, 2020 at 6:38 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > I wonder if we should do something like
> >
> > SYSCALL_DECLARE3(readv, unsigned long, fd, const struct iovec __user *, vec,
> >                  unsigned long, vlen);
> > in syscalls.h instead, and not under that ifdef.
> >
> > Let it expand to declaration of sys_...() in generic case and, on x86, into
> > __do_sys_...() and __ia32_sys_...()/__x64_sys_...(), with types matching
> > what SYSCALL_DEFINE ends up using.
> >
> > Similar macro would cover compat_sys_...() declarations.  That would
> > restore mismatch checking for x86 and friends.  AFAICS, the cost wouldn't
> > be terribly high - cpp would have more to chew through in syscalls.h,
> > but it shouldn't be all that costly.  Famous last words, of course...
> >
> > Does anybody see fundamental problems with that?
> 
> I've had some ideas along those lines in the past and I think it should work.
> 
> As a variation of this, the SYSCALL_DEFINEx() macros could go away
> entirely, leaving only the macro instantiations from the header to
> require that syntax. It would require first changing the remaining
> architectures to build the syscall table from C code instead of
> assembler though.
> 
> Regardless of that, another advantage of having the SYSCALL_DECLAREx()
> would be the ability to include that header file from elsewhere with a different
> macro definition to create a machine-readable version of the interface when
> combined with the syscall.tbl files. This could be used to create a user
> space stub for calling into the low-level syscall regardless of the
> libc interfaces,
> or for synchronizing the interfaces with strace, qemu-user, or anything that
> needs to deal with the low-level interface.

FWIW, after playing with that for a while...  Do we really want the
compat_sys_...() declarations to live in linux/compat.h?  Most of
the users of that file don't want those; why not move them to
linux/syscalls.h?

Reason: there's a lot more users of linux/compat.h than those of
linux/syscalls.h - it's pulled by everything in the networking stack,
for starters...
