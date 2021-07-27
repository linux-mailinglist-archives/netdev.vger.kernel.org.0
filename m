Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1739A3D766C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhG0N2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:28:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236937AbhG0NU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8550D61AFB;
        Tue, 27 Jul 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392009;
        bh=hXFpP/tClzM8yodHRLTENI8Kw1lr94iQfEEzuorVa64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COlYBGJrdc4VMvZxAQ0fx3BiS12BVISxEyJuzE1gy3fpenH61n7rASbKYHErE58c0
         QzuVUJNuSy1Wj51myC3aJ2sQONB7iQ+XOinKYtLwXddleZ9JU95Zqtr7CB4AY4bbpF
         c/aU7P+uX6eGjX7/Lo4FZPIxLlDLHkym3hkC+XPlRZwFI5uOTRkCPLfshCzCUo4hnx
         4lCl7ifMeAR1q8hFuRDkV0d6Iog4rqbmQh/oJRAIWNp3O6PoOwryDXEjRur206JYf5
         JPg1h8hmF7OEVf49sNf7cFiEAYUfgjFgjpoCdlsiRJiQ34Mx1uslYyBFh5iXxUbtSh
         yJBZZTisCcl5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia He <justin.he@arm.com>, Lijian Zhang <Lijian.Zhang@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 5/9] qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()
Date:   Tue, 27 Jul 2021 09:19:57 -0400
Message-Id: <20210727132002.835130-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727132002.835130-1-sashal@kernel.org>
References: <20210727132002.835130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia He <justin.he@arm.com>

[ Upstream commit 6206b7981a36476f4695d661ae139f7db36a802d ]

Liajian reported a bug_on hit on a ThunderX2 arm64 server with FastLinQ
QL41000 ethernet controller:
 BUG: scheduling while atomic: kworker/0:4/531/0x00000200
  [qed_probe:488()]hw prepare failed
  kernel BUG at mm/vmalloc.c:2355!
  Internal error: Oops - BUG: 0 [#1] SMP
  CPU: 0 PID: 531 Comm: kworker/0:4 Tainted: G W 5.4.0-77-generic #86-Ubuntu
  pstate: 00400009 (nzcv daif +PAN -UAO)
 Call trace:
  vunmap+0x4c/0x50
  iounmap+0x48/0x58
  qed_free_pci+0x60/0x80 [qed]
  qed_probe+0x35c/0x688 [qed]
  __qede_probe+0x88/0x5c8 [qede]
  qede_probe+0x60/0xe0 [qede]
  local_pci_probe+0x48/0xa0
  work_for_cpu_fn+0x24/0x38
  process_one_work+0x1d0/0x468
  worker_thread+0x238/0x4e0
  kthread+0xf0/0x118
  ret_from_fork+0x10/0x18

In this case, qed_hw_prepare() returns error due to hw/fw error, but in
theory work queue should be in process context instead of interrupt.

The root cause might be the unpaired spin_{un}lock_bh() in
_qed_mcp_cmd_and_union(), which causes botton half is disabled incorrectly.

Reported-by: Lijian Zhang <Lijian.Zhang@arm.com>
Signed-off-by: Jia He <justin.he@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 9401b49275f0..5d85ae59bc51 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -498,14 +498,18 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-		if (!qed_mcp_has_pending_cmd(p_hwfn))
+		if (!qed_mcp_has_pending_cmd(p_hwfn)) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
+		}
 
 		rc = qed_mcp_update_pending_cmd(p_hwfn, p_ptt);
-		if (!rc)
+		if (!rc) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
-		else if (rc != -EAGAIN)
+		} else if (rc != -EAGAIN) {
 			goto err;
+		}
 
 		spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 
@@ -522,6 +526,8 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		return -EAGAIN;
 	}
 
+	spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
+
 	/* Send the mailbox command */
 	qed_mcp_reread_offsets(p_hwfn, p_ptt);
 	seq_num = ++p_hwfn->mcp_info->drv_mb_seq;
@@ -548,14 +554,18 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-		if (p_cmd_elem->b_is_completed)
+		if (p_cmd_elem->b_is_completed) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
+		}
 
 		rc = qed_mcp_update_pending_cmd(p_hwfn, p_ptt);
-		if (!rc)
+		if (!rc) {
+			spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 			break;
-		else if (rc != -EAGAIN)
+		} else if (rc != -EAGAIN) {
 			goto err;
+		}
 
 		spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 	} while (++cnt < max_retries);
@@ -576,6 +586,7 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		return -EAGAIN;
 	}
 
+	spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 	qed_mcp_cmd_del_elem(p_hwfn, p_cmd_elem);
 	spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-- 
2.30.2

