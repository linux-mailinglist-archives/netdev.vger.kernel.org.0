Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4CA54D814
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358413AbiFPCH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350066AbiFPCHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:07:40 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FFB3558F;
        Wed, 15 Jun 2022 19:07:37 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id F306D20C32A4; Wed, 15 Jun 2022 19:07:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F306D20C32A4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1655345252;
        bh=Cigy/OCgOw9YbD2IF1NWqIEJyOfFXpbWeQHZ0IGWpgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=Ps7A3cFxEm1jMX8K3Fd/wZlpHXp54XMof/Mh6mgl1/mVNmOTKBcf1EywPpvQG8jzQ
         TAJ+BnRuoiKLh/LfPhJ9FkUEFN3hkE6t3IZzWUcl9wKyDsoaWZ1jSSFxXypNAErS7M
         hsQnOJBw/2dwJV+fZTkSCBakx755quwSGnzr7qCc=
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
Subject: [Patch v4 06/12] net: mana: Define data structures for protection domain and memory registration
Date:   Wed, 15 Jun 2022 19:07:14 -0700
Message-Id: <1655345240-26411-7-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
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
---
Change log:
v3: format/coding style changes

 drivers/net/ethernet/microsoft/mana/gdma.h    | 146 +++++++++++++++++-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  27 ++--
 drivers/net/ethernet/microsoft/mana/mana_en.c |  18 ++-
 3 files changed, 168 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index f945755760dc..b1bec8ab5695 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -27,6 +27,10 @@ enum gdma_request_type {
 	GDMA_CREATE_DMA_REGION		= 25,
 	GDMA_DMA_REGION_ADD_PAGES	= 26,
 	GDMA_DESTROY_DMA_REGION		= 27,
+	GDMA_CREATE_PD			= 29,
+	GDMA_DESTROY_PD			= 30,
+	GDMA_CREATE_MR			= 31,
+	GDMA_DESTROY_MR			= 32,
 };
 
 #define GDMA_RESOURCE_DOORBELL_PAGE	27
@@ -59,6 +63,8 @@ enum {
 	GDMA_DEVICE_MANA	= 2,
 };
 
+typedef u64 gdma_obj_handle_t;
+
 struct gdma_resource {
 	/* Protect the bitmap */
 	spinlock_t lock;
@@ -192,7 +198,7 @@ struct gdma_mem_info {
 	u64 length;
 
 	/* Allocated by the PF driver */
-	u64 gdma_region;
+	gdma_obj_handle_t dma_region_handle;
 };
 
 #define REGISTER_ATB_MST_MKEY_LOWER_SIZE 8
@@ -599,7 +605,7 @@ struct gdma_create_queue_req {
 	u32 reserved1;
 	u32 pdid;
 	u32 doolbell_id;
-	u64 gdma_region;
+	gdma_obj_handle_t gdma_region;
 	u32 reserved2;
 	u32 queue_size;
 	u32 log2_throttle_limit;
@@ -626,6 +632,28 @@ struct gdma_disable_queue_req {
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
+	GDMA_ACCESS_FLAG_LOCAL_READ = (1 << 0),
+	GDMA_ACCESS_FLAG_LOCAL_WRITE = (1 << 1),
+	GDMA_ACCESS_FLAG_REMOTE_READ = (1 << 2),
+	GDMA_ACCESS_FLAG_REMOTE_WRITE = (1 << 3),
+	GDMA_ACCESS_FLAG_REMOTE_ATOMIC = (1 << 4),
+};
+
 /* GDMA_CREATE_DMA_REGION */
 struct gdma_create_dma_region_req {
 	struct gdma_req_hdr hdr;
@@ -652,14 +680,14 @@ struct gdma_create_dma_region_req {
 
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
@@ -671,9 +699,114 @@ struct gdma_dma_region_add_pages_req {
 struct gdma_destroy_dma_region_req {
 	struct gdma_req_hdr hdr;
 
-	u64 gdma_region;
+	gdma_obj_handle_t dma_region_handle;
 }; /* HW DATA */
 
+enum gdma_pd_flags {
+	GDMA_PD_FLAG_ALLOW_GPA_MR = (1 << 0),
+	GDMA_PD_FLAG_ALLOW_FMR_MR = (1 << 1),
+};
+
+struct gdma_create_pd_req {
+	struct gdma_req_hdr hdr;
+	enum gdma_pd_flags flags;
+	u32 reserved;
+};
+
+struct gdma_create_pd_resp {
+	struct gdma_resp_hdr hdr;
+	gdma_obj_handle_t pd_handle;
+	u32 pd_id;
+	u32 reserved;
+};
+
+struct gdma_destroy_pd_req {
+	struct gdma_req_hdr hdr;
+	gdma_obj_handle_t pd_handle;
+};
+
+struct gdma_destory_pd_resp {
+	struct gdma_resp_hdr hdr;
+};
+
+enum gdma_mr_type {
+	/* Guest Physical Address - MRs of this type allow access
+	 * to any DMA-mapped memory using bus-logical address
+	 */
+	GDMA_MR_TYPE_GPA = 1,
+
+	/* Guest Virtual Address - MRs of this type allow access
+	 * to memory mapped by PTEs associated with this MR using a virtual
+	 * address that is set up in the MST
+	 */
+	GDMA_MR_TYPE_GVA,
+
+	/* Fast Memory Register - Like GVA but the MR is initially put in the
+	 * FREE state (as opposed to Valid), and the specified number of
+	 * PTEs are reserved for future fast memory reservations.
+	 */
+	GDMA_MR_TYPE_FMR,
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
+		struct {
+			enum gdma_mr_access_flags access_flags;
+		} gpa;
+		struct {
+			enum atb_page_size page_size;
+			u32  reserved_pte_count;
+		} fmr;
+	};
+};
+
+struct gdma_create_mr_request {
+	struct gdma_req_hdr hdr;
+	gdma_obj_handle_t pd_handle;
+	enum gdma_mr_type mr_type;
+	u32 reserved;
+
+	union {
+		struct {
+			enum gdma_mr_access_flags access_flags;
+		} gpa;
+
+		struct {
+			gdma_obj_handle_t dma_region_handle;
+			u64 virtual_address;
+			enum gdma_mr_access_flags access_flags;
+		} gva;
+
+		struct {
+			enum atb_page_size page_size;
+			u32 reserved_pte_count;
+		} fmr;
+	};
+};
+
+struct gdma_create_mr_response {
+	struct gdma_resp_hdr hdr;
+	gdma_obj_handle_t mr_handle;
+	u32 lkey;
+	u32 rkey;
+};
+
+struct gdma_destroy_mr_request {
+	struct gdma_req_hdr hdr;
+	gdma_obj_handle_t mr_handle;
+};
+
+struct gdma_destroy_mr_response {
+	struct gdma_resp_hdr hdr;
+};
+
 int mana_gd_verify_vf_version(struct pci_dev *pdev);
 
 int mana_gd_register_device(struct gdma_dev *gd);
@@ -705,4 +838,7 @@ int mana_gd_allocate_doorbell_page(struct gdma_context *gc, int *doorbell_page);
 
 int mana_gd_destroy_doorbell_page(struct gdma_context *gc, int doorbell_page);
 
+int mana_gd_destroy_dma_region(struct gdma_context *gc,
+			       gdma_obj_handle_t dma_region_handle);
+
 #endif /* _GDMA_H */
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 0c38c9a539f9..60cc1270b7d5 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -226,7 +226,7 @@ static int mana_gd_create_hw_eq(struct gdma_context *gc,
 	req.type = queue->type;
 	req.pdid = queue->gdma_dev->pdid;
 	req.doolbell_id = queue->gdma_dev->doorbell;
-	req.gdma_region = queue->mem_info.gdma_region;
+	req.gdma_region = queue->mem_info.dma_region_handle;
 	req.queue_size = queue->queue_size;
 	req.log2_throttle_limit = queue->eq.log2_throttle_limit;
 	req.eq_pci_msix_index = queue->eq.msix_index;
@@ -240,7 +240,7 @@ static int mana_gd_create_hw_eq(struct gdma_context *gc,
 
 	queue->id = resp.queue_index;
 	queue->eq.disable_needed = true;
-	queue->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
+	queue->mem_info.dma_region_handle = GDMA_INVALID_DMA_REGION;
 	return 0;
 }
 
@@ -694,24 +694,30 @@ int mana_gd_create_hwc_queue(struct gdma_dev *gd,
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
+EXPORT_SYMBOL(mana_gd_destroy_dma_region);
 
 static int mana_gd_create_dma_region(struct gdma_dev *gd,
 				     struct gdma_mem_info *gmi)
@@ -756,14 +762,15 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
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
@@ -886,7 +893,7 @@ void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue)
 		return;
 	}
 
-	mana_gd_destroy_dma_region(gc, gmi->gdma_region);
+	mana_gd_destroy_dma_region(gc, gmi->dma_region_handle);
 	mana_gd_free_memory(gmi);
 	kfree(queue);
 }
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 23e7e423a544..c18c358607a7 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1382,10 +1382,10 @@ static int mana_create_txq(struct mana_port_context *apc,
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
@@ -1400,8 +1400,10 @@ static int mana_create_txq(struct mana_port_context *apc,
 		txq->gdma_sq->id = wq_spec.queue_index;
 		cq->gdma_cq->id = cq_spec.queue_index;
 
-		txq->gdma_sq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
-		cq->gdma_cq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
+		txq->gdma_sq->mem_info.dma_region_handle =
+			GDMA_INVALID_DMA_REGION;
+		cq->gdma_cq->mem_info.dma_region_handle =
+			GDMA_INVALID_DMA_REGION;
 
 		txq->gdma_txq_id = txq->gdma_sq->id;
 
@@ -1612,10 +1614,10 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
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
@@ -1628,8 +1630,8 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	rxq->gdma_rq->id = wq_spec.queue_index;
 	cq->gdma_cq->id = cq_spec.queue_index;
 
-	rxq->gdma_rq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
-	cq->gdma_cq->mem_info.gdma_region = GDMA_INVALID_DMA_REGION;
+	rxq->gdma_rq->mem_info.dma_region_handle = GDMA_INVALID_DMA_REGION;
+	cq->gdma_cq->mem_info.dma_region_handle = GDMA_INVALID_DMA_REGION;
 
 	rxq->gdma_id = rxq->gdma_rq->id;
 	cq->gdma_id = cq->gdma_cq->id;
-- 
2.17.1

