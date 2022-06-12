Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C227547C37
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbiFLVP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbiFLVPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:15:18 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 293FD590B6;
        Sun, 12 Jun 2022 14:15:15 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 833E320C14B6; Sun, 12 Jun 2022 14:15:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 833E320C14B6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1655068515;
        bh=x1QcoU450lsj1EWNt9RFR2F0sIY35MmhbByrM4SKD8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=btoH6NQRGUIYmazGr7xV0u0KByeflr94l0BrTdc/zebk7Ql8IhaOsWDrZN2fM7rCU
         KEK6BYE+q6RyQ/6neoB2mS4NBXt03YOqNxDUV+Jcph8FfPHu+KLubDwmsqiewvmuAE
         Sy8Drgtu2p9ZtLEppKLrq0pbVGMiHSIyN4HSvkIQ=
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
Subject: [Patch v3 11/12] net: mana: Define and process GDMA response code GDMA_STATUS_MORE_ENTRIES
Date:   Sun, 12 Jun 2022 14:14:53 -0700
Message-Id: <1655068494-16440-12-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655068494-16440-1-git-send-email-longli@linuxonhyperv.com>
References: <1655068494-16440-1-git-send-email-longli@linuxonhyperv.com>
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

When doing memory registration, the PF may respond with
GDMA_STATUS_MORE_ENTRIES to indicate a follow request is needed. This is
not an error and should be processed as expected.

Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 2 +-
 include/net/mana/gdma.h                          | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index e61cb3f6fbe1..24ecd193a185 100644
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
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index ef5de92dd98d..0485902d96c9 100644
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

