Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3B743BB22
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238871AbhJZTnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239006AbhJZTnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:43:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1A0060F9D;
        Tue, 26 Oct 2021 19:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635277251;
        bh=DAlXPVFGtJ1N6ufJSqDdE1YQB9+X1d5JS9/+n27Lv6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTwNgJGPPo2uzU8dyxH8rypfutOmE1SLdT3pTsLfcBV362xeghgyzj28KgOQlR6Kg
         S4Xy8BqFNpf+7R1qBg/8J3MQeZOTkCjdMLmyAC/fXSPaVjtFUN8NC+KANDPuh5+Cw4
         ZSuL+XblE4iqieqW0FGPtpPdVZxqcqjS9jeWI4knMvHbuMFC73L0m8JK3j6PvDjlSG
         j1gJA0dj+08h+uc2Y9iv7frU3AulZL6iYuzBzq0GLNup4fPSTFsdYNao36Zg2U0SBi
         4PP/OhK9P+PEIdDK8jRtd0ncgxorFOXdP89GK64l3/xBahmaIQxIA1lW/FM0fyanC9
         jFeK0Q9W6QSoQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: [PATCH net-next 1/2] Revert "devlink: Remove not-executed trap group notifications"
Date:   Tue, 26 Oct 2021 22:40:41 +0300
Message-Id: <38cd9f98e8390ad3489f3b6862e344ce7dd6adf8.1635276828.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1635276828.git.leonro@nvidia.com>
References: <cover.1635276828.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This reverts commit 8bbeed4858239ac956a78e5cbaf778bd6f3baef8 as it
revealed that mlxsw and netdevsim (copy/paste from mlxsw) reregisters
devlink objects during another devlink user triggered command.

Fixes: 22849b5ea595 ("devlink: Remove not-executed trap policer notifications")
Reported-by: syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index f38ef4b26f70..4dac53c77842 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10754,7 +10754,8 @@ devlink_trap_group_notify(struct devlink *devlink,
 
 	WARN_ON_ONCE(cmd != DEVLINK_CMD_TRAP_GROUP_NEW &&
 		     cmd != DEVLINK_CMD_TRAP_GROUP_DEL);
-	ASSERT_DEVLINK_REGISTERED(devlink);
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -11081,6 +11082,9 @@ devlink_trap_group_register(struct devlink *devlink,
 	}
 
 	list_add_tail(&group_item->list, &devlink->trap_group_list);
+	devlink_trap_group_notify(devlink, group_item,
+				  DEVLINK_CMD_TRAP_GROUP_NEW);
+
 	return 0;
 
 err_group_init:
@@ -11101,6 +11105,8 @@ devlink_trap_group_unregister(struct devlink *devlink,
 	if (WARN_ON_ONCE(!group_item))
 		return;
 
+	devlink_trap_group_notify(devlink, group_item,
+				  DEVLINK_CMD_TRAP_GROUP_DEL);
 	list_del(&group_item->list);
 	free_percpu(group_item->stats);
 	kfree(group_item);
@@ -11120,8 +11126,6 @@ int devlink_trap_groups_register(struct devlink *devlink,
 {
 	int i, err;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	mutex_lock(&devlink->lock);
 	for (i = 0; i < groups_count; i++) {
 		const struct devlink_trap_group *group = &groups[i];
@@ -11159,8 +11163,6 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
 {
 	int i;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	mutex_lock(&devlink->lock);
 	for (i = groups_count - 1; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
-- 
2.31.1

