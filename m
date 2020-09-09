Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79296262AC8
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgIIIq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729860AbgIIIqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:46:03 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC273C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:46:02 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id o16so997172pjr.2
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5H2o4KstyUczAeQ512nCP1P7QM7Q38v2/L6/hW5JfE=;
        b=PlO+/9bCb1YRiLpTgXA2lBYaKUAl1TtrU1nhkEhMPZe26/sr+VUOc61eOsd3hlBIcx
         u41BoLOPgiywkgi1aHKOcp+HCAJHK85UrIl+pgXuuJF4tlhXq7gopXMWRDWklcRcPH+q
         NYW8oXtCsdDzAc0aYEoW3OwDqdGKyDk+Ed01bdvpuFluLTnrxtPLcnx5DKgUDZdAq4F7
         dlOPyW5/YyrK3F+/SOgyCfsjcD5n4NzZhxfAq6FT/CpQPIiZ/gClPtOxWREgLc3GiNPe
         fUAg22TPWJgIpe38WTdHeyC+aJ+PruLbD4zSKifNddcO3PKgJDqlYIfApQVWRUOBFiGp
         A/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5H2o4KstyUczAeQ512nCP1P7QM7Q38v2/L6/hW5JfE=;
        b=HgYr4qkMnAXd0kybc/eQf0IXuvMzIPjMpu1NsqyPFlh33UBTOBL9AnVGV44aIqPV5o
         khAKxilSysRMTLB3cEX3J80R4z+1m/CMOqP9T72R8EX5FxecoifRbkzrjTQYEb81+wYa
         49Q8SpccarRO+H7u9u1x0ELm5TYBuDli8ZBWdcEFARgPgB+PGfBkkb0LTxT1/aGZbL2a
         WbyUwxNX6sSc8QQMIdH/cXtW0jCasiLwiC4c0Z24LJVY+bt3fqw+1rSd6dJs6JDzqEIH
         2xUKrdV4PnJKsjUMcm3VkOoY6O4nOcdqp6fA7RYoS9E8wW0nhjmHfzzmhM+YnXVaPJTH
         a+rg==
X-Gm-Message-State: AOAM530H3b/yW5Q/Esi5JQmYSf6wOa4H/J9nFSgcpVedAGR3lqaltVsD
        gXO+piFAy9LxLuWhNUMXKIPxRLq1x7gCTA==
X-Google-Smtp-Source: ABdhPJyxpygj5MtqKCL5CeRewqEKIMKiRgfYiYJpUYtPEGUIqbJ6bP+JDiI0HWiFlZbyoBVt+2xPzg==
X-Received: by 2002:a17:90a:7f93:: with SMTP id m19mr2790972pjl.194.1599641162331;
        Wed, 09 Sep 2020 01:46:02 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:46:01 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 11/20] ethernet: jme: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:15:01 +0530
Message-Id: <20200909084510.648706-12-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/jme.c | 40 +++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index ddc757680089..e9efe074edc1 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -1187,9 +1187,9 @@ jme_shutdown_nic(struct jme_adapter *jme)
 }
 
 static void
-jme_pcc_tasklet(unsigned long arg)
+jme_pcc_tasklet(struct tasklet_struct *t)
 {
-	struct jme_adapter *jme = (struct jme_adapter *)arg;
+	struct jme_adapter *jme = from_tasklet(jme, t, pcc_task);
 	struct net_device *netdev = jme->dev;
 
 	if (unlikely(test_bit(JME_FLAG_SHUTDOWN, &jme->flags))) {
@@ -1265,10 +1265,9 @@ jme_stop_shutdown_timer(struct jme_adapter *jme)
 	jwrite32f(jme, JME_APMC, apmc);
 }
 
-static void
-jme_link_change_tasklet(unsigned long arg)
+static void jme_link_change_tasklet(struct tasklet_struct *t)
 {
-	struct jme_adapter *jme = (struct jme_adapter *)arg;
+	struct jme_adapter *jme = from_tasklet(jme, t, linkch_task);
 	struct net_device *netdev = jme->dev;
 	int rc;
 
@@ -1345,9 +1344,9 @@ jme_link_change_tasklet(unsigned long arg)
 }
 
 static void
-jme_rx_clean_tasklet(unsigned long arg)
+jme_rx_clean_tasklet(struct tasklet_struct *t)
 {
-	struct jme_adapter *jme = (struct jme_adapter *)arg;
+	struct jme_adapter *jme = from_tasklet(jme, t, rxclean_task);
 	struct dynpcc_info *dpi = &(jme->dpi);
 
 	jme_process_receive(jme, jme->rx_ring_size);
@@ -1380,9 +1379,9 @@ jme_poll(JME_NAPI_HOLDER(holder), JME_NAPI_WEIGHT(budget))
 }
 
 static void
-jme_rx_empty_tasklet(unsigned long arg)
+jme_rx_empty_tasklet(struct tasklet_struct *t)
 {
-	struct jme_adapter *jme = (struct jme_adapter *)arg;
+	struct jme_adapter *jme = from_tasklet(jme, t, rxempty_task);
 
 	if (unlikely(atomic_read(&jme->link_changing) != 1))
 		return;
@@ -1392,7 +1391,7 @@ jme_rx_empty_tasklet(unsigned long arg)
 
 	netif_info(jme, rx_status, jme->dev, "RX Queue Full!\n");
 
-	jme_rx_clean_tasklet(arg);
+	jme_rx_clean_tasklet(&jme->rxclean_task);
 
 	while (atomic_read(&jme->rx_empty) > 0) {
 		atomic_dec(&jme->rx_empty);
@@ -1416,10 +1415,9 @@ jme_wake_queue_if_stopped(struct jme_adapter *jme)
 
 }
 
-static void
-jme_tx_clean_tasklet(unsigned long arg)
+static void jme_tx_clean_tasklet(struct tasklet_struct *t)
 {
-	struct jme_adapter *jme = (struct jme_adapter *)arg;
+	struct jme_adapter *jme = from_tasklet(jme, t, txclean_task);
 	struct jme_ring *txring = &(jme->txring[0]);
 	struct txdesc *txdesc = txring->desc;
 	struct jme_buffer_info *txbi = txring->bufinf, *ctxbi, *ttxbi;
@@ -1834,14 +1832,10 @@ jme_open(struct net_device *netdev)
 	jme_clear_pm_disable_wol(jme);
 	JME_NAPI_ENABLE(jme);
 
-	tasklet_init(&jme->linkch_task, jme_link_change_tasklet,
-		     (unsigned long) jme);
-	tasklet_init(&jme->txclean_task, jme_tx_clean_tasklet,
-		     (unsigned long) jme);
-	tasklet_init(&jme->rxclean_task, jme_rx_clean_tasklet,
-		     (unsigned long) jme);
-	tasklet_init(&jme->rxempty_task, jme_rx_empty_tasklet,
-		     (unsigned long) jme);
+	tasklet_setup(&jme->linkch_task, jme_link_change_tasklet);
+	tasklet_setup(&jme->txclean_task, jme_tx_clean_tasklet);
+	tasklet_setup(&jme->rxclean_task, jme_rx_clean_tasklet);
+	tasklet_setup(&jme->rxempty_task, jme_rx_empty_tasklet);
 
 	rc = jme_request_irq(jme);
 	if (rc)
@@ -3040,9 +3034,7 @@ jme_init_one(struct pci_dev *pdev,
 	atomic_set(&jme->tx_cleaning, 1);
 	atomic_set(&jme->rx_empty, 1);
 
-	tasklet_init(&jme->pcc_task,
-		     jme_pcc_tasklet,
-		     (unsigned long) jme);
+	tasklet_setup(&jme->pcc_task, jme_pcc_tasklet);
 	jme->dpi.cur = PCC_P1;
 
 	jme->reg_ghc = 0;
-- 
2.25.1

