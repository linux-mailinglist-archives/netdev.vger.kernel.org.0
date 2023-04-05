Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76646D8B0C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 01:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbjDEXWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 19:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbjDEXWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 19:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C405FCF
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 16:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0331641B3
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 23:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8CAC433D2;
        Wed,  5 Apr 2023 23:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680736931;
        bh=l7ArGaeK9S4QiqVvOYiI6maFdbwXmV0cDyTGLDT4hf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uf7Am3dreS1NDqqX3oBsj+Pu4esIwltIhPZgh3KGgTxv3Kp0soJ4PqVtZa5bRlqEH
         jaommMC+N5jefwCpEXcfXF0uuzmYBEl2wximaoUnkvI1vjo2gfSU3fvvBd3I4ONnHq
         eGvm5tKgouT8wPcoKRDDN6WdW8dsudPSvFynPN8ewg1DoOifocBNp6X/UOrXfzmkl2
         adcwMNiAqnI3D4gXkiR4w2KPKMzJ8EsnCcNaRq7bR5M+jC1O8d88Z3lDQNHr1GjDcq
         WZdjstDnRG4oi79x+iASt27ywGWWV/mHVyNPXkBiYHYSlmQxMpVj9iaGbudLpL/hCl
         eSr0HlgUof1DQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        Jakub Kicinski <kuba@kernel.org>, michael.chan@broadcom.com
Subject: [RFC net-next v2 3/3] bnxt: hook NAPIs to page pools
Date:   Wed,  5 Apr 2023 16:21:00 -0700
Message-Id: <20230405232100.103392-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405232100.103392-1-kuba@kernel.org>
References: <20230405232100.103392-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
index 8ff5a4f98d6f..fffd84d11faf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3237,6 +3237,7 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 
 	pp.pool_size = bp->rx_ring_size;
 	pp.nid = dev_to_node(&bp->pdev->dev);
+	pp.napi = &rxr->bnapi->napi;
 	pp.dev = &bp->pdev->dev;
 	pp.dma_dir = DMA_BIDIRECTIONAL;
 
-- 
2.39.2

