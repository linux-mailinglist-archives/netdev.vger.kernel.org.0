Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7A0405FE1
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 01:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348640AbhIIXLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 19:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348315AbhIIXL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 19:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B217A611AD;
        Thu,  9 Sep 2021 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631229017;
        bh=2herY1xd9DJ2siUB4ATXasFn2x1aHAQ+tTs2qP7D81s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZoaZUFfkVuTNO2GVu6YrVzynWD+eJuWD75rPEbgw8YWkjMLt8Gg05mXCXKyW5KVc
         +3Fx5ui9IUJqkPgkyX6RpQhyyH4OpgD22p/mNGpH7IVofdZa9scJ+Kuck+DHtWsHBl
         lxTRYlaGoRntwDD6r6ym7EisvTY+HGNvpuBlayzExf9EWb03yM+AwyH+mWW7rFKOB1
         0QAg0ReaER/ZAFM2cxyvqxdXMWr9YyypSDRxhUL+F65GkR53mXtVFCc119Y3X+43dt
         tJvR1DryZaZFhFarxxk+LqDjeLoeHvaxqtSwXE6HWUvFxVuUf0cZGI67lXWsqEIGqm
         hpr/MOwPpGp7w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/3] netdevsim: add ability to change channel count
Date:   Thu,  9 Sep 2021 16:10:03 -0700
Message-Id: <20210909231004.196905-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210909231004.196905-1-kuba@kernel.org>
References: <20210909231004.196905-1-kuba@kernel.org>
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

