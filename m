Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4450F8C92B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbfHNChA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728040AbfHNCMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A4DE20842;
        Wed, 14 Aug 2019 02:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748770;
        bh=MksosQLMGZ89hzq1CyJjp04g4mTD95UR39ssKqqsh+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3nwzRtSuvSOiI1m/fr/VLU6jDwAAqAa1vkrGn8SQtZwtMgzLVV+UmItrSc9PaZ60
         ktLSXnAeOoCF5ncss1KCZ+3Zs/1IOtFp+1MyHjGEXone6yycHmJXXNkttztMSzeiQL
         JgQKpXaWXZI0Gri1rUjPn0ZfNLIETBT5aQ0luytQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 058/123] netfilter: ebtables: also count base chain policies
Date:   Tue, 13 Aug 2019 22:09:42 -0400
Message-Id: <20190814021047.14828-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 3b48300d5cc7c7bed63fddb006c4046549ed4aec ]

ebtables doesn't include the base chain policies in the rule count,
so we need to add them manually when we call into the x_tables core
to allocate space for the comapt offset table.

This lead syzbot to trigger:
WARNING: CPU: 1 PID: 9012 at net/netfilter/x_tables.c:649
xt_compat_add_offset.cold+0x11/0x36 net/netfilter/x_tables.c:649

Reported-by: syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com
Fixes: 2035f3ff8eaa ("netfilter: ebtables: compat: un-break 32bit setsockopt when no rules are present")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index fd84b48e48b57..c8177a89f52c3 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1770,20 +1770,28 @@ static int compat_calc_entry(const struct ebt_entry *e,
 	return 0;
 }
 
+static int ebt_compat_init_offsets(unsigned int number)
+{
+	if (number > INT_MAX)
+		return -EINVAL;
+
+	/* also count the base chain policies */
+	number += NF_BR_NUMHOOKS;
+
+	return xt_compat_init_offsets(NFPROTO_BRIDGE, number);
+}
 
 static int compat_table_info(const struct ebt_table_info *info,
 			     struct compat_ebt_replace *newinfo)
 {
 	unsigned int size = info->entries_size;
 	const void *entries = info->entries;
+	int ret;
 
 	newinfo->entries_size = size;
-	if (info->nentries) {
-		int ret = xt_compat_init_offsets(NFPROTO_BRIDGE,
-						 info->nentries);
-		if (ret)
-			return ret;
-	}
+	ret = ebt_compat_init_offsets(info->nentries);
+	if (ret)
+		return ret;
 
 	return EBT_ENTRY_ITERATE(entries, size, compat_calc_entry, info,
 							entries, newinfo);
@@ -2234,11 +2242,9 @@ static int compat_do_replace(struct net *net, void __user *user,
 
 	xt_compat_lock(NFPROTO_BRIDGE);
 
-	if (tmp.nentries) {
-		ret = xt_compat_init_offsets(NFPROTO_BRIDGE, tmp.nentries);
-		if (ret < 0)
-			goto out_unlock;
-	}
+	ret = ebt_compat_init_offsets(tmp.nentries);
+	if (ret < 0)
+		goto out_unlock;
 
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
 	if (ret < 0)
-- 
2.20.1

