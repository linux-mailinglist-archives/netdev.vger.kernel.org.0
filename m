Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3ADA2716EE
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 20:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgITSMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 14:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgITSMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 14:12:15 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43F1C061755;
        Sun, 20 Sep 2020 11:12:14 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kK3om-002bUn-Fx; Sun, 20 Sep 2020 18:12:08 +0000
Date:   Sun, 20 Sep 2020 19:12:08 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <20200920181208.GO3421308@ZenIV.linux.org.uk>
References: <20200919224122.GJ3421308@ZenIV.linux.org.uk>
 <36CF3DE7-7B4B-41FD-9818-FDF8A5B440FB@amacapital.net>
 <20200919232411.GK3421308@ZenIV.linux.org.uk>
 <CALCETrViwOdFia_aX4p4riE8aqop1zoOqVfiQtSAZEzheC+Ozg@mail.gmail.com>
 <20200920025745.GL3421308@ZenIV.linux.org.uk>
 <CALCETrWj1i-oyfA1rCXsNqdJddK6Vwm=W31YEf=k-OMBTC0vHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWj1i-oyfA1rCXsNqdJddK6Vwm=W31YEf=k-OMBTC0vHw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 09:59:36AM -0700, Andy Lutomirski wrote:

> As one example, look at __sys_setsockopt().  It's called for the
> native and compat versions, and it contains an in_compat_syscall()
> check.  (This particularly check looks dubious to me, but that's
> another story.)  If this were to be done with equivalent semantics
> without a separate COMPAT_DEFINE_SYSCALL and without
> in_compat_syscall(), there would need to be some indication as to
> whether this is compat or native setsockopt.  There are other
> setsockopt implementations in the net stack with more
> legitimate-seeming uses of in_compat_syscall() that would need some
> other mechanism if in_compat_syscall() were to go away.
> 
> setsockopt is (I hope!) out of scope for io_uring, but the situation
> isn't fundamentally different from read and write.

	Except that setsockopt() had that crap very widespread; for read()
and write() those are very rare exceptions.

	Andy, please RTFS.  Or dig through archives.  The situation
with setsockopt() is *NOT* a good thing - it's (probably) the least
of the evils.  The last thing we need is making that the norm.
