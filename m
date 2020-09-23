Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A79275A5F
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIWOkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 10:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgIWOkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:40:32 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C34AC0613CE;
        Wed, 23 Sep 2020 07:40:32 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kL5wX-004avv-5G; Wed, 23 Sep 2020 14:40:25 +0000
Date:   Wed, 23 Sep 2020 15:40:25 +0100
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
        linux-security-module@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/9] iov_iter: refactor rw_copy_check_uvector and
 import_iovec
Message-ID: <20200923144025.GL3421308@ZenIV.linux.org.uk>
References: <20200923060547.16903-1-hch@lst.de>
 <20200923060547.16903-4-hch@lst.de>
 <20200923141654.GJ3421308@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923141654.GJ3421308@ZenIV.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 03:16:54PM +0100, Al Viro wrote:
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
> 
> E.g. vfs_readv() quietly truncates vlen to 32 bits, and vlen can
> come unchanged through sys_readv() -> do_readv() -> vfs_readv().
> With unsigned long passed by syscall glue.
> 
> AFAICS, passing 4G+1 as the third argument to readv(2) on 64bit box
> will be quietly treated as 1 these days.  Which would be fine, except
> that before "switch {compat_,}do_readv_writev() to {compat_,}import_iovec()"
> it used to fail with -EINVAL.
> 
> Userland, BTW, describes readv(2) iovcnt as int; process_vm_readv(),
> OTOH, has these counts unsigned long from the userland POV...
> 
> I suppose we ought to switch import_iovec() to unsigned long for nr_segs ;-/
> Strictly speaking that had been a userland ABI change, even though nothing
> except regression tests checking for expected errors would've been likely
> to notice.  And it looks like no regression tests covered that one...
> 
> Linus, does that qualify for your "if no userland has noticed the change,
> it's not a breakage"?

Egads...  We have sys_readv() with unsigned long for file descriptor, since
1.3.31 when it had been introduced.  And originally it did comparison with
NR_OPEN right in sys_readv().  Then in 2.1.60 it had been switched to
fget(), which used to take unsigned long at that point.  And in 2.1.90pre1
it went unsigned int, so non-zero upper 32 bits in readv(2) first argument
ceased to cause EBADF...

Of course, libc had it as int fd all along.
