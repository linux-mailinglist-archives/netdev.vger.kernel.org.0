Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F633951AF
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 17:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhE3PVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 11:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhE3PVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 11:21:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389A4C061574;
        Sun, 30 May 2021 08:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=y3DXZLXagxiVtFwWPQ3/eHYfS2BTxh16gXAXVZkHbvs=; b=ERoCFxV5SBNYHz1mskauOJriQG
        y0EBj4Br/zzwvWrtLk3vX22nZllTohRJ5TQZXvvoR/DlZWEdD3+J+aWd0D3MjDgXqjeMomuoREo15
        Cfme5ehFNPenJvMiyHyXZhqmVhuziWXecTBPN2yyAErWv0+ZAjvCLEpJ92Ql6y1m+BoQ6Laiocewj
        hDPS6WoBh9JirO2W57C45f6LVKRUSZVMBQx/E/OIb+lhnSF5lAShLs5xdPXkA101Cn4AzSahmxMsp
        NXTwIOgJlFR9nzMnOPnnJ3kTwfN5Ap8ZJoaS1yNCQw5RN7dpPBfESQiaB/yYHdk3cdZr0ikeOD0Kl
        eA1SFVtg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lnNCp-008Dun-I2; Sun, 30 May 2021 15:18:26 +0000
Date:   Sun, 30 May 2021 16:18:23 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Justin He <Justin.He@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
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
Message-ID: <YLOsvz8ZbpjfcuGO@casper.infradead.org>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-3-justin.he@arm.com>
 <YLDpSnV9XBUJq5RU@casper.infradead.org>
 <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <89fc3919-ca2c-50fd-35e1-33bf3a59b993@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89fc3919-ca2c-50fd-35e1-33bf3a59b993@rasmusvillemoes.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 10:06:37PM +0200, Rasmus Villemoes wrote:
> On 28/05/2021 16.22, Justin He wrote:
> > 
> >> From: Matthew Wilcox <willy@infradead.org>
> 
> >> How is it "safer"?  You already have a buffer passed from the caller.
> >> Are you saying that d_path_fast() might overrun a really small buffer
> >> but won't overrun a 256 byte buffer?
> > No, it won't overrun a 256 byte buf. When the full path size is larger than 256, the p->len is < 0 in prepend_name, and this overrun will be
> > dectected in extract_string() with "-ENAMETOOLONG".
> > 
> > Each printk contains 2 vsnprintf. vsnprintf() returns the required size after formatting the string.>
> > 1. vprintk_store() will invoke 1st vsnprintf() will 8 bytes space to get the reserve_size. In this case, the _buf_ could be less than _end_ by design.
> > 2. Then it invokes 2nd printk_sprint()->vscnprintf()->vsnprintf() to really fill the space.
> 
> Please do not assume that printk is the only user of vsnprintf() or the
> only one that would use a given %p<foo> extension.
> 
> Also, is it clear that nothing can change underneath you in between two
> calls to vsnprintf()? IOW, is it certain that the path will fit upon a
> second call using the size returned from the first?

No, but that's also true of %s.  I think vprintk_store() is foolish to
do it this way.
