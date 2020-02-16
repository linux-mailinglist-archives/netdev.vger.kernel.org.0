Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B70516071F
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 00:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgBPXML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 18:12:11 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43507 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBPXML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 18:12:11 -0500
Received: by mail-pg1-f194.google.com with SMTP id u12so7685716pgb.10
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 15:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+WBfAPwjI8s9xXmJD0QqvVUlD4BIhP76ABXVlYuT+pg=;
        b=JjGVXaG4D2iU9YQ7LGP6Ua1qOrdxFnAd+amXOH0n5T/mUjTvZfImQIYjmSTSQPCvDZ
         1sljkiAH7TEYuRmCVNPdTlRFVNYksxWW/VTs9VR1k8D1eOjRoR/bcJVxAtbzntXHxWYC
         6tWQl+vqK36X4/o0wgzYJLhYlYFl7cZwIBDvvlHeIEDR/uEukhmYorZxHU+CrFW0PC7H
         22Jms4cOO+14lLnIbzx8yC4TQkDs+Q9iOhslk7oo/wWIZ5pKfbyg2KormTkGY8QrTuvW
         AQPijEr9MJ/5u+wSL6BMm894oPi0KUGWPoDKp31rBXmiwU3f+3QmMvSXSjv93x4UJv5j
         Csxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+WBfAPwjI8s9xXmJD0QqvVUlD4BIhP76ABXVlYuT+pg=;
        b=EJkcV5f56/lLQykVUD/2NLDKHUC7raYM+uRfcTIX2nfxoOSSZeiDfvDoKdTQAuYCWY
         xM0EvyHN5TaHQcX3jBxM+xsLLbhADaEK7/1xxKmwselzl9IbkYRsIzjrhQyOHZt946n6
         FaRJXDov0n5oPhM8/7O/rgjxwDgZJK+xxxxPCU72QG8z2WWSRkhYYSFGrGY7z1LIGpRg
         TQqipbblcf1oZQlYTCb7taLwqpxmMZbwqOX9zM916iP1gO1u0SkHt4wKIauaPD3sklun
         QDlzCtt0/if1ehSp68ieCXSTN3xYI9d2xUQzDABBnmLYNKyxBankqyClGq5/nMSrL4th
         7DgA==
X-Gm-Message-State: APjAAAW65Zm0K1vg9fcTmhpUAjswngoLcPL1Nfx1i+mbavSMJju80P1g
        cMD+HNa3CZJ3ZdhHVZ32nZZdMBU9BTjs8Q==
X-Google-Smtp-Source: APXvYqxmImdDUWyUvRWn7im8r9oRG1yQzeQdjQQqwZz0mLF6hg/cTG1bmf0cWjJiI1wB1yXC7W4F6w==
X-Received: by 2002:aa7:961b:: with SMTP id q27mr14147014pfg.23.1581894730853;
        Sun, 16 Feb 2020 15:12:10 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 70sm14074573pgd.28.2020.02.16.15.12.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Feb 2020 15:12:10 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/9] ionic: replace lif list with xarray
Date:   Sun, 16 Feb 2020 15:11:52 -0800
Message-Id: <20200216231158.5678-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216231158.5678-1-snelson@pensando.io>
References: <20200216231158.5678-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lif list works fine for our purposes now, especially when
we're only using a single lif.  However in the near future there
will be support for slave lifs for RDMA and macvlan offloads,
and with that a need to quickly find a given lif by index.
This patch replaces the lif list with an xarray so we don't have
to search through the list every time we need to fine a lif,
and yet don't need to allocate a possibly large but sparsely
populated array.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   | 16 +++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 38 +++++++++++--------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  1 -
 3 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 7d41e7e56ca6..e5a2a44d9308 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -4,6 +4,8 @@
 #ifndef _IONIC_H_
 #define _IONIC_H_
 
+#include <linux/xarray.h>
+
 struct ionic_lif;
 
 #include "ionic_if.h"
@@ -43,7 +45,7 @@ struct ionic {
 	struct ionic_dev_bar bars[IONIC_BARS_MAX];
 	unsigned int num_bars;
 	struct ionic_identity ident;
-	struct list_head lifs;
+	struct xarray lifs;
 	struct ionic_lif *master_lif;
 	unsigned int nnqs_per_lif;
 	unsigned int nrdma_eqs_per_lif;
@@ -67,6 +69,18 @@ struct ionic_admin_ctx {
 	union ionic_adminq_comp comp;
 };
 
+/* Since we have a bitmap of the allocated lifs, we can use
+ * that to look up each lif specifically, rather than digging
+ * through the whole tree.
+ */
+#define for_each_lif(_ion, _bit, _lif) \
+	for ((_bit) = find_first_bit((_ion)->lifbits, IONIC_LIFS_MAX),   \
+		(_lif) = xa_load(&(_ion)->lifs, (_bit));                 \
+	     (_bit) < IONIC_LIFS_MAX;                                    \
+	     (_bit) = find_next_bit((_ion)->lifbits,                     \
+				    IONIC_LIFS_MAX, ((_bit) + 1)),       \
+		(_lif) = xa_load(&(_ion)->lifs, (_bit)))
+
 int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
 	       ionic_cq_done_cb done_cb, void *done_arg);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 43c8bff02831..58f23760769f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1891,6 +1891,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	struct net_device *netdev;
 	struct ionic_lif *lif;
 	int tbl_sz;
+	void *p;
 	int err;
 
 	netdev = alloc_etherdev_mqs(sizeof(*lif),
@@ -1962,10 +1963,20 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	}
 	netdev_rss_key_fill(lif->rss_hash_key, IONIC_RSS_HASH_KEY_SIZE);
 
-	list_add_tail(&lif->list, &ionic->lifs);
+	p = xa_store(&ionic->lifs, lif->index, lif, GFP_KERNEL);
+	if (xa_err(p)) {
+		dev_err(dev, "LIF tree insertion failed %d, aborting\n",
+			xa_err(p));
+		goto err_out_free_rss;
+	}
 
 	return lif;
 
+err_out_free_rss:
+	dma_free_coherent(dev, lif->rss_ind_tbl_sz, lif->rss_ind_tbl,
+			  lif->rss_ind_tbl_pa);
+	lif->rss_ind_tbl = NULL;
+	lif->rss_ind_tbl_pa = 0;
 err_out_free_qcqs:
 	ionic_qcqs_free(lif);
 err_out_free_lif_info:
@@ -1983,7 +1994,7 @@ int ionic_lifs_alloc(struct ionic *ionic)
 {
 	struct ionic_lif *lif;
 
-	INIT_LIST_HEAD(&ionic->lifs);
+	xa_init(&ionic->lifs);
 
 	/* only build the first lif, others are for later features */
 	set_bit(0, ionic->lifbits);
@@ -2005,6 +2016,7 @@ static void ionic_lif_reset(struct ionic_lif *lif)
 static void ionic_lif_free(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
+	struct ionic *ionic = lif->ionic;
 
 	/* free rss indirection table */
 	dma_free_coherent(dev, lif->rss_ind_tbl_sz, lif->rss_ind_tbl,
@@ -2022,27 +2034,24 @@ static void ionic_lif_free(struct ionic_lif *lif)
 	lif->info_pa = 0;
 
 	/* unmap doorbell page */
-	ionic_bus_unmap_dbpage(lif->ionic, lif->kern_dbpage);
+	ionic_bus_unmap_dbpage(ionic, lif->kern_dbpage);
 	lif->kern_dbpage = NULL;
 	kfree(lif->dbid_inuse);
 	lif->dbid_inuse = NULL;
 
 	/* free netdev & lif */
 	ionic_debugfs_del_lif(lif);
-	list_del(&lif->list);
+	xa_erase(&ionic->lifs, lif->index);
 	free_netdev(lif->netdev);
 }
 
 void ionic_lifs_free(struct ionic *ionic)
 {
-	struct list_head *cur, *tmp;
 	struct ionic_lif *lif;
+	unsigned int i;
 
-	list_for_each_safe(cur, tmp, &ionic->lifs) {
-		lif = list_entry(cur, struct ionic_lif, list);
-
+	for_each_lif(ionic, i, lif)
 		ionic_lif_free(lif);
-	}
 }
 
 static void ionic_lif_deinit(struct ionic_lif *lif)
@@ -2064,13 +2073,11 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 
 void ionic_lifs_deinit(struct ionic *ionic)
 {
-	struct list_head *cur, *tmp;
 	struct ionic_lif *lif;
+	unsigned int i;
 
-	list_for_each_safe(cur, tmp, &ionic->lifs) {
-		lif = list_entry(cur, struct ionic_lif, list);
+	for_each_lif(ionic, i, lif)
 		ionic_lif_deinit(lif);
-	}
 }
 
 static int ionic_lif_adminq_init(struct ionic_lif *lif)
@@ -2308,12 +2315,11 @@ static int ionic_lif_init(struct ionic_lif *lif)
 
 int ionic_lifs_init(struct ionic *ionic)
 {
-	struct list_head *cur, *tmp;
 	struct ionic_lif *lif;
+	unsigned int i;
 	int err;
 
-	list_for_each_safe(cur, tmp, &ionic->lifs) {
-		lif = list_entry(cur, struct ionic_lif, list);
+	for_each_lif(ionic, i, lif) {
 		err = ionic_lif_init(lif);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index e912f8efb3d5..48d4592c6c9f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -134,7 +134,6 @@ enum ionic_lif_state_flags {
 #define IONIC_LIF_NAME_MAX_SZ		32
 struct ionic_lif {
 	char name[IONIC_LIF_NAME_MAX_SZ];
-	struct list_head list;
 	struct net_device *netdev;
 	DECLARE_BITMAP(state, IONIC_LIF_STATE_SIZE);
 	struct ionic *ionic;
-- 
2.17.1

