Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9CA41984AA
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgC3TjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:21 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:40861 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728763AbgC3TjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3739B580542;
        Mon, 30 Mar 2020 15:39:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=15DX2VV/ym5evOBCjFCKSJP9spE9y4y7giOJqXS6+1k=; b=A93/Bzk9
        8Zf7Igqrd4dStxvplYq7Xlww7DyF2ztetxQQ1jRqccKaTKSOmmInTQ+SC167U0uS
        suyf2+IZh9nbjwHh985R44QHQuHpBe6fEpcuFeXjH+0s+vDAmDLK4yGqlbpafqLU
        SbyGQtw6NbCyYyAHzVphYaxPLUUP9+e7FubSF77Anpa9J/VBhSUNrE+UMrgwOU8s
        ovydybRAM2Oa2e55dSW0fK5mpa3MHNT8CKcr0ufm6jdfzRLto8JkL4CtVUWp6YJ5
        0z8LNBwwS4EFKQOgmhe2/lKCmS0QPPTVE/B6iqcDOGP9qc6/iWu6C8fxgU8wU0r7
        dZYMJrbTBJIahQ==
X-ME-Sender: <xms:50qCXvthqm1yIdNbJw-tmxzTQoLBpYLzPLlOXSkW1cb4F9ZASmN6vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:50qCXksvHGTgiNIjOuY0LcQHszfktiRVw6nllEoBCgnZs2CDPILa9w>
    <xmx:50qCXtxxTFc2iu1G-E7x7GVYxe9OU_5QTQaQwR2MZX-Nc1UB8peg-w>
    <xmx:50qCXigsp6flMctr4r4qG7wR56l9LfWcoqAfJdxA4MXp1WsoJvqGEA>
    <xmx:50qCXi0mtxSq9_DWO6MTr_AE1qcJDH4luH91OuYRg6EpS29nw8bevA>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A6DC306CA25;
        Mon, 30 Mar 2020 15:39:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 06/15] netdevsim: Add support for setting of packet trap group parameters
Date:   Mon, 30 Mar 2020 22:38:23 +0300
Message-Id: <20200330193832.2359876-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add a dummy callback to set trap group parameters. Return an error when
the 'fail_trap_group_set' debugfs file is set in order to exercise error
paths and verify that error is propagated to user space when should.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c       | 17 +++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index bda603cfe66a..1fe2a93ad382 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -215,6 +215,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 			    &nsim_dev->fail_reload);
 	debugfs_create_file("trap_flow_action_cookie", 0600, nsim_dev->ddir,
 			    nsim_dev, &nsim_dev_trap_fa_cookie_fops);
+	debugfs_create_bool("fail_trap_group_set", 0600,
+			    nsim_dev->ddir,
+			    &nsim_dev->fail_trap_group_set);
 	debugfs_create_bool("fail_trap_policer_set", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_set);
@@ -813,6 +816,19 @@ nsim_dev_devlink_trap_action_set(struct devlink *devlink,
 	return 0;
 }
 
+static int
+nsim_dev_devlink_trap_group_set(struct devlink *devlink,
+				const struct devlink_trap_group *group,
+				const struct devlink_trap_policer *policer)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+
+	if (nsim_dev->fail_trap_group_set)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int
 nsim_dev_devlink_trap_policer_set(struct devlink *devlink,
 				  const struct devlink_trap_policer *policer,
@@ -854,6 +870,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.flash_update = nsim_dev_flash_update,
 	.trap_init = nsim_dev_devlink_trap_init,
 	.trap_action_set = nsim_dev_devlink_trap_action_set,
+	.trap_group_set = nsim_dev_devlink_trap_group_set,
 	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
 };
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 3d37df5057e8..4ded54a21e1e 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -180,6 +180,7 @@ struct nsim_dev {
 	struct nsim_dev_health health;
 	struct flow_action_cookie *fa_cookie;
 	spinlock_t fa_cookie_lock; /* protects fa_cookie */
+	bool fail_trap_group_set;
 	bool fail_trap_policer_set;
 	bool fail_trap_policer_counter_get;
 };
-- 
2.24.1

