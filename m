Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8905529D60
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244237AbiEQJFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244152AbiEQJEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:04:53 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 200F949686;
        Tue, 17 May 2022 02:04:51 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 04D6420F722B; Tue, 17 May 2022 02:04:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 04D6420F722B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1652778291;
        bh=/BppzPeZ494XyxOwZmPcGdJSVL9IuEWNVP2swpa6YwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=UzKmCnqtP+C8/NDVzNuDYFhjnFcAJ/d4S87kMjfimwOWDJLwxvfXJo6zFiSP3Qy8F
         x9KyTf9WOMWeeFaijFOzYpDhTe139Iu2/KyTtXKX+064YiBCBLdiwJkA1vEfYBcYLk
         7JzvDa92QExJK5dWaKNVcMNMlkNG7wLw4F5gCuW8=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [PATCH 07/12] net: mana: Export Work Queue functions for use by RDMA driver
Date:   Tue, 17 May 2022 02:04:31 -0700
Message-Id: <1652778276-2986-8-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
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

RDMA device may need to create Ethernet device queues for use by Queue
Pair type RAW. This allows a user-mode context accesses Ethernet hardware
queues. Export the supporting functions for use by the RDMA driver.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c |  1 +
 drivers/net/ethernet/microsoft/mana/mana.h      |  9 +++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c   | 16 +++++++++-------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 55c4059ac870..9c93d7a403ea 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -125,6 +125,7 @@ int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 
 	return mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
 }
+EXPORT_SYMBOL(mana_gd_send_request);
 
 int mana_gd_alloc_memory(struct gdma_context *gc, unsigned int length,
 			 struct gdma_mem_info *gmi)
diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 26f14fcb6a61..29e14ad8b930 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -568,6 +568,15 @@ struct mana_adev {
 	struct gdma_dev *mdev;
 };
 
+int mana_create_wq_obj(struct mana_port_context *apc,
+		       mana_handle_t vport,
+		       u32 wq_type, struct mana_obj_spec *wq_spec,
+		       struct mana_obj_spec *cq_spec,
+		       mana_handle_t *wq_obj);
+
+void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
+			 mana_handle_t wq_obj);
+
 int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
 		   u32 doorbell_pg_id);
 void mana_uncfg_vport(struct mana_port_context *apc);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index dc9fcb99e937..b4af85e81834 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -644,11 +644,11 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
 	return err;
 }
 
-static int mana_create_wq_obj(struct mana_port_context *apc,
-			      mana_handle_t vport,
-			      u32 wq_type, struct mana_obj_spec *wq_spec,
-			      struct mana_obj_spec *cq_spec,
-			      mana_handle_t *wq_obj)
+int mana_create_wq_obj(struct mana_port_context *apc,
+		       mana_handle_t vport,
+		       u32 wq_type, struct mana_obj_spec *wq_spec,
+		       struct mana_obj_spec *cq_spec,
+		       mana_handle_t *wq_obj)
 {
 	struct mana_create_wqobj_resp resp = {};
 	struct mana_create_wqobj_req req = {};
@@ -697,9 +697,10 @@ static int mana_create_wq_obj(struct mana_port_context *apc,
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(mana_create_wq_obj);
 
-static void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
-				mana_handle_t wq_obj)
+void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
+			 mana_handle_t wq_obj)
 {
 	struct mana_destroy_wqobj_resp resp = {};
 	struct mana_destroy_wqobj_req req = {};
@@ -724,6 +725,7 @@ static void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
 		netdev_err(ndev, "Failed to destroy WQ object: %d, 0x%x\n", err,
 			   resp.hdr.status);
 }
+EXPORT_SYMBOL_GPL(mana_destroy_wq_obj);
 
 static void mana_destroy_eq(struct mana_context *ac)
 {
-- 
2.17.1

