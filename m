Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECAF300C24
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 20:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbhAVSk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:40:27 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:33323 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729718AbhAVSUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:20:32 -0500
Date:   Fri, 22 Jan 2021 18:19:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611339579; bh=TsNQKfFUZNXIM9ZUMAeIVxKZu6S8ylpuCSw1nnn8SbM=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=C3KAe5+IPr9Wud481J+6zbql8NGCUpZ7QlgtHbd4MDu4q18hobg1Hn2dYteuBla/r
         pL1joKyGcD2A++AL2EbP87HIn3i7lPxlm3KMH/5Y6jCUtG3V+4j+V00DKk6Y2suI2h
         HFyiey7g2CNCETwPe5GdoH/8snrIEwfzH/mePfsJP7NM34THNB7keNHeUBo6KGa1+3
         KJt4Yb8ber7nthy8I1nwCYSFGNatrLH5dn1/u6M1aEdYoqP2bhyKMMeYDaN8qXKffL
         JOXBO4IOke3iT3dG+HYtPdJfgob7HzSZygkEnnNlDf52w6o4BLCDBFQN1ORcoi6DPr
         KNu39ezQYiHSA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Igor Russkikh <irusskikh@marvell.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v4 net-next 0/2] udp: allow forwarding of plain (non-fraglisted) UDP GRO packets
Message-ID: <20210122181909.36340-1-alobakin@pm.me>
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

This series allows to form UDP GRO packets in cases without sockets
(for forwarding). To not change the current datapath, this is
performed only when the new corresponding netdev feature is enabled
via Ethtool (and fraglisted GRO is disabled).
Prior to this point, only fraglisted UDP GRO was available. Plain UDP
GRO shows better forwarding performance when a target NIC is capable
of GSO UDP offload.

Since v3 [2]:
 - rename introduced netdev feature to reflect that it targets
   forwarding and don't touch fraglisted GRO at all (Willem de Bruijn).

Since v2 [1]:
 - convert to a series;
 - new: add new netdev_feature to explicitly enable/disable UDP GRO
   when there is no socket, defaults to off (Paolo Abeni).

Since v1 [0]:
 - drop redundant 'if (sk)' check (Alexander Duyck);
 - add a ref in the commit message to one more commit that was
   an important step for UDP GRO forwarding.

[0] https://lore.kernel.org/netdev/20210112211536.261172-1-alobakin@pm.me
[1] https://lore.kernel.org/netdev/20210113103232.4761-1-alobakin@pm.me
[2] https://lore.kernel.org/netdev/20210118193122.87271-1-alobakin@pm.me

Alexander Lobakin (2):
  net: introduce a netdev feature for UDP GRO forwarding
  udp: allow forwarding of plain (non-fraglisted) UDP GRO packets

 include/linux/netdev_features.h | 4 +++-
 net/ethtool/common.c            | 1 +
 net/ipv4/udp_offload.c          | 3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

--=20
2.30.0


