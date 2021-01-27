Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05043305176
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239089AbhA0Eao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:57032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231761AbhA0CzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 21:55:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E77C6206CA;
        Wed, 27 Jan 2021 02:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611715382;
        bh=W9tlT0efskTAUPKZ2HeTLOQ7jcJgCM815PUeixWj7lc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=beO0RZN+vYk+ctrD6mqWpHBGirSHQOF+G3QxtoMkM5mbOjO2FUyUmoCUXvU1RIcxr
         x19lbatbeqOgSAbMi6yVfHOzCD7r5OMO6F3rbIL6LgO0JOz5zEZ6yajO4j4KhWJUEn
         v5z0NKBllwXAghDG5qf+JguVHv0YVt2lXBbdwC4eaxh0UbSBstLL+7A3yTPrapJIpE
         +8nzVLWb3UzUHkn6vplTbzV71YVpWfZ9lPqdK/7ITXy2pZNuQJM0qZMFc9GkCDos3R
         DX/NHXjfxHkTtb4q3daUNF8pdcWuEjSTLEUTnjeWiVT0+J4yP1VRTtau96lh7zMBy2
         DSFWt2DKhxpFQ==
Date:   Tue, 26 Jan 2021 18:43:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>,
        Praveen Chaudhary <praveen5582@gmail.com>
Cc:     davem@davemloft.net, corbet@lwn.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenggen Xu <zxu@linkedin.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v4 net-next 1/1] Allow user to set metric on default
 route learned via Router Advertisement.
Message-ID: <20210126184301.525297cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <21884a37-ee26-3c8c-690e-9ea29d77d8b9@gmail.com>
References: <20210125214430.24079-1-pchaudhary@linkedin.com>
        <21884a37-ee26-3c8c-690e-9ea29d77d8b9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 20:34:56 -0700 David Ahern wrote:
> On 1/25/21 2:44 PM, Praveen Chaudhary wrote:
> > For IPv4, default route is learned via DHCPv4 and user is allowed to ch=
ange
> > metric using config etc/network/interfaces. But for IPv6, default route=
 can
> > be learned via RA, for which, currently a fixed metric value 1024 is us=
ed.
> >=20
> > Ideally, user should be able to configure metric on default route for I=
Pv6
> > similar to IPv4. This fix adds sysctl for the same.
> >=20
> > Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
> > Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
> >=20
> > Reviewed-by: David Ahern <dsahern@kernel.org>
> >=20
> > Changes in v1.
> > 1.) Correct the call to rt6_add_dflt_router.
> >=20
> > Changes in v2.
> > 1.) Replace accept_ra_defrtr_metric to ra_defrtr_metric.
> > 2.) Change Type to __u32 instead of __s32.
> > 3.) Change description in Documentation/networking/ip-sysctl.rst.
> > 4.) Use proc_douintvec instead of proc_dointvec.
> > 5.) Code style in ndisc_router_discovery().
> > 6.) Change Type to u32 instead of unsigned int.
> >=20
> > Changes in v3:
> > 1.) Removed '---' and '```' from description.
> > 2.) Remove stray ' after accept_ra_defrtr.
> > 3.) Fix tab in net/ipv6/addrconf.c.
> >=20
> > Changes in v4:
> > 1.) Remove special case of 0 and use IP6_RT_PRIO_USER as default.
> > 2.) Do not allow 0.
> > 3.) Change Documentation accordingly.
> > 4.) Remove extra brackets and compare with zero in ndisc_router_discove=
ry().
> > 5.) Remove compare with zero in rt6_add_dflt_router().
> >=20
> > Logs:
> >=20
> > For IPv4:
> >=20
> > Config in etc/network/interfaces:
> > auto eth0
> > iface eth0 inet dhcp
> >     metric 4261413864
> >=20
> > IPv4 Kernel Route Table:
> > $ ip route list
> > default via 172.21.47.1 dev eth0 metric 4261413864
> >=20
> > FRR Table, if a static route is configured:
> > [In real scenario, it is useful to prefer BGP learned default route ove=
r DHCPv4 default route.]
> > Codes: K - kernel route, C - connected, S - static, R - RIP,
> >        O - OSPF, I - IS-IS, B - BGP, P - PIM, E - EIGRP, N - NHRP,
> >        T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP, =20
> >        > - selected route, * - FIB route =20
> >  =20
> > S>* 0.0.0.0/0 [20/0] is directly connected, eth0, 00:00:03 =20
> > K   0.0.0.0/0 [254/1000] via 172.21.47.1, eth0, 6d08h51m
> >=20
> > i.e. User can prefer Default Router learned via Routing Protocol in IPv=
4.
> > Similar behavior is not possible for IPv6, without this fix.
> >=20
> > After fix [for IPv6]:
> > sudo sysctl -w net.ipv6.conf.eth0.net.ipv6.conf.eth0.ra_defrtr_metric=
=3D1996489705
> >=20
> > IP monitor: [When IPv6 RA is received]
> > default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 19964897=
05  pref high
> >=20
> > Kernel IPv6 routing table
> > $ ip -6 route list
> > default via fe80::be16:65ff:feb3:ce8e dev eth0 proto ra metric 19964897=
05 expires 21sec hoplimit 64 pref high
> >=20
> > FRR Table, if a static route is configured:
> > [In real scenario, it is useful to prefer BGP learned default route ove=
r IPv6 RA default route.]
> > Codes: K - kernel route, C - connected, S - static, R - RIPng,
> >        O - OSPFv3, I - IS-IS, B - BGP, N - NHRP, T - Table,
> >        v - VNC, V - VNC-Direct, A - Babel, D - SHARP, =20
> >        > - selected route, * - FIB route =20
> >  =20
> > S>* ::/0 [20/0] is directly connected, eth0, 00:00:06 =20
> > K   ::/0 [119/1001] via fe80::xx16:xxxx:feb3:ce8e, eth0, 6d07h43m
> >=20
> > If the metric is changed later, the effect will be seen only when next =
IPv6
> > RA is received, because the default route must be fully controlled by R=
A msg.
> > Below metric is changed from 1996489705 to 1996489704.
> >=20
> > $ sudo sysctl -w net.ipv6.conf.eth0.ra_defrtr_metric=3D1996489704
> > net.ipv6.conf.eth0.ra_defrtr_metric =3D 1996489704
> >=20
> > IP monitor:
> > [On next IPv6 RA msg, Kernel deletes prev route and installs new route =
with updated metric]
> >=20
> > Deleted default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric =
1996489705=C2=A0=C2=A0expires 3sec hoplimit 64 pref high
> > default via fe80::xx16:xxxx:feb3:ce8e dev eth0 proto ra metric 19964897=
04=C2=A0=C2=A0pref high
> > ---
> >  Documentation/networking/ip-sysctl.rst | 10 ++++++++++
> >  include/linux/ipv6.h                   |  1 +
> >  include/net/ip6_route.h                |  3 ++-
> >  include/uapi/linux/ipv6.h              |  1 +
> >  include/uapi/linux/sysctl.h            |  1 +
> >  net/ipv6/addrconf.c                    | 11 +++++++++++
> >  net/ipv6/ndisc.c                       | 12 ++++++++----
> >  net/ipv6/route.c                       |  5 +++--
> >  8 files changed, 37 insertions(+), 7 deletions(-)
> >  =20
>=20
> Reviewed-by: David Ahern <dsahern@kernel.org>

Did my best to untangle the commit message and applied.

Thanks!
