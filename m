Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520E41061EC
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfKVGAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729501AbfKVF5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0AE820659;
        Fri, 22 Nov 2019 05:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402261;
        bh=gsezTrwdiq3nD9JRIcpdArOxVKjnR8lRYMoWPJV6N7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjI/M3ZnrMaVThiggMMJ1DzY06krp9IY3UAPu+3mguRnfJYmEjEwqiXQDPSbmCd7q
         LaJHHnFQ8dMcq3l6LX4JCBTyqk+dEY8+7Nf4q1OXHX50p4v0o4CLGYpmnVIaI/aVv/
         8CfOXXEN8ADpRZDGvMVtzdTmJav3ak4wsxor3t34=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 102/127] net/core/neighbour: fix kmemleak minimal reference count for hash tables
Date:   Fri, 22 Nov 2019 00:55:20 -0500
Message-Id: <20191122055544.3299-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

[ Upstream commit 01b833ab44c9e484060aad72267fc7e71beb559b ]

This should be 1 for normal allocations, 0 disables leak reporting.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Fixes: 85704cb8dcfd ("net/core/neighbour: tell kmemleak about hash tables")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9a28a21a51f05..2664ad58e5c01 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -368,7 +368,7 @@ static struct neigh_hash_table *neigh_hash_alloc(unsigned int shift)
 		buckets = (struct neighbour __rcu **)
 			  __get_free_pages(GFP_ATOMIC | __GFP_ZERO,
 					   get_order(size));
-		kmemleak_alloc(buckets, size, 0, GFP_ATOMIC);
+		kmemleak_alloc(buckets, size, 1, GFP_ATOMIC);
 	}
 	if (!buckets) {
 		kfree(ret);
-- 
2.20.1

