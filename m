Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E417F4AD41F
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 09:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352361AbiBHI4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 03:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbiBHI4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 03:56:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B266C03FEC1
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 00:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644310566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HqHf6EUSPiajiRiec1PDYOjczpr3OtMb+80DurOQm1Q=;
        b=ezOyJQgyV11S8QI8LeSycVL1pEqDadexsV7uNrc+JbyLYz+iBP+vcWHQktmIIoyUfeMc9D
        5naXFgjdljni+Z6Kt06TZ0SdGpinuNyEvWBKLGh9pFDpa48tPGvfrablRsE6NWNuc8EbJl
        xIBcYOGfPbBqJ4xuIphX0Vhy4wR8DLM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638--9BP0urbMBaRzGg0tyvVAg-1; Tue, 08 Feb 2022 03:56:05 -0500
X-MC-Unique: -9BP0urbMBaRzGg0tyvVAg-1
Received: by mail-ej1-f69.google.com with SMTP id kw5-20020a170907770500b006ba314a753eso5414215ejc.21
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 00:56:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HqHf6EUSPiajiRiec1PDYOjczpr3OtMb+80DurOQm1Q=;
        b=CExNDRhTEs+KVI7tz0azzkyPZ9SWTsd9iaIF3RkcC2/EHDpNR6U9Y9KRW2szns7HLI
         8k242Kw7zlFvDbtv8mxuUcmI5DZY+dgNbrxYgfb8By0xIBToVT0tVlw03AOw5Cf3Dfiv
         FPMgkxGmEgSfTarnrseA163gxX6v0I2kYy1O2f5y4V0oFJidI8aFml6/QYCPrCK1hzrZ
         pesy5gRRYatojnh2TNIdOQPZjA//tAKH9BU6qC2+LUGjpcmHDc6/QfZPxviFqzUDfb4L
         AaA5C+xHiNwJVmC4QYP9FY34C7geEtKykKeUCVhB1zTTVfS2S1FAZ9r3x7iu/e7laAja
         qo8Q==
X-Gm-Message-State: AOAM533hnnc7xxgeV15L2yu0njzAMc3jb9ufH3C2PCbxZfFgVkQPkUoo
        ZkUDQ022zAUz0Pr5n97wgKWVX3EMznPoPAf53fy8J4gvF/F+C1NDe2gGtSoBXi7PSDmIUniKZSI
        O9Ym6ya0+DQK+4q1n
X-Received: by 2002:a17:906:ece8:: with SMTP id qt8mr2833150ejb.738.1644310563747;
        Tue, 08 Feb 2022 00:56:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgmPnTDJ6VlcDa8upD9ktiB96Y6h6udXwi5BYuSzgtm0wmNJhiXp3oe3DRP7Kchc8LQVc1Ew==
X-Received: by 2002:a17:906:ece8:: with SMTP id qt8mr2833120ejb.738.1644310563433;
        Tue, 08 Feb 2022 00:56:03 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id hw16sm1427914ejc.10.2022.02.08.00.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 00:56:02 -0800 (PST)
Date:   Tue, 8 Feb 2022 09:56:01 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Subject: Re: [PATCH 1/8] bpf: Add support to attach kprobe program with fprobe
Message-ID: <YgIwISCfw+DfIBTR@krava>
References: <20220202135333.190761-1-jolsa@kernel.org>
 <20220202135333.190761-2-jolsa@kernel.org>
 <CAEf4BzZYepTYLN6LrPAAaOXUtCBv07bQQJzgarntu03L+cj2GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZYepTYLN6LrPAAaOXUtCBv07bQQJzgarntu03L+cj2GQ@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 10:59:14AM -0800, Andrii Nakryiko wrote:
> On Wed, Feb 2, 2022 at 5:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding new link type BPF_LINK_TYPE_FPROBE that attaches kprobe program
> > through fprobe API.
> >
> > The fprobe API allows to attach probe on multiple functions at once very
> > fast, because it works on top of ftrace. On the other hand this limits
> > the probe point to the function entry or return.
> >
> > The kprobe program gets the same pt_regs input ctx as when it's attached
> > through the perf API.
> >
> > Adding new attach type BPF_TRACE_FPROBE that enables such link for kprobe
> > program.
> >
> > User provides array of addresses or symbols with count to attach the kprobe
> > program to. The new link_create uapi interface looks like:
> >
> >   struct {
> >           __aligned_u64   syms;
> >           __aligned_u64   addrs;
> >           __u32           cnt;
> >           __u32           flags;
> >   } fprobe;
> >
> > The flags field allows single BPF_F_FPROBE_RETURN bit to create return fprobe.
> >
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/bpf_types.h      |   1 +
> >  include/uapi/linux/bpf.h       |  13 ++
> >  kernel/bpf/syscall.c           | 248 ++++++++++++++++++++++++++++++++-
> >  tools/include/uapi/linux/bpf.h |  13 ++
> >  4 files changed, 270 insertions(+), 5 deletions(-)
> >
> 
> [...]
> 
> >
> > +#ifdef CONFIG_FPROBE
> > +
> > +struct bpf_fprobe_link {
> > +       struct bpf_link link;
> > +       struct fprobe fp;
> > +       unsigned long *addrs;
> > +};
> > +
> > +static void bpf_fprobe_link_release(struct bpf_link *link)
> > +{
> > +       struct bpf_fprobe_link *fprobe_link;
> > +
> > +       fprobe_link = container_of(link, struct bpf_fprobe_link, link);
> > +       unregister_fprobe(&fprobe_link->fp);
> > +}
> > +
> > +static void bpf_fprobe_link_dealloc(struct bpf_link *link)
> > +{
> > +       struct bpf_fprobe_link *fprobe_link;
> > +
> > +       fprobe_link = container_of(link, struct bpf_fprobe_link, link);
> > +       kfree(fprobe_link->addrs);
> > +       kfree(fprobe_link);
> > +}
> > +
> > +static const struct bpf_link_ops bpf_fprobe_link_lops = {
> > +       .release = bpf_fprobe_link_release,
> > +       .dealloc = bpf_fprobe_link_dealloc,
> > +};
> > +
> 
> should this whole new link implementation (including
> fprobe_link_prog_run() below) maybe live in kernel/trace/bpf_trace.c?
> Seems a bit more fitting than kernel/bpf/syscall.c

right, it's trace related

> 
> > +static int fprobe_link_prog_run(struct bpf_fprobe_link *fprobe_link,
> > +                               struct pt_regs *regs)
> > +{
> > +       int err;
> > +
> > +       if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
> > +               err = 0;
> > +               goto out;
> > +       }
> > +
> > +       rcu_read_lock();
> > +       migrate_disable();
> > +       err = bpf_prog_run(fprobe_link->link.prog, regs);
> > +       migrate_enable();
> > +       rcu_read_unlock();
> > +
> > + out:
> > +       __this_cpu_dec(bpf_prog_active);
> > +       return err;
> > +}
> > +
> > +static void fprobe_link_entry_handler(struct fprobe *fp, unsigned long entry_ip,
> > +                                     struct pt_regs *regs)
> > +{
> > +       unsigned long saved_ip = instruction_pointer(regs);
> > +       struct bpf_fprobe_link *fprobe_link;
> > +
> > +       /*
> > +        * Because fprobe's regs->ip is set to the next instruction of
> > +        * dynamic-ftrace insturction, correct entry ip must be set, so
> > +        * that the bpf program can access entry address via regs as same
> > +        * as kprobes.
> > +        */
> > +       instruction_pointer_set(regs, entry_ip);
> > +
> > +       fprobe_link = container_of(fp, struct bpf_fprobe_link, fp);
> > +       fprobe_link_prog_run(fprobe_link, regs);
> > +
> > +       instruction_pointer_set(regs, saved_ip);
> > +}
> > +
> > +static void fprobe_link_exit_handler(struct fprobe *fp, unsigned long entry_ip,
> > +                                    struct pt_regs *regs)
> 
> isn't it identical to fprobe_lnk_entry_handler? Maybe use one callback
> for both entry and exit?

heh, did not notice that :) yep, looks that way, will check

> 
> > +{
> > +       unsigned long saved_ip = instruction_pointer(regs);
> > +       struct bpf_fprobe_link *fprobe_link;
> > +
> > +       instruction_pointer_set(regs, entry_ip);
> > +
> > +       fprobe_link = container_of(fp, struct bpf_fprobe_link, fp);
> > +       fprobe_link_prog_run(fprobe_link, regs);
> > +
> > +       instruction_pointer_set(regs, saved_ip);
> > +}
> > +
> > +static int fprobe_resolve_syms(const void *usyms, u32 cnt,
> > +                              unsigned long *addrs)
> > +{
> > +       unsigned long addr, size;
> > +       const char **syms;
> > +       int err = -ENOMEM;
> > +       unsigned int i;
> > +       char *func;
> > +
> > +       size = cnt * sizeof(*syms);
> > +       syms = kzalloc(size, GFP_KERNEL);
> 
> any reason not to use kvzalloc() here?

probably just my ignorance ;-) will check

> 
> > +       if (!syms)
> > +               return -ENOMEM;
> > +
> 
> [...]
> 
> > +
> > +static int bpf_fprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > +{
> > +       struct bpf_fprobe_link *link = NULL;
> > +       struct bpf_link_primer link_primer;
> > +       unsigned long *addrs;
> > +       u32 flags, cnt, size;
> > +       void __user *uaddrs;
> > +       void __user *usyms;
> > +       int err;
> > +
> > +       /* no support for 32bit archs yet */
> > +       if (sizeof(u64) != sizeof(void *))
> > +               return -EINVAL;
> 
> -EOPNOTSUPP?

ok

> 
> > +
> > +       if (prog->expected_attach_type != BPF_TRACE_FPROBE)
> > +               return -EINVAL;
> > +
> > +       flags = attr->link_create.fprobe.flags;
> > +       if (flags & ~BPF_F_FPROBE_RETURN)
> > +               return -EINVAL;
> > +
> > +       uaddrs = u64_to_user_ptr(attr->link_create.fprobe.addrs);
> > +       usyms = u64_to_user_ptr(attr->link_create.fprobe.syms);
> > +       if ((!uaddrs && !usyms) || (uaddrs && usyms))
> > +               return -EINVAL;
> 
> !!uaddrs == !!usyms ?

ah right, will change

> 
> > +
> > +       cnt = attr->link_create.fprobe.cnt;
> > +       if (!cnt)
> > +               return -EINVAL;
> > +
> > +       size = cnt * sizeof(*addrs);
> > +       addrs = kzalloc(size, GFP_KERNEL);
> 
> same, why not kvzalloc? Also, aren't you overwriting each addrs entry
> anyway, so "z" is not necessary, right?

true, no need for zeroing

thanks,
jirka

