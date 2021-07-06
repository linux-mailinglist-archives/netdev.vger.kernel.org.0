Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06533BCBFB
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhGFLSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232005AbhGFLRh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70F6561A14;
        Tue,  6 Jul 2021 11:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570099;
        bh=+kTrYCl2x0xHEW9LPfjcjBWmOZuqBJz7h7U13wIdCis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqKOTc5H/LV/yrqa7ES1OxwBFstvRQO0XiEXiOqXf5sYvvS0bRWOTOhkyUzwF364m
         p0LoLlQ3NBs56Ngpxm+uWQ3dSN7wN5pMbMqR/CLMjNHDz94TjNmMYhMtqiIQGQU6rB
         gIBNWA8xyzUwVbd2jTst5Wwgc8cInFrXF6alz+T+h9h/f66fp65LfcbLxVdK0eGM0F
         BJHe/fOxuYRLoDlzeRUouUFLYxJKjFTrM0V3Lsobn2P22NUvRQJHTul0zrZn56dEBN
         rHyiqJxXuDNFqWZCgn0JBftNZ2BXm80CQnuKKWHcTam1ApEWdx5Yi6q/EeiLuWVe9o
         m+Pv5j20ZjmxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 034/189] net/sched: cls_api: increase max_reclassify_loop
Date:   Tue,  6 Jul 2021 07:11:34 -0400
Message-Id: <20210706111409.2058071-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 05ff8435e50569a0a6b95e5ceaea43696e8827ab ]

modern userspace applications, like OVN, can configure the TC datapath to
"recirculate" packets several times. If more than 4 "recirculation" rules
are configured, packets can be dropped by __tcf_classify().
Changing the maximum number of reclassifications (from 4 to 16) should be
sufficient to prevent drops in most use cases, and guard against loops at
the same time.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 279f9e2a2319..d73b5c5514a9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1531,7 +1531,7 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				 u32 *last_executed_chain)
 {
 #ifdef CONFIG_NET_CLS_ACT
-	const int max_reclassify_loop = 4;
+	const int max_reclassify_loop = 16;
 	const struct tcf_proto *first_tp;
 	int limit = 0;
 
-- 
2.30.2

