Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8749627FB10
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbgJAIHS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:07:18 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:25668 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731602AbgJAIHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:07:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-cvmLx2hHODuBMJbnzzTZLA-1; Thu, 01 Oct 2020 04:00:37 -0400
X-MC-Unique: cvmLx2hHODuBMJbnzzTZLA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A257318BE170;
        Thu,  1 Oct 2020 08:00:36 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7B635C1CF;
        Thu,  1 Oct 2020 08:00:35 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 04/12] rtnetlink: always put IFLA_LINK for links with ndo_get_iflink
Date:   Thu,  1 Oct 2020 09:59:28 +0200
Message-Id: <34fa2e8db1eed23297405cd9144afd6c10ccc392.1600770261.git.sd@queasysnail.net>
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

The test that nla_put_iflink() uses to detect whether a device has a
lower link doesn't work with network namespaces, as a device can have
the same ifindex as its parent:

    ip netns add main
    ip netns add peer
    ip -net main link add dummy0 type dummy
    ip -net main link add link dummy0 macvlan0 netns peer type macvlan
    ip -net main link show type dummy
        # 9: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop ...
    ip -net peer link show type macvlan
        # 9: macvlan0@if9: <BROADCAST,MULTICAST> mtu 1500 qdisc noop ...

Instead of calling dev_get_iflink(), we can use the existence of the
ndo_get_iflink operation (which dev_get_iflink would call) to check if
a device has a lower link.

I previously tried to fix this with commit feadc4b6cf42 ("rtnetlink:
always put IFLA_LINK for links with a link-netnsid") but didn't get to
the root of the problem.

Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network namespaces.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/core/rtnetlink.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index c35b3f02b4f9..a8459fb59ccd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1549,12 +1549,13 @@ static int put_master_ifindex(struct sk_buff *skb, struct net_device *dev)
 
 static int nla_put_iflink(struct sk_buff *skb, const struct net_device *dev)
 {
-	int ifindex = dev_get_iflink(dev);
+	if (dev->netdev_ops && dev->netdev_ops->ndo_get_iflink) {
+		int ifindex = dev->netdev_ops->ndo_get_iflink(dev);
 
-	if (dev->ifindex == ifindex)
-		return 0;
+		return nla_put_u32(skb, IFLA_LINK, ifindex);
+	}
 
-	return nla_put_u32(skb, IFLA_LINK, ifindex);
+	return 0;
 }
 
 static noinline_for_stack int nla_put_ifalias(struct sk_buff *skb,
-- 
2.28.0

