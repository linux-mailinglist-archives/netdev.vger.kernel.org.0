Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB5427FB0F
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbgJAIHF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:07:05 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:40344 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730534AbgJAIHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:07:04 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-17nANtxkPeWVclLZgalo2g-1; Thu, 01 Oct 2020 04:00:41 -0400
X-MC-Unique: 17nANtxkPeWVclLZgalo2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D15A58070FD;
        Thu,  1 Oct 2020 08:00:40 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1359D5C1CF;
        Thu,  1 Oct 2020 08:00:39 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 07/12] ipv6: always put IFLA_LINK for devices with ndo_get_iflink
Date:   Thu,  1 Oct 2020 09:59:31 +0200
Message-Id: <9ccee167b001a643109fcb61130e32ccf96080ee.1600770261.git.sd@queasysnail.net>
In-Reply-To: <cover.1600770261.git.sd@queasysnail.net>
References: <cover.1600770261.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 tries to detect if devices have a lower link when dumping
addresses, but that detection doesn't work when the device and its
link have the same ifindex.

In this setup:
    ip netns add main
    ip netns add peer
    ip -net main link add dummy0 type dummy # ifidx 9
    ip -net main link add link dummy0 macvlan0 up netns peer type macvlan # ifidx 9

We'll get:
    ip -net peer -6 a
        9: macvlan0: <snip>

Instead of:
    ip -net peer -6 a
        9: macvlan0@if9: <snip>

Instead of calling dev_get_iflink(), we can use the existence of the
ndo_get_iflink operation (which dev_get_iflink would call) to check if
a device has a lower link.

Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network namespaces.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv6/addrconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 01146b66d666..688e441a8699 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5835,7 +5835,7 @@ static int inet6_fill_ifinfo(struct sk_buff *skb, struct inet6_dev *idev,
 	    (dev->addr_len &&
 	     nla_put(skb, IFLA_ADDRESS, dev->addr_len, dev->dev_addr)) ||
 	    nla_put_u32(skb, IFLA_MTU, dev->mtu) ||
-	    (dev->ifindex != dev_get_iflink(dev) &&
+	    (dev->netdev_ops && dev->netdev_ops->ndo_get_iflink &&
 	     nla_put_u32(skb, IFLA_LINK, dev_get_iflink(dev))) ||
 	    nla_put_u8(skb, IFLA_OPERSTATE,
 		       netif_running(dev) ? dev->operstate : IF_OPER_DOWN))
-- 
2.28.0

