Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3738D3156D1
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhBIT30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:29:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233302AbhBITFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:05:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FD1164EAA;
        Tue,  9 Feb 2021 19:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612897467;
        bh=UkgMt+q60AO7WX/QjcA7wos9KOv2WlcCyoGrkyvH8/g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=To4j3mrpCivtXVfWIr73fCF+CX8J3esiGWWgZ5NlnHdHDy/t1aTLF6sg6PimYcxoD
         DG/Q9YRiFQY0gXJs6hKdnsR+aYEcVratvJz8arS/L+cwj8rULI/vXPwgg1oWEMiSs8
         ZxmGWawtIfDCi1wmoH8fbQtXvIA0nHvoTgpY3NtqqI374Xtn2YNBbMLbGlPPCFKXZK
         nLU+M3bOdp7xXRp3Pwm3H+jvD75MOEaoToQnUFpKpo+uVQv1gxmUMCEvYmGTijz7Lr
         9Yv8JZjYYYGsOxX3TADhnuowdceg0SoPSCnwV9jI8MQbCRT54dvP8IVi+TppVTh7Ps
         CIis+9RQmvQIg==
Date:   Tue, 9 Feb 2021 11:04:26 -0800
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
Message-ID: <20210209110426.67df7617@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF2d9jj3x9CbPbB6u3gQyW=80WqXxwqnk2bbk1pEmkP6K_Wasg@mail.gmail.com>
References: <20210201233445.2044327-1-jianyang.kernel@gmail.com>
        <87czx978x8.fsf@nvidia.com>
        <20210209082326.44dc3269@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAF2d9jj3x9CbPbB6u3gQyW=80WqXxwqnk2bbk1pEmkP6K_Wasg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 10:49:23 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=
=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=
=B0) wrote:
> On Tue, Feb 9, 2021 at 8:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 9 Feb 2021 12:54:59 +0100 Petr Machata wrote: =20
> > > This will break user scripts, and it fact breaks kernel's very own
> > > selftest. We currently have this internally:
> > >
> > >     diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/=
testing/selftests/net/fib_nexthops.sh
> > >     index 4c7d33618437..bf8ed24ab3ba 100755
> > >     --- a/tools/testing/selftests/net/fib_nexthops.sh
> > >     +++ b/tools/testing/selftests/net/fib_nexthops.sh
> > >     @@ -121,8 +121,6 @@ create_ns()
> > >       set -e
> > >       ip netns add ${n}
> > >       ip netns set ${n} $((nsid++))
> > >     - ip -netns ${n} addr add 127.0.0.1/8 dev lo
> > >     - ip -netns ${n} link set lo up
> > >
> > >       ip netns exec ${n} sysctl -qw net.ipv4.ip_forward=3D1
> > >       ip netns exec ${n} sysctl -qw net.ipv4.fib_multipath_use_neigh=
=3D1
> > >
> > > This now fails because the ip commands are run within a "set -e" bloc=
k,
> > > and kernel rejects addition of a duplicate address. =20
> >
> > Thanks for the report, could you send a revert with this explanation? =
=20
> Rather than revert, shouldn't we just fix the self-test in that regard?

The selftest is just a messenger. We all know Linus's stand on
regressions, IMO we can't make an honest argument that the change
does not break user space after it broke our own selftest. Maybe=20
others disagree..
