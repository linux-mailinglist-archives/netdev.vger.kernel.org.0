Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8303AF25D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhFURyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231739AbhFURyV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D387611BD;
        Mon, 21 Jun 2021 17:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297926;
        bh=8MTBfsk6pvIQk1lT+ke+rQcj+rsp+htuVw6l1OINRpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xx2cqYCc2ytmLT7STrkDpHRKeEnQsaVZsZcOH9Umn4rQfFcl8PkEC6zmThEVJJUDC
         87VY0FcnbU2CPFgun85qCKMJ6jZ5lGXmEkhrKZp05wiDtgJf3O/xBTBnKLEWf8HdP8
         iMCy0hIZvEPshjUP/W9qmVf4hAXwtoM/P0GcQ0NSTRQhMGFLqEfCfmVRJjW17WNZCV
         8zaPKFTFzC8K19yTpncPgE7gOiR7xmrj7SwlRmXBVhfkB3DeM2cJ2seS7VpexBo8NM
         p7H/eVReecGTHHN+YWVsGgtkynEZqK52O4zEx2cxIUUj6YAsY2CJScbOE7HPgwcEpl
         g09bSwT/Nlhog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+7716dbc401d9a437890d@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 05/39] mac80211: remove warning in ieee80211_get_sband()
Date:   Mon, 21 Jun 2021 13:51:21 -0400
Message-Id: <20210621175156.735062-5-sashal@kernel.org>
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
index 02e818d740f6..5ec437e8e713 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1442,7 +1442,7 @@ ieee80211_get_sband(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-	if (WARN_ON_ONCE(!chanctx_conf)) {
+	if (!chanctx_conf) {
 		rcu_read_unlock();
 		return NULL;
 	}
-- 
2.30.2

