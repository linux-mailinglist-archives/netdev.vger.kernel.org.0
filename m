Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694E4D843C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390190AbfJOXIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:08:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52043 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfJOXIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 19:08:51 -0400
Received: from [213.220.153.21] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iKVvr-0000Jx-9u; Tue, 15 Oct 2019 23:08:47 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CAADnVQ+PDTTBT5GEZQhnoF0Ni8JVbRD5A+zWRH6DO45Kc-Zn=Q@mail.gmail.com>
Date:   Wed, 16 Oct 2019 01:08:46 +0200
Subject: Re: [PATCH 0/3] bpf: switch to new usercopy helpers
From:   "Christian Brauner" <christian.brauner@ubuntu.com>
To:     "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
Cc:     "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "bpf" <bpf@vger.kernel.org>, "Martin KaFai Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        "Network Development" <netdev@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Message-Id: <BXQH5L9TPV45.1L8EW2MWSM2VM@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Oct 15, 2019 at 4:02 PM Alexei Starovoitov wrote:
> On Tue, Oct 15, 2019 at 3:55 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > On Tue, Oct 15, 2019 at 03:45:54PM -0700, Alexei Starovoitov wrote:
> > > On Thu, Oct 10, 2019 at 2:26 AM Christian Brauner
> > > <christian.brauner@ubuntu.com> wrote:
> > > >
> > > > On Wed, Oct 09, 2019 at 04:06:18PM -0700, Alexei Starovoitov wrote:
> > > > > On Wed, Oct 9, 2019 at 9:09 AM Christian Brauner
> > > > > <christian.brauner@ubuntu.com> wrote:
> > > > > >
> > > > > > Hey everyone,
> > > > > >
> > > > > > In v5.4-rc2 we added two new helpers check_zeroed_user() and
> > > > > > copy_struct_from_user() including selftests (cf. [1]). It is a =
generic
> > > > > > interface designed to copy a struct from userspace. The helpers=
 will be
> > > > > > especially useful for structs versioned by size of which we hav=
e quite a
> > > > > > few.
> > > > > >
> > > > > > The most obvious benefit is that this helper lets us get rid of
> > > > > > duplicate code. We've already switched over sched_setattr(), pe=
rf_event_open(),
> > > > > > and clone3(). More importantly it will also help to ensure that=
 users
> > > > > > implementing versioning-by-size end up with the same core seman=
tics.
> > > > > >
> > > > > > This point is especially crucial since we have at least one cas=
e where
> > > > > > versioning-by-size is used but with slighly different semantics=
:
> > > > > > sched_setattr(), perf_event_open(), and clone3() all do do simi=
lar
> > > > > > checks to copy_struct_from_user() while rt_sigprocmask(2) alway=
s rejects
> > > > > > differently-sized struct arguments.
> > > > > >
> > > > > > This little series switches over bpf codepaths that have hand-r=
olled
> > > > > > implementations of these helpers.
> > > > >
> > > > > check_zeroed_user() is not in bpf-next.
> > > > > we will let this set sit in patchworks for some time until bpf-ne=
xt
> > > > > is merged back into net-next and we fast forward it.
> > > > > Then we can apply it (assuming no conflicts).
> > > >
> > > > Sounds good to me. Just ping me when you need me to resend rebase o=
nto
> > > > bpf-next.
> > >
> > > -rc1 is now in bpf-next.
> > > I took a look at patches and they look good overall.
> > >
> > > In patches 2 and 3 the zero init via "=3D {};"
> > > should be unnecessary anymore due to
> > > copy_struct_from_user() logic, right?
> >
> > Right, I can remove them.
> >
> > >
> > > Could you also convert all other case in kernel/bpf/,
> > > so bpf_check_uarg_tail_zero() can be removed ?
> > > Otherwise the half-way conversion will look odd.
> >
> > Hm, I thought I did that and concluded that bpf_check_uarg_tail_zero()
> > can't be removed because sometimes it is called to verify whether a
> > given struct is zeroed but nothing is actually copied from userspace bu=
t
> > rather to userspace. See for example
> > v5.4-rc3:kernel/bpf/syscall.c:bpf_map_get_info_by_fd()
> > All call sites where something is actually copied from userspace I've
> > switched to copy_struct_from_user().
>=20
> I see. You're right.
> Could you update the comment in bpf_check_uarg_tail_zero()
> to clarify that copy_struct_from_user() should be used whenever
> possible instead ?

Yup, can do.

Christian
