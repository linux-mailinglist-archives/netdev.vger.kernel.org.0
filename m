Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C74EE15CC1
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfEGGGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 02:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbfEGFdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:33:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F18A206A3;
        Tue,  7 May 2019 05:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207222;
        bh=i6ENz6UCG6TYsbHVXyUNUvgcJbTXyW8JasSMQF/sYO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oadF9PAlpjUrjNEsXx+ElkfmaovPeGOOJB3ejb6y+oNi9Cz9AHzvGLQOKDrZEg+iZ
         VWPsfw0i8KdIWfawaHxnOiahJ/QwarMvSbprV/d6ucwpniJJKsAtWdIQNdAFRM3/Gi
         CbJV13Gaa1L+Yys3LtL7W7qYOId7B1PwUMLzhjn0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Bolotin <dbolotin@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 35/99] qed: Fix the doorbell address sanity check
Date:   Tue,  7 May 2019 01:31:29 -0400
Message-Id: <20190507053235.29900-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Bolotin <dbolotin@marvell.com>

[ Upstream commit b61b04ad81d5f975349d66abbecabf96ba211140 ]

Fix the condition which verifies that doorbell address is inside the
doorbell bar by checking that the end of the address is within range
as well.

Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index ff0bbf8d073d..228891e459bc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -102,11 +102,15 @@ static void qed_db_recovery_dp_entry(struct qed_hwfn *p_hwfn,
 
 /* Doorbell address sanity (address within doorbell bar range) */
 static bool qed_db_rec_sanity(struct qed_dev *cdev,
-			      void __iomem *db_addr, void *db_data)
+			      void __iomem *db_addr,
+			      enum qed_db_rec_width db_width,
+			      void *db_data)
 {
+	u32 width = (db_width == DB_REC_WIDTH_32B) ? 32 : 64;
+
 	/* Make sure doorbell address is within the doorbell bar */
 	if (db_addr < cdev->doorbells ||
-	    (u8 __iomem *)db_addr >
+	    (u8 __iomem *)db_addr + width >
 	    (u8 __iomem *)cdev->doorbells + cdev->db_size) {
 		WARN(true,
 		     "Illegal doorbell address: %p. Legal range for doorbell addresses is [%p..%p]\n",
@@ -159,7 +163,7 @@ int qed_db_recovery_add(struct qed_dev *cdev,
 	}
 
 	/* Sanitize doorbell address */
-	if (!qed_db_rec_sanity(cdev, db_addr, db_data))
+	if (!qed_db_rec_sanity(cdev, db_addr, db_width, db_data))
 		return -EINVAL;
 
 	/* Obtain hwfn from doorbell address */
@@ -205,10 +209,6 @@ int qed_db_recovery_del(struct qed_dev *cdev,
 		return 0;
 	}
 
-	/* Sanitize doorbell address */
-	if (!qed_db_rec_sanity(cdev, db_addr, db_data))
-		return -EINVAL;
-
 	/* Obtain hwfn from doorbell address */
 	p_hwfn = qed_db_rec_find_hwfn(cdev, db_addr);
 
@@ -317,7 +317,7 @@ static void qed_db_recovery_ring(struct qed_hwfn *p_hwfn,
 
 	/* Sanity */
 	if (!qed_db_rec_sanity(p_hwfn->cdev, db_entry->db_addr,
-			       db_entry->db_data))
+			       db_entry->db_width, db_entry->db_data))
 		return;
 
 	/* Flush the write combined buffer. Since there are multiple doorbelling
-- 
2.20.1

