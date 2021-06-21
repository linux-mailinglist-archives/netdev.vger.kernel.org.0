Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96AE43AF41D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhFUSGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232009AbhFUSEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:04:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FA7861414;
        Mon, 21 Jun 2021 17:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298146;
        bh=RpX+WGxLTHL19BXdL9ZW8S463Uw+Gr86xTRwIYqWZKo=;
        h=From:To:Cc:Subject:Date:From;
        b=o1BnRXJTb6F3PDrmGHq6W4O3IUOOXEukiQjvcK3I4AzymaTLUcqyoRWlfUzeUIYY6
         wW29cY6wwJfJIM35Q52ddLK/H4nGiJ8lqBJ6KKJmJQsXZlbKE1W2HyD/TgnUak0ppY
         hoS9cwl11+mHweXt14T+rKGF3qYqPZU/tqtYkPvacMW0HbAXfboWl27+wHYKgLKAiB
         N/uYC6CK16RTP49Y+Wkgz4NkjLLwJ2zwmjkS9BVVppUP97S3eQmPUrGo1Es/3LawEg
         DXcVxceWb0a8M8BgbBZgOHDtqh/t+D2j5Ddr5AfGpeKm5XL72evUL7tIsr3e51SQMc
         zX98iHB8k2BFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+7716dbc401d9a437890d@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/13] mac80211: remove warning in ieee80211_get_sband()
Date:   Mon, 21 Jun 2021 13:55:31 -0400
Message-Id: <20210621175544.736421-1-sashal@kernel.org>
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
index 21b35255ecc2..f5532a3ce72e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1391,7 +1391,7 @@ ieee80211_get_sband(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-	if (WARN_ON_ONCE(!chanctx_conf)) {
+	if (!chanctx_conf) {
 		rcu_read_unlock();
 		return NULL;
 	}
-- 
2.30.2

