Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3763CD4AF
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 14:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbhGSLns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 07:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhGSLnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 07:43:47 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07C0C061574;
        Mon, 19 Jul 2021 04:40:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626697464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ymvuQOiwKUSpANGmy6VygBcyGlRswj0psccsffBvtok=;
        b=eCPFUxyKaT0PGkj4bo4HFm2GuN3gDoTjjJKSyHJhsYzoyZFPEPq711H5pPQzxTWsOPKU3X
        QawghvgEyqNzGvG2a53H/OBXKDyISHLeWj7WlVrBSu7jjXtRA3Ukv5ph/2XqKBgxtJw4sM
        AmOhe6ASBKgJaPVRTPC71GL7zxZe5ls=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        nikolay@nvidia.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        courmisch@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH 1/4] rtnetlink: remove rtnetlink_send() in rtnetlink
Date:   Mon, 19 Jul 2021 20:24:07 +0800
Message-Id: <20210719122407.5253-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtnetlink_send() is similar to rtnl_notify(), so remove rtnetlink_send().
Modify the fifth parameter from 'struct nlmsghdr *nlh' to 'int report'
in rtnl_notify(). This will do well for the caller havn't nlh variable.
And modify the return value to integer, Some caller may be need the
return value.

Rename pid to portid to avoid confusion in rtnl_{unicast, notify}.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/linux/rtnetlink.h |  7 +++----
 net/core/rtnetlink.c      | 21 +++++----------------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index bb9cb84114c1..409c334746a6 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -9,10 +9,9 @@
 #include <linux/refcount.h>
 #include <uapi/linux/rtnetlink.h>
 
-extern int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, u32 group, int echo);
-extern int rtnl_unicast(struct sk_buff *skb, struct net *net, u32 pid);
-extern void rtnl_notify(struct sk_buff *skb, struct net *net, u32 pid,
-			u32 group, struct nlmsghdr *nlh, gfp_t flags);
+extern int rtnl_unicast(struct sk_buff *skb, struct net *net, u32 portid);
+extern int rtnl_notify(struct sk_buff *skb, struct net *net, u32 portid,
+		       u32 group, int report, gfp_t flags);
 extern void rtnl_set_sk_err(struct net *net, u32 group, int error);
 extern int rtnetlink_put_metrics(struct sk_buff *skb, u32 *metrics);
 extern int rtnl_put_cacheinfo(struct sk_buff *skb, struct dst_entry *dst,
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 670d74ab91ae..48bb9dc6f06f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -707,31 +707,20 @@ static int rtnl_link_fill(struct sk_buff *skb, const struct net_device *dev)
 	return err;
 }
 
-int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, unsigned int group, int echo)
+int rtnl_unicast(struct sk_buff *skb, struct net *net, u32 portid)
 {
 	struct sock *rtnl = net->rtnl;
 
-	return nlmsg_notify(rtnl, skb, pid, group, echo, GFP_KERNEL);
-}
-
-int rtnl_unicast(struct sk_buff *skb, struct net *net, u32 pid)
-{
-	struct sock *rtnl = net->rtnl;
-
-	return nlmsg_unicast(rtnl, skb, pid);
+	return nlmsg_unicast(rtnl, skb, portid);
 }
 EXPORT_SYMBOL(rtnl_unicast);
 
-void rtnl_notify(struct sk_buff *skb, struct net *net, u32 pid, u32 group,
-		 struct nlmsghdr *nlh, gfp_t flags)
+int rtnl_notify(struct sk_buff *skb, struct net *net, u32 portid,
+		u32 group, int report, gfp_t flags)
 {
 	struct sock *rtnl = net->rtnl;
-	int report = 0;
-
-	if (nlh)
-		report = nlmsg_report(nlh);
 
-	nlmsg_notify(rtnl, skb, pid, group, report, flags);
+	return nlmsg_notify(rtnl, skb, portid, group, report, flags);
 }
 EXPORT_SYMBOL(rtnl_notify);
 
-- 
2.32.0

