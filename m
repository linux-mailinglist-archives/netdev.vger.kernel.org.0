Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41E756489E
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 18:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiGCQqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 12:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiGCQqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 12:46:44 -0400
Received: from smtp.smtpout.orange.fr (smtp05.smtpout.orange.fr [80.12.242.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984836269
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 09:46:41 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 82k2oH5heZDzU82k2oQODa; Sun, 03 Jul 2022 18:46:39 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 03 Jul 2022 18:46:39 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] cxgb4: Use the bitmap API to allocate bitmaps
Date:   Sun,  3 Jul 2022 18:46:36 +0200
Message-Id: <8a2168ef9871bd9c4f1cf19b8d5f7530662a5d15.1656866770.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

While at it, remove a useless bitmap_zero(). The bitmap is already zeroed
when allocated.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  6 ++---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  8 +++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 27 ++++++++-----------
 3 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 7d49fd4edc9e..14e0d989c3ba 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3429,18 +3429,18 @@ static ssize_t blocked_fl_write(struct file *filp, const char __user *ubuf,
 	unsigned long *t;
 	struct adapter *adap = filp->private_data;
 
-	t = kcalloc(BITS_TO_LONGS(adap->sge.egr_sz), sizeof(long), GFP_KERNEL);
+	t = bitmap_zalloc(adap->sge.egr_sz, GFP_KERNEL);
 	if (!t)
 		return -ENOMEM;
 
 	err = bitmap_parse_user(ubuf, count, t, adap->sge.egr_sz);
 	if (err) {
-		kfree(t);
+		bitmap_free(t);
 		return err;
 	}
 
 	bitmap_copy(adap->sge.blocked_fl, t, adap->sge.egr_sz);
-	kfree(t);
+	bitmap_free(t);
 	return count;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 6c790af92170..77897edd2bc0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -2227,7 +2227,7 @@ void cxgb4_cleanup_ethtool_filters(struct adapter *adap)
 	if (eth_filter_info) {
 		for (i = 0; i < adap->params.nports; i++) {
 			kvfree(eth_filter_info[i].loc_array);
-			kfree(eth_filter_info[i].bmap);
+			bitmap_free(eth_filter_info[i].bmap);
 		}
 		kfree(eth_filter_info);
 	}
@@ -2270,9 +2270,7 @@ int cxgb4_init_ethtool_filters(struct adapter *adap)
 			goto free_eth_finfo;
 		}
 
-		eth_filter->port[i].bmap = kcalloc(BITS_TO_LONGS(nentries),
-						   sizeof(unsigned long),
-						   GFP_KERNEL);
+		eth_filter->port[i].bmap = bitmap_zalloc(nentries, GFP_KERNEL);
 		if (!eth_filter->port[i].bmap) {
 			ret = -ENOMEM;
 			goto free_eth_finfo;
@@ -2284,7 +2282,7 @@ int cxgb4_init_ethtool_filters(struct adapter *adap)
 
 free_eth_finfo:
 	while (i-- > 0) {
-		kfree(eth_filter->port[i].bmap);
+		bitmap_free(eth_filter->port[i].bmap);
 		kvfree(eth_filter->port[i].loc_array);
 	}
 	kfree(eth_filter_info);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 0c78c0db8937..d0061921529f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5047,28 +5047,24 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 	/* Allocate the memory for the vaious egress queue bitmaps
 	 * ie starving_fl, txq_maperr and blocked_fl.
 	 */
-	adap->sge.starving_fl =	kcalloc(BITS_TO_LONGS(adap->sge.egr_sz),
-					sizeof(long), GFP_KERNEL);
+	adap->sge.starving_fl = bitmap_zalloc(adap->sge.egr_sz, GFP_KERNEL);
 	if (!adap->sge.starving_fl) {
 		ret = -ENOMEM;
 		goto bye;
 	}
 
-	adap->sge.txq_maperr = kcalloc(BITS_TO_LONGS(adap->sge.egr_sz),
-				       sizeof(long), GFP_KERNEL);
+	adap->sge.txq_maperr = bitmap_zalloc(adap->sge.egr_sz, GFP_KERNEL);
 	if (!adap->sge.txq_maperr) {
 		ret = -ENOMEM;
 		goto bye;
 	}
 
 #ifdef CONFIG_DEBUG_FS
-	adap->sge.blocked_fl = kcalloc(BITS_TO_LONGS(adap->sge.egr_sz),
-				       sizeof(long), GFP_KERNEL);
+	adap->sge.blocked_fl = bitmap_zalloc(adap->sge.egr_sz, GFP_KERNEL);
 	if (!adap->sge.blocked_fl) {
 		ret = -ENOMEM;
 		goto bye;
 	}
-	bitmap_zero(adap->sge.blocked_fl, adap->sge.egr_sz);
 #endif
 
 	params[0] = FW_PARAM_PFVF(CLIP_START);
@@ -5417,10 +5413,10 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 	adap_free_hma_mem(adap);
 	kfree(adap->sge.egr_map);
 	kfree(adap->sge.ingr_map);
-	kfree(adap->sge.starving_fl);
-	kfree(adap->sge.txq_maperr);
+	bitmap_free(adap->sge.starving_fl);
+	bitmap_free(adap->sge.txq_maperr);
 #ifdef CONFIG_DEBUG_FS
-	kfree(adap->sge.blocked_fl);
+	bitmap_free(adap->sge.blocked_fl);
 #endif
 	if (ret != -ETIMEDOUT && ret != -EIO)
 		t4_fw_bye(adap, adap->mbox);
@@ -5854,8 +5850,7 @@ static int alloc_msix_info(struct adapter *adap, u32 num_vec)
 	if (!msix_info)
 		return -ENOMEM;
 
-	adap->msix_bmap.msix_bmap = kcalloc(BITS_TO_LONGS(num_vec),
-					    sizeof(long), GFP_KERNEL);
+	adap->msix_bmap.msix_bmap = bitmap_zalloc(num_vec, GFP_KERNEL);
 	if (!adap->msix_bmap.msix_bmap) {
 		kfree(msix_info);
 		return -ENOMEM;
@@ -5870,7 +5865,7 @@ static int alloc_msix_info(struct adapter *adap, u32 num_vec)
 
 static void free_msix_info(struct adapter *adap)
 {
-	kfree(adap->msix_bmap.msix_bmap);
+	bitmap_free(adap->msix_bmap.msix_bmap);
 	kfree(adap->msix_info);
 }
 
@@ -6189,10 +6184,10 @@ static void free_some_resources(struct adapter *adapter)
 	cxgb4_cleanup_ethtool_filters(adapter);
 	kfree(adapter->sge.egr_map);
 	kfree(adapter->sge.ingr_map);
-	kfree(adapter->sge.starving_fl);
-	kfree(adapter->sge.txq_maperr);
+	bitmap_free(adapter->sge.starving_fl);
+	bitmap_free(adapter->sge.txq_maperr);
 #ifdef CONFIG_DEBUG_FS
-	kfree(adapter->sge.blocked_fl);
+	bitmap_free(adapter->sge.blocked_fl);
 #endif
 	disable_msi(adapter);
 
-- 
2.34.1

