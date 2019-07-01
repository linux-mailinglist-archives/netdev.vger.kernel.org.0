Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8205C5CC
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 00:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfGAW61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 18:58:27 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:45409 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGAW61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 18:58:27 -0400
Received: by mail-pl1-f202.google.com with SMTP id y9so7967306plp.12
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 15:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RQssbPPo8K9o6Moopq/35SaFuYpJqhs8PFlS8iMoCE8=;
        b=giZbPy6WogPTe+D8pqL6jz8Huy15O8jQSRNpkvd1te3lK50Ri0DbYahFl5DxrTSlOZ
         iLSgOAJKFA9PK9lEoOpLho4uPDYMC1tbXJLKiZmAq44R+ESf3JPrrIA2UtjIfmjYTIL3
         bdM9UIB9J2IgS3//nTSOY2tlAN+Ay3SkuGX2dAdC1gpDYFoNP27i7pGw4MHy6ipUhHP3
         CLFgBjn/98sFd5s5+ohC/jCrtOmZi9ksQAsUXP9HY/u3koznf0PllxCC+7DOem0ZBYAg
         DxFXKSoiVIVmE/1kniv6yeliZjUlp5uUIkh0tR9eYq4LE6KInIrygXlVEsUO/F/V1d9l
         VRng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RQssbPPo8K9o6Moopq/35SaFuYpJqhs8PFlS8iMoCE8=;
        b=DZBq+7WHBlivzN1fInhSiLpoMjcL8Q1ZFAmHM3Q6Cx2hvPPjMZrsc7lCkJwDxyyysd
         XApoN6JNEdmI5cG2OYdZ4ux1U5BE183YIYI9wk93BqI8CA3oiHq2IQ7i7uzWczfGXZOl
         BDingLy1bz8IXAeB5D/KUtW9/riE8ZDzrCv7aeWcPqMNKuHWLeGcU1onGp6zfCDk6qWz
         cWbud01k9FrL9LaUwXUTfPzJLfg2kx2UkJ098On+8b7j4C8JDVbw28F665ialkzYODAd
         vkXK9DrXTC4XPaYsjwAwDSAFlsbPw5qWbjLi02W7CSNkoI6lNvs7qCv11/amrs3qxri0
         pB8A==
X-Gm-Message-State: APjAAAU70Kfq8tGqvPJUQceweZHngEFcDNc3axTZtZ+m1VhYC/1bA8WV
        n6PmNni24s4u7Xb9c8r4AaJjNyWwAXr65h7gmpEaN6EwM+BRSRiK7qwINsuUUoeRjrFhdn+ZBv9
        9eOfFjjG5HlJpFWfsxifdeXflF0rPvNv9Ek0LNkEZB8WrEEed4+xbRZ9IkT1Rqg==
X-Google-Smtp-Source: APXvYqy1jQLiIufBXXg1bRCMbQEXqvhe9VY9M/0rrI3g7XxplKpa0p7UwjQKIH1hEQEIWknsFnNIOuQ3XTs=
X-Received: by 2002:a63:4f65:: with SMTP id p37mr26826809pgl.327.1562021904878;
 Mon, 01 Jul 2019 15:58:24 -0700 (PDT)
Date:   Mon,  1 Jul 2019 15:57:54 -0700
In-Reply-To: <20190701225755.209250-1-csully@google.com>
Message-Id: <20190701225755.209250-4-csully@google.com>
Mime-Version: 1.0
References: <20190701225755.209250-1-csully@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net-next v4 3/4] gve: Add workqueue and reset support
From:   Catherine Sullivan <csully@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the workqueue to handle management interrupts and
support for resets.

Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Jon Olson <jonolson@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Luigi Rizzo <lrizzo@google.com>
---
 .../networking/device_drivers/google/gve.rst  |  11 +
 drivers/net/ethernet/google/gve/gve.h         |  62 ++++++
 drivers/net/ethernet/google/gve/gve_main.c    | 190 +++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_rx.c      |   5 +-
 4 files changed, 260 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/device_drivers/google/gve.rst b/Documentation/networking/device_drivers/google/gve.rst
index df8974fb3270..793693cef6e3 100644
--- a/Documentation/networking/device_drivers/google/gve.rst
+++ b/Documentation/networking/device_drivers/google/gve.rst
@@ -40,6 +40,8 @@ The driver interacts with the device in the following ways:
     - See gve_register.h for more detail
  - Admin Queue
     - See description below
+ - Reset
+    - At any time the device can be reset
  - Interrupts
     - See supported interrupts below
  - Transmit and Receive Queues
@@ -69,6 +71,12 @@ the following (with proper locking):
 The device will update the status field in each AQ command reported as
 executed through the ADMIN_QUEUE_EVENT_COUNTER register.
 
+Device Resets
+-------------
+A device reset is triggered by writing 0x0 to the AQ PFN register.
+This causes the device to release all resources allocated by the
+driver, including the AQ itself.
+
 Interrupts
 ----------
 The following interrupts are supported by the driver:
@@ -78,6 +86,9 @@ Management Interrupt
 The management interrupt is used by the device to tell the driver to
 look at the GVE_DEVICE_STATUS register.
 
+The handler for the management irq simply queues the service task in
+the workqueue to check the register and acks the irq.
+
 Notification Block Interrupts
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 The notification block interrupts are used to tell the driver to poll
diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 110ae46adc69..7960d5532078 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -205,9 +205,18 @@ struct gve_priv {
 	u32 adminq_mask; /* masks prod_cnt to adminq size */
 	u32 adminq_prod_cnt; /* free-running count of AQ cmds executed */
 
+	struct workqueue_struct *gve_wq;
+	struct work_struct service_task;
+	unsigned long service_task_flags;
 	unsigned long state_flags;
 };
 
+enum gve_service_task_flags {
+	GVE_PRIV_FLAGS_DO_RESET			= BIT(1),
+	GVE_PRIV_FLAGS_RESET_IN_PROGRESS	= BIT(2),
+	GVE_PRIV_FLAGS_PROBE_IN_PROGRESS	= BIT(3),
+};
+
 enum gve_state_flags {
 	GVE_PRIV_FLAGS_ADMIN_QUEUE_OK		= BIT(1),
 	GVE_PRIV_FLAGS_DEVICE_RESOURCES_OK	= BIT(2),
@@ -215,6 +224,53 @@ enum gve_state_flags {
 	GVE_PRIV_FLAGS_NAPI_ENABLED		= BIT(4),
 };
 
+static inline bool gve_get_do_reset(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_DO_RESET, &priv->service_task_flags);
+}
+
+static inline void gve_set_do_reset(struct gve_priv *priv)
+{
+	set_bit(GVE_PRIV_FLAGS_DO_RESET, &priv->service_task_flags);
+}
+
+static inline void gve_clear_do_reset(struct gve_priv *priv)
+{
+	clear_bit(GVE_PRIV_FLAGS_DO_RESET, &priv->service_task_flags);
+}
+
+static inline bool gve_get_reset_in_progress(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_RESET_IN_PROGRESS,
+			&priv->service_task_flags);
+}
+
+static inline void gve_set_reset_in_progress(struct gve_priv *priv)
+{
+	set_bit(GVE_PRIV_FLAGS_RESET_IN_PROGRESS, &priv->service_task_flags);
+}
+
+static inline void gve_clear_reset_in_progress(struct gve_priv *priv)
+{
+	clear_bit(GVE_PRIV_FLAGS_RESET_IN_PROGRESS, &priv->service_task_flags);
+}
+
+static inline bool gve_get_probe_in_progress(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_PROBE_IN_PROGRESS,
+			&priv->service_task_flags);
+}
+
+static inline void gve_set_probe_in_progress(struct gve_priv *priv)
+{
+	set_bit(GVE_PRIV_FLAGS_PROBE_IN_PROGRESS, &priv->service_task_flags);
+}
+
+static inline void gve_clear_probe_in_progress(struct gve_priv *priv)
+{
+	clear_bit(GVE_PRIV_FLAGS_PROBE_IN_PROGRESS, &priv->service_task_flags);
+}
+
 static inline bool gve_get_admin_queue_ok(struct gve_priv *priv)
 {
 	return test_bit(GVE_PRIV_FLAGS_ADMIN_QUEUE_OK, &priv->state_flags);
@@ -390,4 +446,10 @@ int gve_rx_alloc_rings(struct gve_priv *priv);
 void gve_rx_free_rings(struct gve_priv *priv);
 bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 		       netdev_features_t feat);
+/* Reset */
+void gve_schedule_reset(struct gve_priv *priv);
+int gve_reset(struct gve_priv *priv, bool attempt_teardown);
+int gve_adjust_queues(struct gve_priv *priv,
+		      struct gve_queue_config new_rx_config,
+		      struct gve_queue_config new_tx_config);
 #endif /* _GVE_H_ */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 44462dce0254..126d6533b965 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -11,6 +11,7 @@
 #include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
+#include <linux/workqueue.h>
 #include <net/sch_generic.h>
 #include "gve.h"
 #include "gve_adminq.h"
@@ -77,6 +78,9 @@ static void gve_free_counter_array(struct gve_priv *priv)
 
 static irqreturn_t gve_mgmnt_intr(int irq, void *arg)
 {
+	struct gve_priv *priv = arg;
+
+	queue_work(priv->gve_wq, &priv->service_task);
 	return IRQ_HANDLED;
 }
 
@@ -284,6 +288,8 @@ static int gve_setup_device_resources(struct gve_priv *priv)
 	return err;
 }
 
+static void gve_trigger_reset(struct gve_priv *priv);
+
 static void gve_teardown_device_resources(struct gve_priv *priv)
 {
 	int err;
@@ -295,7 +301,7 @@ static void gve_teardown_device_resources(struct gve_priv *priv)
 			dev_err(&priv->pdev->dev,
 				"Could not deconfigure device resources: err=%d\n",
 				err);
-			return;
+			gve_trigger_reset(priv);
 		}
 	}
 	gve_free_counter_array(priv);
@@ -330,6 +336,9 @@ static int gve_register_qpls(struct gve_priv *priv)
 			netif_err(priv, drv, priv->dev,
 				  "failed to register queue page list %d\n",
 				  priv->qpls[i].id);
+			/* This failure will trigger a reset - no need to clean
+			 * up
+			 */
 			return err;
 		}
 	}
@@ -344,6 +353,7 @@ static int gve_unregister_qpls(struct gve_priv *priv)
 
 	for (i = 0; i < num_qpls; i++) {
 		err = gve_adminq_unregister_page_list(priv, priv->qpls[i].id);
+		/* This failure will trigger a reset - no need to clean up */
 		if (err) {
 			netif_err(priv, drv, priv->dev,
 				  "Failed to unregister queue page list %d\n",
@@ -364,6 +374,9 @@ static int gve_create_rings(struct gve_priv *priv)
 		if (err) {
 			netif_err(priv, drv, priv->dev, "failed to create tx queue %d\n",
 				  i);
+			/* This failure will trigger a reset - no need to clean
+			 * up
+			 */
 			return err;
 		}
 		netif_dbg(priv, drv, priv->dev, "created tx queue %d\n", i);
@@ -373,6 +386,9 @@ static int gve_create_rings(struct gve_priv *priv)
 		if (err) {
 			netif_err(priv, drv, priv->dev, "failed to create rx queue %d\n",
 				  i);
+			/* This failure will trigger a reset - no need to clean
+			 * up
+			 */
 			return err;
 		}
 		/* Rx data ring has been prefilled with packet buffers at
@@ -448,6 +464,9 @@ static int gve_destroy_rings(struct gve_priv *priv)
 			netif_err(priv, drv, priv->dev,
 				  "failed to destroy tx queue %d\n",
 				  i);
+			/* This failure will trigger a reset - no need to clean
+			 * up
+			 */
 			return err;
 		}
 		netif_dbg(priv, drv, priv->dev, "destroyed tx queue %d\n", i);
@@ -458,6 +477,9 @@ static int gve_destroy_rings(struct gve_priv *priv)
 			netif_err(priv, drv, priv->dev,
 				  "failed to destroy rx queue %d\n",
 				  i);
+			/* This failure will trigger a reset - no need to clean
+			 * up
+			 */
 			return err;
 		}
 		netif_dbg(priv, drv, priv->dev, "destroyed rx queue %d\n", i);
@@ -626,6 +648,18 @@ static void gve_free_qpls(struct gve_priv *priv)
 	kfree(priv->qpls);
 }
 
+/* Use this to schedule a reset when the device is capable of continuing
+ * to handle other requests in its current state. If it is not, do a reset
+ * in thread instead.
+ */
+void gve_schedule_reset(struct gve_priv *priv)
+{
+	gve_set_do_reset(priv);
+	queue_work(priv->gve_wq, &priv->service_task);
+}
+
+static void gve_reset_and_teardown(struct gve_priv *priv, bool was_up);
+static int gve_reset_recovery(struct gve_priv *priv, bool was_up);
 static void gve_turndown(struct gve_priv *priv);
 static void gve_turnup(struct gve_priv *priv);
 
@@ -650,10 +684,10 @@ static int gve_open(struct net_device *dev)
 
 	err = gve_register_qpls(priv);
 	if (err)
-		return err;
+		goto reset;
 	err = gve_create_rings(priv);
 	if (err)
-		return err;
+		goto reset;
 	gve_set_device_rings_ok(priv);
 
 	gve_turnup(priv);
@@ -665,6 +699,19 @@ static int gve_open(struct net_device *dev)
 free_qpls:
 	gve_free_qpls(priv);
 	return err;
+
+reset:
+	/* This must have been called from a reset due to the rtnl lock
+	 * so just return at this point.
+	 */
+	if (gve_get_reset_in_progress(priv))
+		return err;
+	/* Otherwise reset before returning */
+	gve_reset_and_teardown(priv, true);
+	/* if this fails there is nothing we can do so just ignore the return */
+	gve_reset_recovery(priv, false);
+	/* return the original error */
+	return err;
 }
 
 static int gve_close(struct net_device *dev)
@@ -677,16 +724,26 @@ static int gve_close(struct net_device *dev)
 		gve_turndown(priv);
 		err = gve_destroy_rings(priv);
 		if (err)
-			return err;
+			goto err;
 		err = gve_unregister_qpls(priv);
 		if (err)
-			return err;
+			goto err;
 		gve_clear_device_rings_ok(priv);
 	}
 
 	gve_free_rings(priv);
 	gve_free_qpls(priv);
 	return 0;
+
+err:
+	/* This must have been called from a reset due to the rtnl lock
+	 * so just return at this point.
+	 */
+	if (gve_get_reset_in_progress(priv))
+		return err;
+	/* Otherwise reset before returning */
+	gve_reset_and_teardown(priv, true);
+	return gve_reset_recovery(priv, false);
 }
 
 static void gve_turndown(struct gve_priv *priv)
@@ -749,6 +806,7 @@ static void gve_tx_timeout(struct net_device *dev)
 {
 	struct gve_priv *priv = netdev_priv(dev);
 
+	gve_schedule_reset(priv);
 	priv->tx_timeo_cnt++;
 }
 
@@ -760,6 +818,42 @@ static const struct net_device_ops gve_netdev_ops = {
 	.ndo_tx_timeout         =       gve_tx_timeout,
 };
 
+static void gve_handle_status(struct gve_priv *priv, u32 status)
+{
+	if (GVE_DEVICE_STATUS_RESET_MASK & status) {
+		dev_info(&priv->pdev->dev, "Device requested reset.\n");
+		gve_set_do_reset(priv);
+	}
+}
+
+static void gve_handle_reset(struct gve_priv *priv)
+{
+	/* A service task will be scheduled at the end of probe to catch any
+	 * resets that need to happen, and we don't want to reset until
+	 * probe is done.
+	 */
+	if (gve_get_probe_in_progress(priv))
+		return;
+
+	if (gve_get_do_reset(priv)) {
+		rtnl_lock();
+		gve_reset(priv, false);
+		rtnl_unlock();
+	}
+}
+
+/* Handle NIC status register changes and reset requests */
+static void gve_service_task(struct work_struct *work)
+{
+	struct gve_priv *priv = container_of(work, struct gve_priv,
+					     service_task);
+
+	gve_handle_status(priv,
+			  ioread32be(&priv->reg_bar0->device_status));
+
+	gve_handle_reset(priv);
+}
+
 static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 {
 	int num_ntfy;
@@ -847,6 +941,72 @@ static void gve_teardown_priv_resources(struct gve_priv *priv)
 	gve_adminq_free(&priv->pdev->dev, priv);
 }
 
+static void gve_trigger_reset(struct gve_priv *priv)
+{
+	/* Reset the device by releasing the AQ */
+	gve_adminq_release(priv);
+}
+
+static void gve_reset_and_teardown(struct gve_priv *priv, bool was_up)
+{
+	gve_trigger_reset(priv);
+	/* With the reset having already happened, close cannot fail */
+	if (was_up)
+		gve_close(priv->dev);
+	gve_teardown_priv_resources(priv);
+}
+
+static int gve_reset_recovery(struct gve_priv *priv, bool was_up)
+{
+	int err;
+
+	err = gve_init_priv(priv, true);
+	if (err)
+		goto err;
+	if (was_up) {
+		err = gve_open(priv->dev);
+		if (err)
+			goto err;
+	}
+	return 0;
+err:
+	dev_err(&priv->pdev->dev, "Reset failed! !!! DISABLING ALL QUEUES !!!\n");
+	gve_turndown(priv);
+	return err;
+}
+
+int gve_reset(struct gve_priv *priv, bool attempt_teardown)
+{
+	bool was_up = netif_carrier_ok(priv->dev);
+	int err;
+
+	dev_info(&priv->pdev->dev, "Performing reset\n");
+	gve_clear_do_reset(priv);
+	gve_set_reset_in_progress(priv);
+	/* If we aren't attempting to teardown normally, just go turndown and
+	 * reset right away.
+	 */
+	if (!attempt_teardown) {
+		gve_turndown(priv);
+		gve_reset_and_teardown(priv, was_up);
+	} else {
+		/* Otherwise attempt to close normally */
+		if (was_up) {
+			err = gve_close(priv->dev);
+			/* If that fails reset as we did above */
+			if (err)
+				gve_reset_and_teardown(priv, was_up);
+		}
+		/* Clean up any remaining resources */
+		gve_teardown_priv_resources(priv);
+	}
+
+	/* Set it all back up */
+	err = gve_reset_recovery(priv, was_up);
+	gve_clear_reset_in_progress(priv);
+	return err;
+}
+
 static void gve_write_version(u8 __iomem *driver_version_register)
 {
 	const char *c = gve_version_prefix;
@@ -943,21 +1103,36 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->msg_enable = DEFAULT_MSG_LEVEL;
 	priv->reg_bar0 = reg_bar;
 	priv->db_bar2 = db_bar;
+	priv->service_task_flags = 0x0;
 	priv->state_flags = 0x0;
+
+	gve_set_probe_in_progress(priv);
+	priv->gve_wq = alloc_ordered_workqueue("gve", 0);
+	if (!priv->gve_wq) {
+		dev_err(&pdev->dev, "Could not allocate workqueue");
+		err = -ENOMEM;
+		goto abort_with_netdev;
+	}
+	INIT_WORK(&priv->service_task, gve_service_task);
 	priv->tx_cfg.max_queues = max_tx_queues;
 	priv->rx_cfg.max_queues = max_rx_queues;
 
 	err = gve_init_priv(priv, false);
 	if (err)
-		goto abort_with_netdev;
+		goto abort_with_wq;
 
 	err = register_netdev(dev);
 	if (err)
-		goto abort_with_netdev;
+		goto abort_with_wq;
 
 	dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
+	gve_clear_probe_in_progress(priv);
+	queue_work(priv->gve_wq, &priv->service_task);
 	return 0;
 
+abort_with_wq:
+	destroy_workqueue(priv->gve_wq);
+
 abort_with_netdev:
 	free_netdev(dev);
 
@@ -985,6 +1160,7 @@ static void gve_remove(struct pci_dev *pdev)
 
 	unregister_netdev(netdev);
 	gve_teardown_priv_resources(priv);
+	destroy_workqueue(priv->gve_wq);
 	free_netdev(netdev);
 	pci_iounmap(pdev, db_bar);
 	pci_iounmap(pdev, reg_bar);
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 2254857eac50..84e0ecce14c4 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -334,6 +334,9 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 #endif
 
 have_skb:
+	/* We didn't manage to allocate an skb but we haven't had any
+	 * reset worthy failures.
+	 */
 	if (!skb)
 		return true;
 
@@ -399,7 +402,7 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 			   rx->desc.seqno);
 		bytes += be16_to_cpu(desc->len) - GVE_RX_PAD;
 		if (!gve_rx(rx, desc, feat))
-			return false;
+			gve_schedule_reset(priv);
 		cnt++;
 		idx = cnt & rx->desc.mask;
 		desc = rx->desc.desc_ring + idx;
-- 
2.22.0.410.gd8fdbe21b5-goog

