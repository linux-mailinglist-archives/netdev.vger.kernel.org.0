Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970D73C7085
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbhGMMkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbhGMMkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:40:24 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4D2C0613DD;
        Tue, 13 Jul 2021 05:37:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626179853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qJ5CyNueUybotmlLBmn5JE2YvYoFs1ygZR7RwARKtQM=;
        b=SnXtWje0E+4InJjXswWfj1lpFZkcgXr1DE1I446vKeBIFrHsiqzBF3O4JQCdQ/6Z8dvpkP
        5RRVi3yl2ETiIsTba7/GNq8cZWhU1hdOYFcNFW90il2/pQnYUcN49DRtAUbu0KaRJt/bwZ
        aB2tHoCtRe/7mVpnQ9uCnnLFu/FUGPA=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, yajun.deng@linux.dev,
        johannes.berg@intel.com, ryazanov.s.a@gmail.com, avagin@gmail.com,
        vladimir.oltean@nxp.com, roopa@cumulusnetworks.com,
        zhudi21@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/2] rtnetlink: use nlmsg_{multicast, unicast} instead of netlink_{broadcast,unicast}
Date:   Tue, 13 Jul 2021 20:36:53 +0800
Message-Id: <20210713123654.31174-2-yajun.deng@linux.dev>
In-Reply-To: <20210713123654.31174-1-yajun.deng@linux.dev>
References: <20210713123654.31174-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has a 'NETLINK_CB(' statement in nlmsg_multicast() and has 'if (err'
in nlmsg_{multicast, unicast}, use nlmsg_{multicast, unicast} instead
of netlink_{broadcast,unicast}. so the caller would not deal with the
'if (err >0 )' statement. Add the return value for nlmsg_multicast.
As also, rename rtnetlink_send() to rtnl_send(), this makes style
uniform.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/linux/rtnetlink.h |  2 +-
 net/core/rtnetlink.c      | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index bb9cb84114c1..60bef82e42ab 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -9,7 +9,7 @@
 #include <linux/refcount.h>
 #include <uapi/linux/rtnetlink.h>
 
-extern int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, u32 group, int echo);
+extern int rtnl_send(struct sk_buff *skb, struct net *net, u32 pid, u32 group, int echo);
 extern int rtnl_unicast(struct sk_buff *skb, struct net *net, u32 pid);
 extern void rtnl_notify(struct sk_buff *skb, struct net *net, u32 pid,
 			u32 group, struct nlmsghdr *nlh, gfp_t flags);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f6af3e74fc44..c081d607bb69 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -707,17 +707,18 @@ static int rtnl_link_fill(struct sk_buff *skb, const struct net_device *dev)
 	return err;
 }
 
-int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, unsigned int group, int echo)
+int rtnl_send(struct sk_buff *skb, struct net *net, u32 pid, unsigned int group, int echo)
 {
 	struct sock *rtnl = net->rtnl;
 	int err = 0;
 
-	NETLINK_CB(skb).dst_group = group;
-	if (echo)
+	err = nlmsg_multicast(rtnl, skb, pid, group, GFP_KERNEL);
+
+	if (echo) {
 		refcount_inc(&skb->users);
-	netlink_broadcast(rtnl, skb, pid, group, GFP_KERNEL);
-	if (echo)
-		err = netlink_unicast(rtnl, skb, pid, MSG_DONTWAIT);
+		err = nlmsg_unicast(rtnl, skb, pid);
+	}
+
 	return err;
 }
 
-- 
2.32.0

