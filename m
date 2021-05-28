Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB55C3942F9
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhE1Myd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhE1Myc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:54:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E397C061574;
        Fri, 28 May 2021 05:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wHOvG1vDEULjx9dh7AJNtG0WjNHcmlGHIun6OjtdMM0=; b=fGrPFSQdJb65SToPvKgOHyY0AR
        It3eAVUf9rZxrA+8xkck2GzCBktNCbZjNOm7ndxfNU1GUir6kJX0YQ2nD666Yw647m9FwwPOW7JXy
        lZvveL35XRpp9n4lvPBqT5z20rN2G08+8sp7iTO00vXryVZF3vRCiRyJRLvCg66O9WB8++72SCybP
        uhburtlL4UgsYqTeYOjCCx9k077b4fWoCHyvKNPMA1mbnweCFC2J7F7PMwj8nQ+IOqTqBbCLxyeBQ
        Ti3EKSXsIvYXSf/UswH+VdEX/LKqxewEPIaxzdNNDU+WYK9xgaMBuuw8/RgeERMvdC5fQtpz147lA
        bVO5YeQA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lmby1-006cNL-1Y; Fri, 28 May 2021 12:51:59 +0000
Date:   Fri, 28 May 2021 13:51:57 +0100
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
Subject: Re: [PATCH RFCv2 1/3] fs: introduce helper d_path_fast()
Message-ID: <YLDnbafc6mEXENfy@casper.infradead.org>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-2-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528113951.6225-2-justin.he@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 07:39:49PM +0800, Jia He wrote:
> +/**
> + * d_path_fast - fast return the full path of a dentry without taking
> + * any seqlock/spinlock. This helper is typical for debugging purpose
> + */
> +char *d_path_fast(const struct path *path, char *buf, int buflen)

I'd suggest calling it d_path_unsafe().  Otherwise people will call it
instead of d_path because who doesn't like fast?

> +{
> +	struct path root;
> +	struct mount *mnt = real_mount(path->mnt);
> +	DECLARE_BUFFER(b, buf, buflen);
> +
> +	rcu_read_lock();
> +	get_fs_root_rcu(current->fs, &root);
> +
> +	prepend(&b, "", 1);
> +	__prepend_path(path->dentry, mnt, &root, &b);
> +	rcu_read_unlock();
> +
> +	return extract_string(&b);
> +}
> +EXPORT_SYMBOL(d_path_fast);

Why export it?  What module needs this?
