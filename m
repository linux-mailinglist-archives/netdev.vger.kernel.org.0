Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E5632C4AC
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450263AbhCDAQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:16:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1449532AbhCCWwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 17:52:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614811822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I+ZGM20Ww175B2i0Qx4AwkjsbVbJ+G3IdGtLxfVijYs=;
        b=gZyhESmQaGBk83HqGDtsPiQVkdLUYfm9KuGvrCv8BqmMe0wjC77nh2ZL8+PdjQDhqgFjrH
        4Lc4UyxzOKaQ3hKcA/uF1OlS7aH8NqHwfxRDW3iTJG2A5b6+SLCltz2lDrBBjyLVQY7uyZ
        2XAaYcVi7D10EQGEeEVp2Z/83eYNPig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-4KA0ZT6oNeGHCVhnnpNx8A-1; Wed, 03 Mar 2021 17:50:18 -0500
X-MC-Unique: 4KA0ZT6oNeGHCVhnnpNx8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FB97107ACE3;
        Wed,  3 Mar 2021 22:50:16 +0000 (UTC)
Received: from krava (unknown [10.40.196.53])
        by smtp.corp.redhat.com (Postfix) with SMTP id 127FF60BE2;
        Wed,  3 Mar 2021 22:49:59 +0000 (UTC)
Date:   Wed, 3 Mar 2021 23:49:59 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for
 powerpc uprobes
Message-ID: <YEASl9Z3Tl4X0B5L@krava>
References: <20210301190416.90694-1-jolsa@kernel.org>
 <309d8d05-4bbd-56b8-6c05-12a1aa98b843@fb.com>
 <YD4U1x2SbTlJF2QU@krava>
 <20210303064043.GB1913@DESKTOP-TDPLP67.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303064043.GB1913@DESKTOP-TDPLP67.localdomain>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 03, 2021 at 12:10:43PM +0530, Naveen N. Rao wrote:
> On 2021/03/02 11:35AM, Jiri Olsa wrote:
> > On Mon, Mar 01, 2021 at 02:58:53PM -0800, Yonghong Song wrote:
> > > 
> > > 
> > > On 3/1/21 11:04 AM, Jiri Olsa wrote:
> > > > When testing uprobes we the test gets GEP (Global Entry Point)
> > > > address from kallsyms, but then the function is called locally
> > > > so the uprobe is not triggered.
> > > > 
> > > > Fixing this by adjusting the address to LEP (Local Entry Point)
> > > > for powerpc arch.
> > > > 
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >   .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
> > > >   1 file changed, 17 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > > index a0ee87c8e1ea..c3cfb48d3ed0 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > > @@ -2,6 +2,22 @@
> > > >   #include <test_progs.h>
> > > >   #include "test_attach_probe.skel.h"
> > > > +#if defined(__powerpc64__)
> 
> This needs to be specific to ELF v2 ABI, so you'll need to check 
> _CALL_ELF. See commit d5c2e2c17ae1d6 ("perf probe ppc64le: Prefer symbol 
> table lookup over DWARF") for an example.

i see, there's the outer #if _CALL_ELF I missed

> 
> > > > +/*
> > > > + * We get the GEP (Global Entry Point) address from kallsyms,
> > > > + * but then the function is called locally, so we need to adjust
> > > > + * the address to get LEP (Local Entry Point).
> > > 
> > > Any documentation in the kernel about this behavior? This will
> > > help to validate the change without trying with powerpc64 qemu...
> 
> I don't think we have documented this in the kernel anywhere, but this 
> is specific to the ELF v2 ABI and is described there:
> - 2.3.2.1.  Function Prologue: 
>   http://cdn.openpowerfoundation.org/wp-content/uploads/resources/leabi/content/dbdoclet.50655240___RefHeading___Toc377640597.html
> - 3.4.1.  Symbol Values:
>    http://cdn.openpowerfoundation.org/wp-content/uploads/resources/leabi/content/dbdoclet.50655241_95185.html
> 
> > 
> > we got similar fix in perf:
> > 
> > 7b6ff0bdbf4f perf probe ppc64le: Fixup function entry if using kallsyms lookup
> > 
> > CC-ing few other folks from ppc land for more info
> 
> Thanks.
> 
> > > 
> > > > + */
> > > > +#define LEP_OFFSET 8
> > > > +
> > > > +static ssize_t get_offset(ssize_t offset)
> > > > +{
> > > > +	return offset + LEP_OFFSET;
> > > > +}
> > > > +#else
> > > > +#define get_offset(offset) (offset)
> > > > +#endif
> > > > +
> > > >   ssize_t get_base_addr() {
> > > >   	size_t start, offset;
> > > >   	char buf[256];
> > > > @@ -36,7 +52,7 @@ void test_attach_probe(void)
> > > >   	if (CHECK(base_addr < 0, "get_base_addr",
> > > >   		  "failed to find base addr: %zd", base_addr))
> > > >   		return;
> > > > -	uprobe_offset = (size_t)&get_base_addr - base_addr;
> > > > +	uprobe_offset = get_offset((size_t)&get_base_addr - base_addr);
> > > >   	skel = test_attach_probe__open_and_load();
> > > >   	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> > > > 
> 
> As documented in the links above, the right way to identify local entry 
> point (LEP) is by looking at the symbol table. Falling back to using a 
> hardcoded offset of 8 is a reasonable workaround if we don't have access 
> to the symbol table.

thanks for the all the info, I'll send v2 with _CALL_ELF check

jirka

