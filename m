Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE1D32B373
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352536AbhCCDyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 22:54:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348416AbhCBKgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 05:36:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614681315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cJA8I2rtL7UIoMN2Rled0pFiD9pZesjrENP6iGNVxdQ=;
        b=NVv8ljJap8znXp+p5BAgUFHOKHrTnycaoGy0VTDNGYWm5EidjP9seKm9WpwnBFQ2H+ARUf
        GvGQApRdExfeHvATn3Hgw5NTpe5/cAJYTof7Jothybs2nk66j0V2T90HFcmFI3t9qcLr7h
        feTsG39KqxZH5ZfQCw6aqKJcw8lgpX4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-i-MGJPDsNXiiA17NAMbSFw-1; Tue, 02 Mar 2021 05:35:13 -0500
X-MC-Unique: i-MGJPDsNXiiA17NAMbSFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DA7F1E563;
        Tue,  2 Mar 2021 10:35:11 +0000 (UTC)
Received: from krava (unknown [10.40.195.211])
        by smtp.corp.redhat.com (Postfix) with SMTP id 443EC6F452;
        Tue,  2 Mar 2021 10:35:04 +0000 (UTC)
Date:   Tue, 2 Mar 2021 11:35:03 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for
 powerpc uprobes
Message-ID: <YD4U1x2SbTlJF2QU@krava>
References: <20210301190416.90694-1-jolsa@kernel.org>
 <309d8d05-4bbd-56b8-6c05-12a1aa98b843@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <309d8d05-4bbd-56b8-6c05-12a1aa98b843@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 02:58:53PM -0800, Yonghong Song wrote:
> 
> 
> On 3/1/21 11:04 AM, Jiri Olsa wrote:
> > When testing uprobes we the test gets GEP (Global Entry Point)
> > address from kallsyms, but then the function is called locally
> > so the uprobe is not triggered.
> > 
> > Fixing this by adjusting the address to LEP (Local Entry Point)
> > for powerpc arch.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
> >   1 file changed, 17 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > index a0ee87c8e1ea..c3cfb48d3ed0 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > @@ -2,6 +2,22 @@
> >   #include <test_progs.h>
> >   #include "test_attach_probe.skel.h"
> > +#if defined(__powerpc64__)
> > +/*
> > + * We get the GEP (Global Entry Point) address from kallsyms,
> > + * but then the function is called locally, so we need to adjust
> > + * the address to get LEP (Local Entry Point).
> 
> Any documentation in the kernel about this behavior? This will
> help to validate the change without trying with powerpc64 qemu...

we got similar fix in perf:

7b6ff0bdbf4f perf probe ppc64le: Fixup function entry if using kallsyms lookup

CC-ing few other folks from ppc land for more info

jirka

> 
> > + */
> > +#define LEP_OFFSET 8
> > +
> > +static ssize_t get_offset(ssize_t offset)
> > +{
> > +	return offset + LEP_OFFSET;
> > +}
> > +#else
> > +#define get_offset(offset) (offset)
> > +#endif
> > +
> >   ssize_t get_base_addr() {
> >   	size_t start, offset;
> >   	char buf[256];
> > @@ -36,7 +52,7 @@ void test_attach_probe(void)
> >   	if (CHECK(base_addr < 0, "get_base_addr",
> >   		  "failed to find base addr: %zd", base_addr))
> >   		return;
> > -	uprobe_offset = (size_t)&get_base_addr - base_addr;
> > +	uprobe_offset = get_offset((size_t)&get_base_addr - base_addr);
> >   	skel = test_attach_probe__open_and_load();
> >   	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> > 
> 

