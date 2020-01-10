Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4550136E07
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgAJN2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:28:18 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:57756 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727553AbgAJN2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:28:17 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5F053B4005D;
        Fri, 10 Jan 2020 13:28:16 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 10 Jan 2020 13:28:11 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 7/9] sfc: move RSS code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Message-ID: <d5f79bbb-e6dc-5205-8c0e-f43892bf6702@solarflare.com>
Date:   Fri, 10 Jan 2020 13:28:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25158.003
X-TM-AS-Result: No-6.691700-8.000000-10
X-TMASE-MatchedRID: x7hh+1pn08LoV3o5SLrUYvGSfx66m+aMeouvej40T4gd0WOKRkwsh7Eg
        H/blGj35SjVIFO5E44Bw5T4Iaj538mJZXQNDzktSjQlVVwSbjyfYuVu0X/rOkLxgMf9QE2ebmCe
        NcdQPr8yZ3+BXOgDpPdSFa7WNm9rSXXhMBXemG5RTNl9jB9u8gBMCOhxbOH51fqFWsdsssTc6Rv
        9YN97Y5jo1TX7PDFPCHvRJZ/huLIQxotZUXfwLlEhwlOfYeSqx1B5mjfppvWCA6UrbM3j3qRUCx
        /X5xkUncf+//KzNhNHIGPM+Lmih35DZyb8jUOa1FhmgoA99DoKosxQx1ZmPo7qln+jYe7ZhNHwB
        AGIh28uYU/7VPes+KZiP3bw0i7z//P6iulw8JvSwVIp8Y8imtT4YVGZDlIa7myiLZetSf8nJ4y0
        wP1A6ABfHTaLJ4M3MVymkLM+r7VQ7AFczfjr/7IavGLYGdzaZedmIbZ5R++KrVrRS8t7OdweSCL
        TNpamhdy6+2FDeswg=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.691700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25158.003
X-MDID: 1578662897-pIQOxZM9aLMN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Style fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c       | 66 +---------------------------
 drivers/net/ethernet/sfc/efx.h       |  5 ---
 drivers/net/ethernet/sfc/rx_common.c | 65 +++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/rx_common.h |  6 +++
 4 files changed, 72 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 7ad97090ab52..a997f3d720ab 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -27,6 +27,7 @@
 #include "efx_channels.h"
 #include "rx_common.h"
 #include "tx_common.h"
+#include "rx_common.h"
 #include "nic.h"
 #include "io.h"
 #include "selftest.h"
@@ -311,16 +312,6 @@ static void efx_dissociate(struct efx_nic *efx)
 	}
 }
 
-void efx_set_default_rx_indir_table(struct efx_nic *efx,
-				    struct efx_rss_context *ctx)
-{
-	size_t i;
-
-	for (i = 0; i < ARRAY_SIZE(ctx->rx_indir_table); i++)
-		ctx->rx_indir_table[i] =
-			ethtool_rxfh_indir_default(i, efx->rss_spread);
-}
-
 static int efx_probe_nic(struct efx_nic *efx)
 {
 	int rc;
@@ -1299,61 +1290,6 @@ void efx_rps_hash_del(struct efx_nic *efx, const struct efx_filter_spec *spec)
 }
 #endif
 
-/* RSS contexts.  We're using linked lists and crappy O(n) algorithms, because
- * (a) this is an infrequent control-plane operation and (b) n is small (max 64)
- */
-struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
-{
-	struct list_head *head = &efx->rss_context.list;
-	struct efx_rss_context *ctx, *new;
-	u32 id = 1; /* Don't use zero, that refers to the master RSS context */
-
-	WARN_ON(!mutex_is_locked(&efx->rss_lock));
-
-	/* Search for first gap in the numbering */
-	list_for_each_entry(ctx, head, list) {
-		if (ctx->user_id != id)
-			break;
-		id++;
-		/* Check for wrap.  If this happens, we have nearly 2^32
-		 * allocated RSS contexts, which seems unlikely.
-		 */
-		if (WARN_ON_ONCE(!id))
-			return NULL;
-	}
-
-	/* Create the new entry */
-	new = kmalloc(sizeof(struct efx_rss_context), GFP_KERNEL);
-	if (!new)
-		return NULL;
-	new->context_id = EFX_EF10_RSS_CONTEXT_INVALID;
-	new->rx_hash_udp_4tuple = false;
-
-	/* Insert the new entry into the gap */
-	new->user_id = id;
-	list_add_tail(&new->list, &ctx->list);
-	return new;
-}
-
-struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id)
-{
-	struct list_head *head = &efx->rss_context.list;
-	struct efx_rss_context *ctx;
-
-	WARN_ON(!mutex_is_locked(&efx->rss_lock));
-
-	list_for_each_entry(ctx, head, list)
-		if (ctx->user_id == id)
-			return ctx;
-	return NULL;
-}
-
-void efx_free_rss_context_entry(struct efx_rss_context *ctx)
-{
-	list_del(&ctx->list);
-	kfree(ctx);
-}
-
 /**************************************************************************
  *
  * PCI interface
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 2b417e779e82..4db56b356f11 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -26,8 +26,6 @@ extern unsigned int efx_piobuf_size;
 extern bool efx_separate_tx_channels;
 
 /* RX */
-void efx_set_default_rx_indir_table(struct efx_nic *efx,
-				    struct efx_rss_context *ctx);
 void __efx_rx_packet(struct efx_channel *channel);
 void efx_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
 		   unsigned int n_frags, unsigned int len, u16 flags);
@@ -195,9 +193,6 @@ void efx_rps_hash_del(struct efx_nic *efx, const struct efx_filter_spec *spec);
 #endif
 
 /* RSS contexts */
-struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx);
-struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id);
-void efx_free_rss_context_entry(struct efx_rss_context *ctx);
 static inline bool efx_rss_active(struct efx_rss_context *ctx)
 {
 	return ctx->context_id != EFX_EF10_RSS_CONTEXT_INVALID;
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 9c545d873d91..cdf21e2d5610 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -551,3 +551,68 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 
 	napi_gro_frags(napi);
 }
+
+/* RSS contexts.  We're using linked lists and crappy O(n) algorithms, because
+ * (a) this is an infrequent control-plane operation and (b) n is small (max 64)
+ */
+struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
+{
+	struct list_head *head = &efx->rss_context.list;
+	struct efx_rss_context *ctx, *new;
+	u32 id = 1; /* Don't use zero, that refers to the master RSS context */
+
+	WARN_ON(!mutex_is_locked(&efx->rss_lock));
+
+	/* Search for first gap in the numbering */
+	list_for_each_entry(ctx, head, list) {
+		if (ctx->user_id != id)
+			break;
+		id++;
+		/* Check for wrap.  If this happens, we have nearly 2^32
+		 * allocated RSS contexts, which seems unlikely.
+		 */
+		if (WARN_ON_ONCE(!id))
+			return NULL;
+	}
+
+	/* Create the new entry */
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return NULL;
+	new->context_id = EFX_EF10_RSS_CONTEXT_INVALID;
+	new->rx_hash_udp_4tuple = false;
+
+	/* Insert the new entry into the gap */
+	new->user_id = id;
+	list_add_tail(&new->list, &ctx->list);
+	return new;
+}
+
+struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id)
+{
+	struct list_head *head = &efx->rss_context.list;
+	struct efx_rss_context *ctx;
+
+	WARN_ON(!mutex_is_locked(&efx->rss_lock));
+
+	list_for_each_entry(ctx, head, list)
+		if (ctx->user_id == id)
+			return ctx;
+	return NULL;
+}
+
+void efx_free_rss_context_entry(struct efx_rss_context *ctx)
+{
+	list_del(&ctx->list);
+	kfree(ctx);
+}
+
+void efx_set_default_rx_indir_table(struct efx_nic *efx,
+				    struct efx_rss_context *ctx)
+{
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(ctx->rx_indir_table); i++)
+		ctx->rx_indir_table[i] =
+			ethtool_rxfh_indir_default(i, efx->rss_spread);
+}
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
index aa6aeafbc439..4d2e7d38e260 100644
--- a/drivers/net/ethernet/sfc/rx_common.h
+++ b/drivers/net/ethernet/sfc/rx_common.h
@@ -68,4 +68,10 @@ void efx_fast_push_rx_descriptors(struct efx_rx_queue *rx_queue, bool atomic);
 void
 efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 		  unsigned int n_frags, u8 *eh);
+
+struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx);
+struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id);
+void efx_free_rss_context_entry(struct efx_rss_context *ctx);
+void efx_set_default_rx_indir_table(struct efx_nic *efx,
+				    struct efx_rss_context *ctx);
 #endif
-- 
2.20.1


