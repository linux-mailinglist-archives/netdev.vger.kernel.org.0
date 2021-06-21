Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BE53AF2E4
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhFUR5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhFURzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0763161352;
        Mon, 21 Jun 2021 17:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297988;
        bh=sB2btyZogi/Gqa1re073DeHahW7b5+RIXm+Wclmq4b0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7W+iJam5tydSbqpPvCs4iD7WhnHBNWKO1Yj2SSI2+2w+r367L0AlzpfzRRZU1EVY
         hxukcdM2V+bpY6q9CtneuTKxOTxxpAw2TiX3NuvgVqGhwbBJIkEpcf9f05oV8XfuxI
         Kg5aHX4U5xbDKr2Qk/Al+byN+nH6Pwaipz+VMOiwJID0MPe7sDqQU1cgF1jsM9lYrt
         iOZusDc73DNSVIHJBdtrXq1L3aBIpi0ExFD2TXns+f+d4cYAK4MGnm1r4IFMbwukt8
         097cXiLqd4FjGIwgqr+7CjMjE8C8W+yC5YGKxWw78CTInLkJHIj/O/2z3ujR8cqPOQ
         nRI7eSItr2Gvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+7716dbc401d9a437890d@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/35] mac80211: remove warning in ieee80211_get_sband()
Date:   Mon, 21 Jun 2021 13:52:30 -0400
Message-Id: <20210621175300.735437-5-sashal@kernel.org>
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
index be40f6b16199..a83f0c2fcdf7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1445,7 +1445,7 @@ ieee80211_get_sband(struct ieee80211_sub_if_data *sdata)
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-	if (WARN_ON_ONCE(!chanctx_conf)) {
+	if (!chanctx_conf) {
 		rcu_read_unlock();
 		return NULL;
 	}
-- 
2.30.2

