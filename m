Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3933D6CF6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 05:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbhG0DBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 23:01:31 -0400
Received: from out0.migadu.com ([94.23.1.103]:33985 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234831AbhG0DB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 23:01:29 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627357315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=poqKW4sfgoEGrYVeAU0N8jftT0m9Cl7NaTtw9j4jui0=;
        b=QPv4HsBB2OZZ/KEnPvD1VD8gc6j7chjAPc71FgqGmyHwPoAaxXr8HQCDlbUXFzvDGxalkv
        YaKyokkYa2pRkkhQbv4tRDmpL7qq17SVPLCrxdaBYIiWljndn5C9mSaO7ANrbNIPAxS2Kq
        XGekOyJ247AnCusw49bT7AvHTfQj86A=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] net: netlink: add the case when nlh is NULL
Date:   Tue, 27 Jul 2021 11:41:41 +0800
Message-Id: <20210727034141.4414-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the case when nlh is NULL in nlmsg_report(),
so that the caller doesn't need to deal with this case.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/net/netlink.h   | 2 +-
 net/core/rtnetlink.c    | 6 +-----
 net/netlink/genetlink.c | 9 ++++-----
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 1ceec518ab49..7a2a9d3144ba 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -885,7 +885,7 @@ static inline int nlmsg_validate_deprecated(const struct nlmsghdr *nlh,
  */
 static inline int nlmsg_report(const struct nlmsghdr *nlh)
 {
-	return !!(nlh->nlmsg_flags & NLM_F_ECHO);
+	return nlh ? !!(nlh->nlmsg_flags & NLM_F_ECHO) : 0;
 }
 
 /**
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 670d74ab91ae..e79aaf1f7139 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -726,12 +726,8 @@ void rtnl_notify(struct sk_buff *skb, struct net *net, u32 pid, u32 group,
 		 struct nlmsghdr *nlh, gfp_t flags)
 {
 	struct sock *rtnl = net->rtnl;
-	int report = 0;
 
-	if (nlh)
-		report = nlmsg_report(nlh);
-
-	nlmsg_notify(rtnl, skb, pid, group, report, flags);
+	nlmsg_notify(rtnl, skb, pid, group, nlmsg_report(nlh), flags);
 }
 EXPORT_SYMBOL(rtnl_notify);
 
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 2d6fdf40df66..24ca93944e5d 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1485,6 +1485,7 @@ int genlmsg_multicast_allns(const struct genl_family *family,
 {
 	if (WARN_ON_ONCE(group >= family->n_mcgrps))
 		return -EINVAL;
+
 	group = family->mcgrp_offset + group;
 	return genlmsg_mcast(skb, portid, group, flags);
 }
@@ -1495,14 +1496,12 @@ void genl_notify(const struct genl_family *family, struct sk_buff *skb,
 {
 	struct net *net = genl_info_net(info);
 	struct sock *sk = net->genl_sock;
-	int report = 0;
-
-	if (info->nlhdr)
-		report = nlmsg_report(info->nlhdr);
 
 	if (WARN_ON_ONCE(group >= family->n_mcgrps))
 		return;
+
 	group = family->mcgrp_offset + group;
-	nlmsg_notify(sk, skb, info->snd_portid, group, report, flags);
+	nlmsg_notify(sk, skb, info->snd_portid, group,
+		     nlmsg_report(info->nlhdr), flags);
 }
 EXPORT_SYMBOL(genl_notify);
-- 
2.32.0

