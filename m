Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F91636E750
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 10:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240067AbhD2IrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 04:47:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:38342 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhD2IrT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 04:47:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619685991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S3QDYnjvvBLgh2dAPtQ9pkVbfHfZNetkQxLpUjGW754=;
        b=OtSF5u7L+L2LBMnAeCxzUjy4YNgAOoo0IsOcErHs3J8qzcRne5SXyyjiiQ88GBNySNydXZ
        1n6ud3MbJ7JFIP3WhvO+1/xNL/zKyFgiNX4p6E/fDMPqj4Fux+z8ohPY7CpyFnk4PYh3r6
        LANFD0TnI07HbOF7nmtvJ/3Vc5z0/MM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1F1F3AE56;
        Thu, 29 Apr 2021 08:46:31 +0000 (UTC)
Date:   Thu, 29 Apr 2021 10:46:30 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Jia He <justin.he@arm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH 2/4] lib/vsprintf.c: Make %p{D,d} mean as much components
 as possible
Message-ID: <YIpyZmi1Reh7iXeI@alley>
References: <20210428135929.27011-1-justin.he@arm.com>
 <20210428135929.27011-2-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428135929.27011-2-justin.he@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2021-04-28 21:59:27, Jia He wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> We have '%pD'(no digit following) for printing a filename. It may not be
> perfect (by default it only prints one component.
> 
> %pD4 should be more than good enough, but we should make plain "%pD" mean
> "as much of the path that is reasonable" rather than "as few components as
> possible" (ie 1).

Could you please provide link to the discussion where this idea was
came from?

It would be great to add and example into the commit message how
it improved the output.

Also please explain why it is useful/safe to change the behavior
for all existing users. It seems that you checked them and prevented
any regression by the other patches in this patchset.

Anyway, some regressions are fixed by the followup patches.
It would break bisection.

We either need to prevent the regression before this patch.
Or the changes have to be done in this patch. For example,
it would be perfectly fine to update test_printf.c in
this patch.

> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

If you want to keep Linus as the author and do more changes, you might
describe here changes done by you, for example:

[justin.he@arm.com: update documentation and test_printf]
Signed-off-by: Jia He <justin.he@arm.com>

Or you might make you the author and add

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>

> ---
>  Documentation/core-api/printk-formats.rst | 3 ++-
>  lib/vsprintf.c                            | 4 ++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
> index 9be6de402cb9..aa76cbec0dae 100644
> --- a/Documentation/core-api/printk-formats.rst
> +++ b/Documentation/core-api/printk-formats.rst

Plese, update also the pattern:

-	%pd{,2,3,4}
-	%pD{,2,3,4}
+	%pd{1,2,3,4}
+	%pD{1,2,3,4}

> @@ -413,7 +413,8 @@ dentry names
>  For printing dentry name; if we race with :c:func:`d_move`, the name might
>  be a mix of old and new ones, but it won't oops.  %pd dentry is a safer
>  equivalent of %s dentry->d_name.name we used to use, %pd<n> prints ``n``
> -last components.  %pD does the same thing for struct file.
> +last components.  %pD does the same thing for struct file. By default, %p{D,d}
> +is equal to %p{D,d}4.
>  
>  Passed by reference.

Best Regards,
Petr
