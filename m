Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D57F191A07
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCXTeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:34:31 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:57351 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727150AbgCXTeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:34:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id F2ACF5800D2;
        Tue, 24 Mar 2020 15:34:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=eFOsw2RjHh3gr9pZlJvTr/Nd1QrCMaUuOjHldQWQwkI=; b=kBMcil93
        LpjlCycVbtIZu9sfnGwfTgrSJjVo6YSKWzvm2qWGp5CnVjR+4cEM7cJksWnZjbS4
        uu6Fwul4/smNKc+4cwKx3Uucbrgnwv4EJRk6rFVelhJw7FqLCRMbr7Kn2VnADZ50
        6+hYJ/kGmdcGYaIqATf9LySmZ7ADhyTspLZ6IKmRhXpevtKKHh+K4SkZVwzsU/TD
        JZv2M+7IHgYLocBIhzV3LYOEm97OUXP2KI9EIySz9RqiaiyjXlbnudePVlsw1aqh
        zARPk5icLi+J/drkoj+/cw/SMITEqhZFIMqqIz1H6Y5X49jaMcyi6zrt+OqblCYV
        vpZvdHTKh7wk5w==
X-ME-Sender: <xms:xmB6XnI44v6BYEFc7sXUp9OBEhzjhDED3Moor6eVygZu8kRl129mUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:xmB6XizFe6Rcp9dkb11BCTKUV7qfTApWqWbI_asOeSH8o1aGIDZJfQ>
    <xmx:xmB6XnGKw3j21eyjJ9mwCW6KRhU2-1wR6ydWFAiTXmpqxTRF0P7ADA>
    <xmx:xmB6Xq5l9kdBu7Z5VrR6uSlELxCKNN2BpbEZOn7uLa0n4rOx5uFzLQ>
    <xmx:xmB6XrWgi5kWpCgpUtfmgfSdexcw-W3FN-Ldjb6EyY0FWgqCBPCJ9w>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id DDBA0306551D;
        Tue, 24 Mar 2020 15:34:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/15] netdevsim: Add support for setting of packet trap group parameters
Date:   Tue, 24 Mar 2020 21:32:41 +0200
Message-Id: <20200324193250.1322038-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324193250.1322038-1-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
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
index c344d0f727c7..5349a7216f15 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -192,6 +192,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 			    &nsim_dev->fail_reload);
 	debugfs_create_file("trap_flow_action_cookie", 0600, nsim_dev->ddir,
 			    nsim_dev, &nsim_dev_trap_fa_cookie_fops);
+	debugfs_create_bool("fail_trap_group_set", 0600,
+			    nsim_dev->ddir,
+			    &nsim_dev->fail_trap_group_set);
 	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
@@ -769,6 +772,19 @@ nsim_dev_devlink_trap_action_set(struct devlink *devlink,
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
 #define NSIM_DEV_TRAP_POLICER_MIN_RATE	1
 #define NSIM_DEV_TRAP_POLICER_MAX_RATE	8000
 #define NSIM_DEV_TRAP_POLICER_MIN_BURST	8
@@ -836,6 +852,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.flash_update = nsim_dev_flash_update,
 	.trap_init = nsim_dev_devlink_trap_init,
 	.trap_action_set = nsim_dev_devlink_trap_action_set,
+	.trap_group_set = nsim_dev_devlink_trap_group_set,
 	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
 };
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 68788dae5625..f78d8adee014 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -180,6 +180,7 @@ struct nsim_dev {
 	struct nsim_dev_health health;
 	struct flow_action_cookie *fa_cookie;
 	spinlock_t fa_cookie_lock; /* protects fa_cookie */
+	bool fail_trap_group_set;
 	bool fail_trap_policer_counter_get;
 };
 
-- 
2.24.1

