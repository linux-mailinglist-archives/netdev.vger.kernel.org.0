Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB74153223D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 06:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbiEXEo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 00:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiEXEoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 00:44:54 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7448A324;
        Mon, 23 May 2022 21:44:53 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id x65so10053219qke.2;
        Mon, 23 May 2022 21:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ji4sol5sENBEUR3FRJaaPGspSAIjqZFEyUSpEFLQDI=;
        b=hYQ0c6yYUcVfmu71erT+6VDvx5G5eYcf4JX8bivgxAcVRq5T3YZxHLiHp7WVwTBBKX
         2cOVjoP55GH4W2zie2kWBOVkgG9jKEKwEHZKlBMLHQoU3Yc8QfBpCdlzyGoKWq6exl2z
         CXs+AIZOVs51bvpDx4A3SsKyoRq8+ZebiCv1qR8S+d2mqUxAJ/h6mxa3tZBaewM+RluK
         1wzAbw2iLe8Oy3Zk36z2kqKEuVS4oPAbyUAezph7jfU7+2GCbslF5ktHoXqlE7+7ecDQ
         5aw2ZDoJlyjN0AESyO2s/eOFveXNANFGXQV6JyxvQmmQbEnlvdWqWNb53GgzP2Uj38Kk
         pnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ji4sol5sENBEUR3FRJaaPGspSAIjqZFEyUSpEFLQDI=;
        b=KoXc4q7a5y2ykuEfAZKmZbJV7VUhmCnux/QTvN+YAMUSVv5fY/RcsmLDF4sPp2Rtl+
         o597dGXixYNwAYCq3/VLHUV9+76PMNGiEFyO57vlBD7RTlnwMXFgC9nQOMZWeF+TEACi
         Sr8pNpc7czBELQFxCHG8GZFZhf6iHEoLnejaR3YTIxawmruPVT/nM03Ntz8d1v+o/KxG
         q4jRPVFzR8zOf0/rEER9JKA+mqSbrKjDlBnM+IoHBXrq4gH418HEb+cx5JGJ1tF+NxM9
         1yp4mC8nZJU3crvXTmxg3yqPxPW33A2L/mfiDClB1L5ReDKiPOojfgzF0VbOJc7sPuOj
         7Kug==
X-Gm-Message-State: AOAM530KdmMNw3mGFbnwuJFgopAkLlfds/oxmDQEhtmpoP+A3ulWtfV9
        qyo/AZN2WVonRAUhqrkVYXzb+pCu3XtahPtSkkN4qFScv4g=
X-Google-Smtp-Source: ABdhPJyrMD7rEPjUOmV37i177VE1l/2iEx6x8NhX1oEETIuR1mmo3FjJT7Pvls+DCaJgQuyMwtU5RxBp/cx5GfJd574=
X-Received: by 2002:a37:8846:0:b0:6a0:f6f1:a015 with SMTP id
 k67-20020a378846000000b006a0f6f1a015mr16143176qkd.386.1653367492354; Mon, 23
 May 2022 21:44:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220520212746.95075-1-fred@cloudflare.com>
In-Reply-To: <20220520212746.95075-1-fred@cloudflare.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 24 May 2022 07:44:41 +0300
Message-ID: <CAOQ4uxhOZu06xOHbwWszkvprjMVj4ZYbQMpdig0R1WH-4zZGCA@mail.gmail.com>
Subject: Re: [PATCH] cred: Propagate security_prepare_creds() error code
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     linux-aio@kvack.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-cachefs@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        selinux@vger.kernel.org, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 2:17 PM Frederick Lawler <fred@cloudflare.com> wrote:
>
> While experimenting with the security_prepare_creds() LSM hook, we
> noticed that our EPERM error code was not propagated up the callstack.
> Instead ENOMEM is always returned.  As a result, some tools may send a
> confusing error message to the user:
>
> $ unshare -rU
> unshare: unshare failed: Cannot allocate memory
>
> A user would think that the system didn't have enough memory, when
> instead the action was denied.
>
> This problem occurs because prepare_creds() and prepare_kernel_cred()
> return NULL when security_prepare_creds() returns an error code. Later,
> functions calling prepare_creds() and prepare_kernel_cred() return
> ENOMEM because they assume that a NULL meant there was no memory
> allocated.
>
> Fix this by propagating an error code from security_prepare_creds() up
> the callstack.
>
> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
> ---
[...]
> @@ -1173,7 +1173,7 @@ struct file *filp_open(const char *filename, int flags, umode_t mode)
>  {
>         struct filename *name = getname_kernel(filename);
>         struct file *file = ERR_CAST(name);
> -
> +

stray whitespace

>         if (!IS_ERR(name)) {
>                 file = file_open_name(name, flags, mode);
>                 putname(name);
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index f18490813170..905eb8f69d64 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -589,28 +589,32 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
>                         goto out_revert_creds;
>         }
>
> -       err = -ENOMEM;
>         override_cred = prepare_creds();
> -       if (override_cred) {
> -               override_cred->fsuid = inode->i_uid;
> -               override_cred->fsgid = inode->i_gid;
> -               if (!attr->hardlink) {
> -                       err = security_dentry_create_files_as(dentry,
> -                                       attr->mode, &dentry->d_name, old_cred,
> -                                       override_cred);
> -                       if (err) {
> -                               put_cred(override_cred);
> -                               goto out_revert_creds;
> -                       }
> -               }
> -               put_cred(override_creds(override_cred));
> -               put_cred(override_cred);
> +       if (IS_ERR(override_cred)) {
> +               err = PTR_ERR(override_cred);
> +               goto out_revert_creds;
> +       }
>
> -               if (!ovl_dentry_is_whiteout(dentry))
> -                       err = ovl_create_upper(dentry, inode, attr);
> -               else
> -                       err = ovl_create_over_whiteout(dentry, inode, attr);
> +       override_cred->fsuid = inode->i_uid;
> +       override_cred->fsgid = inode->i_gid;
> +       if (!attr->hardlink) {
> +               err = security_dentry_create_files_as(dentry, attr->mode,
> +                                                     &dentry->d_name,
> +                                                     old_cred,
> +                                                     override_cred);
> +               if (err) {
> +                       put_cred(override_cred);
> +                       goto out_revert_creds;
> +               }
>         }
> +       put_cred(override_creds(override_cred));
> +       put_cred(override_cred);
> +
> +       if (!ovl_dentry_is_whiteout(dentry))
> +               err = ovl_create_upper(dentry, inode, attr);
> +       else
> +               err = ovl_create_over_whiteout(dentry, inode, attr);
> +

It does not look like reducing the nesting level was really needed for
your change. Was it? It is impossible to review a logic change
with this much code churn.
Please stick to the changes you declared you are doing
and leave code style out of it.

>  out_revert_creds:
>         revert_creds(old_cred);
>         return err;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 001cdbb8f015..b29b62670e10 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1984,10 +1984,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         if (!ofs)
>                 goto out;
>
> -       err = -ENOMEM;
>         ofs->creator_cred = cred = prepare_creds();
> -       if (!cred)
> +       if (IS_ERR(ofs->creator_cred)) {
> +               err = PTR_ERR(ofs->creator_cred);
>                 goto out_err;
> +       }
>

A non NULL must not be assigned to ofs->creator_cred
use the cred local var for that check, otherwise things will
go badly in ovl_free_fs().

Thanks,
Amir.
