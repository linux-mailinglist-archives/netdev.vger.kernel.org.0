Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593E5420349
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 20:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhJCSOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 14:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231449AbhJCSON (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 14:14:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D10E761A03;
        Sun,  3 Oct 2021 18:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633284745;
        bh=ubBfXkJlfWk9vB5diL1cDnPrfyxhDRFVopndxkSNLHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbMUl87cCWT+97KqDP92fcWx1lVuUa4W8XKStdB2ZbTf1SW2GYZcHkZ2/qI+Jii+/
         Ri7eMjFTMjDrLQpWoQuMRp69yPR/Kz1fwTX8xUjtQcrgdRCluu5G88bEiXlfzJzghh
         +5TPkDuyNOK4KURDvatzlatieradDHJ+EfA6joHw6znQKDTSCHP0xpNs8/WNhAgE4J
         suhj15keyLSoPCl+bTHZhGuTieX6KHadZuXJgJERBPaAXEwSmDh9Q/KX2YrYf4qS1P
         4L57JhB15P5pBGGRXwCoPJCYInAEHhRlltaudJ5cPzq9FC/i/vHEaalRRHFn2ddBEX
         Yyb1Wtb18cMlg==
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
Subject: [PATCH net-next v2 2/5] devlink: Annotate devlink API calls
Date:   Sun,  3 Oct 2021 21:12:03 +0300
Message-Id: <f65772d429d2c259bbc18cf5b1bbe61e39eb7081.1633284302.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633284302.git.leonro@nvidia.com>
References: <cover.1633284302.git.leonro@nvidia.com>
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

