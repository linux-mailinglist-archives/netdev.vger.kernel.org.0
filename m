Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53EEB3521E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfFDVoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:44:09 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:36043 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFDVoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:44:08 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x54Li2SE027494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 4 Jun 2019 15:44:05 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x54Lhw3a020053
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 4 Jun 2019 15:44:02 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v3 02/19] net: axienet: Use standard IO accessors
Date:   Tue,  4 Jun 2019 15:43:29 -0600
Message-Id: <1559684626-24775-3-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559684626-24775-1-git-send-email-hancock@sedsystems.ca>
References: <1559684626-24775-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was using in_be32 and out_be32 IO accessors which do not
exist on most platforms. Also, the use of big-endian accessors does not
seem correct as this hardware is accessed over an AXI bus which, to the
extent it has an endian-ness, is little-endian. Switch to standard
ioread32/iowrite32 accessors.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      | 4 ++--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index e09dc14..d82e3b6 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -476,7 +476,7 @@ struct axienet_option {
  */
 static inline u32 axienet_ior(struct axienet_local *lp, off_t offset)
 {
-	return in_be32(lp->regs + offset);
+	return ioread32(lp->regs + offset);
 }
 
 static inline u32 axinet_ior_read_mcr(struct axienet_local *lp)
@@ -496,7 +496,7 @@ static inline u32 axinet_ior_read_mcr(struct axienet_local *lp)
 static inline void axienet_iow(struct axienet_local *lp, off_t offset,
 			       u32 value)
 {
-	out_be32((lp->regs + offset), value);
+	iowrite32(value, lp->regs + offset);
 }
 
 /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 1bace60..55beca1 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -125,7 +125,7 @@
  */
 static inline u32 axienet_dma_in32(struct axienet_local *lp, off_t reg)
 {
-	return in_be32(lp->dma_regs + reg);
+	return ioread32(lp->dma_regs + reg);
 }
 
 /**
@@ -140,7 +140,7 @@ static inline u32 axienet_dma_in32(struct axienet_local *lp, off_t reg)
 static inline void axienet_dma_out32(struct axienet_local *lp,
 				     off_t reg, u32 value)
 {
-	out_be32((lp->dma_regs + reg), value);
+	iowrite32(value, lp->dma_regs + reg);
 }
 
 /**
-- 
1.8.3.1

