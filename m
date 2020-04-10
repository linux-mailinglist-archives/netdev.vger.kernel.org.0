Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011351A4BDA
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 00:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgDJWSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 18:18:18 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34090 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgDJWSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 18:18:17 -0400
Received: by mail-qt1-f195.google.com with SMTP id 14so2656285qtp.1;
        Fri, 10 Apr 2020 15:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uh9shUxtBnoJSqQ6zkuQRj7I7MOXcl/h/ByktU9C7tI=;
        b=Due2mrx9DZinG/wvEWvx1ZvuiCgn25VPKHxugN+vu9UEcaoaG/IlI3SixSq94AMaW+
         qjiig80TSiUx0K+Qq6lWxZjjk3czuDqFX4wwMEQozU/cuDcq9M/cyrY9wiTfYPct2hxA
         si2OjA0jwFApR8IjYID7toiG8fLFvUKwCybQsqBqmhucEo/b8D4Pc8tN4jLx6znkl2av
         HCjMnArhsWmCJj3ajJAW3DalEC/USSLFTaLq3jiHob5XbTRGccL24yVNiAd/2WCY6hw/
         LY7yMDl8qx/L8oDOQ1l/5jAuDqSxLMT09z+TDC5sI7CkH3HUbsPuflgvr51yM1qrcsEc
         vhsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uh9shUxtBnoJSqQ6zkuQRj7I7MOXcl/h/ByktU9C7tI=;
        b=Ll+gwlXjWo25Ys4onyl9hA8DZoFCmqa7A3FKRJlhW055MCE9MP+fTEfOlrWCPlKMGV
         neXcJ1zxmJJY0B1siz/FnH+rR0M6175yQp+GGFfQjoYCya5tZnrZpqbynHe42naGHBJQ
         XXiFzg7TDKHHVUFbTd2MlKKYxfUG1Jz6TKDJkA/nxOJlwzlJPvwLXl4+qWaV6jjFypAE
         mC1u0L4fDARcVCOa4dIQFJ3SrApvWU0ksZ+piIO1qsfW3XN5YsHFsSHGTxNMzObfVDDJ
         A1IePVwnYucHiHvlsmkdGuiBtma99JYiWrD5bSiikG1NO73++UJPNRU3njwQYooFyc0I
         rtvw==
X-Gm-Message-State: AGi0Pub9sMQERrNZidJaCpjoOATnGcNlYvh8KakjWlYZn+/ez7LRipS4
        peNjfqhbHkZzHleauMnqo1leV02g14Srx3yiyQC+f9GJj5n2ug==
X-Google-Smtp-Source: APiQypKW3LXw5sjXaxcifnnfjoBAIT1hzQuft2v3xxtlNonC35rjZuKbw6NXHuFnFTHe3hTTfaGe40SpZ8lFsb8+4AI=
X-Received: by 2002:ac8:193d:: with SMTP id t58mr1234465qtj.93.1586557094809;
 Fri, 10 Apr 2020 15:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232523.2675550-1-yhs@fb.com>
In-Reply-To: <20200408232523.2675550-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Apr 2020 15:18:03 -0700
Message-ID: <CAEf4Bzb5K6h+Cca63JU35XG+NFoFDCVrC=DhDNVz6KTmoyzpFw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 03/16] bpf: provide a way for targets to
 register themselves
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> Here, the target refers to a particular data structure
> inside the kernel we want to dump. For example, it
> can be all task_structs in the current pid namespace,
> or it could be all open files for all task_structs
> in the current pid namespace.
>
> Each target is identified with the following information:
>    target_rel_path   <=== relative path to /sys/kernel/bpfdump
>    target_proto      <=== kernel func proto which represents
>                           bpf program signature for this target
>    seq_ops           <=== seq_ops for seq_file operations
>    seq_priv_size     <=== seq_file private data size
>    target_feature    <=== target specific feature which needs
>                           handling outside seq_ops.

It's not clear what "feature" stands for here... Is this just a sort
of private_data passed through to dumper?

>
> The target relative path is a relative directory to /sys/kernel/bpfdump/.
> For example, it could be:
>    task                  <=== all tasks
>    task/file             <=== all open files under all tasks
>    ipv6_route            <=== all ipv6_routes
>    tcp6/sk_local_storage <=== all tcp6 socket local storages
>    foo/bar/tar           <=== all tar's in bar in foo

^^ this seems useful, but I don't think code as is supports more than 2 levels?

>
> The "target_feature" is mostly used for reusing existing seq_ops.
> For example, for /proc/net/<> stats, the "net" namespace is often
> stored in file private data. The target_feature enables bpf based
> dumper to set "net" properly for itself before calling shared
> seq_ops.
>
> bpf_dump_reg_target() is implemented so targets
> can register themselves. Currently, module is not
> supported, so there is no bpf_dump_unreg_target().
> The main reason is that BTF is not available for modules
> yet.
>
> Since target might call bpf_dump_reg_target() before
> bpfdump mount point is created, __bpfdump_init()
> may be called in bpf_dump_reg_target() as well.
>
> The file-based dumpers will be regular files under
> the specific target directory. For example,
>    task/my1      <=== dumper "my1" iterates through all tasks
>    task/file/my2 <=== dumper "my2" iterates through all open files
>                       under all tasks
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h |   4 +
>  kernel/bpf/dump.c   | 190 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 193 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index fd2b2322412d..53914bec7590 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1109,6 +1109,10 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
>  int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>  int bpf_obj_get_user(const char __user *pathname, int flags);
>
> +int bpf_dump_reg_target(const char *target, const char *target_proto,
> +                       const struct seq_operations *seq_ops,
> +                       u32 seq_priv_size, u32 target_feature);
> +
>  int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
> diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
> index e0c33486e0e7..45528846557f 100644
> --- a/kernel/bpf/dump.c
> +++ b/kernel/bpf/dump.c
> @@ -12,6 +12,173 @@
>  #include <linux/filter.h>
>  #include <linux/bpf.h>
>
> +struct bpfdump_target_info {
> +       struct list_head list;
> +       const char *target;
> +       const char *target_proto;
> +       struct dentry *dir_dentry;
> +       const struct seq_operations *seq_ops;
> +       u32 seq_priv_size;
> +       u32 target_feature;
> +};
> +
> +struct bpfdump_targets {
> +       struct list_head dumpers;
> +       struct mutex dumper_mutex;

nit: would be a bit simpler if these were static variables with static
initialization, similar to how bpfdump_dentry is separate?

> +};
> +
> +/* registered dump targets */
> +static struct bpfdump_targets dump_targets;
> +
> +static struct dentry *bpfdump_dentry;
> +
> +static struct dentry *bpfdump_add_dir(const char *name, struct dentry *parent,
> +                                     const struct inode_operations *i_ops,
> +                                     void *data);
> +static int __bpfdump_init(void);
> +
> +static int dumper_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +       kfree(d_inode(dentry)->i_private);
> +       return simple_unlink(dir, dentry);
> +}
> +
> +static const struct inode_operations bpf_dir_iops = {
> +       .lookup         = simple_lookup,
> +       .unlink         = dumper_unlink,
> +};
> +
> +int bpf_dump_reg_target(const char *target,
> +                       const char *target_proto,
> +                       const struct seq_operations *seq_ops,
> +                       u32 seq_priv_size, u32 target_feature)
> +{
> +       struct bpfdump_target_info *tinfo, *ptinfo;
> +       struct dentry *dentry, *parent;
> +       const char *lastslash;
> +       bool existed = false;
> +       int err, parent_len;
> +
> +       if (!bpfdump_dentry) {
> +               err = __bpfdump_init();

This will be called (again) if bpfdump_init() fails? Not sure why? In
rare cases, some dumper will fail to initialize, but then some might
succeed, which is going to be even more confusing, no?

> +               if (err)
> +                       return err;
> +       }
> +
> +       tinfo = kmalloc(sizeof(*tinfo), GFP_KERNEL);
> +       if (!tinfo)
> +               return -ENOMEM;
> +
> +       tinfo->target = target;
> +       tinfo->target_proto = target_proto;
> +       tinfo->seq_ops = seq_ops;
> +       tinfo->seq_priv_size = seq_priv_size;
> +       tinfo->target_feature = target_feature;
> +       INIT_LIST_HEAD(&tinfo->list);
> +
> +       lastslash = strrchr(target, '/');
> +       if (!lastslash) {
> +               parent = bpfdump_dentry;

Two nits here. First, it supports only one and two levels. But it
seems like it wouldn't be hard to support multiple? Instead of
reverse-searching for /, you can forward search and keep track of
"current parent".

nit2:

parent = bpfdump_dentry;
if (lastslash) {

    parent = ptinfo->dir_dentry;
}

seems a bit cleaner (and generalizes to multi-level a bit better).

> +       } else {
> +               parent_len = (unsigned long)lastslash - (unsigned long)target;
> +
> +               mutex_lock(&dump_targets.dumper_mutex);
> +               list_for_each_entry(ptinfo, &dump_targets.dumpers, list) {
> +                       if (strlen(ptinfo->target) == parent_len &&
> +                           strncmp(ptinfo->target, target, parent_len) == 0) {
> +                               existed = true;
> +                               break;
> +                       }
> +               }
> +               mutex_unlock(&dump_targets.dumper_mutex);
> +               if (existed == false) {
> +                       err = -ENOENT;
> +                       goto free_tinfo;
> +               }
> +
> +               parent = ptinfo->dir_dentry;
> +               target = lastslash + 1;
> +       }
> +       dentry = bpfdump_add_dir(target, parent, &bpf_dir_iops, tinfo);
> +       if (IS_ERR(dentry)) {
> +               err = PTR_ERR(dentry);
> +               goto free_tinfo;
> +       }
> +
> +       tinfo->dir_dentry = dentry;
> +
> +       mutex_lock(&dump_targets.dumper_mutex);
> +       list_add(&tinfo->list, &dump_targets.dumpers);
> +       mutex_unlock(&dump_targets.dumper_mutex);
> +       return 0;
> +
> +free_tinfo:
> +       kfree(tinfo);
> +       return err;
> +}
> +

[...]

> +       if (S_ISDIR(mode)) {
> +               inode->i_op = i_ops;
> +               inode->i_fop = f_ops;
> +               inc_nlink(inode);
> +               inc_nlink(dir);
> +       } else {
> +               inode->i_fop = f_ops;
> +       }
> +
> +       d_instantiate(dentry, inode);
> +       dget(dentry);

lookup_one_len already bumped refcount, why the second time here?

> +       inode_unlock(dir);
> +       return dentry;
> +
> +dentry_put:
> +       dput(dentry);
> +       dentry = ERR_PTR(err);
> +unlock:
> +       inode_unlock(dir);
> +       return dentry;
> +}
> +

[...]
