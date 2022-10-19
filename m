Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B115360531F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiJSWYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiJSWY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:24:29 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2414CDF0B;
        Wed, 19 Oct 2022 15:24:27 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id F29B820FEA4A; Wed, 19 Oct 2022 15:24:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F29B820FEA4A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1666218267;
        bh=OhaOdiSYohgjWcpV3xvKysL692TUPrtrmeWzwryShrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=fAhmB1ViSRgbNeJA1SDiSWyenYYKA8wEVkDma73WcR20wIN+5atsESCwTI3XU9pfX
         dLaT5eQ6Wo4p8r899JhB/A4jAaGWKCoVbvSURZrMIxIhGUT7oUpROMWQBMPDZyxR78
         IXqOoCCbvwJVQtQjmKKVDCooNxPOTQx2/otTY7+o=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [Patch v8 11/12] net: mana: Define data structures for protection domain and memory registration
Date:   Wed, 19 Oct 2022 15:24:11 -0700
Message-Id: <1666218252-32191-12-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
References: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Sharma <sharmaajay@microsoft.com>

The MANA hardware support protection domain and memory registration for use
in RDMA environment. Add those definitions and expose them for use by the
RDMA driver.

Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
---
Change log:
v3: format/coding style changes
v5: remove unused code dealing with kernel-mode MR

 .../net/ethernet/microsoft/mana/gdma_main.c   |  27 ++--
 drivers/net/ethernet/microsoft/mana/mana_en.c |  18 +--
 include/net/mana/gdma.h                       | 121 +++++++++++++++++-
 3 files changed, 143 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 93847ed0e4b3..fae7a93c77f0 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -198,7 +198,7 @@ static int mana_gd_create_hw_eq(struct gdma_context *gc,
 	req.type = queue->type;
 	req.pdid = queue->gdma_dev->pdid;
 	req.doolbell_id = queue->gdma_dev->doorbell;
-	req.gdma_region = queue->mem_info.gdma_region;
+	req.gdma_region = queue->mem_info.dma_region_handle;
 	req.queue_size = queue->queue_size;
 	req.log2_throttle_limit = queue->eq.log2_throttle_limit;
 	req.eq_pci_msix_index = queue->eq.msix_index;
@@ -212,7 +212,7 @@ static int mana_gd_create_hw_eq(struct gdma_context *gc,
 
 	queue->id = resp.queue_index;
 	queue->eq.disable_needed = true;
-	queue->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
+	queue->mem_info.dma_region_handle = GDMA_INVALID_DMA_REGION;
 	return 0;
 }
 
@@ -666,24 +666,30 @@ int mana_gd_create_hwc_queue(struct gdma_dev *gd,
 	return err;
 }
 
-static void mana_gd_destroy_dma_region(struct gdma_context *gc, u64 gdma_region)
+int mana_gd_destroy_dma_region(struct gdma_context *gc,
+			       gdma_obj_handle_t dma_region_handle)
 {
 	struct gdma_destroy_dma_region_req req = {};
 	struct gdma_general_resp resp = {};
 	int err;
 
-	if (gdma_region == GDMA_INVALID_DMA_REGION)
-		return;
+	if (dma_region_handle == GDMA_INVALID_DMA_REGION)
+		return 0;
 
 	mana_gd_init_req_hdr(&req.hdr, GDMA_DESTROY_DMA_REGION, sizeof(req),
 			     sizeof(resp));
-	req.gdma_region = gdma_region;
+	req.dma_region_handle = dma_region_handle;
 
 	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
-	if (err || resp.hdr.status)
+	if (err || resp.hdr.status) {
 		dev_err(gc->dev, "Failed to destroy DMA region: %d, 0x%x\n",
 			err, resp.hdr.status);
+		return -EPROTO;
+	}
+
+	return 0;
 }
+EXPORT_SYMBOL_NS(mana_gd_destroy_dma_region, NET_MANA);
 
 static int mana_gd_create_dma_region(struct gdma_dev *gd,
 				     struct gdma_mem_info *gmi)
@@ -728,14 +734,15 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 	if (err)
 		goto out;
 
-	if (resp.hdr.status || resp.gdma_region == GDMA_INVALID_DMA_REGION) {
+	if (resp.hdr.status ||
+	    resp.dma_region_handle == GDMA_INVALID_DMA_REGION) {
 		dev_err(gc->dev, "Failed to create DMA region: 0x%x\n",
 			resp.hdr.status);
 		err = -EPROTO;
 		goto out;
 	}
 
-	gmi->gdma_region = resp.gdma_region;
+	gmi->dma_region_handle = resp.dma_region_handle;
 out:
 	kfree(req);
 	return err;
@@ -858,7 +865,7 @@ void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue)
 		return;
 	}
 
-	mana_gd_destroy_dma_region(gc, gmi->gdma_region);
+	mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
 	mana_gd_free_memory(gmi);
 	kfree(queue);
 }
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index f6bcd0cc6cda..1c59502d34b5 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1523,10 +1523,10 @@ static int mana_create_txq(struct mana_port_context *apc,
 		memset(&wq_spec, 0, sizeof(wq_spec));
 		memset(&cq_spec, 0, sizeof(cq_spec));
 
-		wq_spec.gdma_region = txq->gdma_sq->mem_info.gdma_region;
+		wq_spec.gdma_region = txq->gdma_sq->mem_info.dma_region_handle;
 		wq_spec.queue_size = txq->gdma_sq->queue_size;
 
-		cq_spec.gdma_region = cq->gdma_cq->mem_info.gdma_region;
+		cq_spec.gdma_region = cq->gdma_cq->mem_info.dma_region_handle;
 		cq_spec.queue_size = cq->gdma_cq->queue_size;
 		cq_spec.modr_ctx_id = 0;
 		cq_spec.attached_eq = cq->gdma_cq->cq.parent->id;
@@ -1541,8 +1541,10 @@ static int mana_create_txq(struct mana_port_context *apc,
 		txq->gdma_sq->id = wq_spec.queue_index;
 		cq->gdma_cq->id = cq_spec.queue_index;
 
-		txq->gdma_sq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
-		cq->gdma_cq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
+		txq->gdma_sq->mem_info.dma_region_handle =
+			GDMA_INVALID_DMA_REGION;
+		cq->gdma_cq->mem_info.dma_region_handle =
+			GDMA_INVALID_DMA_REGION;
 
 		txq->gdma_txq_id = txq->gdma_sq->id;
 
@@ -1753,10 +1755,10 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	memset(&wq_spec, 0, sizeof(wq_spec));
 	memset(&cq_spec, 0, sizeof(cq_spec));
-	wq_spec.gdma_region = rxq->gdma_rq->mem_info.gdma_region;
+	wq_spec.gdma_region = rxq->gdma_rq->mem_info.dma_region_handle;
 	wq_spec.queue_size = rxq->gdma_rq->queue_size;
 
-	cq_spec.gdma_region = cq->gdma_cq->mem_info.gdma_region;
+	cq_spec.gdma_region = cq->gdma_cq->mem_info.dma_region_handle;
 	cq_spec.queue_size = cq->gdma_cq->queue_size;
 	cq_spec.modr_ctx_id = 0;
 	cq_spec.attached_eq = cq->gdma_cq->cq.parent->id;
@@ -1769,8 +1771,8 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	rxq->gdma_rq->id = wq_spec.queue_index;
 	cq->gdma_cq->id = cq_spec.queue_index;
 
-	rxq->gdma_rq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
-	cq->gdma_cq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
+	rxq->gdma_rq->mem_info.dma_region_handle = GDMA_INVALID_DMA_REGION;
+	cq->gdma_cq->mem_info.dma_region_handle = GDMA_INVALID_DMA_REGION;
 
 	rxq->gdma_id = rxq->gdma_rq->id;
 	cq->gdma_id = cq->gdma_cq->id;
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 055408a5baf3..221adc96340c 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -29,6 +29,10 @@ enum gdma_request_type {
 	GDMA_CREATE_DMA_REGION		= 25,
 	GDMA_DMA_REGION_ADD_PAGES	= 26,
 	GDMA_DESTROY_DMA_REGION		= 27,
+	GDMA_CREATE_PD			= 29,
+	GDMA_DESTROY_PD			= 30,
+	GDMA_CREATE_MR			= 31,
+	GDMA_DESTROY_MR			= 32,
 };
 
 #define GDMA_RESOURCE_DOORBELL_PAGE	27
@@ -61,6 +65,8 @@ enum {
 	GDMA_DEVICE_MANA	= 2,
 };
 
+typedef u64 gdma_obj_handle_t;
+
 struct gdma_resource {
 	/* Protect the bitmap */
 	spinlock_t lock;
@@ -194,7 +200,7 @@ struct gdma_mem_info {
 	u64 length;
 
 	/* Allocated by the PF driver */
-	u64 gdma_region;
+	gdma_obj_handle_t dma_region_handle;
 };
 
 #define REGISTER_ATB_MST_MKEY_LOWER_SIZE 8
@@ -618,7 +624,7 @@ struct gdma_create_queue_req {
 	u32 reserved1;
 	u32 pdid;
 	u32 doolbell_id;
-	u64 gdma_region;
+	gdma_obj_handle_t gdma_region;
 	u32 reserved2;
 	u32 queue_size;
 	u32 log2_throttle_limit;
@@ -645,6 +651,28 @@ struct gdma_disable_queue_req {
 	u32 alloc_res_id_on_creation;
 }; /* HW DATA */
 
+enum atb_page_size {
+	ATB_PAGE_SIZE_4K,
+	ATB_PAGE_SIZE_8K,
+	ATB_PAGE_SIZE_16K,
+	ATB_PAGE_SIZE_32K,
+	ATB_PAGE_SIZE_64K,
+	ATB_PAGE_SIZE_128K,
+	ATB_PAGE_SIZE_256K,
+	ATB_PAGE_SIZE_512K,
+	ATB_PAGE_SIZE_1M,
+	ATB_PAGE_SIZE_2M,
+	ATB_PAGE_SIZE_MAX,
+};
+
+enum gdma_mr_access_flags {
+	GDMA_ACCESS_FLAG_LOCAL_READ = BIT_ULL(0),
+	GDMA_ACCESS_FLAG_LOCAL_WRITE = BIT_ULL(1),
+	GDMA_ACCESS_FLAG_REMOTE_READ = BIT_ULL(2),
+	GDMA_ACCESS_FLAG_REMOTE_WRITE = BIT_ULL(3),
+	GDMA_ACCESS_FLAG_REMOTE_ATOMIC = BIT_ULL(4),
+};
+
 /* GDMA_CREATE_DMA_REGION */
 struct gdma_create_dma_region_req {
 	struct gdma_req_hdr hdr;
@@ -671,14 +699,14 @@ struct gdma_create_dma_region_req {
 
 struct gdma_create_dma_region_resp {
 	struct gdma_resp_hdr hdr;
-	u64 gdma_region;
+	gdma_obj_handle_t dma_region_handle;
 }; /* HW DATA */
 
 /* GDMA_DMA_REGION_ADD_PAGES */
 struct gdma_dma_region_add_pages_req {
 	struct gdma_req_hdr hdr;
 
-	u64 gdma_region;
+	gdma_obj_handle_t dma_region_handle;
 
 	u32 page_addr_list_len;
 	u32 reserved3;
@@ -690,9 +718,88 @@ struct gdma_dma_region_add_pages_req {
 struct gdma_destroy_dma_region_req {
 	struct gdma_req_hdr hdr;
 
-	u64 gdma_region;
+	gdma_obj_handle_t dma_region_handle;
 }; /* HW DATA */
 
+enum gdma_pd_flags {
+	GDMA_PD_FLAG_INVALID = 0,
+};
+
+struct gdma_create_pd_req {
+	struct gdma_req_hdr hdr;
+	enum gdma_pd_flags flags;
+	u32 reserved;
+};/* HW DATA */
+
+struct gdma_create_pd_resp {
+	struct gdma_resp_hdr hdr;
+	gdma_obj_handle_t pd_handle;
+	u32 pd_id;
+	u32 reserved;
+};/* HW DATA */
+
+struct gdma_destroy_pd_req {
+	struct gdma_req_hdr hdr;
+	gdma_obj_handle_t pd_handle;
+};/* HW DATA */
+
+struct gdma_destory_pd_resp {
+	struct gdma_resp_hdr hdr;
+};/* HW DATA */
+
+enum gdma_mr_type {
+	/* Guest Virtual Address - MRs of this type allow access
+	 * to memory mapped by PTEs associated with this MR using a virtual
+	 * address that is set up in the MST
+	 */
+	GDMA_MR_TYPE_GVA = 2,
+};
+
+struct gdma_create_mr_params {
+	gdma_obj_handle_t pd_handle;
+	enum gdma_mr_type mr_type;
+	union {
+		struct {
+			gdma_obj_handle_t dma_region_handle;
+			u64 virtual_address;
+			enum gdma_mr_access_flags access_flags;
+		} gva;
+	};
+};
+
+struct gdma_create_mr_request {
+	struct gdma_req_hdr hdr;
+	gdma_obj_handle_t pd_handle;
+	enum gdma_mr_type mr_type;
+	u32 reserved_1;
+
+	union {
+		struct {
+			gdma_obj_handle_t dma_region_handle;
+			u64 virtual_address;
+			enum gdma_mr_access_flags access_flags;
+		} gva;
+
+	};
+	u32 reserved_2;
+};/* HW DATA */
+
+struct gdma_create_mr_response {
+	struct gdma_resp_hdr hdr;
+	gdma_obj_handle_t mr_handle;
+	u32 lkey;
+	u32 rkey;
+};/* HW DATA */
+
+struct gdma_destroy_mr_request {
+	struct gdma_req_hdr hdr;
+	gdma_obj_handle_t mr_handle;
+};/* HW DATA */
+
+struct gdma_destroy_mr_response {
+	struct gdma_resp_hdr hdr;
+};/* HW DATA */
+
 int mana_gd_verify_vf_version(struct pci_dev *pdev);
 
 int mana_gd_register_device(struct gdma_dev *gd);
@@ -719,4 +826,8 @@ void mana_gd_free_memory(struct gdma_mem_info *gmi);
 
 int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 			 u32 resp_len, void *resp);
+
+int mana_gd_destroy_dma_region(struct gdma_context *gc,
+			       gdma_obj_handle_t dma_region_handle);
+
 #endif /* _GDMA_H */
-- 
2.17.1

