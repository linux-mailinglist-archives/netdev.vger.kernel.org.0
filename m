Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B8C271749
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 21:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgITTCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 15:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgITTCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 15:02:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E732C061755;
        Sun, 20 Sep 2020 12:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IDW3RmS0RDwF1PxkMWRCY+cTnTy0vBsZViqlQFFmOdo=; b=g5wq+0/nR7te7B4gJNw+xxZEh4
        vIYebQdoarMEpWmpRDhj1bWsfYD36OHjLCErlQNaLSUq8CTrXuLatwHN9B+K+KO1QIhzWqG7Z6waK
        del3pmKFJAAuj35sQYQznNEe+qO0m5iu5fRGSMsKcikhX7RyrIn/RWw/VFHRk4mWe6oZMZa9R6Je1
        oGcYf/SOT5wxGjakHifLpr17yPf4i9EhX/Cy94JdQ9a5xDZHTyc0bbRlyh+8XGfdroAgldwfZpb7H
        4VqjUhxS1EFiueOXW0SA9H6gHtPsQs2vFJVBdst+6vs08n2gMA9frgF4VF0y0tLMDhkql0UrCuprC
        yBGQJbwg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kK4b1-0000nk-2G; Sun, 20 Sep 2020 19:01:59 +0000
Date:   Sun, 20 Sep 2020 20:01:59 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
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
Message-ID: <20200920190159.GT32101@casper.infradead.org>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-2-hch@lst.de>
 <20200920151510.GS32101@casper.infradead.org>
 <20200920180742.GN3421308@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200920180742.GN3421308@ZenIV.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 07:07:42PM +0100, Al Viro wrote:
> 	2) a few drivers are really fucked in head.  They use different
> *DATA* layouts for reads/writes, depending upon the calling process.
> IOW, if you fork/exec a 32bit binary and your stdin is one of those,
> reads from stdin in parent and child will yield different data layouts.
> On the same struct file.
> 	That's what Christoph worries about (/dev/sg he'd mentioned is
> one of those).
> 
> 	IMO we should simply have that dozen or so of pathological files
> marked with FMODE_SHITTY_ABI; it's not about how they'd been opened -
> it describes the userland ABI provided by those.  And it's cast in stone.
> 
> 	Any in_compat_syscall() in ->read()/->write() instances is an ABI
> bug, plain and simple.  Some are unfixable for compatibility reasons, but
> any new caller like that should be a big red flag.

So an IOCB_COMPAT flag would let us know whether the caller is expecting
a 32-bit or 64-bit layout?  And io_uring could set it based on the
ctx->compat flag.

> 	Current list of those turds:
> /dev/sg (pointer-chasing, generally insane)
> /sys/firmware/efi/vars/*/raw_var (fucked binary structure)
> /sys/firmware/efi/vars/new_var (fucked binary structure)
> /sys/firmware/efi/vars/del_var (fucked binary structure)
> /dev/uhid	(pointer-chasing for one obsolete command)
> /dev/input/event* (timestamps)
> /dev/uinput (timestamps)
> /proc/bus/input/devices (fucked bitmap-to-text representation)
> /sys/class/input/*/capabilities/* (fucked bitmap-to-text representation)
