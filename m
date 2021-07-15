Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0758C3C9E6C
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 14:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbhGOMQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 08:16:32 -0400
Received: from out2.migadu.com ([188.165.223.204]:10232 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235490AbhGOMQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 08:16:30 -0400
X-Greylist: delayed 97199 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2021 08:16:29 EDT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626351215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H2Yw9AN3KwBdHFnlDR1STrMLBYZe8oyuXo4MVMd+q78=;
        b=KKpiLUaOAyU+5gx/aRHFbL6OJzRtrB9mE20u3+ErGTvzCetVsnseony6tpJEMiXsMaQPyk
        3Gb87FhQDLQF3aKtV3N2cgj9KPlmTP8hhNxMXNmC9GHLB0gq7ufABjyjlbUn47Fl9Jdr6T
        958Cfpphz3KoRR+M7nz+aO/OXgG3Wqc=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        johannes.berg@intel.com, avagin@gmail.com, ryazanov.s.a@gmail.com,
        vladimir.oltean@nxp.com, roopa@cumulusnetworks.com,
        yajun.deng@linux.dev, zhudi21@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] rtnetlink: use nlmsg_notify() in rtnetlink_send()
Date:   Thu, 15 Jul 2021 20:12:57 +0800
Message-Id: <20210715121258.18385-2-yajun.deng@linux.dev>
In-Reply-To: <20210715121258.18385-1-yajun.deng@linux.dev>
References: <20210715121258.18385-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netlink_{broadcast, unicast} don't deal with 'if (err > 0' statement
but nlmsg_{multicast, unicast} do. The nlmsg_notify() contains them.
so use nlmsg_notify() instead. so that the caller wouldn't deal with
'if (err > 0' statement.

v2: use nlmsg_notify() will do well.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/rtnetlink.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f6af3e74fc44..670d74ab91ae 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -710,15 +710,8 @@ static int rtnl_link_fill(struct sk_buff *skb, const struct net_device *dev)
 int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, unsigned int group, int echo)
 {
 	struct sock *rtnl = net->rtnl;
-	int err = 0;
 
-	NETLINK_CB(skb).dst_group = group;
-	if (echo)
-		refcount_inc(&skb->users);
-	netlink_broadcast(rtnl, skb, pid, group, GFP_KERNEL);
-	if (echo)
-		err = netlink_unicast(rtnl, skb, pid, MSG_DONTWAIT);
-	return err;
+	return nlmsg_notify(rtnl, skb, pid, group, echo, GFP_KERNEL);
 }
 
 int rtnl_unicast(struct sk_buff *skb, struct net *net, u32 pid)
-- 
2.32.0

