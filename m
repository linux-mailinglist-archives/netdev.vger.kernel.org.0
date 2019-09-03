Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2540A76FF
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfICW3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:29:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34418 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727608AbfICW3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:29:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so10015768pgc.1
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=MablEK2fDayjnIkJ26lfUvTjSi5s1VdkmPTpUGI5UAE=;
        b=a/q9FuVCZ4/uidZcN7A5DTfnYVehEojEBL41KAt/BO7WdSLQ8LGNNU/9M4W8eNL9w3
         Yz1WXpLeXt+sYryE6Xh5GudGdnLLDkhSwMVNNj6YpNEF1m0HzDfu09dzIOPv8lbDfmcN
         3tApK7E+TjlMP5rv4g2jyjPvQjQcjl/o4keWx+BgYf55lMVEsZc4NqO6pfFJ3f4XrhfU
         FmmAphP9S9LsImhvKw3AsCsoGxIx/VxWz18w2nv+Hv5fVUS4S2ZXCn8faDbuFEdqukWM
         +CZX4lkZJkMTY5/D/0kFXFph8M2inBdMP0FOPXW6eiESUToZUbH0RGRSlK2/9qeUEAFO
         KhQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=MablEK2fDayjnIkJ26lfUvTjSi5s1VdkmPTpUGI5UAE=;
        b=UP6iByZh486mJw59lNoJtGxihIpmNF8RnF9Hq3F8DBC00nhPZxUUgHunXt+w52re38
         sUFSEUP5iul4YRFd32OLfM8qCJHMw6EVxHyrnHSZ8VRsz6/6+Y7ePnp4aFvGM3d6p58g
         MKwG6VXaerj65H/THSAILaaZzv1TAKm5k14vcG6QS7qUxi8irTUIXLqrjaf0/e4dcLVu
         WMRVQYod+WGRCYfetzqnigQ1lriWTDu52XGzp9Azf5xaMJKxDp0QJJj7DDckqhPMqxZ4
         vn44N6t0WACEti8C6GX8vg7TgejSv/Xib3zjMPNk8Xz2Ayp9etRiFCDVsCb9f3ega8jm
         xSsg==
X-Gm-Message-State: APjAAAU1upGyjMNxFqrZZX40dgQlfeQxoUiyML2BOXOg3vdAjj2cEJkL
        YjVPVEyK9+sHQ7uDI3HH6a6bdQ==
X-Google-Smtp-Source: APXvYqzXXcxANCYt/l65Cs+yTMpcFpSyB/XD5bVfmhKFX7og1pqWhMP8i41M2/CreSy+Skv9RfpbEQ==
X-Received: by 2002:aa7:8ac5:: with SMTP id b5mr41324827pfd.56.1567549746058;
        Tue, 03 Sep 2019 15:29:06 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.29.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:29:05 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v7 net-next 18/19] ionic: Add RSS support
Date:   Tue,  3 Sep 2019 15:28:20 -0700
Message-Id: <20190903222821.46161-19-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code to manipulate through ethtool the RSS configuration
used by the NIC.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 73 ++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 84 +++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  8 ++
 3 files changed, 165 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index ab17066acb8d..321b0543f2f8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -482,6 +482,74 @@ static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 	return 0;
 }
 
+static int ionic_get_rxnfc(struct net_device *netdev,
+			   struct ethtool_rxnfc *info, u32 *rules)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	int err = 0;
+
+	switch (info->cmd) {
+	case ETHTOOL_GRXRINGS:
+		info->data = lif->nxqs;
+		break;
+	default:
+		netdev_err(netdev, "Command parameter %d is not supported\n",
+			   info->cmd);
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static u32 ionic_get_rxfh_indir_size(struct net_device *netdev)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+
+	return le16_to_cpu(lif->ionic->ident.lif.eth.rss_ind_tbl_sz);
+}
+
+static u32 ionic_get_rxfh_key_size(struct net_device *netdev)
+{
+	return IONIC_RSS_HASH_KEY_SIZE;
+}
+
+static int ionic_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
+			  u8 *hfunc)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	unsigned int i, tbl_sz;
+
+	if (indir) {
+		tbl_sz = le16_to_cpu(lif->ionic->ident.lif.eth.rss_ind_tbl_sz);
+		for (i = 0; i < tbl_sz; i++)
+			indir[i] = lif->rss_ind_tbl[i];
+	}
+
+	if (key)
+		memcpy(key, lif->rss_hash_key, IONIC_RSS_HASH_KEY_SIZE);
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP;
+
+	return 0;
+}
+
+static int ionic_set_rxfh(struct net_device *netdev, const u32 *indir,
+			  const u8 *key, const u8 hfunc)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	int err;
+
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
+	err = ionic_lif_rss_config(lif, lif->rss_types, key, indir);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int ionic_get_module_info(struct net_device *netdev,
 				 struct ethtool_modinfo *modinfo)
 
@@ -584,6 +652,11 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_sset_count		= ionic_get_sset_count,
 	.get_priv_flags		= ionic_get_priv_flags,
 	.set_priv_flags		= ionic_set_priv_flags,
+	.get_rxnfc		= ionic_get_rxnfc,
+	.get_rxfh_indir_size	= ionic_get_rxfh_indir_size,
+	.get_rxfh_key_size	= ionic_get_rxfh_key_size,
+	.get_rxfh		= ionic_get_rxfh,
+	.set_rxfh		= ionic_set_rxfh,
 	.get_module_info	= ionic_get_module_info,
 	.get_module_eeprom	= ionic_get_module_eeprom,
 	.get_pauseparam		= ionic_get_pauseparam,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 025ad6a6fce4..966a81006528 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1315,6 +1315,65 @@ static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
 	return ionic_adminq_post_wait(lif, &ctx);
 }
 
+int ionic_lif_rss_config(struct ionic_lif *lif, const u16 types,
+			 const u8 *key, const u32 *indir)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.attr = IONIC_LIF_ATTR_RSS,
+			.rss.types = cpu_to_le16(types),
+			.rss.addr = cpu_to_le64(lif->rss_ind_tbl_pa),
+		},
+	};
+	unsigned int i, tbl_sz;
+
+	lif->rss_types = types;
+
+	if (key)
+		memcpy(lif->rss_hash_key, key, IONIC_RSS_HASH_KEY_SIZE);
+
+	if (indir) {
+		tbl_sz = le16_to_cpu(lif->ionic->ident.lif.eth.rss_ind_tbl_sz);
+		for (i = 0; i < tbl_sz; i++)
+			lif->rss_ind_tbl[i] = indir[i];
+	}
+
+	memcpy(ctx.cmd.lif_setattr.rss.key, lif->rss_hash_key,
+	       IONIC_RSS_HASH_KEY_SIZE);
+
+	return ionic_adminq_post_wait(lif, &ctx);
+}
+
+static int ionic_lif_rss_init(struct ionic_lif *lif)
+{
+	u8 rss_key[IONIC_RSS_HASH_KEY_SIZE];
+	unsigned int tbl_sz;
+	unsigned int i;
+
+	netdev_rss_key_fill(rss_key, IONIC_RSS_HASH_KEY_SIZE);
+
+	lif->rss_types = IONIC_RSS_TYPE_IPV4     |
+			 IONIC_RSS_TYPE_IPV4_TCP |
+			 IONIC_RSS_TYPE_IPV4_UDP |
+			 IONIC_RSS_TYPE_IPV6     |
+			 IONIC_RSS_TYPE_IPV6_TCP |
+			 IONIC_RSS_TYPE_IPV6_UDP;
+
+	/* Fill indirection table with 'default' values */
+	tbl_sz = le16_to_cpu(lif->ionic->ident.lif.eth.rss_ind_tbl_sz);
+	for (i = 0; i < tbl_sz; i++)
+		lif->rss_ind_tbl[i] = ethtool_rxfh_indir_default(i, lif->nxqs);
+
+	return ionic_lif_rss_config(lif, lif->rss_types, rss_key, NULL);
+}
+
+static int ionic_lif_rss_deinit(struct ionic_lif *lif)
+{
+	return ionic_lif_rss_config(lif, 0x0, NULL, NULL);
+}
+
 static void ionic_txrx_disable(struct ionic_lif *lif)
 {
 	unsigned int i;
@@ -1413,6 +1472,9 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 		}
 	}
 
+	if (lif->netdev->features & NETIF_F_RXHASH)
+		ionic_lif_rss_init(lif);
+
 	ionic_set_rx_mode(lif->netdev);
 
 	return 0;
@@ -1558,6 +1620,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	struct device *dev = ionic->dev;
 	struct net_device *netdev;
 	struct ionic_lif *lif;
+	int tbl_sz;
 	int err;
 
 	netdev = alloc_etherdev_mqs(sizeof(*lif),
@@ -1610,10 +1673,24 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	if (err)
 		goto err_out_free_lif_info;
 
+	/* allocate rss indirection table */
+	tbl_sz = le16_to_cpu(lif->ionic->ident.lif.eth.rss_ind_tbl_sz);
+	lif->rss_ind_tbl_sz = sizeof(*lif->rss_ind_tbl) * tbl_sz;
+	lif->rss_ind_tbl = dma_alloc_coherent(dev, lif->rss_ind_tbl_sz,
+					      &lif->rss_ind_tbl_pa,
+					      GFP_KERNEL);
+
+	if (!lif->rss_ind_tbl) {
+		dev_err(dev, "Failed to allocate rss indirection table, aborting\n");
+		goto err_out_free_qcqs;
+	}
+
 	list_add_tail(&lif->list, &ionic->lifs);
 
 	return lif;
 
+err_out_free_qcqs:
+	ionic_qcqs_free(lif);
 err_out_free_lif_info:
 	dma_free_coherent(dev, lif->info_sz, lif->info, lif->info_pa);
 	lif->info = NULL;
@@ -1652,6 +1729,12 @@ static void ionic_lif_free(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
 
+	/* free rss indirection table */
+	dma_free_coherent(dev, lif->rss_ind_tbl_sz, lif->rss_ind_tbl,
+			  lif->rss_ind_tbl_pa);
+	lif->rss_ind_tbl = NULL;
+	lif->rss_ind_tbl_pa = 0;
+
 	/* free queues */
 	ionic_qcqs_free(lif);
 	ionic_lif_reset(lif);
@@ -1693,6 +1776,7 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 	clear_bit(IONIC_LIF_INITED, lif->state);
 
 	ionic_rx_filters_deinit(lif);
+	ionic_lif_rss_deinit(lif);
 
 	napi_disable(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 4e0b65ddd8e0..2e931a704565 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -164,6 +164,12 @@ struct ionic_lif {
 	dma_addr_t info_pa;
 	u32 info_sz;
 
+	u16 rss_types;
+	u8 rss_hash_key[IONIC_RSS_HASH_KEY_SIZE];
+	u8 *rss_ind_tbl;
+	dma_addr_t rss_ind_tbl_pa;
+	u32 rss_ind_tbl_sz;
+
 	struct ionic_rx_filters rx_filters;
 	struct ionic_deferred deferred;
 	unsigned long *dbid_inuse;
@@ -198,6 +204,8 @@ void ionic_lifs_unregister(struct ionic *ionic);
 int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 		       union ionic_lif_identity *lif_ident);
 int ionic_lifs_size(struct ionic *ionic);
+int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
+			 const u8 *key, const u32 *indir);
 
 int ionic_open(struct net_device *netdev);
 int ionic_stop(struct net_device *netdev);
-- 
2.17.1

