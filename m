Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A652685E2
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgINHaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgINHaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:12 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9BFC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:12 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x123so11868355pfc.7
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=430KOT9lVZ/Do3huAHdyMqDOOGyfBh/Fh5/1YFj+Bpw=;
        b=knZ+afmmrpbo+9Z8mN76tjIpE5Is+IeE/gvZ6O3ayxdtPPHvqhfixetQhT1Y0AUvmt
         6Qd/2tE5eJSBzDkuVU/38vmwRP5n5CtR65Ab5Qv5OnyddvbPvKwq5La5yUaGdhUdyMWG
         rO1IK8tcjRxGaXxEpyVOPg4C2e9pnlYbBxKqLN49Vsi7u1HWW0f+n0RCtUAQFkDM3Lb4
         K1OVAqfoMK1ea2nbEmVpxEzYswTuDn+lAFmT1WmVVKBgYz/CO+YNDWGSGOYIPgt6d5r1
         2ugfc+FdCXF0ihRdqQ/0vEPj4vpSTPo1cdnM6QnnU3VTB3StzXhHwVnVOxY0xMBdq8RU
         NzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=430KOT9lVZ/Do3huAHdyMqDOOGyfBh/Fh5/1YFj+Bpw=;
        b=T7XS5otBuSmPZ6nvbK3JXrBZPnwEhOKJ7m7j+au5oCGPdBU8X0+fcVDLkZ9oLM2HcI
         TPJ+IV9RT/Zn7DPQk6r3OB9ictf328XxxpvR+J5sFxW2wdYx2L7cmEqairGTj32TI5P9
         7/douNjkuYIpA15ExsomVIBS9ZaZQhYfx2JIlNrQS0G942zC8NM5cVXMphy+VlDqs1Pu
         viDO9yO0jlIzpmOxRJ+zf5oTlky9j1yFOGJasCNQpDeAz/U0h/BpmjOIqxRVUHBJcLI1
         WVUh64iJQIwCSVC0FIVM1lnyJcgP+NGaE1JSygExsZ75QnOkh+I02oJ9t/XxCNnkAo6/
         f3eg==
X-Gm-Message-State: AOAM532pwW/3BQ9dCxnsKMn1MPCkd1nWrMLsoD/XDKHynW7sK/pUMW5f
        I1t/Md0VwfKW55/DmJgByc4=
X-Google-Smtp-Source: ABdhPJzdBKB8PVivjWU9aYfFM7cexcYr0zPjoXaUYZVlJacYK4VivKHp35AgFKpOeE8q1gELBALkvw==
X-Received: by 2002:a63:7f50:: with SMTP id p16mr9954049pgn.451.1600068612069;
        Mon, 14 Sep 2020 00:30:12 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:11 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 05/20] liquidio: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:24 +0530
Message-Id: <20200914072939.803280-6-allen.lkml@gmail.com>
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
 drivers/net/ethernet/cavium/liquidio/lio_main.c    | 12 ++++++------
 drivers/net/ethernet/cavium/liquidio/octeon_main.h |  1 +
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |  8 ++++----
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   | 10 ++++------
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |  4 ++--
 drivers/net/ethernet/cavium/thunder/nicvf_queues.h |  2 +-
 6 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 8e0ed01e7f03..9eac0d43b58d 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -161,13 +161,13 @@ static int liquidio_set_vf_link_state(struct net_device *netdev, int vfidx,
 static struct handshake handshake[MAX_OCTEON_DEVICES];
 static struct completion first_stage;
 
-static void octeon_droq_bh(unsigned long pdev)
+static void octeon_droq_bh(struct tasklet_struct *t)
 {
 	int q_no;
 	int reschedule = 0;
-	struct octeon_device *oct = (struct octeon_device *)pdev;
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = from_tasklet(oct_priv, t,
+							  droq_tasklet);
+	struct octeon_device *oct = oct_priv->dev;
 
 	for (q_no = 0; q_no < MAX_OCTEON_OUTPUT_QUEUES(oct); q_no++) {
 		if (!(oct->io_qmask.oq & BIT_ULL(q_no)))
@@ -4193,8 +4193,7 @@ static int octeon_device_init(struct octeon_device *octeon_dev)
 
 	/* Initialize the tasklet that handles output queue packet processing.*/
 	dev_dbg(&octeon_dev->pci_dev->dev, "Initializing droq tasklet\n");
-	tasklet_init(&oct_priv->droq_tasklet, octeon_droq_bh,
-		     (unsigned long)octeon_dev);
+	tasklet_setup(&oct_priv->droq_tasklet, octeon_droq_bh);
 
 	/* Setup the interrupt handler and record the INT SUM register address
 	 */
@@ -4298,6 +4297,7 @@ static int octeon_device_init(struct octeon_device *octeon_dev)
 	complete(&handshake[octeon_dev->octeon_id].init);
 
 	atomic_set(&octeon_dev->status, OCT_DEV_HOST_OK);
+	oct_priv->dev = octeon_dev;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_main.h b/drivers/net/ethernet/cavium/liquidio/octeon_main.h
index 073d0647b439..5b4cb725f60f 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_main.h
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_main.h
@@ -39,6 +39,7 @@ struct octeon_device_priv {
 	/** Tasklet structures for this device. */
 	struct tasklet_struct droq_tasklet;
 	unsigned long napi_mask;
+	struct octeon_device *dev;
 };
 
 /** This structure is used by NIC driver to store information required
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 3e17ce0d2314..e9d6a5b61046 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -315,9 +315,9 @@ static void octeon_mgmt_clean_tx_buffers(struct octeon_mgmt *p)
 		netif_wake_queue(p->netdev);
 }
 
-static void octeon_mgmt_clean_tx_tasklet(unsigned long arg)
+static void octeon_mgmt_clean_tx_tasklet(struct tasklet_struct *t)
 {
-	struct octeon_mgmt *p = (struct octeon_mgmt *)arg;
+	struct octeon_mgmt *p = from_tasklet(p, t, tx_clean_tasklet);
 	octeon_mgmt_clean_tx_buffers(p);
 	octeon_mgmt_enable_tx_irq(p);
 }
@@ -1489,8 +1489,8 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
 
 	skb_queue_head_init(&p->tx_list);
 	skb_queue_head_init(&p->rx_list);
-	tasklet_init(&p->tx_clean_tasklet,
-		     octeon_mgmt_clean_tx_tasklet, (unsigned long)p);
+	tasklet_setup(&p->tx_clean_tasklet,
+		      octeon_mgmt_clean_tx_tasklet);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 063e560d9c1b..0a94c396173b 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -985,9 +985,9 @@ static int nicvf_poll(struct napi_struct *napi, int budget)
  *
  * As of now only CQ errors are handled
  */
-static void nicvf_handle_qs_err(unsigned long data)
+static void nicvf_handle_qs_err(struct tasklet_struct *t)
 {
-	struct nicvf *nic = (struct nicvf *)data;
+	struct nicvf *nic = from_tasklet(nic, t, qs_err_task);
 	struct queue_set *qs = nic->qs;
 	int qidx;
 	u64 status;
@@ -1493,12 +1493,10 @@ int nicvf_open(struct net_device *netdev)
 	}
 
 	/* Init tasklet for handling Qset err interrupt */
-	tasklet_init(&nic->qs_err_task, nicvf_handle_qs_err,
-		     (unsigned long)nic);
+	tasklet_setup(&nic->qs_err_task, nicvf_handle_qs_err);
 
 	/* Init RBDR tasklet which will refill RBDR */
-	tasklet_init(&nic->rbdr_task, nicvf_rbdr_task,
-		     (unsigned long)nic);
+	tasklet_setup(&nic->rbdr_task, nicvf_rbdr_task);
 	INIT_DELAYED_WORK(&nic->rbdr_work, nicvf_rbdr_work);
 
 	/* Configure CPI alorithm */
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index a45223f0cca5..7a141ce32e86 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -460,9 +460,9 @@ void nicvf_rbdr_work(struct work_struct *work)
 }
 
 /* In Softirq context, alloc rcv buffers in atomic mode */
-void nicvf_rbdr_task(unsigned long data)
+void nicvf_rbdr_task(struct tasklet_struct *t)
 {
-	struct nicvf *nic = (struct nicvf *)data;
+	struct nicvf *nic = from_tasklet(nic, t, rbdr_task);
 
 	nicvf_refill_rbdr(nic, GFP_ATOMIC);
 	if (nic->rb_alloc_fail) {
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.h b/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
index 2460451fc48f..8453defc296c 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
@@ -348,7 +348,7 @@ void nicvf_xdp_sq_doorbell(struct nicvf *nic, struct snd_queue *sq, int sq_num);
 
 struct sk_buff *nicvf_get_rcv_skb(struct nicvf *nic,
 				  struct cqe_rx_t *cqe_rx, bool xdp);
-void nicvf_rbdr_task(unsigned long data);
+void nicvf_rbdr_task(struct tasklet_struct *t);
 void nicvf_rbdr_work(struct work_struct *work);
 
 void nicvf_enable_intr(struct nicvf *nic, int int_type, int q_idx);
-- 
2.25.1

