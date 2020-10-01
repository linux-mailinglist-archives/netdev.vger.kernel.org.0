Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8595727FB14
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbgJAIIJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:08:09 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:23789 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730902AbgJAIIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:08:09 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-tXKJ2mOlNPC8hhpcPpgx8A-1; Thu, 01 Oct 2020 04:00:34 -0400
X-MC-Unique: tXKJ2mOlNPC8hhpcPpgx8A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 169FB9CC0C;
        Thu,  1 Oct 2020 08:00:32 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEA055C1D0;
        Thu,  1 Oct 2020 08:00:28 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 00/12] net: iflink and link-netnsid fixes
Date:   Thu,  1 Oct 2020 09:59:24 +0200
Message-Id: <cover.1600770261.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a lot of places, we use this kind of comparison to detect if a
device has a lower link:

  dev->ifindex != dev_get_iflink(dev)

This seems to be a leftover of the pre-netns days, when the ifindex
was unique over the whole system. Nowadays, with network namespaces,
it's very easy to create a device with the same ifindex as its lower
link:

    ip netns add main
    ip netns add peer
    ip -net main link add dummy0 type dummy
    ip -net main link add link dummy0 macvlan0 netns peer type macvlan
    ip -net main link show type dummy
        9: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop ...
    ip -net peer link show type macvlan
        9: macvlan0@if9: <BROADCAST,MULTICAST> mtu 1500 qdisc noop ...

To detect if a device has a lower link, we can simply check the
existence of the dev->netdev_ops->ndo_get_iflink operation, instead of
checking its return value. In particular, I attempted to fix one of
these checks in commit feadc4b6cf42 ("rtnetlink: always put IFLA_LINK
for links with a link-netnsid"), but this patch isn't correct, since
tunnel devices can export IFLA_LINK_NETNSID without IFLA_LINK. That
patch needs to be reverted.

This series will fix all those bogus comparisons, and export missing
IFLA_LINK_NETNSID attributes in bridge and ipv6 dumps.

ipvlan and geneve are also missing the get_link_net operation, so
userspace can't know when those device are cross-netns. There are a
couple of other device types that have an ndo_get_iflink op but no
get_link_net (virt_wifi, ipoib), and should probably also have a
get_link_net.

Sabrina Dubroca (12):
  ipvlan: add get_link_net
  geneve: add get_link_net
  Revert "rtnetlink: always put IFLA_LINK for links with a link-netnsid"
  rtnetlink: always put IFLA_LINK for links with ndo_get_iflink
  bridge: always put IFLA_LINK for ports with ndo_get_iflink
  bridge: advertise IFLA_LINK_NETNSID when dumping bridge ports
  ipv6: always put IFLA_LINK for devices with ndo_get_iflink
  ipv6: advertise IFLA_LINK_NETNSID when dumping ipv6 addresses
  net: link_watch: fix operstate when the link has the same index as the
    device
  net: link_watch: fix detection of urgent events
  batman-adv: fix iflink detection in batadv_is_on_batman_iface
  batman-adv: fix detection of lower link in batadv_get_real_netdevice

 drivers/net/can/vxcan.c          |  2 +-
 drivers/net/geneve.c             |  8 ++++++++
 drivers/net/ipvlan/ipvlan_main.c |  9 +++++++++
 drivers/net/veth.c               |  2 +-
 include/net/rtnetlink.h          |  4 ++++
 net/batman-adv/hard-interface.c  |  4 ++--
 net/bridge/br_netlink.c          |  4 +++-
 net/core/link_watch.c            |  4 ++--
 net/core/rtnetlink.c             | 25 ++++++++++++-------------
 net/ipv6/addrconf.c              | 11 ++++++++++-
 10 files changed, 52 insertions(+), 21 deletions(-)

-- 
2.28.0

