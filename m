Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6962C26D66C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgIQIZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:25:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbgIQIZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600331123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2jpmJsyvYQ4DNESpdxe5YOP83SDgROVVElDNNc7PZ38=;
        b=WKuK0/jnGinLp58mK/pcKt8BHd4O0VOUtEZY6UXsvfJ+CZv+IgI/4JP5RGQzP1P+xE2ghq
        t6tV6hU1eE0P2g0DgvLWwNxMxh5QBdNBhsk40+bnS79NhypVTcx+TMXMaGlZ/2iU9xXnaE
        URR+3SIVPZbsUENJvuw8X7gobNdBkS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-1SnLk_UgNWm82ESWpfCrgA-1; Thu, 17 Sep 2020 04:25:21 -0400
X-MC-Unique: 1SnLk_UgNWm82ESWpfCrgA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90D9680EF9D;
        Thu, 17 Sep 2020 08:25:19 +0000 (UTC)
Received: from krava (ovpn-114-176.ams2.redhat.com [10.36.114.176])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3956619D7C;
        Thu, 17 Sep 2020 08:25:17 +0000 (UTC)
Date:   Thu, 17 Sep 2020 10:25:16 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix stat probe in d_path test
Message-ID: <20200917082516.GD2411168@krava>
References: <20200916112416.2321204-1-jolsa@kernel.org>
 <20200917014531.lmpkorybofrggte4@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917014531.lmpkorybofrggte4@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 06:45:31PM -0700, Alexei Starovoitov wrote:
> On Wed, Sep 16, 2020 at 01:24:16PM +0200, Jiri Olsa wrote:
> > Some kernels builds might inline vfs_getattr call within fstat
> > syscall code path, so fentry/vfs_getattr trampoline is not called.
> > 
> > Alexei suggested [1] we should use security_inode_getattr instead,
> > because it's less likely to get inlined.
> > 
> > Adding security_inode_getattr to the d_path allowed list and
> > switching the stat trampoline to security_inode_getattr.
> > 
> > Adding flags that indicate trampolines were called and failing
> > the test if any of them got missed, so it's easier to identify
> > the issue next time.
> > 
> > [1] https://lore.kernel.org/bpf/CAADnVQJ0FchoPqNWm+dEppyij-MOvvEG_trEfyrHdabtcEuZGg@mail.gmail.com/
> > Fixes: e4d1af4b16f8 ("selftests/bpf: Add test for d_path helper")
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  kernel/trace/bpf_trace.c                        | 1 +
> >  tools/testing/selftests/bpf/prog_tests/d_path.c | 6 ++++++
> >  tools/testing/selftests/bpf/progs/test_d_path.c | 9 ++++++++-
> >  3 files changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index b2a5380eb187..1001c053ebb3 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1122,6 +1122,7 @@ BTF_ID(func, vfs_truncate)
> >  BTF_ID(func, vfs_fallocate)
> >  BTF_ID(func, dentry_open)
> >  BTF_ID(func, vfs_getattr)
> > +BTF_ID(func, security_inode_getattr)
> >  BTF_ID(func, filp_close)
> >  BTF_SET_END(btf_allowlist_d_path)
> 
> I think it's concealing the problem instead of fixing it.
> bpf is difficult to use for many reasons. Let's not make it harder.
> The users will have a very hard time debugging why vfs_getattr bpf probe
> is not called in all cases.
> Let's replace:
> vfs_truncate -> security_path_truncate
> vfs_fallocate -> security_file_permission
> vfs_getattr -> security_inode_getattr
> 
> For dentry_open also add security_file_open.
> dentry_open and filp_close are in its own files,
> so unlikely to be inlined.

ok

> Ideally resolve_btfids would parse dwarf info and check
> whether any of the funcs in allowlist were inlined.
> That would be more reliable, but not pretty to drag libdw
> dependency into resolve_btfids.

hm, we could add some check to perf|bpftrace that would 
show you all the places where function is called from and
if it was inlined or is a regular call.. so user is aware
what probe calls to expect

> 
> >  
> > diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
> > index fc12e0d445ff..f507f1a6fa3a 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/d_path.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
> > @@ -120,6 +120,12 @@ void test_d_path(void)
> >  	if (err < 0)
> >  		goto cleanup;
> >  
> > +	if (CHECK(!bss->called_stat || !bss->called_close,
> 
> +1 to KP's comment.

ok

thanks,
jirka

