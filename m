Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8135C54D7EB
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358354AbiFPCHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350931AbiFPCHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:07:39 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FC522BCB;
        Wed, 15 Jun 2022 19:07:37 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 7036F20C32A1; Wed, 15 Jun 2022 19:07:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7036F20C32A1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1655345251;
        bh=GFhQPUGWrbgZzC2192zgVbA+JDQi/fpd3+vs9e/absk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=nJ9m7E3K39DIqaR+h1fzd2wmq96DzH2YMhF7YYXoxeXqJXMxmyi+TnasUYbKAi7sz
         zeNuy0rF++RTkLq21K6CaanUvnKq5zoje2a+GMC/Q8UEbHkME2H5Us4dDO5wRQPVTD
         1QzAMKoC0sSBZCaTFXlLFhSsDLjIFdcABdY+wGQQ=
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
Subject: [Patch v4 05/12] net: mana: Set the DMA device max segment size
Date:   Wed, 15 Jun 2022 19:07:13 -0700
Message-Id: <1655345240-26411-6-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
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
index 7b42b78b7ddf..0c38c9a539f9 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1387,6 +1387,12 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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

