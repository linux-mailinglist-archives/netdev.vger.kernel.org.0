Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC1623CF48
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgHETSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:18:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56817 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729091AbgHER7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:59:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596650340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ESShx0Xg3JcVgsVOiqAqDzi1HFrTrI8aPD9Dv5alf9s=;
        b=Ocjdj/QDYpT+lyj24zcFR2a2zBJGzlDqgnwAeeeT8YJ8mHrGocumUPOD4Xefzq7+WQyreE
        NfOJtBuER4fiBefsxpEgQRR9BzUrDMM3XU/W3t7TgYWAPJa6a4s5cjyK0EAva/0J+l1bdY
        Kdw8bb6i5RDZhQBq1irAcwpYAQtqwW4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-KZrzfVvcO3OJ_vGv55Nw1A-1; Wed, 05 Aug 2020 13:58:56 -0400
X-MC-Unique: KZrzfVvcO3OJ_vGv55Nw1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B509102CC43;
        Wed,  5 Aug 2020 17:58:54 +0000 (UTC)
Received: from krava (unknown [10.40.192.11])
        by smtp.corp.redhat.com (Postfix) with SMTP id E0B8E19C71;
        Wed,  5 Aug 2020 17:58:50 +0000 (UTC)
Date:   Wed, 5 Aug 2020 19:58:50 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 bpf-next 10/14] bpf: Add d_path helper
Message-ID: <20200805175850.GD319954@krava>
References: <20200801170322.75218-1-jolsa@kernel.org>
 <20200801170322.75218-11-jolsa@kernel.org>
 <CAEf4BzY5b8GhoovkKZgT4YSUUW=GPZBU0Qjg4eqeHNjoPHCMTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY5b8GhoovkKZgT4YSUUW=GPZBU0Qjg4eqeHNjoPHCMTw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 11:35:53PM -0700, Andrii Nakryiko wrote:
> On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding d_path helper function that returns full path for
> > given 'struct path' object, which needs to be the kernel
> > BTF 'path' object. The path is returned in buffer provided
> > 'buf' of size 'sz' and is zero terminated.
> >
> >   bpf_d_path(&file->f_path, buf, size);
> >
> > The helper calls directly d_path function, so there's only
> > limited set of function it can be called from. Adding just
> > very modest set for the start.
> >
> > Updating also bpf.h tools uapi header and adding 'path' to
> > bpf_helpers_doc.py script.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/uapi/linux/bpf.h       | 13 +++++++++
> >  kernel/trace/bpf_trace.c       | 48 ++++++++++++++++++++++++++++++++++
> >  scripts/bpf_helpers_doc.py     |  2 ++
> >  tools/include/uapi/linux/bpf.h | 13 +++++++++
> >  4 files changed, 76 insertions(+)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index eb5e0c38eb2c..a356ea1357bf 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3389,6 +3389,18 @@ union bpf_attr {
> >   *             A non-negative value equal to or less than *size* on success,
> >   *             or a negative error in case of failure.
> >   *
> > + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> 
> nit: probably would be good to do `const struct path *` here, even if
> we don't do const-ification properly in all helpers.

ok

> 
> > + *     Description
> > + *             Return full path for given 'struct path' object, which
> > + *             needs to be the kernel BTF 'path' object. The path is
> > + *             returned in buffer provided 'buf' of size 'sz' and
> 
> typo: in the provided buffer 'buf' of size ... ?

ugh, sure

> 
> > + *             is zero terminated.
> > + *
> > + *     Return
> > + *             On success, the strictly positive length of the string,
> > + *             including the trailing NUL character. On error, a negative
> > + *             value.
> > + *
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -3533,6 +3545,7 @@ union bpf_attr {
> >         FN(skc_to_tcp_request_sock),    \
> >         FN(skc_to_udp6_sock),           \
> >         FN(get_task_stack),             \
> > +       FN(d_path),                     \
> >         /* */
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index cb91ef902cc4..02a76e246545 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1098,6 +1098,52 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
> >         .arg1_type      = ARG_ANYTHING,
> >  };
> >
> > +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> > +{
> > +       int len;
> > +       char *p;
> > +
> > +       if (!sz)
> > +               return -ENAMETOOLONG;
> 
> if we are modeling this after bpf_probe_read_str(), sz == 0 returns
> success and just does nothing. I don't think anyone will ever handle
> or expect this error. I'd just return 0.

ook

thanks,
jirka

