Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E921147671F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhLPArX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhLPArW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 19:47:22 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5A5C06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:21 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t28-20020a63955c000000b0033f3b16a931so554811pgn.4
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=s7W2tKKF1xH65WC9882sxiN25NTOC3PTlid+qix2NCM=;
        b=HxTu0TF74jGLYISPCAHoJ7fHftpxT8kfkcrVLfB7NDzpjzdWwgZ9wd3nqOzbcM6Ell
         EAKLmhIJDE49l5/jwaC74MzBmFeu7xqdHXUsUoEoALC7pLH3cWS1O5YBUhs+kaMMrjoz
         0UzPoUOdAOPMBioOBPenG1uVgyXSwocnEWF73dVduEKc33thxO1Zwj3Km6+OuwG2BDPb
         dKYsrqAPQqD51Y+2WFdp/6dk0zeqAEqSLna9Klo4OahocbEKPDgT3PElteXvKcK6Akh7
         JHTlDm934MvyNoUHoYP/KKsFZMSUjPJ3rxOHyTycxxHutvSwcXhqgXQOSV38oSDwSvRY
         rScQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s7W2tKKF1xH65WC9882sxiN25NTOC3PTlid+qix2NCM=;
        b=mqZ3WbwSiX5YGFBBQdx8o8x0fO3luYIMrzNGS/hBPs9+ZAM9UcmSjDgARmOF4hYoh4
         qNf1SWigANiIZmlrRrdJFC+V7ZZ0Sk5AyP3116eeFicPsQYrhO0Z2PU8jw5lxX4xoRmU
         rvmiga2KU6FkaPOK4lG30UaC94cmOAgrKwP/AsI95rehBa/cKbF5mH0liph9BsKe54hz
         X1GUX3CkhGygA45DoauVo9pFewjykIjuSNS8Cd2rw+PFk2rbSR38pXboog6slnQudwSQ
         E/oXntwQBH387WYS3GHNaco8PSePQoYiWqxc+FF5I0naoJBqpqGluw7koXikyx+AR4nB
         764A==
X-Gm-Message-State: AOAM530gk9oT9l1lUjzHVTIUICDPYgySBYyfv98dupYb9DqW41FamcQn
        tgKSbjuCpzG2w9UeDBuDUXmsBRaiW0G6pJruHvwLqhnkQb9JSEo5MkUmn0eN7hYRp4YC9vgNuR3
        qW20NtYmSY1tAhIID1foWB0BR8s0JHbD41d1sEkpIB5bvVQ2vBZVvn05O8L3+2gOVnXE=
X-Google-Smtp-Source: ABdhPJzeq0FmvHfeDNn1s9dNDBJ8t4l558IMFxPGjh+fzeM4PZeL/8rmK8ADwR4Bnc3GervtS2MRTSlbfuQzwg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:964d:9084:bbdd:97a9])
 (user=jeroendb job=sendgmr) by 2002:a17:90a:3046:: with SMTP id
 q6mr2234216pjl.208.1639615641033; Wed, 15 Dec 2021 16:47:21 -0800 (PST)
Date:   Wed, 15 Dec 2021 16:46:52 -0800
In-Reply-To: <20211216004652.1021911-1-jeroendb@google.com>
Message-Id: <20211216004652.1021911-9-jeroendb@google.com>
Mime-Version: 1.0
References: <20211216004652.1021911-1-jeroendb@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH net-next 8/8] gve: Add tx|rx-coalesce-usec for DQO
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Tao Liu <xliutaox@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Liu <xliutaox@google.com>

Adding ethtool support for changing rx-coalesce-usec and tx-coalesce-usec
when using the DQO queue format.

Signed-off-by: Tao Liu <xliutaox@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  4 ++
 drivers/net/ethernet/google/gve/gve_dqo.h     | 22 +++++--
 drivers/net/ethernet/google/gve/gve_ethtool.c | 61 +++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_main.c    | 15 +++--
 4 files changed, 91 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 950dff787269..5f5d4f7aa813 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -584,6 +584,10 @@ struct gve_priv {
 	int data_buffer_size_dqo;
 
 	enum gve_queue_format queue_format;
+
+	/* Interrupt coalescing settings */
+	u32 tx_coalesce_usecs;
+	u32 rx_coalesce_usecs;
 };
 
 enum gve_service_task_flags_bit {
diff --git a/drivers/net/ethernet/google/gve/gve_dqo.h b/drivers/net/ethernet/google/gve/gve_dqo.h
index b2e2fb015693..1eb4d5fd8561 100644
--- a/drivers/net/ethernet/google/gve/gve_dqo.h
+++ b/drivers/net/ethernet/google/gve/gve_dqo.h
@@ -18,6 +18,7 @@
 
 #define GVE_TX_IRQ_RATELIMIT_US_DQO 50
 #define GVE_RX_IRQ_RATELIMIT_US_DQO 20
+#define GVE_MAX_ITR_INTERVAL_DQO (GVE_ITR_INTERVAL_DQO_MASK * 2)
 
 /* Timeout in seconds to wait for a reinjection completion after receiving
  * its corresponding miss completion.
@@ -54,17 +55,17 @@ gve_tx_put_doorbell_dqo(const struct gve_priv *priv,
 }
 
 /* Builds register value to write to DQO IRQ doorbell to enable with specified
- * ratelimit.
+ * ITR interval.
  */
-static inline u32 gve_set_itr_ratelimit_dqo(u32 ratelimit_us)
+static inline u32 gve_setup_itr_interval_dqo(u32 interval_us)
 {
 	u32 result = GVE_ITR_ENABLE_BIT_DQO;
 
 	/* Interval has 2us granularity. */
-	ratelimit_us >>= 1;
+	interval_us >>= 1;
 
-	ratelimit_us &= GVE_ITR_INTERVAL_DQO_MASK;
-	result |= (ratelimit_us << GVE_ITR_INTERVAL_DQO_SHIFT);
+	interval_us &= GVE_ITR_INTERVAL_DQO_MASK;
+	result |= (interval_us << GVE_ITR_INTERVAL_DQO_SHIFT);
 
 	return result;
 }
@@ -78,4 +79,15 @@ gve_write_irq_doorbell_dqo(const struct gve_priv *priv,
 	iowrite32(val, &priv->db_bar2[index]);
 }
 
+/* Sets interrupt throttling interval and enables interrupt
+ * by writing to IRQ doorbell.
+ */
+static inline void
+gve_set_itr_coalesce_usecs_dqo(struct gve_priv *priv,
+			       struct gve_notify_block *block,
+			       u32 usecs)
+{
+	gve_write_irq_doorbell_dqo(priv, block,
+				   gve_setup_itr_interval_dqo(usecs));
+}
 #endif /* _GVE_DQO_H_ */
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index e0815bb031e9..50b384910c83 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -8,6 +8,7 @@
 #include <linux/rtnetlink.h>
 #include "gve.h"
 #include "gve_adminq.h"
+#include "gve_dqo.h"
 
 static void gve_get_drvinfo(struct net_device *netdev,
 			    struct ethtool_drvinfo *info)
@@ -540,7 +541,65 @@ static int gve_get_link_ksettings(struct net_device *netdev,
 	return err;
 }
 
+static int gve_get_coalesce(struct net_device *netdev,
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_ec,
+			    struct netlink_ext_ack *extack)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+
+	if (gve_is_gqi(priv))
+		return -EOPNOTSUPP;
+	ec->tx_coalesce_usecs = priv->tx_coalesce_usecs;
+	ec->rx_coalesce_usecs = priv->rx_coalesce_usecs;
+
+	return 0;
+}
+
+static int gve_set_coalesce(struct net_device *netdev,
+			    struct ethtool_coalesce *ec,
+			    struct kernel_ethtool_coalesce *kernel_ec,
+			    struct netlink_ext_ack *extack)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	u32 tx_usecs_orig = priv->tx_coalesce_usecs;
+	u32 rx_usecs_orig = priv->rx_coalesce_usecs;
+	int idx;
+
+	if (gve_is_gqi(priv))
+		return -EOPNOTSUPP;
+
+	if (ec->tx_coalesce_usecs > GVE_MAX_ITR_INTERVAL_DQO ||
+	    ec->rx_coalesce_usecs > GVE_MAX_ITR_INTERVAL_DQO)
+		return -EINVAL;
+	priv->tx_coalesce_usecs = ec->tx_coalesce_usecs;
+	priv->rx_coalesce_usecs = ec->rx_coalesce_usecs;
+
+	if (tx_usecs_orig != priv->tx_coalesce_usecs) {
+		for (idx = 0; idx < priv->tx_cfg.num_queues; idx++) {
+			int ntfy_idx = gve_tx_idx_to_ntfy(priv, idx);
+			struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+
+			gve_set_itr_coalesce_usecs_dqo(priv, block,
+						       priv->tx_coalesce_usecs);
+		}
+	}
+
+	if (rx_usecs_orig != priv->rx_coalesce_usecs) {
+		for (idx = 0; idx < priv->rx_cfg.num_queues; idx++) {
+			int ntfy_idx = gve_rx_idx_to_ntfy(priv, idx);
+			struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
+
+			gve_set_itr_coalesce_usecs_dqo(priv, block,
+						       priv->rx_coalesce_usecs);
+		}
+	}
+
+	return 0;
+}
+
 const struct ethtool_ops gve_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_drvinfo = gve_get_drvinfo,
 	.get_strings = gve_get_strings,
 	.get_sset_count = gve_get_sset_count,
@@ -550,6 +609,8 @@ const struct ethtool_ops gve_ethtool_ops = {
 	.set_channels = gve_set_channels,
 	.get_channels = gve_get_channels,
 	.get_link = ethtool_op_get_link,
+	.get_coalesce = gve_get_coalesce,
+	.set_coalesce = gve_set_coalesce,
 	.get_ringparam = gve_get_ringparam,
 	.reset = gve_user_reset,
 	.get_tunable = gve_get_tunable,
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index e5456187b3f2..f7f65c4bf993 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1113,9 +1113,8 @@ static void gve_turnup(struct gve_priv *priv)
 		if (gve_is_gqi(priv)) {
 			iowrite32be(0, gve_irq_doorbell(priv, block));
 		} else {
-			u32 val = gve_set_itr_ratelimit_dqo(GVE_TX_IRQ_RATELIMIT_US_DQO);
-
-			gve_write_irq_doorbell_dqo(priv, block, val);
+			gve_set_itr_coalesce_usecs_dqo(priv, block,
+						       priv->tx_coalesce_usecs);
 		}
 	}
 	for (idx = 0; idx < priv->rx_cfg.num_queues; idx++) {
@@ -1126,9 +1125,8 @@ static void gve_turnup(struct gve_priv *priv)
 		if (gve_is_gqi(priv)) {
 			iowrite32be(0, gve_irq_doorbell(priv, block));
 		} else {
-			u32 val = gve_set_itr_ratelimit_dqo(GVE_RX_IRQ_RATELIMIT_US_DQO);
-
-			gve_write_irq_doorbell_dqo(priv, block, val);
+			gve_set_itr_coalesce_usecs_dqo(priv, block,
+						       priv->rx_coalesce_usecs);
 		}
 	}
 
@@ -1425,6 +1423,11 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 	dev_info(&priv->pdev->dev, "Max TX queues %d, Max RX queues %d\n",
 		 priv->tx_cfg.max_queues, priv->rx_cfg.max_queues);
 
+	if (!gve_is_gqi(priv)) {
+		priv->tx_coalesce_usecs = GVE_TX_IRQ_RATELIMIT_US_DQO;
+		priv->rx_coalesce_usecs = GVE_RX_IRQ_RATELIMIT_US_DQO;
+	}
+
 setup_device:
 	err = gve_setup_device_resources(priv);
 	if (!err)
-- 
2.34.1.173.g76aa8bc2d0-goog

