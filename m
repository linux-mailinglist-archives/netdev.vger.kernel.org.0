Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E9443BB25
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbhJZTnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239054AbhJZTnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:43:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6B0D60F6F;
        Tue, 26 Oct 2021 19:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635277255;
        bh=6kptRF7T18sW7ZNzM84KDRvLY2wHILPGV96SE3YEtIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdKklo7wRg6PaasIzZVb3gQlH3Zoyi6qoGsOvKca0q40/CNFg/zEM/lCZ8nNkiL6e
         rS424suQGR6oIG5SZq+2DT72ak+8aSOrbxjMxXGSfNZZhZLkYuzBkhGjM3t8qM8MhL
         blIz9jFiZO7MQVAaKC0CYprtym3m/M+LOONgSlN7F5SOmJk2ffSoEos06yoqdamdWF
         AXqOoFyY+arxOqxtX48xGHlUQGOL64SiePzZ77SwU3P4qrpeeodwrKWaJNeXHys8YV
         2PJRCWlw1wzGLgeeECgNemsUBsb/Gslwjn5X+iaCAGCn3sfrotOB7CPbBvXp48dEu2
         XWLyJmKfvIqMQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] Revert "devlink: Remove not-executed trap policer notifications"
Date:   Tue, 26 Oct 2021 22:40:42 +0300
Message-Id: <21da54798e7eebdb43fa8db5ca1910f83f11a007.1635276828.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1635276828.git.leonro@nvidia.com>
References: <cover.1635276828.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This reverts commit 22849b5ea5952d853547cc5e0651f34a246b2a4f as it
revealed that mlxsw and netdevsim (copy/paste from mlxsw) reregisters
devlink objects during another devlink user triggered command.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4dac53c77842..0de679c4313c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11180,7 +11180,8 @@ devlink_trap_policer_notify(struct devlink *devlink,
 
 	WARN_ON_ONCE(cmd != DEVLINK_CMD_TRAP_POLICER_NEW &&
 		     cmd != DEVLINK_CMD_TRAP_POLICER_DEL);
-	ASSERT_DEVLINK_REGISTERED(devlink);
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
@@ -11222,6 +11223,9 @@ devlink_trap_policer_register(struct devlink *devlink,
 	}
 
 	list_add_tail(&policer_item->list, &devlink->trap_policer_list);
+	devlink_trap_policer_notify(devlink, policer_item,
+				    DEVLINK_CMD_TRAP_POLICER_NEW);
+
 	return 0;
 
 err_policer_init:
@@ -11239,6 +11243,8 @@ devlink_trap_policer_unregister(struct devlink *devlink,
 	if (WARN_ON_ONCE(!policer_item))
 		return;
 
+	devlink_trap_policer_notify(devlink, policer_item,
+				    DEVLINK_CMD_TRAP_POLICER_DEL);
 	list_del(&policer_item->list);
 	if (devlink->ops->trap_policer_fini)
 		devlink->ops->trap_policer_fini(devlink, policer);
@@ -11260,8 +11266,6 @@ devlink_trap_policers_register(struct devlink *devlink,
 {
 	int i, err;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	mutex_lock(&devlink->lock);
 	for (i = 0; i < policers_count; i++) {
 		const struct devlink_trap_policer *policer = &policers[i];
@@ -11303,8 +11307,6 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 {
 	int i;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	mutex_lock(&devlink->lock);
 	for (i = policers_count - 1; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
-- 
2.31.1

