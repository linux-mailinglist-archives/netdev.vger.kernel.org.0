Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C8A330045
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 12:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhCGLMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 06:12:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231651AbhCGLMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 06:12:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615115563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r9PFTq8BUDKVO428yQixr9bwpENpUHQxDq5isnXpbB8=;
        b=PU7kgdnO/1VGRcDUb+8JcrCt8XY9GT+UqNP1YNJVpX054iFe1VyRrgC3EdeCOXP5woT1a6
        wfl5ONwQxo/6wZUg6vFvPviu57lnW8LrZjF80PZPkOq7WhzSJcQLxmwQiBwV/us5lpH5oP
        jzhx2vlgT/9ud/K/lY5NlkdtQhdQRzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-i81ex38JNDyE8YSwE66DXw-1; Sun, 07 Mar 2021 06:12:41 -0500
X-MC-Unique: i81ex38JNDyE8YSwE66DXw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B95D81431C;
        Sun,  7 Mar 2021 11:12:39 +0000 (UTC)
Received: from krava (unknown [10.40.192.72])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8604C19D9B;
        Sun,  7 Mar 2021 11:12:32 +0000 (UTC)
Date:   Sun, 7 Mar 2021 12:12:31 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>
Subject: Re: [PATCHv2 bpf-next] selftests/bpf: Fix test_attach_probe for
 powerpc uprobes
Message-ID: <YES1HwAheriyuT6w@krava>
References: <20210305134050.139840-1-jolsa@kernel.org>
 <CAEf4BzanY2ogGDORCsOXrAivWii06vsUpJFT7rQy2nj0xarm+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzanY2ogGDORCsOXrAivWii06vsUpJFT7rQy2nj0xarm+A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 06, 2021 at 07:13:17PM -0800, Andrii Nakryiko wrote:
> On Fri, Mar 5, 2021 at 5:42 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > When testing uprobes we the test gets GEP (Global Entry Point)
> > address from kallsyms, but then the function is called locally
> > so the uprobe is not triggered.
> >
> > Fixing this by adjusting the address to LEP (Local Entry Point)
> > for powerpc arch plus instruction check stolen from ppc_function_entry
> > function pointed out and explained by Michael and Naveen.
> >
> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> > Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../selftests/bpf/prog_tests/attach_probe.c   | 40 ++++++++++++++++++-
> >  1 file changed, 39 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > index a0ee87c8e1ea..9dc4e3dfbcf3 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > @@ -2,6 +2,44 @@
> >  #include <test_progs.h>
> >  #include "test_attach_probe.skel.h"
> >
> > +#if defined(__powerpc64__) && defined(_CALL_ELF) && _CALL_ELF == 2
> > +
> > +#define OP_RT_RA_MASK   0xffff0000UL
> > +#define LIS_R2          0x3c400000UL
> > +#define ADDIS_R2_R12    0x3c4c0000UL
> > +#define ADDI_R2_R2      0x38420000UL
> > +
> > +static ssize_t get_offset(ssize_t addr, ssize_t base)
> > +{
> > +       u32 *insn = (u32 *) addr;
> > +
> > +       /*
> > +        * A PPC64 ABIv2 function may have a local and a global entry
> > +        * point. We need to use the local entry point when patching
> > +        * functions, so identify and step over the global entry point
> > +        * sequence.
> > +        *
> > +        * The global entry point sequence is always of the form:
> > +        *
> > +        * addis r2,r12,XXXX
> > +        * addi  r2,r2,XXXX
> > +        *
> > +        * A linker optimisation may convert the addis to lis:
> > +        *
> > +        * lis   r2,XXXX
> > +        * addi  r2,r2,XXXX
> > +        */
> > +       if ((((*insn & OP_RT_RA_MASK) == ADDIS_R2_R12) ||
> > +            ((*insn & OP_RT_RA_MASK) == LIS_R2)) &&
> > +           ((*(insn + 1) & OP_RT_RA_MASK) == ADDI_R2_R2))
> > +               return (ssize_t)(insn + 2) - base;
> > +       else
> > +               return addr - base;
> > +}
> > +#else
> > +#define get_offset(addr, base) (addr - base)
> 
> I turned this into a static function, not sure why you preferred

seemed simple enough to be dealt with in preprocessor,
why bother compiler ;-)

> #define here. Applied to bpf-next.

thanks,
jirka

