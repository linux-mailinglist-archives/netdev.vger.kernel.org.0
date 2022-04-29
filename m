Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763BC51592D
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 01:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381785AbiD2X6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 19:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381721AbiD2X6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 19:58:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA7231531
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 16:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE84623DA
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 23:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06A8C385B2;
        Fri, 29 Apr 2022 23:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651276523;
        bh=j0PPydcYh4Ot30spy72dhf2uaQdErTfyJslyry130xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zw44pSvSG3qbC+KrmEXrcE6D0ilqJbN1LX33GhD0mIXyyIE83XmWnKamdycM8GxQW
         +Dcpz4dqZsOqUAoo4O8tRLI5DOQ+soPlWAzVaHXF0rkROxjWYuUSl8pHz1p2jkRnC4
         WlxG9bSY4wsuhBE59+V4BDnYVr8aN7GcZdjJsqr8yeNiM5oDVIANb1EL6UKBk5DK06
         uzt8JrIUty9qaxfE1E2PaqHon6wmjcrvGrTPZNtPxiOZ+P1CLKnblIKJfCojXeVQcf
         oxJYflKt63QIn6UAblyJssoLzGMCjtIx85NMI3xWw0MmStEelAQV30EM6r+mq96H/l
         kdCUXkUtZYOZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        petrm@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] rtnl: split __rtnl_newlink() into two functions
Date:   Fri, 29 Apr 2022 16:55:07 -0700
Message-Id: <20220429235508.268349-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220429235508.268349-1-kuba@kernel.org>
References: <20220429235508.268349-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__rtnl_newlink() is 250LoC, but has a few clear sections.
Move the part which creates a new netdev to a separate
function.

For ease of review code will be moved in the next change.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/rtnetlink.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 33919fd5c202..1deef11c6b4d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3302,6 +3302,11 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
 	return 0;
 }
 
+static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
+			       const struct rtnl_link_ops *ops,
+			       struct nlattr **tb, struct nlattr **data,
+			       struct netlink_ext_ack *extack);
+
 struct rtnl_newlink_tbs {
 	struct nlattr *tb[IFLA_MAX + 1];
 	struct nlattr *attr[RTNL_MAX_TYPE + 1];
@@ -3312,19 +3317,16 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			  struct rtnl_newlink_tbs *tbs,
 			  struct netlink_ext_ack *extack)
 {
-	unsigned char name_assign_type = NET_NAME_USER;
 	struct nlattr *linkinfo[IFLA_INFO_MAX + 1];
 	struct nlattr ** const tb = tbs->tb;
 	const struct rtnl_link_ops *m_ops;
 	struct net_device *master_dev;
 	struct net *net = sock_net(skb->sk);
 	const struct rtnl_link_ops *ops;
-	struct net *dest_net, *link_net;
 	struct nlattr **slave_data;
 	char kind[MODULE_NAME_LEN];
 	struct net_device *dev;
 	struct ifinfomsg *ifm;
-	char ifname[IFNAMSIZ];
 	struct nlattr **data;
 	bool link_specified;
 	int err;
@@ -3484,6 +3486,21 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EOPNOTSUPP;
 	}
 
+	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack);
+}
+
+static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
+			       const struct rtnl_link_ops *ops,
+			       struct nlattr **tb, struct nlattr **data,
+			       struct netlink_ext_ack *extack)
+{
+	unsigned char name_assign_type = NET_NAME_USER;
+	struct net *net = sock_net(skb->sk);
+	struct net *dest_net, *link_net;
+	struct net_device *dev;
+	char ifname[IFNAMSIZ];
+	int err;
+
 	if (!ops->alloc && !ops->setup)
 		return -EOPNOTSUPP;
 
-- 
2.34.1

