Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3165934BDAD
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 19:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhC1Rbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 13:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhC1RbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 13:31:21 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79447C061756
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:21 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id y17so9345920ila.6
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uEomFwGOriI2mXIXsdnZpwgRECmnsgSqNPpeNfLZcsc=;
        b=MbfdzYF9DKwBGZ4uh5K08EWewPAPi/UVMMlwalE05xNaQsxSOQoS6iAchVlpUeZ+SN
         tN6cl5mkxdgJAbhqUq9Kawjqy/bIkFuiOKb+x3RlYwDqNn1CYNPx2Ta0GLW9r3QLdx5v
         zxJEYHuUcb8b8+W89FDXzwAZp4g3hlcXJDrO0F+5j2nk9yHHsjLiFrx6cD6UoY1HtAvD
         /p0h4TSarVdENxzdaCEvlCQEYfdTRoYGpsqEH1h3+2JoMrHL+ttw21hY0Y4kOrxlptO6
         0PWQVzhChqjak24gACNw7I0c5x4ImlPZp71pQ7a2uE/T+beXXKIK1sR0u791Ezwf8UVF
         xefw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uEomFwGOriI2mXIXsdnZpwgRECmnsgSqNPpeNfLZcsc=;
        b=BseAwAVLGjkOyrDlO3h7Gn0F50CUTmwSo2JBHSlbTQ31RBjHHFrDRvng/tmtCiIO/Y
         EHlYwkRhYoaUfpj6NsF8t8exnOLCiJ/uwP6S6bxwI4BBhEA4Q9DWJVlgLOR51Q7KbzpH
         mV1MT40DkYPDOTr3Zdy9gAtFSmdl/in2iU6J3MKe+qc4NEAj9uMUC4INbmYKyiwmsQco
         yVrCzxXDnQBhUfdG+hI/4i/l/lsvuuH+QaV2fE7cuQlBCF2NJH/yFdrAFZ43drLpxwoI
         SLRjlqG1Z44GWFXgSooCEARs6eBHvHeTTbYY700j7IKWqEyFMQYoIYE9SkIfXJPexIWy
         ++eQ==
X-Gm-Message-State: AOAM533XUtJiEpL4XgiX++RCu9hNpob7cUoYQQTDsIM7GAzB4zOFKe//
        Tq+xLxnjGSCXlXls24KsYUugvA==
X-Google-Smtp-Source: ABdhPJxWGmH8jEBHaioqJ8etYh5BJ8aGe5g2YGHYXtZna2nW71lNZnx6+j8HLHHSWJwXXFulZr9OhQ==
X-Received: by 2002:a05:6e02:20cd:: with SMTP id 13mr1454112ilq.126.1616952680864;
        Sun, 28 Mar 2021 10:31:20 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d22sm8014422iof.48.2021.03.28.10.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 10:31:20 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>
Subject: [PATCH net-next 6/7] net: ipa: DMA addresses are nicely aligned
Date:   Sun, 28 Mar 2021 12:31:10 -0500
Message-Id: <20210328173111.3399063-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210328173111.3399063-1-elder@linaro.org>
References: <20210328173111.3399063-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent patch avoided doing 64-bit modulo operations by checking
the alignment of some DMA allocations using only the lower 32 bits
of the address.

David Laight pointed out (after the fix was committed) that DMA
allocations might already satisfy the alignment requirements.  And
he was right.

Remove the alignment checks that occur after DMA allocation requests,
and update comments to explain why the constraint is satisfied.  The
only place IPA_TABLE_ALIGN was used was to check the alignment; it is
therefore no longer needed, so get rid of it.

Add comments where GSI_RING_ELEMENT_SIZE and the tre_count and
event_count channel data fields are defined to make explicit they
are required to be powers of 2.

Revise a comment in gsi_trans_pool_init_dma(), taking into account
that dma_alloc_coherent() guarantees its result is aligned to a page
size (or order thereof).

Don't bother printing an error if a DMA allocation fails.

Suggested-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c         | 13 ++++---------
 drivers/net/ipa/gsi_private.h |  2 +-
 drivers/net/ipa/gsi_trans.c   |  9 ++++-----
 drivers/net/ipa/ipa_data.h    |  4 ++--
 drivers/net/ipa/ipa_table.c   | 24 ++++++------------------
 5 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 585574af36ecd..1c835b3e1a437 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1444,18 +1444,13 @@ static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
 	dma_addr_t addr;
 
 	/* Hardware requires a 2^n ring size, with alignment equal to size.
-	 * The size is a power of 2, so we can check alignment using just
-	 * the bottom 32 bits for a DMA address of any size.
+	 * The DMA address returned by dma_alloc_coherent() is guaranteed to
+	 * be a power-of-2 number of pages, which satisfies the requirement.
 	 */
 	ring->virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
-	if (ring->virt && lower_32_bits(addr) % size) {
-		dma_free_coherent(dev, size, ring->virt, addr);
-		dev_err(dev, "unable to alloc 0x%x-aligned ring buffer\n",
-			size);
-		return -EINVAL;	/* Not a good error value, but distinct */
-	} else if (!ring->virt) {
+	if (!ring->virt)
 		return -ENOMEM;
-	}
+
 	ring->addr = addr;
 	ring->count = count;
 
diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index ed7bc26f85e9a..ea333a244cf5e 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -14,7 +14,7 @@ struct gsi_trans;
 struct gsi_ring;
 struct gsi_channel;
 
-#define GSI_RING_ELEMENT_SIZE	16	/* bytes */
+#define GSI_RING_ELEMENT_SIZE	16	/* bytes; must be a power of 2 */
 
 /* Return the entry that follows one provided in a transaction pool */
 void *gsi_trans_pool_next(struct gsi_trans_pool *pool, void *element);
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 6c3ed5b17b80c..70c2b585f98d6 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -153,11 +153,10 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	size = __roundup_pow_of_two(size);
 	total_size = (count + max_alloc - 1) * size;
 
-	/* The allocator will give us a power-of-2 number of pages.  But we
-	 * can't guarantee that, so request it.  That way we won't waste any
-	 * memory that would be available beyond the required space.
-	 *
-	 * Note that gsi_trans_pool_exit_dma() assumes the total allocated
+	/* The allocator will give us a power-of-2 number of pages
+	 * sufficient to satisfy our request.  Round up our requested
+	 * size to avoid any unused space in the allocation.  This way
+	 * gsi_trans_pool_exit_dma() can assume the total allocated
 	 * size is exactly (count * size).
 	 */
 	total_size = get_order(total_size) << PAGE_SHIFT;
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index e97342e80d537..769f68923527f 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -90,8 +90,8 @@ struct ipa_qsb_data {
  * that can be included in a single transaction.
  */
 struct gsi_channel_data {
-	u16 tre_count;
-	u16 event_count;
+	u16 tre_count;			/* must be a power of 2 */
+	u16 event_count;		/* must be a power of 2 */
 	u8 tlv_count;
 };
 
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 4236a50ff03ae..d9538661755f4 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -96,9 +96,6 @@
  *                 ----------------------
  */
 
-/* IPA hardware constrains filter and route tables alignment */
-#define IPA_TABLE_ALIGN			128	/* Minimum table alignment */
-
 /* Assignment of route table entries to the modem and AP */
 #define IPA_ROUTE_MODEM_MIN		0
 #define IPA_ROUTE_MODEM_COUNT		8
@@ -652,26 +649,17 @@ int ipa_table_init(struct ipa *ipa)
 
 	ipa_table_validate_build();
 
+	/* The IPA hardware requires route and filter table rules to be
+	 * aligned on a 128-byte boundary.  We put the "zero rule" at the
+	 * base of the table area allocated here.  The DMA address returned
+	 * by dma_alloc_coherent() is guaranteed to be a power-of-2 number
+	 * of pages, which satisfies the rule alignment requirement.
+	 */
 	size = IPA_ZERO_RULE_SIZE + (1 + count) * IPA_TABLE_ENTRY_SIZE;
 	virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
 	if (!virt)
 		return -ENOMEM;
 
-	/* We put the "zero rule" at the base of our table area.  The IPA
-	 * hardware requires route and filter table rules to be aligned
-	 * on a 128-byte boundary.  As long as the alignment constraint
-	 * is a power of 2, we can check alignment using just the bottom
-	 * 32 bits for a DMA address of any size.
-	 */
-	BUILD_BUG_ON(!is_power_of_2(IPA_TABLE_ALIGN));
-	if (lower_32_bits(addr) % IPA_TABLE_ALIGN) {
-		dev_err(dev, "table address %pad not %u-byte aligned\n",
-			&addr, IPA_TABLE_ALIGN);
-		dma_free_coherent(dev, size, virt, addr);
-
-		return -ERANGE;
-	}
-
 	ipa->table_virt = virt;
 	ipa->table_addr = addr;
 
-- 
2.27.0

