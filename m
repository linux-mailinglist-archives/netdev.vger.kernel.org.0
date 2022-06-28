Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260B755C91D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245214AbiF1GER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 02:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245208AbiF1GEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 02:04:06 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7889325C5C
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 23:04:04 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id o4so12082639wrh.3
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 23:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QNXhUtdlTQcrmyW6lCM6JlWYrPfy+A90YPaeQHo/QNs=;
        b=q7ClShnc9Wdx2N4ezAYB802OSiVV+20WR+VEvCc7CTBDiILDvn43BBkvL9M147fMnj
         eQUHaLlsUk65VO6BUHOSNHC+JI5zKh1Cc6BxzGUfT8u7vGKVNmNUt6Q36Uwydna5/1m1
         lsNsz1CMwwkFomKXzxj2naGpfSyyvKzpTk1SEbVBIy/oSCz4ArkHU/nFRMLpv2fxvmPY
         CVZaoBkmsG4XYMA6HDg9jfne34cBkD7ZojMJNSVRkbcCYzuhSXDhEgGis6sbWrm6mCO/
         lF9ir4KpI8Qyz2KA3qeBYhsfY9DzSYToI8sexB4/igLCkMkehEAlCC/DwCZ2jf0eyZtz
         eARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QNXhUtdlTQcrmyW6lCM6JlWYrPfy+A90YPaeQHo/QNs=;
        b=ZEMqvxh0APVtuB2wre7on0zoKcOIxCfVuewCp1YUyePBKxeBsOomHlBo1zZnFKepV3
         ugYDwMRFKJ6G8XRPcMWw8fx7543tmD8nRKjiS8COxCfJW55pq2WWh7mxMoyeSSEbl7pQ
         pZgQ6V0qmROnsVxVa8Ta6UN8k+eX04uYS2GweU6PdiQlSvrJqNNo/aWE7usku9zYGv2Z
         5hehsEHmpj2GkCi65B1VXgZ94vyO2EP2rotNmGz2ZRGTY07rmsTSg9sP5tiSHzDuFlCF
         bVEV6obPdJxwB5o2a8ZkyYZ5tjDCdFeperVMoJxm4z6bEYwnqBNVGSzdTleasu46W8Oj
         ZDPA==
X-Gm-Message-State: AJIora/di7OGPzNAWQb9ptmjcL8KQhJl9BXu1O5vcBG65mCL0keTq+RH
        Kb0z13omnuLz2UzFBNAWz2bDo15HlYSUhY/S87sfdQ==
X-Google-Smtp-Source: AGRyM1vqGSv/ZWVZq0AFK2J1K439V0xy8ILUWkxiv95//jJ/AW+9QD8jCH6wzg9wiqvrK8Dp6tZFUktxkDSXf3h5n0k=
X-Received: by 2002:a05:6000:a1e:b0:21b:8c8d:3cb5 with SMTP id
 co30-20020a0560000a1e00b0021b8c8d3cb5mr16013841wrb.372.1656396242834; Mon, 27
 Jun 2022 23:04:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-5-yosryahmed@google.com> <40114462-d5e2-ab07-7af9-5e60180027f9@fb.com>
In-Reply-To: <40114462-d5e2-ab07-7af9-5e60180027f9@fb.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 27 Jun 2022 23:03:26 -0700
Message-ID: <CAJD7tkaeR=QFRqq4B-abyYRrJ0p4FB9aDg7ESNvo9GS2KMS-4w@mail.gmail.com>
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

On Mon, Jun 27, 2022 at 9:14 PM Yonghong Song <yhs@fb.com> wrote:
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
> [...]
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
>
> Do we need to do anything special to ensure bpf program gets
> up-to-date stat from ctx.cgroup?

Later patches in the series add cgroup_flush_rstat() kfunc which
flushes cgroup stats that use rstat (e.g. memcg stats). It can be
called directly from the bpf program if needed.

It would be better to leave this to the bpf program, it's an
unnecessary toll to flush the stats for any cgroup_iter program, that
could be not accessing stats, or stats that are not maintained using
rstat.

>
> > +
> > +     /* if prog returns > 0, terminate after this element. */
> > +     if (ret != 0)
> > +             p->terminate = true;
> > +
> > +     return 0;
> > +}
> > +
> [...]
