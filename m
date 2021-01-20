Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD67D2FD13D
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 14:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733145AbhATNTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 08:19:09 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6907 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733258AbhATNQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 08:16:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60082cf50001>; Wed, 20 Jan 2021 05:15:33 -0800
Received: from [172.27.14.4] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 13:15:26 +0000
Subject: Re: [PATCH bpf-next v2 0/8] Introduce bpf_redirect_xsk() helper
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <bjorn.topel@intel.com>, <magnus.karlsson@intel.com>,
        <maciej.fijalkowski@intel.com>, <kuba@kernel.org>,
        <jonathan.lemon@gmail.com>, <davem@davemloft.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <ciara.loftus@intel.com>, <weqaar.a.janjua@intel.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <7dcee85b-b3ef-947f-f433-03ad7066c5dd@nvidia.com>
Date:   Wed, 20 Jan 2021 15:15:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119155013.154808-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611148534; bh=kiWiawGhVprchpRWRe8+/BXGE/CKykZPos9/k7e9MMs=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=IzekYj8KEZ54jGospjLuEQuJRFyXD+Z/tLg5rN9WjmGT6YS25HLfkeDXiP2efNDon
         MY+XBCEZxi+5M5VuNQQqVzFGUVtrqrGaiywlwWubUOk82dGwXvVFurIag/Km7p2awS
         craA1FdJBdJMnLantddYiYiUhAV39CbxCsV/J67pQZeTHZxnFF61EvxvB2jF5z23IF
         HPtKVwhOwkYXyMb8oQNHnXl5PtkPZGNzafIsTR6vWIDHcuDRNCQ3GSCYgOjtzMvKKq
         4zccYGioloupnU4T7vf5V6koaGs3L9yly1sU3bmbCAyi4B+rjzBTLPRTANabBEY/UI
         k9b7UQd4a2mOA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-19 17:50, Bj=C3=B6rn T=C3=B6pel wrote:
> This series extends bind() for XDP sockets, so that the bound socket
> is added to the netdev_rx_queue _rx array in the netdevice. We call
> this to register the socket. To redirect packets to the registered
> socket, a new BPF helper is used: bpf_redirect_xsk().
>=20
> For shared XDP sockets, only the first bound socket is
> registered. Users that need more complex setup has to use XSKMAP and
> bpf_redirect_map().
>=20
> Now, why would one use bpf_redirect_xsk() over the regular
> bpf_redirect_map() helper?
>=20
> * Better performance!
> * Convenience; Most user use one socket per queue. This scenario is
>    what registered sockets support. There is no need to create an
>    XSKMAP. This can also reduce complexity from containerized setups,
>    where users might what to use XDP sockets without CAP_SYS_ADMIN
>    capabilities.
>=20
> The first patch restructures xdp_do_redirect() a bit, to make it
> easier to add the new helper. This restructure also give us a slight
> performance benefit. The following three patches extends bind() and
> adds the new helper. After that, two libbpf patches that selects XDP
> program based on what kernel is running. Finally, selftests for the new
> functionality is added.
>=20
> Note that the libbpf "auto-selection" is based on kernel version, so
> it is hard coded to the "-next" version (5.12). If you would like to
> try this is out, you will need to change the libbpf patch locally!
>=20
> Thanks to Maciej and Magnus for the internal review/comments!
>=20
> Performance (rxdrop, zero-copy)
>=20
> Baseline
> Two cores:                   21.3 Mpps
> One core:                    24.5 Mpps

Two cores is slower? It used to be faster all the time, didn't it?

> Patched
> Two cores, bpf_redirect_map: 21.7 Mpps + 2%
> One core, bpf_redirect_map:  24.9 Mpps + 2%
>=20
> Two cores, bpf_redirect_xsk: 24.0 Mpps +13%

Nice, impressive improvement!

> One core, bpf_redirect_xsk:  25.5 Mpps + 4%
>=20
> Thanks!
> Bj=C3=B6rn
>=20
> v1->v2:
>    * Added missing XDP programs to selftests.
>    * Fixed checkpatch warning in selftests.
>=20
> Bj=C3=B6rn T=C3=B6pel (8):
>    xdp: restructure redirect actions
>    xsk: remove explicit_free parameter from __xsk_rcv()
>    xsk: fold xp_assign_dev and __xp_assign_dev
>    xsk: register XDP sockets at bind(), and add new AF_XDP BPF helper
>    libbpf, xsk: select AF_XDP BPF program based on kernel version
>    libbpf, xsk: select bpf_redirect_xsk(), if supported
>    selftest/bpf: add XDP socket tests for bpf_redirect_{xsk, map}()
>    selftest/bpf: remove a lot of ifobject casting in xdpxceiver
>=20
>   include/linux/filter.h                        |  10 +
>   include/linux/netdevice.h                     |   1 +
>   include/net/xdp_sock.h                        |  12 +
>   include/net/xsk_buff_pool.h                   |   2 +-
>   include/trace/events/xdp.h                    |  46 ++--
>   include/uapi/linux/bpf.h                      |   7 +
>   net/core/filter.c                             | 205 ++++++++++--------
>   net/xdp/xsk.c                                 | 112 ++++++++--
>   net/xdp/xsk_buff_pool.c                       |  12 +-
>   tools/include/uapi/linux/bpf.h                |   7 +
>   tools/lib/bpf/libbpf.c                        |   2 +-
>   tools/lib/bpf/libbpf_internal.h               |   2 +
>   tools/lib/bpf/libbpf_probes.c                 |  16 --
>   tools/lib/bpf/xsk.c                           |  83 ++++++-
>   .../selftests/bpf/progs/xdpxceiver_ext1.c     |  15 ++
>   .../selftests/bpf/progs/xdpxceiver_ext2.c     |   9 +
>   tools/testing/selftests/bpf/test_xsk.sh       |  48 ++++
>   tools/testing/selftests/bpf/xdpxceiver.c      | 164 +++++++++-----
>   tools/testing/selftests/bpf/xdpxceiver.h      |   2 +
>   19 files changed, 554 insertions(+), 201 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/xdpxceiver_ext1.c
>   create mode 100644 tools/testing/selftests/bpf/progs/xdpxceiver_ext2.c
>=20
>=20
> base-commit: 95204c9bfa48d2f4d3bab7df55c1cc823957ff81
>=20

