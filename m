Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938C540A11D
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 00:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349509AbhIMW52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 18:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348400AbhIMWyw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 18:54:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B46FE6112E;
        Mon, 13 Sep 2021 22:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631573616;
        bh=2herY1xd9DJ2siUB4ATXasFn2x1aHAQ+tTs2qP7D81s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJ2jF6OERzbXrT570fe2yfidjW6Mh0I9HEwX3cSa09YOjBtlDqS2VY2xIVhN2zrA0
         gG345GnQctPGfrAbSY9CHOBeyf0DrwiKKyA1aMLmlQjbtE2yFZ/dLXZxcz214atrsx
         1rl2zhcSb07TQZV3Ct0tNlG7qzITSPwRci902meae/qBIrG45mml9DW9O+lDuRs/vK
         5vf2vceTHKaJme58agu+fxnK0D41iRymICAj6PbXDfcPK6CjogQQ7oObSZyg6OqLJh
         MxNhftc2KqKboDUluyJonJKXO85sRoBDqk4WTgjCNn5ODyHxsxbE7ifU2MGANPpbHA
         pxKW7LPYaDmsA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] netdevsim: add ability to change channel count
Date:   Mon, 13 Sep 2021 15:53:31 -0700
Message-Id: <20210913225332.662291-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913225332.662291-1-kuba@kernel.org>
References: <20210913225332.662291-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For testing visibility of mq/mqprio default children.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/ethtool.c   | 28 ++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index b03a0513eb7e..0ab6a40be611 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -81,6 +81,30 @@ static int nsim_set_ringparam(struct net_device *dev,
 	return 0;
 }
 
+static void
+nsim_get_channels(struct net_device *dev, struct ethtool_channels *ch)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	ch->max_combined = ns->nsim_bus_dev->num_queues;
+	ch->combined_count = ns->ethtool.channels;
+}
+
+static int
+nsim_set_channels(struct net_device *dev, struct ethtool_channels *ch)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+	int err;
+
+	err = netif_set_real_num_queues(dev, ch->combined_count,
+					ch->combined_count);
+	if (err)
+		return err;
+
+	ns->ethtool.channels = ch->combined_count;
+	return 0;
+}
+
 static int
 nsim_get_fecparam(struct net_device *dev, struct ethtool_fecparam *fecparam)
 {
@@ -118,6 +142,8 @@ static const struct ethtool_ops nsim_ethtool_ops = {
 	.get_coalesce			= nsim_get_coalesce,
 	.get_ringparam			= nsim_get_ringparam,
 	.set_ringparam			= nsim_set_ringparam,
+	.get_channels			= nsim_get_channels,
+	.set_channels			= nsim_set_channels,
 	.get_fecparam			= nsim_get_fecparam,
 	.set_fecparam			= nsim_set_fecparam,
 };
@@ -141,6 +167,8 @@ void nsim_ethtool_init(struct netdevsim *ns)
 	ns->ethtool.fec.fec = ETHTOOL_FEC_NONE;
 	ns->ethtool.fec.active_fec = ETHTOOL_FEC_NONE;
 
+	ns->ethtool.channels = ns->nsim_bus_dev->num_queues;
+
 	ethtool = debugfs_create_dir("ethtool", ns->nsim_dev_port->ddir);
 
 	debugfs_create_u32("get_err", 0600, ethtool, &ns->ethtool.get_err);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 793c86dc5a9c..d42eec05490f 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -62,6 +62,7 @@ struct nsim_ethtool_pauseparam {
 struct nsim_ethtool {
 	u32 get_err;
 	u32 set_err;
+	u32 channels;
 	struct nsim_ethtool_pauseparam pauseparam;
 	struct ethtool_coalesce coalesce;
 	struct ethtool_ringparam ring;
-- 
2.31.1

