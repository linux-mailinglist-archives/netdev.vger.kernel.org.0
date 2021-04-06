Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE27A355F91
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245120AbhDFXkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbhDFXkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 19:40:12 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19071C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 16:40:04 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id z16so4212939pga.1
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 16:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JZd8GODVkhFncUO9a6Ot4fQsFb+nworE7PsY3uHiXaQ=;
        b=xv/bytPrFq6kDj4/mVsQ5wW2pC4D2dNrnIGkeNFFM8Y4wd1XCeu3j7k7STDgmYMl13
         6iltPzBeLTsM4tUHvXXRAwZU/BHOaowucbHClZcMe1jZ8w7qB46Gd9+fRDGKFgQiKVPH
         kTJex7ZOW+9RV8PLDnAqV95zl7bEtv8pnTpnkKlXf4OQmitfhrqQECU1Qtd6MMQhTLx+
         8CGNFmbpK0f/y0TWJPvien9kxyn2dywaLsrL8i422CXJ3iIH9GLVQefLlJaqPM10MJJN
         ZxVtC0xH4AZBruUmudKQwn6Y++bXOwAHX4/T3G/tTziyfScP7aYb/EJXCuqB/Cd6zTJp
         x8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JZd8GODVkhFncUO9a6Ot4fQsFb+nworE7PsY3uHiXaQ=;
        b=dOM71fZjJkTUHiOCXh/SGjxmJYeptx68CSZIhdVOxCOZXCCRoN0CsFONfj+jKPAiMs
         PVNSNDpt9ryjzBhGQApuUJvfSleyOqKHzLpITttG6KH7iagyvyb4EOrnPq+Xenj2wuW9
         W5FISo6TQe+l2nGARbZJSoU/3kl40n881Y8AQhhX1UsrdD/18profvg+qxY9cJo262N+
         1SZE1jU9FgOoTruXOwTLw8s07bjBSLpUBBVURZL/uHA5O6jDavJ6jHuyJKDML644DWsn
         m2gtejyWTJrymsQ6A2tCmcMww4ZaM0fBLXNh3GEPOelcDsfnoVzlFm6uJ2IeJB2ZjP14
         Es/Q==
X-Gm-Message-State: AOAM530NIu4JNvpLmw3T7uOLuK5uVeMpv+6ly1miONPSYc2J6gG7cago
        NVSC5FI+jZxLA8spZ14xiWHC9uZOTryNqw==
X-Google-Smtp-Source: ABdhPJxIU6vsgEu9b63udp5PsTDkSWnSDHxPTAwOUET0kDB67raWAdbGgcL7u0Y8jdhiCLJM67gSWw==
X-Received: by 2002:a63:4c0e:: with SMTP id z14mr613259pga.30.1617752402976;
        Tue, 06 Apr 2021 16:40:02 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id w191sm20667475pfd.25.2021.04.06.16.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 16:40:02 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hongren Zheng <li@zenithal.me>
Subject: [PATCH net-next] ipv6: report errors for iftoken via netlink extack
Date:   Tue,  6 Apr 2021 16:39:54 -0700
Message-Id: <20210406233954.217139-1-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

Setting iftoken can fail for several different reasons but there
and there was no report to user as to the cause. Add netlink
extended errors to the processing of the request.

This requires adding additional argument through rtnl_af_ops
set_link_af callback.

Reported-by: Hongren Zheng <li@zenithal.me>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/net/rtnetlink.h |  4 ++--
 net/core/rtnetlink.c    |  2 +-
 net/ipv4/devinet.c      |  3 ++-
 net/ipv6/addrconf.c     | 32 ++++++++++++++++++++++++++------
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 4da61c950e93..479f60ef54c0 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -147,8 +147,8 @@ struct rtnl_af_ops {
 	int			(*validate_link_af)(const struct net_device *dev,
 						    const struct nlattr *attr);
 	int			(*set_link_af)(struct net_device *dev,
-					       const struct nlattr *attr);
-
+					       const struct nlattr *attr,
+					       struct netlink_ext_ack *extack);
 	int			(*fill_stats_af)(struct sk_buff *skb,
 						 const struct net_device *dev);
 	size_t			(*get_stats_af_size)(const struct net_device *dev);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d51252afde0a..641c2bd0e221 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2874,7 +2874,7 @@ static int do_setlink(const struct sk_buff *skb,
 
 			BUG_ON(!(af_ops = rtnl_af_lookup(nla_type(af))));
 
-			err = af_ops->set_link_af(dev, af);
+			err = af_ops->set_link_af(dev, af, extack);
 			if (err < 0) {
 				rcu_read_unlock();
 				goto errout;
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 75f67994fc85..2e35f68da40a 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1978,7 +1978,8 @@ static int inet_validate_link_af(const struct net_device *dev,
 	return 0;
 }
 
-static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla)
+static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla,
+			    struct netlink_ext_ack *extack)
 {
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
 	struct nlattr *a, *tb[IFLA_INET_MAX+1];
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 120073ffb666..1afd4bdc0d5b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5672,7 +5672,8 @@ static int inet6_fill_link_af(struct sk_buff *skb, const struct net_device *dev,
 	return 0;
 }
 
-static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token)
+static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token,
+			     struct netlink_ext_ack *extack)
 {
 	struct inet6_ifaddr *ifp;
 	struct net_device *dev = idev->dev;
@@ -5683,12 +5684,29 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token)
 
 	if (!token)
 		return -EINVAL;
-	if (dev->flags & (IFF_LOOPBACK | IFF_NOARP))
+
+	if (dev->flags & IFF_LOOPBACK) {
+		NL_SET_ERR_MSG_MOD(extack, "Device is loopback");
 		return -EINVAL;
-	if (!ipv6_accept_ra(idev))
+	}
+
+	if (dev->flags & IFF_NOARP) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device does not do neighbour discovery");
+		return -EINVAL;
+	}
+
+	if (!ipv6_accept_ra(idev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Router advertisement is disabled on device");
 		return -EINVAL;
-	if (idev->cnf.rtr_solicits == 0)
+	}
+
+	if (idev->cnf.rtr_solicits == 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Router solicitation is disabled on device"));
 		return -EINVAL;
+	}
 
 	write_lock_bh(&idev->lock);
 
@@ -5796,7 +5814,8 @@ static int inet6_validate_link_af(const struct net_device *dev,
 	return 0;
 }
 
-static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla)
+static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla,
+			     struct netlink_ext_ack *extack)
 {
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	struct nlattr *tb[IFLA_INET6_MAX + 1];
@@ -5809,7 +5828,8 @@ static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla)
 		BUG();
 
 	if (tb[IFLA_INET6_TOKEN]) {
-		err = inet6_set_iftoken(idev, nla_data(tb[IFLA_INET6_TOKEN]));
+		err = inet6_set_iftoken(idev, nla_data(tb[IFLA_INET6_TOKEN]),
+					extack);
 		if (err)
 			return err;
 	}
-- 
2.30.2

