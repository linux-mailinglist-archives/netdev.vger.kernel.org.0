Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8704EF7AD
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 18:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239892AbiDAQRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 12:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240237AbiDAQQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 12:16:53 -0400
Received: from olfflo.fourcot.fr (fourcot.fr [217.70.191.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2742CFFF98
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 08:40:41 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, edumazet@google.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Jiri Pirko <jiri@mellanox.com>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: [PATCH net v2] rtnetlink: enable alt_ifname for setlink/newlink
Date:   Fri,  1 Apr 2022 17:39:39 +0200
Message-Id: <20220401153939.19620-1-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

buffer called "ifname" given in function rtnl_dev_get
is always valid when called by setlink/newlink,
but contains only empty string when IFLA_IFNAME is not given. So
IFLA_ALT_IFNAME is always ignored

This patch fixes rtnl_dev_get function with a remove of ifname argument,
and move ifname copy in do_setlink when required

Changes in v2:
 * Remove ifname argument in rtnl_dev_get/do_setlink
   functions (simplify code)

Fixes: 76c9ac0ee878 ("net: rtnetlink: add possibility to use alternative names as message handle")
CC: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
---
 net/core/rtnetlink.c | 65 +++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 37 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index be443cfc77d4..563fdd997f62 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2607,17 +2607,23 @@ static int do_set_proto_down(struct net_device *dev,
 static int do_setlink(const struct sk_buff *skb,
 		      struct net_device *dev, struct ifinfomsg *ifm,
 		      struct netlink_ext_ack *extack,
-		      struct nlattr **tb, char *ifname, int status)
+		      struct nlattr **tb, int status)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
+	char ifname[IFNAMSIZ];
 	int err;
 
 	err = validate_linkmsg(dev, tb, extack);
 	if (err < 0)
 		return err;
 
+	if (tb[IFLA_IFNAME])
+		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
+	else
+		ifname[0] = '\0';
+
 	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD] || tb[IFLA_TARGET_NETNSID]) {
-		const char *pat = ifname && ifname[0] ? ifname : NULL;
+		const char *pat = ifname[0] ? ifname : NULL;
 		struct net *net;
 		int new_ifindex;
 
@@ -2974,20 +2980,16 @@ static int do_setlink(const struct sk_buff *skb,
 
 static struct net_device *rtnl_dev_get(struct net *net,
 				       struct nlattr *ifname_attr,
-				       struct nlattr *altifname_attr,
-				       char *ifname)
+				       struct nlattr *altifname_attr)
 {
-	char buffer[ALTIFNAMSIZ];
+	char ifname[ALTIFNAMSIZ];
 
-	if (!ifname) {
-		ifname = buffer;
-		if (ifname_attr)
-			nla_strscpy(ifname, ifname_attr, IFNAMSIZ);
-		else if (altifname_attr)
-			nla_strscpy(ifname, altifname_attr, ALTIFNAMSIZ);
-		else
-			return NULL;
-	}
+	if (ifname_attr)
+		nla_strscpy(ifname, ifname_attr, IFNAMSIZ);
+	else if (altifname_attr)
+		nla_strscpy(ifname, altifname_attr, ALTIFNAMSIZ);
+	else
+		return NULL;
 
 	return __dev_get_by_name(net, ifname);
 }
@@ -3000,7 +3002,6 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_device *dev;
 	int err;
 	struct nlattr *tb[IFLA_MAX+1];
-	char ifname[IFNAMSIZ];
 
 	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFLA_MAX,
 				     ifla_policy, extack);
@@ -3011,17 +3012,12 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		goto errout;
 
-	if (tb[IFLA_IFNAME])
-		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
-	else
-		ifname[0] = '\0';
-
 	err = -EINVAL;
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
-		dev = rtnl_dev_get(net, NULL, tb[IFLA_ALT_IFNAME], ifname);
+		dev = rtnl_dev_get(net, tb[IFLA_IFNAME], tb[IFLA_ALT_IFNAME]);
 	else
 		goto errout;
 
@@ -3030,7 +3026,7 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto errout;
 	}
 
-	err = do_setlink(skb, dev, ifm, extack, tb, ifname, 0);
+	err = do_setlink(skb, dev, ifm, extack, tb, 0);
 errout:
 	return err;
 }
@@ -3119,8 +3115,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(tgt_net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
-		dev = rtnl_dev_get(net, tb[IFLA_IFNAME],
-				   tb[IFLA_ALT_IFNAME], NULL);
+		dev = rtnl_dev_get(net, tb[IFLA_IFNAME], tb[IFLA_ALT_IFNAME]);
 	else if (tb[IFLA_GROUP])
 		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
 	else
@@ -3262,7 +3257,7 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
 
 	for_each_netdev_safe(net, dev, aux) {
 		if (dev->group == group) {
-			err = do_setlink(skb, dev, ifm, extack, tb, NULL, 0);
+			err = do_setlink(skb, dev, ifm, extack, tb, 0);
 			if (err < 0)
 				return err;
 		}
@@ -3303,16 +3298,11 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
-	if (tb[IFLA_IFNAME])
-		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
-	else
-		ifname[0] = '\0';
-
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
-		dev = rtnl_dev_get(net, NULL, tb[IFLA_ALT_IFNAME], ifname);
+		dev = rtnl_dev_get(net, tb[IFLA_IFNAME], tb[IFLA_ALT_IFNAME]);
 	else
 		dev = NULL;
 
@@ -3413,7 +3403,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			status |= DO_SETLINK_NOTIFY;
 		}
 
-		return do_setlink(skb, dev, ifm, extack, tb, ifname, status);
+		return do_setlink(skb, dev, ifm, extack, tb, status);
 	}
 
 	if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
@@ -3450,7 +3440,10 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!ops->alloc && !ops->setup)
 		return -EOPNOTSUPP;
 
-	if (!ifname[0]) {
+	if (tb[IFLA_IFNAME]) {
+		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
+	}
+	else {
 		snprintf(ifname, IFNAMSIZ, "%s%%d", ops->kind);
 		name_assign_type = NET_NAME_ENUM;
 	}
@@ -3622,8 +3615,7 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(tgt_net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
-		dev = rtnl_dev_get(tgt_net, tb[IFLA_IFNAME],
-				   tb[IFLA_ALT_IFNAME], NULL);
+		dev = rtnl_dev_get(tgt_net, tb[IFLA_IFNAME], tb[IFLA_ALT_IFNAME]);
 	else
 		goto out;
 
@@ -3718,8 +3710,7 @@ static int rtnl_linkprop(int cmd, struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
-		dev = rtnl_dev_get(net, tb[IFLA_IFNAME],
-				   tb[IFLA_ALT_IFNAME], NULL);
+		dev = rtnl_dev_get(net, tb[IFLA_IFNAME], tb[IFLA_ALT_IFNAME]);
 	else
 		return -EINVAL;
 
-- 
2.30.2

