Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D033934BC42
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 14:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhC1MEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 08:04:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhC1MDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 08:03:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616933027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=akFbGFrCz0YDjTwrx18zH9cQEdy+ux2yWLInd1vvevw=;
        b=RcO/CSXl/j5nRGO9vJaLsHIl0GuB2VGU3jZo+GI+CtLPMAShDKWzggnDRbAmMNKM9yyuJ/
        8rkbC1QWh+MbxcEzKk/IeVzbed4PBWuE3/q/0UZSYpES0Dr3NaaMT7JPdZ9tdtIpWvoG84
        KFSps39ombzoa4cG+y+CfNF0YreqB60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-f-iKKB0YPCub_VLgpfHhKA-1; Sun, 28 Mar 2021 08:03:43 -0400
X-MC-Unique: f-iKKB0YPCub_VLgpfHhKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FA011009455;
        Sun, 28 Mar 2021 12:03:41 +0000 (UTC)
Received: from krava (unknown [10.40.192.12])
        by smtp.corp.redhat.com (Postfix) with SMTP id B7ED15DDAD;
        Sun, 28 Mar 2021 12:03:39 +0000 (UTC)
Date:   Sun, 28 Mar 2021 14:03:38 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 07/12] libbpf: add BPF static linker BTF and
 BTF.ext support
Message-ID: <YGBwmlQTDUodxM0J@krava>
References: <20210318194036.3521577-1-andrii@kernel.org>
 <20210318194036.3521577-8-andrii@kernel.org>
 <YFTQExmhNhMcmNOb@krava>
 <CAEf4BzYKassG0AP372Q=Qsd+qqy7=YGe2XTXR4zG0c5oQ7Nkeg@mail.gmail.com>
 <YFT0Q+mVbTEI1rem@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFT0Q+mVbTEI1rem@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 07:58:13PM +0100, Jiri Olsa wrote:
> On Fri, Mar 19, 2021 at 11:39:01AM -0700, Andrii Nakryiko wrote:
> > On Fri, Mar 19, 2021 at 9:23 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Thu, Mar 18, 2021 at 12:40:31PM -0700, Andrii Nakryiko wrote:
> > >
> > > SNIP
> > >
> > > > +
> > > > +     return NULL;
> > > > +}
> > > > +
> > > > +static int linker_fixup_btf(struct src_obj *obj)
> > > > +{
> > > > +     const char *sec_name;
> > > > +     struct src_sec *sec;
> > > > +     int i, j, n, m;
> > > > +
> > > > +     n = btf__get_nr_types(obj->btf);
> > >
> > > hi,
> > > I'm getting bpftool crash when building tests,
> > >
> > > looks like above obj->btf can be NULL:
> > 
> > I lost if (!obj->btf) return 0; somewhere along the rebases. I'll send
> > a fix shortly. But how did you end up with selftests BPF objects built
> > without BTF?
> 
> no idea.. I haven't even updated llvm for almost 3 days now ;-)

sorry for late follow up on this, and it's actually forgotten empty
object in progs directory that was causing this

I wonder we should add empty object like below to catch these cases,
because there's another place that bpftool is crashing on with it

I can send full patch for that if you think it's worth having

jirka


---
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7aad78dbb4b4..aecb6ca52bce 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3165,6 +3165,9 @@ static int add_dummy_ksym_var(struct btf *btf)
 	const struct btf_var_secinfo *vs;
 	const struct btf_type *sec;
 
+	if (!btf)
+		return 0;
+
 	sec_btf_id = btf__find_by_name_kind(btf, KSYMS_SEC,
 					    BTF_KIND_DATASEC);
 	if (sec_btf_id < 0)
diff --git a/tools/testing/selftests/bpf/progs/empty.c b/tools/testing/selftests/bpf/progs/empty.c
new file mode 100644
index 000000000000..e69de29bb2d1

