Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1552C26EBFF
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgIRCJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728195AbgIRCI4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 136C623770;
        Fri, 18 Sep 2020 02:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394935;
        bh=SgnL6lV3WEABDJJLLTBkyo4xD4dIVj3iRHnI1tAuXnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tq6miZgOxZFQApIR5K4ifyTzOjpXgPBKDI57fhRKNC65cj+l2hL4M4wUtjkOXtqWh
         0aWQ0VMH6Rj4VSnGY+KEt7O9/n0vvcihWbBTaeyhQ0idFRxyG1tAmyIR6UeuphIgAg
         4JCLbr4KYcxCd/cNEjfN80E4SG286kigqJuBxvq0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 045/206] ipv6_route_seq_next should increase position index
Date:   Thu, 17 Sep 2020 22:05:21 -0400
Message-Id: <20200918020802.2065198-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 4fc427e0515811250647d44de38d87d7b0e0790f ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 5e8979c1f76d8..28b51f4aa6418 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2372,14 +2372,13 @@ static void *ipv6_route_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct net *net = seq_file_net(seq);
 	struct ipv6_route_iter *iter = seq->private;
 
+	++(*pos);
 	if (!v)
 		goto iter_table;
 
 	n = rcu_dereference_bh(((struct fib6_info *)v)->fib6_next);
-	if (n) {
-		++*pos;
+	if (n)
 		return n;
-	}
 
 iter_table:
 	ipv6_route_check_sernum(iter);
@@ -2387,8 +2386,6 @@ iter_table:
 	r = fib6_walk_continue(&iter->w);
 	spin_unlock_bh(&iter->tbl->tb6_lock);
 	if (r > 0) {
-		if (v)
-			++*pos;
 		return iter->w.leaf;
 	} else if (r < 0) {
 		fib6_walker_unlink(net, &iter->w);
-- 
2.25.1

