Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801253944F6
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 17:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbhE1PYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 11:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhE1PYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 11:24:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AEAC061574;
        Fri, 28 May 2021 08:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UM5DN4/cqvUU0xmTLWTsMkmBxsLpKI9DFsTdLupUfM8=; b=rixJj00vbxOG8VpsVpP8RbwTCr
        7BdeaCq+hpyarwuXl+O3dOf5/mfbsr/do79SCZlf3on6u8YY3NZmQbi6VKZ8WEVqtJtGGU/Q0QI7E
        7/13hGYvF6K3ei013bzRtVwFVdSGdx+hMe5efukKz3ZVKnOnRqw5ipIDrdLxIBXF6zNNSS2CYn64r
        jkpPmGKmoUPksIDohqJaF0jo59P0Pfx82bIhjUY9UQECizoXUfdRMsXEPSo3rHMhIEkG02qytSW0/
        l9fmshRAtie23VjM/0TiggGalzRIWEC+vtQb/ObqtL/vKtzI+k3STDAathHQRnqwoIrkw7vZ+dFfN
        VUIRZJ2Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lmeJU-006kN3-P6; Fri, 28 May 2021 15:22:20 +0000
Date:   Fri, 28 May 2021 16:22:16 +0100
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
Message-ID: <YLEKqGkm8bX6LZfP@casper.infradead.org>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-3-justin.he@arm.com>
 <YLDpSnV9XBUJq5RU@casper.infradead.org>
 <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEDwFCPcFx+qeul@casper.infradead.org>
 <AM6PR08MB437615DB6A6DEC33223A3138F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR08MB437615DB6A6DEC33223A3138F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 03:09:28PM +0000, Justin He wrote:
> > I'm not sure why it's so complicated.  p->len records how many bytes
> > are needed for the entire path; can't you just return -p->len ?
> 
> prepend_name() will return at the beginning if p->len is <0 in this case,
> we can't even get the correct full path size if keep __prepend_path unchanged.
> We need another new helper __prepend_path_size() to get the full path size
> regardless of the negative value p->len.

It's a little hard to follow, based on just the patches.  Is there a
git tree somewhere of Al's patches that you're based on?

Seems to me that prepend_name() is just fine because it updates p->len
before returning false:

 static bool prepend_name(struct prepend_buffer *p, const struct qstr *name)
 {
 	const char *dname = smp_load_acquire(&name->name); /* ^^^ */
 	u32 dlen = READ_ONCE(name->len);
 	char *s;

 	p->len -= dlen + 1;
 	if (unlikely(p->len < 0))
 		return false;

I think the only change you'd need to make for vsnprintf() is in
prepend_path():

-		if (!prepend_name(&b, &dentry->d_name))
-			break;
+		prepend_name(&b, &dentry->d_name);

Would that hurt anything else?

> More than that, even the 1st vsnprintf could have _end_ > _buf_ in some case:
> What if printk("%pD", filp) ? The 1st vsnprintf has positive (end-buf).

I don't understand the problem ... if p->len is positive, then you
succeeded.  if p->len is negative then -p->len is the expected return
value from vsnprintf().  No?

