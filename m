Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3B03A322E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhFJRhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhFJRhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:37:06 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFD4C0617AF
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:09 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id a11so3208912wrt.13
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=4M1DTS/TUH4XveU37GHDSqJrM0/UlPwmrZnAJgu64K0=;
        b=REqtCeCup9q4KYbh/dTDqS5jaD2az2csqn+hBszw7/j1U5daMNrhWb/YRbmsr0X2z8
         MU7tV8J5y/oJX/MNcPgZS3DMk4/lYVS87Zi88yorr5FRgDvlTzqiuxUN3KsVaFAOBM+B
         Fsq6G9ymEod5zkaRDRv6gU+mWYayGS36IoiAedTnjZDL+mBH8lJGxGKqoyI93WZhr8oC
         UC4g4ER94WvqfJmFlZzu+eLht5yE7ZfcU2fMbXfw4GQl0G4vd5C8T/xj4TxTwQtaoYB3
         Smma9jNmzmm8nf2I90U3m9BOic2UIQmgM5JSpZP0HeONfbiCabyxIpwy6elmv8VMG0Eb
         Jj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4M1DTS/TUH4XveU37GHDSqJrM0/UlPwmrZnAJgu64K0=;
        b=fGqwsaQOnAJgoRnXBDo+g66FBLuTqwsX5/C50S9cYNl72w2Bv1/8KVcC1oA4dwtYvS
         SjlVUVk2riX6IcMaxrWMwn5RZldaanT/SCrJcQ9lqtxss49ncm8jX8PJfVOplSueAHD5
         tYSKXvbmziTFhaifukDahvp210XK+MmjYNBTXsFWrbSvYFjfUe46AWTtxpOg4LpeHtlf
         5uNvTcWqfJemdwouuwXDxqpydc+b2sbRSyQnAkAQ4YB8ljdZV8XxIi5Hh5Bufznn+Kaz
         rEfj/PN4tvQLHTBNOltSPA8MZaR8ZnFS7pNZvFXp9D+SdCdXK/dWEs9aKjC83PwfH+9F
         yHyg==
X-Gm-Message-State: AOAM5300Q0ftt6Kl7Wgy/G1ytqxBeh5EWVRrqG6Ajq/FgW165uwZUggZ
        Ju+hdqcbEAX14XNlD7o/WJv4Ug==
X-Google-Smtp-Source: ABdhPJyovkII9B1N/0HNvGQMhkLTvxHdNB8EP6kQq49UWr0hprRbT3cjfcwG3U9lVkjADLEyNcEzHA==
X-Received: by 2002:a5d:5307:: with SMTP id e7mr6848077wrv.300.1623346507967;
        Thu, 10 Jun 2021 10:35:07 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id x3sm9921356wmj.30.2021.06.10.10.35.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jun 2021 10:35:07 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com, leon@kernel.org,
        m.chetan.kumar@intel.com, parav@nvidia.com,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: [PATCH net-next v2 1/3] rtnetlink: add alloc() method to rtnl_link_ops
Date:   Thu, 10 Jun 2021 19:44:47 +0200
Message-Id: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
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
 v2: no change

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

