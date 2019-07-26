Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC14E76810
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfGZNmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727620AbfGZNl6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CB7622CC2;
        Fri, 26 Jul 2019 13:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148518;
        bh=DM7dIiX4yXoSE31CLN5Uu6r4oDMxr77YDotnzPxyWQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTMgiuoKz6sh6z+D9SeXycpHulUeUXqXdQ7rMCpu+NGFM+tR0pAUimuMujCUD4Hfx
         URufPQcMHEYqom0W21vnIxIRBfIBfcU1rzEB631p4luJ2TSS9gLIrHzaLD8MBZV9Ih
         GujEm8obuRzhQw4aJHJGzi2bNKLuvIMQtq6EeYl8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 80/85] bnxt_en: Fix VNIC accounting when enabling aRFS on 57500 chips.
Date:   Fri, 26 Jul 2019 09:39:30 -0400
Message-Id: <20190726133936.11177-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 9b3d15e6b05e0b916be5fbd915f90300a403098b ]

Unlike legacy chips, 57500 chips don't need additional VNIC resources
for aRFS/ntuple.  Fix the code accordingly so that we don't reserve
and allocate additional VNICs on 57500 chips.  Without this patch,
the driver is failing to initialize when it tries to allocate extra
VNICs.

Fixes: ac33906c67e2 ("bnxt_en: Add support for aRFS on 57500 chips.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f758b2e0591f..9a2a0d24d20d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3022,7 +3022,7 @@ static int bnxt_alloc_vnics(struct bnxt *bp)
 	int num_vnics = 1;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (bp->flags & BNXT_FLAG_RFS)
+	if ((bp->flags & (BNXT_FLAG_RFS | BNXT_FLAG_CHIP_P5)) == BNXT_FLAG_RFS)
 		num_vnics += bp->rx_nr_rings;
 #endif
 
@@ -7124,6 +7124,9 @@ static int bnxt_alloc_rfs_vnics(struct bnxt *bp)
 #ifdef CONFIG_RFS_ACCEL
 	int i, rc = 0;
 
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		return 0;
+
 	for (i = 0; i < bp->rx_nr_rings; i++) {
 		struct bnxt_vnic_info *vnic;
 		u16 vnic_id = i + 1;
@@ -9587,7 +9590,7 @@ int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 		return -ENOMEM;
 
 	vnics = 1;
-	if (bp->flags & BNXT_FLAG_RFS)
+	if ((bp->flags & (BNXT_FLAG_RFS | BNXT_FLAG_CHIP_P5)) == BNXT_FLAG_RFS)
 		vnics += rx_rings;
 
 	if (bp->flags & BNXT_FLAG_AGG_RINGS)
-- 
2.20.1

