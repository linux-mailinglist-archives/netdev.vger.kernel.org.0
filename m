Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EA1258474
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 01:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgHaXgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 19:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgHaXgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 19:36:11 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662A1C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:11 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mm21so745104pjb.4
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KgXZdM7W7kfk4TYvsCyI2TxUr5gp7VRTxKkVQMYG7rg=;
        b=GFNTQ5nWCeAnNRo7TklxIznWBbdTCe6+m1s/zI35dbu/5EoCREoX6qKZU4zbdrAhU4
         2FMCosRopYDqjZHVGLTAxXdEGkzYfb76tzw8y2SyuOh9OApzc6EAauoqc30mrYV6Yx0+
         bRDY7KV+THYIOptmUKbJp2Xtlz/LGQj15yD4qujH46Pw1QLA7ZNOe7Q4vUwlyqzWvmsw
         w9UsXX84DMlcwJaC+hfNVJMpJ1c53j5S6OSQT3NoklIbAO9jaeCYUptpMmsNWu2IAE3A
         S7tEr+crBg9R2bwBnULidzzC4/2sxN2vx3kf7cw3/9wrmXfA1rwwuinJiKnsVrS9h7NN
         40FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KgXZdM7W7kfk4TYvsCyI2TxUr5gp7VRTxKkVQMYG7rg=;
        b=qhMU6v/aEgsw8KZJj2XUaNKJTFI5nWF03MW92Ztx6Dtf2nix/nXIKZcPFoP4av3bMi
         SfIbH9H04KpwR2yTVsfJF6SfK1MRUX8pHw7IE1+ho4+FBSy3vdf0MoZG7oj7DCaib2Uo
         H/uAJ9buvNCsa/oQ9x+ZoWvJwnbu8Nl4/5IzayAUUsk4/tmJZcOIdjHkuxX2xGbfAls7
         1tSrjUeSgftrNK+aae6fWqxVbPyb0hbQOOzh0/yX7fAYBsdRYocBPPoiAzR9K5bPgfMf
         2/F7MZL9H+DwOL5spAyuw6vdaNgEQ3A7vaJe5KLI+8w8TmFyrNx1Dv3mR0l1EqqPRh7i
         QeAw==
X-Gm-Message-State: AOAM531lEeYrg9wOLAoQ6zi1o+uSphrQN9azujfs5UlLh5tvdCFRjlPE
        7Lso3pwRLx+W0wWIL/zGLcDgYrhjNtX2JA==
X-Google-Smtp-Source: ABdhPJwlpmpD8qgy6On0kMjdq/9QVGxjhTplOfKgBHnen9cQBlTFEMtlx+UENSCm4upD3rFD8fRqQA==
X-Received: by 2002:a17:90a:e64b:: with SMTP id ep11mr1566091pjb.10.1598916969188;
        Mon, 31 Aug 2020 16:36:09 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 65sm9082651pfx.104.2020.08.31.16.36.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Aug 2020 16:36:08 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/5] ionic: struct reorder for faster access
Date:   Mon, 31 Aug 2020 16:35:56 -0700
Message-Id: <20200831233558.71417-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831233558.71417-1-snelson@pensando.io>
References: <20200831233558.71417-1-snelson@pensando.io>
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
index 2b2eb5f2a0e5..87debc512755 100644
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

