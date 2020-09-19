Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2485271137
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 00:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgISWlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 18:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgISWlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 18:41:31 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A614C0613CE;
        Sat, 19 Sep 2020 15:41:31 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJlXm-001zb3-7c; Sat, 19 Sep 2020 22:41:22 +0000
Date:   Sat, 19 Sep 2020 23:41:22 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Andy Lutomirski <luto@amacapital.net>
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
Message-ID: <20200919224122.GJ3421308@ZenIV.linux.org.uk>
References: <20200919220920.GI3421308@ZenIV.linux.org.uk>
 <AA2CFC7E-E685-4596-84AD-0E314137B93F@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AA2CFC7E-E685-4596-84AD-0E314137B93F@amacapital.net>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 03:23:54PM -0700, Andy Lutomirski wrote:
> 
> > On Sep 19, 2020, at 3:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > 
> > ﻿On Fri, Sep 18, 2020 at 05:16:15PM +0200, Christoph Hellwig wrote:
> >>> On Fri, Sep 18, 2020 at 02:58:22PM +0100, Al Viro wrote:
> >>> Said that, why not provide a variant that would take an explicit
> >>> "is it compat" argument and use it there?  And have the normal
> >>> one pass in_compat_syscall() to that...
> >> 
> >> That would help to not introduce a regression with this series yes.
> >> But it wouldn't fix existing bugs when io_uring is used to access
> >> read or write methods that use in_compat_syscall().  One example that
> >> I recently ran into is drivers/scsi/sg.c.
> > 
> > So screw such read/write methods - don't use them with io_uring.
> > That, BTW, is one of the reasons I'm sceptical about burying the
> > decisions deep into the callchain - we don't _want_ different
> > data layouts on read/write depending upon the 32bit vs. 64bit
> > caller, let alone the pointer-chasing garbage that is /dev/sg.
> 
> Well, we could remove in_compat_syscall(), etc and instead have an implicit parameter in DEFINE_SYSCALL.  Then everything would have to be explicit.  This would probably be a win, although it could be quite a bit of work.

It would not be a win - most of the syscalls don't give a damn
about 32bit vs. 64bit...
