Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6022B41C273
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245449AbhI2KSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245418AbhI2KSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:18:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 646F4613A5;
        Wed, 29 Sep 2021 10:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632910611;
        bh=lA8WUo/+NGUBXAShC+sjos7pew5KebdIN8DiTIW2984=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSpJhV2+J5T+2HEqPitvtj27o68uSnDt46b9mVGz5BBrgUjLbW1CQccH1ATFbj7OG
         7QDWNjlnbCo4AuJbUYK3ZB0kuxPvqWNtszVUVWeSUJFu+xw2Les2D5rJvPQwMskRiw
         +Boj0k4X2Q8bhnw8VsSIO7wst9oAukH196yHabnu2a+NjpD05gu06Yk9LaWaguDtCq
         eYvWnp3roLSM8PRR0R6Fn98qOWKeMvjOl8XIaS/zYG7x6DQT3tDEhbjxO21swCG0aq
         tKQao7GzFXyJfS5U5CZhrPt9frLK3A5G/ID3h/aNFprO+biwuRw6feIloG2x3DCWiY
         Fai7FFCcDc7ag==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Shay Drory <shayd@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next 3/5] devlink: Allow set specific ops callbacks dynamically
Date:   Wed, 29 Sep 2021 13:16:37 +0300
Message-Id: <4e99e3996118ce0e2da5367b8fc2a427095dfffd.1632909221.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632909221.git.leonro@nvidia.com>
References: <cover.1632909221.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Introduce new devlink call to set specific ops callback during
device initialization phase after devlink_alloc() is already
called.

This allows us to set reload_* specific ops based on device property
which sometimes is known almost at the end of driver initialization.

For the sake of simplicity, this API lacks any type of locking and
needs to be called before devlink_register() to make sure that no
parallel access to the ops is possible at this stage.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/devlink.h |  1 +
 net/core/devlink.c    | 41 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 317b09917c41..305be548ac21 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1565,6 +1565,7 @@ static inline struct devlink *devlink_alloc(struct devlink_ops *ops,
 {
 	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
 }
+void devlink_set_ops(struct devlink *devlink, struct devlink_ops *ops);
 void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_reload_enable(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index cee2be47c40e..71d0c5671f43 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8907,6 +8907,43 @@ static bool devlink_reload_actions_valid(struct devlink_ops *ops)
 	return true;
 }
 
+/**
+ *	devlink_set_ops - Set devlink ops dynamically
+ *
+ *	@devlink: devlink
+ *	@ops: devlink ops to set
+ *
+ *	This interface allows us to set ops based on device property
+ *	which is known after devlink_alloc() was already called. For now,
+ *	it is applicable for reload_* assignments only and all other
+ *	callbacks are ignored.
+ *
+ *	It should be called before devlink_register(), so doesn't have any
+ *	protection from concurent access.
+ */
+void devlink_set_ops(struct devlink *devlink, struct devlink_ops *ops)
+{
+	struct devlink_ops *dev_ops = devlink->ops;
+
+	WARN_ON(!devlink_reload_actions_valid(ops));
+
+#define SET_DEVICE_OP(ptr, name)                                               \
+	do {                                                                   \
+		if (ops->name)                                                 \
+			if (!((ptr)->name))				       \
+				(ptr)->name = ops->name;                       \
+	} while (0)
+
+	/* Keep sorted */
+	SET_DEVICE_OP(dev_ops, reload_actions);
+	SET_DEVICE_OP(dev_ops, reload_down);
+	SET_DEVICE_OP(dev_ops, reload_limits);
+	SET_DEVICE_OP(dev_ops, reload_up);
+
+#undef SET_DEVICE_OP
+}
+EXPORT_SYMBOL_GPL(devlink_set_ops);
+
 /**
  *	devlink_alloc_ns - Allocate new devlink instance resources
  *	in specific namespace
@@ -8927,8 +8964,6 @@ struct devlink *devlink_alloc_ns(struct devlink_ops *ops, size_t priv_size,
 	int ret;
 
 	WARN_ON(!ops || !dev);
-	if (!devlink_reload_actions_valid(ops))
-		return NULL;
 
 	devlink = kzalloc(sizeof(*devlink) + priv_size, GFP_KERNEL);
 	if (!devlink)
@@ -8943,6 +8978,8 @@ struct devlink *devlink_alloc_ns(struct devlink_ops *ops, size_t priv_size,
 
 	devlink->dev = dev;
 	devlink->ops = ops;
+	/* To check validity of reload actions */
+	devlink_set_ops(devlink, ops);
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	write_pnet(&devlink->_net, net);
 	INIT_LIST_HEAD(&devlink->port_list);
-- 
2.31.1

