Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1C12A1E3E
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 14:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgKANQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 08:16:47 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:26311 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgKANQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 08:16:47 -0500
Date:   Sun, 01 Nov 2020 13:16:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604236604; bh=W5mDsry01zdm8v+mdkIsMmMzKunu58VfAGfU4PiW1Ng=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=WmM3wlI4r2E6vtJMrBzwgsb84TLDSbiPDFiiofVz+5E/SSW96ktVv6bDUWFBj9pTE
         2JW8RwJO260/MUUijloa82M6wVXuHZVPZqIlyUNCTeTCEBZ9BX67UB3pc5RTwS9k4h
         05/Zn9+oZ0HfERWa/z3Txc7jteF+qvVeMnnSfK0kYu+aUuQlVx/dxLPeR+AGkkY1rT
         nO/LB29ODsLDDR1Cv7q5SOc3ohoiAWzdynp2UyWjT5WjcOUaiQiTAfnnenrZ0jGol1
         OqPt0OpBxK+MuZrIjLoKsSEbntUQn7oKWYgL3xnJDak2FUZ8w+E/aSWTKfyNqy9EzM
         vbhiZH71127hg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next 0/2] net: allow virtual netdevs to forward UDP L4 and fraglist GSO skbs
Message-ID: <NysZRGMkuWq0KPTCJ1Dz2FTjRkeJXDH3edVrsEeJkQI@cp4-web-036.plabs.ch>
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

NETIF_F_GSO_UDP_L4 and NETIF_F_GSO_FRAGLIST allow drivers to offload
GSO UDP L4. This works well on simple setups, but when any logical
netdev (e.g. VLAN) is present, kernel stack always performs software
resegmentation which actually kills the performance.

The full path in such cases is like:
1. Our NIC driver advertises a support for fraglists, GSO UDP L4, GSO
   fraglists.
2. User enables fraglisted GRO via Ethtool.
3. GRO subsystem receives UDP frames from driver and merges the packets
   into fraglisted GSO skb(s).
4. Networking stack queues it up for xmitting.
5. Virtual device like VLAN doesn't advertise a support for GSO UDP L4
   and GSO fraglists, so skb_gso_check() doesn't allow to pass this skb
   as is to the real driver.
6. Kernel then has to form a bunch of regular UDP skbs from that one and
   pass it to the driver instead. This fallback is *extremely* slow for
   any GSO types, but especially for GSO fraglists.
7. All further processing performs with a series of plain UDP skbs, and
   the driver gets it one-by-one, despite that it supports UDP L4 and
   fraglisted GSO.

That's not OK because:
a) logical/virtual netdevs like VLANs, bridges etc. should pass GSO skbs
   as is;
b) even if the final driver doesn't support such type of GSO, this
   software resegmenting should be performed right before it, not in the
   middle of processing -- I think I even saw that note somewhere in
   kernel documentation, and it's totally reasonable in terms of
   performance.

Despite the fact that no mainline drivers currently supports fraglist
GSO, this should and can be easily fixed by adding UDP L4 and fraglist
GSO to the list of GSO types that can be passed-through the logical
interfaces (NETIF_F_GSO_SOFTWARE). After this change, no resegmentation
occurs (if a particular driver supports and advertises this), and the
performance goes on par with e.g. 1:1 forwarding.
The only logical netdevs that seem to be unaffected to this are bridge
interfaces, as their code uses full NETIF_F_GSO_MASK.

Tested on MIPS32 R2 router board with a WIP NIC driver in VLAN NAT:
20 Mbps baseline, 1 Gbps / link speed with this patch.

Since v1 [1]:
 - handle bonding and team drivers as suggested by Willem de Bruijn;
 - reword and expand the introduction with the particular example.=20

[1] https://lore.kernel.org/netdev/Mx3BWGop6fGORN6Cpo4mHIHz2b1bb0eLxeMG8vsi=
jnk@cp3-web-020.plabs.ch

Alexander Lobakin (2):
  net: add GSO UDP L4 and GSO fraglists to the list of software-backed
    types
  net: bonding, dummy, ifb, team: advertise NETIF_F_GSO_SOFTWARE

 drivers/net/bonding/bond_main.c | 11 +++++------
 drivers/net/dummy.c             |  2 +-
 drivers/net/ifb.c               |  3 +--
 drivers/net/team/team.c         |  9 ++++-----
 include/linux/netdev_features.h |  4 ++--
 5 files changed, 13 insertions(+), 16 deletions(-)

--=20
2.29.2


