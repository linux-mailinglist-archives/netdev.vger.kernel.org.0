Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A996D1668
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 06:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjCaEjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 00:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCaEjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 00:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77A2C645
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 21:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5095862323
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB0FC4339E;
        Fri, 31 Mar 2023 04:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680237558;
        bh=woBzBGUUzOwFdMxhVcjM4kn96dJdBOYXuMYy20EE9oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDHw7SAj78g3wLNObwIoCvEWVSIWtei7uJ5ViFZN2i9EtXf88WI7eN1PqMlnvvJzZ
         bKUQ4X7JhgjZPM7vgyMS8KdLmqFYQqboj5Ce/EkE1ZldMqRZzr16ClaeIS75oPMSO7
         bLJ8nZW/CTalbB/vJw/86m2e+52/4iAEDFnILe19eN4ch6sMDEnHlb/foI9HXtC9Mk
         X8KH5b3Xn7ekrReuoouaZ3B18EiORjolv5QLkrvwDB8wgiFcPHnr/F3aulOzA1pWOo
         Vxq0TQx+pcknep3bS1GhVAx/vugHbC6jgOwZaqlh7KXeOCGoLHEWRC8nKj8sQOUEat
         Mc9ymz59WKyig==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, michael.chan@broadcom.com
Subject: [RFC net-next 2/2] bnxt: hook NAPIs to page pools
Date:   Thu, 30 Mar 2023 21:39:06 -0700
Message-Id: <20230331043906.3015706-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331043906.3015706-1-kuba@kernel.org>
References: <20230331043906.3015706-1-kuba@kernel.org>
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
index 656a28ac2ff0..fca1bb6299ae 100644
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

