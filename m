Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09CA35CE04
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245508AbhDLQlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343999AbhDLQgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D08F8613F2;
        Mon, 12 Apr 2021 16:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244852;
        bh=5AVya4vkuXwG5iXSO3Do1PXvm8C9ngfS9ohHbS+s88Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsWtypgjSUX+hSDgjcRQX8XHcJBUGWpuXvrU4KZ0LAezlWzP8Y7uFRxWtRS34GYDV
         H14FGGMwdL8haDBEByamACwzKSZXJzlDnzX1djSGR5x4poVF4dQeKog1fFmNhbLQJX
         makce/P2EWcWMsG64fquuyle7lfvFy3EGVVWSRrYTWLRhacMxz+jE5DO7VhxpqE+CO
         TctdFqaL6uS4UH4hnAoCdiGzQmgeMfzVfBMG6/T1ez6ADCfjAy87Y1jhiYFSND5x5v
         TjRYm+iUMozsw6MQnUXiyD6vK2onM8BDJf/xl53bBPBuJSmd9WaMjS/j8LcQa1+NqZ
         swDqxcvUaNieA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 4.9 21/23] net/rds: Avoid potential use after free in rds_send_remove_from_sock
Date:   Mon, 12 Apr 2021 12:27:02 -0400
Message-Id: <20210412162704.315783-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162704.315783-1-sashal@kernel.org>
References: <20210412162704.315783-1-sashal@kernel.org>
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
index 6cb91061556a..bee84584ce34 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -90,6 +90,7 @@ void rds_message_put(struct rds_message *rm)
 		rds_message_purge(rm);
 
 		kfree(rm);
+		rm = NULL;
 	}
 }
 EXPORT_SYMBOL_GPL(rds_message_put);
diff --git a/net/rds/send.c b/net/rds/send.c
index 50241d30e16d..a84198e1b87c 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -640,7 +640,7 @@ static void rds_send_remove_from_sock(struct list_head *messages, int status)
 unlock_and_drop:
 		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
 		rds_message_put(rm);
-		if (was_on_sock)
+		if (was_on_sock && rm)
 			rds_message_put(rm);
 	}
 
-- 
2.30.2

