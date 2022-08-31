Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082C25A72A1
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 02:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiHaAfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 20:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiHaAfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 20:35:07 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1921BB46;
        Tue, 30 Aug 2022 17:34:45 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 8E4AD2045E30; Tue, 30 Aug 2022 17:34:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8E4AD2045E30
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1661906085;
        bh=CtZIhscJHRz1CQti5qDT6TZ/XyLLNkWFp5+uAHlbEjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=hAy5LDjSwvHiqdJDHxBO7IObb1BsIk8hzBD9tj6/v5yaCIWyNbyDY2mU1SjMdn/sN
         Skuv8cwtrl32Tfuzm1NxHZLH6Byw3eriTYmLwtVAd8/a0TcVsIjkoJb5ukLHdU35wF
         Ki76Eehymw2dqZuex3DBXN2fiqe/z3nlTawyM4FQ=
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
Subject: [Patch v5 09/12] net: mana: Define max values for SGL entries
Date:   Tue, 30 Aug 2022 17:34:28 -0700
Message-Id: <1661906071-29508-10-git-send-email-longli@linuxonhyperv.com>
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

The number of maximum SGl entries should be computed from the maximum
WQE size for the intended queue type and the corresponding OOB data
size. This guarantees the hardware queue can successfully queue requests
up to the queue depth exposed to the upper layer.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 2 +-
 include/net/mana/gdma.h                       | 7 +++++++
 include/net/mana/mana.h                       | 4 +---
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index ba776f73d7c9..2ca2a63afe6c 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -188,7 +188,7 @@ int mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	pkg.wqe_req.client_data_unit = 0;
 
 	pkg.wqe_req.num_sge = 1 + skb_shinfo(skb)->nr_frags;
-	WARN_ON_ONCE(pkg.wqe_req.num_sge > 30);
+	WARN_ON_ONCE(pkg.wqe_req.num_sge > MAX_TX_WQE_SGL_ENTRIES);
 
 	if (pkg.wqe_req.num_sge <= ARRAY_SIZE(pkg.sgl_array)) {
 		pkg.wqe_req.sgl = pkg.sgl_array;
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index f945755760dc..e9ad03ccc98b 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -430,6 +430,13 @@ struct gdma_wqe {
 #define MAX_TX_WQE_SIZE 512
 #define MAX_RX_WQE_SIZE 256
 
+#define MAX_TX_WQE_SGL_ENTRIES	((GDMA_MAX_SQE_SIZE -			   \
+			sizeof(struct gdma_sge) - INLINE_OOB_SMALL_SIZE) / \
+			sizeof(struct gdma_sge))
+
+#define MAX_RX_WQE_SGL_ENTRIES	((GDMA_MAX_RQE_SIZE -			   \
+			sizeof(struct gdma_sge)) / sizeof(struct gdma_sge))
+
 struct gdma_cqe {
 	u32 cqe_data[GDMA_COMP_DATA_SIZE / 4];
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index f0902f83045f..5ad548047ce0 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -263,8 +263,6 @@ struct mana_cq {
 	int budget;
 };
 
-#define GDMA_MAX_RQE_SGES 15
-
 struct mana_recv_buf_oob {
 	/* A valid GDMA work request representing the data buffer. */
 	struct gdma_wqe_request wqe_req;
@@ -274,7 +272,7 @@ struct mana_recv_buf_oob {
 
 	/* SGL of the buffer going to be sent has part of the work request. */
 	u32 num_sge;
-	struct gdma_sge sgl[GDMA_MAX_RQE_SGES];
+	struct gdma_sge sgl[MAX_RX_WQE_SGL_ENTRIES];
 
 	/* Required to store the result of mana_gd_post_work_request.
 	 * gdma_posted_wqe_info.wqe_size_in_bu is required for progressing the
-- 
2.17.1

