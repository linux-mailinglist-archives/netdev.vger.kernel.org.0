Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC97B4363E7
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhJUOSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231550AbhJUOSl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 10:18:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5BAA6121F;
        Thu, 21 Oct 2021 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634825785;
        bh=J2YnZpwyF7eJeN4xv83Lq3jtQZn3lRH1fQJKO3NuswA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YXUSvEy0AyOlIPjSRVEqffM3pS/Mf+JbfRSa77ygx7o8YeIWodprQaK2qTbbjHFfe
         kBLYJ47jR1Gr/k1lvtlX8N0I1b7vqFLL5rXPhZbx8qO4YVXwFhbJXhwX4P+pquvc3y
         c+702K7gTzeU0QslY8t2JzoteQc++n8xrMR2LmSxHmbBgQLM2pLOdN+khr1EzpoICZ
         30EP3Z6di1WtRqyVkitvwemBjp8Efu5iapf2Gt4lkPP8pl0lXSzixG9SN6jIPCmwUH
         gamy4euLVwJBW5TDgHEkWndK5r9GorJTmnEkZ6r0bNv6O5QlzXL+MT9CGbjR8R6N8b
         qPVEu+xyBVbSw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] devlink: Remove not-executed trap policer notifications
Date:   Thu, 21 Oct 2021 17:16:14 +0300
Message-Id: <a971b4eb177e66bbf3595cfb8443ca82e90aaf64.1634825474.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634825474.git.leonro@nvidia.com>
References: <cover.1634825474.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The trap policer logic is registered before devlink_register() and all the
notifications are delayed. This patch removes not-possible notifications
along with addition of code annotation logic.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e9802421ed50..bc93d894b4c6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11173,8 +11173,7 @@ devlink_trap_policer_notify(struct devlink *devlink,
 
 	WARN_ON_ONCE(cmd != DEVLINK_CMD_TRAP_POLICER_NEW &&
 		     cmd != DEVLINK_CMD_TRAP_POLICER_DEL);
-	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
-		return;
+	ASSERT_DEVLINK_REGISTERED(devlink);
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -11216,9 +11215,6 @@ devlink_trap_policer_register(struct devlink *devlink,
 	}
 
 	list_add_tail(&policer_item->list, &devlink->trap_policer_list);
-	devlink_trap_policer_notify(devlink, policer_item,
-				    DEVLINK_CMD_TRAP_POLICER_NEW);
-
 	return 0;
 
 err_policer_init:
@@ -11236,8 +11232,6 @@ devlink_trap_policer_unregister(struct devlink *devlink,
 	if (WARN_ON_ONCE(!policer_item))
 		return;
 
-	devlink_trap_policer_notify(devlink, policer_item,
-				    DEVLINK_CMD_TRAP_POLICER_DEL);
 	list_del(&policer_item->list);
 	if (devlink->ops->trap_policer_fini)
 		devlink->ops->trap_policer_fini(devlink, policer);
@@ -11259,6 +11253,8 @@ devlink_trap_policers_register(struct devlink *devlink,
 {
 	int i, err;
 
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
 	mutex_lock(&devlink->lock);
 	for (i = 0; i < policers_count; i++) {
 		const struct devlink_trap_policer *policer = &policers[i];
@@ -11300,6 +11296,8 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 {
 	int i;
 
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
 	mutex_lock(&devlink->lock);
 	for (i = policers_count - 1; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
-- 
2.31.1

