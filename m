Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6904F246027
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgHQI3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgHQIZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:25:24 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DC7C061388;
        Mon, 17 Aug 2020 01:25:24 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s14so1163851plp.4;
        Mon, 17 Aug 2020 01:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YNvMy4AuY+7swgSlQS3LYVsoHEcImnFolbz565rcKCo=;
        b=gp0tN+rAx/ViPmdFY3zUwZzTzj/Mg191vxLR90RxlqxOVPK45tXw3AbH1absvhOybR
         L6XttLKa2rjCShl6MqYQ44QfUdD3CVHD/k57/uefx7mFbw+dvycMW2owDft3AzCYyaXg
         Y1BmBIF3uILRsHaMGOz6on8xFypoYQ+YpP9K7zS9WIdsZr2rdHgI+e3rRrY/Y1ehFs4z
         YLfJwdzquI3XniXWrq0BcbCg8tEUFTyHrJPXLn3HnBveGGnmRIaVf9eeW9Dea/WmD2Mg
         zUc8GkJfzCMUzMW2uxsTdDJiiIf52wovdrIoBeC0iJpmdGWJJbAGwIplKpTw7jseeePb
         MyVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YNvMy4AuY+7swgSlQS3LYVsoHEcImnFolbz565rcKCo=;
        b=XI8vejuvSaBrM6ivB/n9RK8AfZqN7e+fTvSEA/TtfCjpV1YeQtzSbItVjJu6NaAjg3
         On8ef1AySMdCnqvwqZeB0TLJr5RKk/Dj0e8RIjXk4irx8MzXUiPggIN1FPHFlBNJAdRG
         h4S0fJY/rtqpRIk98T9WJ+sxtTrjIsQ6e07ysRUDN5+yLXaTL6nvH4K+YY7GdWYsTfxm
         Ylm0HQr0wJV1thlt1rsKlnh1tksDcX2Svo9HWWMu1Vw9HFCKmsZMGrYMscODBsVxv629
         k8/g8U1mn8JziVfRWVFMwBZaBYwchf2VndHAd/gtUUktiB+nu723iloiiapzGOtCKpkd
         ygFw==
X-Gm-Message-State: AOAM532Qe2Uewhu8V7Tgr0W+pIyzWqeOK5beEnxTNhv0XymOSyQGQfwa
        Hd5d94zqOj2CufcKjiYYm04=
X-Google-Smtp-Source: ABdhPJzHbNppt+UgUbbnFLVZ8W8+Njht8c/Lw3IR0qTaF2iala6YGQd/m/DGKcMclr2bZnj1397x2A==
X-Received: by 2002:a17:90b:11c4:: with SMTP id gv4mr11263497pjb.198.1597652724297;
        Mon, 17 Aug 2020 01:25:24 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:25:23 -0700 (PDT)
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
Subject: [PATCH 05/20] ethernet: cavium: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:19 +0530
Message-Id: <20200817082434.21176-7-allen.lkml@gmail.com>
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
 drivers/net/ethernet/cavium/liquidio/lio_main.c    | 12 ++++++------
 drivers/net/ethernet/cavium/liquidio/octeon_main.h |  1 +
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |  8 ++++----
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   | 10 ++++------
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |  4 ++--
 drivers/net/ethernet/cavium/thunder/nicvf_queues.h |  2 +-
 6 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index e73bc211779a..41c5f4c6ca22 100644
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
@@ -4194,8 +4194,7 @@ static int octeon_device_init(struct octeon_device *octeon_dev)
 
 	/* Initialize the tasklet that handles output queue packet processing.*/
 	dev_dbg(&octeon_dev->pci_dev->dev, "Initializing droq tasklet\n");
-	tasklet_init(&oct_priv->droq_tasklet, octeon_droq_bh,
-		     (unsigned long)octeon_dev);
+	tasklet_setup(&oct_priv->droq_tasklet, octeon_droq_bh);
 
 	/* Setup the interrupt handler and record the INT SUM register address
 	 */
@@ -4299,6 +4298,7 @@ static int octeon_device_init(struct octeon_device *octeon_dev)
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
index 3e17ce0d2314..c745ace07fc3 100644
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
+		     octeon_mgmt_clean_tx_tasklet);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index c1378b5c780c..11112b58c88f 100644
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
2.17.1

