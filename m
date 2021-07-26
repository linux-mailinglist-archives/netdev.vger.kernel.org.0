Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAA13D65EA
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhGZQ7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbhGZQ7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 12:59:49 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF059C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 10:40:17 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id j21so12898159ioo.6
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 10:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rMhwXuvkKbeYnU6oDXYaGN+W0CVUDzl5mE/XU+7HM3k=;
        b=LH3WAvZFozHwksBA62OcjqWgC5JXBSCJSVYZDvmUSZG3RT7WIMg14xGurLLDuwjmdA
         JtlkmhkCCrK4KBBrQ/QTuO3i0SHfWKIJ/RC1CoNtu5vaaOGfI+DpKqnZm8a8JFWcdb3A
         tlM/Co6WUg0vCzmDlS7RbDJ7MrlGQOC7H8CmTNdMK1SZwIKZHII9Nynqv3MdVhAvhaGH
         csXKc2BdS3++Vsc/aIdk01ZZk/odBkVkbuOWCC+IlzhBkANr2jabUqBLp6AIueDnVsPC
         uJ9ZkRiXiLJn4LKHyVFsfq2WxwjpblvBJVyivN5uh+/8TE+V8hkEzmM/C1U4WLND+NlL
         +vlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rMhwXuvkKbeYnU6oDXYaGN+W0CVUDzl5mE/XU+7HM3k=;
        b=lN8xnh7FTJIayf6YAPEgpAuyuqfH4wj64J1iPTUWK45OUYC6ZBVr/4mTo7ipc2YK4d
         vqyyJKyDO2o2gvGRIeMtnPEOw5PWQ758AVHt9KoFUmX1tZj7mJoYz/Pf9X1YVueCf6Vw
         wvG1SgnL+znC1NRr81DOvIEqVZXa2cpMIWZ9hj8iP86w1ewg11iJYWstNMMo1nSCKzmJ
         UmpyihdifIELCkCf6dm+GOSc8adOYuUTc6yejIdwNX5QDcR8ftG5s9gU+I5QfVzk5uXM
         hPrb2f2RzJJRHUymIS8uJrCwqomMw9BCFvTWPI2YrON71BYzwq7bqhlvUeOj30Bm6xTl
         JCrw==
X-Gm-Message-State: AOAM5300TMO2XK8HKxIYgXZ9al2oAeSyrNDkfUXRigNImejYFKAzuQVj
        IflFl5bM+UKrv3mKvQLshxwagg==
X-Google-Smtp-Source: ABdhPJzaE2ofk5NUGu1dCVF2T+e4Xf7i9XlCxv+1zHel0KOm//J8S+ePZXXlE7PxwmYOuNaxphvNmg==
X-Received: by 2002:a02:6d5d:: with SMTP id e29mr17618117jaf.44.1627321217136;
        Mon, 26 Jul 2021 10:40:17 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l4sm202721ilh.41.2021.07.26.10.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 10:40:16 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     leon@kernel.org, bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] net: ipa: use WARN_ON() rather than assertions
Date:   Mon, 26 Jul 2021 12:40:10 -0500
Message-Id: <20210726174010.396765-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726174010.396765-1-elder@linaro.org>
References: <20210726174010.396765-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've added commented assertions to record certain properties that
can be assumed to hold in certain places in the IPA code.  Convert
these into real WARN_ON() calls so the assertions are actually
checked, using the standard WARN_ON() mechanism.

Where errors can be returned, return an error if a warning is
triggered.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c     | 30 ++++++++++++++++++------------
 drivers/net/ipa/ipa_cmd.c       | 14 +++++++-------
 drivers/net/ipa/ipa_endpoint.c  | 26 +++++++++++++++-----------
 drivers/net/ipa/ipa_interrupt.c |  8 +++++---
 drivers/net/ipa/ipa_main.c      |  5 +----
 drivers/net/ipa/ipa_reg.h       | 12 ++++++------
 drivers/net/ipa/ipa_table.c     |  2 +-
 7 files changed, 53 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 6127370facee5..1544564bc2835 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -184,8 +184,8 @@ static u32 gsi_trans_pool_alloc_common(struct gsi_trans_pool *pool, u32 count)
 {
 	u32 offset;
 
-	/* assert(count > 0); */
-	/* assert(count <= pool->max_alloc); */
+	WARN_ON(!count);
+	WARN_ON(count > pool->max_alloc);
 
 	/* Allocate from beginning if wrap would occur */
 	if (count > pool->count - pool->free)
@@ -221,9 +221,10 @@ void *gsi_trans_pool_next(struct gsi_trans_pool *pool, void *element)
 {
 	void *end = pool->base + pool->count * pool->size;
 
-	/* assert(element >= pool->base); */
-	/* assert(element < end); */
-	/* assert(pool->max_alloc == 1); */
+	WARN_ON(element < pool->base);
+	WARN_ON(element >= end);
+	WARN_ON(pool->max_alloc != 1);
+
 	element += pool->size;
 
 	return element < end ? element : pool->base;
@@ -328,7 +329,8 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	struct gsi_trans_info *trans_info;
 	struct gsi_trans *trans;
 
-	/* assert(tre_count <= gsi_channel_trans_tre_max(gsi, channel_id)); */
+	if (WARN_ON(tre_count > gsi_channel_trans_tre_max(gsi, channel_id)))
+		return NULL;
 
 	trans_info = &channel->trans_info;
 
@@ -404,7 +406,7 @@ void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
 	u32 which = trans->used++;
 	struct scatterlist *sg;
 
-	/* assert(which < trans->tre_count); */
+	WARN_ON(which >= trans->tre_count);
 
 	/* Commands are quite different from data transfer requests.
 	 * Their payloads come from a pool whose memory is allocated
@@ -437,8 +439,10 @@ int gsi_trans_page_add(struct gsi_trans *trans, struct page *page, u32 size,
 	struct scatterlist *sg = &trans->sgl[0];
 	int ret;
 
-	/* assert(trans->tre_count == 1); */
-	/* assert(!trans->used); */
+	if (WARN_ON(trans->tre_count != 1))
+		return -EINVAL;
+	if (WARN_ON(trans->used))
+		return -EINVAL;
 
 	sg_set_page(sg, page, size, offset);
 	ret = dma_map_sg(trans->gsi->dev, sg, 1, trans->direction);
@@ -457,8 +461,10 @@ int gsi_trans_skb_add(struct gsi_trans *trans, struct sk_buff *skb)
 	u32 used;
 	int ret;
 
-	/* assert(trans->tre_count == 1); */
-	/* assert(!trans->used); */
+	if (WARN_ON(trans->tre_count != 1))
+		return -EINVAL;
+	if (WARN_ON(trans->used))
+		return -EINVAL;
 
 	/* skb->len will not be 0 (checked early) */
 	ret = skb_to_sgvec(skb, sg, 0, skb->len);
@@ -546,7 +552,7 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 	u32 avail;
 	u32 i;
 
-	/* assert(trans->used > 0); */
+	WARN_ON(!trans->used);
 
 	/* Consume the entries.  If we cross the end of the ring while
 	 * filling them we'll switch to the beginning to finish.
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 8900f91509fee..cff51731195aa 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -165,6 +165,10 @@ static void ipa_cmd_validate_build(void)
 		     field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK));
 	BUILD_BUG_ON(field_max(IP_FLTRT_FLAGS_HASH_ADDR_FMASK) !=
 		     field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK));
+
+	/* Valid endpoint numbers must fit in the IP packet init command */
+	BUILD_BUG_ON(field_max(IPA_PACKET_INIT_DEST_ENDPOINT_FMASK) <
+		     IPA_ENDPOINT_MAX - 1);
 }
 
 /* Validate a memory region holding a table */
@@ -531,9 +535,6 @@ static void ipa_cmd_ip_packet_init_add(struct gsi_trans *trans, u8 endpoint_id)
 	union ipa_cmd_payload *cmd_payload;
 	dma_addr_t payload_addr;
 
-	/* assert(endpoint_id <
-		  field_max(IPA_PACKET_INIT_DEST_ENDPOINT_FMASK)); */
-
 	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
 	payload = &cmd_payload->ip_packet_init;
 
@@ -557,8 +558,9 @@ void ipa_cmd_dma_shared_mem_add(struct gsi_trans *trans, u32 offset, u16 size,
 	u16 flags;
 
 	/* size and offset must fit in 16 bit fields */
-	/* assert(size > 0 && size <= U16_MAX); */
-	/* assert(offset <= U16_MAX && ipa->mem_offset <= U16_MAX - offset); */
+	WARN_ON(!size);
+	WARN_ON(size > U16_MAX);
+	WARN_ON(offset > U16_MAX || ipa->mem_offset > U16_MAX - offset);
 
 	offset += ipa->mem_offset;
 
@@ -597,8 +599,6 @@ static void ipa_cmd_ip_tag_status_add(struct gsi_trans *trans)
 	union ipa_cmd_payload *cmd_payload;
 	dma_addr_t payload_addr;
 
-	/* assert(tag <= field_max(IP_PACKET_TAG_STATUS_TAG_FMASK)); */
-
 	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
 	payload = &cmd_payload->ip_packet_tag_status;
 
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index ab02669bae4e6..8070d1a1d5dfd 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -250,17 +250,18 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 
 	/* Suspend is not supported for IPA v4.0+.  Delay doesn't work
 	 * correctly on IPA v4.2.
-	 *
-	 * if (endpoint->toward_ipa)
-	 * 	assert(ipa->version != IPA_VERSION_4.2);
-	 * else
-	 *	assert(ipa->version < IPA_VERSION_4_0);
 	 */
+	if (endpoint->toward_ipa)
+		WARN_ON(ipa->version == IPA_VERSION_4_2);
+	else
+		WARN_ON(ipa->version >= IPA_VERSION_4_0);
+
 	mask = endpoint->toward_ipa ? ENDP_DELAY_FMASK : ENDP_SUSPEND_FMASK;
 
 	val = ioread32(ipa->reg_virt + offset);
-	/* Don't bother if it's already in the requested state */
 	state = !!(val & mask);
+
+	/* Don't bother if it's already in the requested state */
 	if (suspend_delay != state) {
 		val ^= mask;
 		iowrite32(val, ipa->reg_virt + offset);
@@ -273,7 +274,7 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 static void
 ipa_endpoint_program_delay(struct ipa_endpoint *endpoint, bool enable)
 {
-	/* assert(endpoint->toward_ipa); */
+	WARN_ON(!endpoint->toward_ipa);
 
 	/* Delay mode doesn't work properly for IPA v4.2 */
 	if (endpoint->ipa->version != IPA_VERSION_4_2)
@@ -287,7 +288,8 @@ static bool ipa_endpoint_aggr_active(struct ipa_endpoint *endpoint)
 	u32 offset;
 	u32 val;
 
-	/* assert(mask & ipa->available); */
+	WARN_ON(!(mask & ipa->available));
+
 	offset = ipa_reg_state_aggr_active_offset(ipa->version);
 	val = ioread32(ipa->reg_virt + offset);
 
@@ -299,7 +301,8 @@ static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
 	u32 mask = BIT(endpoint->endpoint_id);
 	struct ipa *ipa = endpoint->ipa;
 
-	/* assert(mask & ipa->available); */
+	WARN_ON(!(mask & ipa->available));
+
 	iowrite32(mask, ipa->reg_virt + IPA_REG_AGGR_FORCE_CLOSE_OFFSET);
 }
 
@@ -338,7 +341,7 @@ ipa_endpoint_program_suspend(struct ipa_endpoint *endpoint, bool enable)
 	if (endpoint->ipa->version >= IPA_VERSION_4_0)
 		return enable;	/* For IPA v4.0+, no change made */
 
-	/* assert(!endpoint->toward_ipa); */
+	WARN_ON(endpoint->toward_ipa);
 
 	suspended = ipa_endpoint_init_ctrl(endpoint, enable);
 
@@ -1156,7 +1159,8 @@ static bool ipa_endpoint_skb_build(struct ipa_endpoint *endpoint,
 	if (!endpoint->netdev)
 		return false;
 
-	/* assert(len <= SKB_WITH_OVERHEAD(IPA_RX_BUFFER_SIZE-NET_SKB_PAD)); */
+	WARN_ON(len > SKB_WITH_OVERHEAD(IPA_RX_BUFFER_SIZE - NET_SKB_PAD));
+
 	skb = build_skb(page_address(page), IPA_RX_BUFFER_SIZE);
 	if (skb) {
 		/* Reserve the headroom and account for the data */
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index c46df0b7c4e50..e792bc3be5766 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -146,7 +146,7 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 	u32 offset;
 	u32 val;
 
-	/* assert(mask & ipa->available); */
+	WARN_ON(!(mask & ipa->available));
 
 	/* IPA version 3.0 does not support TX_SUSPEND interrupt control */
 	if (ipa->version == IPA_VERSION_3_0)
@@ -206,7 +206,8 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
 	struct ipa *ipa = interrupt->ipa;
 	u32 offset;
 
-	/* assert(ipa_irq < IPA_IRQ_COUNT); */
+	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
+
 	interrupt->handler[ipa_irq] = handler;
 
 	/* Update the IPA interrupt mask to enable it */
@@ -222,7 +223,8 @@ ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
 	struct ipa *ipa = interrupt->ipa;
 	u32 offset;
 
-	/* assert(ipa_irq < IPA_IRQ_COUNT); */
+	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
+
 	/* Update the IPA interrupt mask to disable it */
 	interrupt->enabled &= ~BIT(ipa_irq);
 	offset = ipa_reg_irq_en_offset(ipa->version);
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index ff5f3fab640d6..0567d726c5608 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -253,9 +253,6 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 	const struct ipa_qsb_data *data1;
 	u32 val;
 
-	/* assert(data->qsb_count > 0); */
-	/* assert(data->qsb_count < 3); */
-
 	/* QMB 0 represents DDR; QMB 1 (if present) represents PCIe */
 	data0 = &data->qsb_data[IPA_QSB_MASTER_DDR];
 	if (data->qsb_count > 1)
@@ -293,7 +290,7 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
  */
 static u32 ipa_aggr_granularity_val(u32 usec)
 {
-	/* assert(usec != 0); */
+	WARN_ON(!usec);
 
 	return DIV_ROUND_CLOSEST(usec * TIMER_FREQUENCY, USEC_PER_SEC) - 1;
 }
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index b89dec5865a5b..a5b355384d4ae 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -99,7 +99,7 @@ struct ipa;
 static inline u32 arbitration_lock_disable_encoded(enum ipa_version version,
 						   u32 mask)
 {
-	/* assert(version >= IPA_VERSION_4_0); */
+	WARN_ON(version < IPA_VERSION_4_0);
 
 	if (version < IPA_VERSION_4_9)
 		return u32_encode_bits(mask, GENMASK(20, 17));
@@ -116,7 +116,7 @@ static inline u32 full_flush_rsc_closure_en_encoded(enum ipa_version version,
 {
 	u32 val = enable ? 1 : 0;
 
-	/* assert(version >= IPA_VERSION_4_5); */
+	WARN_ON(version < IPA_VERSION_4_5);
 
 	if (version == IPA_VERSION_4_5 || version == IPA_VERSION_4_7)
 		return u32_encode_bits(val, GENMASK(21, 21));
@@ -409,7 +409,7 @@ static inline u32 ipa_header_size_encoded(enum ipa_version version,
 
 	val = u32_encode_bits(size, HDR_LEN_FMASK);
 	if (version < IPA_VERSION_4_5) {
-		/* ipa_assert(header_size == size); */
+		WARN_ON(header_size != size);
 		return val;
 	}
 
@@ -429,7 +429,7 @@ static inline u32 ipa_metadata_offset_encoded(enum ipa_version version,
 
 	val = u32_encode_bits(off, HDR_OFST_METADATA_FMASK);
 	if (version < IPA_VERSION_4_5) {
-		/* ipa_assert(offset == off); */
+		WARN_ON(offset != off);
 		return val;
 	}
 
@@ -812,7 +812,7 @@ ipa_reg_irq_suspend_info_offset(enum ipa_version version)
 static inline u32
 ipa_reg_irq_suspend_en_ee_n_offset(enum ipa_version version, u32 ee)
 {
-	/* assert(version != IPA_VERSION_3_0); */
+	WARN_ON(version == IPA_VERSION_3_0);
 
 	if (version < IPA_VERSION_4_9)
 		return 0x00003034 + 0x1000 * ee;
@@ -830,7 +830,7 @@ ipa_reg_irq_suspend_en_offset(enum ipa_version version)
 static inline u32
 ipa_reg_irq_suspend_clr_ee_n_offset(enum ipa_version version, u32 ee)
 {
-	/* assert(version != IPA_VERSION_3_0); */
+	WARN_ON(version == IPA_VERSION_3_0);
 
 	if (version < IPA_VERSION_4_9)
 		return 0x00003038 + 0x1000 * ee;
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index c607ebec74567..2324e1b93e37d 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -231,7 +231,7 @@ static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
 	if (!count)
 		return 0;
 
-/* assert(count <= max_t(u32, IPA_FILTER_COUNT_MAX, IPA_ROUTE_COUNT_MAX)); */
+	WARN_ON(count > max_t(u32, IPA_FILTER_COUNT_MAX, IPA_ROUTE_COUNT_MAX));
 
 	/* Skip over the zero rule and possibly the filter mask */
 	skip = filter_mask ? 1 : 2;
-- 
2.27.0

