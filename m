Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208403B2466
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 03:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFXBMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 21:12:02 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:43999 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFXBMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 21:12:01 -0400
Received: by mail-pj1-f54.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso2436737pjp.2;
        Wed, 23 Jun 2021 18:09:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PO+OZdeB1TBNrmdfG2tVTtR4I3d+YFWVIm9pGwjwxnE=;
        b=cqDfDiiDKtWXhO4/aCcKIS9Msi7Koe0oMpUI4k06Jz9+JiiGzt7eNexUzogg7mmvQE
         zOL5fDy4UaYFOrDQktuwaFPyhyXhzlX0gCXGx5wINmCDh+3T2EnZYwm2HOnNF0Z/INxK
         0/EtOwlHDa+XMGSjdXgNlyUWQLbUOppz9XI0Mnqw5XS7MvtPA6XgZNO1NXNpEJ6dShWw
         QZkyV44vED3YrzIMSKbpe8tWM4b8L3BI/6JGbxJ9FwBrOKhe4aJwpyi8cVT2wEjAJx/c
         64/EXktekF7fI6teUnr/gcGCVdCmgAharfJv6jpeUkTTUxMQcc9zDtz/EFyd5QBHEBVk
         /+lw==
X-Gm-Message-State: AOAM532+Z2wniOOr7fqaoasypuMRxaWaNIi76v759XxbqG7XVvUDpeNW
        M3Wlw+SSQiRNTy918bSmYEw=
X-Google-Smtp-Source: ABdhPJz4hSR98F63n7IBaqWqCwwbKSQIvfmPp1JmZJih2MQBU+xd2rF2KWEtN3g1X+YSoC+euSnceQ==
X-Received: by 2002:a17:902:7d8f:b029:116:4b69:c7c5 with SMTP id a15-20020a1709027d8fb02901164b69c7c5mr1980892plm.58.1624496983406;
        Wed, 23 Jun 2021 18:09:43 -0700 (PDT)
Received: from garbanzo ([191.96.121.71])
        by smtp.gmail.com with ESMTPSA id o14sm289291pgk.82.2021.06.23.18.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 18:09:42 -0700 (PDT)
Date:   Wed, 23 Jun 2021 18:09:38 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     gregkh@linuxfoundation.org, rafael@kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, atenart@kernel.org, alobakin@pm.me,
        weiwan@google.com, ap420073@gmail.com, jeyu@kernel.org,
        ngupta@vflare.org, sergey.senozhatsky.work@gmail.com,
        minchan@kernel.org, axboe@kernel.dk, mbenes@suse.com,
        jpoimboe@redhat.com, tglx@linutronix.de, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] sysfs: fix kobject refcount to address races with
 kobject removal
Message-ID: <20210624010938.h6asniijrd2nrlyy@garbanzo>
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

If you kobject_get() you also protect from module removal to complete
until the calls ends. The issue is the dereference for the attribute
op will be gone if we don't protect the kobject during the op.

We only have an open() call for the bin sysfs files. So the alternative
is to sprinkly the get on all calls. The goal with adding it to the
directory creation was to simplify this.

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

Yes, I noted this possibility below the commit log, below the "---".

  Luis
