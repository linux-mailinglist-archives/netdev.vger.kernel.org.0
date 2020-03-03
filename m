Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C691783A5
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 21:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbgCCUF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 15:05:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42446 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731448AbgCCUF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 15:05:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583265924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oqvnJpDgLYD/tNq6zGIo7bmstN4/76XEt5bzM7y0dlA=;
        b=eZtmMwLLSnRbyUI0bWfzfE3z0Tmxj+yG5UBDwzZyPZg8MSnLzzpnmkLhNJQNERH31QyYrE
        uj9YjqBoyICpFPd/1+3i5wVMXpTWroNvq/sLwIvCc6v2MRbLHrcaTR39gxQZV9tLNKD7z1
        VYpnQX5BdHb4YNzxlPSHZEbrhKV+7wI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-CtyHItd5Obm2rWsnsQNnWg-1; Tue, 03 Mar 2020 15:05:20 -0500
X-MC-Unique: CtyHItd5Obm2rWsnsQNnWg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7571F107ACC4;
        Tue,  3 Mar 2020 20:05:18 +0000 (UTC)
Received: from krava (ovpn-206-59.brq.redhat.com [10.40.206.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8E581001B3F;
        Tue,  3 Mar 2020 20:05:15 +0000 (UTC)
Date:   Tue, 3 Mar 2020 21:05:13 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [RFC] libbpf,selftests: Question on btf_dump__emit_type_decl for
 BTF_KIND_FUNC
Message-ID: <20200303200513.GB74093@krava>
References: <20200303140837.90056-1-jolsa@kernel.org>
 <CAEf4BzY8_=wcL3N96eS-jcSPBL=ueMgQg+m=Fxiw+o0Tc7F23Q@mail.gmail.com>
 <20200303173314.GA74093@krava>
 <CAEf4BzYQYJJwLUNhDoKcdgKsMijf9R5vG-vbOBYA-nUAgNs1qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYQYJJwLUNhDoKcdgKsMijf9R5vG-vbOBYA-nUAgNs1qA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 10:00:02AM -0800, Andrii Nakryiko wrote:
> On Tue, Mar 3, 2020 at 9:33 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Mar 03, 2020 at 09:09:38AM -0800, Andrii Nakryiko wrote:
> > > On Tue, Mar 3, 2020 at 6:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > hi,
> > > > for bpftrace I'd like to print BTF functions (BTF_KIND_FUNC)
> > > > declarations together with their names.
> > > >
> > > > I saw we have btf_dump__emit_type_decl and added BTF_KIND_FUNC,
> > > > where it seemed to be missing, so it prints out something now
> > > > (not sure it's the right fix though).
> > > >
> > > > Anyway, would you be ok with adding some flag/bool to struct
> > > > btf_dump_emit_type_decl_opts, so I could get output like:
> > > >
> > > >   kfunc:ksys_readahead(int fd, long long int offset, long unsigned int count) = ssize_t
> > > >   kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t
> > > >
> > > > ... to be able to the arguments and return type separated,
> > > > so I could easily get to something like above?
> > > >
> > > > Current interface is just vfprintf callback and I'm not sure
> > > > I can rely that it will allywas be called with same arguments,
> > > > like having separated calls for parsed atoms like 'return type',
> > > > '(', ')', '(', 'arg type', 'arg name', ...
> > > >
> > > > I'm open to any suggestion ;-)
> > >
> > > Hey Jiri!
> > >
> > > Can you please elaborate on the use case and problem you are trying to solve?
> > >
> > > I think we can (and probably even should) add such option and support
> > > to dump functions, but whatever we do it should be a valid C syntax
> > > and should be compilable.
> > > Example above:
> > >
> > > kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t
> > >
> > > Is this really the syntax you need to get? I think btf_dump, when
> > > (optionally) emitting function declaration, will have to emit that
> > > particular one as:
> > >
> > > size_t ksys_read(unsigned int fd, char buf, long unsigned int count);
> > >
> > > But I'd like to hear the use case before we add this. Thanks!
> >
> > the use case is just for the 'bpftrace -l' output, which displays
> > the probe names that could be used.. for kernel BTF kernel functions
> > it's 'kfunc:function(args)'
> >
> >         software:task-clock:
> >         hardware:backend-stalls:
> >         hardware:branch-instructions:
> >         ...
> >         tracepoint:kvmmmu:kvm_mmu_pagetable_walk
> >         tracepoint:kvmmmu:kvm_mmu_paging_element
> >         ...
> >         kprobe:console_on_rootfs
> >         kprobe:trace_initcall_start_cb
> >         kprobe:run_init_process
> >         kprobe:try_to_run_init_process
> >         ...
> >         kfunc:x86_reserve_hardware
> >         kfunc:hw_perf_lbr_event_destroy
> >         kfunc:x86_perf_event_update
> >
> > I dont want to print the return type as is in C, because it would
> > mess up the whole output, hence the '= <return type>'
> >
> >         kfunc:ksys_readahead(int fd, long long int offset, long unsigned int count) = ssize_t
> >         kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t
> >
> > also possible only in verbose mode ;-)
> >
> > the final shape of the format will be decided in a bpftrace review,
> > but in any case I think I'll need some way to get these bits:
> >   <args> <return type>
> >
> 
> Ok, I think for your use case it's better for you to implement it
> customly, I don't think this fits btf_dump() C output as is. But you
> have all the right high-level APIs anyways. There is nothing irregular
> about function declarations, thankfully. Pointers to functions are way
> more involved, syntactically, which is already abstracted from you in
> btf_dump__emit_type_decl(). Here's the code:
> 
> static int dump_funcs(const struct btf *btf, struct btf_dump *d)
> {
>         int err = 0, i, j, cnt = btf__get_nr_types(btf);
>         const struct btf_type *t;
>         const struct btf_param *p;
>         const char *name;
> 
>         for (i = 1; i <= cnt; i++) {
>                 t = btf__type_by_id(btf, i);
>                 if (!btf_is_func(t))
>                         continue;
> 
>                 name = btf__name_by_offset(btf, t->name_off);
>                 t = btf__type_by_id(btf, t->type);
>                 if (!btf_is_func_proto(t))
>                         return -EINVAL;
> 
>                 printf("kfunc:%s(", name);
>                 for (j = 0, p = btf_params(t); j < btf_vlen(t); j++, p++) {
>                         err = btf_dump__emit_type_decl(d, p->type, NULL);
>                         if (err)
>                                 return err;
>                 }
>                 printf(") = ");
> 
>                 err = btf_dump__emit_type_decl(d, t->type, NULL);
>                 if (err)
>                         return err;

aaah right, we could move it one level down ;-) ok, that will do

> 
>                 printf(";\n");
>         }
>         return 0;
> }
> 
> Beware, this will crash right now due to NULL field_name, but I'm
> fixing that with a tiny patch in just a second.
> 
> Also beware, there are no argument names captures for func_protos...
> 
> So with the above (and btf_dump__emit_type_decl() fix for NULL
> field_name), this will produce output:
> 
> kfunc:num_digits(int) = int;
> kfunc:copy_from_user_nmi(void *const void *long unsigned int) = long
> unsigned int;
> kfunc:arch_wb_cache_pmem(void *size_t) = void;
> kfunc:__clear_user(void *long unsigned int) = long unsigned int;

thanks, I'll use that

jirka

