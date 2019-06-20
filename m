Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 238D14DB22
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfFTUYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 16:24:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41966 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbfFTUYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:24:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so2285596pff.8
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=PNxYZIvmTZM5cxqyHDJUP7/zbYObh7xhsFfQTbcxScU=;
        b=xXCOMkuvQUc6Ytm6n39uoBagHKy7jj1kd/fUgVzv3UO4083auTLx62EAn9V2qhWHhf
         KUOjgadh8k8L9w0Z+oDqEwOwzPbG4TtbUp2FilH6OWgkvSIVZ8gTd8Ggq7dbZdtZFgH1
         dpXIJYfZW8iZNUGlSZ9vZzRnSRfO/EqtmMwxjhDo1bnM2B+SuymuS3h6drf4cRDciHgN
         +Z2QBss+RBzCUZDvN3RynirFdJgpJMG1qvaxdwx6pCg7Ct3YXtUXfaO3kdAiQtBZdhHd
         A1LA2B6V3ytTkMQuc7z/HzITCuSiSuWqzXV6Hku2GMAZNmCRNsXNyomU+tGTUEisRXKl
         8EUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=PNxYZIvmTZM5cxqyHDJUP7/zbYObh7xhsFfQTbcxScU=;
        b=Rt5/4mJrW80jGgDGrb1wJP99p3snTp88948wn4QzOIZ/IoLYQLnKtNi7gtAE/SX4bc
         kjpASJvGu8okmzkvcIrVTqwk3NRIzaYNq8E5eNi24S2PK0OKZgFTTx6UmHru/S6xCf2e
         NzKm+tFREC2zMGh/qNnyJQIYPIh3pLb4DphAtDQKnznFuJKzoa5YJU3KSictsJDvTN2i
         xnIMFPIRr7qDMH0s2Vlc0jsM0nHo7akbFwHDYusJMDe1U3fn2O6689owS0sDEUZFjAZj
         Ns80a+S8TRYqQ+Wnlx27PhqaWX3woKADmQ5VJlpF45BGhxRDplrpuu5pTGk6f/wMNsXl
         PTcw==
X-Gm-Message-State: APjAAAXvyFQhq1AdAK8r7xvnKKDuSBa43FusFHzxrf9ZNE471Phm8fOE
        VdYctaUqp4ykd18tdrjzpC/SpcdxNe8=
X-Google-Smtp-Source: APXvYqyzXnaxAb+f0ROwO01v1Ou8ZtZrS+yP8eNSyxu6CY9XUwOkOq/utODCL3TQWQNLGuOCs8/cWA==
X-Received: by 2002:aa7:8d4d:: with SMTP id s13mr17160822pfe.259.1561062286453;
        Thu, 20 Jun 2019 13:24:46 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h26sm340537pfq.64.2019.06.20.13.24.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:24:45 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH net-next 17/18] ionic: Add RSS support
Date:   Thu, 20 Jun 2019 13:24:23 -0700
Message-Id: <20190620202424.23215-18-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620202424.23215-1-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code to manipulate through ethtool the RSS configuration
used by the NIC.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 73 +++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 93 +++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  8 ++
 3 files changed, 174 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index b6ccb2560744..2439c9beb6ae 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -507,6 +507,74 @@ static int ionic_set_channels(struct net_device *netdev,
 	return 0;
 }
 
+static int ionic_get_rxnfc(struct net_device *netdev,
+			   struct ethtool_rxnfc *info, u32 *rules)
+{
+	struct lif *lif = netdev_priv(netdev);
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
+	struct lif *lif = netdev_priv(netdev);
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
+	struct lif *lif = netdev_priv(netdev);
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
+	struct lif *lif = netdev_priv(netdev);
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
 static u32 ionic_get_priv_flags(struct net_device *netdev)
 {
 	struct lif *lif = netdev_priv(netdev);
@@ -626,6 +694,11 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_strings		= ionic_get_strings,
 	.get_ethtool_stats	= ionic_get_stats,
 	.get_sset_count		= ionic_get_sset_count,
+	.get_rxnfc		= ionic_get_rxnfc,
+	.get_rxfh_indir_size	= ionic_get_rxfh_indir_size,
+	.get_rxfh_key_size	= ionic_get_rxfh_key_size,
+	.get_rxfh		= ionic_get_rxfh,
+	.set_rxfh		= ionic_set_rxfh,
 	.get_priv_flags		= ionic_get_priv_flags,
 	.set_priv_flags		= ionic_set_priv_flags,
 	.get_module_info	= ionic_get_module_info,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 88fa9397e64a..6710e36794b9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -26,6 +26,8 @@ static void ionic_qcq_free(struct lif *lif, struct qcq *qcq);
 static int ionic_lif_txqs_init(struct lif *lif);
 static int ionic_lif_rxqs_init(struct lif *lif);
 static void ionic_lif_qcq_deinit(struct lif *lif, struct qcq *qcq);
+static int ionic_lif_rss_init(struct lif *lif);
+static int ionic_lif_rss_deinit(struct lif *lif);
 static int ionic_set_nic_features(struct lif *lif, netdev_features_t features);
 static int ionic_notifyq_clean(struct lif *lif, int budget);
 
@@ -1096,6 +1098,9 @@ static int ionic_txrx_init(struct lif *lif)
 	if (err)
 		goto err_out;
 
+	if (lif->netdev->features & NETIF_F_RXHASH)
+		ionic_lif_rss_init(lif);
+
 	ionic_set_rx_mode(lif->netdev);
 
 	return 0;
@@ -1220,6 +1225,7 @@ static struct lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
 	struct device *dev = ionic->dev;
 	struct net_device *netdev;
 	struct lif *lif;
+	int tbl_sz;
 	int err;
 
 	netdev = alloc_etherdev_mqs(sizeof(*lif),
@@ -1274,10 +1280,24 @@ static struct lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
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
@@ -1316,6 +1336,14 @@ static void ionic_lif_free(struct lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
 
+	/* free rss indirection table */
+	if (lif->rss_ind_tbl) {
+		dma_free_coherent(dev, lif->rss_ind_tbl_sz, lif->rss_ind_tbl,
+				  lif->rss_ind_tbl_pa);
+		lif->rss_ind_tbl = NULL;
+		lif->rss_ind_tbl_pa = 0;
+	}
+
 	/* free queues */
 	ionic_qcqs_free(lif);
 	ionic_lif_reset(lif);
@@ -1353,6 +1381,70 @@ void ionic_lifs_free(struct ionic *ionic)
 	}
 }
 
+int ionic_lif_rss_config(struct lif *lif, const u16 types,
+			 const u8 *key, const u32 *indir)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = CMD_OPCODE_LIF_SETATTR,
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
+static int ionic_lif_rss_init(struct lif *lif)
+{
+	static const u8 toeplitz_symmetric_key[] = {
+		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
+		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
+		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
+		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
+		0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A, 0x6D, 0x5A,
+	};
+	unsigned int i, tbl_sz;
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
+		lif->rss_ind_tbl[i] = i % lif->nxqs;
+
+	return ionic_lif_rss_config(lif, lif->rss_types,
+				    toeplitz_symmetric_key, NULL);
+}
+
+static int ionic_lif_rss_deinit(struct lif *lif)
+{
+	/* Disable RSS on the NIC */
+	return ionic_lif_rss_config(lif, 0x0, NULL, NULL);
+}
+
 static void ionic_lif_qcq_deinit(struct lif *lif, struct qcq *qcq)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
@@ -1385,6 +1477,7 @@ static void ionic_lif_deinit(struct lif *lif)
 	clear_bit(LIF_INITED, lif->state);
 
 	ionic_rx_filters_deinit(lif);
+	ionic_lif_rss_deinit(lif);
 
 	napi_disable(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index ffe4cd19a1db..220955ee7259 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -166,6 +166,12 @@ struct lif {
 	dma_addr_t info_pa;
 	u32 info_sz;
 
+	u16 rss_types;
+	u8 rss_hash_key[IONIC_RSS_HASH_KEY_SIZE];
+	u8 *rss_ind_tbl;
+	dma_addr_t rss_ind_tbl_pa;
+	u32 rss_ind_tbl_sz;
+
 	struct rx_filters rx_filters;
 	struct deferred deferred;
 	u32 tx_coalesce_usecs;
@@ -221,6 +227,8 @@ void ionic_lifs_unregister(struct ionic *ionic);
 int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 		       union lif_identity *lif_ident);
 int ionic_lifs_size(struct ionic *ionic);
+int ionic_lif_rss_config(struct lif *lif, u16 types,
+			 const u8 *key, const u32 *indir);
 
 int ionic_open(struct net_device *netdev);
 int ionic_stop(struct net_device *netdev);
-- 
2.17.1

