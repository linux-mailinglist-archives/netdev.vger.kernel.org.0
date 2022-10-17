Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9481601760
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiJQTV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiJQTVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:21:02 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03F4274B9B;
        Mon, 17 Oct 2022 12:20:56 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 64A9420FE028; Mon, 17 Oct 2022 12:20:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 64A9420FE028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1666034456;
        bh=A8fxUD/nTCAqIoM1mcUZ00zFIWg8IfK6iVDQEpa0CEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=l9NkBblHyXCR+bOA3ZQItM0wEvL6Bt2uBjYQwFtIo8wcnSrBDHg3LN5aOK2R5pNex
         qzRE93yMzULau694eLtSnwxB4VJm4sbLPNRjYQq+mlWFfyYlIWgv/NXiSveBD5eqi1
         zZOV4Jkh0S9d3l4pMDxgCZGA1959E7dCDRSCkBdU=
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
Subject: [Patch v7 10/12] net: mana: Define data structures for allocating doorbell page from GDMA
Date:   Mon, 17 Oct 2022 12:20:39 -0700
Message-Id: <1666034441-15424-11-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666034441-15424-1-git-send-email-longli@linuxonhyperv.com>
References: <1666034441-15424-1-git-send-email-longli@linuxonhyperv.com>
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

From: Long Li <longli@microsoft.com>

The RDMA device needs to allocate doorbell pages for each user context.
Define the GDMA data structures for use by the RDMA driver.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
---
Change log:
v4: use EXPORT_SYMBOL_NS
v7: move mana_gd_allocate_doorbell_page() and mana_gd_destroy_doorbell_page() to the RDMA driver

 include/net/mana/gdma.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index a9b7930dfbf8..bc060b6fa54c 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -24,11 +24,15 @@ enum gdma_request_type {
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
@@ -587,6 +591,26 @@ struct gdma_register_device_resp {
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
@@ -695,4 +719,5 @@ void mana_gd_free_memory(struct gdma_mem_info *gmi);
 
 int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 			 u32 resp_len, void *resp);
+
 #endif /* _GDMA_H */
-- 
2.17.1

