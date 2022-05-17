Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80678529D5D
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbiEQJFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244028AbiEQJEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:04:54 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BDC448E75;
        Tue, 17 May 2022 02:04:54 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 23D9020F7230; Tue, 17 May 2022 02:04:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 23D9020F7230
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1652778294;
        bh=6RZGGvFWrSGpPbswEMH8aRsp+dxd1M1jw+kx4KN2h5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=ffSoI6UcZSsVkTrcMBtafR/4BW8d2IJSV1qpmR/cVAyh8+XyqnustFWw3s102uobi
         9vn163S4vzn/da5NOz55QBGKgS+DuMgznMryri5Dr8dallaGRZWRSmeYYoE7gPcEpJ
         vhoJWRmHcz3dEYDB6MZ+DB/H+bROUQssHS3i24OM=
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
Subject: [PATCH 11/12] net: mana: Define and process GDMA response code GDMA_STATUS_MORE_ENTRIES
Date:   Tue, 17 May 2022 02:04:35 -0700
Message-Id: <1652778276-2986-12-git-send-email-longli@linuxonhyperv.com>
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

When doing memory registration, the PF may respond with
GDMA_STATUS_MORE_ENTRIES to indicate a follow request is needed. This is
not an error and should be processed as expected.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 2 +-
 include/linux/mana/gdma.h                        | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 609cd714dcc0..a80c14676c75 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -820,7 +820,7 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 		goto out;
 	}
 
-	if (ctx->status_code) {
+	if (ctx->status_code && ctx->status_code != GDMA_STATUS_MORE_ENTRIES) {
 		dev_err(hwc->dev, "HWC: Failed hw_channel req: 0x%x\n",
 			ctx->status_code);
 		err = -EPROTO;
diff --git a/include/linux/mana/gdma.h b/include/linux/mana/gdma.h
index d6a970118f4c..d40f1dffca5c 100644
--- a/include/linux/mana/gdma.h
+++ b/include/linux/mana/gdma.h
@@ -9,6 +9,8 @@
 
 #include "shm_channel.h"
 
+#define GDMA_STATUS_MORE_ENTRIES	((u32)0x00000105L)
+
 /* Structures labeled with "HW DATA" are exchanged with the hardware. All of
  * them are naturally aligned and hence don't need __packed.
  */
-- 
2.17.1

