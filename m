Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6AC42A531
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbhJLNRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:17:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236681AbhJLNRl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 09:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C21261050;
        Tue, 12 Oct 2021 13:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634044540;
        bh=dOmb9Sa558V+AowolLjO/p0iaivIqbdF1pcAJPjI+k4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ya7oalL5RoNVLLPffO1ICFzNhDh/zPj75nQO6Iklw6JQR1tZPxM2/cDsaAn2/yM7l
         htIU3TrVhccc/dgXlNayacmFQuS5knK9SmL8DBlMZ9uJ1g3JeaU3GAhORcQfDOB/9n
         joP9bbuz36Qvk5g+KYhVHZBaScHYG+ggaNATQoa72pHquvM901OWNPE7WzMiVxonuo
         CscIQTLsGK1HDVSwALtMu9YU+5nc2xzlvr4gjin3xJSmxi0OxAev1PhAk0PRmgwzl3
         1jD235jhT4wLpJ4pbJd+uZBVIiMBLp/ae0J59FBMcJzkN14Ns9j3NaQDtA3x7YJ75k
         5Q9zIyietfaOA==
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
Subject: [PATCH net-next v4 2/6] devlink: Move netdev_to_devlink helpers to devlink.c
Date:   Tue, 12 Oct 2021 16:15:22 +0300
Message-Id: <b11adcc241126d68c2509e65cddab7f06c23b80e.1634044267.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634044267.git.leonro@nvidia.com>
References: <cover.1634044267.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Both netdev_to_devlink and netdev_to_devlink_port are used in devlink.c
only, so move them in order to reduce their scope.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/devlink.h | 17 -----------------
 net/core/devlink.c    | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index ae03eb1c6cc9..7f44ad14e5ed 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1486,23 +1486,6 @@ void *devlink_priv(struct devlink *devlink);
 struct devlink *priv_to_devlink(void *priv);
 struct device *devlink_to_dev(const struct devlink *devlink);
 
-static inline struct devlink_port *
-netdev_to_devlink_port(struct net_device *dev)
-{
-	if (dev->netdev_ops->ndo_get_devlink_port)
-		return dev->netdev_ops->ndo_get_devlink_port(dev);
-	return NULL;
-}
-
-static inline struct devlink *netdev_to_devlink(struct net_device *dev)
-{
-	struct devlink_port *devlink_port = netdev_to_devlink_port(dev);
-
-	if (devlink_port)
-		return devlink_port->devlink;
-	return NULL;
-}
-
 struct ib_device;
 
 struct net *devlink_net(const struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 87d1766ebdbf..e9e908c4cfb4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11381,6 +11381,24 @@ static void __devlink_compat_running_version(struct devlink *devlink,
 	nlmsg_free(msg);
 }
 
+static struct devlink_port *netdev_to_devlink_port(struct net_device *dev)
+{
+	if (!dev->netdev_ops->ndo_get_devlink_port)
+		return NULL;
+
+	return dev->netdev_ops->ndo_get_devlink_port(dev);
+}
+
+static struct devlink *netdev_to_devlink(struct net_device *dev)
+{
+	struct devlink_port *devlink_port = netdev_to_devlink_port(dev);
+
+	if (!devlink_port)
+		return NULL;
+
+	return devlink_port->devlink;
+}
+
 void devlink_compat_running_version(struct net_device *dev,
 				    char *buf, size_t len)
 {
-- 
2.31.1

