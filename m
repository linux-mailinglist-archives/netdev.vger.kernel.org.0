Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F0734CE99
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhC2LRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:17:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27094 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230432AbhC2LQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:16:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617016616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cz/cjJRBylKhD4ItdpjXqR/ijI/EJe3f4X9M4EbEIzM=;
        b=Arjo/RkwtILsw/7eFh6soWodJ4ojIKEjagFYCcYkB9quw5FA1VeEpLPvHVUFGf9btGkSSH
        28RGa+2an7yGyeDiFJhACTD4MYqnMy0nrM5AMeAqn0S0Vqr5owyAfgap/UlFjpRuQ5Hpkc
        QpteAEwXqljp+cGlk1Qe000nlbF+Bbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-Hc_yTmx8OoefdXTb_hlLJA-1; Mon, 29 Mar 2021 07:16:51 -0400
X-MC-Unique: Hc_yTmx8OoefdXTb_hlLJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA26B501FB;
        Mon, 29 Mar 2021 11:16:50 +0000 (UTC)
Received: from krava (unknown [10.40.195.107])
        by smtp.corp.redhat.com (Postfix) with SMTP id E4A0E5D9F0;
        Mon, 29 Mar 2021 11:16:48 +0000 (UTC)
Date:   Mon, 29 Mar 2021 13:16:47 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 07/12] libbpf: add BPF static linker BTF and
 BTF.ext support
Message-ID: <YGG3H7Df5PA6UGk+@krava>
References: <20210318194036.3521577-1-andrii@kernel.org>
 <20210318194036.3521577-8-andrii@kernel.org>
 <YFTQExmhNhMcmNOb@krava>
 <CAEf4BzYKassG0AP372Q=Qsd+qqy7=YGe2XTXR4zG0c5oQ7Nkeg@mail.gmail.com>
 <YFT0Q+mVbTEI1rem@krava>
 <YGBwmlQTDUodxM0J@krava>
 <CAEf4BzbeCOU+ScbycxUGwbmKhqjU5EWBj=dry-GXVOwOXe86ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbeCOU+ScbycxUGwbmKhqjU5EWBj=dry-GXVOwOXe86ag@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 11:29:27AM -0700, Andrii Nakryiko wrote:
> On Sun, Mar 28, 2021 at 5:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Fri, Mar 19, 2021 at 07:58:13PM +0100, Jiri Olsa wrote:
> > > On Fri, Mar 19, 2021 at 11:39:01AM -0700, Andrii Nakryiko wrote:
> > > > On Fri, Mar 19, 2021 at 9:23 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > >
> > > > > On Thu, Mar 18, 2021 at 12:40:31PM -0700, Andrii Nakryiko wrote:
> > > > >
> > > > > SNIP
> > > > >
> > > > > > +
> > > > > > +     return NULL;
> > > > > > +}
> > > > > > +
> > > > > > +static int linker_fixup_btf(struct src_obj *obj)
> > > > > > +{
> > > > > > +     const char *sec_name;
> > > > > > +     struct src_sec *sec;
> > > > > > +     int i, j, n, m;
> > > > > > +
> > > > > > +     n = btf__get_nr_types(obj->btf);
> > > > >
> > > > > hi,
> > > > > I'm getting bpftool crash when building tests,
> > > > >
> > > > > looks like above obj->btf can be NULL:
> > > >
> > > > I lost if (!obj->btf) return 0; somewhere along the rebases. I'll send
> > > > a fix shortly. But how did you end up with selftests BPF objects built
> > > > without BTF?
> > >
> > > no idea.. I haven't even updated llvm for almost 3 days now ;-)
> >
> > sorry for late follow up on this, and it's actually forgotten empty
> > object in progs directory that was causing this
> >
> > I wonder we should add empty object like below to catch these cases,
> 
> well, feel free to chime in on [0] then
> 
>   [0] https://patchwork.kernel.org/project/netdevbpf/patch/20210319205909.1748642-4-andrii@kernel.org/

right, well this would be added to catch similar crashes,
which I think you both agree on

> 
> > because there's another place that bpftool is crashing on with it
> >
> > I can send full patch for that if you think it's worth having
> 
> sure, but see my comment below

ok, thanks
jirka

> 
> >
> > jirka
> >
> >
> > ---
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 7aad78dbb4b4..aecb6ca52bce 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -3165,6 +3165,9 @@ static int add_dummy_ksym_var(struct btf *btf)
> >         const struct btf_var_secinfo *vs;
> >         const struct btf_type *sec;
> >
> > +       if (!btf)
> > +               return 0;
> > +
> 
> add_dummy_ksym_var() shouldn't be called, if there is no btf, so the
> fix should be outside of this fix.
> 
> >         sec_btf_id = btf__find_by_name_kind(btf, KSYMS_SEC,
> >                                             BTF_KIND_DATASEC);
> >         if (sec_btf_id < 0)
> > diff --git a/tools/testing/selftests/bpf/progs/empty.c b/tools/testing/selftests/bpf/progs/empty.c
> > new file mode 100644
> > index 000000000000..e69de29bb2d1
> >
> 

