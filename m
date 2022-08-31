Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC445A728C
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 02:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiHaAer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 20:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiHaAen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 20:34:43 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B883A50F2;
        Tue, 30 Aug 2022 17:34:42 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id B10832045E27; Tue, 30 Aug 2022 17:34:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B10832045E27
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1661906081;
        bh=YTey0238/4aS/xrya6ulkxY7HltVXIIjE23VfT2Wlq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=b+kkFAgp8NZVphhliKzNlFE43GjkWUTODZ1YVlHyaMBnJu/XXHL8qtzEMevlb1epe
         hRSxlrqSJGyljsxPfstatT4TeZgrFLbssVOyJEvjEWdkB47e3uYKdwKQ9Urvl1Iy2/
         KZyXMK5jSUV9StCfJka0dkblcI7/6gFbfOtH38CI=
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
Subject: [Patch v5 02/12] net: mana: Record the physical address for doorbell page region
Date:   Tue, 30 Aug 2022 17:34:21 -0700
Message-Id: <1661906071-29508-3-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
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

For supporting RDMA device with multiple user contexts with their
individual doorbell pages, record the start address of doorbell page
region for use by the RDMA driver to allocate user context doorbell IDs.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma.h      | 2 ++
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index d815d323be87..c724ca410fcb 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -350,9 +350,11 @@ struct gdma_context {
 	struct completion	eq_test_event;
 	u32			test_event_eq_id;
 
+	phys_addr_t		bar0_pa;
 	void __iomem		*bar0_va;
 	void __iomem		*shm_base;
 	void __iomem		*db_page_base;
+	phys_addr_t		phys_db_page_base;
 	u32 db_page_size;
 
 	/* Shared memory chanenl (used to bootstrap HWC) */
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 49b85ca578b0..9fafaa0c8e76 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -27,6 +27,9 @@ static void mana_gd_init_registers(struct pci_dev *pdev)
 	gc->db_page_base = gc->bar0_va +
 				mana_gd_r64(gc, GDMA_REG_DB_PAGE_OFFSET);
 
+	gc->phys_db_page_base = gc->bar0_pa +
+				mana_gd_r64(gc, GDMA_REG_DB_PAGE_OFFSET);
+
 	gc->shm_base = gc->bar0_va + mana_gd_r64(gc, GDMA_REG_SHM_OFFSET);
 }
 
@@ -1335,6 +1338,7 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_init(&gc->eq_test_event_mutex);
 	pci_set_drvdata(pdev, gc);
+	gc->bar0_pa = pci_resource_start(pdev, 0);
 
 	bar0_va = pci_iomap(pdev, bar, 0);
 	if (!bar0_va)
-- 
2.17.1

