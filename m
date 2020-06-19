Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75832200983
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgFSNFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:05:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42803 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725806AbgFSNFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592571948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WNsf8IexMCY/OkFOSI6bu7aqViRl1CJCZz35rwX9Mu8=;
        b=YW1s4U3KzExwMF99vjhe3PBtK66zCn6m0frlI45nOgDOleHCTtT63cCMsLtvM4nCoEfHji
        kdghQkrpI43daMuEEXVzw2JSTRex1liaKNRT+Wb2F2KRIMC7JQZ7n7bk7sVfPqM3V6QdMl
        +z7Wspwnj6avSVrNEQspg/Ya4kS5kQ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-AKwGdyJmNzeAekZ8dWfarw-1; Fri, 19 Jun 2020 09:05:46 -0400
X-MC-Unique: AKwGdyJmNzeAekZ8dWfarw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7BE7107ACCD;
        Fri, 19 Jun 2020 13:05:43 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with SMTP id 425D65D9CA;
        Fri, 19 Jun 2020 13:05:40 +0000 (UTC)
Date:   Fri, 19 Jun 2020 15:05:39 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 03/11] bpf: Add btf_ids object
Message-ID: <20200619130539.GC2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-4-jolsa@kernel.org>
 <CAEf4BzZBKyP2uifNeH6pBm=wQk_WwhL8DjGdgsjgxmQUNqe_Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZBKyP2uifNeH6pBm=wQk_WwhL8DjGdgsjgxmQUNqe_Lw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 06:02:48PM -0700, Andrii Nakryiko wrote:

SNIP

> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index db600ef218d7..0be2ee265931 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -641,6 +641,10 @@
> >                 __start_BTF = .;                                        \
> >                 *(.BTF)                                                 \
> >                 __stop_BTF = .;                                         \
> > +       }                                                               \
> > +       . = ALIGN(4);                                                   \
> > +       .BTF_ids : AT(ADDR(.BTF_ids) - LOAD_OFFSET) {                   \
> > +               *(.BTF_ids)                                             \
> >         }
> >  #else
> >  #define BTF
> > diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> > index 1131a921e1a6..21e4fc7c25ab 100644
> > --- a/kernel/bpf/Makefile
> > +++ b/kernel/bpf/Makefile
> > @@ -7,7 +7,7 @@ obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list
> >  obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
> >  obj-$(CONFIG_BPF_SYSCALL) += disasm.o
> >  obj-$(CONFIG_BPF_JIT) += trampoline.o
> > -obj-$(CONFIG_BPF_SYSCALL) += btf.o
> > +obj-$(CONFIG_BPF_SYSCALL) += btf.o btf_ids.o
> >  obj-$(CONFIG_BPF_JIT) += dispatcher.o
> >  ifeq ($(CONFIG_NET),y)
> >  obj-$(CONFIG_BPF_SYSCALL) += devmap.o
> > diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
> > new file mode 100644
> > index 000000000000..e7f9d94ad293
> > --- /dev/null
> > +++ b/kernel/bpf/btf_ids.c
> > @@ -0,0 +1,3 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +
> > +#include "btf_ids.h"
> 
> hm... what's the purpose of this btf_ids.c file?

I put all the lists in here.. I can add it in that patch later on

jirka

> 
> > diff --git a/kernel/bpf/btf_ids.h b/kernel/bpf/btf_ids.h
> > new file mode 100644
> > index 000000000000..68aa5c38a37f
> > --- /dev/null
> > +++ b/kernel/bpf/btf_ids.h
> 
> [...]
> 

