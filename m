Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A042884D3
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 10:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732553AbgJIIDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 04:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732393AbgJIIDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 04:03:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D83521789;
        Fri,  9 Oct 2020 08:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602230589;
        bh=fQcM168yLVyS2ZARRkBYciSvWnf+tfn++UbfD9IlDGY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1Bsbp+w9iQdRw0Oy6WcLqtS/f9PqyTy0EoMRb9PtauGjh3ZwuthPTI8ZhFOvyJ/Bi
         PX47s2B7KSWrUMruh7XS06ieqkVhhBk3p8/YSKSIkqdRdHBvgaGVISoPclaNALfFWP
         2eErWMC2iXQPXk9GSJ1Vrye6mtc7RbuEvei8tHDw=
Date:   Fri, 9 Oct 2020 10:03:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, nstange@suse.de, ap420073@gmail.com,
        David.Laight@aculab.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, rafael@kernel.org
Subject: Re: [CRAZY-RFF] debugfs: track open files and release on remove
Message-ID: <20201009080355.GA398994@kroah.com>
References: <87v9fkgf4i.fsf@suse.de>
 <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 09:53:06AM +0200, Johannes Berg wrote:
> [RFF = Request For Flaming]
> 
> THIS IS PROBABLY COMPLETELY CRAZY.
> 
> Currently, if a module is unloaded while debugfs files are being
> kept open, things crash since the ->release() method is called
> only at the actual release, despite the proxy_fops, and then the
> code is no longer around.
> 
> The correct way to fix this is to annotate all the debugfs fops
> with .owner= THIS_MODULE, but as a learning exercise and to see
> how much hate I can possibly receive, I figured I'd try to work
> around this in debugfs itself.

For lots of debugfs files, .owner should already be set, if you use the
DEFINE_SIMPLE_ATTRIBUTE() or DEFINE_DEBUGFS_ATTRIBUTE() macros.

But yes, not all.

> First, if the fops have a release method and no owner, we track
> all the open files - currently using a very simple array data
> structure for it linked into struct debugfs_fsdata. This required
> changing the API of debugfs_file_get() and debugfs_file_put() to
> pass the struct file * to it.
> 
> Then, once we know which files are still open at remove time, we
> can call all their release functions, and avoid calling them from
> the proxy_fops. Of course still call them from the proxy_fops if
> the file is still around, and clean up, so the release isn't all
> deferred to the end, but done as soon as possible.
> 
> This introduces a potential locking issue, we could have a fops
> struct that takes a lock in its release that the same module is
> also taking around debugfs_remove(). To flag these issues using
> lockdep, take inode_lock_shared() in full_proxy_release(), see
> the comment there. If this triggers for some fops, add the owner
> as it should have been in the first place.
> 
> Over adding the owner everywhere this has two small advantages:
>  1) you can unload the module while a debugfs file is open;
>  2) no need to change hundreds of places in the kernel :-)

I thought the proxy-ops stuff was supposed to fix this issue already.
Why isn't it, what is broken in them that causes this to still crash?

And of course, removing kernel modules is never a guaranteed operation,
nor is it anything that ever happens automatically, so is this really an
issue?  :)

thanks,

greg k-h
