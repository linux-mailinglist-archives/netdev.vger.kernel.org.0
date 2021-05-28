Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956C83942E7
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhE1Mqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbhE1Mqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:46:38 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80B0C061574;
        Fri, 28 May 2021 05:45:03 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lmbqV-001sdQ-IQ; Fri, 28 May 2021 12:44:11 +0000
Date:   Fri, 28 May 2021 12:44:11 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jia He <justin.he@arm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
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
Message-ID: <YLDlm94+A8GcNyWL@zeniv-ca.linux.org.uk>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-2-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528113951.6225-2-justin.he@arm.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 07:39:49PM +0800, Jia He wrote:

> +/**
> + * d_path_fast - fast return the full path of a dentry without taking
> + * any seqlock/spinlock. This helper is typical for debugging purpose
> + */
> +char *d_path_fast(const struct path *path, char *buf, int buflen)
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

Umm...  I'd suggest failing if __prepend_path() returns 3 (at least)...
