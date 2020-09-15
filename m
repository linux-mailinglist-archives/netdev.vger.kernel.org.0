Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5426426A1C8
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 11:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIOJMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 05:12:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbgIOJMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 05:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600161133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lRUm+6UJDwls3Dpm2liZr7g4tgUxqrMaFN//hnrr1Kg=;
        b=Znb32Hu/VCCmrgNele6N/63xpLPQH187GrzBP6GTR4i8BRa3eltx0+aJx9dEx+w0wEiFn/
        4l2kR/zgY+5EcWLyyjGz3nCcKcZ8FTcA+0PrWP6tmxwPpBONSr0o0euv62mWT6OvPNrvD2
        5+Rg6baX6IZlUuI48E6vp8413Zz/LDg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-2E5Q5Cx5Pwi2e3P3CrCmlA-1; Tue, 15 Sep 2020 05:12:09 -0400
X-MC-Unique: 2E5Q5Cx5Pwi2e3P3CrCmlA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E3CC801AC2;
        Tue, 15 Sep 2020 09:12:07 +0000 (UTC)
Received: from krava (unknown [10.40.192.180])
        by smtp.corp.redhat.com (Postfix) with SMTP id BBCFD7E46E;
        Tue, 15 Sep 2020 09:12:03 +0000 (UTC)
Date:   Tue, 15 Sep 2020 11:12:02 +0200
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
Subject: Re: [PATCH bpf-next] selftests/bpf: Check trampoline execution in
 d_path test
Message-ID: <20200915091202.GA2171499@krava>
References: <20200910122224.1683258-1-jolsa@kernel.org>
 <CAADnVQJ0FchoPqNWm+dEppyij-MOvvEG_trEfyrHdabtcEuZGg@mail.gmail.com>
 <20200911131558.GD1714160@krava>
 <CAADnVQKhf8X0zxcx5B9VsXM3Wesayk_Hbtu-zobqaZU09jNv7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKhf8X0zxcx5B9VsXM3Wesayk_Hbtu-zobqaZU09jNv7Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 07:30:33PM -0700, Alexei Starovoitov wrote:
> On Fri, Sep 11, 2020 at 6:16 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Sep 10, 2020 at 05:46:21PM -0700, Alexei Starovoitov wrote:
> > > On Thu, Sep 10, 2020 at 5:22 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > Some kernels builds might inline vfs_getattr call within
> > > > fstat syscall code path, so fentry/vfs_getattr trampoline
> > > > is not called.
> > > >
> > > > I'm not sure how to handle this in some generic way other
> > > > than use some other function, but that might get inlined at
> > > > some point as well.
> > >
> > > It's great that we had the test and it failed.
> > > Doing the test skipping will only hide the problem.
> > > Please don't do it here and in the future.
> > > Instead let's figure out the real solution.
> > > Assuming that vfs_getattr was added to btf_allowlist_d_path
> > > for a reason we have to make this introspection place
> > > reliable regardless of compiler inlining decisions.
> > > We can mark it as 'noinline', but that's undesirable.
> > > I suggest we remove it from the allowlist and replace it with
> > > security_inode_getattr.
> > > I think that is a better long term fix.
> >
> > in my case vfs_getattr got inlined in vfs_statx_fd and both
> > of them are defined in fs/stat.c
> >
> > so the idea is that inlining will not happen if the function
> > is defined in another object? or less likely..?
> 
> when it's in a different .o file. yes.
> Very few folks build LTO kernels, so I propose to cross that bridge when
> we get there.
> Eventually we can replace security_inode_getattr
> with bpf_lsm_inode_getattr or simply add noinline to security_inode_getattr.
> 
> > we should be safe when it's called from module
> 
> what do you mean?

it's external call, so it will not get inlined

> 
> > > While at it I would apply the same critical thinking to other
> > > functions in the allowlist. They might suffer the same issue.
> > > So s/vfs_truncate/security_path_truncate/ and so on?
> > > Things won't work when CONFIG_SECURITY is off, but that is a rare kernel config?
> > > Or add both security_* and vfs_* variants and switch tests to use security_* ?
> > > but it feels fragile to allow inline-able funcs in allowlist.
> >
> > hm, what's the difference between vfs_getattr and security_inode_getattr
> > in this regard? I'd expect compiler could inline it same way as for vfs_getattr
> 
> not really because they're in different files and LTO is not on.
> Even with LTO the chances of inlining are small. The compiler will
> consider profitability of it. Since there is a loop inside, it's unlikely.

ok, thanks for info

I'll use that security_inode_getattr instead of vfs_getattr

jirka

