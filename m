Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886AE3EC1CC
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 11:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbhHNJ6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 05:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237773AbhHNJ6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 05:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4F3E60E93;
        Sat, 14 Aug 2021 09:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628935061;
        bh=sncrE3HsRIhHLQMLLwFadwJDxDl1C41sdTzur3zQFaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBVtqhI2q/jSCii8kyllJS90WBbRf7B6c9JxY/T6NqwW+P/ZfgFJiI7Var8hNa363
         JDqAuHkJU8XlhS1D+IvMMqfb6cq2xvfa3iY30zqBeo61/UZfn6/rHRvkg4EvAAoALe
         eALK7fhLIs60h7mh9rQRwoHt1LI2DueNywaPGRWflrSWewwC0Zo0YCuRfmyyVJUddC
         fcJ/LUx0h1ckr+xgfqUhQfVFwJNwWAJjz1eXazqnTu+EBcJw4V/I8eGfQTd+e6lxlZ
         m1qjsEGL1AiWYHo2iErWtFAgv9g670GaqC1aOtZ3as8KuiWiqwH0lyrOTBacw6EUfK
         Wmy/OUvxhsJhQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 1/6] devlink: Simplify devlink_pernet_pre_exit call
Date:   Sat, 14 Aug 2021 12:57:26 +0300
Message-Id: <98298393caf87126db0fc0e888010ed1cdcaf786.1628933864.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628933864.git.leonro@nvidia.com>
References: <cover.1628933864.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The devlink_pernet_pre_exit() will be called if net namespace exits.

That routine is relevant for devlink instances that were assigned to
that namespaces first. This assignment is possible only with the following
command: "devlink reload DEV netns ...", which already checks reload support.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee9787314cff..9e74a95b3322 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11392,16 +11392,16 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	 */
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
-		if (net_eq(devlink_net(devlink), net)) {
-			if (WARN_ON(!devlink_reload_supported(devlink->ops)))
-				continue;
-			err = devlink_reload(devlink, &init_net,
-					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
-					     DEVLINK_RELOAD_LIMIT_UNSPEC,
-					     &actions_performed, NULL);
-			if (err && err != -EOPNOTSUPP)
-				pr_warn("Failed to reload devlink instance into init_net\n");
-		}
+		if (!net_eq(devlink_net(devlink), net))
+			continue;
+
+		WARN_ON(!devlink_reload_supported(devlink->ops));
+		err = devlink_reload(devlink, &init_net,
+				     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+				     DEVLINK_RELOAD_LIMIT_UNSPEC,
+				     &actions_performed, NULL);
+		if (err && err != -EOPNOTSUPP)
+			pr_warn("Failed to reload devlink instance into init_net\n");
 	}
 	mutex_unlock(&devlink_mutex);
 }
-- 
2.31.1

