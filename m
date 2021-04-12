Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DEF35CDC7
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243700AbhDLQik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245306AbhDLQcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B722D613C1;
        Mon, 12 Apr 2021 16:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244785;
        bh=4r1J+iMHVrRok9gveKkIVB2mrQwSLbeMgahkVyAyR1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoCzmEn1/H/Vdq2HGX7bb7IlGU13f6MfUMwRLmxK0JQTXElSbBdtwWRF4wTHcCypK
         NLzEPpi9sQkoG7U7wz00ZGDxqIl5zZp9V2VvvHXf8UvdCbxBUsquoFs4vv56tFg4cu
         gXAuD2VDnBqLGmFYGwAN5rH5ItnLc46TJVSqNGM62H4uEIM5Skk31Xk4rmSe/1027d
         nKkOVIzvXCkPvUVn+GMUrgP43g9tS5ArlnWwaUbI12WDUHbEuAKljzKKsBaATMtfeU
         91YqxsyJJHWymaNMiNZuHf2O7oOVy9Uh95qHDB7rRZI1giyuKC6iq5HfMlnM+tMeV2
         zmaAryQldg8Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 4.19 25/28] net/rds: Avoid potential use after free in rds_send_remove_from_sock
Date:   Mon, 12 Apr 2021 12:25:50 -0400
Message-Id: <20210412162553.315227-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162553.315227-1-sashal@kernel.org>
References: <20210412162553.315227-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 0c85a7e87465f2d4cbc768e245f4f45b2f299b05 ]

In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
is freed and later under spinlock, causing potential use-after-free.
Set the free pointer to NULL to avoid undefined behavior.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/message.c | 1 +
 net/rds/send.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 4b00b1152a5f..e35c9c914df0 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -180,6 +180,7 @@ void rds_message_put(struct rds_message *rm)
 		rds_message_purge(rm);
 
 		kfree(rm);
+		rm = NULL;
 	}
 }
 EXPORT_SYMBOL_GPL(rds_message_put);
diff --git a/net/rds/send.c b/net/rds/send.c
index 26e2c2305f7a..f480a447a432 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -655,7 +655,7 @@ static void rds_send_remove_from_sock(struct list_head *messages, int status)
 unlock_and_drop:
 		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
 		rds_message_put(rm);
-		if (was_on_sock)
+		if (was_on_sock && rm)
 			rds_message_put(rm);
 	}
 
-- 
2.30.2

