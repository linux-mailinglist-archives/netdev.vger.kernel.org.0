Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 685A39D88B
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfHZVeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:34:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40797 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfHZVeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:34:09 -0400
Received: by mail-pf1-f196.google.com with SMTP id w16so12633194pfn.7
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=o/GnbYa/ZwAddoMwCHxBNeoX6xfJErgkcUjZaVkKse4=;
        b=DutqHogE0jXvpUI3drcJ68ie6hfPrtuSy+jWsKg+ZvhdGN7CxqWMHyPd1IaDCDVqI3
         iME3WzofJvPXP1Bz+hvaSSr0tVhdmAJeSZya2bygYt4M6YXPCYpQQnD7qL9B5n/HOG26
         dAqm21MoVgS6g/3FXcWVIYQnsxQt/e7lT5A+wp6LMTX/tRJxpvesPQUvPOhj8bu+wVMy
         taSLncaa/THcGvhC/KGrXBqYPnSurB+Eu2mSvvAW9HuYQDff2SJ8XGe9K+IcvI5ImJg1
         IW6QiS8KBpGhKk6Z+V3zfHW2TCpeD4pIgXwZkSxH3AtFSpEDmObsw0185pquc/gxCzNN
         xs3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=o/GnbYa/ZwAddoMwCHxBNeoX6xfJErgkcUjZaVkKse4=;
        b=sTDMlP8MglnAu3YcB4ob6IThVsxKtD4htyhu4Xxa05XUzlisiVztEaoRHRk2diXb6C
         /0FfZN3sQ1NytWGXUqTbwvlfbwjRVpnsZ7Lmk/I7hRGavK/R9PpozhOuLhQCl6zaFG94
         SvJ//ZGfcHXSuZIY5MV1NHVFM3OQzCUxgMcD11+jrYihb7rEb3wj9kRWSibQcvBkTHll
         yEt0gMsBOZ6Va2IaAHlilv4+WdCLKaoyXB1rRAmnJoT7EtNcENoQituJQwMilJzRtuoi
         LGA/UCh5IpoAuAolznKcxyfECc68HnjQZ+EUrq93JUdJ5yvj8aMJjyxnSJYuhVPlAm7g
         e5hw==
X-Gm-Message-State: APjAAAULN8gawAwTS1eAWxWHvlC4gVPe/7rbl/yIk7BUOE88znGrmMil
        DXMRczKr/SdJnZ6uyYPRnRs6HBIfM5M=
X-Google-Smtp-Source: APXvYqwVFnONe7g1SiSkzheJYtnDV6s0aBPtyhwUzldUutgs8LBloFYV2yhPqU3MICL1+S66F8xdQQ==
X-Received: by 2002:a65:6284:: with SMTP id f4mr18867602pgv.416.1566855248464;
        Mon, 26 Aug 2019 14:34:08 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm5876905pfi.128.2019.08.26.14.34.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:34:07 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v5 net-next 17/18] ionic: Add RSS support
Date:   Mon, 26 Aug 2019 14:33:38 -0700
Message-Id: <20190826213339.56909-18-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826213339.56909-1-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
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
index c6a056efea0e..ce32d5e96903 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -486,6 +486,74 @@ static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
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
 
@@ -585,6 +653,11 @@ static const struct ethtool_ops ionic_ethtool_ops = {
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
index 41e2768ea47b..48f254ab7d46 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1314,6 +1314,65 @@ static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
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
@@ -1412,6 +1471,9 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 		}
 	}
 
+	if (lif->netdev->features & NETIF_F_RXHASH)
+		ionic_lif_rss_init(lif);
+
 	ionic_set_rx_mode(lif->netdev);
 
 	return 0;
@@ -1557,6 +1619,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	struct device *dev = ionic->dev;
 	struct net_device *netdev;
 	struct ionic_lif *lif;
+	int tbl_sz;
 	int err;
 
 	netdev = alloc_etherdev_mqs(sizeof(*lif),
@@ -1609,10 +1672,24 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
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
@@ -1651,6 +1728,12 @@ static void ionic_lif_free(struct ionic_lif *lif)
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
@@ -1692,6 +1775,7 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 	clear_bit(IONIC_LIF_INITED, lif->state);
 
 	ionic_rx_filters_deinit(lif);
+	ionic_lif_rss_deinit(lif);
 
 	napi_disable(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 5b7e7127cacb..402d6a8238a1 100644
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
@@ -223,6 +229,8 @@ void ionic_lifs_unregister(struct ionic *ionic);
 int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 		       union ionic_lif_identity *lif_ident);
 int ionic_lifs_size(struct ionic *ionic);
+int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
+			 const u8 *key, const u32 *indir);
 
 int ionic_open(struct net_device *netdev);
 int ionic_stop(struct net_device *netdev);
-- 
2.17.1

