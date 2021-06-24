Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6FD3B2D35
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 13:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhFXLIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 07:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232220AbhFXLIu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 07:08:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52C1E611CE;
        Thu, 24 Jun 2021 11:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624532791;
        bh=jy1Ohwt6mASGLqB7LXAH9lJN7Il/Uo+VjdoVg3Kfy90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pKw3BmhiA/bll99Wx3MgBEfXQEYrDfP7NB2D//0fWxApPJho2DKYf94OJo4HVs+vG
         lKA6Ef5j65ILC7SecBz8j5aqAkks2FRJudOxFLwpeSt/sF1fWuLLZ8zodu7qZXglXN
         OxAnLI98ZgkjSugX4BojElnH9Zei/t1i4uSFNYuc=
Date:   Thu, 24 Jun 2021 13:06:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, rafael@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, atenart@kernel.org,
        alobakin@pm.me, weiwan@google.com, ap420073@gmail.com,
        jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, jikos@kernel.org, rostedt@goodmis.org,
        peterz@infradead.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] sysfs: fix kobject refcount to address races with
 kobject removal
Message-ID: <YNRnLzxvNUYcf4sx@kroah.com>
References: <20210623215007.862787-1-mcgrof@kernel.org>
 <202106231555.871D23D50@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202106231555.871D23D50@keescook>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 03:59:37PM -0700, Kees Cook wrote:
> On Wed, Jun 23, 2021 at 02:50:07PM -0700, Luis Chamberlain wrote:
> > It's possible today to have a device attribute read or store
> > race against device removal. This is known to happen as follows:
> > 
> > write system call -->
> >   ksys_write () -->
> >     vfs_write() -->
> >       __vfs_write() -->
> >         kernfs_fop_write_iter() -->
> >           sysfs_kf_write() -->
> >             dev_attr_store() -->
> >               null reference
> > 
> > This happens because the dev_attr->store() callback can be
> > removed prior to its call, after dev_attr_store() was initiated.
> > The null dereference is possible because the sysfs ops can be
> > removed on module removal, for instance, when device_del() is
> > called, and a sysfs read / store is not doing any kobject reference
> > bumps either. This allows a read/store call to initiate, a
> > device_del() to kick off, and then the read/store call can be
> > gone by the time to execute it.
> > 
> > The sysfs filesystem is not doing any kobject reference bumps during a
> > read / store ops to prevent this.
> > 
> > To fix this in a simplified way, just bump the kobject reference when
> > we create a directory and remove it on directory removal.
> > 
> > The big unfortunate eye-sore is addressing the manual kobject reference
> > assumption on the networking code, which leads me to believe we should
> > end up replacing that eventually with another sort of check.
> > 
> > Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> > 
> > This v4 moves to fixing the race condition on dev_attr_store() and
> > dev_attr_read() to sysfs by bumping the kobject reference count
> > on directory creation / deletion as suggested by Greg.
> > 
> > Unfortunately at least the networking core has a manual refcount
> > assumption, which needs to be adjusted to account for this change.
> > This should also mean there is runtime for other kobjects which may
> > not be explored yet which may need fixing as well. We may want to
> > change the check to something else on the networking front, but its
> > not clear to me yet what to use.
> > 
> >  fs/sysfs/dir.c | 3 +++
> >  net/core/dev.c | 4 ++--
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> > index 59dffd5ca517..6c47aa4af6f5 100644
> > --- a/fs/sysfs/dir.c
> > +++ b/fs/sysfs/dir.c
> > @@ -56,12 +56,14 @@ int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
> >  
> >  	kobject_get_ownership(kobj, &uid, &gid);
> >  
> > +	kobject_get(kobj);
> >  	kn = kernfs_create_dir_ns(parent, kobject_name(kobj),
> >  				  S_IRWXU | S_IRUGO | S_IXUGO, uid, gid,
> >  				  kobj, ns);
> >  	if (IS_ERR(kn)) {
> >  		if (PTR_ERR(kn) == -EEXIST)
> >  			sysfs_warn_dup(parent, kobject_name(kobj));
> > +		kobject_put(kobj);
> >  		return PTR_ERR(kn);
> >  	}
> >  
> > @@ -100,6 +102,7 @@ void sysfs_remove_dir(struct kobject *kobj)
> >  	if (kn) {
> >  		WARN_ON_ONCE(kernfs_type(kn) != KERNFS_DIR);
> >  		kernfs_remove(kn);
> > +		kobject_put(kobj);
> >  	}
> >  }
> 
> Shouldn't this be taken on open() not sysfs creation, or is the problem
> that the kobject is held the module memory rather than duplicated by
> sysfs?

No, this is when we are passing a pointer off to kernfs, it needs to
have the reference count incremented then otherwise it could "disappear"
without kernfs knowing about it.

> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 222b1d322c96..3a0ffa603d14 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -10429,7 +10429,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
> >  	rebroadcast_time = warning_time = jiffies;
> >  	refcnt = netdev_refcnt_read(dev);
> >  
> > -	while (refcnt != 1) {
> > +	while (refcnt != 3) {
> >  		if (time_after(jiffies, rebroadcast_time + 1 * HZ)) {
> >  			rtnl_lock();
> >  
> > @@ -10544,7 +10544,7 @@ void netdev_run_todo(void)
> >  		netdev_wait_allrefs(dev);
> >  
> >  		/* paranoia */
> > -		BUG_ON(netdev_refcnt_read(dev) != 1);
> > +		BUG_ON(netdev_refcnt_read(dev) != 3);
> 
> And surely there are things besides netdevs that would suffer from this
> change?

I _REALLY_ hope not.  No one should ever be looking at the count of a
kobject for anything as there are way too many ways that means nothing.

This is a fun hack for networking to be paranoid that they got their
initializion logic correct, so I'll leave it be right now.  No one else
should care, and if they do, we should fix it up...

thanks,

greg k-h
