Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B88A2711D6
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 04:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgITC54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 22:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITC5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 22:57:55 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8DAC061755;
        Sat, 19 Sep 2020 19:57:55 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJpXt-0026Rb-Iq; Sun, 20 Sep 2020 02:57:45 +0000
Date:   Sun, 20 Sep 2020 03:57:45 +0100
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
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <20200920025745.GL3421308@ZenIV.linux.org.uk>
References: <20200919224122.GJ3421308@ZenIV.linux.org.uk>
 <36CF3DE7-7B4B-41FD-9818-FDF8A5B440FB@amacapital.net>
 <20200919232411.GK3421308@ZenIV.linux.org.uk>
 <CALCETrViwOdFia_aX4p4riE8aqop1zoOqVfiQtSAZEzheC+Ozg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrViwOdFia_aX4p4riE8aqop1zoOqVfiQtSAZEzheC+Ozg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 05:14:41PM -0700, Andy Lutomirski wrote:

> > 2) have you counted the syscalls that do and do not need that?
> 
> No.

Might be illuminating...

> > 3) how many of those realistically *can* be unified with their
> > compat counterparts?  [hint: ioctl(2) cannot]
> 
> There would be no requirement to unify anything.  The idea is that
> we'd get rid of all the global state flags.

_What_ global state flags?  When you have separate SYSCALL_DEFINE3(ioctl...)
and COMPAT_SYSCALL_DEFINE3(ioctl...), there's no flags at all, global or
local.  They only come into the play when you try to share the same function
for both, right on the top level.

> For ioctl, we'd have a new file_operation:
> 
> long ioctl(struct file *, unsigned int, unsigned long, enum syscall_arch);
> 
> I'm not saying this is easy, but I think it's possible and the result
> would be more obviously correct than what we have now.

No, it would not.  Seriously, from time to time a bit of RTFS before grand
proposals turns out to be useful.
