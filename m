Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 984CC17AB35
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgCERJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:09:04 -0500
Received: from inva020.nxp.com ([92.121.34.13]:56386 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbgCERJE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:09:04 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E175D1A076C;
        Thu,  5 Mar 2020 18:09:01 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D51B11A074F;
        Thu,  5 Mar 2020 18:09:01 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 95FF32059D;
        Thu,  5 Mar 2020 18:09:01 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, s.hauer@pengutronix.de,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net-next v3 1/3] fsl/fman: reuse set_mac_address() in dtsec init()
Date:   Thu,  5 Mar 2020 19:08:56 +0200
Message-Id: <1583428138-12733-2-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reuse the set_mac_address() in the init() function.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 44 ++++++++++--------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 1ca543ac8f2c..f7aec507787f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -366,13 +366,26 @@ static void set_dflts(struct dtsec_cfg *cfg)
 	cfg->maximum_frame = DEFAULT_MAXIMUM_FRAME;
 }
 
+static void set_mac_address(struct dtsec_regs __iomem *regs, u8 *adr)
+{
+	u32 tmp;
+
+	tmp = (u32)((adr[5] << 24) |
+		    (adr[4] << 16) | (adr[3] << 8) | adr[2]);
+	iowrite32be(tmp, &regs->macstnaddr1);
+
+	tmp = (u32)((adr[1] << 24) | (adr[0] << 16));
+	iowrite32be(tmp, &regs->macstnaddr2);
+}
+
 static int init(struct dtsec_regs __iomem *regs, struct dtsec_cfg *cfg,
-		phy_interface_t iface, u16 iface_speed, u8 *macaddr,
+		phy_interface_t iface, u16 iface_speed, u64 addr,
 		u32 exception_mask, u8 tbi_addr)
 {
 	bool is_rgmii, is_sgmii, is_qsgmii;
-	int i;
+	enet_addr_t eth_addr;
 	u32 tmp;
+	int i;
 
 	/* Soft reset */
 	iowrite32be(MACCFG1_SOFT_RESET, &regs->maccfg1);
@@ -501,12 +514,8 @@ static int init(struct dtsec_regs __iomem *regs, struct dtsec_cfg *cfg,
 
 	iowrite32be(0xffffffff, &regs->ievent);
 
-	tmp = (u32)((macaddr[5] << 24) |
-		    (macaddr[4] << 16) | (macaddr[3] << 8) | macaddr[2]);
-	iowrite32be(tmp, &regs->macstnaddr1);
-
-	tmp = (u32)((macaddr[1] << 24) | (macaddr[0] << 16));
-	iowrite32be(tmp, &regs->macstnaddr2);
+	MAKE_ENET_ADDR_FROM_UINT64(addr, eth_addr);
+	set_mac_address(regs, (u8 *)eth_addr);
 
 	/* HASH */
 	for (i = 0; i < NUM_OF_HASH_REGS; i++) {
@@ -519,18 +528,6 @@ static int init(struct dtsec_regs __iomem *regs, struct dtsec_cfg *cfg,
 	return 0;
 }
 
-static void set_mac_address(struct dtsec_regs __iomem *regs, u8 *adr)
-{
-	u32 tmp;
-
-	tmp = (u32)((adr[5] << 24) |
-		    (adr[4] << 16) | (adr[3] << 8) | adr[2]);
-	iowrite32be(tmp, &regs->macstnaddr1);
-
-	tmp = (u32)((adr[1] << 24) | (adr[0] << 16));
-	iowrite32be(tmp, &regs->macstnaddr2);
-}
-
 static void set_bucket(struct dtsec_regs __iomem *regs, int bucket,
 		       bool enable)
 {
@@ -1391,9 +1388,8 @@ int dtsec_init(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	struct dtsec_cfg *dtsec_drv_param;
-	int err;
 	u16 max_frm_ln;
-	enet_addr_t eth_addr;
+	int err;
 
 	if (is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
@@ -1410,10 +1406,8 @@ int dtsec_init(struct fman_mac *dtsec)
 
 	dtsec_drv_param = dtsec->dtsec_drv_param;
 
-	MAKE_ENET_ADDR_FROM_UINT64(dtsec->addr, eth_addr);
-
 	err = init(dtsec->regs, dtsec_drv_param, dtsec->phy_if,
-		   dtsec->max_speed, (u8 *)eth_addr, dtsec->exceptions,
+		   dtsec->max_speed, dtsec->addr, dtsec->exceptions,
 		   dtsec->tbiphy->mdio.addr);
 	if (err) {
 		free_init_resources(dtsec);
-- 
2.1.0

