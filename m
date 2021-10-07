Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB08424D7B
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 08:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240296AbhJGG5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 02:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240233AbhJGG5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 02:57:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 521E661261;
        Thu,  7 Oct 2021 06:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633589728;
        bh=ubBfXkJlfWk9vB5diL1cDnPrfyxhDRFVopndxkSNLHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+qO3gFaIC2YiK+qF0Li+9ZLcXO5JK2oRoxGvU8Dp6vd3MYz864zj/jNvHnC0TBQc
         6D5nX//OJnLvnlcSDarDsges/HgnNZXZ0ZrslsgmjsqORpacvBv67daSVDJtOJGe6V
         rDtV7GaTYRRQ3noWqpGjQqer4T7cMPpN1xAU7tnlkTw9+pM0xl+0b9LK6/B2InB/dD
         uCCwf2QaDp+QOiJBM60xWgIvOVvEOYCEfFSZdu14j4xRzowQppuMitMTdsqDI0Qq1p
         jR+FckUd5bkOQ0/FY17jNa2AkzOmcEriGCm+snkSVncgmrF2fGy2Uyv4a0g7vBuvp+
         wx8ZST14rvh0g==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next v3 2/5] devlink: Annotate devlink API calls
Date:   Thu,  7 Oct 2021 09:55:16 +0300
Message-Id: <19f798d89eae110593055db5e15eb3bbf07adb2c.1633589385.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633589385.git.leonro@nvidia.com>
References: <cover.1633589385.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Initial annotation patch to separate calls that needs to be executed
before or after devlink_register().

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9642429cec65..4e484afeadea 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -154,6 +154,22 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
 static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
 #define DEVLINK_REGISTERED XA_MARK_1
 
+/* devlink instances are open to the access from the user space after
+ * devlink_register() call. Such logical barrier allows us to have certain
+ * expectations related to locking.
+ *
+ * Before *_register() - we are in initialization stage and no parallel
+ * access possible to the devlink instance. All drivers perform that phase
+ * by implicitly holding device_lock.
+ *
+ * After *_register() - users and driver can access devlink instance at
+ * the same time.
+ */
+#define ASSERT_DEVLINK_REGISTERED(d)                                           \
+	WARN_ON_ONCE(!xa_get_mark(&devlinks, (d)->index, DEVLINK_REGISTERED))
+#define ASSERT_DEVLINK_NOT_REGISTERED(d)                                       \
+	WARN_ON_ONCE(xa_get_mark(&devlinks, (d)->index, DEVLINK_REGISTERED))
+
 /* devlink_mutex
  *
  * An overall lock guarding every operation coming from userspace.
@@ -9115,6 +9131,10 @@ static void devlink_notify_unregister(struct devlink *devlink)
  */
 void devlink_register(struct devlink *devlink)
 {
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+	/* Make sure that we are in .probe() routine */
+	device_lock_assert(devlink->dev);
+
 	mutex_lock(&devlink_mutex);
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_notify_register(devlink);
@@ -9129,6 +9149,10 @@ EXPORT_SYMBOL_GPL(devlink_register);
  */
 void devlink_unregister(struct devlink *devlink)
 {
+	ASSERT_DEVLINK_REGISTERED(devlink);
+	/* Make sure that we are in .remove() routine */
+	device_lock_assert(devlink->dev);
+
 	devlink_put(devlink);
 	wait_for_completion(&devlink->comp);
 
@@ -9183,6 +9207,8 @@ EXPORT_SYMBOL_GPL(devlink_reload_disable);
  */
 void devlink_free(struct devlink *devlink)
 {
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
 	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
-- 
2.31.1

