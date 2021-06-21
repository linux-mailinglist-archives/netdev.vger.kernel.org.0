Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F97D3AF3AE
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhFUSDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232796AbhFUSAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:00:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44C0861261;
        Mon, 21 Jun 2021 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298093;
        bh=KHzhpOJF3qzOUq+8N4aNBVh1O5HCIOEE+iLayqoAqCo=;
        h=From:To:Cc:Subject:Date:From;
        b=dSBHC8Wi9AYgn1x6AuFhrbj98mVcFI2RO6aJoiE1B0CkT6pl67syQn8ABN2Bm94jj
         RiVx0XK6ld3i5/1FORA1E8WyJSyf7NcMj+xgCkH7vq16cLptQ74z2X8vr0uNy7gdL6
         im/JS2gat2ni15IK6lqCjZuPTEbTV+Yx5Rav9z/VYjpWClfVXBY49jVneD6hl9lsb4
         AT5Yt741mhNDe0LT1d7PAkVvILFwq13Uxhy7imerTSkwGjCQ4pd/vjVUvIbotBGliB
         2MZXDhs7CWqW7NkOxrpaIOeYDh/zZGpAh/tNRjAkBL3PIcheiY+E8YMI8qgmFvB87G
         tYeZkV1yIKs1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+7716dbc401d9a437890d@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/16] mac80211: remove warning in ieee80211_get_sband()
Date:   Mon, 21 Jun 2021 13:54:35 -0400
Message-Id: <20210621175450.736067-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0ee4d55534f82a0624701d0bb9fc2304d4529086 ]

Syzbot reports that it's possible to hit this from userspace,
by trying to add a station before any other connection setup
has been done. Instead of trying to catch this in some other
way simply remove the warning, that will appropriately reject
the call from userspace.

Reported-by: syzbot+7716dbc401d9a437890d@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20210517164715.f537da276d17.Id05f40ec8761d6a8cc2df87f1aa09c651988a586@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6c9d9c94983b..dea48696f994 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1398,7 +1398,7 @@ ieee80211_get_sband(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-	if (WARN_ON_ONCE(!chanctx_conf)) {
+	if (!chanctx_conf) {
 		rcu_read_unlock();
 		return NULL;
 	}
-- 
2.30.2

