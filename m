Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997E9518D72
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 21:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbiECTxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 15:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiECTxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 15:53:20 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399BE3F88A;
        Tue,  3 May 2022 12:49:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AFC11210E4;
        Tue,  3 May 2022 19:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651607384; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9BjCsNyhWrFhajIPGqZcKtHERzRUauTrhIQt2R+1HS0=;
        b=x74SWPj5lGZTVIeu5kHB7KOvBdLAMWOJ9MzTKPcraNvyAgog5Z4WGg6GX2drGe+BCv8FCO
        1vJblvVsNI/sDjjECCl01lTBxW3uwzzDfnQYKxZ7BzvgWK8CsGqrqqVmfNMc3J8ugXBmRs
        GKWEFHHOL78Muie3Rrq8KNenw+NBCE8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651607384;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9BjCsNyhWrFhajIPGqZcKtHERzRUauTrhIQt2R+1HS0=;
        b=aPs7YCK6PUz6/Zd1NZ4LV3QGTAKxYUSIaKi2rjAj7hT/4dOGfcpUqRxyjuCMzXpdKKirxI
        u/pqrktMmBqyrzAQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B656D2C145;
        Tue,  3 May 2022 19:49:43 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 57731A0629; Tue,  3 May 2022 21:49:43 +0200 (CEST)
Date:   Tue, 3 May 2022 21:49:43 +0200
From:   Jan Kara <jack@suse.cz>
To:     Guowei Du <duguoweisz@gmail.com>
Cc:     jack@suse.cz, amir73il@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        jmorris@namei.org, serge@hallyn.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, anton@enomsg.org, ccross@android.com,
        tony.luck@intel.com, selinux@vger.kernel.org,
        duguowei <duguowei@xiaomi.com>
Subject: Re: [PATCH] fsnotify: add generic perm check for unlink/rmdir
Message-ID: <20220503194943.6bcmsxjvinfjrqxa@quack3.lan>
References: <20220503183750.1977-1-duguoweisz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503183750.1977-1-duguoweisz@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 04-05-22 02:37:50, Guowei Du wrote:
> From: duguowei <duguowei@xiaomi.com>
> 
> For now, there have been open/access/open_exec perms for file operation,
> so we add new perms check with unlink/rmdir syscall. if one app deletes
> any file/dir within pubic area, fsnotify can sends fsnotify_event to
> listener to deny that, even if the app have right dac/mac permissions.
> 
> Signed-off-by: duguowei <duguowei@xiaomi.com>

Before we go into technical details of implementation can you tell me more
details about the usecase? Why do you need to check specifically for unlink
/ delete?

Also on the design side of things: Do you realize these permission events
will not be usable together with other permission events like
FAN_OPEN_PERM? Because these require notification group returning file
descriptors while your events will return file handles... I guess we should
somehow fix that.


								Honza
> ---
>  fs/notify/fsnotify.c             |  2 +-
>  include/linux/fs.h               |  2 ++
>  include/linux/fsnotify.h         | 16 ++++++++++++++++
>  include/linux/fsnotify_backend.h |  6 +++++-
>  security/security.c              | 12 ++++++++++--
>  security/selinux/hooks.c         |  4 ++++
>  6 files changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
> index 70a8516b78bc..9c03a5f84be0 100644
> --- a/fs/notify/fsnotify.c
> +++ b/fs/notify/fsnotify.c
> @@ -581,7 +581,7 @@ static __init int fsnotify_init(void)
>  {
>  	int ret;
>  
> -	BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_BITS) != 25);
> +	BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_BITS) != 27);
>  
>  	ret = init_srcu_struct(&fsnotify_mark_srcu);
>  	if (ret)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bbde95387a23..9c661584db7d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -100,6 +100,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  #define MAY_CHDIR		0x00000040
>  /* called from RCU mode, don't block */
>  #define MAY_NOT_BLOCK		0x00000080
> +#define MAY_UNLINK		0x00000100
> +#define MAY_RMDIR		0x00000200
>  
>  /*
>   * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
> diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
> index bb8467cd11ae..68f5d4aaf1ae 100644
> --- a/include/linux/fsnotify.h
> +++ b/include/linux/fsnotify.h
> @@ -80,6 +80,22 @@ static inline int fsnotify_parent(struct dentry *dentry, __u32 mask,
>  	return fsnotify(mask, data, data_type, NULL, NULL, inode, 0);
>  }
>  
> +static inline int fsnotify_path_perm(struct path *path, struct dentry *dentry, __u32 mask)
> +{
> +	__u32 fsnotify_mask = 0;
> +
> +	if (!(mask & (MAY_UNLINK | MAY_RMDIR)))
> +		return 0;
> +
> +	if (mask & MAY_UNLINK)
> +		fsnotify_mask |= FS_UNLINK_PERM;
> +
> +	if (mask & MAY_RMDIR)
> +		fsnotify_mask |= FS_RMDIR_PERM;
> +
> +	return fsnotify_parent(dentry, fsnotify_mask, path, FSNOTIFY_EVENT_PATH);
> +}
> +
>  /*
>   * Simple wrappers to consolidate calls to fsnotify_parent() when an event
>   * is on a file/dentry.
> diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
> index 0805b74cae44..0e2e240e8234 100644
> --- a/include/linux/fsnotify_backend.h
> +++ b/include/linux/fsnotify_backend.h
> @@ -54,6 +54,8 @@
>  #define FS_OPEN_PERM		0x00010000	/* open event in an permission hook */
>  #define FS_ACCESS_PERM		0x00020000	/* access event in a permissions hook */
>  #define FS_OPEN_EXEC_PERM	0x00040000	/* open/exec event in a permission hook */
> +#define FS_UNLINK_PERM		0x00080000	/* unlink event in a permission hook */
> +#define FS_RMDIR_PERM		0x00100000	/* rmdir event in a permission hook */
>  
>  #define FS_EXCL_UNLINK		0x04000000	/* do not send events if object is unlinked */
>  /*
> @@ -79,7 +81,9 @@
>  #define ALL_FSNOTIFY_DIRENT_EVENTS (FS_CREATE | FS_DELETE | FS_MOVE | FS_RENAME)
>  
>  #define ALL_FSNOTIFY_PERM_EVENTS (FS_OPEN_PERM | FS_ACCESS_PERM | \
> -				  FS_OPEN_EXEC_PERM)
> +				  FS_OPEN_EXEC_PERM | \
> +				  FS_UNLINK_PERM | \
> +				  FS_RMDIR_PERM)
>  
>  /*
>   * This is a list of all events that may get sent to a parent that is watching
> diff --git a/security/security.c b/security/security.c
> index b7cf5cbfdc67..8efc00ec02ed 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1160,16 +1160,24 @@ EXPORT_SYMBOL(security_path_mkdir);
>  
>  int security_path_rmdir(const struct path *dir, struct dentry *dentry)
>  {
> +	int ret;
>  	if (unlikely(IS_PRIVATE(d_backing_inode(dir->dentry))))
>  		return 0;
> -	return call_int_hook(path_rmdir, 0, dir, dentry);
> +	ret = call_int_hook(path_rmdir, 0, dir, dentry);
> +	if (ret)
> +		return ret;
> +	return fsnotify_path_perm(dir, dentry, MAY_RMDIR);
>  }
>  
>  int security_path_unlink(const struct path *dir, struct dentry *dentry)
>  {
> +	int ret;
>  	if (unlikely(IS_PRIVATE(d_backing_inode(dir->dentry))))
>  		return 0;
> -	return call_int_hook(path_unlink, 0, dir, dentry);
> +	ret = call_int_hook(path_unlink, 0, dir, dentry);
> +	if (ret)
> +		return ret;
> +	return fsnotify_path_perm(dir, dentry, MAY_UNLINK);
>  }
>  EXPORT_SYMBOL(security_path_unlink);
>  
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index e9e959343de9..f0780f0eb903 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1801,8 +1801,12 @@ static int may_create(struct inode *dir,
>  }
>  
>  #define MAY_LINK	0
> +#ifndef MAY_UNLINK
>  #define MAY_UNLINK	1
> +#endif
> +#ifndef MAY_RMDIR
>  #define MAY_RMDIR	2
> +#endif
>  
>  /* Check whether a task can link, unlink, or rmdir a file/directory. */
>  static int may_link(struct inode *dir,
> -- 
> 2.17.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
