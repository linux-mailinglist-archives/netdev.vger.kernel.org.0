Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A7F271759
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 21:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgITTKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 15:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgITTKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 15:10:43 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CF2C061755;
        Sun, 20 Sep 2020 12:10:42 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kK4jH-002dC7-8S; Sun, 20 Sep 2020 19:10:31 +0000
Date:   Sun, 20 Sep 2020 20:10:31 +0100
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
Message-ID: <20200920191031.GQ3421308@ZenIV.linux.org.uk>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-2-hch@lst.de>
 <20200920151510.GS32101@casper.infradead.org>
 <20200920180742.GN3421308@ZenIV.linux.org.uk>
 <20200920190159.GT32101@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200920190159.GT32101@casper.infradead.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 08:01:59PM +0100, Matthew Wilcox wrote:
> On Sun, Sep 20, 2020 at 07:07:42PM +0100, Al Viro wrote:
> > 	2) a few drivers are really fucked in head.  They use different
> > *DATA* layouts for reads/writes, depending upon the calling process.
> > IOW, if you fork/exec a 32bit binary and your stdin is one of those,
> > reads from stdin in parent and child will yield different data layouts.
> > On the same struct file.
> > 	That's what Christoph worries about (/dev/sg he'd mentioned is
> > one of those).
> > 
> > 	IMO we should simply have that dozen or so of pathological files
> > marked with FMODE_SHITTY_ABI; it's not about how they'd been opened -
> > it describes the userland ABI provided by those.  And it's cast in stone.
> > 
> > 	Any in_compat_syscall() in ->read()/->write() instances is an ABI
> > bug, plain and simple.  Some are unfixable for compatibility reasons, but
> > any new caller like that should be a big red flag.
> 
> So an IOCB_COMPAT flag would let us know whether the caller is expecting
> a 32-bit or 64-bit layout?  And io_uring could set it based on the
> ctx->compat flag.

So you want to convert all that crap to a form that would see iocb
(IOW, ->read_iter()/->write_iter())?  And, since quite a few are sysfs
attributes, propagate that through sysfs, changing the method signatures
to match that and either modifying fuckloads of instances or introducing
new special methods for the ones that are sensitive to that crap?

IMO it's much saner to mark those and refuse to touch them from io_uring...
