Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C36E2D8477
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 05:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438212AbgLLEZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 23:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438183AbgLLEZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 23:25:09 -0500
Date:   Fri, 11 Dec 2020 20:24:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607747068;
        bh=2hPjMowESwYKSPRiZH0wnxLXNkkzB4BqAImGJwWYT/Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=D9+jBftfpfHojdCICpnMg541yCT7iNsCgliS2DYcRkzV2gSmZ7bPCtwZVildgznQI
         yF5ALe7CFY99HgZSdzmGMnUY7fPlbmxpXeBdN6FgQJFWXsaPSJKjj85yYXjBO/2ly3
         5wf/ghjnamb1qL+OFeB6QosnR56LrT4qkGAX1mBvAeD5YfzhKibAV6Cr/KwgyciQ+u
         PUHPyED0yj20qqIPevz3oqPgAYm/6qlffekF42nQgncUfKYPlXgXathV+WkvbB+eSD
         B8rb4QNgBkWCKSkFGpN1o+SHxOqEsDUzTRrm2MBPnTNnrWHxtWN9Z7gHPkOeBeox7H
         8OhtwQ8lGwQAQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 13/15] mlxsw: spectrum_router_xm: Introduce
 basic XM cache flushing
Message-ID: <20201211202427.5871de8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211170413.2269479-14-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
        <20201211170413.2269479-14-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 19:04:11 +0200 Ido Schimmel wrote:
> From: Jiri Pirko <jiri@nvidia.com>
>=20
> Upon route insertion and removal, it is needed to flush possibly cached
> entries from the XM cache. Extend XM op context to carry information
> needed for the flush. Implement the flush in delayed work since for HW
> design reasons there is a need to wait 50usec before the flush can be
> done. If during this time comes the same flush request, consolidate it
> to the first one. Implement this queued flushes by a hashtable.
>=20
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

32 bit does not like this patch:

In file included from ../include/linux/bitops.h:5,
                 from ../include/linux/kernel.h:12,
                 from ../drivers/net/ethernet/mellanox/mlxsw/spectrum_route=
r_xm.c:4:
../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c: In function =
=E2=80=98mlxsw_sp_router_xm_flush_mask4=E2=80=99:
../include/linux/bits.h:36:11: warning: right shift count is negative [-Wsh=
ift-count-negative]
   36 |   (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
      |           ^~
../include/linux/bits.h:38:31: note: in expansion of macro =E2=80=98__GENMA=
SK=E2=80=99
   38 |  (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
      |                               ^~~~~~~~~
../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:361:9: note: in=
 expansion of macro =E2=80=98GENMASK=E2=80=99
  361 |  return GENMASK(32, 32 - prefix_len);
      |         ^~~~~~~
../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:361:16: warning=
: shift count is negative (-1)
In file included from ../include/linux/bitops.h:5,
                 from ../include/linux/kernel.h:12,
                 from ../drivers/net/ethernet/mellanox/mlxsw/spectrum_route=
r_xm.c:4:
../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c: In function =
=E2=80=98mlxsw_sp_router_xm_flush_mask4=E2=80=99:
../include/linux/bits.h:36:11: warning: right shift count is negative [-Wsh=
ift-count-negative]
   36 |   (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
      |           ^~
../include/linux/bits.h:38:31: note: in expansion of macro =E2=80=98__GENMA=
SK=E2=80=99
   38 |  (GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
      |                               ^~~~~~~~~
../drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c:361:9: note: in=
 expansion of macro =E2=80=98GENMASK=E2=80=99
  361 |  return GENMASK(32, 32 - prefix_len);
      |         ^~~~~~~
