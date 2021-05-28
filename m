Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E9C394322
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 15:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbhE1NCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 09:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhE1NCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 09:02:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A74C061574;
        Fri, 28 May 2021 06:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZUYH3Mi14wG7kdhKEHxhtXEvN0lUYTCSCOFLNtrHy8U=; b=ApeMuFTFAmYrhq5vjgQD8SK9L/
        3Jr36omDQW+jP9z71Yj9q4mcFfIz/QvWcbW3MCmXI72eJdE1Y5CazcfgIM1KZlUU0nj8C/g9CsVzw
        JKe4dEZD2Sixv0LFh+4vEfEAGlUJLVI+4zFcx3bk1VkKcBWsJrhdhAS1cELocq0ONIO/futC6J2Aq
        HGOB9N/6/r+hJ0EseI9fOa1ZvYakcOj6SqqytcT2I2IAB4wjRGFqVs5x0EFt7375ZAMJCnZjchi1y
        Q7rzBYzdSQoBv+iMBZ8WNrVbZOtW5VIuygblyl3g40Gqxjo83YwPPspTP3s1kczXA3S3m/uzVwy9l
        7IyoDrsQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lmc5i-006clg-A9; Fri, 28 May 2021 12:59:59 +0000
Date:   Fri, 28 May 2021 13:59:54 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jia He <justin.he@arm.com>
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
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for
 file
Message-ID: <YLDpSnV9XBUJq5RU@casper.infradead.org>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-3-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528113951.6225-3-justin.he@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 07:39:50PM +0800, Jia He wrote:
> We have '%pD' for printing a filename. It may not be perfect (by
> default it only prints one component.)
> 
> As suggested by Linus at [1]:
> A dentry has a parent, but at the same time, a dentry really does
> inherently have "one name" (and given just the dentry pointers, you
> can't show mount-related parenthood, so in many ways the "show just
> one name" makes sense for "%pd" in ways it doesn't necessarily for
> "%pD"). But while a dentry arguably has that "one primary component",
> a _file_ is certainly not exclusively about that last component.
> 
> Hence "file_dentry_name()" simply shouldn't use "dentry_name()" at all.
> Despite that shared code origin, and despite that similar letter
> choice (lower-vs-upper case), a dentry and a file really are very
> different from a name standpoint.
> 
> Here stack space is preferred for file_d_path_name() because it is
> much safer. The stack size 256 is a compromise between stack overflow
> and too short full path.

How is it "safer"?  You already have a buffer passed from the caller.
Are you saying that d_path_fast() might overrun a really small buffer
but won't overrun a 256 byte buffer?

> @@ -920,13 +921,25 @@ char *dentry_name(char *buf, char *end, const struct dentry *d, struct printf_sp
>  }
>  
>  static noinline_for_stack
> -char *file_dentry_name(char *buf, char *end, const struct file *f,
> +char *file_d_path_name(char *buf, char *end, const struct file *f,
>  			struct printf_spec spec, const char *fmt)
>  {
> +	const struct path *path;
> +	char *p;
> +	char full_path[256];
> +
>  	if (check_pointer(&buf, end, f, spec))
>  		return buf;
>  
> -	return dentry_name(buf, end, f->f_path.dentry, spec, fmt);
> +	path = &f->f_path;
> +	if (check_pointer(&buf, end, path, spec))
> +		return buf;
> +
> +	p = d_path_fast(path, full_path, sizeof(full_path));
> +	if (IS_ERR(p))
> +		return err_ptr(buf, end, p, spec);
> +
> +	return string_nocheck(buf, end, p, spec);
>  }
>  #ifdef CONFIG_BLOCK
>  static noinline_for_stack
