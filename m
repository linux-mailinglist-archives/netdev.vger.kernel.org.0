Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EB64325C8
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhJRSAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhJRSAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 14:00:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7426760F02;
        Mon, 18 Oct 2021 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634579913;
        bh=ge+eIkzzAkuGhHb3uX/+iTHVZpyor7eLDw73yDW8zVk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J0b+jKDJTxhPz+zxQoRFENjkyEms1lsDQCvHNboAWtZ6smpjRdU/iVYJlJ0NXBdVi
         TesR83//fy7mZx9OIVtyK5rIvkS0La9w/4rK6iWfVI0zApxa1yL9Kngw5MCe7poFNt
         cQa5MYhELZI4bXksNPVQe0wZXBRVYQPb8kPQra+POBwVRVPFTGn/71UYLayKsWXdPf
         1pG0W6vK7MD2YI/Cwn+fyGwzKTfJNgbvlhApP12w0AsD+td4nfFf83Jm6QXq1LB1Za
         Qq0TueVhWGBEfQAF8CqPGKrKjobdBQ/whNiW/IP7WoHx3t7Yi5nem0+JoGL2gpcBxL
         LAVnkCCYUkGrg==
Date:   Mon, 18 Oct 2021 10:58:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Cc:     Vlad Buslov <vladbu@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+62e474dd92a35e3060d8@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, joamaki@gmail.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [syzbot] BUG: corrupted list in netif_napi_add
Message-ID: <20211018105831.77cde2ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87lf2qi63r.fsf@toke.dk>
References: <0000000000005639cd05ce3a6d4d@google.com>
        <f821df00-b3e9-f5a8-3dcb-a235dd473355@iogearbox.net>
        <f3cc125b2865cce2ea4354b3c93f45c86193545a.camel@redhat.com>
        <ygnh5ytubfa4.fsf@nvidia.com>
        <20211018084201.4c7e5be1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87lf2qi63r.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 19:40:40 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
>=20
> > On Mon, 18 Oct 2021 17:04:19 +0300 Vlad Buslov wrote: =20
> >> We got a use-after-free with very similar trace [0] during nightly
> >> regression. The issue happens when ip link up/down state is flipped
> >> several times in loop and doesn't reproduce for me manually. The fact
> >> that it didn't reproduce for me after running test ten times suggests
> >> that it is either very hard to reproduce or that it is a result of some
> >> interaction between several tests in our suite.
> >>=20
> >> [0]:
> >>=20
> >> [ 3187.779569] mlx5_core 0000:08:00.0 enp8s0f0: Link up
> >>  [ 3187.890694] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>  [ 3187.892518] BUG: KASAN: use-after-free in __list_add_valid+0xc3/0x=
f0
> >>  [ 3187.894132] Read of size 8 at addr ffff8881150b3fb8 by task ip/119=
618 =20
> >
> > Hm, not sure how similar it is. This one looks like channel was freed
> > without deleting NAPI. Do you have list debug enabled? =20
>=20
> Well, the other report[0] also kinda looks like the NAPI thread keeps
> running after it should have been disabled, so maybe they are in fact
> related?
>=20
> [0] https://lore.kernel.org/r/000000000000c1524005cdeacc5f@google.com

Could be, if napi->state gets corrupted it may lose NAPI_STATE_LISTED.

719c57197010 ("net: make napi_disable() symmetric with enable")
3765996e4f0b ("napi: fix race inside napi_enable")
is the only thing that comes to mind, but they look fine to me.

