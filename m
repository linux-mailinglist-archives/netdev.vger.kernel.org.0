Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EEC246005
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgHQI0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgHQIZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:25:59 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49A2C061388;
        Mon, 17 Aug 2020 01:25:59 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 128so7765146pgd.5;
        Mon, 17 Aug 2020 01:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2lWTwfGunDOTtwrs6ILJYDdQIZghCfDlVzunIeUIAUk=;
        b=kSZoZKRGgALpz+rZ1rW4PeRUO4mvrUjXHJCHKyxtMUtQUhXwaE9HJJ7el6oyO7OOQx
         lXYshzblUOVqLabYIbGjttJclIN9gL3539pLtVDVK9JXTdhavTDEE3dsHqQ5wAYvlJPy
         zvkZWlPoZQb9yg30asCxwKCpGAcuPV9/8kTJ+1TY4ad6Zzb4Ra7b/q56IrzacHNUHvj9
         J388zqCTJYUc5/LAGQo1JI7xxtfYsX26N4YZZTlao2oCGpP2BHYHLWlMz7LFAzJYYk/h
         lVdADjdY4TLYRC2sTeADdTJhfjj6RSC9e3ufqO6H6bYUDH14JYwZeP1ykSFvmTO9/oGI
         C3Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2lWTwfGunDOTtwrs6ILJYDdQIZghCfDlVzunIeUIAUk=;
        b=NJBgJ6Zw/oIfaPsiUEFQ1gFEMV/KM7mt+ckM6X+H6rFBirlS8gc1alQxLXNLNRumi3
         +cdk0FrUBH9aHQKu6CzxFoRj8jqZ7GH6Z3YfOrEM8abMJDa13zX9sXj5dXkmL0vwM6e6
         PCdn0OFn9Rcsid8d69RGSelYJq8XsN6sILv3NGuCJc/sPxVeNyyxXcK0+a1VKEllFGwl
         TGw+i77PC3eL69aF4EsNITSNwVfcz21mt62YHuLx/8fyhgyiqL56Xe0/NAHX9xPe0Kwx
         8hbrWVCWCNxpes9QW4S7kzoxEhWt4c7IfaxV81VFuRvxGfoA3ZLi5EVijBR60xNBYQng
         w60g==
X-Gm-Message-State: AOAM531M4hBn0dg3tmbL50ZXyDnw+DKKmpyk/V/JtB0B+RUz+fsnwDLh
        FzdCQEctGCa4m+O6te796D4=
X-Google-Smtp-Source: ABdhPJyiyk1L76pQbEM7KTHPtWb5CWW9jSXriZUpVIGgsJyJ/Z/vcZJfa1sOQ3p1ZAwHDvISchf1Ig==
X-Received: by 2002:a63:1822:: with SMTP id y34mr9759847pgl.364.1597652759213;
        Mon, 17 Aug 2020 01:25:59 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:25:58 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 11/20] ethernet: jme: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:25 +0530
Message-Id: <20200817082434.21176-13-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
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
2.17.1

