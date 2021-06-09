Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7623A16E9
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhFIOTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:19:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232603AbhFIOTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 10:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623248257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aIQm3c+AEZpBjm+kS5UDs6ZfPL7zYXMjlKfBUogTj7M=;
        b=C8aowpFpxveDd0ntOf2zAENdxOjaRiz3MQDghOKU3O4s25pjQmhs3qMqOegtPKgGurtIeP
        QMB2ABKvMHN6qhhBqx0HbYSi7I5qYF8rYe0wiGWsd3upfzAiWQrBW6Mb3zxN7bWkx7kruW
        8aLc9dEKMb0S8mLmun8F+WneVpRXDTo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-tJcWTFsRO36GQGxag1T5Lg-1; Wed, 09 Jun 2021 10:17:36 -0400
X-MC-Unique: tJcWTFsRO36GQGxag1T5Lg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADDBD1012586;
        Wed,  9 Jun 2021 14:17:34 +0000 (UTC)
Received: from krava (unknown [10.40.195.97])
        by smtp.corp.redhat.com (Postfix) with SMTP id B0CE3608BA;
        Wed,  9 Jun 2021 14:17:31 +0000 (UTC)
Date:   Wed, 9 Jun 2021 16:17:30 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 15/19] libbpf: Add support to link multi func tracing
 program
Message-ID: <YMDNeve5/TColRcq@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-16-jolsa@kernel.org>
 <CAEf4BzaCWG1WtkQA6gZGvvGUhk3Si9jkZ2s6ToWowKhU4cXMuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaCWG1WtkQA6gZGvvGUhk3Si9jkZ2s6ToWowKhU4cXMuw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 10:34:11PM -0700, Andrii Nakryiko wrote:
> On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding support to link multi func tracing program
> > through link_create interface.
> >
> > Adding special types for multi func programs:
> >
> >   fentry.multi
> >   fexit.multi
> >
> > so you can define multi func programs like:
> >
> >   SEC("fentry.multi/bpf_fentry_test*")
> >   int BPF_PROG(test1, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
> >
> > that defines test1 to be attached to bpf_fentry_test* functions,
> > and able to attach ip and 6 arguments.
> >
> > If functions are not specified the program needs to be attached
> > manually.
> >
> > Adding new btf id related fields to bpf_link_create_opts and
> > bpf_link_create to use them.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/lib/bpf/bpf.c    | 11 ++++++-
> >  tools/lib/bpf/bpf.h    |  4 ++-
> >  tools/lib/bpf/libbpf.c | 72 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 85 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> > index 86dcac44f32f..da892737b522 100644
> > --- a/tools/lib/bpf/bpf.c
> > +++ b/tools/lib/bpf/bpf.c
> > @@ -674,7 +674,8 @@ int bpf_link_create(int prog_fd, int target_fd,
> >                     enum bpf_attach_type attach_type,
> >                     const struct bpf_link_create_opts *opts)
> >  {
> > -       __u32 target_btf_id, iter_info_len;
> > +       __u32 target_btf_id, iter_info_len, multi_btf_ids_cnt;
> > +       __s32 *multi_btf_ids;
> >         union bpf_attr attr;
> >         int fd;
> >
> > @@ -687,6 +688,9 @@ int bpf_link_create(int prog_fd, int target_fd,
> >         if (iter_info_len && target_btf_id)
> 
> here we check that mutually exclusive options are not specified, we
> should do the same for multi stuff

right, ok

> 
> >                 return libbpf_err(-EINVAL);
> >
> > +       multi_btf_ids = OPTS_GET(opts, multi_btf_ids, 0);
> > +       multi_btf_ids_cnt = OPTS_GET(opts, multi_btf_ids_cnt, 0);
> > +
> >         memset(&attr, 0, sizeof(attr));
> >         attr.link_create.prog_fd = prog_fd;
> >         attr.link_create.target_fd = target_fd;
> > @@ -701,6 +705,11 @@ int bpf_link_create(int prog_fd, int target_fd,
> >                 attr.link_create.target_btf_id = target_btf_id;
> >         }
> >
> > +       if (multi_btf_ids && multi_btf_ids_cnt) {
> > +               attr.link_create.multi_btf_ids = (__u64) multi_btf_ids;
> > +               attr.link_create.multi_btf_ids_cnt = multi_btf_ids_cnt;
> > +       }
> > +
> >         fd = sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
> >         return libbpf_err_errno(fd);
> >  }
> > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> > index 4f758f8f50cd..2f78b6c34765 100644
> > --- a/tools/lib/bpf/bpf.h
> > +++ b/tools/lib/bpf/bpf.h
> > @@ -177,8 +177,10 @@ struct bpf_link_create_opts {
> >         union bpf_iter_link_info *iter_info;
> >         __u32 iter_info_len;
> >         __u32 target_btf_id;
> > +       __s32 *multi_btf_ids;
> 
> why ids are __s32?..

hum not sure why I did that.. __u32 then

> 
> > +       __u32 multi_btf_ids_cnt;
> >  };
> > -#define bpf_link_create_opts__last_field target_btf_id
> > +#define bpf_link_create_opts__last_field multi_btf_ids_cnt
> >
> >  LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
> >                                enum bpf_attach_type attach_type,
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 65f87cc1220c..bd31de3b6a85 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -228,6 +228,7 @@ struct bpf_sec_def {
> >         bool is_attachable;
> >         bool is_attach_btf;
> >         bool is_sleepable;
> > +       bool is_multi_func;
> >         attach_fn_t attach_fn;
> >  };
> >
> > @@ -7609,6 +7610,8 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
> >
> >                 if (prog->sec_def->is_sleepable)
> >                         prog->prog_flags |= BPF_F_SLEEPABLE;
> > +               if (prog->sec_def->is_multi_func)
> > +                       prog->prog_flags |= BPF_F_MULTI_FUNC;
> >                 bpf_program__set_type(prog, prog->sec_def->prog_type);
> >                 bpf_program__set_expected_attach_type(prog,
> >                                 prog->sec_def->expected_attach_type);
> > @@ -9070,6 +9073,8 @@ static struct bpf_link *attach_raw_tp(const struct bpf_sec_def *sec,
> >                                       struct bpf_program *prog);
> >  static struct bpf_link *attach_trace(const struct bpf_sec_def *sec,
> >                                      struct bpf_program *prog);
> > +static struct bpf_link *attach_trace_multi(const struct bpf_sec_def *sec,
> > +                                          struct bpf_program *prog);
> >  static struct bpf_link *attach_lsm(const struct bpf_sec_def *sec,
> >                                    struct bpf_program *prog);
> >  static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
> > @@ -9143,6 +9148,14 @@ static const struct bpf_sec_def section_defs[] = {
> >                 .attach_fn = attach_iter),
> >         SEC_DEF("syscall", SYSCALL,
> >                 .is_sleepable = true),
> > +       SEC_DEF("fentry.multi/", TRACING,
> > +               .expected_attach_type = BPF_TRACE_FENTRY,
> 
> BPF_TRACE_MULTI_FENTRY instead of is_multi stuff everywhere?.. Or a
> new type of BPF program altogether?
> 
> > +               .is_multi_func = true,
> > +               .attach_fn = attach_trace_multi),
> > +       SEC_DEF("fexit.multi/", TRACING,
> > +               .expected_attach_type = BPF_TRACE_FEXIT,
> > +               .is_multi_func = true,
> > +               .attach_fn = attach_trace_multi),
> >         BPF_EAPROG_SEC("xdp_devmap/",           BPF_PROG_TYPE_XDP,
> >                                                 BPF_XDP_DEVMAP),
> >         BPF_EAPROG_SEC("xdp_cpumap/",           BPF_PROG_TYPE_XDP,
> > @@ -9584,6 +9597,9 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
> >         if (!name)
> >                 return -EINVAL;
> >
> > +       if (prog->prog_flags & BPF_F_MULTI_FUNC)
> > +               return 0;
> > +
> >         for (i = 0; i < ARRAY_SIZE(section_defs); i++) {
> >                 if (!section_defs[i].is_attach_btf)
> >                         continue;
> > @@ -10537,6 +10553,62 @@ static struct bpf_link *bpf_program__attach_btf_id(struct bpf_program *prog)
> >         return (struct bpf_link *)link;
> >  }
> >
> > +static struct bpf_link *bpf_program__attach_multi(struct bpf_program *prog)
> > +{
> > +       char *pattern = prog->sec_name + prog->sec_def->len;
> > +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> > +       enum bpf_attach_type attach_type;
> > +       int prog_fd, link_fd, cnt, err;
> > +       struct bpf_link *link = NULL;
> > +       __s32 *ids = NULL;
> > +
> > +       prog_fd = bpf_program__fd(prog);
> > +       if (prog_fd < 0) {
> > +               pr_warn("prog '%s': can't attach before loaded\n", prog->name);
> > +               return ERR_PTR(-EINVAL);
> > +       }
> > +
> > +       err = bpf_object__load_vmlinux_btf(prog->obj, true);
> > +       if (err)
> > +               return ERR_PTR(err);
> > +
> > +       cnt = btf__find_by_pattern_kind(prog->obj->btf_vmlinux, pattern,
> > +                                       BTF_KIND_FUNC, &ids);
> 
> I wonder if it would be better to just support a simplified glob
> patterns like "prefix*", "*suffix", "exactmatch", and "*substring*"?
> That should be sufficient for majority of cases. For the cases where
> user needs something more nuanced, they can just construct BTF ID list
> with custom code and do manual attach.

as I wrote earlier the function is just for the purpose of the test,
and we can always do the manual attach

I don't mind adding that simplified matching you described

jirka

> 
> > +       if (cnt <= 0)
> > +               return ERR_PTR(-EINVAL);
> > +
> > +       link = calloc(1, sizeof(*link));
> > +       if (!link) {
> > +               err = -ENOMEM;
> > +               goto out_err;
> > +       }
> > +       link->detach = &bpf_link__detach_fd;
> > +
> > +       opts.multi_btf_ids = ids;
> > +       opts.multi_btf_ids_cnt = cnt;
> > +
> > +       attach_type = bpf_program__get_expected_attach_type(prog);
> > +       link_fd = bpf_link_create(prog_fd, 0, attach_type, &opts);
> > +       if (link_fd < 0) {
> > +               err = -errno;
> > +               goto out_err;
> > +       }
> > +       link->fd = link_fd;
> > +       free(ids);
> > +       return link;
> > +
> > +out_err:
> > +       free(link);
> > +       free(ids);
> > +       return ERR_PTR(err);
> > +}
> > +
> > +static struct bpf_link *attach_trace_multi(const struct bpf_sec_def *sec,
> > +                                          struct bpf_program *prog)
> > +{
> > +       return bpf_program__attach_multi(prog);
> > +}
> > +
> >  struct bpf_link *bpf_program__attach_trace(struct bpf_program *prog)
> >  {
> >         return bpf_program__attach_btf_id(prog);
> > --
> > 2.31.1
> >
> 

