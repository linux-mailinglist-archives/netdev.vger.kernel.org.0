Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0FE29E76A
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 10:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgJ2JeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 05:34:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbgJ2JeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 05:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603964041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vt9IrI+bbNphkz41mmMtwpNk3Dc6tdCm1kauoJydoGY=;
        b=jOPkRiY2HUDqCriUIzumyYBdWOIQbv01gICEbAQvfQVXVwBULfD1ryyawAlilWE8opSmFq
        +ZlHOUZp+TPFtSqZmZWa+TBwn12gBtzsvhSR7dU19kDgO55Bevj2CRhByy/oASRoTeCJkz
        qbQ+/QKgcS1f/0ejlCXoxp6AxLIVLd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-eWboWm2qPCWmrG4GxZMBmg-1; Thu, 29 Oct 2020 05:33:57 -0400
X-MC-Unique: eWboWm2qPCWmrG4GxZMBmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1472364149;
        Thu, 29 Oct 2020 09:33:55 +0000 (UTC)
Received: from krava (unknown [10.40.193.60])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3AEDF5B4A1;
        Thu, 29 Oct 2020 09:33:44 +0000 (UTC)
Date:   Thu, 29 Oct 2020 10:33:43 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 07/16] kallsyms: Use rb tree for kallsyms name
 search
Message-ID: <20201029093343.GB3027684@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022082138.2322434-8-jolsa@kernel.org>
 <20201028182534.GS2900849@krava>
 <CAEf4BzarrQLrh4PXZvMmrL8KpBTjB65V9+jxn0os-Yd2jN2aYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzarrQLrh4PXZvMmrL8KpBTjB65V9+jxn0os-Yd2jN2aYQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 03:40:46PM -0700, Andrii Nakryiko wrote:
> On Wed, Oct 28, 2020 at 3:29 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Oct 22, 2020 at 10:21:29AM +0200, Jiri Olsa wrote:
> > > The kallsyms_expand_symbol function showed in several bpf related
> > > profiles, because it's doing linear search.
> > >
> > > Before:
> > >
> > >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
> > >    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> > >
> > >      2,535,458,767      cycles:k                         ( +-  0.55% )
> > >        940,046,382      cycles:u                         ( +-  0.27% )
> > >
> > >              33.60 +- 3.27 seconds time elapsed  ( +-  9.73% )
> > >
> > > Loading all the vmlinux symbols in rbtree and and switch to rbtree
> > > search in kallsyms_lookup_name function to save few cycles and time.
> > >
> > > After:
> > >
> > >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
> > >    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> > >
> > >      2,199,433,771      cycles:k                         ( +-  0.55% )
> > >        936,105,469      cycles:u                         ( +-  0.37% )
> > >
> > >              26.48 +- 3.57 seconds time elapsed  ( +- 13.49% )
> > >
> > > Each symbol takes 160 bytes, so for my .config I've got about 18 MBs
> > > used for 115285 symbols.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >
> > FYI there's init_kprobes dependency on kallsyms_lookup_name in early
> > init call, so this won't work as it is :-\ will address this in v2
> >
> > also I'll switch to sorted array and bsearch, because kallsyms is not
> > dynamically updated
> 
> what about kernel modules then?

please check my answer to Alexei, I just answered it there

thanks,
jirka

> 
> >
> > jirka
> >
> > > ---
> > >  kernel/kallsyms.c | 95 ++++++++++++++++++++++++++++++++++++++++++-----
> > >  1 file changed, 86 insertions(+), 9 deletions(-)
> > >
> 
> [...]
> 

