Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD9E605314
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiJSWYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiJSWY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:24:27 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53988A44F;
        Wed, 19 Oct 2022 15:24:26 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 164AE20FEA38; Wed, 19 Oct 2022 15:24:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 164AE20FEA38
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1666218266;
        bh=jONrZhhKFLS3dleWg98wZ6FgVfueM2/7lN9acbPbclk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=O3Bpo+j/gs9KNLIGApIKuqGFHT25Gt+FjovdKSU44sMELkmsuamBOOQKvjq4Yj6rM
         i5Z/mYJrziaJbZN7nzgLU6AYoVoxElhY4w5w6kAHcnJn0QjVRdKxEn5lsz7BOUYRwe
         HjixD8OwCfno2P2yXtfpmiBAR44D/MnFYqVHSjD0=
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
Subject: [Patch v8 09/12] net: mana: Define and process GDMA response code GDMA_STATUS_MORE_ENTRIES
Date:   Wed, 19 Oct 2022 15:24:09 -0700
Message-Id: <1666218252-32191-10-git-send-email-longli@linuxonhyperv.com>
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

When doing memory registration, the PF may respond with
GDMA_STATUS_MORE_ENTRIES to indicate a follow request is needed. This is
not an error and should be processed as expected.

Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 2 +-
 include/net/mana/gdma.h                          | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 76829ab43d40..9d1507eba5b9 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -836,7 +836,7 @@ int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 		goto out;
 	}
 
-	if (ctx->status_code) {
+	if (ctx->status_code && ctx->status_code != GDMA_STATUS_MORE_ENTRIES) {
 		dev_err(hwc->dev, "HWC: Failed hw_channel req: 0x%x\n",
 			ctx->status_code);
 		err = -EPROTO;
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 0b0c0cd0b6bd..a9b7930dfbf8 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -9,6 +9,8 @@
 
 #include "shm_channel.h"
 
+#define GDMA_STATUS_MORE_ENTRIES	0x00000105
+
 /* Structures labeled with "HW DATA" are exchanged with the hardware. All of
  * them are naturally aligned and hence don't need __packed.
  */
-- 
2.17.1

