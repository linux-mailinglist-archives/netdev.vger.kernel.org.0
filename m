Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7C212B660
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfL0RmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:42:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727813AbfL0RmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEBC821744;
        Fri, 27 Dec 2019 17:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468537;
        bh=G1X73f8j5ZQK4s/al11K17DrbTTEfiY6izAM4uPLVQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRQiyUp9Xa9kReAmZHpjL5wmORu+xW4yYO49p0i4XLx+K+P5g7O9/PYqMWYAWhorK
         vUJ0tzZPsyti2x3fy8EZ4M3JBq/9Wqg1SOtrPnkB8bH9lq5o6ea1UaUhzh2JH4OLdg
         9Gsaw+AXkROb4m3WNQ8pNF7sePb/ayHn7TS7LxZU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 067/187] bnxt_en: Fix MSIX request logic for RDMA driver.
Date:   Fri, 27 Dec 2019 12:38:55 -0500
Message-Id: <20191227174055.4923-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 0c722ec0a289c7f6b53f89bad1cfb7c4db3f7a62 ]

The logic needs to check both bp->total_irqs and the reserved IRQs in
hw_resc->resv_irqs if applicable and see if both are enough to cover
the L2 and RDMA requested vectors.  The current code is only checking
bp->total_irqs and can fail in some code paths, such as the TX timeout
code path with the RDMA driver requesting vectors after recovery.  In
this code path, we have not reserved enough MSIX resources for the
RDMA driver yet.

Fixes: 75720e6323a1 ("bnxt_en: Keep track of reserved IRQs.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index b2c160947fc8..30816ec4fa91 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -113,8 +113,10 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
+	struct bnxt_hw_resc *hw_resc;
 	int max_idx, max_cp_rings;
 	int avail_msix, idx;
+	int total_vecs;
 	int rc = 0;
 
 	ASSERT_RTNL();
@@ -142,7 +144,10 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 	}
 	edev->ulp_tbl[ulp_id].msix_base = idx;
 	edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
-	if (bp->total_irqs < (idx + avail_msix)) {
+	hw_resc = &bp->hw_resc;
+	total_vecs = idx + avail_msix;
+	if (bp->total_irqs < total_vecs ||
+	    (BNXT_NEW_RM(bp) && hw_resc->resv_irqs < total_vecs)) {
 		if (netif_running(dev)) {
 			bnxt_close_nic(bp, true, false);
 			rc = bnxt_open_nic(bp, true, false);
@@ -156,7 +161,6 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 	}
 
 	if (BNXT_NEW_RM(bp)) {
-		struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
 		int resv_msix;
 
 		resv_msix = hw_resc->resv_irqs - bp->cp_nr_rings;
-- 
2.20.1

