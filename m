Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E1A51592B
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 01:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381846AbiD2X6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 19:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381721AbiD2X6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 19:58:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A4E31531
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 16:55:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B293AB837F5
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 23:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36758C385B1;
        Fri, 29 Apr 2022 23:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651276523;
        bh=jXrqeezgsTJnRf/V6NJcs543ZUkDPOeDbTSdA0C7T8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwlnDr5hZtyJVEJn8dxq/mrr7edPcyqx49tMYcmtkrTl7GHJbylcbyfQZZHF3dLky
         uv4u6gqfsbK9klaVlDh/+6CUViX6h9IG44WaCDxUQVow9xfEP/bi15L0lmFf38byhC
         hR0kw2BBFplQP+ICHpkFOA/rX1s6QaApH2+3wO6RRll7MzBwnp+Wsk8WJTgK3azfGn
         0VBE9RE/NGcg1mY2xGHksp1I5uTzalr26wAk7Po1jnTbuWCGkPkupqmUv2nuSlxkrM
         3Gqh43wb9iFoCmrPeaQAI+KW29RsS3pQn4sgoBdCw/r7KLH+8nb+3b3IntDxuNxzus
         fDRYjDhYP5uDw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        petrm@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] rtnl: move rtnl_newlink_create()
Date:   Fri, 29 Apr 2022 16:55:08 -0700
Message-Id: <20220429235508.268349-4-kuba@kernel.org>
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

Pure code move.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/rtnetlink.c | 177 +++++++++++++++++++++----------------------
 1 file changed, 86 insertions(+), 91 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1deef11c6b4d..eea5ed09e1bb 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3305,7 +3305,92 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
 static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 			       const struct rtnl_link_ops *ops,
 			       struct nlattr **tb, struct nlattr **data,
-			       struct netlink_ext_ack *extack);
+			       struct netlink_ext_ack *extack)
+{
+	unsigned char name_assign_type = NET_NAME_USER;
+	struct net *net = sock_net(skb->sk);
+	struct net *dest_net, *link_net;
+	struct net_device *dev;
+	char ifname[IFNAMSIZ];
+	int err;
+
+	if (!ops->alloc && !ops->setup)
+		return -EOPNOTSUPP;
+
+	if (tb[IFLA_IFNAME]) {
+		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
+	} else {
+		snprintf(ifname, IFNAMSIZ, "%s%%d", ops->kind);
+		name_assign_type = NET_NAME_ENUM;
+	}
+
+	dest_net = rtnl_link_get_net_capable(skb, net, tb, CAP_NET_ADMIN);
+	if (IS_ERR(dest_net))
+		return PTR_ERR(dest_net);
+
+	if (tb[IFLA_LINK_NETNSID]) {
+		int id = nla_get_s32(tb[IFLA_LINK_NETNSID]);
+
+		link_net = get_net_ns_by_id(dest_net, id);
+		if (!link_net) {
+			NL_SET_ERR_MSG(extack, "Unknown network namespace id");
+			err =  -EINVAL;
+			goto out;
+		}
+		err = -EPERM;
+		if (!netlink_ns_capable(skb, link_net->user_ns, CAP_NET_ADMIN))
+			goto out;
+	} else {
+		link_net = NULL;
+	}
+
+	dev = rtnl_create_link(link_net ? : dest_net, ifname,
+			       name_assign_type, ops, tb, extack);
+	if (IS_ERR(dev)) {
+		err = PTR_ERR(dev);
+		goto out;
+	}
+
+	dev->ifindex = ifm->ifi_index;
+
+	if (ops->newlink)
+		err = ops->newlink(link_net ? : net, dev, tb, data, extack);
+	else
+		err = register_netdevice(dev);
+	if (err < 0) {
+		free_netdev(dev);
+		goto out;
+	}
+
+	err = rtnl_configure_link(dev, ifm);
+	if (err < 0)
+		goto out_unregister;
+	if (link_net) {
+		err = dev_change_net_namespace(dev, dest_net, ifname);
+		if (err < 0)
+			goto out_unregister;
+	}
+	if (tb[IFLA_MASTER]) {
+		err = do_set_master(dev, nla_get_u32(tb[IFLA_MASTER]), extack);
+		if (err)
+			goto out_unregister;
+	}
+out:
+	if (link_net)
+		put_net(link_net);
+	put_net(dest_net);
+	return err;
+out_unregister:
+	if (ops->newlink) {
+		LIST_HEAD(list_kill);
+
+		ops->dellink(dev, &list_kill);
+		unregister_netdevice_many(&list_kill);
+	} else {
+		unregister_netdevice(dev);
+	}
+	goto out;
+}
 
 struct rtnl_newlink_tbs {
 	struct nlattr *tb[IFLA_MAX + 1];
@@ -3489,96 +3574,6 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return rtnl_newlink_create(skb, ifm, ops, tb, data, extack);
 }
 
-static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
-			       const struct rtnl_link_ops *ops,
-			       struct nlattr **tb, struct nlattr **data,
-			       struct netlink_ext_ack *extack)
-{
-	unsigned char name_assign_type = NET_NAME_USER;
-	struct net *net = sock_net(skb->sk);
-	struct net *dest_net, *link_net;
-	struct net_device *dev;
-	char ifname[IFNAMSIZ];
-	int err;
-
-	if (!ops->alloc && !ops->setup)
-		return -EOPNOTSUPP;
-
-	if (tb[IFLA_IFNAME]) {
-		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
-	} else {
-		snprintf(ifname, IFNAMSIZ, "%s%%d", ops->kind);
-		name_assign_type = NET_NAME_ENUM;
-	}
-
-	dest_net = rtnl_link_get_net_capable(skb, net, tb, CAP_NET_ADMIN);
-	if (IS_ERR(dest_net))
-		return PTR_ERR(dest_net);
-
-	if (tb[IFLA_LINK_NETNSID]) {
-		int id = nla_get_s32(tb[IFLA_LINK_NETNSID]);
-
-		link_net = get_net_ns_by_id(dest_net, id);
-		if (!link_net) {
-			NL_SET_ERR_MSG(extack, "Unknown network namespace id");
-			err =  -EINVAL;
-			goto out;
-		}
-		err = -EPERM;
-		if (!netlink_ns_capable(skb, link_net->user_ns, CAP_NET_ADMIN))
-			goto out;
-	} else {
-		link_net = NULL;
-	}
-
-	dev = rtnl_create_link(link_net ? : dest_net, ifname,
-			       name_assign_type, ops, tb, extack);
-	if (IS_ERR(dev)) {
-		err = PTR_ERR(dev);
-		goto out;
-	}
-
-	dev->ifindex = ifm->ifi_index;
-
-	if (ops->newlink)
-		err = ops->newlink(link_net ? : net, dev, tb, data, extack);
-	else
-		err = register_netdevice(dev);
-	if (err < 0) {
-		free_netdev(dev);
-		goto out;
-	}
-
-	err = rtnl_configure_link(dev, ifm);
-	if (err < 0)
-		goto out_unregister;
-	if (link_net) {
-		err = dev_change_net_namespace(dev, dest_net, ifname);
-		if (err < 0)
-			goto out_unregister;
-	}
-	if (tb[IFLA_MASTER]) {
-		err = do_set_master(dev, nla_get_u32(tb[IFLA_MASTER]), extack);
-		if (err)
-			goto out_unregister;
-	}
-out:
-	if (link_net)
-		put_net(link_net);
-	put_net(dest_net);
-	return err;
-out_unregister:
-	if (ops->newlink) {
-		LIST_HEAD(list_kill);
-
-		ops->dellink(dev, &list_kill);
-		unregister_netdevice_many(&list_kill);
-	} else {
-		unregister_netdevice(dev);
-	}
-	goto out;
-}
-
 static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
-- 
2.34.1

