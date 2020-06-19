Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2022009A6
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732463AbgFSNNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:13:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40625 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732442AbgFSNNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:13:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592572397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=an7x1V2TFS3WGjFEC1lctVzmins8f4o7Bkx05YpijFY=;
        b=EOWLito3LR+t0FuxLcox9r71CRpXwDoZ1yRSmdYQc4Y2EXlENVQVKoP8hbuVsW506cxi7Z
        9ET1Xa4fDMvAEvxI57vvhkmvLmIxLklouC8Ey+M4nlqpQdsRxx8xXF1eGzahrVq+bKVoNa
        V72vnY/72pUygaRK314/8HNZpEw4qnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-qSorFMsvOkOiM7HpspC2og-1; Fri, 19 Jun 2020 09:13:13 -0400
X-MC-Unique: qSorFMsvOkOiM7HpspC2og-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E393C8015CB;
        Fri, 19 Jun 2020 13:13:10 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with SMTP id 90AC75D9E5;
        Fri, 19 Jun 2020 13:13:07 +0000 (UTC)
Date:   Fri, 19 Jun 2020 15:13:06 +0200
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
Message-ID: <20200619131306.GD2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-4-jolsa@kernel.org>
 <CAEf4BzZ=BN7zDU_8xMEEoF7khjC4bwGitU+iYf+6uFXPZ_=u-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ=BN7zDU_8xMEEoF7khjC4bwGitU+iYf+6uFXPZ_=u-g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 05:56:38PM -0700, Andrii Nakryiko wrote:
> On Tue, Jun 16, 2020 at 3:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding support to generate .BTF_ids section that would
> > hold various BTF IDs list for verifier.
> >
> > Adding macros help to define lists of BTF IDs placed in
> > .BTF_ids section. They are initially filled with zeros
> > (during compilation) and resolved later during the
> > linking phase by btfid tool.
> >
> > Following defines list of one BTF ID that is accessible
> > within kernel code as bpf_skb_output_btf_ids array.
> >
> >   extern int bpf_skb_output_btf_ids[];
> >
> >   BTF_ID_LIST(bpf_skb_output_btf_ids)
> >   BTF_ID(struct, sk_buff)
> >
> > Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/asm-generic/vmlinux.lds.h |  4 ++
> >  kernel/bpf/Makefile               |  2 +-
> >  kernel/bpf/btf_ids.c              |  3 ++
> >  kernel/bpf/btf_ids.h              | 70 +++++++++++++++++++++++++++++++
> >  4 files changed, 78 insertions(+), 1 deletion(-)
> >  create mode 100644 kernel/bpf/btf_ids.c
> >  create mode 100644 kernel/bpf/btf_ids.h
> >
> 
> [...]
> 
> > +/*
> > + * Following macros help to define lists of BTF IDs placed
> > + * in .BTF_ids section. They are initially filled with zeros
> > + * (during compilation) and resolved later during the
> > + * linking phase by btfid tool.
> > + *
> > + * Any change in list layout must be reflected in btfid
> > + * tool logic.
> > + */
> > +
> > +#define SECTION ".BTF_ids"
> 
> nit: SECTION is super generic and non-greppable. BTF_IDS_SECTION?

ok

> 
> > +
> > +#define ____BTF_ID(symbol)                             \
> > +asm(                                                   \
> > +".pushsection " SECTION ",\"a\";               \n"     \
> 
> section should be also read-only? Either immediately here, of btfid
> tool should mark it? Unless I missed that it's already doing it :)

hm, it's there next to the .BTF section within RO_DATA macro,
so I thought that was enough.. I'll double check

> 
> > +".local " #symbol " ;                          \n"     \
> > +".type  " #symbol ", @object;                  \n"     \
> > +".size  " #symbol ", 4;                        \n"     \
> > +#symbol ":                                     \n"     \
> > +".zero 4                                       \n"     \
> > +".popsection;                                  \n");
> > +
> > +#define __BTF_ID(...) \
> > +       ____BTF_ID(__VA_ARGS__)
> 
> why varargs, if it's always a single argument? Or it's one of those
> macro black magic things were it works only in this particular case,
> but not others?

yea, I kind of struggled in here, because any other would not
expand the name concat together with the unique ID bit,
__VA_ARGS__ did it nicely ;-) I'll revisit this

thanks,
jirka

