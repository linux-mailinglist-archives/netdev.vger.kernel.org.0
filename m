Return-Path: <netdev+bounces-10110-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0628872C49C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36BA71C20909
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FB8171CA;
	Mon, 12 Jun 2023 12:41:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD78168CA;
	Mon, 12 Jun 2023 12:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB26C433EF;
	Mon, 12 Jun 2023 12:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686573711;
	bh=L6SKPZEB4iig2lGJu+4rZ2K6vhnK52Rq0MvFETPiOk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6+ap7IononxCwcx2ewycNMfLkstWxYTSLdX5ZeKZuOgLM6Kc7xgyizwUpo6Y7UAH
	 LKEJwZgXt0TEkUXBf2Ks0MKoGAEAaBcvTeY2GLxLi5ynEnKCE51s/ge0/Diu139lPL
	 amBCjdRTBlvEYoNEsSm/qnqtzvjJA/AjwgpwLLI3poTAMcTxds2EfqOhNTIAONWSI3
	 xTlwDAb1l/42NE6Ryuqg/dpPKb5fsem/EHG04osEHQn45DofAREZaifNtQmG+vbEWN
	 Mm814jzRhpWW4sSzf3prfK6dJVbWbyF4u/vosHq0rWksKQCYA0scf6wQTP1GvDj2eT
	 21GviI6my+zyQ==
From: Arnd Bergmann <arnd@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
	linux-omap@vger.kernel.org,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Tero Kristo <kristo@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Mao Wenan <maowenan@huawei.com>,
	Andrew Lunn <andrew@lunn.ch>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Roger Quadros <rogerq@kernel.org>,
	Simon Horman <simon.horman@corigine.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	bpf@vger.kernel.org
Subject: [PATCH 3/3] net: ethernet: ti-cpsw: fix linking built-in code to modules
Date: Mon, 12 Jun 2023 14:40:06 +0200
Message-Id: <20230612124024.520720-3-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230612124024.520720-1-arnd@kernel.org>
References: <20230612124024.520720-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

There are six variants of the cpsw driver, sharing various parts of
the code: davinci-emac, cpsw, cpsw-switchdev, netcp, netcp_ethss and
am65-cpsw-nuss.

I noticed that this means some files can be linked into more than
one loadable module, or even part of vmlinux but also linked into
a loadable module, both of which mess up assumptions of the build
system.

Change this back to having separate modules for each portion that
can be linked standalone, exporting symbols as needed:

 - ti-cpsw-common.ko now contains both cpsw-common.o and
   davinci_cpdma.o as they are always used together

 - ti-cpsw-priv.ko contains cpsw_priv.o, cpsw_sl.o and cpsw_ethtool.o,
   which are the core of the cpsw and cpsw-new drivers.

 - ti-cpsw-ale.o is the one standalone module that is used by all
   except davinci_emac.

Each of these will be built-in if any of its users are built-in,
otherwise it's a loadable module if there is at least one module
using it. I did not bring back the separate Kconfig symbols for
this, but just handle it using Makefile logic.

Note: ideally this is something that Kbuild complains about, but
usually we just notice when something using THIS_MODULS misbehaves
in a way that a user notices.

Fixes: 99f6297182729 ("net: ethernet: ti: cpsw: drop TI_DAVINCI_CPDMA config option")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/ti/Makefile        | 29 +++++++++++-----------
 drivers/net/ethernet/ti/cpsw_ale.c      | 23 +++++++++++++++++
 drivers/net/ethernet/ti/cpsw_ethtool.c  | 25 +++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.c     | 33 +++++++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_sl.c       |  8 ++++++
 drivers/net/ethernet/ti/davinci_cpdma.c | 27 ++++++++++++++++++++
 6 files changed, 130 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
index 75f761efbea71..d1f44f7667a96 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -3,28 +3,27 @@
 # Makefile for the TI network device drivers.
 #
 
-obj-$(CONFIG_TI_CPSW) += cpsw-common.o
-obj-$(CONFIG_TI_DAVINCI_EMAC) += cpsw-common.o
-obj-$(CONFIG_TI_CPSW_SWITCHDEV) += cpsw-common.o
+ti-cpsw-common-y += cpsw-common.o davinci_cpdma.o
+ti-cpsw-priv-y += cpsw_priv.o cpsw_sl.o cpsw_ethtool.o
+ti-cpsw-ale-y += cpsw_ale.o
 
 obj-$(CONFIG_TLAN) += tlan.o
 obj-$(CONFIG_CPMAC) += cpmac.o
-obj-$(CONFIG_TI_DAVINCI_EMAC) += ti_davinci_emac.o
-ti_davinci_emac-y := davinci_emac.o davinci_cpdma.o
+obj-$(CONFIG_TI_DAVINCI_EMAC) += davinci_emac.o ti-cpsw-common.o
 obj-$(CONFIG_TI_DAVINCI_MDIO) += davinci_mdio.o
 obj-$(CONFIG_TI_CPSW_PHY_SEL) += cpsw-phy-sel.o
 obj-$(CONFIG_TI_CPTS) += cpts.o
-obj-$(CONFIG_TI_CPSW) += ti_cpsw.o
-ti_cpsw-y := cpsw.o davinci_cpdma.o cpsw_ale.o cpsw_priv.o cpsw_sl.o cpsw_ethtool.o
-obj-$(CONFIG_TI_CPSW_SWITCHDEV) += ti_cpsw_new.o
-ti_cpsw_new-y := cpsw_switchdev.o cpsw_new.o davinci_cpdma.o cpsw_ale.o cpsw_sl.o cpsw_priv.o cpsw_ethtool.o
+obj-$(CONFIG_TI_CPSW) += ti_cpsw.o ti-cpsw-common.o ti-cpsw-priv.o ti-cpsw-ale.o
+ti_cpsw-y := cpsw.o
+obj-$(CONFIG_TI_CPSW_SWITCHDEV) += ti_cpsw_new.o ti-cpsw-common.o ti-cpsw-priv.o ti-cpsw-ale.o
+ti_cpsw_new-y := cpsw_switchdev.o cpsw_new.o
 
-obj-$(CONFIG_TI_KEYSTONE_NETCP) += keystone_netcp.o
-keystone_netcp-y := netcp_core.o cpsw_ale.o
-obj-$(CONFIG_TI_KEYSTONE_NETCP_ETHSS) += keystone_netcp_ethss.o
-keystone_netcp_ethss-y := netcp_ethss.o netcp_sgmii.o netcp_xgbepcsr.o cpsw_ale.o
+obj-$(CONFIG_TI_KEYSTONE_NETCP) += keystone_netcp.o ti-cpsw-ale.o
+keystone_netcp-y := netcp_core.o
+obj-$(CONFIG_TI_KEYSTONE_NETCP_ETHSS) += keystone_netcp_ethss.o ti-cpsw-ale.o
+keystone_netcp_ethss-y := netcp_ethss.o netcp_sgmii.o netcp_xgbepcsr.o
 
-obj-$(CONFIG_TI_K3_AM65_CPSW_NUSS) += ti-am65-cpsw-nuss.o
-ti-am65-cpsw-nuss-y := am65-cpsw-nuss.o cpsw_sl.o am65-cpsw-ethtool.o cpsw_ale.o k3-cppi-desc-pool.o am65-cpsw-qos.o
+obj-$(CONFIG_TI_K3_AM65_CPSW_NUSS) += ti-am65-cpsw-nuss.o ti-cpsw-priv.o ti-cpsw-ale.o
+ti-am65-cpsw-nuss-y := am65-cpsw-nuss.o am65-cpsw-ethtool.o k3-cppi-desc-pool.o am65-cpsw-qos.o
 ti-am65-cpsw-nuss-$(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV) += am65-cpsw-switchdev.o
 obj-$(CONFIG_TI_K3_AM65_CPTS) += am65-cpts.o
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 0c5e783e574c4..589808a93b2c7 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -452,6 +452,7 @@ int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int port_mask, int vid)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_flush_multicast);
 
 static inline void cpsw_ale_set_vlan_entry_type(u32 *ale_entry,
 						int flags, u16 vid)
@@ -489,6 +490,7 @@ int cpsw_ale_add_ucast(struct cpsw_ale *ale, const u8 *addr, int port,
 	cpsw_ale_write(ale, idx, ale_entry);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_add_ucast);
 
 int cpsw_ale_del_ucast(struct cpsw_ale *ale, const u8 *addr, int port,
 		       int flags, u16 vid)
@@ -504,6 +506,7 @@ int cpsw_ale_del_ucast(struct cpsw_ale *ale, const u8 *addr, int port,
 	cpsw_ale_write(ale, idx, ale_entry);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_del_ucast);
 
 int cpsw_ale_add_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask,
 		       int flags, u16 vid, int mcast_state)
@@ -537,6 +540,7 @@ int cpsw_ale_add_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask,
 	cpsw_ale_write(ale, idx, ale_entry);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_add_mcast);
 
 int cpsw_ale_del_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask,
 		       int flags, u16 vid)
@@ -566,6 +570,7 @@ int cpsw_ale_del_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask,
 	cpsw_ale_write(ale, idx, ale_entry);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_del_mcast);
 
 /* ALE NetCP NU switch specific vlan functions */
 static void cpsw_ale_set_vlan_mcast(struct cpsw_ale *ale, u32 *ale_entry,
@@ -635,6 +640,7 @@ int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port_mask, int untag,
 	cpsw_ale_write(ale, idx, ale_entry);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_add_vlan);
 
 static void cpsw_ale_vlan_del_modify_int(struct cpsw_ale *ale,  u32 *ale_entry,
 					 u16 vid, int port_mask)
@@ -692,6 +698,7 @@ int cpsw_ale_vlan_del_modify(struct cpsw_ale *ale, u16 vid, int port_mask)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_vlan_del_modify);
 
 int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 {
@@ -726,6 +733,7 @@ int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_del_vlan);
 
 int cpsw_ale_vlan_add_modify(struct cpsw_ale *ale, u16 vid, int port_mask,
 			     int untag_mask, int reg_mask, int unreg_mask)
@@ -765,6 +773,7 @@ int cpsw_ale_vlan_add_modify(struct cpsw_ale *ale, u16 vid, int port_mask,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_vlan_add_modify);
 
 void cpsw_ale_set_unreg_mcast(struct cpsw_ale *ale, int unreg_mcast_mask,
 			      bool add)
@@ -792,6 +801,7 @@ void cpsw_ale_set_unreg_mcast(struct cpsw_ale *ale, int unreg_mcast_mask,
 		cpsw_ale_write(ale, idx, ale_entry);
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_set_unreg_mcast);
 
 static void cpsw_ale_vlan_set_unreg_mcast(struct cpsw_ale *ale, u32 *ale_entry,
 					  int allmulti)
@@ -857,6 +867,7 @@ void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti, int port)
 		cpsw_ale_write(ale, idx, ale_entry);
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_set_allmulti);
 
 struct ale_control_info {
 	const char	*name;
@@ -1114,6 +1125,7 @@ int cpsw_ale_control_set(struct cpsw_ale *ale, int port, int control,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_control_set);
 
 int cpsw_ale_control_get(struct cpsw_ale *ale, int port, int control)
 {
@@ -1137,6 +1149,7 @@ int cpsw_ale_control_get(struct cpsw_ale *ale, int port, int control)
 	tmp = readl_relaxed(ale->params.ale_regs + offset) >> shift;
 	return tmp & BITMASK(info->bits);
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_control_get);
 
 int cpsw_ale_rx_ratelimit_mc(struct cpsw_ale *ale, int port, unsigned int ratelimit_pps)
 
@@ -1159,6 +1172,7 @@ int cpsw_ale_rx_ratelimit_mc(struct cpsw_ale *ale, int port, unsigned int rateli
 		port, val * ALE_RATE_LIMIT_MIN_PPS);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_rx_ratelimit_mc);
 
 int cpsw_ale_rx_ratelimit_bc(struct cpsw_ale *ale, int port, unsigned int ratelimit_pps)
 
@@ -1181,6 +1195,7 @@ int cpsw_ale_rx_ratelimit_bc(struct cpsw_ale *ale, int port, unsigned int rateli
 		port, val * ALE_RATE_LIMIT_MIN_PPS);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_rx_ratelimit_bc);
 
 static void cpsw_ale_timer(struct timer_list *t)
 {
@@ -1270,6 +1285,7 @@ void cpsw_ale_start(struct cpsw_ale *ale)
 
 	cpsw_ale_aging_start(ale);
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_start);
 
 void cpsw_ale_stop(struct cpsw_ale *ale)
 {
@@ -1277,6 +1293,7 @@ void cpsw_ale_stop(struct cpsw_ale *ale)
 	cpsw_ale_control_set(ale, 0, ALE_CLEAR, 1);
 	cpsw_ale_control_set(ale, 0, ALE_ENABLE, 0);
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_stop);
 
 static const struct cpsw_ale_dev_id cpsw_ale_id_match[] = {
 	{
@@ -1441,6 +1458,7 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 	cpsw_ale_control_set(ale, 0, ALE_CLEAR, 1);
 	return ale;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_create);
 
 void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data)
 {
@@ -1451,6 +1469,7 @@ void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data)
 		data += ALE_ENTRY_WORDS;
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_dump);
 
 void cpsw_ale_restore(struct cpsw_ale *ale, u32 *data)
 {
@@ -1461,8 +1480,12 @@ void cpsw_ale_restore(struct cpsw_ale *ale, u32 *data)
 		data += ALE_ENTRY_WORDS;
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_restore);
 
 u32 cpsw_ale_get_num_entries(struct cpsw_ale *ale)
 {
 	return ale ? ale->params.ale_entries : 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_ale_get_num_entries);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index a557a477d0393..619bc9632b44b 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -144,6 +144,7 @@ u32 cpsw_get_msglevel(struct net_device *ndev)
 
 	return priv->msg_enable;
 }
+EXPORT_SYMBOL_GPL(cpsw_get_msglevel);
 
 void cpsw_set_msglevel(struct net_device *ndev, u32 value)
 {
@@ -151,6 +152,7 @@ void cpsw_set_msglevel(struct net_device *ndev, u32 value)
 
 	priv->msg_enable = value;
 }
+EXPORT_SYMBOL_GPL(cpsw_set_msglevel);
 
 int cpsw_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal,
 		      struct kernel_ethtool_coalesce *kernel_coal,
@@ -161,6 +163,7 @@ int cpsw_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal,
 	coal->rx_coalesce_usecs = cpsw->coal_intvl;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_get_coalesce);
 
 int cpsw_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal,
 		      struct kernel_ethtool_coalesce *kernel_coal,
@@ -220,6 +223,7 @@ int cpsw_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *coal,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_set_coalesce);
 
 int cpsw_get_sset_count(struct net_device *ndev, int sset)
 {
@@ -234,6 +238,7 @@ int cpsw_get_sset_count(struct net_device *ndev, int sset)
 		return -EOPNOTSUPP;
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_get_sset_count);
 
 static void cpsw_add_ch_strings(u8 **p, int ch_num, int rx_dir)
 {
@@ -271,6 +276,7 @@ void cpsw_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 		break;
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_get_strings);
 
 void cpsw_get_ethtool_stats(struct net_device *ndev,
 			    struct ethtool_stats *stats, u64 *data)
@@ -303,6 +309,7 @@ void cpsw_get_ethtool_stats(struct net_device *ndev,
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_get_ethtool_stats);
 
 void cpsw_get_pauseparam(struct net_device *ndev,
 			 struct ethtool_pauseparam *pause)
@@ -313,6 +320,7 @@ void cpsw_get_pauseparam(struct net_device *ndev,
 	pause->rx_pause = priv->rx_pause ? true : false;
 	pause->tx_pause = priv->tx_pause ? true : false;
 }
+EXPORT_SYMBOL_GPL(cpsw_get_pauseparam);
 
 void cpsw_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
@@ -326,6 +334,7 @@ void cpsw_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 	if (cpsw->slaves[slave_no].phy)
 		phy_ethtool_get_wol(cpsw->slaves[slave_no].phy, wol);
 }
+EXPORT_SYMBOL_GPL(cpsw_get_wol);
 
 int cpsw_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
@@ -338,6 +347,7 @@ int cpsw_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 	else
 		return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_GPL(cpsw_set_wol);
 
 int cpsw_get_regs_len(struct net_device *ndev)
 {
@@ -346,6 +356,7 @@ int cpsw_get_regs_len(struct net_device *ndev)
 	return cpsw_ale_get_num_entries(cpsw->ale) *
 	       ALE_ENTRY_WORDS * sizeof(u32);
 }
+EXPORT_SYMBOL_GPL(cpsw_get_regs_len);
 
 void cpsw_get_regs(struct net_device *ndev, struct ethtool_regs *regs, void *p)
 {
@@ -357,6 +368,7 @@ void cpsw_get_regs(struct net_device *ndev, struct ethtool_regs *regs, void *p)
 
 	cpsw_ale_dump(cpsw->ale, reg);
 }
+EXPORT_SYMBOL_GPL(cpsw_get_regs);
 
 int cpsw_ethtool_op_begin(struct net_device *ndev)
 {
@@ -370,6 +382,7 @@ int cpsw_ethtool_op_begin(struct net_device *ndev)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpsw_ethtool_op_begin);
 
 void cpsw_ethtool_op_complete(struct net_device *ndev)
 {
@@ -380,6 +393,7 @@ void cpsw_ethtool_op_complete(struct net_device *ndev)
 	if (ret < 0)
 		cpsw_err(priv, drv, "ethtool complete failed %d\n", ret);
 }
+EXPORT_SYMBOL_GPL(cpsw_ethtool_op_complete);
 
 void cpsw_get_channels(struct net_device *ndev, struct ethtool_channels *ch)
 {
@@ -394,6 +408,7 @@ void cpsw_get_channels(struct net_device *ndev, struct ethtool_channels *ch)
 	ch->tx_count = cpsw->tx_ch_num;
 	ch->combined_count = 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_get_channels);
 
 int cpsw_get_link_ksettings(struct net_device *ndev,
 			    struct ethtool_link_ksettings *ecmd)
@@ -408,6 +423,7 @@ int cpsw_get_link_ksettings(struct net_device *ndev,
 	phy_ethtool_ksettings_get(cpsw->slaves[slave_no].phy, ecmd);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_get_link_ksettings);
 
 int cpsw_set_link_ksettings(struct net_device *ndev,
 			    const struct ethtool_link_ksettings *ecmd)
@@ -421,6 +437,7 @@ int cpsw_set_link_ksettings(struct net_device *ndev,
 
 	return phy_ethtool_ksettings_set(cpsw->slaves[slave_no].phy, ecmd);
 }
+EXPORT_SYMBOL_GPL(cpsw_set_link_ksettings);
 
 int cpsw_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
 {
@@ -433,6 +450,7 @@ int cpsw_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
 	else
 		return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_GPL(cpsw_get_eee);
 
 int cpsw_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
 {
@@ -445,6 +463,7 @@ int cpsw_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
 	else
 		return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_GPL(cpsw_set_eee);
 
 int cpsw_nway_reset(struct net_device *ndev)
 {
@@ -457,6 +476,7 @@ int cpsw_nway_reset(struct net_device *ndev)
 	else
 		return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_GPL(cpsw_nway_reset);
 
 static void cpsw_suspend_data_pass(struct net_device *ndev)
 {
@@ -654,6 +674,7 @@ int cpsw_set_channels_common(struct net_device *ndev,
 	cpsw_fail(cpsw);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpsw_set_channels_common);
 
 void cpsw_get_ringparam(struct net_device *ndev,
 			struct ethtool_ringparam *ering,
@@ -669,6 +690,7 @@ void cpsw_get_ringparam(struct net_device *ndev,
 	ering->rx_max_pending = cpsw->descs_pool_size - CPSW_MAX_QUEUES;
 	ering->rx_pending = cpdma_get_num_rx_descs(cpsw->dma);
 }
+EXPORT_SYMBOL_GPL(cpsw_get_ringparam);
 
 int cpsw_set_ringparam(struct net_device *ndev,
 		       struct ethtool_ringparam *ering,
@@ -715,6 +737,7 @@ int cpsw_set_ringparam(struct net_device *ndev,
 	cpsw_fail(cpsw);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpsw_set_ringparam);
 
 #if IS_ENABLED(CONFIG_TI_CPTS)
 int cpsw_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
@@ -737,6 +760,7 @@ int cpsw_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
 		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_get_ts_info);
 #else
 int cpsw_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
 {
@@ -749,4 +773,5 @@ int cpsw_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
 	info->rx_filters = 0;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_get_ts_info);
 #endif
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 4ebe8bc325730..29338a26a2b56 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -32,6 +32,7 @@
 #define CPTS_N_ETX_TS 4
 
 int (*cpsw_slave_index)(struct cpsw_common *cpsw, struct cpsw_priv *priv);
+EXPORT_SYMBOL_GPL(cpsw_slave_index);
 
 void cpsw_intr_enable(struct cpsw_common *cpsw)
 {
@@ -40,6 +41,7 @@ void cpsw_intr_enable(struct cpsw_common *cpsw)
 
 	cpdma_ctlr_int_ctrl(cpsw->dma, true);
 }
+EXPORT_SYMBOL_GPL(cpsw_intr_enable);
 
 void cpsw_intr_disable(struct cpsw_common *cpsw)
 {
@@ -48,6 +50,7 @@ void cpsw_intr_disable(struct cpsw_common *cpsw)
 
 	cpdma_ctlr_int_ctrl(cpsw->dma, false);
 }
+EXPORT_SYMBOL_GPL(cpsw_intr_disable);
 
 void cpsw_tx_handler(void *token, int len, int status)
 {
@@ -82,6 +85,7 @@ void cpsw_tx_handler(void *token, int len, int status)
 	ndev->stats.tx_packets++;
 	ndev->stats.tx_bytes += len;
 }
+EXPORT_SYMBOL_GPL(cpsw_tx_handler);
 
 irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id)
 {
@@ -98,6 +102,7 @@ irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id)
 	napi_schedule(&cpsw->napi_tx);
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(cpsw_tx_interrupt);
 
 irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id)
 {
@@ -114,6 +119,7 @@ irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id)
 	napi_schedule(&cpsw->napi_rx);
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(cpsw_rx_interrupt);
 
 irqreturn_t cpsw_misc_interrupt(int irq, void *dev_id)
 {
@@ -126,6 +132,7 @@ irqreturn_t cpsw_misc_interrupt(int irq, void *dev_id)
 
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(cpsw_misc_interrupt);
 
 int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
 {
@@ -158,6 +165,7 @@ int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
 
 	return num_tx;
 }
+EXPORT_SYMBOL_GPL(cpsw_tx_mq_poll);
 
 int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
 {
@@ -176,6 +184,7 @@ int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
 
 	return num_tx;
 }
+EXPORT_SYMBOL_GPL(cpsw_tx_poll);
 
 int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 {
@@ -208,6 +217,7 @@ int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 
 	return num_rx;
 }
+EXPORT_SYMBOL_GPL(cpsw_rx_mq_poll);
 
 int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
 {
@@ -226,6 +236,7 @@ int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
 
 	return num_rx;
 }
+EXPORT_SYMBOL_GPL(cpsw_rx_poll);
 
 void cpsw_rx_vlan_encap(struct sk_buff *skb)
 {
@@ -268,12 +279,14 @@ void cpsw_rx_vlan_encap(struct sk_buff *skb)
 		skb_pull(skb, VLAN_HLEN);
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_rx_vlan_encap);
 
 void cpsw_set_slave_mac(struct cpsw_slave *slave, struct cpsw_priv *priv)
 {
 	slave_write(slave, mac_hi(priv->mac_addr), SA_HI);
 	slave_write(slave, mac_lo(priv->mac_addr), SA_LO);
 }
+EXPORT_SYMBOL_GPL(cpsw_set_slave_mac);
 
 void cpsw_soft_reset(const char *module, void __iomem *reg)
 {
@@ -286,6 +299,7 @@ void cpsw_soft_reset(const char *module, void __iomem *reg)
 
 	WARN(readl_relaxed(reg) & 1, "failed to soft-reset %s\n", module);
 }
+EXPORT_SYMBOL_GPL(cpsw_soft_reset);
 
 void cpsw_ndo_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
@@ -305,6 +319,7 @@ void cpsw_ndo_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 	netif_trans_update(ndev);
 	netif_tx_wake_all_queues(ndev);
 }
+EXPORT_SYMBOL_GPL(cpsw_ndo_tx_timeout);
 
 static int cpsw_get_common_speed(struct cpsw_common *cpsw)
 {
@@ -343,6 +358,7 @@ int cpsw_need_resplit(struct cpsw_common *cpsw)
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(cpsw_need_resplit);
 
 void cpsw_split_res(struct cpsw_common *cpsw)
 {
@@ -428,6 +444,7 @@ void cpsw_split_res(struct cpsw_common *cpsw)
 	if (budget)
 		cpsw->rxv[0].budget += budget;
 }
+EXPORT_SYMBOL_GPL(cpsw_split_res);
 
 int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 		     int ale_ageout, phys_addr_t desc_mem_phys,
@@ -548,6 +565,7 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpsw_init_common);
 
 #if IS_ENABLED(CONFIG_TI_CPTS)
 
@@ -729,6 +747,7 @@ int cpsw_ndo_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 
 	return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_GPL(cpsw_ndo_ioctl);
 
 int cpsw_ndo_set_tx_maxrate(struct net_device *ndev, int queue, u32 rate)
 {
@@ -778,6 +797,7 @@ int cpsw_ndo_set_tx_maxrate(struct net_device *ndev, int queue, u32 rate)
 	cpsw_split_res(cpsw);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpsw_ndo_set_tx_maxrate);
 
 static int cpsw_tc_to_fifo(int tc, int num_tc)
 {
@@ -802,6 +822,7 @@ bool cpsw_shp_is_off(struct cpsw_priv *priv)
 
 	return !val;
 }
+EXPORT_SYMBOL_GPL(cpsw_shp_is_off);
 
 static void cpsw_fifo_shp_on(struct cpsw_priv *priv, int fifo, int on)
 {
@@ -1063,6 +1084,7 @@ int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		return -EOPNOTSUPP;
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_ndo_setup_tc);
 
 void cpsw_cbs_resume(struct cpsw_slave *slave, struct cpsw_priv *priv)
 {
@@ -1076,6 +1098,7 @@ void cpsw_cbs_resume(struct cpsw_slave *slave, struct cpsw_priv *priv)
 		cpsw_set_fifo_rlimit(priv, fifo, bw);
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_cbs_resume);
 
 void cpsw_mqprio_resume(struct cpsw_slave *slave, struct cpsw_priv *priv)
 {
@@ -1098,6 +1121,7 @@ void cpsw_mqprio_resume(struct cpsw_slave *slave, struct cpsw_priv *priv)
 
 	slave_write(slave, tx_prio_map, tx_prio_rg);
 }
+EXPORT_SYMBOL_GPL(cpsw_mqprio_resume);
 
 int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 {
@@ -1143,6 +1167,7 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_fill_rx_channels);
 
 static struct page_pool *cpsw_create_page_pool(struct cpsw_common *cpsw,
 					       int size)
@@ -1228,6 +1253,7 @@ void cpsw_destroy_xdp_rxqs(struct cpsw_common *cpsw)
 		cpsw->page_pool[ch] = NULL;
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_destroy_xdp_rxqs);
 
 int cpsw_create_xdp_rxqs(struct cpsw_common *cpsw)
 {
@@ -1260,6 +1286,7 @@ int cpsw_create_xdp_rxqs(struct cpsw_common *cpsw)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpsw_create_xdp_rxqs);
 
 static int cpsw_xdp_prog_setup(struct cpsw_priv *priv, struct netdev_bpf *bpf)
 {
@@ -1287,6 +1314,7 @@ int cpsw_ndo_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
 		return -EINVAL;
 	}
 }
+EXPORT_SYMBOL_GPL(cpsw_ndo_bpf);
 
 int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
 		      struct page *page, int port)
@@ -1320,6 +1348,7 @@ int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpsw_xdp_tx_frame);
 
 int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 		 struct page *page, int port, int *len)
@@ -1382,6 +1411,7 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 	page_pool_recycle_direct(cpsw->page_pool[ch], page);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpsw_run_xdp);
 
 static int cpsw_qos_clsflower_add_policer(struct cpsw_priv *priv,
 					  struct netlink_ext_ack *extack,
@@ -1581,3 +1611,6 @@ void cpsw_qos_clsflower_resume(struct cpsw_priv *priv)
 		cpsw_ale_rx_ratelimit_mc(priv->cpsw->ale, port_id,
 					 priv->ale_mc_ratelimit.rate_packet_ps);
 }
+EXPORT_SYMBOL_GPL(cpsw_qos_clsflower_resume);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/ti/cpsw_sl.c b/drivers/net/ethernet/ti/cpsw_sl.c
index 0c7531cb0f398..522d49eee607f 100644
--- a/drivers/net/ethernet/ti/cpsw_sl.c
+++ b/drivers/net/ethernet/ti/cpsw_sl.c
@@ -200,6 +200,7 @@ u32 cpsw_sl_reg_read(struct cpsw_sl *sl, enum cpsw_sl_regs reg)
 	dev_dbg(sl->dev, "cpsw_sl: reg: %04X r 0x%08X\n", sl->regs[reg], val);
 	return val;
 }
+EXPORT_SYMBOL_GPL(cpsw_sl_reg_read);
 
 void cpsw_sl_reg_write(struct cpsw_sl *sl, enum cpsw_sl_regs reg, u32 val)
 {
@@ -212,6 +213,7 @@ void cpsw_sl_reg_write(struct cpsw_sl *sl, enum cpsw_sl_regs reg, u32 val)
 	dev_dbg(sl->dev, "cpsw_sl: reg: %04X w 0x%08X\n", sl->regs[reg], val);
 	writel(val, sl->sl_base + sl->regs[reg]);
 }
+EXPORT_SYMBOL_GPL(cpsw_sl_reg_write);
 
 static const struct cpsw_sl_dev_id *cpsw_sl_match_id(
 		const struct cpsw_sl_dev_id *id,
@@ -252,6 +254,7 @@ struct cpsw_sl *cpsw_sl_get(const char *device_id, struct device *dev,
 
 	return sl;
 }
+EXPORT_SYMBOL_GPL(cpsw_sl_get);
 
 void cpsw_sl_reset(struct cpsw_sl *sl, unsigned long tmo)
 {
@@ -270,6 +273,7 @@ void cpsw_sl_reset(struct cpsw_sl *sl, unsigned long tmo)
 	if (cpsw_sl_reg_read(sl, CPSW_SL_SOFT_RESET) & CPSW_SL_SOFT_RESET_BIT)
 		dev_err(sl->dev, "cpsw_sl failed to soft-reset.\n");
 }
+EXPORT_SYMBOL_GPL(cpsw_sl_reset);
 
 u32 cpsw_sl_ctl_set(struct cpsw_sl *sl, u32 ctl_funcs)
 {
@@ -287,6 +291,7 @@ u32 cpsw_sl_ctl_set(struct cpsw_sl *sl, u32 ctl_funcs)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_sl_ctl_set);
 
 u32 cpsw_sl_ctl_clr(struct cpsw_sl *sl, u32 ctl_funcs)
 {
@@ -304,11 +309,13 @@ u32 cpsw_sl_ctl_clr(struct cpsw_sl *sl, u32 ctl_funcs)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_sl_ctl_clr);
 
 void cpsw_sl_ctl_reset(struct cpsw_sl *sl)
 {
 	cpsw_sl_reg_write(sl, CPSW_SL_MACCONTROL, 0);
 }
+EXPORT_SYMBOL_GPL(cpsw_sl_ctl_reset);
 
 int cpsw_sl_wait_for_idle(struct cpsw_sl *sl, unsigned long tmo)
 {
@@ -326,3 +333,4 @@ int cpsw_sl_wait_for_idle(struct cpsw_sl *sl, unsigned long tmo)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpsw_sl_wait_for_idle);
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index d2eab5cd1e0c9..41e89a19be537 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -531,6 +531,7 @@ struct cpdma_ctlr *cpdma_ctlr_create(struct cpdma_params *params)
 		ctlr->num_chan = CPDMA_MAX_CHANNELS;
 	return ctlr;
 }
+EXPORT_SYMBOL_GPL(cpdma_ctlr_create);
 
 int cpdma_ctlr_start(struct cpdma_ctlr *ctlr)
 {
@@ -591,6 +592,7 @@ int cpdma_ctlr_start(struct cpdma_ctlr *ctlr)
 	spin_unlock_irqrestore(&ctlr->lock, flags);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpdma_ctlr_start);
 
 int cpdma_ctlr_stop(struct cpdma_ctlr *ctlr)
 {
@@ -623,6 +625,7 @@ int cpdma_ctlr_stop(struct cpdma_ctlr *ctlr)
 	spin_unlock_irqrestore(&ctlr->lock, flags);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpdma_ctlr_stop);
 
 int cpdma_ctlr_destroy(struct cpdma_ctlr *ctlr)
 {
@@ -640,6 +643,7 @@ int cpdma_ctlr_destroy(struct cpdma_ctlr *ctlr)
 	cpdma_desc_pool_destroy(ctlr);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpdma_ctlr_destroy);
 
 int cpdma_ctlr_int_ctrl(struct cpdma_ctlr *ctlr, bool enable)
 {
@@ -660,21 +664,25 @@ int cpdma_ctlr_int_ctrl(struct cpdma_ctlr *ctlr, bool enable)
 	spin_unlock_irqrestore(&ctlr->lock, flags);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpdma_ctlr_int_ctrl);
 
 void cpdma_ctlr_eoi(struct cpdma_ctlr *ctlr, u32 value)
 {
 	dma_reg_write(ctlr, CPDMA_MACEOIVECTOR, value);
 }
+EXPORT_SYMBOL_GPL(cpdma_ctlr_eoi);
 
 u32 cpdma_ctrl_rxchs_state(struct cpdma_ctlr *ctlr)
 {
 	return dma_reg_read(ctlr, CPDMA_RXINTSTATMASKED);
 }
+EXPORT_SYMBOL_GPL(cpdma_ctrl_rxchs_state);
 
 u32 cpdma_ctrl_txchs_state(struct cpdma_ctlr *ctlr)
 {
 	return dma_reg_read(ctlr, CPDMA_TXINTSTATMASKED);
 }
+EXPORT_SYMBOL_GPL(cpdma_ctrl_txchs_state);
 
 static void cpdma_chan_set_descs(struct cpdma_ctlr *ctlr,
 				 int rx, int desc_num,
@@ -802,6 +810,7 @@ int cpdma_chan_set_weight(struct cpdma_chan *ch, int weight)
 	spin_unlock_irqrestore(&ctlr->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_set_weight);
 
 /* cpdma_chan_get_min_rate - get minimum allowed rate for channel
  * Should be called before cpdma_chan_set_rate.
@@ -816,6 +825,7 @@ u32 cpdma_chan_get_min_rate(struct cpdma_ctlr *ctlr)
 
 	return DIV_ROUND_UP(divident, divisor);
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_get_min_rate);
 
 /* cpdma_chan_set_rate - limits bandwidth for transmit channel.
  * The bandwidth * limited channels have to be in order beginning from lowest.
@@ -860,6 +870,7 @@ int cpdma_chan_set_rate(struct cpdma_chan *ch, u32 rate)
 	spin_unlock_irqrestore(&ctlr->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_set_rate);
 
 u32 cpdma_chan_get_rate(struct cpdma_chan *ch)
 {
@@ -872,6 +883,7 @@ u32 cpdma_chan_get_rate(struct cpdma_chan *ch)
 
 	return rate;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_get_rate);
 
 struct cpdma_chan *cpdma_chan_create(struct cpdma_ctlr *ctlr, int chan_num,
 				     cpdma_handler_fn handler, int rx_type)
@@ -931,6 +943,7 @@ struct cpdma_chan *cpdma_chan_create(struct cpdma_ctlr *ctlr, int chan_num,
 	spin_unlock_irqrestore(&ctlr->lock, flags);
 	return chan;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_create);
 
 int cpdma_chan_get_rx_buf_num(struct cpdma_chan *chan)
 {
@@ -943,6 +956,7 @@ int cpdma_chan_get_rx_buf_num(struct cpdma_chan *chan)
 
 	return desc_num;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_get_rx_buf_num);
 
 int cpdma_chan_destroy(struct cpdma_chan *chan)
 {
@@ -964,6 +978,7 @@ int cpdma_chan_destroy(struct cpdma_chan *chan)
 	spin_unlock_irqrestore(&ctlr->lock, flags);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_destroy);
 
 int cpdma_chan_get_stats(struct cpdma_chan *chan,
 			 struct cpdma_chan_stats *stats)
@@ -976,6 +991,7 @@ int cpdma_chan_get_stats(struct cpdma_chan *chan,
 	spin_unlock_irqrestore(&chan->lock, flags);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_get_stats);
 
 static void __cpdma_chan_submit(struct cpdma_chan *chan,
 				struct cpdma_desc __iomem *desc)
@@ -1100,6 +1116,7 @@ int cpdma_chan_idle_submit(struct cpdma_chan *chan, void *token, void *data,
 	spin_unlock_irqrestore(&chan->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_idle_submit);
 
 int cpdma_chan_idle_submit_mapped(struct cpdma_chan *chan, void *token,
 				  dma_addr_t data, int len, int directed)
@@ -1125,6 +1142,7 @@ int cpdma_chan_idle_submit_mapped(struct cpdma_chan *chan, void *token,
 	spin_unlock_irqrestore(&chan->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_idle_submit_mapped);
 
 int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 		      int len, int directed)
@@ -1150,6 +1168,7 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 	spin_unlock_irqrestore(&chan->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_submit);
 
 int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token,
 			     dma_addr_t data, int len, int directed)
@@ -1175,6 +1194,7 @@ int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token,
 	spin_unlock_irqrestore(&chan->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_submit_mapped);
 
 bool cpdma_check_free_tx_desc(struct cpdma_chan *chan)
 {
@@ -1189,6 +1209,7 @@ bool cpdma_check_free_tx_desc(struct cpdma_chan *chan)
 	spin_unlock_irqrestore(&chan->lock, flags);
 	return free_tx_desc;
 }
+EXPORT_SYMBOL_GPL(cpdma_check_free_tx_desc);
 
 static void __cpdma_chan_free(struct cpdma_chan *chan,
 			      struct cpdma_desc __iomem *desc,
@@ -1289,6 +1310,7 @@ int cpdma_chan_process(struct cpdma_chan *chan, int quota)
 	}
 	return used;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_process);
 
 int cpdma_chan_start(struct cpdma_chan *chan)
 {
@@ -1308,6 +1330,7 @@ int cpdma_chan_start(struct cpdma_chan *chan)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_start);
 
 int cpdma_chan_stop(struct cpdma_chan *chan)
 {
@@ -1370,6 +1393,7 @@ int cpdma_chan_stop(struct cpdma_chan *chan)
 	spin_unlock_irqrestore(&chan->lock, flags);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(cpdma_chan_stop);
 
 int cpdma_chan_int_ctrl(struct cpdma_chan *chan, bool enable)
 {
@@ -1416,11 +1440,13 @@ int cpdma_get_num_rx_descs(struct cpdma_ctlr *ctlr)
 {
 	return ctlr->num_rx_desc;
 }
+EXPORT_SYMBOL_GPL(cpdma_get_num_rx_descs);
 
 int cpdma_get_num_tx_descs(struct cpdma_ctlr *ctlr)
 {
 	return ctlr->num_tx_desc;
 }
+EXPORT_SYMBOL_GPL(cpdma_get_num_tx_descs);
 
 int cpdma_set_num_rx_descs(struct cpdma_ctlr *ctlr, int num_rx_desc)
 {
@@ -1442,3 +1468,4 @@ int cpdma_set_num_rx_descs(struct cpdma_ctlr *ctlr, int num_rx_desc)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(cpdma_set_num_rx_descs);
-- 
2.39.2


