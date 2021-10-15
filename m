Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FDF42FDFD
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbhJOWTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238808AbhJOWTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE91A6120A;
        Fri, 15 Oct 2021 22:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336222;
        bh=5nivEfqlALOw188V5+i9KJKoYg/vi6u9v1wJ/SCiLpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HE4HCHuTwlyZe0xwAa3VuDAUbo6+Kh0Q66NEoG6+tJT+vxQHskbO6EQ9pe4pPu9dD
         IHKoOZshviBjQDS5D+Tg4E4grFPY/b4v6Nh1BD26Kx+BtrNYNDd/GWhJl0++fWiDKW
         XRcM3/9gkPWv89A+eKsHvqp6n39cPc9Wk0swjkDixtFVNdmBSghyhH5vrk1wdHpYuI
         wXEoLC8Q1vc+8feePPWD1NdHSYpzYuAIF/MoAyDWEK/wvQGloSMKvADrFLWSauhREK
         KfCREZ30nPiLVaeaHTXmEx56x46CouCM7cC4DHnbL/qs8lCIz4RpJh4XhxLKw1VETL
         gwmwbISKX2zoQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com
Subject: [PATCH net-next 06/12] ethernet: bnx2x: use eth_hw_addr_set()
Date:   Fri, 15 Oct 2021 15:16:46 -0700
Message-Id: <20211015221652.827253-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015221652.827253-1-kuba@kernel.org>
References: <20211015221652.827253-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Read the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: aelior@marvell.com
CC: skalluru@marvell.com
CC: GR-everest-linux-l2@marvell.com
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 27e712178f95..aec666e97683 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -11823,9 +11823,10 @@ static void bnx2x_get_mac_hwinfo(struct bnx2x *bp)
 	u32 val, val2;
 	int func = BP_ABS_FUNC(bp);
 	int port = BP_PORT(bp);
+	u8 addr[ETH_ALEN] = {};
 
 	/* Zero primary MAC configuration */
-	eth_zero_addr(bp->dev->dev_addr);
+	eth_hw_addr_set(bp->dev, addr);
 
 	if (BP_NOMCP(bp)) {
 		BNX2X_ERROR("warning: random MAC workaround active\n");
@@ -11834,8 +11835,10 @@ static void bnx2x_get_mac_hwinfo(struct bnx2x *bp)
 		val2 = MF_CFG_RD(bp, func_mf_config[func].mac_upper);
 		val = MF_CFG_RD(bp, func_mf_config[func].mac_lower);
 		if ((val2 != FUNC_MF_CFG_UPPERMAC_DEFAULT) &&
-		    (val != FUNC_MF_CFG_LOWERMAC_DEFAULT))
-			bnx2x_set_mac_buf(bp->dev->dev_addr, val, val2);
+		    (val != FUNC_MF_CFG_LOWERMAC_DEFAULT)) {
+			bnx2x_set_mac_buf(addr, val, val2);
+			eth_hw_addr_set(bp->dev, addr);
+		}
 
 		if (CNIC_SUPPORT(bp))
 			bnx2x_get_cnic_mac_hwinfo(bp);
@@ -11843,7 +11846,8 @@ static void bnx2x_get_mac_hwinfo(struct bnx2x *bp)
 		/* in SF read MACs from port configuration */
 		val2 = SHMEM_RD(bp, dev_info.port_hw_config[port].mac_upper);
 		val = SHMEM_RD(bp, dev_info.port_hw_config[port].mac_lower);
-		bnx2x_set_mac_buf(bp->dev->dev_addr, val, val2);
+		bnx2x_set_mac_buf(addr, val, val2);
+		eth_hw_addr_set(bp->dev, addr);
 
 		if (CNIC_SUPPORT(bp))
 			bnx2x_get_cnic_mac_hwinfo(bp);
@@ -12291,7 +12295,9 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 		if (rc)
 			return rc;
 	} else {
-		eth_zero_addr(bp->dev->dev_addr);
+		static const u8 zero_addr[ETH_ALEN] = {};
+
+		eth_hw_addr_set(bp->dev, zero_addr);
 	}
 
 	bnx2x_set_modes_bitmap(bp);
-- 
2.31.1

