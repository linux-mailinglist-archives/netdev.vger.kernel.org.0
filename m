Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7992A3DEDC4
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbhHCMTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:19:35 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:37718 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S235007AbhHCMTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:19:34 -0400
X-UUID: 85d44bc3947a457f9bb65037c55c32b0-20210803
X-UUID: 85d44bc3947a457f9bb65037c55c32b0-20210803
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 493601969; Tue, 03 Aug 2021 20:19:22 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 3 Aug 2021 20:19:20 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 3 Aug 2021 20:19:19 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <rocco.yue@gmail.com>,
        <chao.song@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH net-next] net: add extack arg for link ops
Date:   Tue, 3 Aug 2021 20:02:50 +0800
Message-ID: <20210803120250.32642-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass extack arg to validate_linkmsg and validate_link_af callbacks.
If a netlink attribute has a reject_message, use the extended ack
mechanism to carry the message back to user space.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 include/net/rtnetlink.h | 3 ++-
 net/core/rtnetlink.c    | 9 +++++----
 net/ipv4/devinet.c      | 5 +++--
 net/ipv6/addrconf.c     | 5 +++--
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 384e800665f2..9f48733bfd21 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -153,7 +153,8 @@ struct rtnl_af_ops {
 						    u32 ext_filter_mask);
 
 	int			(*validate_link_af)(const struct net_device *dev,
-						    const struct nlattr *attr);
+						    const struct nlattr *attr,
+						    struct netlink_ext_ack *extack);
 	int			(*set_link_af)(struct net_device *dev,
 					       const struct nlattr *attr,
 					       struct netlink_ext_ack *extack);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f6af3e74fc44..8c78715338b0 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2268,7 +2268,8 @@ static int rtnl_ensure_unique_netns(struct nlattr *tb[],
 	return -EINVAL;
 }
 
-static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[])
+static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[],
+			    struct netlink_ext_ack *extack)
 {
 	if (dev) {
 		if (tb[IFLA_ADDRESS] &&
@@ -2295,7 +2296,7 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[])
 				return -EOPNOTSUPP;
 
 			if (af_ops->validate_link_af) {
-				err = af_ops->validate_link_af(dev, af);
+				err = af_ops->validate_link_af(dev, af, extack);
 				if (err < 0)
 					return err;
 			}
@@ -2603,7 +2604,7 @@ static int do_setlink(const struct sk_buff *skb,
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err;
 
-	err = validate_linkmsg(dev, tb);
+	err = validate_linkmsg(dev, tb, extack);
 	if (err < 0)
 		return err;
 
@@ -3301,7 +3302,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			m_ops = master_dev->rtnl_link_ops;
 	}
 
-	err = validate_linkmsg(dev, tb);
+	err = validate_linkmsg(dev, tb, extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 73721a4448bd..26856064096a 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1950,7 +1950,8 @@ static const struct nla_policy inet_af_policy[IFLA_INET_MAX+1] = {
 };
 
 static int inet_validate_link_af(const struct net_device *dev,
-				 const struct nlattr *nla)
+				 const struct nlattr *nla,
+				 struct netlink_ext_ack *extack)
 {
 	struct nlattr *a, *tb[IFLA_INET_MAX+1];
 	int err, rem;
@@ -1959,7 +1960,7 @@ static int inet_validate_link_af(const struct net_device *dev,
 		return -EAFNOSUPPORT;
 
 	err = nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla,
-					  inet_af_policy, NULL);
+					  inet_af_policy, extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3bf685fe64b9..59792779551e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5784,7 +5784,8 @@ static int check_stable_privacy(struct inet6_dev *idev, struct net *net,
 }
 
 static int inet6_validate_link_af(const struct net_device *dev,
-				  const struct nlattr *nla)
+				  const struct nlattr *nla,
+				  struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[IFLA_INET6_MAX + 1];
 	struct inet6_dev *idev = NULL;
@@ -5797,7 +5798,7 @@ static int inet6_validate_link_af(const struct net_device *dev,
 	}
 
 	err = nla_parse_nested_deprecated(tb, IFLA_INET6_MAX, nla,
-					  inet6_af_policy, NULL);
+					  inet6_af_policy, extack);
 	if (err)
 		return err;
 
-- 
2.18.0

