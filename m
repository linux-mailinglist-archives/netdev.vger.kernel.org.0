Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B40B67EDF6
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjA0TH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjA0TH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:07:58 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAD1E05D
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 11:07:56 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id z10-20020a655a4a000000b004de9d84987bso2337204pgs.9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 11:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j9AjCteT5oXOliiBDsi/BtPpjWzY8Wi3XK8EjycIbYY=;
        b=n6AzdOLNRTqb4i6FyEqbFi5s6pTlhyre25ufFwx+T+VmajjxssTt0l8XCKQR/Aqecv
         t5czYE9FLkrlUSl51FMuykQ1e1GcF3m5oNdeJBZLdw2D63jbXf6XfTeNurXdbWrn/zPD
         0oTbY9zSFrSWwarkUi/JZeBmWAeeYdlF6qUJU5pVqeOuE7Omi52/PsLVpsnLgGzmyvs8
         Qzi8KLY+VRFCIgj68RifAkcwvQfGqbGSzt51gfoz1FGRmwAX8HkbYcV17zQFE/36rY2Y
         t8ertkB8APqDAym2fHdv+w+6uQ6EsF9ADBteRoCKRbbfopznDFmxuVd2dDrS3CqEW1Ev
         jKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j9AjCteT5oXOliiBDsi/BtPpjWzY8Wi3XK8EjycIbYY=;
        b=C9kFO5DsXNtE2ZZ+L8zmJFF2ARRbDUKWBiO5SK5pRPLzqyt7DaZ2f5FDgTH2YI9Ewk
         zk0YCmZFiV8DlzB8LAX6RlLO0GS8K/YjQbZ3keuUkmdFWxVmAl9uefj72hnDBjDOCQ4t
         dBqrfHRlLaSsEvq6uR2irvQx7u9ZweWjf0WLcroO254nu8aD7O7P+QMfq6Z7LnQzyet3
         emfat7WikRmnBT/dg1JDRYvIMaO6NIfi+jFLpHDiMv3CnYPdKYGrArde3hROC8vVqMDm
         kM7TDTC1A6syJJC3/Vk8m3AhW7Um85L7geQq+PX6OwDoyHWvvD9aMDlLq8RLsg0bWI0s
         Ktzg==
X-Gm-Message-State: AO0yUKU3xMYR5wf9GaiGiNOeWQo7KunfgJGxGwFaKyX5BhMEYEwT8PB6
        cUTTMxGbdy+KpuWr87MCfvXVlvIXrz+TC2v6lq3o14tRpw+0vDcvKgcQ11YxuLnKNt6tIRM8dna
        RKlhCi2lTXqVdilmwDD5jljzda81GP4kLUId+ZBNepB/ScVtpMqN3KQU4AuJY1yTcW8M=
X-Google-Smtp-Source: AK7set8IKnNvbkL5X+lizk9XC9rrApWvSt+9UUc/xXEKp4X9BleheZae0GjrYEJO3IX6PWizWkCBlbsbszCbxA==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:f20d:8b00:2281:bf9a])
 (user=jeroendb job=sendgmr) by 2002:a63:131e:0:b0:4d9:ed5e:5e99 with SMTP id
 i30-20020a63131e000000b004d9ed5e5e99mr1260832pgl.69.1674846475741; Fri, 27
 Jan 2023 11:07:55 -0800 (PST)
Date:   Fri, 27 Jan 2023 11:07:44 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230127190744.3721063-1-jeroendb@google.com>
Subject: [PATCH net-next] gve: Introduce a way to disable queue formats
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device is capable of simultaneously supporting multiple
queue formats. With this change the driver can deliberately
pick a queue format.

Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         | 30 +++++++++-
 drivers/net/ethernet/google/gve/gve_adminq.c  | 35 +++++++-----
 drivers/net/ethernet/google/gve/gve_ethtool.c | 57 ++++++++++++-------
 drivers/net/ethernet/google/gve/gve_main.c    | 26 ++++++++-
 4 files changed, 110 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 64eb0442c82f..b78b48887023 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -505,6 +505,8 @@ enum gve_queue_format {
 	GVE_DQO_RDA_FORMAT		= 0x3,
 };
 
+const char *gve_queue_format_name(enum gve_queue_format format);
+
 struct gve_priv {
 	struct net_device *dev;
 	struct gve_tx_ring *tx; /* array of tx_cfg.num_queues */
@@ -584,6 +586,7 @@ struct gve_priv {
 	u64 stats_report_len;
 	dma_addr_t stats_report_bus; /* dma address for the stats report */
 	unsigned long ethtool_flags;
+	unsigned long ethtool_formats; /* queue formats allowed */
 
 	unsigned long stats_report_timer_period;
 	struct timer_list stats_report_timer;
@@ -599,6 +602,7 @@ struct gve_priv {
 	int data_buffer_size_dqo;
 
 	enum gve_queue_format queue_format;
+	enum gve_queue_format next_queue_format;
 
 	/* Interrupt coalescing settings */
 	u32 tx_coalesce_usecs;
@@ -609,7 +613,7 @@ enum gve_service_task_flags_bit {
 	GVE_PRIV_FLAGS_DO_RESET			= 1,
 	GVE_PRIV_FLAGS_RESET_IN_PROGRESS	= 2,
 	GVE_PRIV_FLAGS_PROBE_IN_PROGRESS	= 3,
-	GVE_PRIV_FLAGS_DO_REPORT_STATS = 4,
+	GVE_PRIV_FLAGS_DO_REPORT_STATS		= 4,
 };
 
 enum gve_state_flags_bit {
@@ -621,8 +625,17 @@ enum gve_state_flags_bit {
 
 enum gve_ethtool_flags_bit {
 	GVE_PRIV_FLAGS_REPORT_STATS		= 0,
+	GVE_PRIV_FLAGS_ENABLE_DQO_RDA		= 1,
+	GVE_PRIV_FLAGS_ENABLE_GQI_RDA		= 2,
+	GVE_PRIV_FLAGS_ENABLE_GQI_QPL		= 3,
 };
 
+#define GVE_PRIV_FLAGS_MASK \
+	(BIT(GVE_PRIV_FLAGS_REPORT_STATS)	| \
+	 BIT(GVE_PRIV_FLAGS_ENABLE_DQO_RDA)	| \
+	 BIT(GVE_PRIV_FLAGS_ENABLE_GQI_RDA)	| \
+	 BIT(GVE_PRIV_FLAGS_ENABLE_GQI_QPL))
+
 static inline bool gve_get_do_reset(struct gve_priv *priv)
 {
 	return test_bit(GVE_PRIV_FLAGS_DO_RESET, &priv->service_task_flags);
@@ -756,6 +769,21 @@ static inline void gve_clear_report_stats(struct gve_priv *priv)
 	clear_bit(GVE_PRIV_FLAGS_REPORT_STATS, &priv->ethtool_flags);
 }
 
+static inline bool gve_get_enable_dqo_rda(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_ENABLE_DQO_RDA, &priv->ethtool_flags);
+}
+
+static inline bool gve_get_enable_gqi_rda(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_ENABLE_GQI_RDA, &priv->ethtool_flags);
+}
+
+static inline bool gve_get_enable_gqi_qpl(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_ENABLE_GQI_QPL, &priv->ethtool_flags);
+}
+
 /* Returns the address of the ntfy_blocks irq doorbell
  */
 static inline __be32 __iomem *gve_irq_doorbell(struct gve_priv *priv,
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 60061288ad9d..d8bf761ef133 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -59,10 +59,9 @@ void gve_parse_device_option(struct gve_priv *priv,
 				 option_length, req_feat_mask);
 			break;
 		}
-
 		dev_info(&priv->pdev->dev,
 			 "Gqi raw addressing device option enabled.\n");
-		priv->queue_format = GVE_GQI_RDA_FORMAT;
+		priv->ethtool_formats |= BIT(GVE_PRIV_FLAGS_ENABLE_GQI_RDA);
 		break;
 	case GVE_DEV_OPT_ID_GQI_RDA:
 		if (option_length < sizeof(**dev_op_gqi_rda) ||
@@ -79,6 +78,7 @@ void gve_parse_device_option(struct gve_priv *priv,
 				 GVE_DEVICE_OPTION_TOO_BIG_FMT, "GQI RDA");
 		}
 		*dev_op_gqi_rda = (void *)(option + 1);
+		priv->ethtool_formats |= BIT(GVE_PRIV_FLAGS_ENABLE_GQI_RDA);
 		break;
 	case GVE_DEV_OPT_ID_GQI_QPL:
 		if (option_length < sizeof(**dev_op_gqi_qpl) ||
@@ -95,6 +95,7 @@ void gve_parse_device_option(struct gve_priv *priv,
 				 GVE_DEVICE_OPTION_TOO_BIG_FMT, "GQI QPL");
 		}
 		*dev_op_gqi_qpl = (void *)(option + 1);
+		priv->ethtool_formats |= BIT(GVE_PRIV_FLAGS_ENABLE_GQI_QPL);
 		break;
 	case GVE_DEV_OPT_ID_DQO_RDA:
 		if (option_length < sizeof(**dev_op_dqo_rda) ||
@@ -111,6 +112,7 @@ void gve_parse_device_option(struct gve_priv *priv,
 				 GVE_DEVICE_OPTION_TOO_BIG_FMT, "DQO RDA");
 		}
 		*dev_op_dqo_rda = (void *)(option + 1);
+		priv->ethtool_formats |= BIT(GVE_PRIV_FLAGS_ENABLE_DQO_RDA);
 		break;
 	case GVE_DEV_OPT_ID_JUMBO_FRAMES:
 		if (option_length < sizeof(**dev_op_jumbo_frames) ||
@@ -737,33 +739,36 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	if (err)
 		goto free_device_descriptor;
 
+	priv->ethtool_flags = priv->ethtool_formats;
+
 	/* If the GQI_RAW_ADDRESSING option is not enabled and the queue format
 	 * is not set to GqiRda, choose the queue format in a priority order:
 	 * DqoRda, GqiRda, GqiQpl. Use GqiQpl as default.
 	 */
 	if (dev_op_dqo_rda) {
 		priv->queue_format = GVE_DQO_RDA_FORMAT;
-		dev_info(&priv->pdev->dev,
-			 "Driver is running with DQO RDA queue format.\n");
 		supported_features_mask =
 			be32_to_cpu(dev_op_dqo_rda->supported_features_mask);
 	} else if (dev_op_gqi_rda) {
 		priv->queue_format = GVE_GQI_RDA_FORMAT;
-		dev_info(&priv->pdev->dev,
-			 "Driver is running with GQI RDA queue format.\n");
 		supported_features_mask =
 			be32_to_cpu(dev_op_gqi_rda->supported_features_mask);
-	} else if (priv->queue_format == GVE_GQI_RDA_FORMAT) {
-		dev_info(&priv->pdev->dev,
-			 "Driver is running with GQI RDA queue format.\n");
-	} else {
+	} else if (dev_op_gqi_qpl) {
 		priv->queue_format = GVE_GQI_QPL_FORMAT;
-		if (dev_op_gqi_qpl)
-			supported_features_mask =
-				be32_to_cpu(dev_op_gqi_qpl->supported_features_mask);
-		dev_info(&priv->pdev->dev,
-			 "Driver is running with GQI QPL queue format.\n");
+		supported_features_mask =
+			be32_to_cpu(dev_op_gqi_qpl->supported_features_mask);
+	} else if (gve_get_enable_gqi_rda(priv)) {
+		priv->queue_format = GVE_GQI_RDA_FORMAT;
+	} else {
+		dev_err(&priv->pdev->dev, "No compatible queue formats\n");
+		err = -EINVAL;
+		goto free_device_descriptor;
 	}
+	dev_info(&priv->pdev->dev, "Driver is running with %s queue format.\n",
+		 gve_queue_format_name(priv->queue_format));
+
+	priv->next_queue_format = priv->queue_format;
+
 	if (gve_is_gqi(priv)) {
 		err = gve_set_desc_cnt(priv, descriptor);
 	} else {
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index ce574d097e28..7f682d266f0e 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -68,7 +68,7 @@ static const char gve_gstrings_adminq_stats[][ETH_GSTRING_LEN] = {
 };
 
 static const char gve_gstrings_priv_flags[][ETH_GSTRING_LEN] = {
-	"report-stats",
+	"report-stats", "enable-dqo-rda", "enable-gqi-rda", "enable-gqi-qpl",
 };
 
 #define GVE_MAIN_STATS_LEN  ARRAY_SIZE(gve_gstrings_main_stats)
@@ -490,37 +490,36 @@ static int gve_set_tunable(struct net_device *netdev,
 static u32 gve_get_priv_flags(struct net_device *netdev)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
-	u32 ret_flags = 0;
-
-	/* Only 1 flag exists currently: report-stats (BIT(O)), so set that flag. */
-	if (priv->ethtool_flags & BIT(0))
-		ret_flags |= BIT(0);
-	return ret_flags;
+	return priv->ethtool_flags & GVE_PRIV_FLAGS_MASK;
 }
 
 static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
-	u64 ori_flags, new_flags;
+	u32 ori_flags;
+	enum gve_queue_format new_format;
+
+	/* Make sure there is a queue format to use */
+	if ((priv->ethtool_formats & flags) == 0) {
+		dev_err(&priv->pdev->dev,
+			"All available queue formats disabled\n");
+		return -EINVAL;
+	}
 
 	ori_flags = READ_ONCE(priv->ethtool_flags);
-	new_flags = ori_flags;
 
-	/* Only one priv flag exists: report-stats (BIT(0))*/
-	if (flags & BIT(0))
-		new_flags |= BIT(0);
-	else
-		new_flags &= ~(BIT(0));
-	priv->ethtool_flags = new_flags;
+	priv->ethtool_flags = flags & GVE_PRIV_FLAGS_MASK;
+
 	/* start report-stats timer when user turns report stats on. */
-	if (flags & BIT(0)) {
+	if (gve_get_report_stats(priv))
 		mod_timer(&priv->stats_report_timer,
 			  round_jiffies(jiffies +
 					msecs_to_jiffies(priv->stats_report_timer_period)));
-	}
+
 	/* Zero off gve stats when report-stats turned off and */
 	/* delete report stats timer. */
-	if (!(flags & BIT(0)) && (ori_flags & BIT(0))) {
+	if (!gve_get_report_stats(priv) &&
+	    (ori_flags & BIT(GVE_PRIV_FLAGS_REPORT_STATS))) {
 		int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
 			priv->tx_cfg.num_queues;
 		int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
@@ -530,7 +529,27 @@ static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
 				   sizeof(struct stats));
 		del_timer_sync(&priv->stats_report_timer);
 	}
-	return 0;
+
+	if (priv->ethtool_formats == 0)
+		/* Can't change queue format */
+		return 0;
+
+	/* Check if a new queue format should be activated */
+	if (gve_get_enable_dqo_rda(priv))
+		new_format = GVE_DQO_RDA_FORMAT;
+	else if (gve_get_enable_gqi_rda(priv))
+		new_format = GVE_GQI_RDA_FORMAT;
+	else
+		new_format = GVE_GQI_QPL_FORMAT;
+
+	if (priv->queue_format == new_format)
+		return 0;
+
+	priv->next_queue_format = new_format;
+	dev_info(&priv->pdev->dev, "Driver is switching to %s queue format.\n",
+		 gve_queue_format_name(priv->next_queue_format));
+
+	return gve_reset(priv, false);
 }
 
 static int gve_get_link_ksettings(struct net_device *netdev,
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 5b40f9c53196..23f30d9d97a0 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -32,6 +32,23 @@
 const char gve_version_str[] = GVE_VERSION;
 static const char gve_version_prefix[] = GVE_VERSION_PREFIX;
 
+const char *gve_queue_format_name(enum gve_queue_format format)
+{
+	switch (format) {
+	case GVE_QUEUE_FORMAT_UNSPECIFIED:
+		return "unspecified";
+	case GVE_GQI_RDA_FORMAT:
+		return "GQI RDA";
+	case GVE_GQI_QPL_FORMAT:
+		return "GQI QPL";
+	case GVE_DQO_RDA_FORMAT:
+		return "DQO RDA";
+	default:
+		return "unknown";
+	}
+}
+
+struct bpf_prog;
 static int gve_verify_driver_compatibility(struct gve_priv *priv)
 {
 	int err;
@@ -1413,6 +1430,11 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 		return err;
 	}
 
+	if (skip_describe_device) {
+		priv->queue_format = priv->next_queue_format;
+		goto setup_device;
+	}
+
 	err = gve_verify_driver_compatibility(priv);
 	if (err) {
 		dev_err(&priv->pdev->dev,
@@ -1420,9 +1442,6 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 		goto err;
 	}
 
-	if (skip_describe_device)
-		goto setup_device;
-
 	priv->queue_format = GVE_QUEUE_FORMAT_UNSPECIFIED;
 	/* Get the initial information we need from the device */
 	err = gve_adminq_describe_device(priv);
@@ -1661,6 +1680,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->service_task_flags = 0x0;
 	priv->state_flags = 0x0;
 	priv->ethtool_flags = 0x0;
+	priv->ethtool_formats = 0x0;
 
 	gve_set_probe_in_progress(priv);
 	priv->gve_wq = alloc_ordered_workqueue("gve", 0);
-- 
2.39.1.456.gfc5497dd1b-goog

