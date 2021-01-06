Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4033A2EC34F
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbhAFSk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:40:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbhAFSkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 13:40:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A2B223137;
        Wed,  6 Jan 2021 18:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609958414;
        bh=0BrWNZz5FTEATIslw6poEkKFNsItoHl93UC2ZCWjyoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfQ2g8hPUPNlBlMXidj9GFsuK4OMZX/NKYDlnlH4XaeG/k9oKWeZuPTUzueec8Xd+
         /3sidZ14IzfASQ2xT5f/ofLD6abPAvQBJFLuNtMiIe0jYEFemtJItziyWqYoVYB1OG
         9KCdMzwpifrIy2InTt8PpUYhMDnS14nsN4hJ55PJetGTey8vcNGgOqdp0zrLGs+oAD
         AITOrmyiTvvdeHAQqnHmXv4qvEvZ6GimVI1qqUYGo8BR+owdx7uvmujWudj5Rd8Tb8
         muR7kgxCF7hM+2FeJb/hOCSkoFW74igvhpmbPUKOTL2LYtVmfgG+KFeDcqj6kNLeTj
         f71eNB0Jphn/g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com, xiyou.wangcong@gmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH net 3/3] net: make sure devices go through netdev_wait_all_refs
Date:   Wed,  6 Jan 2021 10:40:07 -0800
Message-Id: <20210106184007.1821480-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106184007.1821480-1-kuba@kernel.org>
References: <20210106184007.1821480-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If register_netdevice() fails at the very last stage - the
notifier call - some subsystems may have already seen it and
grabbed a reference. struct net_device can't be freed right
away without calling netdev_wait_all_refs().

Now that we have a clean interface in form of dev->needs_free_netdev
and lenient free_netdev() we can undo what commit 93ee31f14f6f ("[NET]:
Fix free_netdev on register_netdev failure.") has done and complete
the unregistration path by bringing the net_set_todo() call back.

After registration fails user is still expected to explicitly
free the net_device, so make sure ->needs_free_netdev is cleared,
otherwise rolling back the registration will cause the old double
free for callers who release rtnl_lock before the free.

This also solves the problem of priv_destructor not being called
on notifier error.

net_set_todo() will be moved back into unregister_netdevice_queue()
in a follow up.

Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index adde93cbca9f..0071a11a6dc3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10077,17 +10077,11 @@ int register_netdevice(struct net_device *dev)
 	ret = call_netdevice_notifiers(NETDEV_REGISTER, dev);
 	ret = notifier_to_errno(ret);
 	if (ret) {
+		/* Expect explicit free_netdev() on failure */
+		dev->needs_free_netdev = false;
 		rollback_registered(dev);
-		rcu_barrier();
-
-		dev->reg_state = NETREG_UNREGISTERED;
-		/* We should put the kobject that hold in
-		 * netdev_unregister_kobject(), otherwise
-		 * the net device cannot be freed when
-		 * driver calls free_netdev(), because the
-		 * kobject is being hold.
-		 */
-		kobject_put(&dev->dev.kobj);
+		net_set_todo(dev);
+		goto out;
 	}
 	/*
 	 *	Prevent userspace races by waiting until the network
-- 
2.26.2

