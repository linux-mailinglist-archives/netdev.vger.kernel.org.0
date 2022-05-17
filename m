Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D13529D3E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbiEQJFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244147AbiEQJEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:04:53 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B996848E7C;
        Tue, 17 May 2022 02:04:49 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 93C9A20F7228; Tue, 17 May 2022 02:04:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 93C9A20F7228
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1652778289;
        bh=ZSGgxZeLIKsFB36lfkhwVhmsmPYSt9vljt8jQ1PtJZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=GNHpc5+K2Pb7W4R3wicIAlk6IwZKx4Rdo67tK5JwiVCcS0T36pzEAatIkYSHHYzaB
         ixKRw9Da2MRAXO8ym/ExQurHrQ4LBS4q3TGAgldL9kUNg1Cr4WdRYtGR1n9riQvtno
         3isIOPfv4dsqT0UL8NiM2DJXxdcN2tYI8UpXy0gk=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [PATCH 05/12] net: mana: Set the DMA device max page size
Date:   Tue, 17 May 2022 02:04:29 -0700
Message-Id: <1652778276-2986-6-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
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

From: Long Li <longli@microsoft.com>

The system chooses default 64K page size if the device does not specify
the max page size the device can handle for DMA. This do not work well
when device is registering large chunk of memory in that a large page size
is more efficient.

Set it to the maximum hardware supported page size.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 86ffe0e39df0..426087688480 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1385,6 +1385,13 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto release_region;
 
+	// The max GDMA HW supported page size is 2M
+	err = dma_set_max_seg_size(&pdev->dev, SZ_2M);
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

