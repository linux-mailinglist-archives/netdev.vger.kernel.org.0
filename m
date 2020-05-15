Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3216B1D52BC
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 16:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgEOO7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 10:59:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53229 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726236AbgEOO7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 10:59:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589554759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xcab0cmvJdvPEWHUxyhfWdxbwZt/8hc2SOf8Qa9hlEE=;
        b=EjlOouVettFY022TR/g5VH6FCNik+7RpgBxxMOO9XooR/sQanfP5EStJ5XVfPjsGkErEKR
        8BuMqHEcP300xLhSrNZyBEq0j3pfws0yPAN8EuXZwzqtsjlmHyHCDtSgPbkuT3zzvW5NYN
        6/o9GHw6hC+cqi0tNeKrC6qQ1K8DTXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-bsulARIrNtKRGXVSVna1Dw-1; Fri, 15 May 2020 10:59:14 -0400
X-MC-Unique: bsulARIrNtKRGXVSVna1Dw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A90A53;
        Fri, 15 May 2020 14:59:12 +0000 (UTC)
Received: from krava (unknown [10.40.194.127])
        by smtp.corp.redhat.com (Postfix) with SMTP id C5A655D9D7;
        Fri, 15 May 2020 14:59:08 +0000 (UTC)
Date:   Fri, 15 May 2020 16:59:07 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/9] bpf: Add d_path helper
Message-ID: <20200515145907.GE3565839@krava>
References: <20200506132946.2164578-1-jolsa@kernel.org>
 <20200506132946.2164578-2-jolsa@kernel.org>
 <CAEf4BzaiTFasYEnj-N100=mxQN5R70xKbF4Z2xJcWHaaYN4_ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaiTFasYEnj-N100=mxQN5R70xKbF4Z2xJcWHaaYN4_ag@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 03:06:01PM -0700, Andrii Nakryiko wrote:
> On Wed, May 6, 2020 at 6:30 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding d_path helper function that returns full path
> > for give 'struct path' object, which needs to be the
> > kernel BTF 'path' object.
> >
> > The helper calls directly d_path function.
> >
> > Updating also bpf.h tools uapi header and adding
> > 'path' to bpf_helpers_doc.py script.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/uapi/linux/bpf.h       | 14 +++++++++++++-
> >  kernel/trace/bpf_trace.c       | 31 +++++++++++++++++++++++++++++++
> >  scripts/bpf_helpers_doc.py     |  2 ++
> >  tools/include/uapi/linux/bpf.h | 14 +++++++++++++-
> >  4 files changed, 59 insertions(+), 2 deletions(-)
> >
> 
> [...]
> 
> >
> > +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> > +{
> > +       char *p = d_path(path, buf, sz - 1);
> > +       int len;
> > +
> > +       if (IS_ERR(p)) {
> > +               len = PTR_ERR(p);
> > +       } else {
> > +               len = strlen(p);
> > +               if (len && p != buf) {
> > +                       memmove(buf, p, len);
> > +                       buf[len] = 0;
> > +               }
> > +       }
> > +
> > +       return len;
> > +}
> > +
> > +static u32 bpf_d_path_btf_ids[3];
> 
> Using shorter than 5 element array is "unconventional", but seems like
> btf_distill_func_proto will never access elements that are not
> ARG_PTR_TO_BTF_ID, so it's fine. But than again, if we are saving
> space, why not just 1-element array? :)

right, that can be actualy just 1 element array ;-)

> 
> 
> > +static const struct bpf_func_proto bpf_d_path_proto = {
> > +       .func           = bpf_d_path,
> > +       .gpl_only       = true,
> > +       .ret_type       = RET_INTEGER,
> > +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> > +       .arg2_type      = ARG_PTR_TO_MEM,
> > +       .arg3_type      = ARG_CONST_SIZE,
> > +       .btf_id         = bpf_d_path_btf_ids,
> > +};
> > +
> 
> [...]
> 
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index b3643e27e264..bc13cad27872 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -3068,6 +3068,17 @@ union bpf_attr {
> >   *             See: clock_gettime(CLOCK_BOOTTIME)
> >   *     Return
> >   *             Current *ktime*.
> > + *
> > + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> > + *     Description
> > + *             Return full path for given 'struct path' object, which
> > + *             needs to be the kernel BTF 'path' object. The path is
> > + *             returned in buffer provided 'buf' of size 'sz'.
> > + *
> 
> Please specify if it's always zero-terminated string (especially on truncation).

ok, will mention the zero termination in here

thanks,
jirka

