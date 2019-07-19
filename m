Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392BB6E4A3
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 13:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbfGSLAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 07:00:45 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50570 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbfGSLAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 07:00:43 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so28402484wml.0
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 04:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=omF0oatgeQIy4kD7Y7buVEzkWEZlga4YvJNIZczkgI0=;
        b=X0FGcS1Eoek7DjG279tXIxdk3I0prmFZR+6wpTG4jxJR8OTA5UeVSQOV7RF5nOfIP7
         EiFwCPgyVFZxfH4JaQfohdWIhA7FO042wfLqK7H2Z4oO5ERS7dPQU9iAG3+Tai5wCSDY
         gHtuBYy2YVIZg5vOX1tUUweDooSj2VqsdAw3/HlOFfCtyp/BUsW4PFmye7NSmGEGmZ5S
         WrOoNY77L/6oDePq4lAyF3gizCxb0nvh6U/+kKldqoKGs5NsS6VaHGZE1bz2Cz9l4F+C
         jeL7yzA2JUkxNE19ze7rbmk6wY1X9o+zUGnolCVtKeQnZNnZ8BpE9z0MwFN4WppmvWpw
         0NGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=omF0oatgeQIy4kD7Y7buVEzkWEZlga4YvJNIZczkgI0=;
        b=acNGsPoLDQap5CUHqAubs6noXgiFVz/aUU4adOpaBvefDk2HbYQ3Sd9DZzrRlfV91x
         lnNzIQyEr+f36eEXEGroCSrLOt1DtEIt6tABNnmJyOyydkr1GHuUgAW8P546m+CUsWs0
         44GjsRCEPoK9nVOTciqXThfBxRTVEGboBP/KnphT2WaUB4DIiTnmDNkJYB1X31QDUKBS
         C3x9a36Pyt0tv/lFwTLLHVSRSAZVm8Ef+pgr4sL4Mdm4t1pstJb6GVer85Rq93HM02H7
         4MdAQKwXS+rBQyMirab+3DvQ0I12gyEXLrZ0KN2TIvrWSdqZ8fbpkOjNUxW5YKUWcVQw
         PZnw==
X-Gm-Message-State: APjAAAWuQSAJafRWHnOoAqfg3qXzpfggBsU0f4F2QhrQRZpeEOZu6Moh
        FNzu0HWjskWKyrosQGNEXP16988a
X-Google-Smtp-Source: APXvYqxj7zj+4aTJMd381UZNMTkP2wg0eraWg/E+SidsB9z/ipz46Kt16BDBnFoy+ydhsT8LpCshjQ==
X-Received: by 2002:a1c:be19:: with SMTP id o25mr45548582wmf.54.1563534036471;
        Fri, 19 Jul 2019 04:00:36 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id n9sm56359819wrp.54.2019.07.19.04.00.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 04:00:36 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next rfc 6/7] net: rtnetlink: introduce helper to get net_device instance by ifname
Date:   Fri, 19 Jul 2019 13:00:28 +0200
Message-Id: <20190719110029.29466-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719110029.29466-1-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce helper function rtnl_get_dev() that gets net_device structure
instance pointer according to passed ifname or ifname attribute.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/rtnetlink.c | 57 ++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 8994dc858ae0..1fa30d514e3f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2765,6 +2765,23 @@ static int do_setlink(const struct sk_buff *skb,
 	return err;
 }
 
+static struct net_device *rtnl_dev_get(struct net *net,
+				       struct nlattr *ifname_attr,
+				       char *ifname)
+{
+	char buffer[IFNAMSIZ];
+
+	if (!ifname) {
+		ifname = buffer;
+		if (ifname_attr)
+			nla_strlcpy(ifname, ifname_attr, IFNAMSIZ);
+		else
+			return NULL;
+	}
+
+	return __dev_get_by_name(net, ifname);
+}
+
 static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
@@ -2794,7 +2811,7 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME])
-		dev = __dev_get_by_name(net, ifname);
+		dev = rtnl_dev_get(net, NULL, ifname);
 	else
 		goto errout;
 
@@ -2867,7 +2884,6 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *tgt_net = net;
 	struct net_device *dev = NULL;
 	struct ifinfomsg *ifm;
-	char ifname[IFNAMSIZ];
 	struct nlattr *tb[IFLA_MAX+1];
 	int err;
 	int netnsid = -1;
@@ -2881,9 +2897,6 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
-	if (tb[IFLA_IFNAME])
-		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
-
 	if (tb[IFLA_TARGET_NETNSID]) {
 		netnsid = nla_get_s32(tb[IFLA_TARGET_NETNSID]);
 		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
@@ -2896,7 +2909,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(tgt_net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME])
-		dev = __dev_get_by_name(tgt_net, ifname);
+		dev = rtnl_dev_get(net, tb[IFLA_IFNAME], NULL);
 	else if (tb[IFLA_GROUP])
 		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
 	else
@@ -3068,7 +3081,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME])
-		dev = __dev_get_by_name(net, ifname);
+		dev = rtnl_dev_get(net, NULL, ifname);
 	else
 		dev = NULL;
 
@@ -3350,7 +3363,6 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *net = sock_net(skb->sk);
 	struct net *tgt_net = net;
 	struct ifinfomsg *ifm;
-	char ifname[IFNAMSIZ];
 	struct nlattr *tb[IFLA_MAX+1];
 	struct net_device *dev = NULL;
 	struct sk_buff *nskb;
@@ -3373,9 +3385,6 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return PTR_ERR(tgt_net);
 	}
 
-	if (tb[IFLA_IFNAME])
-		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
-
 	if (tb[IFLA_EXT_MASK])
 		ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
 
@@ -3384,7 +3393,7 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(tgt_net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME])
-		dev = __dev_get_by_name(tgt_net, ifname);
+		dev = rtnl_dev_get(tgt_net, tb[IFLA_IFNAME], NULL);
 	else
 		goto out;
 
@@ -3433,16 +3442,12 @@ static int rtnl_newaltifname(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return err;
 
 	ifm = nlmsg_data(nlh);
-	if (ifm->ifi_index > 0) {
+	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	} else if (tb[IFLA_IFNAME]) {
-		char ifname[IFNAMSIZ];
-
-		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
-		dev = __dev_get_by_name(net, ifname);
-	} else {
+	else if (tb[IFLA_IFNAME])
+		dev = rtnl_dev_get(net, tb[IFLA_IFNAME], NULL);
+	else
 		return -EINVAL;
-	}
 
 	if (!dev)
 		return -ENODEV;
@@ -3484,16 +3489,12 @@ static int rtnl_delaltifname(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return err;
 
 	ifm = nlmsg_data(nlh);
-	if (ifm->ifi_index > 0) {
+	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	} else if (tb[IFLA_IFNAME]) {
-		char ifname[IFNAMSIZ];
-
-		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
-		dev = __dev_get_by_name(net, ifname);
-	} else {
+	else if (tb[IFLA_IFNAME])
+		dev = rtnl_dev_get(net, tb[IFLA_IFNAME], NULL);
+	else
 		return -EINVAL;
-	}
 
 	if (!dev)
 		return -ENODEV;
-- 
2.21.0

