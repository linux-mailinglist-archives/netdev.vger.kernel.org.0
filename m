Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A39394485
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbhE1OzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235415AbhE1OzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 10:55:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C92C061574;
        Fri, 28 May 2021 07:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eYPDj+LfIhrv+LaA3M9K/3pjJ6DaX5CeFYMC/mFkVBE=; b=gQ1U2K3Xo+QlISz1KdFvyYrZPb
        2mqImu2CRR6ObYKJPMvmMOg/7qtwA9DlvVtyqKYsUFY+L3x3eJ4NpTZG66ztCfFhlim23uBIxdXDZ
        VoxIcoucNkIsQLnwbk8AHiOx4l0MGYhHcjgyhFR6tXvkoO2mPqN1pSeIIyvDT9EfOibSwfoyEhuC5
        MISE/nlH1O+MJaoECgujjrTSwn14YwX3+mzTqtXMu3j3Iq1YPbeMdYizz12fUbsh/NiH4TqEMw8SS
        lfQzgxngIwHJmBqY4CA+Lcd/WAsbCFNn4A1An8SH2nrtg+P24dR+b303UHZOr8EG5ggdyScucqrDQ
        6AmUmNYA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lmdqz-006iup-0i; Fri, 28 May 2021 14:52:49 +0000
Date:   Fri, 28 May 2021 15:52:48 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Justin He <Justin.He@arm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for
 file
Message-ID: <YLEDwFCPcFx+qeul@casper.infradead.org>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-3-justin.he@arm.com>
 <YLDpSnV9XBUJq5RU@casper.infradead.org>
 <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 02:22:01PM +0000, Justin He wrote:
> > On Fri, May 28, 2021 at 07:39:50PM +0800, Jia He wrote:
> > > We have '%pD' for printing a filename. It may not be perfect (by
> > > default it only prints one component.)
> > >
> > > As suggested by Linus at [1]:
> > > A dentry has a parent, but at the same time, a dentry really does
> > > inherently have "one name" (and given just the dentry pointers, you
> > > can't show mount-related parenthood, so in many ways the "show just
> > > one name" makes sense for "%pd" in ways it doesn't necessarily for
> > > "%pD"). But while a dentry arguably has that "one primary component",
> > > a _file_ is certainly not exclusively about that last component.
> > >
> > > Hence "file_dentry_name()" simply shouldn't use "dentry_name()" at all.
> > > Despite that shared code origin, and despite that similar letter
> > > choice (lower-vs-upper case), a dentry and a file really are very
> > > different from a name standpoint.
> > >
> > > Here stack space is preferred for file_d_path_name() because it is
> > > much safer. The stack size 256 is a compromise between stack overflow
> > > and too short full path.
> >
> > How is it "safer"?  You already have a buffer passed from the caller.
> > Are you saying that d_path_fast() might overrun a really small buffer
> > but won't overrun a 256 byte buffer?
> No, it won't overrun a 256 byte buf. When the full path size is larger than 256, the p->len is < 0 in prepend_name, and this overrun will be
> dectected in extract_string() with "-ENAMETOOLONG".
> 
> Each printk contains 2 vsnprintf. vsnprintf() returns the required size after formatting the string.
> 1. vprintk_store() will invoke 1st vsnprintf() will 8 bytes space to get the reserve_size. In this case, the _buf_ could be less than _end_ by design.
> 2. Then it invokes 2nd printk_sprint()->vscnprintf()->vsnprintf() to really fill the space.

I think you need to explain _that_ in the commit log, not make some
nebulous claim of "safer".

> If we choose the stack space, it can meet above 2 cases.
> 
> If we pass the parameter like:
> p = d_path_fast(path, buf, end - buf);
> We need to handle the complicated logic in prepend_name()
> I have tried this way in local test, the code logic is very complicated
> and not so graceful.
> e.g. I need to firstly go through the loop and get the full path size of
> that file. And then return reserved_size for that 1st vsnprintf

I'm not sure why it's so complicated.  p->len records how many bytes
are needed for the entire path; can't you just return -p->len ?
