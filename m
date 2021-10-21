Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903724363EA
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhJUOSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231530AbhJUOSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 10:18:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CBFA61208;
        Thu, 21 Oct 2021 14:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634825789;
        bh=3Nb/grbHgFRXCZr4E6AcfZIkKMqUx73ZWOTPNtV7b9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzQYYq6EvQEOCUqUWEPA7J9cs1lUt8XZcXdZbDyhz6snpqMuXngeGVOivM1OddOW+
         /WszZZ3P+fFpUo7J1p2GbGTzzTOfHcir2DuxwdtmqNbBz/0BOGN3t46UjUoZXs4ID8
         HeshHfVKaOgcNd86t5LdzzYckTU4/CRMVW6wd9WN+lqffDofoZCabgGm5FCSAuTAJI
         XacuA7IvSJu9MvnGQ6TILDBOj1WA7s/VPlhPvA494w6dWpdaROj5xpABML++8/6hFT
         oDk+2Hv63likeUzMmwg3QYYpbfsqlLyt/lDqrjKrWQVF1+bbVUW6BtCN1mHynYfCn9
         xKx4ZAJnidhIg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] devlink: Remove not-executed trap group notifications
Date:   Thu, 21 Oct 2021 17:16:15 +0300
Message-Id: <dce75c1415c50c1ff0248f59efb58a7022b52934.1634825474.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634825474.git.leonro@nvidia.com>
References: <cover.1634825474.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The trap logic is registered before devlink_register() and all the
notifications are delayed. This patch removes not-possible trap group
notifications along with addition of code annotation logic.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index bc93d894b4c6..10e953abad89 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10747,8 +10747,7 @@ devlink_trap_group_notify(struct devlink *devlink,
 
 	WARN_ON_ONCE(cmd != DEVLINK_CMD_TRAP_GROUP_NEW &&
 		     cmd != DEVLINK_CMD_TRAP_GROUP_DEL);
-	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
-		return;
+	ASSERT_DEVLINK_REGISTERED(devlink);
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -11075,9 +11074,6 @@ devlink_trap_group_register(struct devlink *devlink,
 	}
 
 	list_add_tail(&group_item->list, &devlink->trap_group_list);
-	devlink_trap_group_notify(devlink, group_item,
-				  DEVLINK_CMD_TRAP_GROUP_NEW);
-
 	return 0;
 
 err_group_init:
@@ -11098,8 +11094,6 @@ devlink_trap_group_unregister(struct devlink *devlink,
 	if (WARN_ON_ONCE(!group_item))
 		return;
 
-	devlink_trap_group_notify(devlink, group_item,
-				  DEVLINK_CMD_TRAP_GROUP_DEL);
 	list_del(&group_item->list);
 	free_percpu(group_item->stats);
 	kfree(group_item);
@@ -11119,6 +11113,8 @@ int devlink_trap_groups_register(struct devlink *devlink,
 {
 	int i, err;
 
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
 	mutex_lock(&devlink->lock);
 	for (i = 0; i < groups_count; i++) {
 		const struct devlink_trap_group *group = &groups[i];
@@ -11156,6 +11152,8 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
 {
 	int i;
 
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
 	mutex_lock(&devlink->lock);
 	for (i = groups_count - 1; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
-- 
2.31.1

