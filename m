Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B5418D5E5
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 18:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgCTRfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 13:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgCTRfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 13:35:38 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9325D20722;
        Fri, 20 Mar 2020 17:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584725737;
        bh=SmCtLv/G908LL/O/QDUftYhYByNrX4ZJA0bnrKe8bjc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FDz18fZq4efz4/7m3C2j1sdiurP2SFERgx/U2Bo1UcBRBkHszqlr7Fn4jb4qq355o
         wZ2oA636j2OuYbqOO0ZWfwqiScCHO36wyM8I72Q7xf6eLtB9F79sPiK0CrO5MZC3ml
         eR17S7bek74a6KUUzbXycFiWlICQlElSdJO5LC70=
Date:   Fri, 20 Mar 2020 10:35:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
In-Reply-To: <875zez76ph.fsf@toke.dk>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
        <158462359315.164779.13931660750493121404.stgit@toke.dk>
        <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
        <875zez76ph.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Mar 2020 09:48:10 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te: =20
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>=20
> >> While it is currently possible for userspace to specify that an existi=
ng
> >> XDP program should not be replaced when attaching to an interface, the=
re is
> >> no mechanism to safely replace a specific XDP program with another.
> >>=20
> >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, which c=
an be
> >> set along with IFLA_XDP_FD. If set, the kernel will check that the pro=
gram
> >> currently loaded on the interface matches the expected one, and fail t=
he
> >> operation if it does not. This corresponds to a 'cmpxchg' memory opera=
tion.
> >>=20
> >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explicitly
> >> request checking of the EXPECTED_FD attribute. This is needed for user=
space
> >> to discover whether the kernel supports the new attribute.
> >>=20
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> =20
> >
> > I didn't know we wanted to go ahead with this... =20
>=20
> Well, I'm aware of the bpf_link discussion, obviously. Not sure what's
> happening with that, though. So since this is a straight-forward
> extension of the existing API, that doesn't carry a high implementation
> cost, I figured I'd just go ahead with this. Doesn't mean we can't have
> something similar in bpf_link as well, of course.

I'm not really in the loop, but from what I overheard - I think the
bpf_link may be targeting something non-networking first.

> > If we do please run this thru checkpatch, set .strict_start_type, =20
>=20
> Will do.
>=20
> > and make the expected fd unsigned. A negative expected fd makes no
> > sense. =20
>=20
> A negative expected_fd corresponds to setting the UPDATE_IF_NOEXIST
> flag. I guess you could argue that since we have that flag, setting a
> negative expected_fd is not strictly needed. However, I thought it was
> weird to have a "this is what I expect" API that did not support
> expressing "I expect no program to be attached".

I see it now, not entirely unreasonable.

Why did you choose to use the FD rather than passing prog id directly?
Is the application unlikely to have program ID?
