Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBFA3CFA8E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238751AbhGTMtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:49:07 -0400
Received: from foss.arm.com ([217.140.110.172]:58536 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239043AbhGTMrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 08:47:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A8041FB;
        Tue, 20 Jul 2021 06:26:57 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.103])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 862083F694;
        Tue, 20 Jul 2021 06:26:54 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org, nd@arm.com,
        Jia He <justin.he@arm.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: [PATCH net v2] Revert "qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()"
Date:   Tue, 20 Jul 2021 21:26:55 +0800
Message-Id: <20210720132655.4704-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 6206b7981a36476f4695d661ae139f7db36a802d.

That patch added additional spin_{un}lock_bh(), which was harmless
but pointless. The orginal code path has guaranteed the pair of
spin_{un}lock_bh().

We'd better revert it before we find the exact root cause of the
bug_on mentioned in that patch.

Fixes: 6206b7981a36 ("qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()")
Cc: David S. Miller <davem@davemloft.net>
Cc: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Jia He <justin.he@arm.com>

---
v2: correct the hash value of reverted commit, and add the fixes tag

 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 79d879a5d663..4387292c37e2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -474,18 +474,14 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-		if (!qed_mcp_has_pending_cmd(p_hwfn)) {
-			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
+		if (!qed_mcp_has_pending_cmd(p_hwfn))
 			break;
-		}
 
 		rc = qed_mcp_update_pending_cmd(p_hwfn, p_ptt);
-		if (!rc) {
-			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
+		if (!rc)
 			break;
-		} else if (rc != -EAGAIN) {
+		else if (rc != -EAGAIN)
 			goto err;
-		}
 
 		spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 
@@ -502,8 +498,6 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		return -EAGAIN;
 	}
 
-	spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
-
 	/* Send the mailbox command */
 	qed_mcp_reread_offsets(p_hwfn, p_ptt);
 	seq_num = ++p_hwfn->mcp_info->drv_mb_seq;
@@ -530,18 +524,14 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-		if (p_cmd_elem->b_is_completed) {
-			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
+		if (p_cmd_elem->b_is_completed)
 			break;
-		}
 
 		rc = qed_mcp_update_pending_cmd(p_hwfn, p_ptt);
-		if (!rc) {
-			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
+		if (!rc)
 			break;
-		} else if (rc != -EAGAIN) {
+		else if (rc != -EAGAIN)
 			goto err;
-		}
 
 		spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 	} while (++cnt < max_retries);
@@ -564,7 +554,6 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		return -EAGAIN;
 	}
 
-	spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 	qed_mcp_cmd_del_elem(p_hwfn, p_cmd_elem);
 	spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-- 
2.17.1

