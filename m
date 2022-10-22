Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF75608290
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 02:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiJVACG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 20:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiJVABt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 20:01:49 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 441E626D902;
        Fri, 21 Oct 2022 17:01:43 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id DDB9F20FF4EE; Fri, 21 Oct 2022 17:01:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DDB9F20FF4EE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1666396901;
        bh=XCdAPyY3QKtJwrvrDmLBBK0K2ZN06sCmO+Hdg9ph1/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=faA+oiyAlFd7vGuIT2sfiAWGev0+Q8HkghW02Cha5wsLc9B22gKphi71HW1es33ka
         ATH6a53lvZmNZ7CV1HBv25C19dklB3Ul3D5j2fNeNMaTlKTxUcoec9jDkk3f8OyLWN
         +E1Lg2ORB2KTc0wwOguHnZoaYJquQM6IRclES/5Y=
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
Subject: [Patch v9 10/12] net: mana: Define data structures for allocating doorbell page from GDMA
Date:   Fri, 21 Oct 2022 17:01:27 -0700
Message-Id: <1666396889-31288-11-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666396889-31288-1-git-send-email-longli@linuxonhyperv.com>
References: <1666396889-31288-1-git-send-email-longli@linuxonhyperv.com>
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
v8: remove extra line in header file

 include/net/mana/gdma.h | 25 +++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index a9b7930dfbf8..055408a5baf3 100644
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
-- 
2.17.1

