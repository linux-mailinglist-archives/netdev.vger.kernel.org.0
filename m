Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DF92716A3
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 20:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgITSIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 14:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgITSIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 14:08:01 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470E0C061755;
        Sun, 20 Sep 2020 11:08:01 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kK3kU-002bOQ-WD; Sun, 20 Sep 2020 18:07:43 +0000
Date:   Sun, 20 Sep 2020 19:07:42 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <20200920180742.GN3421308@ZenIV.linux.org.uk>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-2-hch@lst.de>
 <20200920151510.GS32101@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200920151510.GS32101@casper.infradead.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 04:15:10PM +0100, Matthew Wilcox wrote:
> On Fri, Sep 18, 2020 at 02:45:25PM +0200, Christoph Hellwig wrote:
> > Add a flag to force processing a syscall as a compat syscall.  This is
> > required so that in_compat_syscall() works for I/O submitted by io_uring
> > helper threads on behalf of compat syscalls.
> 
> Al doesn't like this much, but my suggestion is to introduce two new
> opcodes -- IORING_OP_READV32 and IORING_OP_WRITEV32.  The compat code
> can translate IORING_OP_READV to IORING_OP_READV32 and then the core
> code can know what that user pointer is pointing to.

Let's separate two issues:
	1) compat syscalls want 32bit iovecs.  Nothing to do with the
drivers, dealt with just fine.
	2) a few drivers are really fucked in head.  They use different
*DATA* layouts for reads/writes, depending upon the calling process.
IOW, if you fork/exec a 32bit binary and your stdin is one of those,
reads from stdin in parent and child will yield different data layouts.
On the same struct file.
	That's what Christoph worries about (/dev/sg he'd mentioned is
one of those).

	IMO we should simply have that dozen or so of pathological files
marked with FMODE_SHITTY_ABI; it's not about how they'd been opened -
it describes the userland ABI provided by those.  And it's cast in stone.

	Any in_compat_syscall() in ->read()/->write() instances is an ABI
bug, plain and simple.  Some are unfixable for compatibility reasons, but
any new caller like that should be a big red flag.

	How we import iovec array is none of the drivers' concern; we do
not need to mess with in_compat_syscall() reporting the matching value,
etc. for that.  It's about the instances that want in_compat_syscall() to
decide between the 32bit and 64bit data layouts.  And I believe that
we should simply have them marked as such and rejected by io_uring.  With
any new occurences getting slapped down hard.

	Current list of those turds:
/dev/sg (pointer-chasing, generally insane)
/sys/firmware/efi/vars/*/raw_var (fucked binary structure)
/sys/firmware/efi/vars/new_var (fucked binary structure)
/sys/firmware/efi/vars/del_var (fucked binary structure)
/dev/uhid	(pointer-chasing for one obsolete command)
/dev/input/event* (timestamps)
/dev/uinput (timestamps)
/proc/bus/input/devices (fucked bitmap-to-text representation)
/sys/class/input/*/capabilities/* (fucked bitmap-to-text representation)
