Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FBA3B2D44
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 13:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhFXLL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 07:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232315AbhFXLLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 07:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6C14611CE;
        Thu, 24 Jun 2021 11:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624532945;
        bh=ipdW0KmT21fOP4law8edoBBMDuUDLXiDVr4XSG7gfOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PTm5EGY/nBGP/xGvrGLnlF+HfZsQCkVuiGdbIpPg5Gv6Bkmi+Y3g2jrY5EetWYMVl
         1l0ddXXsiqVHXxbhPAIIeM4+nWeqKjEbXh/ZWGCa/fwzYMu6j/zfVciu4yn8jN+TnN
         e5ZnTwQwnl1u8ehmB5v7n492Fnk0+C1DoOV5PvrU=
Date:   Thu, 24 Jun 2021 13:09:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     rafael@kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, andriin@fb.com, daniel@iogearbox.net,
        atenart@kernel.org, alobakin@pm.me, weiwan@google.com,
        ap420073@gmail.com, jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] sysfs: fix kobject refcount to address races with
 kobject removal
Message-ID: <YNRnzxTabyoToKKJ@kroah.com>
References: <20210623215007.862787-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623215007.862787-1-mcgrof@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 02:50:07PM -0700, Luis Chamberlain wrote:
> It's possible today to have a device attribute read or store
> race against device removal. This is known to happen as follows:
> 
> write system call -->
>   ksys_write () -->
>     vfs_write() -->
>       __vfs_write() -->
>         kernfs_fop_write_iter() -->
>           sysfs_kf_write() -->
>             dev_attr_store() -->
>               null reference
> 
> This happens because the dev_attr->store() callback can be
> removed prior to its call, after dev_attr_store() was initiated.
> The null dereference is possible because the sysfs ops can be
> removed on module removal, for instance, when device_del() is
> called, and a sysfs read / store is not doing any kobject reference
> bumps either. This allows a read/store call to initiate, a
> device_del() to kick off, and then the read/store call can be
> gone by the time to execute it.
> 
> The sysfs filesystem is not doing any kobject reference bumps during a
> read / store ops to prevent this.
> 
> To fix this in a simplified way, just bump the kobject reference when
> we create a directory and remove it on directory removal.
> 
> The big unfortunate eye-sore is addressing the manual kobject reference
> assumption on the networking code, which leads me to believe we should
> end up replacing that eventually with another sort of check.
> 
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
> 
> This v4 moves to fixing the race condition on dev_attr_store() and
> dev_attr_read() to sysfs by bumping the kobject reference count
> on directory creation / deletion as suggested by Greg.

This looks good.

It's late in the development cycle, I'll hold off on adding this to my
tree until 5.14-rc1 is out because of:

> Unfortunately at least the networking core has a manual refcount
> assumption, which needs to be adjusted to account for this change.
> This should also mean there is runtime for other kobjects which may
> not be explored yet which may need fixing as well. We may want to
> change the check to something else on the networking front, but its
> not clear to me yet what to use.

That's crazy what networking is doing here, hopefully no one else is.
If they are, let's shake it out in linux-next to find the problems which
is why a good "soak" there is a good idea.

thanks for making this change and sticking with it!

Oh, and with this change, does your modprobe/rmmod crazy test now work?

greg k-h
