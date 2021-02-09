Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7C031573B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbhBITxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:53:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233690AbhBIToW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:44:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E836A64E7D;
        Tue,  9 Feb 2021 19:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612899821;
        bh=8WXzoyNmJXYYsY4nKsRw7MwdLD85EN0HCgwD/aOv0Mo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p8LehPQ7SlqkOG0xfKAcr/TjLXZddKslZxo/r7xvkCOlxOdnKzy1vDaeqeYstrYLH
         BAb7brbt2V4LaBLGpVXMhAxljLAdmBfkHX/sGTSOG/lwztdFY4KGdDuKNonbUu8+ct
         7zHEPGkGbceFa387arB6aN8Ua8JeGrMsA+mSrNaH+rQ00l2XQ5vAtbIZN5T6xA8Xrg
         YtgiUt6HyCysW02Ju6m05027F5exraZ1cCI75V6SH58jAr8CJyflau6aaIHqO4stQ5
         hywDY1wucNYuXn1YDnGHPK4IiCStbIYwflyKGSQHO32w9LYR+x4TF65dixtCpTz4eQ
         kKaefE3TuOtRw==
Date:   Tue, 9 Feb 2021 11:43:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mahesh Bandewar (=?UTF-8?B?4KSu4KS54KWH4KS2IOCkrOCkguCkoeClh+CktQ==?=
        =?UTF-8?B?4KS+4KSw?=)" <maheshb@google.com>
Cc:     Petr Machata <petrm@nvidia.com>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next v3] net-loopback: set lo dev initial state to
 UP
Message-ID: <20210209114340.0857fbf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF2d9jhQQs+MX4TRbd1c7A3YH5cLV7uaJcQDhE1LWzMAG8uKjA@mail.gmail.com>
References: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
        <87czx978x8.fsf@nvidia.com>
        <20210209082326.44dc3269@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAF2d9jj3x9CbPbB6u3gQyW=80WqXxwqnk2bbk1pEmkP6K_Wasg@mail.gmail.com>
        <20210209110426.67df7617@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAF2d9jhQQs+MX4TRbd1c7A3YH5cLV7uaJcQDhE1LWzMAG8uKjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 11:18:05 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=
=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=
=B0) wrote:
> On Tue, Feb 9, 2021 at 11:04 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 9 Feb 2021 10:49:23 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=
=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=
=E0=A4=B0) wrote: =20
> > > On Tue, Feb 9, 2021 at 8:23 AM Jakub Kicinski <kuba@kernel.org> wrote=
: =20
> > > > On Tue, 9 Feb 2021 12:54:59 +0100 Petr Machata wrote: =20
> > > > > This will break user scripts, and it fact breaks kernel's very own
> > > > > selftest. We currently have this internally:
> > > > >
> > > > >     diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/to=
ols/testing/selftests/net/fib_nexthops.sh
> > > > >     index 4c7d33618437..bf8ed24ab3ba 100755
> > > > >     --- a/tools/testing/selftests/net/fib_nexthops.sh
> > > > >     +++ b/tools/testing/selftests/net/fib_nexthops.sh
> > > > >     @@ -121,8 +121,6 @@ create_ns()
> > > > >       set -e
> > > > >       ip netns add ${n}
> > > > >       ip netns set ${n} $((nsid++))
> > > > >     - ip -netns ${n} addr add 127.0.0.1/8 dev lo
> > > > >     - ip -netns ${n} link set lo up
> > > > >
> > > > >       ip netns exec ${n} sysctl -qw net.ipv4.ip_forward=3D1
> > > > >       ip netns exec ${n} sysctl -qw net.ipv4.fib_multipath_use_ne=
igh=3D1
> > > > >
> > > > > This now fails because the ip commands are run within a "set -e" =
block,
> > > > > and kernel rejects addition of a duplicate address. =20
> > > >
> > > > Thanks for the report, could you send a revert with this explanatio=
n? =20
> > > Rather than revert, shouldn't we just fix the self-test in that regar=
d? =20
> >
> > The selftest is just a messenger. We all know Linus's stand on
> > regressions, IMO we can't make an honest argument that the change
> > does not break user space after it broke our own selftest. Maybe
> > others disagree.. =20
>=20
> Actually that was the reason behind encompassing this behavior change
> with a sysctl.

Which as I explained to you is pointless for portable applications.
