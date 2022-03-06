Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E984F4CEA1B
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 09:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbiCFI6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 03:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbiCFI6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 03:58:32 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941DA1A394
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 00:57:39 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id q17so16017270edd.4
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 00:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k6CeGpm/lwo9g059L+ipT3MX8Qu35+AyMwdPGKmU+fQ=;
        b=hOXJDS7wcoaKCIXCo6nqbQ7xulyTuhYSlxmTYEQyhdiIjnRA9Knt93J1F49QiyhEZT
         oApXKTO2dec3oe6WxsbRgLEm11cxQbt+IaZ5yT9+t+RlHWivibt+d6UkWdqLy2RWbAV9
         IAhOve8i+x1JXflXTXfq7Gf5g9e47/7Em7zYZJ/qGyDg3ixfImbhrK0MO4Lvue+28Oh0
         MCHZfxDi1+o9NHG+bbI9X/MTqxD2DjLw5yrvJXyrVuhL+PpIvmWGySwK7xLrZ1GtvEgw
         Df4niHEO7r8d0+LU+A+YUPXxjzBfhjfkVgZ3wbGhHmCfOgD8RLRullr2pW1+x1UyUAJf
         v5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k6CeGpm/lwo9g059L+ipT3MX8Qu35+AyMwdPGKmU+fQ=;
        b=sEBdfPlNPnpycnSaHz4CDevHDPqj3njnqdcL8ROAsxkv2IWNmZYaPtkOPmEaPXoogo
         xgovjEtUo3deEtplAw6ZkAA3ydKoVevGdZdo307XrX5CG4/nvwrTDq1Yx6ThhOqNZLAu
         3TjKg7CvjY5776r8wQLKoz6oqp+ysOfDk2GzGuVauaGiQsWAQz7dkpHvfXI3I8G6hmzh
         lgSVKMJFbqVZFgd6yavuJRSZ6Tbatj9Sr05xZehAgCDmEiyClQBq1vTt6jgPxePxo618
         ajZYcCkZQ58oyljeiWQcQNQgBBICElLCjE/f9lF5ZLH1pYDBcctPvpgCGFKBrDUxUee2
         rqrQ==
X-Gm-Message-State: AOAM533fSdnYwcGS+BgkA3yrf8LhLhObbEnLUKLLoeViXiQ9LQx8On8i
        uaQAJetpN5wiqhYP3O5Polq0gNV7QCTXzR/z
X-Google-Smtp-Source: ABdhPJyyqhGGVtsfvrYZSSPLT1wC0pZVqDSL0GwmADyV/sBa2UBmHLwTJXYOXpbXV/pkaXeVoNwGzg==
X-Received: by 2002:a05:6402:5209:b0:412:7cd8:a8fc with SMTP id s9-20020a056402520900b004127cd8a8fcmr5964671edd.51.1646557058088;
        Sun, 06 Mar 2022 00:57:38 -0800 (PST)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id z24-20020a170906815800b006dab4bd985dsm2663423ejw.107.2022.03.06.00.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 00:57:37 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [RFC PATCH net-next 2/6] ptp: Initialize skb_shared_hwtstamps
Date:   Sun,  6 Mar 2022 09:56:54 +0100
Message-Id: <20220306085658.1943-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220306085658.1943-1-gerhard@engleder-embedded.com>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are only a few locations, which do not initialize the whole
skb_shared_hwtstamps structure and write the only field of the
structure. This is ok as long as skb_shared_hwtstamps is not extended
with additional fields.

Always initialize the whole skb_shared_hwtstamps structure to prepare
for future extensions of this structure.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c        | 1 +
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c     | 1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c         | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c     | 1 +
 drivers/net/ethernet/sfc/tx_common.c                   | 1 +
 drivers/ptp/ptp_ines.c                                 | 1 +
 7 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index ba28aa444e5a..8c7868007bdf 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2212,6 +2212,7 @@ static void handle_timestamp(struct octeon_device *oct,
 		netif_info(lio, tx_done, lio->netdev,
 			   "Got resulting SKBTX_HW_TSTAMP skb=%p ns=%016llu\n",
 			   skb, (unsigned long long)ns);
+		memset(&ts, 0, sizeof(ts));
 		ts.hwtstamp = ns_to_ktime(ns + lio->ptp_adjust);
 		skb_tstamp_tx(skb, &ts);
 	}
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 568f211d91cc..ebac2d46a3bf 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1340,6 +1340,7 @@ static void handle_timestamp(struct octeon_device *oct, u32 status, void *buf)
 		netif_info(lio, tx_done, lio->netdev,
 			   "Got resulting SKBTX_HW_TSTAMP skb=%p ns=%016llu\n",
 			   skb, (unsigned long long)ns);
+		memset(&ts, 0, sizeof(ts));
 		ts.hwtstamp = ns_to_ktime(ns + lio->ptp_adjust);
 		skb_tstamp_tx(skb, &ts);
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
index 5bf117d2179f..67241dbe575c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
@@ -109,6 +109,7 @@ void cxgb4_ptp_read_hwstamp(struct adapter *adapter, struct port_info *pi)
 	tx_ts |= (u64)t4_read_reg(adapter,
 				  T5_PORT_REG(pi->port_id,
 					      MAC_PORT_TX_TS_VAL_HI)) << 32;
+	memset(skb_ts, 0, sizeof(*skb_ts));
 	skb_ts->hwtstamp = ns_to_ktime(tx_ts);
 	skb_tstamp_tx(adapter->ptp_tx_skb, skb_ts);
 	dev_kfree_skb_any(adapter->ptp_tx_skb);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
index a40b1583f114..4e378d856529 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -103,6 +103,7 @@ void hclge_ptp_clean_tx_hwts(struct hclge_dev *hdev)
 		hdev->ptp->tx_cleaned++;
 
 		ns += (((u64)hi) << 32 | lo) * NSEC_PER_SEC;
+		memset(&hwts, 0, sizeof(hwts));
 		hwts.hwtstamp = ns_to_ktime(ns);
 		skb_tstamp_tx(skb, &hwts);
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 35422e64d89f..887a09887f03 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -445,6 +445,7 @@ static void mlxsw_sp1_packet_timestamp(struct mlxsw_sp *mlxsw_sp,
 	nsec = timecounter_cyc2time(&mlxsw_sp->clock->tc, timestamp);
 	spin_unlock_bh(&mlxsw_sp->clock->lock);
 
+	memset(&hwtstamps, 0, sizeof(hwtstamps));
 	hwtstamps.hwtstamp = ns_to_ktime(nsec);
 	mlxsw_sp1_ptp_packet_finish(mlxsw_sp, skb,
 				    key.local_port, key.ingress, &hwtstamps);
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index d530cde2b864..f7b6228a6be0 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -170,6 +170,7 @@ void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 		     tx_queue->completed_timestamp_minor)) {
 			struct skb_shared_hwtstamps hwtstamp;
 
+			memset(&hwtstamp, 0, sizeof(hwtstamp));
 			hwtstamp.hwtstamp =
 				efx_ptp_nic_to_kernel_time(tx_queue);
 			skb_tstamp_tx(skb, &hwtstamp);
diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
index 61f47fb9d997..6413e44267cc 100644
--- a/drivers/ptp/ptp_ines.c
+++ b/drivers/ptp/ptp_ines.c
@@ -659,6 +659,7 @@ static void ines_txtstamp_work(struct work_struct *work)
 		kfree_skb(skb);
 		return;
 	}
+	memset(&ssh, 0, sizeof(ssh));
 	ssh.hwtstamp = ns_to_ktime(ns);
 	skb_complete_tx_timestamp(skb, &ssh);
 }
-- 
2.20.1

