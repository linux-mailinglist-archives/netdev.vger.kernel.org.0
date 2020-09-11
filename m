Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F94F266105
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 16:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgIKOOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 10:14:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbgIKNQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 09:16:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599830165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rkS7T2t+cwHMdDgfJc0SznulsmzvAzCieOLQud/9Bcc=;
        b=BW5shzUNLFhZbr1NjEOy3DT1vPLrwNc6M2nJCt4pj35TxstYTRoccs99f08ZGgU+YXXMsQ
        m9GxlMAyJDI9gJHSAV7LsrIy2p1qZ9Nu0r7dx5UxtUEkLb/200G7+t9+6Fr3pmgeFqYzAt
        252QYOEhiN4fF7i5czlMDST7egJFZng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-c1THySt4MBOTG0_EC_WAnA-1; Fri, 11 Sep 2020 09:16:03 -0400
X-MC-Unique: c1THySt4MBOTG0_EC_WAnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DD7981F00F;
        Fri, 11 Sep 2020 13:16:02 +0000 (UTC)
Received: from krava (unknown [10.40.192.120])
        by smtp.corp.redhat.com (Postfix) with SMTP id 54B7875136;
        Fri, 11 Sep 2020 13:15:59 +0000 (UTC)
Date:   Fri, 11 Sep 2020 15:15:58 +0200
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
Message-ID: <20200911131558.GD1714160@krava>
References: <20200910122224.1683258-1-jolsa@kernel.org>
 <CAADnVQJ0FchoPqNWm+dEppyij-MOvvEG_trEfyrHdabtcEuZGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJ0FchoPqNWm+dEppyij-MOvvEG_trEfyrHdabtcEuZGg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 05:46:21PM -0700, Alexei Starovoitov wrote:
> On Thu, Sep 10, 2020 at 5:22 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Some kernels builds might inline vfs_getattr call within
> > fstat syscall code path, so fentry/vfs_getattr trampoline
> > is not called.
> >
> > I'm not sure how to handle this in some generic way other
> > than use some other function, but that might get inlined at
> > some point as well.
> 
> It's great that we had the test and it failed.
> Doing the test skipping will only hide the problem.
> Please don't do it here and in the future.
> Instead let's figure out the real solution.
> Assuming that vfs_getattr was added to btf_allowlist_d_path
> for a reason we have to make this introspection place
> reliable regardless of compiler inlining decisions.
> We can mark it as 'noinline', but that's undesirable.
> I suggest we remove it from the allowlist and replace it with
> security_inode_getattr.
> I think that is a better long term fix.

in my case vfs_getattr got inlined in vfs_statx_fd and both
of them are defined in fs/stat.c 

so the idea is that inlining will not happen if the function
is defined in another object? or less likely..?

we should be safe when it's called from module

> While at it I would apply the same critical thinking to other
> functions in the allowlist. They might suffer the same issue.
> So s/vfs_truncate/security_path_truncate/ and so on?
> Things won't work when CONFIG_SECURITY is off, but that is a rare kernel config?
> Or add both security_* and vfs_* variants and switch tests to use security_* ?
> but it feels fragile to allow inline-able funcs in allowlist.

hm, what's the difference between vfs_getattr and security_inode_getattr
in this regard? I'd expect compiler could inline it same way as for vfs_getattr

jirka

