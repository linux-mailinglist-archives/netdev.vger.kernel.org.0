Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4B0191EAD
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 02:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgCYBnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 21:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727189AbgCYBnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 21:43:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C1C92072E;
        Wed, 25 Mar 2020 01:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585100593;
        bh=sg7WOwd9ZDEpz06YO3AE0R8NPoAXbF/kRDcvIEYj8tM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ayIhAdEoNBZR9mJCDvo9gy+hZyO14idUgHBKa4lTIBINnvMbbQDP5NGM3VHkA7Qez
         LJy/Hdv8TYF5ZNoOvINVS3LJ6qCR3g0BK9cBiX1SugXLQsFwgNA/HgvZ8hLe6s6lM/
         YHJ9N2u9vLwMw5GFDlU+9tBwtrNpe40TXGr6TapQ=
Date:   Tue, 24 Mar 2020 18:43:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v3 1/4] xdp: Support specifying expected
 existing program when attaching XDP
Message-ID: <20200324184311.4cfb4911@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEf4BzaXvTx5-bp8QygxScwEKjq8LYZqU4dgxo2C9USqHpGxKg@mail.gmail.com>
References: <158507357205.6925.17804771242752938867.stgit@toke.dk>
        <158507357313.6925.9859587430926258691.stgit@toke.dk>
        <CAEf4BzaXvTx5-bp8QygxScwEKjq8LYZqU4dgxo2C9USqHpGxKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 17:54:07 -0700 Andrii Nakryiko wrote:
> On Tue, Mar 24, 2020 at 11:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >
> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >
> > While it is currently possible for userspace to specify that an existing
> > XDP program should not be replaced when attaching to an interface, ther=
e is
> > no mechanism to safely replace a specific XDP program with another.
> >
> > This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_ID, which ca=
n be
> > set along with IFLA_XDP_FD. If set, the kernel will check that the prog=
ram
> > currently loaded on the interface matches the expected one, and fail the
> > operation if it does not. This corresponds to a 'cmpxchg' memory operat=
ion.
> > Setting the new attribute with a negative value means that no program is
> > expected to be attached, which corresponds to setting the UPDATE_IF_NOE=
XIST
> > flag.
> >
> > A new companion flag, XDP_FLAGS_EXPECT_ID, is also added to explicitly
> > request checking of the EXPECTED_ID attribute. This is needed for users=
pace
> > to discover whether the kernel supports the new attribute. =20
>=20
> Doesn't it feel inconsistent in UAPI that FD is used to specify XDP
> program to be attached, but ID is used to specify expected XDP
> program? Especially that the same cgroup use case is using
> (consistently) prog FDs. Or is it another case where XDP needs its own
> special way?

There was a comment during review of v1, I wish you spoke up then.

The prog ID is what dump returns, so the consistency can go either way
(note that this API predates object IDs). Since XDP uses IDs internally
it's just simpler to take prog ID.

But it's a detail, so if you feel strongly I don't really mind.
