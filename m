Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1047C24CE
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732198AbfI3QC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:02:26 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:57970 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732190AbfI3QC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:02:26 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTP id 9C764324B62;
        Mon, 30 Sep 2019 18:02:24 +0200 (CEST)
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 1/2] netns: move rtnl_net_get_size() and rtnl_net_fill()
Date:   Mon, 30 Sep 2019 18:02:13 +0200
Message-Id: <20190930160214.4512-2-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
References: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no functional change in this patch, it only prepares the next one
where rtnl_net_newid() will use rtnl_net_get_size() and rtnl_net_fill().

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/core/net_namespace.c | 92 ++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a0e0d298c991..8f5fa5d5becd 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -716,6 +716,52 @@ static const struct nla_policy rtnl_net_policy[NETNSA_MAX + 1] = {
 	[NETNSA_TARGET_NSID]	= { .type = NLA_S32 },
 };
 
+struct net_fill_args {
+	u32 portid;
+	u32 seq;
+	int flags;
+	int cmd;
+	int nsid;
+	bool add_ref;
+	int ref_nsid;
+};
+
+static int rtnl_net_get_size(void)
+{
+	return NLMSG_ALIGN(sizeof(struct rtgenmsg))
+	       + nla_total_size(sizeof(s32)) /* NETNSA_NSID */
+	       + nla_total_size(sizeof(s32)) /* NETNSA_CURRENT_NSID */
+	       ;
+}
+
+static int rtnl_net_fill(struct sk_buff *skb, struct net_fill_args *args)
+{
+	struct nlmsghdr *nlh;
+	struct rtgenmsg *rth;
+
+	nlh = nlmsg_put(skb, args->portid, args->seq, args->cmd, sizeof(*rth),
+			args->flags);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	rth = nlmsg_data(nlh);
+	rth->rtgen_family = AF_UNSPEC;
+
+	if (nla_put_s32(skb, NETNSA_NSID, args->nsid))
+		goto nla_put_failure;
+
+	if (args->add_ref &&
+	    nla_put_s32(skb, NETNSA_CURRENT_NSID, args->ref_nsid))
+		goto nla_put_failure;
+
+	nlmsg_end(skb, nlh);
+	return 0;
+
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
+}
+
 static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 			  struct netlink_ext_ack *extack)
 {
@@ -776,52 +822,6 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-static int rtnl_net_get_size(void)
-{
-	return NLMSG_ALIGN(sizeof(struct rtgenmsg))
-	       + nla_total_size(sizeof(s32)) /* NETNSA_NSID */
-	       + nla_total_size(sizeof(s32)) /* NETNSA_CURRENT_NSID */
-	       ;
-}
-
-struct net_fill_args {
-	u32 portid;
-	u32 seq;
-	int flags;
-	int cmd;
-	int nsid;
-	bool add_ref;
-	int ref_nsid;
-};
-
-static int rtnl_net_fill(struct sk_buff *skb, struct net_fill_args *args)
-{
-	struct nlmsghdr *nlh;
-	struct rtgenmsg *rth;
-
-	nlh = nlmsg_put(skb, args->portid, args->seq, args->cmd, sizeof(*rth),
-			args->flags);
-	if (!nlh)
-		return -EMSGSIZE;
-
-	rth = nlmsg_data(nlh);
-	rth->rtgen_family = AF_UNSPEC;
-
-	if (nla_put_s32(skb, NETNSA_NSID, args->nsid))
-		goto nla_put_failure;
-
-	if (args->add_ref &&
-	    nla_put_s32(skb, NETNSA_CURRENT_NSID, args->ref_nsid))
-		goto nla_put_failure;
-
-	nlmsg_end(skb, nlh);
-	return 0;
-
-nla_put_failure:
-	nlmsg_cancel(skb, nlh);
-	return -EMSGSIZE;
-}
-
 static int rtnl_net_valid_getid_req(struct sk_buff *skb,
 				    const struct nlmsghdr *nlh,
 				    struct nlattr **tb,
-- 
2.23.0

