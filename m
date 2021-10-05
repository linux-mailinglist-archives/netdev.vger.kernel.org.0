Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00714228BF
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbhJENyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235660AbhJENxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DD6461A08;
        Tue,  5 Oct 2021 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441872;
        bh=NQKC8Vr4op7XQbJQ+LpubJ+MUbA4cdFLEPqGo2sEVRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhVV18yu9OlqucAXq0c1Mrfpqyt3fPslMPUkP5oabtws6yT1L+Pxj7OLuT9irKqJo
         QXAYJ47ORAS6EvLmZD5fngJ2fPTU4uHo3kxlr6NLKs81ik2ogzsJ1xukn+Rl23Raan
         3Fkcv93gKGpLTHqmrC2IVokebNoPQV75BvaM0ClM+OjWGaLGaInWp1bL9NirhjWrgQ
         1PaLkxNq/SGKav+TtUIXLPw5JykCxqEMaAcLFVc4YtPXv5naeQBPiqPj3pTsOxXat3
         RwsPK1FaVi4ntGjdZLEyMcka15KnCPMUjdXvX28X/hposHhjwmtsBc6BQs/2KK02z0
         KNLGkMbwNfbYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     MichelleJin <shjy180909@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 26/40] mac80211: check return value of rhashtable_init
Date:   Tue,  5 Oct 2021 09:50:05 -0400
Message-Id: <20211005135020.214291-26-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: MichelleJin <shjy180909@gmail.com>

[ Upstream commit 111461d573741c17eafad029ac93474fa9adcce0 ]

When rhashtable_init() fails, it returns -EINVAL.
However, since error return value of rhashtable_init is not checked,
it can cause use of uninitialized pointers.
So, fix unhandled errors of rhashtable_init.

Signed-off-by: MichelleJin <shjy180909@gmail.com>
Link: https://lore.kernel.org/r/20210927033457.1020967-4-shjy180909@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index efbefcbac3ac..7cab1cf09bf1 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -60,7 +60,10 @@ static struct mesh_table *mesh_table_alloc(void)
 	atomic_set(&newtbl->entries,  0);
 	spin_lock_init(&newtbl->gates_lock);
 	spin_lock_init(&newtbl->walk_lock);
-	rhashtable_init(&newtbl->rhead, &mesh_rht_params);
+	if (rhashtable_init(&newtbl->rhead, &mesh_rht_params)) {
+		kfree(newtbl);
+		return NULL;
+	}
 
 	return newtbl;
 }
-- 
2.33.0

