Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC3F2685EA
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgINHbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgINHag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:36 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A732C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:35 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s14so830142pju.1
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PQu44jX34niMe9yWaRIsglhuZesfqWCqKBJxJwKReTQ=;
        b=Q9rDgqGbG5La5/lgibc14Ml+jDk9QazkQYwhs32nQ2RsiwOFX4xVVvIW+QBfqvh2fp
         7K5RHybjQWALoy1yf4in98mIenDdiJGeqZDxczgvTy0IMKlkdq2+IZD93iivvmfb20XC
         W1WVUGACvew2kghwn2J62reDUG2ikROyVKINIi5ofO++xUOfqkmAR0O23zuWvPF+py0A
         wKJzPLQLrC+AZ0Mi+beKeJQ3P7153UEW62Rsc2mFBC5X/g6sy7uIGK4fpBKLd1G57pk6
         kf2IXC8kPTeF8MgSHsoCwai3bRtLrKDnU1Ds+aynB6n8E1D0wsiIrDoRwRpi5Fo62JEP
         lq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PQu44jX34niMe9yWaRIsglhuZesfqWCqKBJxJwKReTQ=;
        b=pqg4Y9YSrjt95haxjY7Pt/iBNeopAtzfct9sCG/EwUIxb6M38g6AB+YlWsz3/lfTWo
         UCBnljN73l4XyELHMexD7tPlgibNBnIj4sdTXdnZskwg+UcuvSN3sIQ0qaDyqE0ymCAd
         5VZNlmPf942DmQ1IJv3FNLHmtV/DtQzZpslRH0CdDq4MQfKJfZu4iCOzCxrDYRgY0aot
         ILE926urMnTa43tqySFpfH7qFImWqAaBeJJ6zINSPSeC9vfe2eNWHYvBEnfFo6wADa1r
         qkUgubBrAk7sd66CwYDQtDPY26Mv+Ql1/hhaQdTgzunf1Ol/NEmCKoWUUmN4nyYPlgu/
         zc7Q==
X-Gm-Message-State: AOAM531E+v2Y19h9Vtt+py4ZVkVuqwhsZzQguycJJlstaDhMHciA64k+
        FRKoopEm+StEMHixFRLAdRI=
X-Google-Smtp-Source: ABdhPJxjn/QmGPFkEPA30uRVo3OWReVx3iWRyDj1eckxjZGOQn2OFT+nZrYT2urx3FPuxB/1EOBDzQ==
X-Received: by 2002:a17:90b:b8f:: with SMTP id bd15mr13273618pjb.65.1600068635147;
        Mon, 14 Sep 2020 00:30:35 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:34 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 11/20] net: jme: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:30 +0530
Message-Id: <20200914072939.803280-12-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
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

