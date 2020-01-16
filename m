Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F47513F3EA
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389992AbgAPSqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:46:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389931AbgAPRKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A22324684;
        Thu, 16 Jan 2020 17:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194625;
        bh=4a7Sk8SWFDzfmkMN30hHFPwBDh9o5W9TF2o7WnL/dco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tD22/1xzrGP//aTgHVdcZIihYdesZpZU0JdVUauRDUqGHTnXnukJViigSAy+fF1dk
         eaE4aMRJBIQ/BlA2Qq1nVGLsKoni8QsB/d4iN1cJ20pFGkH2injtHtqEacKaffxk1Q
         V5XFuvmr49Hk/Oj6AdkJH2rGh6gsZdgBZsgAMWDQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 485/671] cxgb4: smt: Add lock for atomic_dec_and_test
Date:   Thu, 16 Jan 2020 12:02:03 -0500
Message-Id: <20200116170509.12787-222-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 4a8937b83892cb69524291cae6cdabad4a8be033 ]

The atomic_dec_and_test() is not safe because it is
outside of locks.
Move the locks of t4_smte_free() to its caller,
cxgb4_smt_release() to protect the atomic decrement.

Fixes: 3bdb376e6944 ("cxgb4: introduce SMT ops to prepare for SMAC rewrite support")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/smt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/smt.c b/drivers/net/ethernet/chelsio/cxgb4/smt.c
index 7b2207a2a130..9b3f4205cb4d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/smt.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/smt.c
@@ -98,11 +98,9 @@ static struct smt_entry *find_or_alloc_smte(struct smt_data *s, u8 *smac)
 
 static void t4_smte_free(struct smt_entry *e)
 {
-	spin_lock_bh(&e->lock);
 	if (atomic_read(&e->refcnt) == 0) {  /* hasn't been recycled */
 		e->state = SMT_STATE_UNUSED;
 	}
-	spin_unlock_bh(&e->lock);
 }
 
 /**
@@ -112,8 +110,10 @@ static void t4_smte_free(struct smt_entry *e)
  */
 void cxgb4_smt_release(struct smt_entry *e)
 {
+	spin_lock_bh(&e->lock);
 	if (atomic_dec_and_test(&e->refcnt))
 		t4_smte_free(e);
+	spin_unlock_bh(&e->lock);
 }
 EXPORT_SYMBOL(cxgb4_smt_release);
 
-- 
2.20.1

