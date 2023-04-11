Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485706DE591
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDKUSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjDKUSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:18:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD0C1701
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10DF062BDA
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 20:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EA2C4339E;
        Tue, 11 Apr 2023 20:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681244300;
        bh=pWW/3DCMbeVwyTwbpEQ2eoEBgaaogzr81WHm7J7BpaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdQmSSSkGV7HVW8JO9+d9BM6iouTWxaz1qgRklkwd2S6bJ7YBe6SMGI4uF/H2C0mT
         JOJGK0pV46qx7Ge0oOMr2nRjIq+zJo9B642iWamO9wI21u2V3W2yDGfLoLyF7j45Dk
         5a9hENgH/VFzIJxCe8qvjxpeZgngJTRlsKWqkUFDOdlq2vTXCHiJL+TU5EYCjwYjep
         jLsIKVrINBqhZkXe3TGPeyPL5o/NCe2LOj2Zpsq725Z3TTyUk7tTJL/LB5yXUG6PU5
         tsjIZmbR5IzJZG+TYmk3yYDnQ1j6yU7ojAMuPzna6tnnD8xEn1vYiSdhnIYDdLM6EW
         gPvfMkynVK+lQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        linyunsheng@huawei.com, Jakub Kicinski <kuba@kernel.org>,
        michael.chan@broadcom.com
Subject: [PATCH net-next 3/3] bnxt: hook NAPIs to page pools
Date:   Tue, 11 Apr 2023 13:18:00 -0700
Message-Id: <20230411201800.596103-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411201800.596103-1-kuba@kernel.org>
References: <20230411201800.596103-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnxt has 1:1 mapping of page pools and NAPIs, so it's safe
to hoook them up together.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: michael.chan@broadcom.com
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f7602d8d79e3..b79c6780c752 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3211,6 +3211,7 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 
 	pp.pool_size = bp->rx_ring_size;
 	pp.nid = dev_to_node(&bp->pdev->dev);
+	pp.napi = &rxr->bnapi->napi;
 	pp.dev = &bp->pdev->dev;
 	pp.dma_dir = DMA_BIDIRECTIONAL;
 
-- 
2.39.2

