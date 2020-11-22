Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094382BC63F
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 15:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgKVOvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 09:51:32 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:37880 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgKVOva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 09:51:30 -0500
Date:   Sun, 22 Nov 2020 14:51:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1606056687; bh=VKTi2TdWNmni+nfDPo4i0OtqRh+E2ou4umPgwKFqw7g=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=X2o/z0sO+7JWaMGhDuRp0/0PywWsdFM3N9qQgXUg8SvW5UsMJi/6shwRGz2ODJjEB
         cDSX6v0NkSqVAmB5gaVLafR0d996Ix+00UG3vItjyJztyBbVdxuxo+5ILZ1s4HEqvC
         G1lL21oXKHkob9tYlSyVwUIVyyyRHqbC2/fvQH1mTsZcu4IaPIUa9K77bClZriLsvw
         dQxEhobM34vsenJuebxcIS4/1gvfSjoOMQ1oQcjMqd4n9fDI5DC6ylmy/yDMLn4p3N
         QQUeaAlwwJYADlbApLXtdWMxEtaDRHwaYDuDZa9PlpRFq+WpNOehmgAdX1QoQ9pcuo
         s7vbAkZs3BoGg==
To:     Pablo Neira Ayuso <pablo@netfilter.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, fw@strlen.de,
        razor@blackwall.org, jeremy@azazel.net, tobias@waldekranz.com,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next,v5 0/9] netfilter: flowtable bridge and vlan enhancements
Message-ID: <20201122145108.2640-1-alobakin@pm.me>
In-Reply-To: <20201122102605.2342-1-alobakin@pm.me>
References: <20201122102605.2342-1-alobakin@pm.me>
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
Date: Sun, 22 Nov 2020 12:42:19 +0100

> On Sun, Nov 22, 2020 at 10:26:16AM +0000, Alexander Lobakin wrote:
>> From: Pablo Neira Ayuso <pablo@netfilter.org>
>> Date: Fri, 20 Nov 2020 13:49:12 +0100
> [...]
>>> Something like this:
>>>
>>>                        fast path
>>>                 .------------------------.
>>>                /                          \
>>>                |           IP forwarding   |
>>>                |          /             \  .
>>>                |       br0               eth0
>>>                .       / \
>>>                -- veth1  veth2
>>>                    .
>>>                    .
>>>                    .
>>>                  eth0
>>>            ab:cd:ef:ab:cd:ef
>>>                   VM
>>
>> I'm concerned about bypassing vlan and bridge's .ndo_start_xmit() in
>> case of this shortcut. We'll have incomplete netdevice Tx stats for
>> these two, as it gets updated inside this callbacks.
>
> TX device stats are being updated accordingly.
>
> # ip netns exec nsr1 ip -s link
> 1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN mode DEFAULT group defa=
ult qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>     RX: bytes  packets  errors  dropped overrun mcast  =20
>     0          0        0       0       0       0      =20
>     TX: bytes  packets  errors  dropped carrier collsns=20
>     0          0        0       0       0       0      =20
> 2: veth0@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue st=
ate UP mode DEFAULT group default qlen 1000
>     link/ether 82:0d:f3:b5:59:5d brd ff:ff:ff:ff:ff:ff link-netns ns1
>     RX: bytes  packets  errors  dropped overrun mcast  =20
>     213290848248 4869765  0       0       0       0      =20
>     TX: bytes  packets  errors  dropped carrier collsns=20
>     315346667  4777953  0       0       0       0      =20
> 3: veth1@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue st=
ate UP mode DEFAULT group default qlen 1000
>     link/ether 4a:81:2d:9a:02:88 brd ff:ff:ff:ff:ff:ff link-netns ns2
>     RX: bytes  packets  errors  dropped overrun mcast  =20
>     315337919  4777833  0       0       0       0      =20
>     TX: bytes  packets  errors  dropped carrier collsns=20
>     213290844826 4869708  0       0       0       0      =20
> 4: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP=
 mode DEFAULT group default qlen 1000
>     link/ether 82:0d:f3:b5:59:5d brd ff:ff:ff:ff:ff:ff
>     RX: bytes  packets  errors  dropped overrun mcast  =20
>     4101       73       0       0       0       0      =20
>     TX: bytes  packets  errors  dropped carrier collsns=20
>     5256       74       0       0       0       0      =20

Aren't these counters very low for br0, despite that br0 is an
intermediate point of traffic flow?

> 5: veth0.10@veth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noque=
ue master br0 state UP mode DEFAULT group default qlen 1000
>     link/ether 82:0d:f3:b5:59:5d brd ff:ff:ff:ff:ff:ff
>     RX: bytes  packets  errors  dropped overrun mcast  =20
>     4101       73       0       0       0       62     =20
>     TX: bytes  packets  errors  dropped carrier collsns=20
>     315342363  4777893  0       0       0       0      =20

