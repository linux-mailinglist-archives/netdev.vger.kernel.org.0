Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8869694AD
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391596AbfGOO3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389367AbfGOO3h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:29:37 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CD2E205ED;
        Mon, 15 Jul 2019 14:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200975;
        bh=X/0nRMRwZ/KVQqQSES3OyZYVlgeCHDVKiEHGuKM+pd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W77cJkfkvvqKF3RRn8DuGcT97MvXHaeempewC9EalzsgIKb24zHThy9CstHzuEZYJ
         7LEYhooH6tqdwJSx0HVx/ssoKDV8qFtGqD7BN7mKZ4a2wNtHe4SNHPoHF/FoXQ1B/m
         fjJWznUtRwqjEZCTV/96L5vOzXpLDmhaalQwkKy0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 016/105] qed: Set the doorbell address correctly
Date:   Mon, 15 Jul 2019 10:27:10 -0400
Message-Id: <20190715142839.9896-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 8366d520019f366fabd6c7a13032bdcd837e18d4 ]

In 100g mode the doorbell bar is united for both engines. Set
the correct offset in the hwfn so that the doorbell returned
for RoCE is in the affined hwfn.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Denis Bolotin <denis.bolotin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c  | 29 ++++++++++++++--------
 drivers/net/ethernet/qlogic/qed/qed_rdma.c |  2 +-
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 410528e7d927..c4e8bf0773fe 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -2947,6 +2947,7 @@ static int qed_get_dev_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 				 void __iomem *p_regview,
 				 void __iomem *p_doorbells,
+				 u64 db_phys_addr,
 				 enum qed_pci_personality personality)
 {
 	int rc = 0;
@@ -2954,6 +2955,7 @@ static int qed_hw_prepare_single(struct qed_hwfn *p_hwfn,
 	/* Split PCI bars evenly between hwfns */
 	p_hwfn->regview = p_regview;
 	p_hwfn->doorbells = p_doorbells;
+	p_hwfn->db_phys_addr = db_phys_addr;
 
 	if (IS_VF(p_hwfn->cdev))
 		return qed_vf_hw_prepare(p_hwfn);
@@ -3036,7 +3038,9 @@ int qed_hw_prepare(struct qed_dev *cdev,
 	/* Initialize the first hwfn - will learn number of hwfns */
 	rc = qed_hw_prepare_single(p_hwfn,
 				   cdev->regview,
-				   cdev->doorbells, personality);
+				   cdev->doorbells,
+				   cdev->db_phys_addr,
+				   personality);
 	if (rc)
 		return rc;
 
@@ -3045,22 +3049,25 @@ int qed_hw_prepare(struct qed_dev *cdev,
 	/* Initialize the rest of the hwfns */
 	if (cdev->num_hwfns > 1) {
 		void __iomem *p_regview, *p_doorbell;
-		u8 __iomem *addr;
+		u64 db_phys_addr;
+		u32 offset;
 
 		/* adjust bar offset for second engine */
-		addr = cdev->regview +
-		       qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
-				       BAR_ID_0) / 2;
-		p_regview = addr;
+		offset = qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
+					 BAR_ID_0) / 2;
+		p_regview = cdev->regview + offset;
 
-		addr = cdev->doorbells +
-		       qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
-				       BAR_ID_1) / 2;
-		p_doorbell = addr;
+		offset = qed_hw_bar_size(p_hwfn, p_hwfn->p_main_ptt,
+					 BAR_ID_1) / 2;
+
+		p_doorbell = cdev->doorbells + offset;
+
+		db_phys_addr = cdev->db_phys_addr + offset;
 
 		/* prepare second hw function */
 		rc = qed_hw_prepare_single(&cdev->hwfns[1], p_regview,
-					   p_doorbell, personality);
+					   p_doorbell, db_phys_addr,
+					   personality);
 
 		/* in case of error, need to free the previously
 		 * initiliazed hwfn 0.
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 1b6554866138..1e13dea66989 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -753,7 +753,7 @@ static int qed_rdma_add_user(void *rdma_cxt,
 				     dpi_start_offset +
 				     ((out_params->dpi) * p_hwfn->dpi_size));
 
-	out_params->dpi_phys_addr = p_hwfn->cdev->db_phys_addr +
+	out_params->dpi_phys_addr = p_hwfn->db_phys_addr +
 				    dpi_start_offset +
 				    ((out_params->dpi) * p_hwfn->dpi_size);
 
-- 
2.20.1

