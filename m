Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E2439F83E
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhFHOAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 10:00:19 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:41907 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbhFHOAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 10:00:18 -0400
Received: by mail-wm1-f46.google.com with SMTP id l11-20020a05600c4f0bb029017a7cd488f5so1964854wmq.0
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 06:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=MRT0SOOsG4AdunyzUvkRb/0kxk6sA/og4uHR2hzJs1A=;
        b=XzjkCamkIwNRqHEaSCavk9rc4s55UixZta4Uh6IguvzsizZ0oSDS0hrkikYTIROHlS
         rIXA7M+7Oj0HuEup1okuiZ8MW/DNAChmwEu7wWa6G6pkqwkYZ97cfEDJTZkF0Akst6E8
         U7ULoYGh6kZknDXig3JhRbaDErhW1pSjXAywMkg1KcIqSjEr4deTkVDxS3QUpg78kKSx
         uu11flAkOP8paVnTSBGPp7M9eixd+G5g76nQujPbh20N/pQwNOEeAPu3W87UlwHSy9HP
         EgNs1EM+n/LnBUWiBlB7dTKkdW4OhYCgY5mhFWX0G28zBsyYs88aA3A+y5KZvb5qAF1j
         7fxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MRT0SOOsG4AdunyzUvkRb/0kxk6sA/og4uHR2hzJs1A=;
        b=oT/ki/VKNCQYNaRqt3wXZZjcOckH40gQ9U/80Vs3WuWvOGVn5rFYeYg8zqLq8PgYK1
         4TaZ5Avfeb3oQj2tg9Qd/meTUdnx8JSkYlfg6WtZYV19Fmw39DIeQ0UMpfoU/KXwQ9/U
         lAqYxZeXOO9vwoJOwOSDd/uABPETKmVdCIrTVdKPEqxbxfddLMMBaes0ELtxqunCg42/
         eRBLYAVCYL+7lfMNFdrD9kYlln5WmMAQvcEJM0UDC+2vidIxtqPe0K7Z6cKUbJlS07h5
         w+XZyeF0ruzAb6HZI+OYWzY3YoRJrB3FvbZq2zuqFZ9w+rGkLioHHw9SiNYtwvjo9drS
         xptQ==
X-Gm-Message-State: AOAM531YGr+tAgQhbFN2IODrGBXU0QOMZTGDJkuFyW9fKm1Wu1hw3VV7
        uUveEjR6l4fRHr0t3DK7+DFn8QfMuLAaK2AS
X-Google-Smtp-Source: ABdhPJz+HfLsbw+0DwoeMLEH120Th6PICkURbvIglmv80mdODujsDRlzb7koKSfn8SaDk4cPyzJJTQ==
X-Received: by 2002:a1c:f70b:: with SMTP id v11mr22455348wmh.186.1623160645003;
        Tue, 08 Jun 2021 06:57:25 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id f14sm1956108wmq.10.2021.06.08.06.57.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jun 2021 06:57:24 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com, leon@kernel.org,
        m.chetan.kumar@intel.com, Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: [PATCH net-next 1/4] rtnetlink: add alloc() method to rtnl_link_ops
Date:   Tue,  8 Jun 2021 16:07:04 +0200
Message-Id: <1623161227-29930-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
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
index 714d5fa..c0c8dec 100644
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
@@ -3177,8 +3177,17 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
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
 
@@ -3411,7 +3420,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EOPNOTSUPP;
 	}
 
-	if (!ops->setup)
+	if (!ops->alloc && !ops->setup)
 		return -EOPNOTSUPP;
 
 	if (!ifname[0]) {
-- 
2.7.4

