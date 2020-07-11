Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B68121C60F
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 22:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGKUDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 16:03:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52202 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726628AbgGKUDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 16:03:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594497833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hfhNn2+Z06JFLTqf0fcnWHz09eTkp1dfSJoM5LOrl+w=;
        b=gUvPEVsSXLFqSU54IFvWU6BDiJemjkYSmO7iesW/AB4hWjjBv4+RhiiaF+qXTMZm/GVnk5
        /hxxTgCuFDj+ZjApx0yBOsQLdO4TKITN4YLuZPaKyHye3wvr3hePM+CtKB7qSv7McgQl7K
        7VHEZYQTZC3mXpZrXp/KFe5sg/Xi/lU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-FUFWQOi7O8itz_7gSsXHpg-1; Sat, 11 Jul 2020 16:03:51 -0400
X-MC-Unique: FUFWQOi7O8itz_7gSsXHpg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66C33800C64;
        Sat, 11 Jul 2020 20:03:49 +0000 (UTC)
Received: from krava (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5C7E8724C5;
        Sat, 11 Jul 2020 20:03:47 +0000 (UTC)
Date:   Sat, 11 Jul 2020 22:03:46 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v6 bpf-next 0/9] bpf: Add d_path helper - preparation
 changes
Message-ID: <20200711200346.GA5823@krava>
References: <20200710193754.3821104-1-jolsa@kernel.org>
 <CAEf4BzbejJeaG-kffJf-tM_a7kMDET7n3Nu4dJB+jKRicc90Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbejJeaG-kffJf-tM_a7kMDET7n3Nu4dJB+jKRicc90Qw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 01:46:02PM -0700, Andrii Nakryiko wrote:
> On Fri, Jul 10, 2020 at 12:38 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > this patchset does preparation work for adding d_path helper,
> > which still needs more work, but the initial set of patches
> > is ready and useful to have.
> >
> > This patchset adds:
> >   - support to generate BTF ID lists that are resolved during
> >     kernel linking and usable within kernel code with following
> >     macros:
> >
> >       BTF_ID_LIST(bpf_skb_output_btf_ids)
> >       BTF_ID(struct, sk_buff)
> >
> >     and access it in kernel code via:
> >       extern u32 bpf_skb_output_btf_ids[];
> >
> >   - resolve_btfids tool that scans elf object for .BTF_ids
> >     section and resolves its symbols with BTF ID values
> >   - resolving of bpf_ctx_convert struct and several other
> >     objects with BTF_ID_LIST
> >
> > v6 changes:
> >   - added acks
> >   - added general make rule to resolve_btfids Build [Andrii]
> >   - renamed .BTF.ids to .BTF_ids [Andrii]
> >   - added --no-fail option to resolve_btfids [Andrii]
> >   - changed resolve_btfids test to work over BTF from object
> >     file, so we don't depend on vmlinux BTF [Andrii]
> >   - fixed few typos [Andrii]
> >   - fixed the out of tree build [Andrii]
> >
> > Also available at:
> >   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   bpf/d_path
> >
> > thanks,
> > jirka
> >
> >
> > ---
> 
> You've missed fixing bpf_get_task_stack_proto with your
> BTF_IDS_LIST/BTF_ID macro. It's currently failing in subtests. With
> BTF_IDS_LIST/BTF_ID trivial fix it works again. Please fix that before
> this can be applied.

ugh.. moving fast ;-) some of the selftests are failing for me
on regular basis, I overlooked this one, sry

> 
> btf_data.c could also use some name-conflicting entries, just to make
> sure that kind (struct vs typedef) is taken into account. Maybe just
> add some dummy `typedef int S;` or something?

sure.. and I had to change resolve_btfids a bit because of that,
so I'll not add your ack to first patch yet

I'll send the new version shortly

thanks,
jirka

> 
> So with the above, please add for the next revision:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Tested-by: Andrii Nakryiko <andriin@fb.com>
> 
> > Jiri Olsa (9):
> >       bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object
> >       bpf: Compile resolve_btfids tool at kernel compilation start
> >       bpf: Add BTF_ID_LIST/BTF_ID/BTF_ID_UNUSED macros
> >       bpf: Resolve BTF IDs in vmlinux image
> >       bpf: Remove btf_id helpers resolving
> >       bpf: Use BTF_ID to resolve bpf_ctx_convert struct
> >       bpf: Add info about .BTF_ids section to btf.rst
> >       tools headers: Adopt verbatim copy of btf_ids.h from kernel sources
> >       selftests/bpf: Add test for resolve_btfids
> >
> >  Documentation/bpf/btf.rst                               |  36 +++++
> >  Makefile                                                |  25 +++-
> >  include/asm-generic/vmlinux.lds.h                       |   4 +
> >  include/linux/btf_ids.h                                 |  87 ++++++++++++
> >  kernel/bpf/btf.c                                        | 103 ++------------
> >  kernel/trace/bpf_trace.c                                |   9 +-
> >  net/core/filter.c                                       |   9 +-
> >  scripts/link-vmlinux.sh                                 |   6 +
> >  tools/Makefile                                          |   3 +
> >  tools/bpf/Makefile                                      |   9 +-
> >  tools/bpf/resolve_btfids/Build                          |  10 ++
> >  tools/bpf/resolve_btfids/Makefile                       |  77 +++++++++++
> >  tools/bpf/resolve_btfids/main.c                         | 721 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tools/include/linux/btf_ids.h                           |  87 ++++++++++++
> >  tools/include/linux/compiler.h                          |   4 +
> >  tools/testing/selftests/bpf/Makefile                    |  14 +-
> >  tools/testing/selftests/bpf/prog_tests/resolve_btfids.c | 107 ++++++++++++++
> >  tools/testing/selftests/bpf/progs/btf_data.c            |  26 ++++
> >  18 files changed, 1234 insertions(+), 103 deletions(-)
> >  create mode 100644 include/linux/btf_ids.h
> >  create mode 100644 tools/bpf/resolve_btfids/Build
> >  create mode 100644 tools/bpf/resolve_btfids/Makefile
> >  create mode 100644 tools/bpf/resolve_btfids/main.c
> >  create mode 100644 tools/include/linux/btf_ids.h
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/btf_data.c
> >
> 

