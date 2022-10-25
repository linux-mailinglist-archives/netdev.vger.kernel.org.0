Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BDB60D4F9
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 21:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiJYTwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 15:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbiJYTv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 15:51:58 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59978106E06
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 12:51:52 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id o65so11422591iof.4
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 12:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l133zv+Dip4+RVfo1hNbK6ZAuTDbPpUv6wOODnCUtFU=;
        b=wtLM9Ns/jhaQnCQdl/vOr8eYMTtqTnnamG9PlzaLFmyAlerQ7Mnaa6o8H5ozhq/2CU
         5z++B95jLsiNl2EAJ3NhGwvdx/TYDMxKs3ewOfFFU+H9qVLPBpqYGVRDl9fIDsGp6/FH
         tbpRL6KF/OVeAtXYutYcVkb0+0pQTVvU+8T4GrMtYfIebGIHycj9Hikernak6+8FdQai
         0fAZJTY4iP/KV7asVxxw4SGWZjQz4YvZYdbQ831Xtbe618HSeAoFGFPvm6S0RC2wNo+d
         G9hDIDbgPWwy4yk3R+1/H4AxHegL1YTKRDSxcaPa78tDKCPVC5F1gffLa2HXV7l5/FLR
         hspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l133zv+Dip4+RVfo1hNbK6ZAuTDbPpUv6wOODnCUtFU=;
        b=ofNU3s+J2YrimXLCcfuzxszPBKV8KwO6Lvbfxv0rObiIrZ4iqLnA/N0CMR8lSnm1X0
         5Lm72b1aMUxgkRfgIXesBZ0LGsx5L+2eJZzoNwBETgONkHQ7s2xiy0a4LYD5LCrt8p4c
         EvmdP09mzR8JX/5jk8h1er36sr8TvMzJq3MwIdxJsBW+LU9U+lApBsQDUWpEqp3knzxE
         ehWdw8oy7O2+g5SdQ16c7ZrpARAZgGzdgN9qwZDigPT5wT/jdGeBQdZrdwxiHY7zESwl
         XYO5My6EQXIkIOPyAMsnsXXdMyJufuE04vPAJ37+DoB13vxv5KLL7N9v7ulUU/+6iFTg
         HNhA==
X-Gm-Message-State: ACrzQf0YlUayAj/DtZaiLysWqtitgE61BFQktV6J/o297HGzlt24uX5n
        WVWnZowb7rQSDjTBiV3nTQ1nwA==
X-Google-Smtp-Source: AMsMyM47lpMf/Gs4woUPVfGEJlhiU2Ve+I0QJuf2x1OErrrrrUHiHRgUStjqDR1qi+mDyEee2Aq/sg==
X-Received: by 2002:a05:6638:35a2:b0:364:451:9969 with SMTP id v34-20020a05663835a200b0036404519969mr26740834jal.245.1666727511779;
        Tue, 25 Oct 2022 12:51:51 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id y10-20020a056638014a00b00349d2d52f6asm1211719jao.37.2022.10.25.12.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 12:51:50 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] net: ipa: record the route table size in the IPA structure
Date:   Tue, 25 Oct 2022 14:51:40 -0500
Message-Id: <20221025195143.255934-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221025195143.255934-1-elder@linaro.org>
References: <20221025195143.255934-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The non-hashed routing tables for IPv4 and IPv6 will be the same
size.  And if supported, the hashed routing tables will be the same
size as the non-hashed tables.

Record the size (number of entries) of all routing tables in the IPA
structure.  For now, initialize this field using IPA_ROUTE_TABLE_MAX,
and just do so when the first route table is validated.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h       |  2 ++
 drivers/net/ipa/ipa_table.c | 22 +++++++++++++++-------
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 09ead433ec38e..aa39509e209a3 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -39,6 +39,7 @@ struct ipa_interrupt;
  * @power:		IPA power information
  * @table_addr:		DMA address of filter/route table content
  * @table_virt:		Virtual address of filter/route table content
+ * @route_count:	Total number of entries in a routing table
  * @interrupt:		IPA Interrupt information
  * @uc_powered:		true if power is active by proxy for microcontroller
  * @uc_loaded:		true after microcontroller has reported it's ready
@@ -84,6 +85,7 @@ struct ipa {
 
 	dma_addr_t table_addr;
 	__le64 *table_virt;
+	u32 route_count;
 
 	struct ipa_interrupt *interrupt;
 	bool uc_powered;
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 58a1a9da3133e..0815c8967e914 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -185,7 +185,7 @@ static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
 	if (!count)
 		return 0;
 
-	WARN_ON(count > max_t(u32, IPA_FILTER_COUNT_MAX, IPA_ROUTE_COUNT_MAX));
+	WARN_ON(count > max_t(u32, IPA_FILTER_COUNT_MAX, ipa->route_count));
 
 	/* Skip over the zero rule and possibly the filter mask */
 	skip = filter_mask ? 1 : 2;
@@ -302,7 +302,7 @@ static int ipa_route_reset(struct ipa *ipa, bool modem)
 		count = IPA_ROUTE_MODEM_COUNT;
 	} else {
 		first = IPA_ROUTE_MODEM_COUNT;
-		count = IPA_ROUTE_COUNT_MAX - IPA_ROUTE_MODEM_COUNT;
+		count = ipa->route_count - IPA_ROUTE_MODEM_COUNT;
 	}
 
 	ipa_table_reset_add(trans, false, first, count, IPA_MEM_V4_ROUTE);
@@ -552,7 +552,7 @@ static void ipa_route_config(struct ipa *ipa, bool modem)
 	if (!ipa_table_hash_support(ipa))
 		return;
 
-	for (route_id = 0; route_id < IPA_ROUTE_COUNT_MAX; route_id++)
+	for (route_id = 0; route_id < ipa->route_count; route_id++)
 		if (ipa_route_id_modem(route_id) == modem)
 			ipa_route_tuple_zero(ipa, route_id);
 }
@@ -566,7 +566,9 @@ void ipa_table_config(struct ipa *ipa)
 	ipa_route_config(ipa, true);
 }
 
-/* Zero modem_route_count means filter table memory check */
+/* Verify the sizes of all IPA table filter or routing table memory regions
+ * are valid.  If valid, this records the size of the routing table.
+ */
 bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count)
 {
 	bool hash_support = ipa_table_hash_support(ipa);
@@ -591,6 +593,10 @@ bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count)
 	if (mem_ipv4->size != mem_ipv6->size)
 		return false;
 
+	/* Record the number of routing table entries */
+	if (!filter)
+		ipa->route_count = IPA_ROUTE_COUNT_MAX;
+
 	/* Table offset and size must fit in TABLE_INIT command fields */
 	if (!ipa_cmd_table_init_valid(ipa, mem_ipv4, !filter))
 		return false;
@@ -671,7 +677,7 @@ bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count)
  *	| ---- zero rule address | \
  *	|\   |-------------------|  |
  *	| ---- zero rule address |  |	IPA_FILTER_COUNT_MAX
- *	|    |-------------------|   >	or IPA_ROUTE_COUNT_MAX,
+ *	|    |-------------------|   >	or IPA route count,
  *	|	      ...	    |	whichever is greater
  *	 \   |-------------------|  |
  *	  ---- zero rule address | /
@@ -679,15 +685,17 @@ bool ipa_table_mem_valid(struct ipa *ipa, bool modem_route_count)
  */
 int ipa_table_init(struct ipa *ipa)
 {
-	u32 count = max_t(u32, IPA_FILTER_COUNT_MAX, IPA_ROUTE_COUNT_MAX);
 	struct device *dev = &ipa->pdev->dev;
 	dma_addr_t addr;
 	__le64 le_addr;
 	__le64 *virt;
 	size_t size;
+	u32 count;
 
 	ipa_table_validate_build();
 
+	count = max_t(u32, IPA_FILTER_COUNT_MAX, ipa->route_count);
+
 	/* The IPA hardware requires route and filter table rules to be
 	 * aligned on a 128-byte boundary.  We put the "zero rule" at the
 	 * base of the table area allocated here.  The DMA address returned
@@ -722,7 +730,7 @@ int ipa_table_init(struct ipa *ipa)
 
 void ipa_table_exit(struct ipa *ipa)
 {
-	u32 count = max_t(u32, 1 + IPA_FILTER_COUNT_MAX, IPA_ROUTE_COUNT_MAX);
+	u32 count = max_t(u32, 1 + IPA_FILTER_COUNT_MAX, ipa->route_count);
 	struct device *dev = &ipa->pdev->dev;
 	size_t size;
 
-- 
2.34.1

