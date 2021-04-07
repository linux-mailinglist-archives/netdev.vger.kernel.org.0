Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5C9357140
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 18:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243271AbhDGP7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354126AbhDGP7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 11:59:35 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28202C061756
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 08:59:25 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t24so5968087pjw.4
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 08:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DpB/I3hsJfInErSI6XP+V1fS0jFYk2FPtdF9VIzTjVE=;
        b=YB74zvd0ir0HBGori7A27meYl5U372zwMJSF6jnlcqEOc2D5DiGZN4kAJftKcsLvUo
         4MZ5BVXZLVsb9X+HTD3ggoi957Pkw+KAOC7a/MrK8pRl+d3H94dtbMEJTV9hbGx7Y7ny
         0j6ddOVuJvaEJNRQ4AoWNqhsvhd9OQxPXznqSo6HHH3qHC9RM/aB2xvYfZWbWqcj0VWp
         TEr3MLpmX/eq2y0Zre/SNnGvUFcrOrZQaIYVFfBF5tkyu7pgkOYXbeIRf3rL+K8hyQSs
         5gUBiPM0O/yjuN7mXG+tKgNSWeU0IBmoObzNEC86P4nd/RFv5uvdcJkF4lqBgGpEEqCa
         HxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DpB/I3hsJfInErSI6XP+V1fS0jFYk2FPtdF9VIzTjVE=;
        b=Xlsgei4GJYQv1eOjSkBERQc5PipC20ciKviviyqnC3hop/cIuHMZm+if7XKhHWni2k
         PwOX81s5zRFf7ycQDKMc7YNM67DfLeluCaHawAsWBoj6pbcBmP3EC49k2ji0zt/pdhnc
         00RjQnI6oXJORIe+a16+ayOtKmM4gLMnGnQyH1go6mvnrO9WvY2IkdgQgpGUlckot2+d
         4dxYFedlf37CzMuGn2mFN1IzSKNylEilJjxpRtqq9SheJ6kV0rJnSMiMJg7tu+GlzngK
         koPw4FguIBQUWqrRZcAjRWCJRV9iKCN3ioDFKYAKv4z7BLNaotoyaGP9Uwh8r4AFEGVj
         r71w==
X-Gm-Message-State: AOAM532/oTOcXNXYvmbBkhAyTrwbcwuTQgR6BF2UpBjOim6rweOrIyUr
        LcQ15Vzi5TcGr0hk5kMY1aVQjMA/ECT8dw==
X-Google-Smtp-Source: ABdhPJxnfmLdBBviLwpfn6Pnd+26Kh/ybe66bpZTcZJFbrLFmNgqMLLvVaWwPahFVU25m78JAKjn9Q==
X-Received: by 2002:a17:90a:3d01:: with SMTP id h1mr4040063pjc.124.1617811164141;
        Wed, 07 Apr 2021 08:59:24 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id b186sm22352046pfb.170.2021.04.07.08.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 08:59:23 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hongren Zheng <li@zenithal.me>
Subject: [PATCH v2] ipv6: report errors for iftoken via netlink extack
Date:   Wed,  7 Apr 2021 08:59:12 -0700
Message-Id: <20210407155912.19602-1-sthemmin@microsoft.com>
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
v2 - fix typo that broke build

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
index 120073ffb666..dbb5bb9269bb 100644
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
+			       "Router solicitation is disabled on device");
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

