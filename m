Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11BD2703B8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgIRSH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRSH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:07:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77ED5C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 11:07:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y6so6294843ybi.11
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 11:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=UEnJBtojhxDnqw7J1AzGBnp5BsMwkcU/v7w7cXuGCOQ=;
        b=QGAwYaNWC+r8SFFQOg+ehEpOsRq40pnQMI6uvsDF3zMxsdMwW21227NW8O9JomeKx8
         1lfkXwmM3EGxoAFh5W5fzw8HWp7E3MwicubxB5TOx4sLVC5iHB8/PYqBpIVsguSLoQoc
         LwOdduknVhcS6odINvUK/ogn0PcnO0KvHcZk8zHQhJ1ReW1wqZuLuHKhfU/BGlVmC26N
         R/BgKhdKQkaYmdxUTqnmIIEVVVXO9pKERvgY/qtURziEu8oHvTqzfljJfB2Zv9TP5SMu
         m44y3rf+ZdUMEVGJHAdFQg5JIt57MagRjqidwerSeiKOw7afSfHXXleQGDBtlNSY6iQy
         OcOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UEnJBtojhxDnqw7J1AzGBnp5BsMwkcU/v7w7cXuGCOQ=;
        b=meULbDtggNueYIGg4d8xz+5cKTG76kU8lsNEWrgq8lWXerXKWoPx+QWct505PIbVmz
         CkltIOCRULoT6tcgWe6jKkn+XhMvXHLl20IuMi1MUafk8ChrlJ4sj5DqXSxe+q57yigY
         ckHgkmTViKRpbf8xW4fLeCOjhKzzxBg/jagR3LCEA2I1mcCYvYVjCQKddsb4tGycxnAm
         8Oia7oIv7wYmYFF4q1K3DrKp3jCt7EavVXytoqplwSUlghsY2HfwkOu5u+OJhoEL8TbL
         Z92r8oz6vKo7KGojwE2e0l4Qnc68xdQmxu26B1iMFqxroqVD38n3u1WQMlvwmgrtLTHL
         vlug==
X-Gm-Message-State: AOAM5324RhHJw9ivOtaUS4FjrMOACoW1wGMPrAfKdMcraza95O+i0SrY
        psNqJ2Vg1wg6mhRmczai0rY6E09fQJzT5E0l93Pg+punmnkCRqZ+II2HGP7vihPg6TzkPTa/cPE
        z2EiNRPHl+v61K8KsRKsbL72o15PmLa+Ec2t6Uc05KWg0Ul7eIHDnh02Koclbal2eAnO6DoRo
X-Google-Smtp-Source: ABdhPJzITQqJZZas5OPy8jFlhWfo0oPCPfaEvlle5fUIlRPd1MHDXZfWyiS6S6YX2Pcj9yCIDtICQvWZ/A0ct2sr
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:d3c4:: with SMTP id
 e187mr14645221ybf.300.1600452445603; Fri, 18 Sep 2020 11:07:25 -0700 (PDT)
Date:   Fri, 18 Sep 2020 11:07:18 -0700
In-Reply-To: <20200918180720.2080407-1-awogbemila@google.com>
Message-Id: <20200918180720.2080407-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20200918180720.2080407-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 1/3] gve: Add support for raw addressing device option
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
 drivers/net/ethernet/google/gve/gve_adminq.c | 49 +++++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_adminq.h | 15 ++++--
 drivers/net/ethernet/google/gve/gve_main.c   |  9 ++++
 4 files changed, 69 insertions(+), 5 deletions(-)

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
index 24ae6a28a806..b79958e37a30 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -460,11 +460,14 @@ int gve_adminq_destroy_rx_queues(struct gve_priv *priv, u32 num_queues)
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
@@ -514,10 +517,54 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 	priv->rx_pages_per_qpl = be16_to_cpu(descriptor->rx_pages_per_qpl);
 	if (priv->rx_pages_per_qpl < priv->rx_desc_cnt) {
 		dev_err(&priv->pdev->dev, "rx_pages_per_qpl cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
-			priv->rx_pages_per_qpl);
+			  priv->rx_pages_per_qpl);
 		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
 	}
 	priv->default_num_queues = be16_to_cpu(descriptor->default_num_queues);
+	dev_opt = (struct gve_device_option *)((void *)descriptor +
+							sizeof(*descriptor));
+
+	num_options = be16_to_cpu(descriptor->num_device_options);
+	for (i = 0; i < num_options; i++) {
+		u16 option_length = be16_to_cpu(dev_opt->option_length);
+		u16 option_id = be16_to_cpu(dev_opt->option_id);
+
+		if ((void *)dev_opt + sizeof(*dev_opt) + option_length > (void *)descriptor +
+				      be16_to_cpu(descriptor->total_length)) {
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
+			    be32_to_cpu(dev_opt->feat_mask) !=
+			    GVE_DEV_OPT_FEAT_MASK_RAW_ADDRESSING) {
+				dev_info(&priv->pdev->dev,
+					 "Raw addressing device option not enabled, length or features mask did not match expected.\n");
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
+			dev_info(&priv->pdev->dev,
+				 "Unrecognized device option 0x%hx not enabled.\n",
+				   option_id);
+			break;
+		}
+		dev_opt = (void *)dev_opt + sizeof(*dev_opt) + option_length;
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
2.28.0.681.g6f77f65b4e-goog

