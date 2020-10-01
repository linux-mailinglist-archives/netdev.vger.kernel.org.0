Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7896027FB12
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731602AbgJAIHX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:07:23 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:32162 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731599AbgJAIHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:07:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-69hJf2bWPKeeqIMgWn5mVw-1; Thu, 01 Oct 2020 04:00:36 -0400
X-MC-Unique: 69hJf2bWPKeeqIMgWn5mVw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8027E9CC01;
        Thu,  1 Oct 2020 08:00:35 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B42D65E1DD;
        Thu,  1 Oct 2020 08:00:34 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 03/12] Revert "rtnetlink: always put IFLA_LINK for links with a link-netnsid"
Date:   Thu,  1 Oct 2020 09:59:27 +0200
Message-Id: <da756c4eac820bccb4e7f3cc8d8afee9eac03401.1600770261.git.sd@queasysnail.net>
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

This reverts commit feadc4b6cf42a53a8a93c918a569a0b7e62bd350.

It fixed the particular issue that was seen in the OpenShift setup,
but ignored the case of tunnels like VXLAN, which export a
IFLA_LINK_NETNSID attribute but don't have an IFLA_LINK.

In case a vxlan device is created in one netns, then moved to another,
we end up seeing:

  # ip -net foo link
  15: vxlan1@if15: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
             ^

The next patch will fix the original problem properly.

Fixes: feadc4b6cf42 ("rtnetlink: always put IFLA_LINK for links with a link-netnsid")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/core/rtnetlink.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 68e0682450c6..c35b3f02b4f9 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1547,15 +1547,14 @@ static int put_master_ifindex(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
-static int nla_put_iflink(struct sk_buff *skb, const struct net_device *dev,
-			  bool force)
+static int nla_put_iflink(struct sk_buff *skb, const struct net_device *dev)
 {
 	int ifindex = dev_get_iflink(dev);
 
-	if (force || dev->ifindex != ifindex)
-		return nla_put_u32(skb, IFLA_LINK, ifindex);
+	if (dev->ifindex == ifindex)
+		return 0;
 
-	return 0;
+	return nla_put_u32(skb, IFLA_LINK, ifindex);
 }
 
 static noinline_for_stack int nla_put_ifalias(struct sk_buff *skb,
@@ -1572,8 +1571,6 @@ static int rtnl_fill_link_netnsid(struct sk_buff *skb,
 				  const struct net_device *dev,
 				  struct net *src_net, gfp_t gfp)
 {
-	bool put_iflink = false;
-
 	if (dev->rtnl_link_ops && dev->rtnl_link_ops->get_link_net) {
 		struct net *link_net = dev->rtnl_link_ops->get_link_net(dev);
 
@@ -1582,12 +1579,10 @@ static int rtnl_fill_link_netnsid(struct sk_buff *skb,
 
 			if (nla_put_s32(skb, IFLA_LINK_NETNSID, id))
 				return -EMSGSIZE;
-
-			put_iflink = true;
 		}
 	}
 
-	return nla_put_iflink(skb, dev, put_iflink);
+	return 0;
 }
 
 static int rtnl_fill_link_af(struct sk_buff *skb,
@@ -1738,6 +1733,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
+	    nla_put_iflink(skb, dev) ||
 	    put_master_ifindex(skb, dev) ||
 	    nla_put_u8(skb, IFLA_CARRIER, netif_carrier_ok(dev)) ||
 	    (dev->qdisc &&
-- 
2.28.0

