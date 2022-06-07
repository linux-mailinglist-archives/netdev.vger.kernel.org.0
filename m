Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D298153260E
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 11:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbiEXI6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbiEXI4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:56:32 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A4776C57F;
        Tue, 24 May 2022 01:56:31 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 13CEA20B8955; Tue, 24 May 2022 01:56:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 13CEA20B8955
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1653382591;
        bh=LmeUd3HzlFEV9uqUAPx3qEVgppMIqrk1rWw5FyI79rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=IepS4nFHRmtOLM3Wd4t64JpVOcKEeXVR0Hjz1+q/qlgqokz6V+T3ZKKjjKhRPrya9
         TflWVk6VszgDkgh7AoKPmXi5P55UQ0UJe7xEEpHEMtndM9Hg7/nNNiiKuQRMRY5dof
         Z8FxFcwzBYr+KSCMxjRANdoaf4US1eFnYbQPAki0=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [Patch v2 05/12] net: mana: Set the DMA device max segment size
Date:   Tue, 24 May 2022 01:56:05 -0700
Message-Id: <1653382572-14788-6-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1653382572-14788-1-git-send-email-longli@linuxonhyperv.com>
References: <1653382572-14788-1-git-send-email-longli@linuxonhyperv.com>
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

MANA hardware doesn't have any restrictions on the DMA segment size, set it
to the max allowed value.

Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
---
Change log:
v2: Use the max allowed value as the hardware doesn't have any limit

 drivers/net/ethernet/microsoft/mana/gdma_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 86ffe0e39df0..3cf69874ef18 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1385,6 +1385,12 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto release_region;
 
+	err = dma_set_max_seg_size(&pdev->dev, UINT_MAX);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to set dma device segment size\n");
+		goto release_region;
+	}
+
 	err = -ENOMEM;
 	gc = vzalloc(sizeof(*gc));
 	if (!gc)
-- 
2.17.1

