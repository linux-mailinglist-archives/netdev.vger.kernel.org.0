Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FE82321FF
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 17:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgG2Pye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 11:54:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24244 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726341AbgG2Pyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 11:54:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596038071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/J6JS+fMs+vZIrHI2Gt0ra9KaEpOAIgrYgpi5yu3vNU=;
        b=FgEZlfu3lC1/T07TFpqx5Z7rtxD70MzUNETx/IVG1+5gLkxQ3K1VHeKgnNTeFLBgLa4AEe
        7YfC9SAdONNFV532U2bj4ZPlYw+flTwFSeydjfFf/f9IwRkyc6RL8OUyTINw19Pr+clH4A
        CiUx/fZU7QJQGJFKz1fd75ehKrT6nyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-zuNP3vcPPk-q__0svAmtQg-1; Wed, 29 Jul 2020 11:54:27 -0400
X-MC-Unique: zuNP3vcPPk-q__0svAmtQg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 502221009447;
        Wed, 29 Jul 2020 15:54:25 +0000 (UTC)
Received: from krava (unknown [10.40.193.247])
        by smtp.corp.redhat.com (Postfix) with SMTP id EC53171929;
        Wed, 29 Jul 2020 15:54:18 +0000 (UTC)
Date:   Wed, 29 Jul 2020 17:54:18 +0200
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
Subject: Re: [PATCH v8 bpf-next 09/13] bpf: Add d_path helper
Message-ID: <20200729155418.GK1319041@krava>
References: <20200722211223.1055107-1-jolsa@kernel.org>
 <20200722211223.1055107-10-jolsa@kernel.org>
 <CAEf4BzZ48nhqGhij9qe7Hc_JD6RpZoh-4NnVvqR=V1YN4ff2sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ48nhqGhij9qe7Hc_JD6RpZoh-4NnVvqR=V1YN4ff2sA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 12:47:03PM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 22, 2020 at 2:14 PM Jiri Olsa <jolsa@kernel.org> wrote:
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
> > +               if (len && p != buf)
> > +                       memmove(buf, p, len);
> 
> not sure if it's worth it, but if len == sz - 1 then memmove is not
> necessary. Again, don't know if worth it, as it's probably not going
> to be a common case.

I did not see condition like that for d_path/file_path usage,
I'll check if such return values are even possible

> 
> > +               buf[len] = 0;
> > +               /* Include the trailing NUL. */
> > +               len++;
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
> 
> 
> We should probably comply with an updated coding style ([0]) and use
> an allowlist name for this?
> 
>   [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=49decddd39e5f6132ccd7d9fdc3d7c470b0061bb

right, will change

> 
> > +
> > +static bool bpf_d_path_allowed(const struct bpf_prog *prog)
> > +{
> > +       return btf_id_set_contains(&btf_whitelist_d_path, prog->aux->attach_btf_id);
> > +}
> > +
> > +BTF_ID_LIST(bpf_d_path_btf_ids)
> > +BTF_ID(struct, path)
> > +
> > +static const struct bpf_func_proto bpf_d_path_proto = {
> > +       .func           = bpf_d_path,
> > +       .gpl_only       = false,
> > +       .ret_type       = RET_INTEGER,
> > +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> > +       .arg2_type      = ARG_PTR_TO_MEM,
> > +       .arg3_type      = ARG_CONST_SIZE,
> 
> I feel like we had a discussion about ARG_CONST_SIZE vs
> ARG_CONST_SIZE_OR_ZERO before, maybe on some different thread.
> Basically, this >0 restriction was a major nuisance for
> bpf_perf_event_output() cases, so much that we changed it to _OR_ZERO.
> In practice, while it might never be the case that we have sz == 0
> passed into the function, having to prove this to the verifier is a
> PITA. Unless there is a very strong reason not to, let's mark this as
> ARG_CONST_SIZE_OR_ZERO and handle sz == 0 case as a noop?

sure, will change

thanks,
jirka

