Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8E13A33E6
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhFJTZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhFJTZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:25:14 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB55C0617AD
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:23:18 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id x18so2891905ila.10
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZO4h+PYJOf6ZfOfwhNt7/7Z/XLn2xofEcctKVO8NNKs=;
        b=kW3vUZ34Jg0z7b8YWn5WOik7kunMU2bkK85BgKtIcOiZPG4VRqpj5Y9dCv7fb/7EIG
         0CPfmSBIItmGNF4ni4gSZ/VIsSMQNref054WRaGh3xhJB8Pna4/u27bBGe/t6/ZU2Vj4
         diUyLXA3BKhNQn8OJaYmwNcwMpDJ3ktNFJh/WCMHqACgUVGqgM3hh+7q7jPl2HLhEZU7
         th2gddESeNyzgbJGKvZeQIg7CEKVacq0Es6SAQcwf5aFP91c+vy7prFQeb8Adt/RAk6C
         Ye+D9XdueFYLCUEKrkQMFXAmYVzi+CYZcSPQkrPfU1nKH1iTYvMFvRycbOg+k1NJE9bT
         c23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZO4h+PYJOf6ZfOfwhNt7/7Z/XLn2xofEcctKVO8NNKs=;
        b=SFoYF2K7jsDUXRlqZpXfHeFKEkWTB+0JKdxbRpZYoLWTgaVZojb4NOzzu5DzmLnlJt
         OYhBM5TO43cdBHpYR7EDzQAWUJl/5A2IPD7Pr0Z48FuRroGav36oMYtSjukEkYf9nbml
         YpAr0+z43rOTgO4+K3iCNHLLOhgEFtirXGQa8wBf1AuGbmL3G5sSLb6G4JO6kQtPIOHz
         Oj5r2gw9xxGHeUaDDaHoA32XMdxr2i6qx5iPjBy+Np9mbyz9IoEAn9CvU60vYTo9WSaa
         KDNdX2NDr+pTJehMunvDBFDDh733FcS0J7m6I5pEB9g9Rm5XITsvylqt4DPiYuETuyZv
         K+Tg==
X-Gm-Message-State: AOAM5334V4JBJciypIQbbexVu3XiXMEbdRaIcF1waBmFVDjixs2wGMDi
        1xaOwPLsBP/kJCzFABb57u+9Qg==
X-Google-Smtp-Source: ABdhPJw6AQYL4X41gV2hfYbUd8Sv9roceSUw7Jv5IkGJN0QRwBCW1QVu5zCXdtI4TJE6outi8P7SZg==
X-Received: by 2002:a05:6e02:1068:: with SMTP id q8mr276336ilj.276.1623352997667;
        Thu, 10 Jun 2021 12:23:17 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w21sm2028684iol.52.2021.06.10.12.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:23:17 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/8] net: ipa: pass mem_id to ipa_table_reset_add()
Date:   Thu, 10 Jun 2021 14:23:05 -0500
Message-Id: <20210610192308.2739540-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210610192308.2739540-1-elder@linaro.org>
References: <20210610192308.2739540-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a memory region ID rather than the address of a memory region
descriptor to ipa_table_reset_add() to simplify callers.  Similarly,
pass memory region IDs to ipa_table_init_add().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_table.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 95a4c2aceb010..f7ee75bfba748 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -256,14 +256,15 @@ static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
 }
 
 static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
-				u16 first, u16 count, const struct ipa_mem *mem)
+				u16 first, u16 count, enum ipa_mem_id mem_id)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	const struct ipa_mem *mem = &ipa->mem[mem_id];
 	dma_addr_t addr;
 	u32 offset;
 	u16 size;
 
-	/* Nothing to do if the table memory regions is empty */
+	/* Nothing to do if the table memory region is empty */
 	if (!mem->size)
 		return;
 
@@ -284,7 +285,6 @@ static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
 static int
 ipa_filter_reset_table(struct ipa *ipa, enum ipa_mem_id mem_id, bool modem)
 {
-	const struct ipa_mem *mem = &ipa->mem[mem_id];
 	u32 ep_mask = ipa->filter_map;
 	u32 count = hweight32(ep_mask);
 	struct gsi_trans *trans;
@@ -309,7 +309,7 @@ ipa_filter_reset_table(struct ipa *ipa, enum ipa_mem_id mem_id, bool modem)
 		if (endpoint->ee_id != ee_id)
 			continue;
 
-		ipa_table_reset_add(trans, true, endpoint_id, 1, mem);
+		ipa_table_reset_add(trans, true, endpoint_id, 1, mem_id);
 	}
 
 	gsi_trans_commit_wait(trans);
@@ -367,15 +367,13 @@ static int ipa_route_reset(struct ipa *ipa, bool modem)
 		count = IPA_ROUTE_AP_COUNT;
 	}
 
+	ipa_table_reset_add(trans, false, first, count, IPA_MEM_V4_ROUTE);
 	ipa_table_reset_add(trans, false, first, count,
-			    &ipa->mem[IPA_MEM_V4_ROUTE]);
-	ipa_table_reset_add(trans, false, first, count,
-			    &ipa->mem[IPA_MEM_V4_ROUTE_HASHED]);
+			    IPA_MEM_V4_ROUTE_HASHED);
 
+	ipa_table_reset_add(trans, false, first, count, IPA_MEM_V6_ROUTE);
 	ipa_table_reset_add(trans, false, first, count,
-			    &ipa->mem[IPA_MEM_V6_ROUTE]);
-	ipa_table_reset_add(trans, false, first, count,
-			    &ipa->mem[IPA_MEM_V6_ROUTE_HASHED]);
+			    IPA_MEM_V6_ROUTE_HASHED);
 
 	gsi_trans_commit_wait(trans);
 
@@ -429,10 +427,12 @@ int ipa_table_hash_flush(struct ipa *ipa)
 
 static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
 			       enum ipa_cmd_opcode opcode,
-			       const struct ipa_mem *mem,
-			       const struct ipa_mem *hash_mem)
+			       enum ipa_mem_id mem_id,
+			       enum ipa_mem_id hash_mem_id)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	const struct ipa_mem *hash_mem = &ipa->mem[hash_mem_id];
+	const struct ipa_mem *mem = &ipa->mem[mem_id];
 	dma_addr_t hash_addr;
 	dma_addr_t addr;
 	u16 hash_count;
@@ -473,20 +473,16 @@ int ipa_table_setup(struct ipa *ipa)
 	}
 
 	ipa_table_init_add(trans, false, IPA_CMD_IP_V4_ROUTING_INIT,
-			   &ipa->mem[IPA_MEM_V4_ROUTE],
-			   &ipa->mem[IPA_MEM_V4_ROUTE_HASHED]);
+			   IPA_MEM_V4_ROUTE, IPA_MEM_V4_ROUTE_HASHED);
 
 	ipa_table_init_add(trans, false, IPA_CMD_IP_V6_ROUTING_INIT,
-			   &ipa->mem[IPA_MEM_V6_ROUTE],
-			   &ipa->mem[IPA_MEM_V6_ROUTE_HASHED]);
+			   IPA_MEM_V6_ROUTE, IPA_MEM_V6_ROUTE_HASHED);
 
 	ipa_table_init_add(trans, true, IPA_CMD_IP_V4_FILTER_INIT,
-			   &ipa->mem[IPA_MEM_V4_FILTER],
-			   &ipa->mem[IPA_MEM_V4_FILTER_HASHED]);
+			   IPA_MEM_V4_FILTER, IPA_MEM_V4_FILTER_HASHED);
 
 	ipa_table_init_add(trans, true, IPA_CMD_IP_V6_FILTER_INIT,
-			   &ipa->mem[IPA_MEM_V6_FILTER],
-			   &ipa->mem[IPA_MEM_V6_FILTER_HASHED]);
+			   IPA_MEM_V6_FILTER, IPA_MEM_V6_FILTER_HASHED);
 
 	gsi_trans_commit_wait(trans);
 
-- 
2.27.0

