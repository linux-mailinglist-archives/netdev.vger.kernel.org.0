Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3099327FB0D
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbgJAIHO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:07:14 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:23098 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731604AbgJAIHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:07:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-NyFMpeS1MquNUIqzQwKA3A-1; Thu, 01 Oct 2020 04:00:39 -0400
X-MC-Unique: NyFMpeS1MquNUIqzQwKA3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EC8B10BBEDC;
        Thu,  1 Oct 2020 08:00:38 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 077055C1CF;
        Thu,  1 Oct 2020 08:00:36 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 05/12] bridge: always put IFLA_LINK for ports with ndo_get_iflink
Date:   Thu,  1 Oct 2020 09:59:29 +0200
Message-Id: <a343c9b6b1b2194df3f9e205b9067c945f240fda.1600770261.git.sd@queasysnail.net>
In-Reply-To: <cover.1600770261.git.sd@queasysnail.net>
References: <cover.1600770261.git.sd@queasysnail.net>
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

Bridge devices try to detect if devices have a lower link when dumping
information about their ports, but that detection doesn't work when
the device and its link have the same ifindex:

For a bridge with the following ports:

    20: veth1@if20: <BROADCAST,MULTICAST> mtu 1500 qdisc noop master bridge0 ...
    22: veth2@if21: <BROADCAST,MULTICAST> mtu 1500 qdisc noop master bridge0 ...

We get this output with the "bridge link" command:

    20: veth1: <BROADCAST,MULTICAST> mtu 1500 master bridge0 ...
    22: veth2@if21: <BROADCAST,MULTICAST> mtu 1500 master bridge0 ...

veth1 should also have "@if20" in bridge link.

Instead of calling dev_get_iflink(), we can use the existence of the
ndo_get_iflink operation (which dev_get_iflink would call) to check if
a device has a lower link.

Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network namespaces.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/bridge/br_netlink.c | 2 +-
 net/core/rtnetlink.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 147d52596e17..6af5d62ddf7b 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -410,7 +410,7 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_OPERSTATE, operstate) ||
 	    (dev->addr_len &&
 	     nla_put(skb, IFLA_ADDRESS, dev->addr_len, dev->dev_addr)) ||
-	    (dev->ifindex != dev_get_iflink(dev) &&
+	    (dev->netdev_ops && dev->netdev_ops->ndo_get_iflink &&
 	     nla_put_u32(skb, IFLA_LINK, dev_get_iflink(dev))))
 		goto nla_put_failure;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a8459fb59ccd..3d8051158890 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4625,7 +4625,7 @@ int ndo_dflt_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 	     nla_put_u32(skb, IFLA_MASTER, br_dev->ifindex)) ||
 	    (dev->addr_len &&
 	     nla_put(skb, IFLA_ADDRESS, dev->addr_len, dev->dev_addr)) ||
-	    (dev->ifindex != dev_get_iflink(dev) &&
+	    (dev->netdev_ops && dev->netdev_ops->ndo_get_iflink &&
 	     nla_put_u32(skb, IFLA_LINK, dev_get_iflink(dev))))
 		goto nla_put_failure;
 
-- 
2.28.0

