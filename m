Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A745A7298
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 02:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiHaAfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 20:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiHaAeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 20:34:46 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 124CBBC4;
        Tue, 30 Aug 2022 17:34:44 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id EBE022045E2B; Tue, 30 Aug 2022 17:34:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EBE022045E2B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1661906083;
        bh=HtxpNhH+H5wUbWfJokqUpF/2aUNQmLJn4KCHYfFBwJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=HOEAdX/Z6gW161Qk3fBOdjZdGSsp5CJuaju8Htcm/+ymcPtNeXmvI5mujZoMyQwNo
         OpHjFCCyIUwI26f7JAwJUaFQcgXURltNnFVqvCAl0opPrQ5+YhwkiQSSr7PoVd60Bb
         d4U8cTaIabRudMVsOZTn30ElsOG2LlWPsVadqrgA=
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
Subject: [Patch v5 06/12] net: mana: Export Work Queue functions for use by RDMA driver
Date:   Tue, 30 Aug 2022 17:34:25 -0700
Message-Id: <1661906071-29508-7-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
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

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
---
Change log:
v3: format/coding style changes
v5: remove unused defintions, use EXPORT_SYMBOL_NS, rearrange some defintions to a later patch in the series

 drivers/net/ethernet/microsoft/mana/gdma_main.c |  1 +
 drivers/net/ethernet/microsoft/mana/mana.h      |  9 +++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c   | 16 +++++++++-------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 9a1885e47766..2bd9bf624eb3 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -125,6 +125,7 @@ int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 
 	return mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
 }
+EXPORT_SYMBOL_NS(mana_gd_send_request, NET_MANA);
 
 int mana_gd_alloc_memory(struct gdma_context *gc, unsigned int length,
 			 struct gdma_mem_info *gmi)
diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 2643036ee3e0..f0902f83045f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -565,6 +565,15 @@ struct mana_tx_package {
 	struct gdma_posted_wqe_info wqe_info;
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
index f0bd0efd0b6a..4c771ce59108 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -677,11 +677,11 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
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
@@ -730,9 +730,10 @@ static int mana_create_wq_obj(struct mana_port_context *apc,
 out:
 	return err;
 }
+EXPORT_SYMBOL_NS(mana_create_wq_obj, NET_MANA);
 
-static void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
-				mana_handle_t wq_obj)
+void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
+			 mana_handle_t wq_obj)
 {
 	struct mana_destroy_wqobj_resp resp = {};
 	struct mana_destroy_wqobj_req req = {};
@@ -757,6 +758,7 @@ static void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
 		netdev_err(ndev, "Failed to destroy WQ object: %d, 0x%x\n", err,
 			   resp.hdr.status);
 }
+EXPORT_SYMBOL_NS(mana_destroy_wq_obj, NET_MANA);
 
 static void mana_destroy_eq(struct mana_context *ac)
 {
-- 
2.17.1

