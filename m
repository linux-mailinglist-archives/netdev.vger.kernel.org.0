Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E9368DB9
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733311AbfGOOAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387444AbfGON77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:59:59 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7906A20C01;
        Mon, 15 Jul 2019 13:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199198;
        bh=HC93si3eU8rA7ko8jkkmx7/BKlXaMUrZjDSLR/e38WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nR74mRFC4cCo+PfCe/bf3lMQRqJZKUqVRQk5l9ZFpoxL+QcTQKC0TZ2+A0hIRKgXb
         yPYiEO0afnOo/XAwIEKDaB1QpeL/UoVRXsylXkQSfEXueds6xk8a7ndrVSSENhVY4e
         v/xYFGYhwrCPlp1dhDYd4NxR1v4JFAqwLCC5SIPw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 213/249] bnxt_en: Fix statistics context reservation logic for RDMA driver.
Date:   Mon, 15 Jul 2019 09:46:18 -0400
Message-Id: <20190715134655.4076-213-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit d77b1ad8e87dc5a6cd0d9158b097a4817946ca3b ]

The current logic assumes that the RDMA driver uses one statistics
context adjacent to the ones used by the network driver.  This
assumption is not true and the statistics context used by the
RDMA driver is tied to its MSIX base vector.  This wrong assumption
can cause RDMA driver failure after changing ethtool rings on the
network side.  Fix the statistics reservation logic accordingly.

Fixes: 780baad44f0f ("bnxt_en: Reserve 1 stat_ctx for RDMA driver.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b9bc829aa9da..9090c79387c1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5508,7 +5508,16 @@ static int bnxt_cp_rings_in_use(struct bnxt *bp)
 
 static int bnxt_get_func_stat_ctxs(struct bnxt *bp)
 {
-	return bp->cp_nr_rings + bnxt_get_ulp_stat_ctxs(bp);
+	int ulp_stat = bnxt_get_ulp_stat_ctxs(bp);
+	int cp = bp->cp_nr_rings;
+
+	if (!ulp_stat)
+		return cp;
+
+	if (bnxt_nq_rings_in_use(bp) > cp + bnxt_get_ulp_msix_num(bp))
+		return bnxt_get_ulp_msix_base(bp) + ulp_stat;
+
+	return cp + ulp_stat;
 }
 
 static bool bnxt_need_reserve_rings(struct bnxt *bp)
@@ -7477,11 +7486,7 @@ unsigned int bnxt_get_avail_cp_rings_for_en(struct bnxt *bp)
 
 unsigned int bnxt_get_avail_stat_ctxs_for_en(struct bnxt *bp)
 {
-	unsigned int stat;
-
-	stat = bnxt_get_max_func_stat_ctxs(bp) - bnxt_get_ulp_stat_ctxs(bp);
-	stat -= bp->cp_nr_rings;
-	return stat;
+	return bnxt_get_max_func_stat_ctxs(bp) - bnxt_get_func_stat_ctxs(bp);
 }
 
 int bnxt_get_avail_msix(struct bnxt *bp, int num)
-- 
2.20.1

