Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A99C51ADC7
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 21:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376625AbiEDTbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 15:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiEDTbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 15:31:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591EE2A716;
        Wed,  4 May 2022 12:27:57 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CA6491F37F;
        Wed,  4 May 2022 19:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651692475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QfMEuCSetan9XRRWFKWsb6K22EKUj5mlPD2hKmHn9OA=;
        b=y/UFq5IrvxkZkFmQEu4t3IyAMXoZhnY89D1YCa+4mFShbOT215HyN4juNSRgpppqsdKRqY
        A6WUzKTWIWW2EPNzducjggk75qLmWOmJpurJjWBrOebo6Y7m2W1TqjKmZ0/Lutga/FG1YR
        AEAFk16h5ARd30C7wESXwh2P/xPUPu4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651692475;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QfMEuCSetan9XRRWFKWsb6K22EKUj5mlPD2hKmHn9OA=;
        b=w2QUOIvAI5xAkcb2v3e6k+WAmBJvCwp+AnfgNQchFDRwvEVGfjVVAGRnMt3Z5s3qooMEX6
        3tFcy3HY0vS8YCDw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id EA1B42C141;
        Wed,  4 May 2022 19:27:54 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 7477FA061E; Wed,  4 May 2022 21:27:51 +0200 (CEST)
Date:   Wed, 4 May 2022 21:27:51 +0200
From:   Jan Kara <jack@suse.cz>
To:     guowei du <duguoweisz@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, amir73il@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org, serge@hallyn.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, anton@enomsg.org, ccross@android.com,
        tony.luck@intel.com, selinux@vger.kernel.org,
        duguowei <duguowei@xiaomi.com>
Subject: Re: [PATCH] fsnotify: add generic perm check for unlink/rmdir
Message-ID: <20220504192751.76axinbuuptqdpsz@quack3.lan>
References: <20220503183750.1977-1-duguoweisz@gmail.com>
 <20220503194943.6bcmsxjvinfjrqxa@quack3.lan>
 <CAC+1Nxv5n0eGtRhfS6pxt8Z-no5scu2kO2pu+_6CpbkeeBqFAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC+1Nxv5n0eGtRhfS6pxt8Z-no5scu2kO2pu+_6CpbkeeBqFAw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On Wed 04-05-22 11:42:23, guowei du wrote:
>           for the first issue,one usecase is ,for the shared storage with
> android device,shared storage is public to all apps which gained whole
> storage rwx permission,
>           and computer could also read/write the storage by usb cable
> connected.
>          so ,we need to protect some resources such as photoes or videos or
> some secure documents in the shared storage.
>          in other words,we want to subdivide permissions of that area  for
> open/read/unlink and so on.

I see but I thought that MTP protocol was there exactly so that the phone
can control the access from computer to the shared storage. So it is
probably not the case that you'd need this fanotify feature to control MTP
client access but you want to say block image removal while the file is
being transfered over MTP? Do I get this right?

>          for the second issue. every FANOTIFY_EVENT_TYPE_PATH event will
> 'dentry_open' a new file with FMODE_NONOTIFY,then bind to a new unused fd,
> so could tell me the reason?

Yes, this is just how fanotify was designed. And it was designed in this
way because it was created for use by antivirus scanners which wanted to
read the file contents and based on that decide whether the file could be
accessed or not.

>         and next step ,i will go on to fix the related issue such as
> fanotify module.

I have realized that you do propagate struct path to fsnotify with your new
RMDIR_PERM and UNLINK_PERM events (unlike standard DELETE fsnotify events)
so things should work in the same way as say for OPEN_PERM events.

								Honza

> On Wed, May 4, 2022 at 3:49 AM Jan Kara <jack@suse.cz> wrote:
> 
> > On Wed 04-05-22 02:37:50, Guowei Du wrote:
> > > From: duguowei <duguowei@xiaomi.com>
> > >
> > > For now, there have been open/access/open_exec perms for file operation,
> > > so we add new perms check with unlink/rmdir syscall. if one app deletes
> > > any file/dir within pubic area, fsnotify can sends fsnotify_event to
> > > listener to deny that, even if the app have right dac/mac permissions.
> > >
> > > Signed-off-by: duguowei <duguowei@xiaomi.com>
> >
> > Before we go into technical details of implementation can you tell me more
> > details about the usecase? Why do you need to check specifically for unlink
> > / delete?
> >
> > Also on the design side of things: Do you realize these permission events
> > will not be usable together with other permission events like
> > FAN_OPEN_PERM? Because these require notification group returning file
> > descriptors while your events will return file handles... I guess we should
> > somehow fix that.
> >
> >
> >                                                                 Honza
> > > ---
> > >  fs/notify/fsnotify.c             |  2 +-
> > >  include/linux/fs.h               |  2 ++
> > >  include/linux/fsnotify.h         | 16 ++++++++++++++++
> > >  include/linux/fsnotify_backend.h |  6 +++++-
> > >  security/security.c              | 12 ++++++++++--
> > >  security/selinux/hooks.c         |  4 ++++
> > >  6 files changed, 38 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
> > > index 70a8516b78bc..9c03a5f84be0 100644
> > > --- a/fs/notify/fsnotify.c
> > > +++ b/fs/notify/fsnotify.c
> > > @@ -581,7 +581,7 @@ static __init int fsnotify_init(void)
> > >  {
> > >       int ret;
> > >
> > > -     BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_BITS) != 25);
> > > +     BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_BITS) != 27);
> > >
> > >       ret = init_srcu_struct(&fsnotify_mark_srcu);
> > >       if (ret)
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index bbde95387a23..9c661584db7d 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -100,6 +100,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb,
> > loff_t offset,
> > >  #define MAY_CHDIR            0x00000040
> > >  /* called from RCU mode, don't block */
> > >  #define MAY_NOT_BLOCK                0x00000080
> > > +#define MAY_UNLINK           0x00000100
> > > +#define MAY_RMDIR            0x00000200
> > >
> > >  /*
> > >   * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must
> > correspond
> > > diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
> > > index bb8467cd11ae..68f5d4aaf1ae 100644
> > > --- a/include/linux/fsnotify.h
> > > +++ b/include/linux/fsnotify.h
> > > @@ -80,6 +80,22 @@ static inline int fsnotify_parent(struct dentry
> > *dentry, __u32 mask,
> > >       return fsnotify(mask, data, data_type, NULL, NULL, inode, 0);
> > >  }
> > >
> > > +static inline int fsnotify_path_perm(struct path *path, struct dentry
> > *dentry, __u32 mask)
> > > +{
> > > +     __u32 fsnotify_mask = 0;
> > > +
> > > +     if (!(mask & (MAY_UNLINK | MAY_RMDIR)))
> > > +             return 0;
> > > +
> > > +     if (mask & MAY_UNLINK)
> > > +             fsnotify_mask |= FS_UNLINK_PERM;
> > > +
> > > +     if (mask & MAY_RMDIR)
> > > +             fsnotify_mask |= FS_RMDIR_PERM;
> > > +
> > > +     return fsnotify_parent(dentry, fsnotify_mask, path,
> > FSNOTIFY_EVENT_PATH);
> > > +}
> > > +
> > >  /*
> > >   * Simple wrappers to consolidate calls to fsnotify_parent() when an
> > event
> > >   * is on a file/dentry.
> > > diff --git a/include/linux/fsnotify_backend.h
> > b/include/linux/fsnotify_backend.h
> > > index 0805b74cae44..0e2e240e8234 100644
> > > --- a/include/linux/fsnotify_backend.h
> > > +++ b/include/linux/fsnotify_backend.h
> > > @@ -54,6 +54,8 @@
> > >  #define FS_OPEN_PERM         0x00010000      /* open event in an
> > permission hook */
> > >  #define FS_ACCESS_PERM               0x00020000      /* access event in
> > a permissions hook */
> > >  #define FS_OPEN_EXEC_PERM    0x00040000      /* open/exec event in a
> > permission hook */
> > > +#define FS_UNLINK_PERM               0x00080000      /* unlink event in
> > a permission hook */
> > > +#define FS_RMDIR_PERM                0x00100000      /* rmdir event in
> > a permission hook */
> > >
> > >  #define FS_EXCL_UNLINK               0x04000000      /* do not send
> > events if object is unlinked */
> > >  /*
> > > @@ -79,7 +81,9 @@
> > >  #define ALL_FSNOTIFY_DIRENT_EVENTS (FS_CREATE | FS_DELETE | FS_MOVE |
> > FS_RENAME)
> > >
> > >  #define ALL_FSNOTIFY_PERM_EVENTS (FS_OPEN_PERM | FS_ACCESS_PERM | \
> > > -                               FS_OPEN_EXEC_PERM)
> > > +                               FS_OPEN_EXEC_PERM | \
> > > +                               FS_UNLINK_PERM | \
> > > +                               FS_RMDIR_PERM)
> > >
> > >  /*
> > >   * This is a list of all events that may get sent to a parent that is
> > watching
> > > diff --git a/security/security.c b/security/security.c
> > > index b7cf5cbfdc67..8efc00ec02ed 100644
> > > --- a/security/security.c
> > > +++ b/security/security.c
> > > @@ -1160,16 +1160,24 @@ EXPORT_SYMBOL(security_path_mkdir);
> > >
> > >  int security_path_rmdir(const struct path *dir, struct dentry *dentry)
> > >  {
> > > +     int ret;
> > >       if (unlikely(IS_PRIVATE(d_backing_inode(dir->dentry))))
> > >               return 0;
> > > -     return call_int_hook(path_rmdir, 0, dir, dentry);
> > > +     ret = call_int_hook(path_rmdir, 0, dir, dentry);
> > > +     if (ret)
> > > +             return ret;
> > > +     return fsnotify_path_perm(dir, dentry, MAY_RMDIR);
> > >  }
> > >
> > >  int security_path_unlink(const struct path *dir, struct dentry *dentry)
> > >  {
> > > +     int ret;
> > >       if (unlikely(IS_PRIVATE(d_backing_inode(dir->dentry))))
> > >               return 0;
> > > -     return call_int_hook(path_unlink, 0, dir, dentry);
> > > +     ret = call_int_hook(path_unlink, 0, dir, dentry);
> > > +     if (ret)
> > > +             return ret;
> > > +     return fsnotify_path_perm(dir, dentry, MAY_UNLINK);
> > >  }
> > >  EXPORT_SYMBOL(security_path_unlink);
> > >
> > > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > > index e9e959343de9..f0780f0eb903 100644
> > > --- a/security/selinux/hooks.c
> > > +++ b/security/selinux/hooks.c
> > > @@ -1801,8 +1801,12 @@ static int may_create(struct inode *dir,
> > >  }
> > >
> > >  #define MAY_LINK     0
> > > +#ifndef MAY_UNLINK
> > >  #define MAY_UNLINK   1
> > > +#endif
> > > +#ifndef MAY_RMDIR
> > >  #define MAY_RMDIR    2
> > > +#endif
> > >
> > >  /* Check whether a task can link, unlink, or rmdir a file/directory. */
> > >  static int may_link(struct inode *dir,
> > > --
> > > 2.17.1
> > >
> > --
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
> >
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
