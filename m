Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7373AF2EE
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhFUR6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232026AbhFUR4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A44486120D;
        Mon, 21 Jun 2021 17:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297990;
        bh=9QELizn/eVJ4Vy64PO6RFUDWTkCe/8iWmOq9SJTNLZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljlnBSuqFqAig9gdN2nCchm866OyQCH7caqpapOwa9+jWdDGaOybarzylbL/OAVFL
         kFW4G/pgP4Sc6e2mUzh4yGwfqmc5qWEc6cEiAvUqu/KukW6Nkn1A/JWPlZh0H/dkpa
         42hlVUm2wbKc1D9K7SZtNwmY7imrfBJdyh4LT+xD2qZarw4Gw9irvJZHcO8uodhOq6
         fgeTlJd5/Y4+oUw+FZLHKWAZjoM831s8FBgPBHF5O34GlnU+qKh3rpdZ0btYlxfpzp
         o4oAhDvQ+idbfhAltMn1i4wyVRhgoi3O3GsItMXVwAcAB5Q2Z9086Gs2QYJjwN/LC6
         3Z0AlaTjB4lqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+a063bbf0b15737362592@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/35] mac80211_hwsim: drop pending frames on stop
Date:   Mon, 21 Jun 2021 13:52:31 -0400
Message-Id: <20210621175300.735437-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
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
index 3b3fc7c9c91d..f147d4feedb9 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1623,8 +1623,13 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
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

