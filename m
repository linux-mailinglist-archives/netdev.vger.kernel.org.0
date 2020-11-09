Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3822AC96D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbgKIXhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729454AbgKIXhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:37:06 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAB0C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 15:37:06 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id c196so13004724ybf.0
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 15:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=1YWUAiKB6ie/2+y6SPRo8lqO99NPRLjIDB3pd9DskRA=;
        b=EHXBqfTT0XKXYYPEBixOQL20co7qzxh8aFEljPBguj7/V03hkCZZrTnS+iJWKqQHrI
         N++VpZjWvoQ9g3DP9mdHihmiwJ+XXK7myC5+nPUDf+VXlicZgyPV6h+tQAaxGoRCGv21
         S8nBI6eaCxvso6KRWDpZsZfmqzt3etmbb8LZufUvjg3IiLEADRKRGpEleI+3QsjqD548
         zsYEN3ZCEO0GPyf20lRfEJBhKRmnSlJSJ+COHYeAdHbjM8AzpOmFv2eCPjLsPOt6yaQl
         d/gV019g7GPxpvRTFg1LVD19VGXSsgNqt2jGgJt07rDR/qrOfEqqHY0HYSVitAmqrZ7P
         GK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1YWUAiKB6ie/2+y6SPRo8lqO99NPRLjIDB3pd9DskRA=;
        b=cugAFWU8QxLDV63epLFi+1gkOqJH0kUaRz5blTHh0FSyE6Mkg6VRfxhPEvDorNhSFe
         RmUUf/w535WXQjr4qQ+KuxDutR3bx2loPWtvTPhAXNKXdwZ5p3223kXzVaiQKJ3EVupo
         1xjtSx5xCTI+FP1f2SzeFvL4NREQfQGz1AQWHymncF+QnX7JDMI/HmMxkr/J/BSVIMO4
         0WfO1b3Ud2RpSCWcJal+HQPqxTUeR7n3RSHvPilIUfk/WENACxeSgL9lMlYUOlTC7AAd
         eCHWM1c6BRFNmo0PyqrkeK+X+pAaEs2bktnr2U0cCovA386sZd0o9g/lvpl7/z+/jRGr
         KBGg==
X-Gm-Message-State: AOAM5337CHL/izdW0elSyZgTVAaeHJLO1H4pAox/E2dIrJdkuZR2+6HT
        4hLDI5vQwTsw7KYnBhjIR5nf5YfK5pag/a2Z0DIybne/Yv3OdHFT+JKHxIqce3Igac5K36thU/z
        hRH6KaD/JzLn/Mt3BBChEAhi7yM676Ihf1SPUa07fBtH08FOwojAdONxL5Zcc8hLlAZ3zew1i
X-Google-Smtp-Source: ABdhPJzy8HE4thVAXhgCL9jLs/vJ8OEffyR3DokKLRTS6vW/CjdZ7dokRjxqibzl37S40oO2UcpKdmv6U7BVk8vQ
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:6cd6:: with SMTP id
 h205mr20518712ybc.49.1604965025156; Mon, 09 Nov 2020 15:37:05 -0800 (PST)
Date:   Mon,  9 Nov 2020 15:36:56 -0800
In-Reply-To: <20201109233659.1953461-1-awogbemila@google.com>
Message-Id: <20201109233659.1953461-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH net-next v6 1/4] gve: Add support for raw addressing device option
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Add support to describe device for parsing device options. As
the first device option, add raw addressing.

"Raw Addressing" mode (as opposed to the current "qpl" mode) is an
operational mode which allows the driver avoid bounce buffer copies
which it currently performs using pre-allocated qpls (queue_page_lists)
when sending and receiving packets.
For egress packets, the provided skb data addresses will be dma_map'ed and
passed to the device, allowing the NIC can perform DMA directly - the
driver will not have to copy the buffer content into pre-allocated
buffers/qpls (as in qpl mode).
For ingress packets, copies are also eliminated as buffers are handed to
the networking stack and then recycled or re-allocated as
necessary, avoiding the use of skb_copy_to_linear_data().

This patch only introduces the option to the driver.
Subsequent patches will add the ingress and egress functionality.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        |  1 +
 drivers/net/ethernet/google/gve/gve_adminq.c | 64 ++++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_adminq.h | 15 +++--
 drivers/net/ethernet/google/gve/gve_main.c   |  9 +++
 4 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index f5c80229ea96..80cdae06ee39 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -199,6 +199,7 @@ struct gve_priv {
 	u64 num_registered_pages; /* num pages registered with NIC */
 	u32 rx_copybreak; /* copy packets smaller than this */
 	u16 default_num_queues; /* default num queues to set up */
+	bool raw_addressing; /* true if this dev supports raw addressing */
 
 	struct gve_queue_config tx_cfg;
 	struct gve_queue_config rx_cfg;
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 24ae6a28a806..3e6de659b274 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -14,6 +14,18 @@
 #define GVE_ADMINQ_SLEEP_LEN		20
 #define GVE_MAX_ADMINQ_EVENT_COUNTER_CHECK	100
 
+static inline
+struct gve_device_option *gve_get_next_option(struct gve_device_descriptor *descriptor,
+					      struct gve_device_option *option)
+{
+	void *option_end, *descriptor_end;
+
+	option_end = (void *)option + sizeof(*option) + be16_to_cpu(option->option_length);
+	descriptor_end = (void *)descriptor + be16_to_cpu(descriptor->total_length);
+
+	return option_end > descriptor_end ? NULL : (struct gve_device_option *)option_end;
+}
+
 int gve_adminq_alloc(struct device *dev, struct gve_priv *priv)
 {
 	priv->adminq = dma_alloc_coherent(dev, PAGE_SIZE,
@@ -460,11 +472,14 @@ int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 num_queues)
 int gve_adminq_describe_device(struct gve_priv *priv)
 {
 	struct gve_device_descriptor *descriptor;
+	struct gve_device_option *dev_opt;
 	union gve_adminq_command cmd;
 	dma_addr_t descriptor_bus;
+	u16 num_options;
 	int err = 0;
 	u8 *mac;
 	u16 mtu;
+	int i;
 
 	memset(&cmd, 0, sizeof(cmd));
 	descriptor = dma_alloc_coherent(&priv->pdev->dev, PAGE_SIZE,
@@ -518,6 +533,55 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
+	dev_opt = (void *)(descriptor + 1);
+
+	num_options = be16_to_cpu(descriptor->num_device_options);
+	for (i = 0; i < num_options; i++) {
+		u16 option_length = be16_to_cpu(dev_opt->option_length);
+		u16 option_id = be16_to_cpu(dev_opt->option_id);
+		struct gve_device_option *next_opt;
+
+		next_opt = gve_get_next_option(descriptor, dev_opt);
+		if (!next_opt) {
+			dev_err(&priv->dev->dev,
+				"options exceed device_descriptor's total length.\n");
+			err = -EINVAL;
+			goto free_device_descriptor;
+		}
+
+		switch (option_id) {
+		case GVE_DEV_OPT_ID_RAW_ADDRESSING:
+			/* If the length or feature mask doesn't match,
+			 * continue without enabling the feature.
+			 */
+			if (option_length != GVE_DEV_OPT_LEN_RAW_ADDRESSING ||
+			    dev_opt->feat_mask !=
+			    cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING)) {
+				dev_warn(&priv->pdev->dev,
+					 "Raw addressing option error:\n"
+					 "	Expected: length=%d, feature_mask=%x.\n"
+					 "	Actual: length=%d, feature_mask=%x.\n",
+					 GVE_DEV_OPT_LEN_RAW_ADDRESSING,
+					 cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING),
+					 option_length, dev_opt->feat_mask);
+				priv->raw_addressing = false;
+			} else {
+				dev_info(&priv->pdev->dev,
+					 "Raw addressing device option enabled.\n");
+				priv->raw_addressing = true;
+			}
+			break;
+		default:
+			/* If we don't recognize the option just continue
+			 * without doing anything.
+			 */
+			dev_dbg(&priv->pdev->dev,
+				"Unrecognized device option 0x%hx not enabled.\n",
+				option_id);
+			break;
+		}
+		dev_opt = next_opt;
+	}
 
 free_device_descriptor:
 	dma_free_coherent(&priv->pdev->dev, sizeof(*descriptor), descriptor,
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index 281de8326bc5..af5f586167bd 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -79,12 +79,17 @@ struct gve_device_descriptor {
 
 static_assert(sizeof(struct gve_device_descriptor) == 40);
 
-struct device_option {
-	__be32 option_id;
-	__be32 option_length;
+struct gve_device_option {
+	__be16 option_id;
+	__be16 option_length;
+	__be32 feat_mask;
 };
 
-static_assert(sizeof(struct device_option) == 8);
+static_assert(sizeof(struct gve_device_option) == 8);
+
+#define GVE_DEV_OPT_ID_RAW_ADDRESSING 0x1
+#define GVE_DEV_OPT_LEN_RAW_ADDRESSING 0x0
+#define GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING 0x0
 
 struct gve_adminq_configure_device_resources {
 	__be64 counter_array;
@@ -111,6 +116,8 @@ struct gve_adminq_unregister_page_list {
 
 static_assert(sizeof(struct gve_adminq_unregister_page_list) == 4);
 
+#define GVE_RAW_ADDRESSING_QPL_ID 0xFFFFFFFF
+
 struct gve_adminq_create_tx_queue {
 	__be32 queue_id;
 	__be32 reserved;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 48a433154ce0..70685c10db0e 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -678,6 +678,10 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 	int i, j;
 	int err;
 
+	/* Raw addressing means no QPLs */
+	if (priv->raw_addressing)
+		return 0;
+
 	priv->qpls = kvzalloc(num_qpls * sizeof(*priv->qpls), GFP_KERNEL);
 	if (!priv->qpls)
 		return -ENOMEM;
@@ -718,6 +722,10 @@ static void gve_free_qpls(struct gve_priv *priv)
 	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
 	int i;
 
+	/* Raw addressing means no QPLs */
+	if (priv->raw_addressing)
+		return;
+
 	kvfree(priv->qpl_cfg.qpl_id_map);
 
 	for (i = 0; i < num_qpls; i++)
@@ -1078,6 +1086,7 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 	if (skip_describe_device)
 		goto setup_device;
 
+	priv->raw_addressing = false;
 	/* Get the initial information we need from the device */
 	err = gve_adminq_describe_device(priv);
 	if (err) {
-- 
2.29.2.222.g5d2a92d10f8-goog

