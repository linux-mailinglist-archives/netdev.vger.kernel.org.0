Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87FE54D7E3
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358264AbiFPCHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348886AbiFPCHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:07:37 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCC67116D;
        Wed, 15 Jun 2022 19:07:31 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id E4E0F20C327E; Wed, 15 Jun 2022 19:07:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E4E0F20C327E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1655345250;
        bh=IR+xHxrGtTrpXoE74WEAqbmgPYifyyXxBbYPDvxls8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=Ov/WRCwThR9Bh6JXlEh13Gxxpg+fNnP4mgssjGMn+LrlM4MutIA7hK1YoO+n3deTK
         6M9q+RgktDnJnJ8OlKNoF5ZC4tSnemgcma0Lr7v53I885UXmamyOx7RZkmF+KWUBgq
         m/HuEjYve/MiuE+w+Vt+Qf8M5ZcLr7W+fRCVg3u4=
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
Subject: [Patch v4 04/12] net: mana: Add functions for allocating doorbell page from GDMA
Date:   Wed, 15 Jun 2022 19:07:12 -0700
Message-Id: <1655345240-26411-5-git-send-email-longli@linuxonhyperv.com>
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

From: Long Li <longli@microsoft.com>

The RDMA device needs to allocate doorbell pages for each user context.
Implement those functions and expose them for use by the RDMA driver.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma.h    | 29 ++++++++++
 .../net/ethernet/microsoft/mana/gdma_main.c   | 56 +++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index c724ca410fcb..f945755760dc 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -22,11 +22,15 @@ enum gdma_request_type {
 	GDMA_GENERATE_TEST_EQE		= 10,
 	GDMA_CREATE_QUEUE		= 12,
 	GDMA_DISABLE_QUEUE		= 13,
+	GDMA_ALLOCATE_RESOURCE_RANGE	= 22,
+	GDMA_DESTROY_RESOURCE_RANGE	= 24,
 	GDMA_CREATE_DMA_REGION		= 25,
 	GDMA_DMA_REGION_ADD_PAGES	= 26,
 	GDMA_DESTROY_DMA_REGION		= 27,
 };
 
+#define GDMA_RESOURCE_DOORBELL_PAGE	27
+
 enum gdma_queue_type {
 	GDMA_INVALID_QUEUE,
 	GDMA_SQ,
@@ -568,6 +572,26 @@ struct gdma_register_device_resp {
 	u32 db_id;
 }; /* HW DATA */
 
+struct gdma_allocate_resource_range_req {
+	struct gdma_req_hdr hdr;
+	u32 resource_type;
+	u32 num_resources;
+	u32 alignment;
+	u32 allocated_resources;
+};
+
+struct gdma_allocate_resource_range_resp {
+	struct gdma_resp_hdr hdr;
+	u32 allocated_resources;
+};
+
+struct gdma_destroy_resource_range_req {
+	struct gdma_req_hdr hdr;
+	u32 resource_type;
+	u32 num_resources;
+	u32 allocated_resources;
+};
+
 /* GDMA_CREATE_QUEUE */
 struct gdma_create_queue_req {
 	struct gdma_req_hdr hdr;
@@ -676,4 +700,9 @@ void mana_gd_free_memory(struct gdma_mem_info *gmi);
 
 int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 			 u32 resp_len, void *resp);
+
+int mana_gd_allocate_doorbell_page(struct gdma_context *gc, int *doorbell_page);
+
+int mana_gd_destroy_doorbell_page(struct gdma_context *gc, int doorbell_page);
+
 #endif /* _GDMA_H */
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 9fafaa0c8e76..7b42b78b7ddf 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -153,6 +153,62 @@ void mana_gd_free_memory(struct gdma_mem_info *gmi)
 			  gmi->dma_handle);
 }
 
+int mana_gd_destroy_doorbell_page(struct gdma_context *gc, int doorbell_page)
+{
+	struct gdma_destroy_resource_range_req req = {};
+	struct gdma_resp_hdr resp = {};
+	int err;
+
+	mana_gd_init_req_hdr(&req.hdr, GDMA_DESTROY_RESOURCE_RANGE,
+			     sizeof(req), sizeof(resp));
+
+	req.resource_type = GDMA_RESOURCE_DOORBELL_PAGE;
+	req.num_resources = 1;
+	req.allocated_resources = doorbell_page;
+
+	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err || resp.status) {
+		dev_err(gc->dev,
+			"Failed to destroy doorbell page: ret %d, 0x%x\n",
+			err, resp.status);
+		return err ? err : -EPROTO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(mana_gd_destroy_doorbell_page);
+
+int mana_gd_allocate_doorbell_page(struct gdma_context *gc,
+				   int *doorbell_page)
+{
+	struct gdma_allocate_resource_range_req req = {};
+	struct gdma_allocate_resource_range_resp resp = {};
+	int err;
+
+	mana_gd_init_req_hdr(&req.hdr, GDMA_ALLOCATE_RESOURCE_RANGE,
+			     sizeof(req), sizeof(resp));
+
+	req.resource_type = GDMA_RESOURCE_DOORBELL_PAGE;
+	req.num_resources = 1;
+	req.alignment = 1;
+
+	/* Have GDMA start searching from 0 */
+	req.allocated_resources = 0;
+
+	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
+	if (err || resp.hdr.status) {
+		dev_err(gc->dev,
+			"Failed to allocate doorbell page: ret %d, 0x%x\n",
+			err, resp.hdr.status);
+		return err ? err : -EPROTO;
+	}
+
+	*doorbell_page = resp.allocated_resources;
+
+	return 0;
+}
+EXPORT_SYMBOL(mana_gd_allocate_doorbell_page);
+
 static int mana_gd_create_hw_eq(struct gdma_context *gc,
 				struct gdma_queue *queue)
 {
-- 
2.17.1

