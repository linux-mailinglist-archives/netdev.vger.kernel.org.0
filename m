Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB705F1776
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 02:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiJAAmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 20:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbiJAAmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 20:42:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556EC199CA4;
        Fri, 30 Sep 2022 17:42:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E3D5B82ACA;
        Sat,  1 Oct 2022 00:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9045EC433C1;
        Sat,  1 Oct 2022 00:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664584958;
        bh=n/hDwtfOebc+FCFcLBZD65Wm0/S4cuMCFkQDrMXrKSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AXYvzR7LG4qjRF1yJ3V9hMqsLkfCxsKOGkfkiOgMyz9PTPgx9tJepKIVY5peksmhG
         aGK0dYuSbgGvE9/TNLld+4OtKh8f5wVNeR5Cc4gYrfL8Sz/Wd0nhj+oez09pWpCOQy
         YJbCyOtfcSN0Y8/lWz5S+UwCrioogi3XXzx4SIbswyOGBbxNc4dxdBzZt40Sjd0Zdu
         2TF15R6H9ZdykGaT5JHYlSG7hKimMsNEo9pjiCO0qmPqUS9Nz3F0yX0EaFOZOAmjdF
         GihacY9F34yMs7SrWruhsGCrI3Tjv0n9reqw18tkJBVs/iWydWgcnuFrZpYTG4yHn6
         hTxosRcp/7vJQ==
Date:   Fri, 30 Sep 2022 17:42:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maximilien Cuony <maximilien.cuony@arcanite.ch>
Cc:     netdev@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Mike Manning <mvrmanning@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [REGRESSION] Unable to NAT own TCP packets from another VRF
 with tcp_l3mdev_accept = 1
Message-ID: <20220930174237.2e89c9e1@kernel.org>
In-Reply-To: <98348818-28c5-4cb2-556b-5061f77e112c@arcanite.ch>
References: <98348818-28c5-4cb2-556b-5061f77e112c@arcanite.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding netfilter and vrf experts.

On Wed, 28 Sep 2022 16:02:43 +0200 Maximilien Cuony wrote:
> Hello,
>=20
> We're using VRF with a machine used as a router and have a specific=20
> issue where the router doesn't handle his own packets correctly during=20
> NATing if the packet is coming from a different VRF.
>=20
> We had the issue with debian buster (4.19), but the issue solved itself=20
> when we updated to debian bullseye (5.10.92).
>=20
> However, during an upgrade of debian bullseye to the latest kernel, the=20
> issue appeared again (5.10.140).
>=20
> We did a bisection and this leaded us to=20
> "b0d67ef5b43aedbb558b9def2da5b4fffeb19966 net: allow unbound socket for=20
> packets in VRF when tcp_l3mdev_accept set [ Upstream commit=20
> 944fd1aeacb627fa617f85f8e5a34f7ae8ea4d8e ]".
>=20
> Simplified case setup:
>=20
> There is two machines in the setup. They both forward packets=20
> (net.ipv4.ip_forward =3D 1) and there is two interface between them.
>=20
> The main machine has two VRF. The default VRF is using the second=20
> machine as the default route, on a specific interface.
> The second machine has as default route to main machine, on the other=20
> VRF using the second pair of interfaces.
>=20
> On the main machine, the second interface is in a specific VRF. In that=20
> VRF, packets are NATed to the internet on a third interface.
>=20
> A visual schema with the normal flow is available there:=20
> https://etinacra.ch/kernel.png
>=20
> Configuration command:
>=20
> Main machine:
> sysctl -w net.ipv4.tcp_l3mdev_accept =3D 1
> sysctl -w systnet.ipv4.ip_forward =3D 1
> iptables -t raw -A PREROUTING -i eth0 -j CT --zone 5
> iptables -t raw -A OUTPUT -o eth0 -j CT --zone 5
> iptables -t nat -A POSTROUTING -o eth2 -j SNAT --to 192.168.1.1
> cat /etc/network/interfaces
>=20
> auto firewall
> iface firewall
>  =C2=A0=C2=A0=C2=A0 vrf-table 1200
>=20
> auto eth0
> iface eth0
>  =C2=A0=C2=A0=C2=A0 address 192.168.5.1/24
>  =C2=A0=C2=A0=C2=A0 gateway 192.168.5.2
>=20
> auto eth1
> iface eth1
>  =C2=A0=C2=A0=C2=A0 address 192.168.10.1/24
>  =C2=A0=C2=A0=C2=A0 vrf firewall
>  =C2=A0=C2=A0=C2=A0 up ip route add 192.168.5.0/24 via 192.168.10.2 vrf f=
irewall
>=20
> auto eth2
> iface eth2
>  =C2=A0=C2=A0=C2=A0 address 192.168.1.1/24
>  =C2=A0=C2=A0=C2=A0 gateway 192.168.1.250
>  =C2=A0=C2=A0=C2=A0 vrf firewall
>=20
> =3D=3D
>=20
> Second machine:
>=20
> sysctl -w net.ipv4.ip_forward =3D 1
>=20
> cat /etc/network/interfaces
>=20
> auto eth0
> iface eth0
>  =C2=A0=C2=A0=C2=A0 address 192.168.5.2/24
>=20
> auto eth1
> iface eth1
>  =C2=A0=C2=A0=C2=A0 address 192.168.10.2/24
>  =C2=A0=C2=A0=C2=A0 gateway 192.168.10.1
>=20
> =3D=3D
>=20
> Without issue, if we look at a tcpdump on all interface on the main=20
> machine, everything is fine (output truncated):
>=20
> 10:28:32.811283 eth0 Out IP 192.168.5.1.55750 > 99.99.99.99.80: Flags=20
> [S], seq 2216112145
> 10:28:32.811666 eth1 In=C2=A0 IP 192.168.5.1.55750 > 99.99.99.99.80: Flag=
s=20
> [S], seq 2216112145
> 10:28:32.811679 eth2 Out IP 192.168.1.1.55750 > 99.99.99.99.80: Flags=20
> [S], seq 2216112145
> 10:28:32.835138 eth2 In=C2=A0 IP 99.99.99.99.80 > 192.168.1.1.55750: Flag=
s=20
> [S.], seq 383992840, ack 2216112146
> 10:28:32.835152 eth1 Out IP 99.99.99.99.80 > 192.168.5.1.55750: Flags=20
> [S.], seq 383992840, ack 2216112146
> 10:28:32.835457 eth0 In=C2=A0 IP 99.99.99.99.80 > 192.168.5.1.55750: Flag=
s=20
> [S.], seq 383992840, ack 2216112146
> 10:28:32.835511 eth0 Out IP 192.168.5.1.55750 > 99.99.99.99.80: Flags=20
> [.], ack 1, win 502
>=20
> However when the issue is present, the SYNACK does arrives on eth2, but=20
> is never "unNATed" back to eth1:
>=20
> 10:25:07.644433 eth0 Out IP 192.168.5.1.48684 > 99.99.99.99.80: Flags=20
> [S], seq 3207393154
> 10:25:07.644782 eth1 In=C2=A0 IP 192.168.5.1.48684 > 99.99.99.99.80: Flag=
s=20
> [S], seq 3207393154
> 10:25:07.644793 eth2 Out IP 192.168.1.1.48684 > 99.99.99.99.80: Flags=20
> [S], seq 3207393154
> 10:25:07.668551 eth2 In=C2=A0 IP 54.36.61.42.80 > 192.168.1.1.48684: Flag=
s=20
> [S.], seq 823335485, ack 3207393155
>=20
> The issue is only with TCP connections. UDP or ICMP works fine.
>=20
> Turing off net.ipv4.tcp_l3mdev_accept back to 0 also fix the issue, but=20
> we need this flag since we use some sockets that does not understand VRFs.
>=20
> We did have a look at the diff and the code of inet_bound_dev_eq, but we=
=20
> didn't understand much the real problem - but it does seem now that=20
> bound_dev_if if now checked not to be False before the bound_dev_if =3D=
=3D=20
> dif || bound_dev_if =3D=3D sdif comparison, something that was not the ca=
se=20
> before (especially since it's dependent on l3mdev_accept).
>=20
> Maybe our setup is wrong and we should not be able to route packets like=
=20
> that?
>=20
> Thanks a lot and have a nice day!
>=20
> Maximilien Cuony
>=20
>=20

