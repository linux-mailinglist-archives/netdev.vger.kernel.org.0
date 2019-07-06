Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FFA60F53
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 09:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfGFHgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 03:36:51 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38909 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfGFHgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 03:36:50 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so5224345pfn.5
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 00:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sDWptPn4HOlNVySN7yBCPgNqRiXYToQPEfQeL5/yFmc=;
        b=bu7sMJ9rgBU1U7dgwRIPFy7Hj8B6O2sv6ke/Nzug7Gmu3VFoYrS1BBndiL0yr2Tpxm
         qvmzVuRIZSCSy0x6dompA4G3yAFXzp86sMxTbHv7oPr2HUez77+S4kdl/kD9WqGz/32/
         z2RqvTBRc9B/rA2i9qpOSrl6oXsl/ERl8P0qY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sDWptPn4HOlNVySN7yBCPgNqRiXYToQPEfQeL5/yFmc=;
        b=OOQmofJ9jtfCSx0KuLmPvXEw8a2jzVRaVBJSiNpXcibtpb52Uv0sfIg5s9fFRbJv/+
         mSSRMu3Cq57BQ9uAieIw6JoDwvnWC/XI+ZiwWrMsEw8hsMZOBTt9Lh/W1RqnJD8iOJ5m
         +ApVXYOyNv3+Ir9cWply6zTzoxnVZI+fmzwuWwrRiQBoexJGGkdT2EZS7yBD/Bto+vnK
         nSow2zPkTNPsi4pquY7+GVdEI8gpEwCWfbnNCE9GZ0u5E6wEjx+BBUdNZNs0Zz19w0N6
         tbFH2xSIRHOonc5FnxNtP/Rf66Q9jWtDTUBX/+x9KPCg2lDNjPqHBQU0+3r606HX2M8i
         lYsA==
X-Gm-Message-State: APjAAAVrw4lYHFnCvIAAu64cW8jKtzJY/EHjJ2yQkcpGQvlxn9o80ceg
        6Dk5x5yffHJgjwHwo2uhjRGwbZYHvtM=
X-Google-Smtp-Source: APXvYqz5Wh5P5+6bC3XaYzY0SzO4gFjggpDOEZNkrl0WrNq9hhz2MPJt+7k9HbBOfELnTptgY7fSwA==
X-Received: by 2002:a63:dc02:: with SMTP id s2mr9879196pgg.286.1562398609262;
        Sat, 06 Jul 2019 00:36:49 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a10sm1520144pfc.162.2019.07.06.00.36.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 00:36:48 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, gospo@broadcom.com
Cc:     netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org
Subject: [PATCH net-next 4/4] bnxt_en: add page_pool support
Date:   Sat,  6 Jul 2019 03:36:18 -0400
Message-Id: <1562398578-26020-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
References: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Gospodarek <gospo@broadcom.com>

This removes contention over page allocation for XDP_REDIRECT actions by
adding page_pool support per queue for the driver.  The performance for
XDP_REDIRECT actions scales linearly with the number of cores performing
redirect actions when using the page pools instead of the standard page
allocator.

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/Kconfig         |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 40 +++++++++++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  3 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  3 +-
 4 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 2e4a8c7..e9017ca 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -199,6 +199,7 @@ config BNXT
 	select FW_LOADER
 	select LIBCRC32C
 	select NET_DEVLINK
+	select PAGE_POOL
 	---help---
 	  This driver supports Broadcom NetXtreme-C/E 10/25/40/50 gigabit
 	  Ethernet cards.  To compile this driver as a module, choose M here:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d8f0846..b6777e5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -54,6 +54,7 @@
 #include <net/pkt_cls.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <net/page_pool.h>
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
@@ -668,19 +669,20 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 }
 
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
+					 struct bnxt_rx_ring_info *rxr,
 					 gfp_t gfp)
 {
 	struct device *dev = &bp->pdev->dev;
 	struct page *page;
 
-	page = alloc_page(gfp);
+	page = page_pool_dev_alloc_pages(rxr->page_pool);
 	if (!page)
 		return NULL;
 
 	*mapping = dma_map_page_attrs(dev, page, 0, PAGE_SIZE, bp->rx_dir,
 				      DMA_ATTR_WEAK_ORDERING);
 	if (dma_mapping_error(dev, *mapping)) {
-		__free_page(page);
+		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
 	}
 	*mapping += bp->rx_dma_offset;
@@ -716,7 +718,8 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	dma_addr_t mapping;
 
 	if (BNXT_RX_PAGE_MODE(bp)) {
-		struct page *page = __bnxt_alloc_rx_page(bp, &mapping, gfp);
+		struct page *page =
+			__bnxt_alloc_rx_page(bp, &mapping, rxr, gfp);
 
 		if (!page)
 			return -ENOMEM;
@@ -2360,7 +2363,7 @@ static void bnxt_free_rx_skbs(struct bnxt *bp)
 				dma_unmap_page_attrs(&pdev->dev, mapping,
 						     PAGE_SIZE, bp->rx_dir,
 						     DMA_ATTR_WEAK_ORDERING);
-				__free_page(data);
+				page_pool_recycle_direct(rxr->page_pool, data);
 			} else {
 				dma_unmap_single_attrs(&pdev->dev, mapping,
 						       bp->rx_buf_use_size,
@@ -2497,6 +2500,8 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
 		if (xdp_rxq_info_is_reg(&rxr->xdp_rxq))
 			xdp_rxq_info_unreg(&rxr->xdp_rxq);
 
+		rxr->page_pool = NULL;
+
 		kfree(rxr->rx_tpa);
 		rxr->rx_tpa = NULL;
 
@@ -2511,6 +2516,26 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
 	}
 }
 
+static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
+				   struct bnxt_rx_ring_info *rxr)
+{
+	struct page_pool_params pp = { 0 };
+
+	pp.pool_size = bp->rx_ring_size;
+	pp.nid = dev_to_node(&bp->pdev->dev);
+	pp.dev = &bp->pdev->dev;
+	pp.dma_dir = DMA_BIDIRECTIONAL;
+
+	rxr->page_pool = page_pool_create(&pp);
+	if (IS_ERR(rxr->page_pool)) {
+		int err = PTR_ERR(rxr->page_pool);
+
+		rxr->page_pool = NULL;
+		return err;
+	}
+	return 0;
+}
+
 static int bnxt_alloc_rx_rings(struct bnxt *bp)
 {
 	int i, rc, agg_rings = 0, tpa_rings = 0;
@@ -2530,12 +2555,17 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
 
 		ring = &rxr->rx_ring_struct;
 
+		rc = bnxt_alloc_rx_page_pool(bp, rxr);
+		if (rc)
+			return rc;
+
 		rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i);
 		if (rc < 0)
 			return rc;
 
 		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
-						MEM_TYPE_PAGE_SHARED, NULL);
+						MEM_TYPE_PAGE_POOL,
+						rxr->page_pool);
 		if (rc) {
 			xdp_rxq_info_unreg(&rxr->xdp_rxq);
 			return rc;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 8ac51fa..16694b7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -26,6 +26,8 @@
 #include <net/xdp.h>
 #include <linux/dim.h>
 
+struct page_pool;
+
 struct tx_bd {
 	__le32 tx_bd_len_flags_type;
 	#define TX_BD_TYPE					(0x3f << 0)
@@ -799,6 +801,7 @@ struct bnxt_rx_ring_info {
 	struct bnxt_ring_struct	rx_ring_struct;
 	struct bnxt_ring_struct	rx_agg_ring_struct;
 	struct xdp_rxq_info	xdp_rxq;
+	struct page_pool	*page_pool;
 };
 
 struct bnxt_cp_ring_info {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 12489d2..c6f6f20 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -15,6 +15,7 @@
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <linux/filter.h>
+#include <net/page_pool.h>
 #include "bnxt_hsi.h"
 #include "bnxt.h"
 #include "bnxt_xdp.h"
@@ -191,7 +192,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 
 		if (xdp_do_redirect(bp->dev, &xdp, xdp_prog)) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
-			__free_page(page);
+			page_pool_recycle_direct(rxr->page_pool, page);
 			return true;
 		}
 
-- 
2.5.1

