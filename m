Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5972272C8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbfEVXNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:13:13 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42424 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729591AbfEVXNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:13:11 -0400
Received: by mail-pl1-f195.google.com with SMTP id go2so1772487plb.9
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z3IIYySHh6QCI1uOh3m2ijGeXTemP9G7BVzmSADHR+k=;
        b=TsGLlcwgnRcEob3k/n2lb3vH8pHKv0eEb5DPqMQgSkuSveTW62eiVER/NXV7vKDJAW
         pACfAo7np2T4CzCqIqZQ04wq15PGnAnrkx/Yn4zwsrVboiHP0dgG7Oi4460maoXtU3ZZ
         MaIr3Wkww6CimYYDiOVrmEQqNROk8vYd0WnJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z3IIYySHh6QCI1uOh3m2ijGeXTemP9G7BVzmSADHR+k=;
        b=IlzPR6Vk16py9reNa3MghCEn2W+5w6wNjkx0VZ77noS0J7DnCBgvQQuf6lyx2jmRoO
         uGYYTt83J8mfpsSwgTDw5eKU7Dd6VN2buQFMMMdaFn/sLoeZf9/yZLt9cTInNG34htHv
         7BocdXgaUjv9kVeC7RyOC9mFKsj8d4UWrrvCH1mkVK4IhPdYESUCZDOYGlRFvfR/EBGH
         oqauHiGyU/L17l6EaRX7YVig+l2V1p/2iKu4mSFEQm93sZpBr3Sh85rP3ParvjxietFx
         oKnMBXe2soo4HZ+ws5kFQJlq1fsh3S5WtjE/w9ebY2lES+Z3TXhkLYRBDLiJ8v4N+NCs
         6OVA==
X-Gm-Message-State: APjAAAXUSeUdKS7DioAKMfrIuA7Jd6BAeHiO3wx9sSo8ehtY7pYNX1r8
        zW0AJoB/Be7M08YnvZphX4TXQu1qrpc=
X-Google-Smtp-Source: APXvYqxkfM0wITIQ5HPXzZJLVqdDUPCYXH6SFoAQ00+Jx9DPaGFB4DZ1J7p/3pFcfzswvft0N+Dlog==
X-Received: by 2002:a17:902:9693:: with SMTP id n19mr92803176plp.92.1558566791153;
        Wed, 22 May 2019 16:13:11 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q20sm27750419pgq.66.2019.05.22.16.13.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 16:13:10 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 3/4] bnxt_en: Reduce memory usage when running in kdump kernel.
Date:   Wed, 22 May 2019 19:12:56 -0400
Message-Id: <1558566777-23429-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1558566777-23429-1-git-send-email-michael.chan@broadcom.com>
References: <1558566777-23429-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Skip RDMA context memory allocations, reduce to 1 ring, and disable
TPA when running in the kdump kernel.  Without this patch, the driver
fails to initialize with memory allocation errors when running in a
typical kdump kernel.

Fixes: cf6daed098d1 ("bnxt_en: Increase context memory allocations on 57500 chips for RDMA.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cfcc33c..79812da 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6379,7 +6379,7 @@ static int bnxt_alloc_ctx_mem(struct bnxt *bp)
 	if (!ctx || (ctx->flags & BNXT_CTX_FLAG_INITED))
 		return 0;
 
-	if (bp->flags & BNXT_FLAG_ROCE_CAP) {
+	if ((bp->flags & BNXT_FLAG_ROCE_CAP) && !is_kdump_kernel()) {
 		pg_lvl = 2;
 		extra_qps = 65536;
 		extra_srqs = 8192;
@@ -10437,7 +10437,7 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 
 	if (sh)
 		bp->flags |= BNXT_FLAG_SHARED_RINGS;
-	dflt_rings = netif_get_num_default_rss_queues();
+	dflt_rings = is_kdump_kernel() ? 1 : netif_get_num_default_rss_queues();
 	/* Reduce default rings on multi-port cards so that total default
 	 * rings do not exceed CPU count.
 	 */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index acc73f3..be438d8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -20,6 +20,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/rhashtable.h>
+#include <linux/crash_dump.h>
 #include <net/devlink.h>
 #include <net/dst_metadata.h>
 #include <net/xdp.h>
@@ -1369,7 +1370,8 @@ struct bnxt {
 #define BNXT_CHIP_TYPE_NITRO_A0(bp) ((bp)->flags & BNXT_FLAG_CHIP_NITRO_A0)
 #define BNXT_RX_PAGE_MODE(bp)	((bp)->flags & BNXT_FLAG_RX_PAGE_MODE)
 #define BNXT_SUPPORTS_TPA(bp)	(!BNXT_CHIP_TYPE_NITRO_A0(bp) &&	\
-				 !(bp->flags & BNXT_FLAG_CHIP_P5))
+				 !(bp->flags & BNXT_FLAG_CHIP_P5) &&	\
+				 !is_kdump_kernel())
 
 /* Chip class phase 5 */
 #define BNXT_CHIP_P5(bp)			\
-- 
2.5.1

