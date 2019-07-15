Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A29A68D9E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387529AbfGOOAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387484AbfGOOAB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:00:01 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 417D0212F5;
        Mon, 15 Jul 2019 13:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199200;
        bh=HVwfv/xPdc+JafPoW5hZgKYeM8SgLs9kQUl1bB803XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2XJ+9yMcI9Vb7IFzI3Cep/fcVwOGdzVLO2nVA/R9iqbCnpVAVzaOHZ0Hc6/sqNEA
         FA0g1V2NNeE7/JeyRUC/83nZHZexeRS/wMWLEtimZ68HJpu2WUEbA6kf3y+ltNu6yJ
         wcH1HU3SbOiz+TrfKtMGR3H5XkxeaLRkmSbNkR6M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 214/249] bnxt_en: Cap the returned MSIX vectors to the RDMA driver.
Date:   Mon, 15 Jul 2019 09:46:19 -0400
Message-Id: <20190715134655.4076-214-sashal@kernel.org>
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

[ Upstream commit 1dbc59fa4bbaa108b641cd65a54f662b75e4ed36 ]

In an earlier commit to improve NQ reservations on 57500 chips, we
set the resv_irqs on the 57500 VFs to the fixed value assigned by
the PF regardless of how many are actually used.  The current
code assumes that resv_irqs minus the ones used by the network driver
must be the ones for the RDMA driver.  This is no longer true and
we may return more MSIX vectors than requested, causing inconsistency.
Fix it by capping the value.

Fixes: 01989c6b69d9 ("bnxt_en: Improve NQ reservations.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index bfa342a98d08..fc77caf0a076 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -157,8 +157,10 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 
 	if (BNXT_NEW_RM(bp)) {
 		struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
+		int resv_msix;
 
-		avail_msix = hw_resc->resv_irqs - bp->cp_nr_rings;
+		resv_msix = hw_resc->resv_irqs - bp->cp_nr_rings;
+		avail_msix = min_t(int, resv_msix, avail_msix);
 		edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
 	}
 	bnxt_fill_msix_vecs(bp, ent);
-- 
2.20.1

