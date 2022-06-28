Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D7755C511
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245295AbiF1GH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 02:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243515AbiF1GHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 02:07:21 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8172A26AD4
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 23:07:19 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v14so16035696wra.5
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 23:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UlC45+E/EEsREXomgnlTyZyN/c9acM72aDVSIPabFQo=;
        b=p5WY7Wfn4Mx/ulZYT3RM4hBp+YoKtc0dDCdrTO1g2QWV1ElLpgTwWuS6QQokcpirjF
         +arAqXMk8IFkq2ajI5KOj5FuhLdYTicGMKEcbY65+wuVtsSRYup4TfHwqgNRAR7Xlg9d
         q05lTdHGCRsUfcvvRAgATIv7YkIjkePTLd8hZjfePOsvCIYvadb1atcYfDtkRsJWb0Un
         R+RekmfTm6afRtnK+WaUgFGpRBXw2asDnDj51jKdQOc6QspSQLctYkflsFKnSRNWQ295
         HH3al6lGm5cMR4fzQsQqm3ORU32X3wvOsAoabqN9AJdIUiLI3eTf7mbmjL9O6yf/shjA
         oojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UlC45+E/EEsREXomgnlTyZyN/c9acM72aDVSIPabFQo=;
        b=DPCDSunTKZBGa1dpFeqYz24fMmzJn9Ze0OZWeWL2Le1RDYYEi+nW5RMji7TKd8CuFO
         t6Rf4PlQJ2ukjnVZgQIhoujM40xgdB6xtVNc5Flk8+i+78eBGgYH8pTdlkKGiZSuCKSl
         3koSVkW5RtQCCUzZyp0OQkZf+6LuntirzttcCop3KudDT+PLF+8xLTeczNKezCRaEIWl
         qE7Om4bvc2jTHJDKwvammNbYYo+PnR4CLPFAXGMCchZjKAKcHFs7GKtYBuNyn4U40/GU
         5h9AMRRzDKplpWcwLpKBPTvqVOwZ10HxXjhZrfVZvZRaj+ACYcmucICAbUAEsvy1IyP0
         fnfQ==
X-Gm-Message-State: AJIora9jB9cTcmratzSU3nrHb4GH2GKPLz13oRD4vxVc3QKq7MDzS480
        cjEpP4DsOD9RXXA4D0nbBB2p8mCYkrW6PQDxmprcvw==
X-Google-Smtp-Source: AGRyM1sGTR8q97z3Ojh1T9dJClXoZ9KcRPM+WoWjltPOEM9eYc/I2T8u5jQzEIKG0heOEvIIcmgIiwEeEm3ECOw+U5c=
X-Received: by 2002:a5d:664d:0:b0:21a:3b82:6bb2 with SMTP id
 f13-20020a5d664d000000b0021a3b826bb2mr15982525wrw.534.1656396437938; Mon, 27
 Jun 2022 23:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-5-yosryahmed@google.com> <f6c0274d-73c4-e05b-6405-4062230c4a14@fb.com>
In-Reply-To: <f6c0274d-73c4-e05b-6405-4062230c4a14@fb.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 27 Jun 2022 23:06:41 -0700
Message-ID: <CAJD7tkaNV_QUQyYRdCsuXcnSSpw9kSmY1D=faJBsQBYO3x4QHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 9:09 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> > From: Hao Luo <haoluo@google.com>
> >
> > Cgroup_iter is a type of bpf_iter. It walks over cgroups in two modes:
> >
> >   - walking a cgroup's descendants.
> >   - walking a cgroup's ancestors.
>
> The implementation has another choice, BPF_ITER_CGROUP_PARENT_UP.
> We should add it here as well.
>

BPF_ITER_CGROUP_PARENT_UP is expressed here, I think what's actually
missing here (and down below where only 2 modes are specified again)
is that walking descendants is broken down into two separate modes,
pre and post order traversals.

> >
> > When attaching cgroup_iter, one can set a cgroup to the iter_link
> > created from attaching. This cgroup is passed as a file descriptor and
> > serves as the starting point of the walk. If no cgroup is specified,
> > the starting point will be the root cgroup.
> >
> > For walking descendants, one can specify the order: either pre-order or
> > post-order. For walking ancestors, the walk starts at the specified
> > cgroup and ends at the root.
> >
> > One can also terminate the walk early by returning 1 from the iter
> > program.
> >
> > Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> > program is called with cgroup_mutex held.
>
> Overall looks good to me with a few nits below.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >   include/linux/bpf.h            |   8 ++
> >   include/uapi/linux/bpf.h       |  21 +++
> >   kernel/bpf/Makefile            |   2 +-
> >   kernel/bpf/cgroup_iter.c       | 235 +++++++++++++++++++++++++++++++++
> >   tools/include/uapi/linux/bpf.h |  21 +++
> >   5 files changed, 286 insertions(+), 1 deletion(-)
> >   create mode 100644 kernel/bpf/cgroup_iter.c
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 8e6092d0ea956..48d8e836b9748 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -44,6 +44,7 @@ struct kobject;
> >   struct mem_cgroup;
> >   struct module;
> >   struct bpf_func_state;
> > +struct cgroup;
> >
> >   extern struct idr btf_idr;
> >   extern spinlock_t btf_idr_lock;
> > @@ -1590,7 +1591,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
> >       int __init bpf_iter_ ## target(args) { return 0; }
> >
> >   struct bpf_iter_aux_info {
> > +     /* for map_elem iter */
> >       struct bpf_map *map;
> > +
> > +     /* for cgroup iter */
> > +     struct {
> > +             struct cgroup *start; /* starting cgroup */
> > +             int order;
> > +     } cgroup;
> >   };
> >
> >   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index f4009dbdf62da..4fd05cde19116 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -87,10 +87,27 @@ struct bpf_cgroup_storage_key {
> >       __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
> >   };
> >
> > +enum bpf_iter_cgroup_traversal_order {
> > +     BPF_ITER_CGROUP_PRE = 0,        /* pre-order traversal */
> > +     BPF_ITER_CGROUP_POST,           /* post-order traversal */
> > +     BPF_ITER_CGROUP_PARENT_UP,      /* traversal of ancestors up to the root */
> > +};
> > +
> >   union bpf_iter_link_info {
> >       struct {
> >               __u32   map_fd;
> >       } map;
> > +
> > +     /* cgroup_iter walks either the live descendants of a cgroup subtree, or the ancestors
> > +      * of a given cgroup.
> > +      */
> > +     struct {
> > +             /* Cgroup file descriptor. This is root of the subtree if for walking the
> > +              * descendants; this is the starting cgroup if for walking the ancestors.
> > +              */
> > +             __u32   cgroup_fd;
> > +             __u32   traversal_order;
> > +     } cgroup;
> >   };
> >
> >   /* BPF syscall commands, see bpf(2) man-page for more details. */
> > @@ -6050,6 +6067,10 @@ struct bpf_link_info {
> >                               struct {
> >                                       __u32 map_id;
> >                               } map;
> > +                             struct {
> > +                                     __u32 traversal_order;
> > +                                     __aligned_u64 cgroup_id;
> > +                             } cgroup;
> >                       };
> >               } iter;
> >               struct  {
> > diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> > index 057ba8e01e70f..9741b9314fb46 100644
> > --- a/kernel/bpf/Makefile
> > +++ b/kernel/bpf/Makefile
> > @@ -8,7 +8,7 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
> >
> >   obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o link_iter.o
> >   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
> > -obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
> > +obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o cgroup_iter.o
> >   obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
> >   obj-${CONFIG_BPF_LSM}         += bpf_inode_storage.o
> >   obj-$(CONFIG_BPF_SYSCALL) += disasm.o
> > diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
> > new file mode 100644
> > index 0000000000000..88deb655efa71
> > --- /dev/null
> > +++ b/kernel/bpf/cgroup_iter.c
> > @@ -0,0 +1,235 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (c) 2022 Google */
> > +#include <linux/bpf.h>
> > +#include <linux/btf_ids.h>
> > +#include <linux/cgroup.h>
> > +#include <linux/kernel.h>
> > +#include <linux/seq_file.h>
> > +
> > +#include "../cgroup/cgroup-internal.h"  /* cgroup_mutex and cgroup_is_dead */
> > +
> > +/* cgroup_iter provides two modes of traversal to the cgroup hierarchy.
> > + *
> > + *  1. Walk the descendants of a cgroup.
> > + *  2. Walk the ancestors of a cgroup.
>
> three modes here?
>
> > + *
> > + * For walking descendants, cgroup_iter can walk in either pre-order or
> > + * post-order. For walking ancestors, the iter walks up from a cgroup to
> > + * the root.
> > + *
> > + * The iter program can terminate the walk early by returning 1. Walk
> > + * continues if prog returns 0.
> > + *
> > + * The prog can check (seq->num == 0) to determine whether this is
> > + * the first element. The prog may also be passed a NULL cgroup,
> > + * which means the walk has completed and the prog has a chance to
> > + * do post-processing, such as outputing an epilogue.
> > + *
> > + * Note: the iter_prog is called with cgroup_mutex held.
> > + */
> > +
> > +struct bpf_iter__cgroup {
> > +     __bpf_md_ptr(struct bpf_iter_meta *, meta);
> > +     __bpf_md_ptr(struct cgroup *, cgroup);
> > +};
> > +
> > +struct cgroup_iter_priv {
> > +     struct cgroup_subsys_state *start_css;
> > +     bool terminate;
> > +     int order;
> > +};
> > +
> > +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> > +{
> > +     struct cgroup_iter_priv *p = seq->private;
> > +
> > +     mutex_lock(&cgroup_mutex);
> > +
> > +     /* support only one session */
> > +     if (*pos > 0)
> > +             return NULL;
> > +
> > +     ++*pos;
> > +     p->terminate = false;
> > +     if (p->order == BPF_ITER_CGROUP_PRE)
> > +             return css_next_descendant_pre(NULL, p->start_css);
> > +     else if (p->order == BPF_ITER_CGROUP_POST)
> > +             return css_next_descendant_post(NULL, p->start_css);
> > +     else /* BPF_ITER_CGROUP_PARENT_UP */
> > +             return p->start_css;
> > +}
> > +
> > +static int __cgroup_iter_seq_show(struct seq_file *seq,
> > +                               struct cgroup_subsys_state *css, int in_stop);
> > +
> > +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
> > +{
> > +     /* pass NULL to the prog for post-processing */
> > +     if (!v)
> > +             __cgroup_iter_seq_show(seq, NULL, true);
> > +     mutex_unlock(&cgroup_mutex);
> > +}
> > +
> > +static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> > +{
> > +     struct cgroup_subsys_state *curr = (struct cgroup_subsys_state *)v;
> > +     struct cgroup_iter_priv *p = seq->private;
> > +
> > +     ++*pos;
> > +     if (p->terminate)
> > +             return NULL;
> > +
> > +     if (p->order == BPF_ITER_CGROUP_PRE)
> > +             return css_next_descendant_pre(curr, p->start_css);
> > +     else if (p->order == BPF_ITER_CGROUP_POST)
> > +             return css_next_descendant_post(curr, p->start_css);
> > +     else
> > +             return curr->parent;
> > +}
> > +
> > +static int __cgroup_iter_seq_show(struct seq_file *seq,
> > +                               struct cgroup_subsys_state *css, int in_stop)
> > +{
> > +     struct cgroup_iter_priv *p = seq->private;
> > +     struct bpf_iter__cgroup ctx;
> > +     struct bpf_iter_meta meta;
> > +     struct bpf_prog *prog;
> > +     int ret = 0;
> > +
> > +     /* cgroup is dead, skip this element */
> > +     if (css && cgroup_is_dead(css->cgroup))
> > +             return 0;
> > +
> > +     ctx.meta = &meta;
> > +     ctx.cgroup = css ? css->cgroup : NULL;
> > +     meta.seq = seq;
> > +     prog = bpf_iter_get_info(&meta, in_stop);
> > +     if (prog)
> > +             ret = bpf_iter_run_prog(prog, &ctx);
> > +
> > +     /* if prog returns > 0, terminate after this element. */
> > +     if (ret != 0)
> > +             p->terminate = true;
> > +
> > +     return 0;
> > +}
> > +
> > +static int cgroup_iter_seq_show(struct seq_file *seq, void *v)
> > +{
> > +     return __cgroup_iter_seq_show(seq, (struct cgroup_subsys_state *)v,
> > +                                   false);
> > +}
> > +
> > +static const struct seq_operations cgroup_iter_seq_ops = {
> > +     .start  = cgroup_iter_seq_start,
> > +     .next   = cgroup_iter_seq_next,
> > +     .stop   = cgroup_iter_seq_stop,
> > +     .show   = cgroup_iter_seq_show,
> > +};
> > +
> > +BTF_ID_LIST_SINGLE(bpf_cgroup_btf_id, struct, cgroup)
> > +
> > +static int cgroup_iter_seq_init(void *priv, struct bpf_iter_aux_info *aux)
> > +{
> > +     struct cgroup_iter_priv *p = (struct cgroup_iter_priv *)priv;
> > +     struct cgroup *cgrp = aux->cgroup.start;
> > +
> > +     p->start_css = &cgrp->self;
> > +     p->terminate = false;
> > +     p->order = aux->cgroup.order;
> > +     return 0;
> > +}
> > +
> > +static const struct bpf_iter_seq_info cgroup_iter_seq_info = {
> > +     .seq_ops                = &cgroup_iter_seq_ops,
> > +     .init_seq_private       = cgroup_iter_seq_init,
> > +     .seq_priv_size          = sizeof(struct cgroup_iter_priv),
> > +};
> > +
> > +static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
> > +                               union bpf_iter_link_info *linfo,
> > +                               struct bpf_iter_aux_info *aux)
> > +{
> > +     int fd = linfo->cgroup.cgroup_fd;
> > +     struct cgroup *cgrp;
> > +
> > +     if (fd)
> > +             cgrp = cgroup_get_from_fd(fd);
> > +     else /* walk the entire hierarchy by default. */
> > +             cgrp = cgroup_get_from_path("/");
> > +
> > +     if (IS_ERR(cgrp))
> > +             return PTR_ERR(cgrp);
> > +
> > +     aux->cgroup.start = cgrp;
> > +     aux->cgroup.order = linfo->cgroup.traversal_order;
>
> The legality of traversal_order should be checked.
>
> > +     return 0;
> > +}
> > +
> > +static void bpf_iter_detach_cgroup(struct bpf_iter_aux_info *aux)
> > +{
> > +     cgroup_put(aux->cgroup.start);
> > +}
> > +
> > +static void bpf_iter_cgroup_show_fdinfo(const struct bpf_iter_aux_info *aux,
> > +                                     struct seq_file *seq)
> > +{
> > +     char *buf;
> > +
> > +     buf = kzalloc(PATH_MAX, GFP_KERNEL);
> > +     if (!buf) {
> > +             seq_puts(seq, "cgroup_path:\n");
>
> This is a really unlikely case. maybe "cgroup_path:<unknown>"?
>
> > +             goto show_order;
> > +     }
> > +
> > +     /* If cgroup_path_ns() fails, buf will be an empty string, cgroup_path
> > +      * will print nothing.
> > +      *
> > +      * Path is in the calling process's cgroup namespace.
> > +      */
> > +     cgroup_path_ns(aux->cgroup.start, buf, PATH_MAX,
> > +                    current->nsproxy->cgroup_ns);
> > +     seq_printf(seq, "cgroup_path:\t%s\n", buf);
> > +     kfree(buf);
> > +
> > +show_order:
> > +     if (aux->cgroup.order == BPF_ITER_CGROUP_PRE)
> > +             seq_puts(seq, "traversal_order: pre\n");
> > +     else if (aux->cgroup.order == BPF_ITER_CGROUP_POST)
> > +             seq_puts(seq, "traversal_order: post\n");
> > +     else /* BPF_ITER_CGROUP_PARENT_UP */
> > +             seq_puts(seq, "traversal_order: parent_up\n");
> > +}
> > +
> [...]
