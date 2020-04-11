Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E43B61A5AFE
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbgDKXqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:46:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbgDKXF0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B19C20708;
        Sat, 11 Apr 2020 23:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646326;
        bh=oQBj8lb2uNeut+/63KcU0BjmNZtn6nkTPn8nReRWhAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TY3xSW43zk3Scr4Gi7rpHzHdDpx+W64L178R6fclzNq+qQMFm0V5/HBlCRKq3Gl//
         HVSXrjjqCOfQXNuNSrvuOs7Q4FElyzYEYAfDd+WaYA0G49ZCEPPMxfDZ/U2aT2U1EL
         L4nfz9MgJOSxKTCNCpSTEKmRW8PY0VrkwleHETQU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vikas Patel <vikpatel@codeaurora.org>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 079/149] ath11k: Fixing dangling pointer issue upon peer delete failure
Date:   Sat, 11 Apr 2020 19:02:36 -0400
Message-Id: <20200411230347.22371-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vikas Patel <vikpatel@codeaurora.org>

[ Upstream commit 58595c9874c625ceb7004960d8e53b9226abdc92 ]

When there is WMI command failure, 'peer->sta' was not getting
cleaned up, and mac80211 frees the 'sta' memory, which is causing
the below page fault.

Cleaning up the sta pointer in ath11k whenever peer delete command
is sent.

Unable to handle kernel paging request at virtual address 200080000006a
pgd = ffffffc02a774000
[200080000006a] *pgd=0000000000000000, *pud=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
.
.
.
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.4.60 #1
Hardware name: Qualcomm Technologies, Inc. IPQ807x/AP-HK01-C1 (DT)
task: ffffffc00083c6d0 ti: ffffffc00083c6d0 task.ti: ffffffc00083c6d0
PC is at ath11k_dp_rx_process_mon_status+0x114/0x4e0 [ath11k]
LR is at ath11k_dp_rx_process_mon_status+0xe8/0x4e0 [ath11k]
pc : [<ffffffbffcf8e544>] lr : [<ffffffbffcf8e518>] pstate: 60000145
sp : ffffffc000833a30

Signed-off-by: Vikas Patel <vikpatel@codeaurora.org>
Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 78f20ba47b37e..e89790a01c48b 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2786,6 +2786,7 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 	struct ath11k *ar = hw->priv;
 	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
 	struct ath11k_sta *arsta = (struct ath11k_sta *)sta->drv_priv;
+	struct ath11k_peer *peer;
 	int ret = 0;
 
 	/* cancel must be done outside the mutex to avoid deadlock */
@@ -2818,6 +2819,17 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 				   sta->addr, arvif->vdev_id);
 
 		ath11k_mac_dec_num_stations(arvif, sta);
+		spin_lock_bh(&ar->ab->base_lock);
+		peer = ath11k_peer_find(ar->ab, arvif->vdev_id, sta->addr);
+		if (peer && peer->sta == sta) {
+			ath11k_warn(ar->ab, "Found peer entry %pM n vdev %i after it was supposedly removed\n",
+				    vif->addr, arvif->vdev_id);
+			peer->sta = NULL;
+			list_del(&peer->list);
+			kfree(peer);
+			ar->num_peers--;
+		}
+		spin_unlock_bh(&ar->ab->base_lock);
 
 		kfree(arsta->tx_stats);
 		arsta->tx_stats = NULL;
-- 
2.20.1

