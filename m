Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D5F3BCED2
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbhGFL1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234822AbhGFLZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E29EE61D31;
        Tue,  6 Jul 2021 11:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570345;
        bh=nQS3t7wV/RZjdaFDVw4HYZ8B9wPxypO0wSp6Pk74WDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXhhVxRfnmcDDLkDdT9sRwqAw2Q5VWnpV3NhPVjF7QI+E5o+axQvbwR1CWjTLf9E6
         ncaWgSgNysJ/r+VJWjS5HJM6IQBu28nK6B5u+YhBkaVuWSuqqwPEyj8Ey+UusJdEvN
         cUrXViGrnMHCN1Wp1NQDnMXud2s1c2o05EY8MrmjpKbOMCgA37kpNuAJgeBHYPKut4
         V4hUYKKdLy+tzXulAuhp7HeqTYw8mU8yvvyPA135LA36qLHInrVERraL95Q6dm6izs
         ygLtVwIHnTCWhfRjbyewDzwZ5S1xsiU4WCplNkQABMJdKDr+snFSJzbSz9uEul6Aki
         FEc0uCCsmjaIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 028/160] net/sched: cls_api: increase max_reclassify_loop
Date:   Tue,  6 Jul 2021 07:16:14 -0400
Message-Id: <20210706111827.2060499-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 94f6942d7ec1..2f82ac7c0f93 100644
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

