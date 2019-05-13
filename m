Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F171B74F
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 15:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbfEMNrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 09:47:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbfEMNrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 09:47:06 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 187C988302;
        Mon, 13 May 2019 13:47:06 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.205.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3A7B19C67;
        Mon, 13 May 2019 13:47:02 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Dan Winship <danw@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a link-netnsid
Date:   Mon, 13 May 2019 15:47:17 +0200
Message-Id: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 13 May 2019 13:47:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
iflink == ifindex.

In some cases, a device can be created in a different netns with the
same ifindex as its parent. That device will not dump its IFLA_LINK
attribute, which can confuse some userspace software that expects it.
For example, if the last ifindex created in init_net and foo are both
8, these commands will trigger the issue:

    ip link add parent type dummy                   # ifindex 9
    ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo

So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
always put the IFLA_LINK attribute as well.

Thanks to Dan Winship for analyzing the original OpenShift bug down to
the missing netlink attribute.

Analyzed-by: Dan Winship <danw@redhat.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
v2: change Fixes tag, it's been here forever as Nicolas said, and add his Ack

 net/core/rtnetlink.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2bd12afb9297..adcc045952c2 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1496,14 +1496,15 @@ static int put_master_ifindex(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
-static int nla_put_iflink(struct sk_buff *skb, const struct net_device *dev)
+static int nla_put_iflink(struct sk_buff *skb, const struct net_device *dev,
+			  bool force)
 {
 	int ifindex = dev_get_iflink(dev);
 
-	if (dev->ifindex == ifindex)
-		return 0;
+	if (force || dev->ifindex != ifindex)
+		return nla_put_u32(skb, IFLA_LINK, ifindex);
 
-	return nla_put_u32(skb, IFLA_LINK, ifindex);
+	return 0;
 }
 
 static noinline_for_stack int nla_put_ifalias(struct sk_buff *skb,
@@ -1520,6 +1521,8 @@ static int rtnl_fill_link_netnsid(struct sk_buff *skb,
 				  const struct net_device *dev,
 				  struct net *src_net)
 {
+	bool put_iflink = false;
+
 	if (dev->rtnl_link_ops && dev->rtnl_link_ops->get_link_net) {
 		struct net *link_net = dev->rtnl_link_ops->get_link_net(dev);
 
@@ -1528,10 +1531,12 @@ static int rtnl_fill_link_netnsid(struct sk_buff *skb,
 
 			if (nla_put_s32(skb, IFLA_LINK_NETNSID, id))
 				return -EMSGSIZE;
+
+			put_iflink = true;
 		}
 	}
 
-	return 0;
+	return nla_put_iflink(skb, dev, put_iflink);
 }
 
 static int rtnl_fill_link_af(struct sk_buff *skb,
@@ -1617,7 +1622,6 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 #ifdef CONFIG_RPS
 	    nla_put_u32(skb, IFLA_NUM_RX_QUEUES, dev->num_rx_queues) ||
 #endif
-	    nla_put_iflink(skb, dev) ||
 	    put_master_ifindex(skb, dev) ||
 	    nla_put_u8(skb, IFLA_CARRIER, netif_carrier_ok(dev)) ||
 	    (dev->qdisc &&
-- 
2.21.0

