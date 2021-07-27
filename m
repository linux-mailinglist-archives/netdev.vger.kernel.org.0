Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0178D3D7637
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236874AbhG0NZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237043AbhG0NWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:22:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFB5E61AEF;
        Tue, 27 Jul 2021 13:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392028;
        bh=IEMBuGM2e14tCOC30Js/a/PP3e+BUjqDR2jRxGaGQkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fa7Rx8DZfgPG1h5PfKip8WK+6S/FfY/ygR4oTuMDYwVxxk10n49Aa192VrZe/BiqS
         r4N/rc9c7Kk/+AhOvP841FRdIjYb4OwXE0KKSQMxbPprf/M+VmRmaapaNLrut3uH/7
         vdQ4wAi7glYdg1cyMwecpCVNkEFC3eDmyZVJYI2SUQmdfCiQnYGl8W2UKZt6T/ZohA
         hu3MkezU3pezGo+9vbOHvzqgrnaLkv9tUHTwm4Bl+BdZaBd5RwGj0Ak03DO0CvNBgO
         8IOdPlS553qVLdKQJGmjXJGXpmk1idv6UzolzdK7valEgjycA1wwB/kVx4ZQ1COhX2
         yV89uvqXpJGig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia He <justin.he@arm.com>, Lijian Zhang <Lijian.Zhang@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/5] qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()
Date:   Tue, 27 Jul 2021 09:20:22 -0400
Message-Id: <20210727132024.835810-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727132024.835810-1-sashal@kernel.org>
References: <20210727132024.835810-1-sashal@kernel.org>
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
index ef17ca09d303..789ecc19c412 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -497,14 +497,18 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 
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
 
@@ -521,6 +525,8 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		return -EAGAIN;
 	}
 
+	spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
+
 	/* Send the mailbox command */
 	qed_mcp_reread_offsets(p_hwfn, p_ptt);
 	seq_num = ++p_hwfn->mcp_info->drv_mb_seq;
@@ -547,14 +553,18 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 
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
@@ -575,6 +585,7 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		return -EAGAIN;
 	}
 
+	spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 	qed_mcp_cmd_del_elem(p_hwfn, p_cmd_elem);
 	spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-- 
2.30.2

