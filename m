Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB943A162B
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhFINzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:55:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236143AbhFINzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623246791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I98s1qNBjYN20ZD/jjdHcGtzxzwR0Qh8wsfstpatNdE=;
        b=DY4EUgpWD3BuTWgXOFAQF5JyXq9I7JFS+ZsTh4GU9h4Pg3Eh9RiCj6dWkLiHPOBh/ik27V
        lRRnA5UHisFyceq0PCDrAAPwNIGosdKgtUtxSEFShtaKJc8h3KeoIzvf84wo6hBRxuGhty
        K8+quG6HIEctqqwP3cY1XEPshYZOmug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-73EMVyDpPki7VZrDxZvKXA-1; Wed, 09 Jun 2021 09:53:09 -0400
X-MC-Unique: 73EMVyDpPki7VZrDxZvKXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F5D4185060B;
        Wed,  9 Jun 2021 13:53:08 +0000 (UTC)
Received: from krava (unknown [10.40.195.97])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3827718AA1;
        Wed,  9 Jun 2021 13:53:05 +0000 (UTC)
Date:   Wed, 9 Jun 2021 15:53:04 +0200
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
Subject: Re: [PATCH 13/19] bpf: Add support to link multi func tracing program
Message-ID: <YMDHwANChgw0z1IY@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-14-jolsa@kernel.org>
 <CAEf4BzbrwiAJobuU01rd3XEw_b-vbUiL-uqM4_5_FZuAT7rSxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbrwiAJobuU01rd3XEw_b-vbUiL-uqM4_5_FZuAT7rSxA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 10:18:21PM -0700, Andrii Nakryiko wrote:
> On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding support to attach multiple functions to tracing program
> > by using the link_create/link_update interface.
> >
> > Adding multi_btf_ids/multi_btf_ids_cnt pair to link_create struct
> > API, that define array of functions btf ids that will be attached
> > to prog_fd.
> >
> > The prog_fd needs to be multi prog tracing program (BPF_F_MULTI_FUNC).
> 
> So I'm not sure why we added a new load flag instead of just using a
> new BPF program type or expected attach type?  We have different
> trampolines and different kinds of links for them, so why not be
> consistent and use the new type of BPF program?.. It does change BPF
> verifier's treatment of input arguments, so it's not just a slight
> variation, it's quite different type of program.

ok, makes sense ... BPF_PROG_TYPE_TRACING_MULTI ?

SNIP

> >  struct bpf_attach_target_info {
> > @@ -746,6 +747,8 @@ void bpf_ksym_add(struct bpf_ksym *ksym);
> >  void bpf_ksym_del(struct bpf_ksym *ksym);
> >  int bpf_jit_charge_modmem(u32 pages);
> >  void bpf_jit_uncharge_modmem(u32 pages);
> > +struct bpf_trampoline *bpf_trampoline_multi_alloc(void);
> > +void bpf_trampoline_multi_free(struct bpf_trampoline *tr);
> >  #else
> >  static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
> >                                            struct bpf_trampoline *tr)
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index ad9340fb14d4..5fd6ff64e8dc 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1007,6 +1007,7 @@ enum bpf_link_type {
> >         BPF_LINK_TYPE_ITER = 4,
> >         BPF_LINK_TYPE_NETNS = 5,
> >         BPF_LINK_TYPE_XDP = 6,
> > +       BPF_LINK_TYPE_TRACING_MULTI = 7,
> >
> >         MAX_BPF_LINK_TYPE,
> >  };
> > @@ -1454,6 +1455,10 @@ union bpf_attr {
> >                                 __aligned_u64   iter_info;      /* extra bpf_iter_link_info */
> >                                 __u32           iter_info_len;  /* iter_info length */
> >                         };
> > +                       struct {
> > +                               __aligned_u64   multi_btf_ids;          /* addresses to attach */
> > +                               __u32           multi_btf_ids_cnt;      /* addresses count */
> > +                       };
> 
> let's do what bpf_link-based TC-BPF API is doing, put it into a named
> field (I'd do the same for iter_info/iter_info_len above as well, I'm
> not sure why we did this flat naming scheme, we now it's inconvenient
> when extending stuff).
> 
> struct {
>     __aligned_u64 btf_ids;
>     __u32 btf_ids_cnt;
> } multi;

ok

> 
> >                 };
> >         } link_create;
> >
> 
> [...]
> 
> > +static int bpf_tracing_multi_link_update(struct bpf_link *link,
> > +                                        struct bpf_prog *new_prog,
> > +                                        struct bpf_prog *old_prog __maybe_unused)
> > +{
> 
> BPF_LINK_UPDATE command supports passing old_fd and extra flags. We
> can use that to implement both updating existing BPF program in-place
> (by passing BPF_F_REPLACE and old_fd) or adding the program to the
> list of programs, if old_fd == 0. WDYT?

yes, sounds good

thanks,
jirka

