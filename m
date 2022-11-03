Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04D0618898
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 20:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiKCTSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 15:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiKCTQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 15:16:57 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 661E21FCC7;
        Thu,  3 Nov 2022 12:16:56 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 4B7CC205DA44; Thu,  3 Nov 2022 12:16:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4B7CC205DA44
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1667503016;
        bh=VZLU6TkFNRW5iAmkrZyBMdtSidOZ/oflWZp0XwAvTYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=OXn7B0VBBUOP4BFd2hlUmFaC8hWqxcIhI8pjMeDz1Or+/8I7ym6VmmAc+HFA50WWa
         z8RPmaPIWd6oytlW26EW4PDwrKPOx7rTMfxd01p/x6SsqIKa/jsFvxiVQSYwrdQCWT
         zUOYKoXyYPz0+Bc9wMymiXMlATDSf7r126uMiE+A=
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
Subject: [Patch v10 05/12] net: mana: Export Work Queue functions for use by RDMA driver
Date:   Thu,  3 Nov 2022 12:16:23 -0700
Message-Id: <1667502990-2559-6-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
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

RDMA device may need to create Ethernet device queues for use by Queue
Pair type RAW. This allows a user-mode context accesses Ethernet hardware
queues. Export the supporting functions for use by the RDMA driver.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
---
Change log:
v3: format/coding style changes
v5: remove unused defintions, use EXPORT_SYMBOL_NS, rearrange some defintions to a later patch in the series

 drivers/net/ethernet/microsoft/mana/gdma_main.c |  1 +
 drivers/net/ethernet/microsoft/mana/mana.h      |  9 +++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c   | 16 +++++++++-------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 4f041b27c07d..aab22911f20d 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -152,6 +152,7 @@ int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 
 	return mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
 }
+EXPORT_SYMBOL_NS(mana_gd_send_request, NET_MANA);
 
 int mana_gd_alloc_memory(struct gdma_context *gc, unsigned int length,
 			 struct gdma_mem_info *gmi)
diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 2883a08dbfb5..6e9e86fb4c02 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -635,6 +635,15 @@ struct mana_tx_package {
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
index efe14a343fd1..6ad4bc8cbc99 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -792,11 +792,11 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
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
@@ -845,9 +845,10 @@ static int mana_create_wq_obj(struct mana_port_context *apc,
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
@@ -872,6 +873,7 @@ static void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
 		netdev_err(ndev, "Failed to destroy WQ object: %d, 0x%x\n", err,
 			   resp.hdr.status);
 }
+EXPORT_SYMBOL_NS(mana_destroy_wq_obj, NET_MANA);
 
 static void mana_destroy_eq(struct mana_context *ac)
 {
-- 
2.17.1

