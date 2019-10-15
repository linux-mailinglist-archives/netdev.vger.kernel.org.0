Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D55AD841B
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390155AbfJOW4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:56:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51766 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbfJOW4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:56:01 -0400
Received: from [213.220.153.21] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iKVjR-00084E-U9; Tue, 15 Oct 2019 22:55:57 +0000
Date:   Wed, 16 Oct 2019 00:55:57 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] bpf: switch to new usercopy helpers
Message-ID: <20191015225555.jprg5xmnbg45os3y@wittgenstein>
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
 <CAADnVQJxUwD3u+tK1xsU2thpRWiAbERGx8mMoXKOCfNZrETMuw@mail.gmail.com>
 <20191010092647.cpxh7neqgabq36gt@wittgenstein>
 <CAADnVQJ6t+HQBRhN3mZrz4qhzGybsY2g-26mc2kQARkbLxqzTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQJ6t+HQBRhN3mZrz4qhzGybsY2g-26mc2kQARkbLxqzTA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 03:45:54PM -0700, Alexei Starovoitov wrote:
> On Thu, Oct 10, 2019 at 2:26 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > On Wed, Oct 09, 2019 at 04:06:18PM -0700, Alexei Starovoitov wrote:
> > > On Wed, Oct 9, 2019 at 9:09 AM Christian Brauner
> > > <christian.brauner@ubuntu.com> wrote:
> > > >
> > > > Hey everyone,
> > > >
> > > > In v5.4-rc2 we added two new helpers check_zeroed_user() and
> > > > copy_struct_from_user() including selftests (cf. [1]). It is a generic
> > > > interface designed to copy a struct from userspace. The helpers will be
> > > > especially useful for structs versioned by size of which we have quite a
> > > > few.
> > > >
> > > > The most obvious benefit is that this helper lets us get rid of
> > > > duplicate code. We've already switched over sched_setattr(), perf_event_open(),
> > > > and clone3(). More importantly it will also help to ensure that users
> > > > implementing versioning-by-size end up with the same core semantics.
> > > >
> > > > This point is especially crucial since we have at least one case where
> > > > versioning-by-size is used but with slighly different semantics:
> > > > sched_setattr(), perf_event_open(), and clone3() all do do similar
> > > > checks to copy_struct_from_user() while rt_sigprocmask(2) always rejects
> > > > differently-sized struct arguments.
> > > >
> > > > This little series switches over bpf codepaths that have hand-rolled
> > > > implementations of these helpers.
> > >
> > > check_zeroed_user() is not in bpf-next.
> > > we will let this set sit in patchworks for some time until bpf-next
> > > is merged back into net-next and we fast forward it.
> > > Then we can apply it (assuming no conflicts).
> >
> > Sounds good to me. Just ping me when you need me to resend rebase onto
> > bpf-next.
> 
> -rc1 is now in bpf-next.
> I took a look at patches and they look good overall.
> 
> In patches 2 and 3 the zero init via "= {};"
> should be unnecessary anymore due to
> copy_struct_from_user() logic, right?

Right, I can remove them.

> 
> Could you also convert all other case in kernel/bpf/,
> so bpf_check_uarg_tail_zero() can be removed ?
> Otherwise the half-way conversion will look odd.

Hm, I thought I did that and concluded that bpf_check_uarg_tail_zero()
can't be removed because sometimes it is called to verify whether a
given struct is zeroed but nothing is actually copied from userspace but
rather to userspace. See for example
v5.4-rc3:kernel/bpf/syscall.c:bpf_map_get_info_by_fd()
All call sites where something is actually copied from userspace I've
switched to copy_struct_from_user().

Christian
