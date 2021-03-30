Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2E634DFD6
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhC3EAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhC3EAD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:00:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 722FC61987;
        Tue, 30 Mar 2021 04:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617076802;
        bh=tkjSjXClRM5fZ8WExJxUY1SzkBRPs9UF3TMj/Dv2FAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQfJNeCL3orGCNtUL2g1hGCXVa1a0NRFUHq4Nl+UvnJLioWJe8hwhTiyF4G0mPmc0
         98YaOjX3R8dcO05I6fJ6lS4KchotFSqbc7/6QmrfxIKgpHsHRkXrAY6cMJdTbPln2D
         FSJJKTk/XkjH+s4tC5Us5ng0k5SxxjfJqM0ebMFiMn0xdHu3s/oEagqMxKyiRvN7eD
         j9jEcYF5smN4sX9nr5RVxPLBS9eTEGpnRwRxC3ToQYKMRS+ByoKIVbKTD8qyK+tjzC
         pOtf874CTwgRG6C2hnVdAZS12EB4qnIfW6oYlVcvux4a/IjSh0SQuWSo1QF8gJI2u5
         CmrHwlTyvhMqQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] netdevsim: add FEC settings support
Date:   Mon, 29 Mar 2021 20:59:53 -0700
Message-Id: <20210330035954.1206441-3-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330035954.1206441-1-kuba@kernel.org>
References: <20210330035954.1206441-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ethtool FEC and some ethtool error injection.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/ethtool.c   | 36 +++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  3 +++
 2 files changed, 39 insertions(+)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index 166f0d6cbcf7..c9ae52595a8f 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -77,6 +77,34 @@ static int nsim_set_ringparam(struct net_device *dev,
 	return 0;
 }
 
+static int
+nsim_get_fecparam(struct net_device *dev, struct ethtool_fecparam *fecparam)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	if (ns->ethtool.get_err)
+		return -ns->ethtool.get_err;
+	memcpy(fecparam, &ns->ethtool.fec, sizeof(ns->ethtool.fec));
+	return 0;
+}
+
+static int
+nsim_set_fecparam(struct net_device *dev, struct ethtool_fecparam *fecparam)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+	u32 fec;
+
+	if (ns->ethtool.set_err)
+		return -ns->ethtool.set_err;
+	memcpy(&ns->ethtool.fec, fecparam, sizeof(ns->ethtool.fec));
+	fec = fecparam->fec;
+	if (fec == ETHTOOL_FEC_AUTO)
+		fec |= ETHTOOL_FEC_OFF;
+	fec |= ETHTOOL_FEC_NONE;
+	ns->ethtool.fec.active_fec = 1 << (fls(fec) - 1);
+	return 0;
+}
+
 static const struct ethtool_ops nsim_ethtool_ops = {
 	.supported_coalesce_params	= ETHTOOL_COALESCE_ALL_PARAMS,
 	.get_pause_stats	        = nsim_get_pause_stats,
@@ -86,6 +114,8 @@ static const struct ethtool_ops nsim_ethtool_ops = {
 	.get_coalesce			= nsim_get_coalesce,
 	.get_ringparam			= nsim_get_ringparam,
 	.set_ringparam			= nsim_set_ringparam,
+	.get_fecparam			= nsim_get_fecparam,
+	.set_fecparam			= nsim_set_fecparam,
 };
 
 static void nsim_ethtool_ring_init(struct netdevsim *ns)
@@ -104,8 +134,14 @@ void nsim_ethtool_init(struct netdevsim *ns)
 
 	nsim_ethtool_ring_init(ns);
 
+	ns->ethtool.fec.fec = ETHTOOL_FEC_NONE;
+	ns->ethtool.fec.active_fec = ETHTOOL_FEC_NONE;
+
 	ethtool = debugfs_create_dir("ethtool", ns->nsim_dev_port->ddir);
 
+	debugfs_create_u32("get_err", 0600, ethtool, &ns->ethtool.get_err);
+	debugfs_create_u32("set_err", 0600, ethtool, &ns->ethtool.set_err);
+
 	dir = debugfs_create_dir("pause", ethtool);
 	debugfs_create_bool("report_stats_rx", 0600, dir,
 			    &ns->ethtool.pauseparam.report_stats_rx);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index d735c21def4b..7ff24e03577b 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -60,9 +60,12 @@ struct nsim_ethtool_pauseparam {
 };
 
 struct nsim_ethtool {
+	u32 get_err;
+	u32 set_err;
 	struct nsim_ethtool_pauseparam pauseparam;
 	struct ethtool_coalesce coalesce;
 	struct ethtool_ringparam ring;
+	struct ethtool_fecparam fec;
 };
 
 struct netdevsim {
-- 
2.30.2

