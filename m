Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F54A31AD2F
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 17:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhBMQn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 11:43:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229690AbhBMQnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 11:43:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613234514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CFzmDa/KGuuQsQx0DDBef7gqPGBnn8UpPfi1reQ/ou0=;
        b=BkpcxwhJYdsFUt78QU9E/ygeistdjKLtdA6Tplr6dfM4uZWcPks9AUhIj+09gIycj54TDO
        6yh0ExbgqrcWJjWHC5PIXd54MkYS60F1qoSNpiBIOjVZISmugo+Ql2esT5LclbFgYJPZed
        wFBgEQOBbIaIekWCyhI1CoDgIefc9xs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-1-ysXB80NOS4IRfp614DVw-1; Sat, 13 Feb 2021 11:41:50 -0500
X-MC-Unique: 1-ysXB80NOS4IRfp614DVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 848F1192CC41;
        Sat, 13 Feb 2021 16:41:48 +0000 (UTC)
Received: from krava (unknown [10.40.192.50])
        by smtp.corp.redhat.com (Postfix) with SMTP id DD6B31ABE5;
        Sat, 13 Feb 2021 16:41:44 +0000 (UTC)
Date:   Sat, 13 Feb 2021 17:41:43 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] btf_encoder: Match ftrace addresses within elf functions
Message-ID: <YCgBR6c7UdmhNgwr@krava>
References: <20210212135427.1250224-1-jolsa@redhat.com>
 <20210212220420.1289014-1-jolsa@kernel.org>
 <CAEf4BzYN7FnGjEYMDqQFK1LryUi0+cBTqaFXmPU_kBN1jJ+LLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYN7FnGjEYMDqQFK1LryUi0+cBTqaFXmPU_kBN1jJ+LLg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 02:21:04PM -0800, Andrii Nakryiko wrote:
> On Fri, Feb 12, 2021 at 2:05 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Currently when processing DWARF function, we check its entrypoint
> > against ftrace addresses, assuming that the ftrace address matches
> > with function's entrypoint.
> >
> > This is not the case on some architectures as reported by Nathan
> > when building kernel on arm [1].
> >
> > Fixing the check to take into account the whole function not
> > just the entrypoint.
> >
> > Most of the is_ftrace_func code was contributed by Andrii.
> >
> > [1] https://lore.kernel.org/bpf/20210209034416.GA1669105@ubuntu-m3-large-x86/
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> LGTM. But see another suggestion below. In either case:
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> >  btf_encoder.c | 55 +++++++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 45 insertions(+), 10 deletions(-)
> >
> > diff --git a/btf_encoder.c b/btf_encoder.c
> > index b124ec20a689..03242f04c55d 100644
> > --- a/btf_encoder.c
> > +++ b/btf_encoder.c
> > @@ -36,6 +36,7 @@ struct funcs_layout {
> >  struct elf_function {
> >         const char      *name;
> >         unsigned long    addr;
> > +       unsigned long    size;
> >         unsigned long    sh_addr;
> >         bool             generated;
> >  };
> > @@ -98,6 +99,7 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
> >
> >         functions[functions_cnt].name = name;
> >         functions[functions_cnt].addr = elf_sym__value(sym);
> > +       functions[functions_cnt].size = elf_sym__size(sym);
> >         functions[functions_cnt].sh_addr = sh.sh_addr;
> >         functions[functions_cnt].generated = false;
> >         functions_cnt++;
> > @@ -236,6 +238,48 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
> >         return 0;
> >  }
> >
> > +static int is_ftrace_func(struct elf_function *func, __u64 *addrs,
> > +                         __u64 count, bool kmod)
> > +{
> > +       /*
> > +        * For vmlinux image both addrs[x] and functions[x]::addr
> > +        * values are final address and are comparable.
> > +        *
> > +        * For kernel module addrs[x] is final address, but
> > +        * functions[x]::addr is relative address within section
> > +        * and needs to be relocated by adding sh_addr.
> > +        */
> > +       __u64 start = kmod ? func->addr + func->sh_addr : func->addr;
> > +       __u64 addr, end = func->addr + func->size;
> > +
> > +       /*
> > +        * The invariant here is addr[r] that is the smallest address
> > +        * that is >= than function start addr. Except the corner case
> > +        * where there is no such r, but for that we have a final check
> > +        * in the return.
> > +        */
> > +       size_t l = 0, r = count - 1, m;
> > +
> > +       /* make sure we don't use invalid r */
> > +       if (count == 0)
> > +               return false;
> > +
> > +       while (l < r) {
> > +               m = l + (r - l) / 2;
> > +               addr = addrs[m];
> > +
> > +               if (addr >= start) {
> > +                       /* we satisfy invariant, so tighten r */
> > +                       r = m;
> > +               } else {
> > +                       /* m is not good enough as l, maybe m + 1 will be */
> > +                       l = m + 1;
> > +               }
> > +       }
> > +
> > +       return start <= addrs[r] && addrs[r] < end;
> > +}
> > +
> >  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> >  {
> >         __u64 *addrs, count, i;
> > @@ -275,18 +319,9 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> >          */
> >         for (i = 0; i < functions_cnt; i++) {
> >                 struct elf_function *func = &functions[i];
> > -               /*
> > -                * For vmlinux image both addrs[x] and functions[x]::addr
> > -                * values are final address and are comparable.
> > -                *
> > -                * For kernel module addrs[x] is final address, but
> > -                * functions[x]::addr is relative address within section
> > -                * and needs to be relocated by adding sh_addr.
> > -                */
> > -               __u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
> 
> if we just...
> 
> if (kmod)
>     func->addr += func->sh_addr;
> 
> ... here, that would make is_ftrace_func() free of kmod knowledge. If
> there are other places that rely on kmod vs non-kmod address of a
> function, that would be simplified as well, right?

yes, this is the only place for now, I'll make the change

thanks,
jirka

> 
> >
> >                 /* Make sure function is within ftrace addresses. */
> > -               if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> > +               if (is_ftrace_func(func, addrs, count, kmod)) {
> >                         /*
> >                          * We iterate over sorted array, so we can easily skip
> >                          * not valid item and move following valid field into
> > --
> > 2.29.2
> >
> 

