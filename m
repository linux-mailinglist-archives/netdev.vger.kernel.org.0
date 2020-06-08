Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589011F30A8
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 03:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbgFIBBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 21:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbgFHXIK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6845208B6;
        Mon,  8 Jun 2020 23:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657689;
        bh=oka/rNmtiRJwDwVogsEa+EcBiai5h5lBqQBMHdewr8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8FOv85L2uOxj7PFZ8XWJqGtpSz6db3fNysG4dV++0l+2MPZGxNJjJQZo9sqqFSA7
         z8+8GXJSLvliblyvMUn6IcQDKgFTYchDJar5o9MU8Jiz6RnisiaoIm2waY1q3jVh5u
         Ix6UneSP7SOhBtWifxl/LgdpFYHdNvdya2+pBY7I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sriram R <srirrama@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 091/274] ath11k: Avoid mgmt tx count underflow
Date:   Mon,  8 Jun 2020 19:03:04 -0400
Message-Id: <20200608230607.3361041-91-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriram R <srirrama@codeaurora.org>

[ Upstream commit 800113ff4b1d277c2b66ffc04d4d38f202a0d187 ]

The mgmt tx count reference is incremented/decremented on every mgmt tx and on
tx completion event from firmware.
In case of an unexpected mgmt tx completion event from firmware,
the counter would underflow. Avoid this by decrementing
only when the tx count is greater than 0.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1585567028-9242-1-git-send-email-srirrama@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 6fec62846279..73beca6d6b5f 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -3740,8 +3740,9 @@ static int wmi_process_mgmt_tx_comp(struct ath11k *ar, u32 desc_id,
 
 	ieee80211_tx_status_irqsafe(ar->hw, msdu);
 
-	WARN_ON_ONCE(atomic_read(&ar->num_pending_mgmt_tx) == 0);
-	atomic_dec(&ar->num_pending_mgmt_tx);
+	/* WARN when we received this event without doing any mgmt tx */
+	if (atomic_dec_if_positive(&ar->num_pending_mgmt_tx) < 0)
+		WARN_ON_ONCE(1);
 
 	return 0;
 }
-- 
2.25.1

