Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CF2618875
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 20:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiKCTRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 15:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiKCTQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 15:16:56 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEDA41F9DE;
        Thu,  3 Nov 2022 12:16:54 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 78DA2205DA43; Thu,  3 Nov 2022 12:16:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 78DA2205DA43
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1667503014;
        bh=8Z6yW2KqbQl4Wyror+q4zSVQuzt8hLhkxhobys217qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=Nkhol3X59tnEwYqBLiIRFX3PP+FzavW8ftwQ03wcEznRasb5T5A3qNTS8H5Jh+9La
         pxBmZ3t+juA5h/6WV551Wd/6O2nTK5d5ok2AujIkuNKX30kTFdnKR8cMxp0R6NXLMg
         vnrVfcEuDRpbmpnPk6sm9HiH5bSZ3VTFJq3xOMq0=
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
Subject: [Patch v10 02/12] net: mana: Record the physical address for doorbell page region
Date:   Thu,  3 Nov 2022 12:16:20 -0700
Message-Id: <1667502990-2559-3-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
---
Change log:
v6: rebased to rdma-next

 drivers/net/ethernet/microsoft/mana/gdma.h      | 2 ++
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index f321a2616d03..72eaec2470c0 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -351,9 +351,11 @@ struct gdma_context {
 	u32			test_event_eq_id;
 
 	bool			is_pf;
+	phys_addr_t		bar0_pa;
 	void __iomem		*bar0_va;
 	void __iomem		*shm_base;
 	void __iomem		*db_page_base;
+	phys_addr_t		phys_db_page_base;
 	u32 db_page_size;
 
 	/* Shared memory chanenl (used to bootstrap HWC) */
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 5f9240182351..0cfe5f15458e 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -44,6 +44,9 @@ static void mana_gd_init_vf_regs(struct pci_dev *pdev)
 	gc->db_page_base = gc->bar0_va +
 				mana_gd_r64(gc, GDMA_REG_DB_PAGE_OFFSET);
 
+	gc->phys_db_page_base = gc->bar0_pa +
+				mana_gd_r64(gc, GDMA_REG_DB_PAGE_OFFSET);
+
 	gc->shm_base = gc->bar0_va + mana_gd_r64(gc, GDMA_REG_SHM_OFFSET);
 }
 
@@ -1367,6 +1370,7 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_init(&gc->eq_test_event_mutex);
 	pci_set_drvdata(pdev, gc);
+	gc->bar0_pa = pci_resource_start(pdev, 0);
 
 	bar0_va = pci_iomap(pdev, bar, 0);
 	if (!bar0_va)
-- 
2.17.1

