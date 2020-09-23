Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A15275AAA
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgIWOt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 10:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgIWOtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:49:25 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA320C0613CE;
        Wed, 23 Sep 2020 07:49:24 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kL657-004bBq-D5; Wed, 23 Sep 2020 14:49:17 +0000
Date:   Wed, 23 Sep 2020 15:49:17 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Laight <David.Laight@aculab.com>
Cc:     Christoph Hellwig <hch@lst.de>,
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
        <linux-security-module@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/9] iov_iter: refactor rw_copy_check_uvector and
 import_iovec
Message-ID: <20200923144917.GM3421308@ZenIV.linux.org.uk>
References: <20200923060547.16903-1-hch@lst.de>
 <20200923060547.16903-4-hch@lst.de>
 <20200923141654.GJ3421308@ZenIV.linux.org.uk>
 <200cf2b9ce5e408f8838948fda7ce9a0@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200cf2b9ce5e408f8838948fda7ce9a0@AcuMS.aculab.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 02:38:24PM +0000, David Laight wrote:
> From: Al Viro
> > Sent: 23 September 2020 15:17
> > 
> > On Wed, Sep 23, 2020 at 08:05:41AM +0200, Christoph Hellwig wrote:
> > 
> > > +struct iovec *iovec_from_user(const struct iovec __user *uvec,
> > > +		unsigned long nr_segs, unsigned long fast_segs,
> > 
> > Hmm...  For fast_segs unsigned long had always been ridiculous
> > (4G struct iovec on caller stack frame?), but that got me wondering about
> > nr_segs and I wish I'd thought of that when introducing import_iovec().
> > 
> > The thing is, import_iovec() takes unsigned int there.  Which is fine
> > (hell, the maximal value that can be accepted in 1024), except that
> > we do pass unsigned long syscall argument to it in some places.
> 
> It will make diddly-squit difference.
> The parameters end up in registers on most calling conventions.
> Plausibly you get an extra 'REX' byte on x86 for the 64bit value.
> What you want to avoid is explicit sign/zero extension and value
> masking after arithmetic.

Don't tell me what I want; your telepathic abilities are consistently sucky.

I am *NOT* talking about microoptimization here.  I have described
the behaviour change of syscall caused by commit 5 years ago.  Which is
generally considered a problem.  Then I asked whether that behaviour
change would fall under the "if nobody noticed, it's not a userland ABI
breakage" exception.

Could you show me the point where I have expressed concerns about
the quality of amd64 code generated for that thing, before or after
the change in question?
