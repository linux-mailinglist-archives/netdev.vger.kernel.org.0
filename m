Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319762C46ED
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 18:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732906AbgKYRix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 12:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730653AbgKYRix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 12:38:53 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2BFC0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 09:38:53 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id u37so580252ybi.15
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 09:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=sjqbZMhxPK938ej92Ts1k1/xwfmuayPRPSr4ai0+vh4=;
        b=a4rdeIumGBxjhlxyqRHnRsALSH7geCmRH/WUft2AFJCA39m9QyPphy8AERYNHqi4R/
         pxtxYt6v9wXG8FiktIeBi9WCtiFILF10q6dtWZjde4G7je+oXbLNOvQ5C12H0rfHr/1l
         opCgiK2N4ayZf2lazFJDI9vPolvEloH9G6PoPI0I63M3EOg6osrCe84jKdV3DMain+tI
         2HvxVt16mfsqrp2VzskXGszt4eet7RUyMYeVFVmf4F/q3OfKpjdXNZQg9R3S7JoOkEvD
         cg0MweiKeDo63qEfyNBwNPJTSFsnkrJ1VztfXir8xBR0Q2ZV2B+T1PnX1HrLd5R8y532
         Ds8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sjqbZMhxPK938ej92Ts1k1/xwfmuayPRPSr4ai0+vh4=;
        b=JHR3WrTD81ysHfAEcdw8lG4uiULm/4vDAyxdFVnmmf6UHlzGdtlyShRGCxSzWf0YTq
         F37ra7JrUgLIh9qT7Gysvu/MidBPtnK8F6ZI1OWzyfVyyS/CcvlQb6zRECdT1GmJnmYR
         VmDvMvoUuZJOFhgOGv/XHSTebNE12jg1kTz2epL502OSOPLgQGwnprn1QPP8NV2GxrJb
         JlYMyf+MZs8ydC4wK5pjwYL1CdLuPN1Nh7CJtjOtdneYlv+55a/rcp50EWmpegR923yC
         n09DQPjnz39Wu4nUt6VmxjcZFBdfRZHzOriPLiAWfaDqgp9xbjtKEYCrIq2jupC4mjk1
         GZwg==
X-Gm-Message-State: AOAM532JFoNL7bUtbj/GAstvOEPNkQG33Ryt1qfEYpXCa7LT8quM/IqF
        z9JgABlsrKVlBzSEM/PJrhA31H8vT+tRZhKL3ROkT+gO/Qm9kPJUwlUzkeLoTWoDrE4/wzKUovs
        VlMXxvbOmmqV6c0Srfgog7g2Lissg+ge0onpm8cEWlTirYeqPFb/q4XmMFAatBNSQi5sHnVRo
X-Google-Smtp-Source: ABdhPJzjr71MTSAhqU+W1bM3Zb5zJ6IcoMwf2GODdVynKx6mLWyhH6dtdi/OkRhwIGW4BH1lz4T+RlCQJOj6HpFC
Sender: "awogbemila via sendgmr" <awogbemila@awogbemila.sea.corp.google.com>
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:d047:: with SMTP id
 h68mr5176647ybg.49.1606325932297; Wed, 25 Nov 2020 09:38:52 -0800 (PST)
Date:   Wed, 25 Nov 2020 09:38:43 -0800
In-Reply-To: <20201125173846.3033449-1-awogbemila@google.com>
Message-Id: <20201125173846.3033449-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20201125173846.3033449-1-awogbemila@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH net-next v8 1/4] gve: Add support for raw addressing device option
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com, saeed@kernel.org,
        Catherine Sullivan <csully@google.com>,
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
 drivers/net/ethernet/google/gve/gve_adminq.c | 71 ++++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_adminq.h | 15 +++--
 drivers/net/ethernet/google/gve/gve_main.c   |  9 +++
 4 files changed, 92 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index f5c80229ea96..782e2791ee11 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -199,6 +199,7 @@ struct gve_priv {
 	u64 num_registered_pages; /* num pages registered with NIC */
 	u32 rx_copybreak; /* copy packets smaller than this */
 	u16 default_num_queues; /* default num queues to set up */
+	u8 raw_addressing; /* 1 if this dev supports raw addressing, 0 otherwise */
 
 	struct gve_queue_config tx_cfg;
 	struct gve_queue_config rx_cfg;
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 24ae6a28a806..608a8806f8c8 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -14,6 +14,57 @@
 #define GVE_ADMINQ_SLEEP_LEN		20
 #define GVE_MAX_ADMINQ_EVENT_COUNTER_CHECK	100
 
+#define GVE_DEVICE_OPTION_ERROR_FMT "%s option error:\n" \
+"Expected: length=%d, feature_mask=%x.\n" \
+"Actual: length=%d, feature_mask=%x.\n"
+
+static
+struct gve_device_option *gve_get_next_option(struct gve_device_descriptor *descriptor,
+					      struct gve_device_option *option)
+{
+	void *option_end, *descriptor_end;
+
+	option_end = (void *)(option + 1) + be16_to_cpu(option->option_length);
+	descriptor_end = (void *)descriptor + be16_to_cpu(descriptor->total_length);
+
+	return option_end > descriptor_end ? NULL : (struct gve_device_option *)option_end;
+}
+
+static
+void gve_parse_device_option(struct gve_priv *priv,
+			     struct gve_device_descriptor *device_descriptor,
+			     struct gve_device_option *option)
+{
+	u16 option_length = be16_to_cpu(option->option_length);
+	u16 option_id = be16_to_cpu(option->option_id);
+
+	switch (option_id) {
+	case GVE_DEV_OPT_ID_RAW_ADDRESSING:
+		/* If the length or feature mask doesn't match,
+		 * continue without enabling the feature.
+		 */
+		if (option_length != GVE_DEV_OPT_LEN_RAW_ADDRESSING ||
+		    option->feat_mask != cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING)) {
+			dev_warn(&priv->pdev->dev, GVE_DEVICE_OPTION_ERROR_FMT, "Raw Addressing",
+				 GVE_DEV_OPT_LEN_RAW_ADDRESSING,
+				 cpu_to_be32(GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING),
+				 option_length, option->feat_mask);
+			priv->raw_addressing = 0;
+		} else {
+			dev_info(&priv->pdev->dev,
+				 "Raw addressing device option enabled.\n");
+			priv->raw_addressing = 1;
+		}
+		break;
+	default:
+		/* If we don't recognize the option just continue
+		 * without doing anything.
+		 */
+		dev_dbg(&priv->pdev->dev, "Unrecognized device option 0x%hx not enabled.\n",
+			option_id);
+	}
+}
+
 int gve_adminq_alloc(struct device *dev, struct gve_priv *priv)
 {
 	priv->adminq = dma_alloc_coherent(dev, PAGE_SIZE,
@@ -460,11 +511,14 @@ int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 num_queues)
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
@@ -518,6 +572,23 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
+	dev_opt = (void *)(descriptor + 1);
+
+	num_options = be16_to_cpu(descriptor->num_device_options);
+	for (i = 0; i < num_options; i++) {
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
+		gve_parse_device_option(priv, descriptor, dev_opt);
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
2.29.2.454.gaff20da3a2-goog

