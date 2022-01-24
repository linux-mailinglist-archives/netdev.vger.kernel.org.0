Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9350499C06
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242724AbiAXV64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:58:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47494 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346686AbiAXVhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:37:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B329AB8105C;
        Mon, 24 Jan 2022 21:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64061C340E8;
        Mon, 24 Jan 2022 21:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643060224;
        bh=p+HWmAwbx4PM1ahPU6LAvyTqNx07782m8kgyYrwLFT8=;
        h=Date:From:To:Cc:Subject:From;
        b=CmipDkkUgY3vXAQnEAtk1lzDgjA15xxFksaITPOHeCfSUazyZtXqWhPOVPaoHLGme
         nPkaSHZECQ0I9kfxljSD233eNJHIzxq4vLN01DUKt85n245kLxlzz1XxN3spNE6mJo
         /mRjP4iGQ9Qp5ZgjlDMn2oK5FpQ25JRnsOS6Wbw+RHmiWRNXdu4X8kZoNWvlwp+ZWK
         xsQEG0KA1E/Cmxdkp+xGLzsKh1ymkmHXbiGGlqIybuXExQ69xNuLOweAyaJP7zSsRh
         6AGgKLdcZ36JOxVtxGiGwBZdi392cAKlYhgAtYVQQMtlW8NkepvPipzANj8R7L5LY1
         Xc4wbV2+Mvk5w==
Date:   Mon, 24 Jan 2022 15:43:47 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: mana: Use struct_size() helper in
 mana_gd_create_dma_region()
Message-ID: <20220124214347.GA24709@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows that,
in the worst scenario, could lead to heap overflows.

Also, address the following sparse warnings:
drivers/net/ethernet/microsoft/mana/gdma_main.c:677:24: warning: using sizeof on a flexible structure

Link: https://github.com/KSPP/linux/issues/174
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 636dfef24a6c..49b85ca578b0 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -663,7 +663,7 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 	struct gdma_context *gc = gd->gdma_context;
 	struct hw_channel_context *hwc;
 	u32 length = gmi->length;
-	u32 req_msg_size;
+	size_t req_msg_size;
 	int err;
 	int i;
 
@@ -674,7 +674,7 @@ static int mana_gd_create_dma_region(struct gdma_dev *gd,
 		return -EINVAL;
 
 	hwc = gc->hwc.driver_data;
-	req_msg_size = sizeof(*req) + num_page * sizeof(u64);
+	req_msg_size = struct_size(req, page_addr_list, num_page);
 	if (req_msg_size > hwc->max_req_msg_size)
 		return -EINVAL;
 
-- 
2.27.0

