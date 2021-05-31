Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9682395844
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 11:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhEaJmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 05:42:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:55936 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230500AbhEaJmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 05:42:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622454035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bPMteFR0fnmyo8FXBzBxRPRmVb4fglfAJIgPFxZ76ck=;
        b=fUx3YXqwD0FYvZRCenXctrEefGQaPnqoTrhsrCqr6gtMMdzrHn7ieUqpDhSpsgIMLE6vmZ
        yIU4fc6DL/cUolu5k960Gxlh8oizRRK4+SmC0UbANavCdZccin0KFMEMVg1If0YV691wVi
        WEnSrZAT6SGY/njmbiqICl2miIcbHZ0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7D2B2B4BA;
        Mon, 31 May 2021 09:40:35 +0000 (UTC)
Date:   Mon, 31 May 2021 11:40:34 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Justin He <Justin.He@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Message-ID: <YLSvEqQQj5RLjAJ/@alley>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-3-justin.he@arm.com>
 <YLDpSnV9XBUJq5RU@casper.infradead.org>
 <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <89fc3919-ca2c-50fd-35e1-33bf3a59b993@rasmusvillemoes.dk>
 <YLOsvz8ZbpjfcuGO@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLOsvz8ZbpjfcuGO@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun 2021-05-30 16:18:23, Matthew Wilcox wrote:
> On Fri, May 28, 2021 at 10:06:37PM +0200, Rasmus Villemoes wrote:
> > On 28/05/2021 16.22, Justin He wrote:
> > > 
> > >> From: Matthew Wilcox <willy@infradead.org>
> > 
> > >> How is it "safer"?  You already have a buffer passed from the caller.
> > >> Are you saying that d_path_fast() might overrun a really small buffer
> > >> but won't overrun a 256 byte buffer?
> > > No, it won't overrun a 256 byte buf. When the full path size is larger than 256, the p->len is < 0 in prepend_name, and this overrun will be
> > > dectected in extract_string() with "-ENAMETOOLONG".
> > > 
> > > Each printk contains 2 vsnprintf. vsnprintf() returns the required size after formatting the string.>
> > > 1. vprintk_store() will invoke 1st vsnprintf() will 8 bytes space to get the reserve_size. In this case, the _buf_ could be less than _end_ by design.
> > > 2. Then it invokes 2nd printk_sprint()->vscnprintf()->vsnprintf() to really fill the space.
> > 
> > Please do not assume that printk is the only user of vsnprintf() or the
> > only one that would use a given %p<foo> extension.
> > 
> > Also, is it clear that nothing can change underneath you in between two
> > calls to vsnprintf()? IOW, is it certain that the path will fit upon a
> > second call using the size returned from the first?
> 
> No, but that's also true of %s.  I think vprintk_store() is foolish to
> do it this way.

Just for record. vprintk_store() is foolish here by intention.
It avoids the need of static per-CPU X per-context buffers
and it is simple.

I believe that it should be good enough in practice. Any race here
would make the result racy anyway.

Of course, we might need to reconsider it if there are real life
problems with this approach.

Best Regards,
Petr
