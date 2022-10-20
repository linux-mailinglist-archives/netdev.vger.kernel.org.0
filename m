Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E205605911
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiJTHxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiJTHxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:53:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BA8163393
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666252419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2BAneK9GcjYPPpYozl24p3lMeV2Zp2TkVz542OfMHWQ=;
        b=RsNn565YwTq3UCp50iOjBVsp2Cft20wxUKB0Y6tv9/eDkma+AEgoqLh1ocIodRG+rK+4+k
        yMH5Son5KmmcA1xjl/MNv50aa+Ewozhu1prk5zbU/pevYBLSBHGeF92oPoC9Ur2Pn04e+3
        AG8YNrwBZJxFSjAD8FqrfiNJZxjrn4c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-BgRgfgzBNruxJd6_L_S6DQ-1; Thu, 20 Oct 2022 03:53:36 -0400
X-MC-Unique: BgRgfgzBNruxJd6_L_S6DQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B323187B2A1;
        Thu, 20 Oct 2022 07:53:33 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.192.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99F262166B29;
        Thu, 20 Oct 2022 07:53:14 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     irusskikh@marvell.com, kuba@kernel.org, andrew@lunn.ch
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        dbogdanov@marvell.com, mstarovo@pm.me, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Li Liang <liali@redhat.com>
Subject: [PATCH v2 net] atlantic: fix deadlock at aq_nic_stop
Date:   Thu, 20 Oct 2022 09:53:10 +0200
Message-Id: <20221020075310.15226-1-ihuguet@redhat.com>
In-Reply-To: <20221014103443.138574-1-ihuguet@redhat.com>
References: <20221014103443.138574-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NIC is stopped with rtnl_lock held, and during the stop it cancels the
'service_task' work and free irqs.

However, if CONFIG_MACSEC is set, rtnl_lock is acquired both from
aq_nic_service_task and aq_linkstate_threaded_isr. Then a deadlock
happens if aq_nic_stop tries to cancel/disable them when they've already
started their execution.

As the deadlock is caused by rtnl_lock, it causes many other processes
to stall, not only atlantic related stuff.

Fix it by introducing a mutex that protects each NIC's macsec related
data, and locking it instead of the rtnl_lock from the service task and
the threaded IRQ.

Before this patch, all macsec data was protected with rtnl_lock, but
maybe not all of it needs to be protected. With this new mutex, further
efforts can be made to limit the protected data only to that which
requires it. However, probably it doesn't worth it because all macsec's
data accesses are infrequent, and almost all are done from macsec_ops
or ethtool callbacks, called holding rtnl_lock, so macsec_mutex won't
never be much contended.

The issue appeared repeteadly attaching and deattaching the NIC to a
bond interface. Doing that after this patch I cannot reproduce the bug.

Fixes: 62c1c2e606f6 ("net: atlantic: MACSec offload skeleton")
Reported-by: Li Liang <liali@redhat.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

---

v2: per Andrew Lunn's suggestion, avoid rtnl_trylock approach and use a
dedicated mutex instead.
---
 .../ethernet/aquantia/atlantic/aq_macsec.c    | 96 ++++++++++++++-----
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  2 +
 2 files changed, 74 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 3d0e16791e1c..a0180811305d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -1394,26 +1394,57 @@ static void aq_check_txsa_expiration(struct aq_nic_s *nic)
 			egress_sa_threshold_expired);
 }
 
+#define AQ_LOCKED_MDO_DEF(mdo)						\
+static int aq_locked_mdo_##mdo(struct macsec_context *ctx)		\
+{									\
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);		\
+	int ret;							\
+	mutex_lock(&nic->macsec_mutex);					\
+	ret = aq_mdo_##mdo(ctx);					\
+	mutex_unlock(&nic->macsec_mutex);				\
+	return ret;							\
+}
+
+AQ_LOCKED_MDO_DEF(dev_open)
+AQ_LOCKED_MDO_DEF(dev_stop)
+AQ_LOCKED_MDO_DEF(add_secy)
+AQ_LOCKED_MDO_DEF(upd_secy)
+AQ_LOCKED_MDO_DEF(del_secy)
+AQ_LOCKED_MDO_DEF(add_rxsc)
+AQ_LOCKED_MDO_DEF(upd_rxsc)
+AQ_LOCKED_MDO_DEF(del_rxsc)
+AQ_LOCKED_MDO_DEF(add_rxsa)
+AQ_LOCKED_MDO_DEF(upd_rxsa)
+AQ_LOCKED_MDO_DEF(del_rxsa)
+AQ_LOCKED_MDO_DEF(add_txsa)
+AQ_LOCKED_MDO_DEF(upd_txsa)
+AQ_LOCKED_MDO_DEF(del_txsa)
+AQ_LOCKED_MDO_DEF(get_dev_stats)
+AQ_LOCKED_MDO_DEF(get_tx_sc_stats)
+AQ_LOCKED_MDO_DEF(get_tx_sa_stats)
+AQ_LOCKED_MDO_DEF(get_rx_sc_stats)
+AQ_LOCKED_MDO_DEF(get_rx_sa_stats)
+
 const struct macsec_ops aq_macsec_ops = {
-	.mdo_dev_open = aq_mdo_dev_open,
-	.mdo_dev_stop = aq_mdo_dev_stop,
-	.mdo_add_secy = aq_mdo_add_secy,
-	.mdo_upd_secy = aq_mdo_upd_secy,
-	.mdo_del_secy = aq_mdo_del_secy,
-	.mdo_add_rxsc = aq_mdo_add_rxsc,
-	.mdo_upd_rxsc = aq_mdo_upd_rxsc,
-	.mdo_del_rxsc = aq_mdo_del_rxsc,
-	.mdo_add_rxsa = aq_mdo_add_rxsa,
-	.mdo_upd_rxsa = aq_mdo_upd_rxsa,
-	.mdo_del_rxsa = aq_mdo_del_rxsa,
-	.mdo_add_txsa = aq_mdo_add_txsa,
-	.mdo_upd_txsa = aq_mdo_upd_txsa,
-	.mdo_del_txsa = aq_mdo_del_txsa,
-	.mdo_get_dev_stats = aq_mdo_get_dev_stats,
-	.mdo_get_tx_sc_stats = aq_mdo_get_tx_sc_stats,
-	.mdo_get_tx_sa_stats = aq_mdo_get_tx_sa_stats,
-	.mdo_get_rx_sc_stats = aq_mdo_get_rx_sc_stats,
-	.mdo_get_rx_sa_stats = aq_mdo_get_rx_sa_stats,
+	.mdo_dev_open = aq_locked_mdo_dev_open,
+	.mdo_dev_stop = aq_locked_mdo_dev_stop,
+	.mdo_add_secy = aq_locked_mdo_add_secy,
+	.mdo_upd_secy = aq_locked_mdo_upd_secy,
+	.mdo_del_secy = aq_locked_mdo_del_secy,
+	.mdo_add_rxsc = aq_locked_mdo_add_rxsc,
+	.mdo_upd_rxsc = aq_locked_mdo_upd_rxsc,
+	.mdo_del_rxsc = aq_locked_mdo_del_rxsc,
+	.mdo_add_rxsa = aq_locked_mdo_add_rxsa,
+	.mdo_upd_rxsa = aq_locked_mdo_upd_rxsa,
+	.mdo_del_rxsa = aq_locked_mdo_del_rxsa,
+	.mdo_add_txsa = aq_locked_mdo_add_txsa,
+	.mdo_upd_txsa = aq_locked_mdo_upd_txsa,
+	.mdo_del_txsa = aq_locked_mdo_del_txsa,
+	.mdo_get_dev_stats = aq_locked_mdo_get_dev_stats,
+	.mdo_get_tx_sc_stats = aq_locked_mdo_get_tx_sc_stats,
+	.mdo_get_tx_sa_stats = aq_locked_mdo_get_tx_sa_stats,
+	.mdo_get_rx_sc_stats = aq_locked_mdo_get_rx_sc_stats,
+	.mdo_get_rx_sa_stats = aq_locked_mdo_get_rx_sa_stats,
 };
 
 int aq_macsec_init(struct aq_nic_s *nic)
@@ -1435,6 +1466,7 @@ int aq_macsec_init(struct aq_nic_s *nic)
 
 	nic->ndev->features |= NETIF_F_HW_MACSEC;
 	nic->ndev->macsec_ops = &aq_macsec_ops;
+	mutex_init(&nic->macsec_mutex);
 
 	return 0;
 }
@@ -1458,7 +1490,7 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 	if (!nic->macsec_cfg)
 		return 0;
 
-	rtnl_lock();
+	mutex_lock(&nic->macsec_mutex);
 
 	if (nic->aq_fw_ops->send_macsec_req) {
 		struct macsec_cfg_request cfg = { 0 };
@@ -1507,7 +1539,7 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 	ret = aq_apply_macsec_cfg(nic);
 
 unlock:
-	rtnl_unlock();
+	mutex_unlock(&nic->macsec_mutex);
 	return ret;
 }
 
@@ -1519,9 +1551,9 @@ void aq_macsec_work(struct aq_nic_s *nic)
 	if (!netif_carrier_ok(nic->ndev))
 		return;
 
-	rtnl_lock();
+	mutex_lock(&nic->macsec_mutex);
 	aq_check_txsa_expiration(nic);
-	rtnl_unlock();
+	mutex_unlock(&nic->macsec_mutex);
 }
 
 int aq_macsec_rx_sa_cnt(struct aq_nic_s *nic)
@@ -1532,21 +1564,30 @@ int aq_macsec_rx_sa_cnt(struct aq_nic_s *nic)
 	if (!cfg)
 		return 0;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
 		if (!test_bit(i, &cfg->rxsc_idx_busy))
 			continue;
 		cnt += hweight_long(cfg->aq_rxsc[i].rx_sa_idx_busy);
 	}
 
+	mutex_unlock(&nic->macsec_mutex);
 	return cnt;
 }
 
 int aq_macsec_tx_sc_cnt(struct aq_nic_s *nic)
 {
+	int cnt;
+
 	if (!nic->macsec_cfg)
 		return 0;
 
-	return hweight_long(nic->macsec_cfg->txsc_idx_busy);
+	mutex_lock(&nic->macsec_mutex);
+	cnt = hweight_long(nic->macsec_cfg->txsc_idx_busy);
+	mutex_unlock(&nic->macsec_mutex);
+
+	return cnt;
 }
 
 int aq_macsec_tx_sa_cnt(struct aq_nic_s *nic)
@@ -1557,12 +1598,15 @@ int aq_macsec_tx_sa_cnt(struct aq_nic_s *nic)
 	if (!cfg)
 		return 0;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
 		if (!test_bit(i, &cfg->txsc_idx_busy))
 			continue;
 		cnt += hweight_long(cfg->aq_txsc[i].tx_sa_idx_busy);
 	}
 
+	mutex_unlock(&nic->macsec_mutex);
 	return cnt;
 }
 
@@ -1634,6 +1678,8 @@ u64 *aq_macsec_get_stats(struct aq_nic_s *nic, u64 *data)
 	if (!cfg)
 		return data;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	aq_macsec_update_stats(nic);
 
 	common_stats = &cfg->stats;
@@ -1716,5 +1762,7 @@ u64 *aq_macsec_get_stats(struct aq_nic_s *nic, u64 *data)
 
 	data += i;
 
+	mutex_unlock(&nic->macsec_mutex);
+
 	return data;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 935ba889bd9a..ad33f8586532 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -157,6 +157,8 @@ struct aq_nic_s {
 	struct mutex fwreq_mutex;
 #if IS_ENABLED(CONFIG_MACSEC)
 	struct aq_macsec_cfg *macsec_cfg;
+	/* mutex to protect data in macsec_cfg */
+	struct mutex macsec_mutex;
 #endif
 	/* PTP support */
 	struct aq_ptp_s *aq_ptp;
-- 
2.34.1

