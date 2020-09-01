Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D64B259E01
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgIASUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgIASUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:20:34 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A8FC061246
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 11:20:33 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id t9so1282394pfq.8
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 11:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d313eD54a7wBpf4xIcIfjkC0vS1lqfvdWPstPVu4Iqw=;
        b=nC4mzWjaQJdYMTkfgDEpFZ1dR1FHJu4B1aEtQDUDt79VYBWHqpzcOt0SoNF7XKmFJf
         oXCzacNl3ISYRJwNRi2bo97noEa2BewTFhqPHXcrmeKl99SFxO06pJTvYeh8eSl3+qyT
         sZ/pW6Hu0xc9sOmU2FnSG710ei2DT3ErHhHOtvV87wLHWmFbDs8r4WR978ncxgfikhUX
         Lty980B31xMITP1scTDIxInD+TbjldnFnt4k74WaRhkfCDDrG+9/avU6yoqUE+Axvkv8
         LiZtX/Lf9rlxke+fcNXJGCiHgJ+SNiSBxdrDYWAPBwa949+YeBw9z+5JlPLeXEiYRxBm
         5oaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d313eD54a7wBpf4xIcIfjkC0vS1lqfvdWPstPVu4Iqw=;
        b=Jy4PKvgMz2QW6S+556s3xllbH45nJ5XPo3CWwCnfl+GcI0mX8ItVnLzqxP626xgvJP
         uTWhmCQMEQilqAJjkI+/jgzyASzwRMDuK8wCsopLR7KrLvRMCBD+H/eyyoZO6auUP7AN
         R06O3H4g1MyghnFzwI4Q/sAxo+sRk/EsvbYi/vbrH3nSw+BIbaVNwguaFOBuNHR0IOXr
         wxHIwp26+fXpTxsa57uvbuUziTCzb8sQKDcOLxA8hy4B0+KlUGP7cTRa6442B0bYeblu
         DkLPekUVpKiw9bnjJ+SqNfas27WejbDCbCdZZou5Mv2n8YnP0NS9UyUm1g2g4wyvXxjQ
         ITSg==
X-Gm-Message-State: AOAM530RWsrRnoJvCcmLqdEPVdUQ95x6yC6ET2FYnVhJvRezOpZm8c7p
        1Q7C3BVGSj4vhYszBHwtuOS+onMpCmSX8Q==
X-Google-Smtp-Source: ABdhPJy4hUcPF6QOQRZbY+XFtCApZfJfP1xRwcDuvrWe4jj/s9U1tynLe13YLRpVawttjNL8uc9Zlw==
X-Received: by 2002:a62:1d44:: with SMTP id d65mr3096700pfd.150.1598984433143;
        Tue, 01 Sep 2020 11:20:33 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id j81sm2747086pfd.213.2020.09.01.11.20.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 11:20:32 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/6] ionic: struct reorder for faster access
Date:   Tue,  1 Sep 2020 11:20:20 -0700
Message-Id: <20200901182024.64101-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901182024.64101-1-snelson@pensando.io>
References: <20200901182024.64101-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move a few active struct fields to the front of the struct
for a little better cache use and performance.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.h    | 18 +++++++++---------
 .../net/ethernet/pensando/ionic/ionic_lif.h    | 14 +++++++-------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 9e2ac2b8a082..0641ca2e1780 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -199,16 +199,17 @@ struct ionic_desc_info {
 
 struct ionic_queue {
 	struct device *dev;
-	u64 dbell_count;
-	u64 drop;
-	u64 stop;
-	u64 wake;
 	struct ionic_lif *lif;
 	struct ionic_desc_info *info;
-	struct ionic_dev *idev;
 	u16 head_idx;
 	u16 tail_idx;
 	unsigned int index;
+	unsigned int num_descs;
+	u64 dbell_count;
+	u64 stop;
+	u64 wake;
+	u64 drop;
+	struct ionic_dev *idev;
 	unsigned int type;
 	unsigned int hw_index;
 	unsigned int hw_type;
@@ -226,7 +227,6 @@ struct ionic_queue {
 	};
 	dma_addr_t base_pa;
 	dma_addr_t sg_base_pa;
-	unsigned int num_descs;
 	unsigned int desc_size;
 	unsigned int sg_desc_size;
 	unsigned int pid;
@@ -246,8 +246,6 @@ struct ionic_intr_info {
 };
 
 struct ionic_cq {
-	void *base;
-	dma_addr_t base_pa;
 	struct ionic_lif *lif;
 	struct ionic_cq_info *info;
 	struct ionic_queue *bound_q;
@@ -255,8 +253,10 @@ struct ionic_cq {
 	u16 tail_idx;
 	bool done_color;
 	unsigned int num_descs;
-	u64 compl_count;
 	unsigned int desc_size;
+	u64 compl_count;
+	void *base;
+	dma_addr_t base_pa;
 };
 
 struct ionic;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index e1e6ff1a0918..11ea9e0c6a4a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -16,32 +16,32 @@
 #define IONIC_TX_BUDGET_DEFAULT		256
 
 struct ionic_tx_stats {
-	u64 dma_map_err;
 	u64 pkts;
 	u64 bytes;
-	u64 clean;
-	u64 linearize;
 	u64 csum_none;
 	u64 csum;
-	u64 crc32_csum;
 	u64 tso;
 	u64 tso_bytes;
 	u64 frags;
 	u64 vlan_inserted;
+	u64 clean;
+	u64 linearize;
+	u64 crc32_csum;
 	u64 sg_cntr[IONIC_MAX_NUM_SG_CNTR];
+	u64 dma_map_err;
 };
 
 struct ionic_rx_stats {
-	u64 dma_map_err;
-	u64 alloc_err;
 	u64 pkts;
 	u64 bytes;
 	u64 csum_none;
 	u64 csum_complete;
-	u64 csum_error;
 	u64 buffers_posted;
 	u64 dropped;
 	u64 vlan_stripped;
+	u64 csum_error;
+	u64 dma_map_err;
+	u64 alloc_err;
 };
 
 #define IONIC_QCQ_F_INITED		BIT(0)
-- 
2.17.1

