Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54E926616F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 16:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgIKOoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 10:44:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54572 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726193AbgIKNDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 09:03:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599829368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Oqtp+pU6EVX5K85gU9EYn6QWRvb00undsqSAgRZGvwg=;
        b=RTpDK0Th+/1iYevBS8TVp63NXYXnNBcc2fmuX1p9OcZ424O+72UegBbxIlHM3r8idOo/qk
        JmlUX0c6DJ/gtWwxEhf2QLzQRi7aKmNA+Nwf0PS/2M58Wt0dzUNK5itVIqwXjBcdsIvjS+
        EzBDM5hWP/qxgxRJMutSQDnjXrh2ttk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-kt3iaoLZOAWSvM6rs-mcOA-1; Fri, 11 Sep 2020 09:02:47 -0400
X-MC-Unique: kt3iaoLZOAWSvM6rs-mcOA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CC75802B46;
        Fri, 11 Sep 2020 13:02:45 +0000 (UTC)
Received: from krava (unknown [10.40.192.120])
        by smtp.corp.redhat.com (Postfix) with SMTP id 39C7B75129;
        Fri, 11 Sep 2020 13:02:34 +0000 (UTC)
Date:   Fri, 11 Sep 2020 15:02:32 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Adding test for arg
 dereference in extension trace
Message-ID: <20200911130232.GB1714160@krava>
References: <20200909151115.1559418-1-jolsa@kernel.org>
 <20200909151115.1559418-2-jolsa@kernel.org>
 <CAEf4BzbY3zV-xYDBvCYztXOkn=MJwHxOVyAH7YRH8JH869qtDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbY3zV-xYDBvCYztXOkn=MJwHxOVyAH7YRH8JH869qtDg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 03:34:26PM -0700, Andrii Nakryiko wrote:

SNIP

> > +
> > +void test_trace_ext(void)
> > +{
> > +       struct test_trace_ext_tracing *skel_trace = NULL;
> > +       struct test_trace_ext_tracing__bss *bss_trace;
> > +       const char *file = "./test_pkt_md_access.o";
> > +       struct test_trace_ext *skel_ext = NULL;
> > +       struct test_trace_ext__bss *bss_ext;
> > +       int err, prog_fd, ext_fd;
> > +       struct bpf_object *obj;
> > +       char buf[100];
> > +       __u32 retval;
> > +       __u64 len;
> > +
> > +       err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
> > +       if (CHECK_FAIL(err))
> > +               return;
> 
> We should avoid using bpf_prog_load() for new code. Can you please
> just skeleton instead? Or at least bpf_object__open_file()?

ok

> 
> > +
> > +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
> > +                           .attach_prog_fd = prog_fd,
> > +       );
> 
> DECLARE_LIBBPF_OPTS does declare a variable, so should be together
> with all the other variables above, otherwise some overly strict C89
> mode compiler will start complaining. You can assign
> `opts.attach_prog_fd = prog_fd;` outside of declaration. But I also
> don't think you need this one. Having .attach_prog_fd in open_opts is
> not great, because it's a per-program setting specified at bpf_object
> level. Would bpf_program__set_attach_target() work here?

right, I'll try it, it should be enough

SNIP

> > +
> > +cleanup:
> > +       test_trace_ext__destroy(skel_ext);
> > +       bpf_object__close(obj);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_trace_ext.c b/tools/testing/selftests/bpf/progs/test_trace_ext.c
> > new file mode 100644
> > index 000000000000..a6318f6b52ee
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_trace_ext.c
> > @@ -0,0 +1,18 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (c) 2019 Facebook
> > +#include <linux/bpf.h>
> > +#include <stdbool.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_endian.h>
> > +#include <bpf/bpf_tracing.h>
> > +
> > +volatile __u64 ext_called = 0;
> 
> nit: no need for volatile, global variables are not going anywhere;
> same below in two places

ok, thanks

jirka

