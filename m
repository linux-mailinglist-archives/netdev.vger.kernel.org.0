Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801496E05FA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjDME0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjDME0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:26:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C5A170F
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 21:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5053263B67
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ADAC4339E;
        Thu, 13 Apr 2023 04:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681359978;
        bh=aZ6Hv0X8gO7tEf0eXSwUnv/Ac3oCFNG5TNE82clGf1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCk4mMlbUnNoIVVmKhzvQqgJHvoa1RoX5qGEhcByu7FJwQ+zTdTHp2r9kdF4/chSZ
         o6TfX3aRy6IzhLvgv57UOcN8yCfsH92tZ4hwKaEkcFUrWQCuE9ow/djbTVYDaRFaCF
         muN9PwS8fExzx0P8ODnCHeH+MU5QBC6+Pa6qrvu2yIbGQ2JUxqd4JpIeFOrSz1FuAM
         HlfOTFGfN6Qz9I3TmJ/tI2UmGsc8MhxssC9q5o6ixRoquQ7V1UbK+U2pK1HuNOetLY
         HTxPJRL/CPpGdyDHDcA0u3S7TDSPPsnCOuJs9oo7egDIzinEl5iL+uxjjmmufMdJyR
         nK5MVIJh2SxSw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        linyunsheng@huawei.com, alexander.duyck@gmail.com,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, michael.chan@broadcom.com
Subject: [PATCH net-next v2 3/3] bnxt: hook NAPIs to page pools
Date:   Wed, 12 Apr 2023 21:26:05 -0700
Message-Id: <20230413042605.895677-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413042605.895677-1-kuba@kernel.org>
References: <20230413042605.895677-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnxt has 1:1 mapping of page pools and NAPIs, so it's safe
to hoook them up together.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
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

