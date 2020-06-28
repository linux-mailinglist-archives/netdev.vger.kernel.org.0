Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760C220C9EC
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgF1Tmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:42:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26007 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726733AbgF1Tmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:42:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593373371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qn8LpID6vlMXVlee8uuBX1nH9942F9auzaGbi0XYOzY=;
        b=aiOkAVVrlRk0SPuJ9pBUE3w3FsTNxYex0pKcadpd1ENhGzkFMd0/HsLJVVjb86pK5VIqD4
        8JroXtkQFgn9hNs4zjmENxigwNi6muQ76eqUlxkI7jwWHrkk1ieO3PVGYiMeADpTmsG30m
        201liGxipqBPnbjph+jgCj8idPkvDaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-DRjyZkxOPie65meza3Aj7g-1; Sun, 28 Jun 2020 15:42:48 -0400
X-MC-Unique: DRjyZkxOPie65meza3Aj7g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A75E5107ACCA;
        Sun, 28 Jun 2020 19:42:46 +0000 (UTC)
Received: from krava (unknown [10.40.192.56])
        by smtp.corp.redhat.com (Postfix) with SMTP id 28EF85C1B2;
        Sun, 28 Jun 2020 19:42:42 +0000 (UTC)
Date:   Sun, 28 Jun 2020 21:42:42 +0200
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
Subject: Re: [PATCH v4 bpf-next 10/14] bpf: Add d_path helper
Message-ID: <20200628194242.GB2988321@krava>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-11-jolsa@kernel.org>
 <CAEf4BzY4EqkbB7Ob9EZAJrWdBRtH_k3sL=4JZzAiqkMXjYjNKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY4EqkbB7Ob9EZAJrWdBRtH_k3sL=4JZzAiqkMXjYjNKA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 01:38:27PM -0700, Andrii Nakryiko wrote:
> On Thu, Jun 25, 2020 at 4:49 PM Jiri Olsa <jolsa@kernel.org> wrote:
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
> >  include/uapi/linux/bpf.h       | 14 +++++++++-
> >  kernel/trace/bpf_trace.c       | 47 ++++++++++++++++++++++++++++++++++
> >  scripts/bpf_helpers_doc.py     |  2 ++
> >  tools/include/uapi/linux/bpf.h | 14 +++++++++-
> >  4 files changed, 75 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 0cb8ec948816..23274c81f244 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3285,6 +3285,17 @@ union bpf_attr {
> >   *             Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
> >   *     Return
> >   *             *sk* if casting is valid, or NULL otherwise.
> > + *
> > + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> > + *     Description
> > + *             Return full path for given 'struct path' object, which
> > + *             needs to be the kernel BTF 'path' object. The path is
> > + *             returned in buffer provided 'buf' of size 'sz'.
> > + *
> > + *     Return
> > + *             length of returned string on success, or a negative
> > + *             error in case of failure
> 
> It's important to note whether string is always zero-terminated (I'm
> guessing it is, right?).

right, will add

> 
> > + *
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -3427,7 +3438,8 @@ union bpf_attr {
> >         FN(skc_to_tcp_sock),            \
> >         FN(skc_to_tcp_timewait_sock),   \
> >         FN(skc_to_tcp_request_sock),    \
> > -       FN(skc_to_udp6_sock),
> > +       FN(skc_to_udp6_sock),           \
> > +       FN(d_path),
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >   * function eBPF program intends to call
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index b124d468688c..6f31e21565b6 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1060,6 +1060,51 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
> >         .arg1_type      = ARG_ANYTHING,
> >  };
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
> 
> if len above is zero, you won't zero-terminate it, so probably better
> to move buf[len] = 0 out of if to do unconditionally

good catch, will change

> 
> > +               }
> > +       }
> > +
> > +       return len;
> > +}
> > +
> > +BTF_SET_START(btf_whitelist_d_path)
> > +BTF_ID(func, vfs_truncate)
> > +BTF_ID(func, vfs_fallocate)
> > +BTF_ID(func, dentry_open)
> > +BTF_ID(func, vfs_getattr)
> > +BTF_ID(func, filp_close)
> > +BTF_SET_END(btf_whitelist_d_path)
> > +
> > +static bool bpf_d_path_allowed(const struct bpf_prog *prog)
> > +{
> > +       return btf_id_set_contains(&btf_whitelist_d_path, prog->aux->attach_btf_id);
> > +}
> > +
> 
> This looks pretty great and clean, considering what's happening under
> the covers. Nice work, thanks a lot!
> 
> > +BTF_ID_LIST(bpf_d_path_btf_ids)
> > +BTF_ID(struct, path)
> 
> this is a bit more confusing to read and error-prone, but I couldn't
> come up with any better way to do this... Still better than
> alternatives.
> 
> > +
> > +static const struct bpf_func_proto bpf_d_path_proto = {
> > +       .func           = bpf_d_path,
> > +       .gpl_only       = true,
> 
> Does it have to be GPL-only? What's the criteria? Sorry if this was
> brought up previously.

I don't think it's needed to be gpl_only, I'll set it to false

thanks,
jirka

