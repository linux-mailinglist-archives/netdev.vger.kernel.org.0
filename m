Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3633AF265
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbhFURy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231736AbhFURyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E9061026;
        Mon, 21 Jun 2021 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297928;
        bh=1sHIQdPRn/XYTHYJ7Gb5M0sxtlirFmYni9xPyfy/yw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a++x/0Th+JrA4jsQRiWWUhX7BldLGaQMOP0ZX0+zYzGG7EN6ep0xL+jdZ87prR6mX
         yfwPJfqXWJyq5ICbZFwKWltZNCpeaGAI15OAClJmV70XYQSNLSMRddUzDJ1rIsSi76
         6xQuNGRsR5SU1y7RzgpkoekwkwdFPkmjTU+bWPbVVI7Z4djtu2+xUJJyZc47UsfjK5
         jSJu68aY0lHKa2QptD3QO6gdOv/54Ti4SLHKe+i4wyMYD2gNY8n2RrK1vNEvknPZ7z
         Aww3+8f6Kow5jBHoyypqUC7wEbtZlIKLa31WeVQyDtYYijaut3alhWSauo+Ov1lX+S
         wyw7bL1rb986g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+a063bbf0b15737362592@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 06/39] mac80211_hwsim: drop pending frames on stop
Date:   Mon, 21 Jun 2021 13:51:22 -0400
Message-Id: <20210621175156.735062-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit bd18de517923903a177508fc8813f44e717b1c00 ]

Syzbot reports that we may be able to get into a situation where
mac80211 has pending ACK frames on shutdown with hwsim. It appears
that the reason for this is that syzbot uses the wmediumd hooks to
intercept/injection frames, and may shut down hwsim, removing the
radio(s), while frames are pending in the air simulation.

Clean out the pending queue when the interface is stopped, after
this the frames can't be reported back to mac80211 properly anyway.

Reported-by: syzbot+a063bbf0b15737362592@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20210517170429.b0f85ab0eda1.Ie42a6ec6b940c971f3441286aeaaae2fe368e29a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index fa7d4c20dc13..30b39cb4056a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1693,8 +1693,13 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
+
 	data->started = false;
 	hrtimer_cancel(&data->beacon_timer);
+
+	while (!skb_queue_empty(&data->pending))
+		ieee80211_free_txskb(hw, skb_dequeue(&data->pending));
+
 	wiphy_dbg(hw->wiphy, "%s\n", __func__);
 }
 
-- 
2.30.2

