Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C4A3BD5AF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbhGFMYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232659AbhGFLbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE73261D0B;
        Tue,  6 Jul 2021 11:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570557;
        bh=vC2jNN6lJLLT6eGljA0ccjhw4SGacE5QaRnNIflnTyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orcLSC7QtvZkJv1TgslZAS1DWvggG9B8JMsCZ3bt3UV5lRx4kRvucR3JCoftcLawf
         6fwK3+DTGphdet12/mhgEnO16uXva3StUAxEoUM/qH+QtgoPVZPzCGVRyzpxauRk5m
         AfA1gkP2Col7yTQF6LErvhmkqrLJlRsldEzIJUEbHBed/JaW0rz8VSelF8iLD8YksV
         KGvKsc95+r46TxvJvUzd79BaSSj71uU2dpRwRj/jv3GtQCcsLhUY5ggsRZ5zf61fYe
         jjIGSqu6AD3q7p3sZ5p+pvdZkpB6k1STCvGIVXXfKzm2dTmnhR7xnZ3PdfEbHgf2Gg
         8vdb4yFQ3Praw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 025/137] net/sched: cls_api: increase max_reclassify_loop
Date:   Tue,  6 Jul 2021 07:20:11 -0400
Message-Id: <20210706112203.2062605-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index a281da07bb1d..30090794b791 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1532,7 +1532,7 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				 u32 *last_executed_chain)
 {
 #ifdef CONFIG_NET_CLS_ACT
-	const int max_reclassify_loop = 4;
+	const int max_reclassify_loop = 16;
 	const struct tcf_proto *first_tp;
 	int limit = 0;
 
-- 
2.30.2

