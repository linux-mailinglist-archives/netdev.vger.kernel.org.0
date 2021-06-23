Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDE43B23B9
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 00:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhFWXB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 19:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhFWXB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 19:01:58 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E97CC061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 15:59:39 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c15so1921347pls.13
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 15:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AR/Ua1TRk1srTsKUy9Kk92PMxSf64zM0MUfZcN6Owxg=;
        b=dWJTfn04TrFiACb2m/tWOsyDj+TjOwkXHOEteS659btHvoMCcfmo7Nv8naYbHj5erI
         6pKrNKfCaqkrMoIV7ZuXxDezdgeZCh5VhStPpR47I2VVZlBAWt/PveqOF2uJ04lNtbQY
         FRt3JwDgannArBd1NuVf3Y6V/jc9+WgMSLrDs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AR/Ua1TRk1srTsKUy9Kk92PMxSf64zM0MUfZcN6Owxg=;
        b=Rtvjlc6QpC1lvcxsou+1spuPOV3NkkVLulF3I+ccQ1pHedTESuWhE7vE37wJmJlWBZ
         HkjRPQ6JPLmbJ4HQ9fPS1VI6mBLYKKA0OXD7OtFzQSe9MhGdX4acTp0kaJm1Pi4RcWqu
         yTt7kMtls6N3CvtQqbf1oYtyqTdf5vrPBm0vYwH6p4B1AeXqz9rdiDu6UZpulBFqO066
         884NUosXN8bhBNqH8VrHpiYZerL+yObLa/u8r7AYomybjZWvnY0l2dgTmVHmyfD4gzTV
         MmFEFCzt/tUR+IIgNZvmo1GHAxx1C9mcfyHTOM/uxJLFWQ5JSEZ/rKbF7V9a/7WkfSQO
         6GZQ==
X-Gm-Message-State: AOAM533aWUNsAffW6um7n9LBUlhRFKKZO2HPa9N+5C3S2cUVuY9IXlq/
        ubQlBvkBZ+qSVjVNY5UHRyKs2A==
X-Google-Smtp-Source: ABdhPJxiVT0AsG+TbO2XHVHp1DTtCTZZjJVqReqUGyzo+PPEwagBS8EA/x6CujEDGNboytxKtwPxtg==
X-Received: by 2002:a17:90a:f16:: with SMTP id 22mr11748383pjy.38.1624489178837;
        Wed, 23 Jun 2021 15:59:38 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r207sm794664pfc.118.2021.06.23.15.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 15:59:38 -0700 (PDT)
Date:   Wed, 23 Jun 2021 15:59:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
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
Message-ID: <202106231555.871D23D50@keescook>
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
> 
> Unfortunately at least the networking core has a manual refcount
> assumption, which needs to be adjusted to account for this change.
> This should also mean there is runtime for other kobjects which may
> not be explored yet which may need fixing as well. We may want to
> change the check to something else on the networking front, but its
> not clear to me yet what to use.
> 
>  fs/sysfs/dir.c | 3 +++
>  net/core/dev.c | 4 ++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 59dffd5ca517..6c47aa4af6f5 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -56,12 +56,14 @@ int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
>  
>  	kobject_get_ownership(kobj, &uid, &gid);
>  
> +	kobject_get(kobj);
>  	kn = kernfs_create_dir_ns(parent, kobject_name(kobj),
>  				  S_IRWXU | S_IRUGO | S_IXUGO, uid, gid,
>  				  kobj, ns);
>  	if (IS_ERR(kn)) {
>  		if (PTR_ERR(kn) == -EEXIST)
>  			sysfs_warn_dup(parent, kobject_name(kobj));
> +		kobject_put(kobj);
>  		return PTR_ERR(kn);
>  	}
>  
> @@ -100,6 +102,7 @@ void sysfs_remove_dir(struct kobject *kobj)
>  	if (kn) {
>  		WARN_ON_ONCE(kernfs_type(kn) != KERNFS_DIR);
>  		kernfs_remove(kn);
> +		kobject_put(kobj);
>  	}
>  }

Shouldn't this be taken on open() not sysfs creation, or is the problem
that the kobject is held the module memory rather than duplicated by
sysfs?

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 222b1d322c96..3a0ffa603d14 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10429,7 +10429,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
>  	rebroadcast_time = warning_time = jiffies;
>  	refcnt = netdev_refcnt_read(dev);
>  
> -	while (refcnt != 1) {
> +	while (refcnt != 3) {
>  		if (time_after(jiffies, rebroadcast_time + 1 * HZ)) {
>  			rtnl_lock();
>  
> @@ -10544,7 +10544,7 @@ void netdev_run_todo(void)
>  		netdev_wait_allrefs(dev);
>  
>  		/* paranoia */
> -		BUG_ON(netdev_refcnt_read(dev) != 1);
> +		BUG_ON(netdev_refcnt_read(dev) != 3);

And surely there are things besides netdevs that would suffer from this
change?

>  		BUG_ON(!list_empty(&dev->ptype_all));
>  		BUG_ON(!list_empty(&dev->ptype_specific));
>  		WARN_ON(rcu_access_pointer(dev->ip_ptr));
> -- 
> 2.27.0
> 

-- 
Kees Cook
