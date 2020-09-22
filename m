Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266B727485A
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgIVSjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:39:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50038 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgIVSjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600799979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ybdXG74ST/H7YVIH/fOBujbQfC+uJlYyh/yfVB4O5s=;
        b=QM6qkLjfQTmETPspwrczL/AGkBrUFoVdL4ATiZkHNNdFhqMBIodcVtMhYWcnFNX8bnXiU7
        h0ePFheZB8WHxwYY1OhY3VV7a6nGH90NvJ8FOH/nv/CA0PWC2PkO1RNZ/8U5PpquEiTOl7
        +8g2ggTlKBGeF9gd0zTZJib1BnJHQ0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-ICIgBxxAOpGyDiDX5ZiiWA-1; Tue, 22 Sep 2020 14:39:37 -0400
X-MC-Unique: ICIgBxxAOpGyDiDX5ZiiWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E73B1882FA7;
        Tue, 22 Sep 2020 18:39:35 +0000 (UTC)
Received: from krava (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with SMTP id DA23178828;
        Tue, 22 Sep 2020 18:39:32 +0000 (UTC)
Date:   Tue, 22 Sep 2020 20:39:32 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv2 bpf-next] selftests/bpf: Fix stat probe in d_path test
Message-ID: <20200922183932.GC2718767@krava>
References: <20200918112338.2618444-1-jolsa@kernel.org>
 <CAADnVQ+OmqycbKTewWPA9D5upP9Ri-yvS1=GKRN1nQs6AL_YVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+OmqycbKTewWPA9D5upP9Ri-yvS1=GKRN1nQs6AL_YVw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 04:32:13PM -0700, Alexei Starovoitov wrote:
> On Fri, Sep 18, 2020 at 4:23 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Some kernels builds might inline vfs_getattr call within fstat
> > syscall code path, so fentry/vfs_getattr trampoline is not called.
> >
> > Alexei suggested [1] we should use security_inode_getattr instead,
> > because it's less likely to get inlined. Using this idea also for
> > vfs_truncate (replaced with security_path_truncate) and vfs_fallocate
> > (replaced with security_file_permission).
> >
> > Keeping dentry_open and filp_close, because they are in their own
> > files, so unlikely to be inlined, but in case they are, adding
> > security_file_open.
> >
> > Switching the d_path test stat trampoline to security_inode_getattr.
> >
> > Adding flags that indicate trampolines were called and failing
> > the test if any of them got missed, so it's easier to identify
> > the issue next time.
> >
> > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > [1] https://lore.kernel.org/bpf/CAADnVQJ0FchoPqNWm+dEppyij-MOvvEG_trEfyrHdabtcEuZGg@mail.gmail.com/
> > Fixes: e4d1af4b16f8 ("selftests/bpf: Add test for d_path helper")
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> > v2 changes:
> >   - replaced vfs_* function with security_* in d_path allow list
> >     vfs_truncate  -> security_path_truncate
> >     vfs_fallocate -> security_file_permission
> >     vfs_getattr   -> security_inode_getattr
> >   - added security_file_open to d_path allow list
> >   - split verbose output for trampoline flags
> >
> >  kernel/trace/bpf_trace.c                        |  7 ++++---
> >  tools/testing/selftests/bpf/prog_tests/d_path.c | 10 ++++++++++
> >  tools/testing/selftests/bpf/progs/test_d_path.c |  9 ++++++++-
> >  3 files changed, 22 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index b2a5380eb187..e24323d72cac 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1118,10 +1118,11 @@ BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> >  }
> >
> >  BTF_SET_START(btf_allowlist_d_path)
> > -BTF_ID(func, vfs_truncate)
> > -BTF_ID(func, vfs_fallocate)
> > +BTF_ID(func, security_path_truncate)
> > +BTF_ID(func, security_file_permission)
> > +BTF_ID(func, security_inode_getattr)
> > +BTF_ID(func, security_file_open)
> >  BTF_ID(func, dentry_open)
> > -BTF_ID(func, vfs_getattr)
> >  BTF_ID(func, filp_close)
> >  BTF_SET_END(btf_allowlist_d_path)
> 
> bpf CI system flagged the build error:
> FAILED unresolved symbol security_path_truncate
> because CONFIG_SECURITY_PATH wasn't set.
> Which points to the issue with this patch that the above
> security_* funcs have to be guarded with appropriate #ifdef.

ugh, sry

> I don't have a use case for tracing vfs_truncate, but
> security_path_unlink I would want to do in the future.
> Unfortunately it's under the same SECURITY_PATH ifdef.
> So my earlier desire to make it fool proof is not feasible at this point.
> Adding 'was_probed_func_inlined' check to libbpftrace.a would
> solve it eventually.
> For now I think we have to live with this function probing fragility.
> So I've modified the patch to add these few security_* funcs
> and kept vfs_* equivalents.
> Also reworded commit log and applied to bpf-next. Thanks
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=a8a717963fe5ecfd274eb93dd1285ee9428ffca7
> 

ok, looks good, thanks,
jirka

