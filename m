Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AAC3A4D7B
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 10:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhFLIOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 04:14:23 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:40484 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFLIOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 04:14:20 -0400
Received: by mail-wr1-f54.google.com with SMTP id y7so8417303wrh.7
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 01:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pAaCMxF9sS+QVyZSSeidUbHEHKD3loHR2IcQcTMXKSQ=;
        b=Oh6mIdyMQ1qBMCPK6uUu/n/2a0Jp4mWKyJTLupCiWzpzjiQZEQzA52c5C07O2gqdW3
         46JUJylcyIPz5w6zzhUGwTKBggf/szzEiWu1plETy5zey1xS8bZXjcu8baGtN8ePmJlQ
         JTmXjwTjrarZ0GPGOkWmyCrfc3kmqrRT2A/8AyjW+gExiFw4ixro64tfAGSKWxgvi0yL
         JOWgeddrr3wYVOpg+tGeuOyb/u9Lw5ZiJkUIV4MXUE9Oq6f/Rf7xFJr2mznlfjXrcqNl
         SWNpN9RIZYV899FOJUh/2zjwAq7XX8Ym7Kn4JCvWhP+zmjfsYP4WIeYXDzA1rkC3KmwC
         EYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pAaCMxF9sS+QVyZSSeidUbHEHKD3loHR2IcQcTMXKSQ=;
        b=S38t18c5128Yo9qgPx012D2TrriCa4rEq6AqO+8QdsymBerRaxhumfNzOwKKEMzW9w
         9wXR3oPMYaveI9DvY0wb0r7ONNqkp/R7igmwBhiQXEnlCz77Xakq+JlcW0losFXti2XT
         yWUdMsbj0DDkCFpnTM4QFqyYMXKpVv8ayuIBI4tArKiap6aJl6A9MX69FYhvpBwyqR26
         JZf3Z7q8o2GCcrJGlrlpTKE32iF7yD6Gx+JVWqi6qjc/EoodBxRP7junCoWVRN0wi44Z
         UJlQM9VXgbNqwUsnZToVfZNcfWx9qaSUtM2TrXEUyjt7WsEnNCOluFCwafwsFxZDayxW
         E/iQ==
X-Gm-Message-State: AOAM532nGE+CGOSodXeBjGTz53tj4CBnCf6huAXI5VaUbqvuYqj+yEvS
        Y3HBdIlK2Dv/BlSoeKG/pvtbvQ==
X-Google-Smtp-Source: ABdhPJylz00o06gCFwefAL94pprfNCUuSzM4U86ejXBk/n2N8TEwBQUYAK1JPdVjtQq4OmqYuk4MGQ==
X-Received: by 2002:adf:efc3:: with SMTP id i3mr7985579wrp.356.1623485480095;
        Sat, 12 Jun 2021 01:11:20 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id w13sm10619313wrc.31.2021.06.12.01.11.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Jun 2021 01:11:19 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, m.chetan.kumar@intel.com,
        johannes.berg@intel.com, leon@kernel.org, ryazanov.s.a@gmail.com,
        parav@nvidia.com
Subject: [PATCH net-next v3 1/4] rtnetlink: add alloc() method to rtnl_link_ops
Date:   Sat, 12 Jun 2021 10:20:54 +0200
Message-Id: <1623486057-13075-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623486057-13075-1-git-send-email-loic.poulain@linaro.org>
References: <1623486057-13075-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In order to make rtnetlink ops that can create different
kinds of devices, like what we want to add to the WWAN
framework, the priv_size and setup parameters aren't quite
sufficient. Make this easier to manage by allowing ops to
allocate their own netdev via an @alloc method that gets
the tb netlink data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 include/net/rtnetlink.h |  8 ++++++++
 net/core/rtnetlink.c    | 19 ++++++++++++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 479f60e..384e800 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -37,6 +37,9 @@ static inline int rtnl_msg_family(const struct nlmsghdr *nlh)
  *	@maxtype: Highest device specific netlink attribute number
  *	@policy: Netlink policy for device specific attribute validation
  *	@validate: Optional validation function for netlink/changelink parameters
+ *	@alloc: netdev allocation function, can be %NULL and is then used
+ *		in place of alloc_netdev_mqs(), in this case @priv_size
+ *		and @setup are unused. Returns a netdev or ERR_PTR().
  *	@priv_size: sizeof net_device private space
  *	@setup: net_device setup function
  *	@newlink: Function for configuring and registering a new device
@@ -63,6 +66,11 @@ struct rtnl_link_ops {
 	const char		*kind;
 
 	size_t			priv_size;
+	struct net_device	*(*alloc)(struct nlattr *tb[],
+					  const char *ifname,
+					  unsigned char name_assign_type,
+					  unsigned int num_tx_queues,
+					  unsigned int num_rx_queues);
 	void			(*setup)(struct net_device *dev);
 
 	bool			netns_refund;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index cd87c76..92c3e43 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -376,12 +376,12 @@ int __rtnl_link_register(struct rtnl_link_ops *ops)
 	if (rtnl_link_ops_get(ops->kind))
 		return -EEXIST;
 
-	/* The check for setup is here because if ops
+	/* The check for alloc/setup is here because if ops
 	 * does not have that filled up, it is not possible
 	 * to use the ops for creating device. So do not
 	 * fill up dellink as well. That disables rtnl_dellink.
 	 */
-	if (ops->setup && !ops->dellink)
+	if ((ops->alloc || ops->setup) && !ops->dellink)
 		ops->dellink = unregister_netdevice_queue;
 
 	list_add_tail(&ops->list, &link_ops);
@@ -3165,8 +3165,17 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 		return ERR_PTR(-EINVAL);
 	}
 
-	dev = alloc_netdev_mqs(ops->priv_size, ifname, name_assign_type,
-			       ops->setup, num_tx_queues, num_rx_queues);
+	if (ops->alloc) {
+		dev = ops->alloc(tb, ifname, name_assign_type,
+				 num_tx_queues, num_rx_queues);
+		if (IS_ERR(dev))
+			return dev;
+	} else {
+		dev = alloc_netdev_mqs(ops->priv_size, ifname,
+				       name_assign_type, ops->setup,
+				       num_tx_queues, num_rx_queues);
+	}
+
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
@@ -3399,7 +3408,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EOPNOTSUPP;
 	}
 
-	if (!ops->setup)
+	if (!ops->alloc && !ops->setup)
 		return -EOPNOTSUPP;
 
 	if (!ifname[0]) {
-- 
2.7.4

