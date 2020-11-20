Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA802BADC7
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgKTPJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:09:53 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:28517 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728986AbgKTPJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 10:09:50 -0500
Date:   Fri, 20 Nov 2020 15:09:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1605884986; bh=UVOu2hdELOa22PUbrShtG1tB8psu0alU/hmyCLLV9UM=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=VueJGVkgQLGRZDT3DiCzapoc33mzRj8lMzTVlVHhhsSoL++7l82zQraWm37Zs+2Re
         5kkudcRIobbBOblMqkRvMzqAcQCREG8RcQhHqfYnrJnn3tmkvVtlHtHgdaXjN0Ry97
         nKYwxDBSrG25sgksTSHQBtE+kCprN5HGWT3rNxs7FoFlLZ6aNIC+zb+zeCiu1gluRj
         FeXLU4u6ABd1bN/hTChV7aed+VuQ0tKKY6Bm4IZyjVC3lo0MmLOycAqQeAfH93YQm4
         YVMra9byrzdGYVIqjmajZjF7NBe6t6+5u/0I5qw311ILZyYsFMU5OLILyJa5sw2x9F
         m68851K5chCTg==
To:     Pablo Neira Ayuso <pablo@netfilter.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, fw@strlen.de,
        razor@blackwall.org, jeremy@azazel.net, tobias@waldekranz.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next,v5 0/9] netfilter: flowtable bridge and vlan enhancements
Message-ID: <JbOm90Raei3ADlleQvsaCY9krt0lOkG1YFpbZEgylgU@cp4-web-014.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 20 Nov 2020 13:49:12 +0100

> Hi,

Hi Pablo,

> The following patchset augments the Netfilter flowtable fastpath to
> support for network topologies that combine IP forwarding, bridge and
> VLAN devices.

I'm curious if this new infra can be expanded later to shortcut other
VLAN-like virtual netdevs e.g. DSA-like switch slaves.

I mean, usually we have port0...portX physical port representors
and backing CPU port with ethX representor. When in comes to NAT,
portX is set as destination. Flow offload calls dev_queue_xmit()
on it, switch stack pushes CPU tag into the skb, change skb->dev
to ethX and calls another dev_queue_xmit().

If we could (using the new .ndo_fill_forward_path()) tell Netfilter
that our real dest is ethX and push the CPU tag via dev_hard_header(),
this will omit one more dev_queue_xmit() and a bunch of indirect calls
and checks.
This might require some sort of "custom" or "private" cookies for
N-Tuple though to separate flows from/to different switch ports (as
it's done for VLAN: proto + VID).

If so, I'd like to try to implement and publish that idea for reviews
after this one lands nf-next.

> This v5 includes updates for:
>=20
> - Patch #2: fix incorrect xmit type in IPv6 path, per Florian Westphal.
> - Patch #3: fix possible off by one in dev_fill_forward_path() stack logi=
c,
>             per Florian Westphal.
> - Patch #7: add a note to patch description to specify that FDB topology
>             updates are not supported at this stage, per Jakub Kicinski.
>=20
> A typical scenario that can benefit from this infrastructure is composed
> of several VMs connected to bridge ports where the bridge master device
> 'br0' has an IP address. A DHCP server is also assumed to be running to
> provide connectivity to the VMs. The VMs reach the Internet through
> 'br0' as default gateway, which makes the packet enter the IP forwarding
> path. Then, netfilter is used to NAT the packets before they leave
> through the wan device.
>=20
> Something like this:
>=20
>                        fast path
>                 .------------------------.
>                /                          \
>                |           IP forwarding   |
>                |          /             \  .
>                |       br0               eth0
>                .       / \
>                -- veth1  veth2
>                    .
>                    .
>                    .
>                  eth0
>            ab:cd:ef:ab:cd:ef
>                   VM
>=20
> The idea is to accelerate forwarding by building a fast path that takes
> packets from the ingress path of the bridge port and place them in the
> egress path of the wan device (and vice versa). Hence, skipping the
> classic bridge and IP stack paths.
>=20
> This patchset is composed of:
>=20
> Patch #1 adds a placeholder for the hash calculation, instead of using
>          the dir field.
>=20
> Patch #2 adds the transmit path type field to the flow tuple. Two transmi=
t
>          paths are supported so far: the neighbour and the xfrm transmit
>          paths. This patch comes in preparation to add a new direct ether=
net
>          transmit path (see patch #7).
>=20
> Patch #3 adds dev_fill_forward_path() and .ndo_fill_forward_path() to
>          netdev_ops. This new function describes the list of netdevice ho=
ps
>          to reach a given destination MAC address in the local network to=
pology,
>          e.g.
>=20
>                            IP forwarding
>                           /             \
>                        br0              eth0
>                        / \
>                    veth1 veth2
>                     .
>                     .
>                     .
>                    eth0
>              ab:cd:ef:ab:cd:ef
>=20
>           where veth1 and veth2 are bridge ports and eth0 provides Intern=
et
>           connectivity. eth0 is the interface in the VM which is connecte=
d to
>           the veth1 bridge port. Then, for packets going to br0 whose
>           destination MAC address is ab:cd:ef:ab:cd:ef, dev_fill_forward_=
path()
>           provides the following path: br0 -> veth1.
>=20
> Patch #4 adds .ndo_fill_forward_path for VLAN devices, which provides the=
 next
>          device hop via vlan->real_dev. This annotates the VLAN id and pr=
otocol.
>          This is useful to know what VLAN headers are expected from the i=
ngress
>          device. This also provides information regarding the VLAN header=
s
>          to be pushed in the egress path.
>=20
> Patch #5 adds .ndo_fill_forward_path for bridge devices, which allows to =
make
>          lookups to the FDB to locate the next device hop (bridge port) i=
n the
>          forwarding path.
>=20
> Patch #6 updates the flowtable to use the dev_fill_forward_path()
>          infrastructure to obtain the ingress device in the fastpath.
>=20
> Patch #7 updates the flowtable to use dev_fill_forward_path() to obtain t=
he
>          egress device in the forwarding path. This also adds the direct
>          ethernet transmit path, which pushes the ethernet header to the
>          packet and send it through dev_queue_xmit(). This patch adds
>          support for the bridge, so bridge ports use this direct xmit pat=
h.
>=20
> Patch #8 adds ingress VLAN support (up to 2 VLAN tags, QinQ). The VLAN
>          information is also provided by dev_fill_forward_path(). Store t=
he
>          VLAN id and protocol in the flow tuple for hash lookups. The VLA=
N
>          support in the xmit path is achieved by annotating the first vla=
n
>          device found in the xmit path and by calling dev_hard_header()
>          (previous patch #7) before dev_queue_xmit().
>=20
> Patch #9 extends nft_flowtable.sh selftest: This is adding a test to
>          cover bridge and vlan support coming in this patchset.
>=20
> =3D Performance numbers
>=20
> My testbed environment consists of three containers:
>=20
>   192.168.20.2     .20.1     .10.1   10.141.10.2
>          veth0       veth0 veth1      veth0
>         ns1 <---------> nsr1 <--------> ns2
>                             SNAT
>      iperf -c                          iperf -s
>=20
> where nsr1 is used for forwarding. There is a bridge device br0 in nsr1,
> veth0 is a port of br0. SNAT is performed on the veth1 device of nsr1.
>=20
> - ns2 runs iperf -s
> - ns1 runs iperf -c 10.141.10.2 -n 100G
>=20
> My results are:
>=20
> - Baseline (no flowtable, classic forwarding path + netfilter): ~16 Gbit/=
s
> - Fastpath (with flowtable, this patchset): ~25 Gbit/s
>=20
> This is an improvement of ~50% compared to baseline.

Anyway, great work, thanks!

> Please, apply. Thank you.
>=20
> Pablo Neira Ayuso (9):
>   netfilter: flowtable: add hash offset field to tuple
>   netfilter: flowtable: add xmit path types
>   net: resolve forwarding path from virtual netdevice and HW destination =
address
>   net: 8021q: resolve forwarding path for vlan devices
>   bridge: resolve forwarding path for bridge devices
>   netfilter: flowtable: use dev_fill_forward_path() to obtain ingress dev=
ice
>   netfilter: flowtable: use dev_fill_forward_path() to obtain egress devi=
ce
>   netfilter: flowtable: add vlan support
>   selftests: netfilter: flowtable bridge and VLAN support
>=20
>  include/linux/netdevice.h                     |  35 +++
>  include/net/netfilter/nf_flow_table.h         |  43 +++-
>  net/8021q/vlan_dev.c                          |  15 ++
>  net/bridge/br_device.c                        |  27 +++
>  net/core/dev.c                                |  46 ++++
>  net/netfilter/nf_flow_table_core.c            |  51 +++--
>  net/netfilter/nf_flow_table_ip.c              | 200 ++++++++++++++----
>  net/netfilter/nft_flow_offload.c              | 159 +++++++++++++-
>  .../selftests/netfilter/nft_flowtable.sh      |  82 +++++++
>  9 files changed, 598 insertions(+), 60 deletions(-)
>=20
> --
> 2.20.1

Al

