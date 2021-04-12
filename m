Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EB335CC5D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243543AbhDLQ2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:28:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243716AbhDLQ0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:26:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24FD561372;
        Mon, 12 Apr 2021 16:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244694;
        bh=nUvGJWgWbLvPWG9YfcI1jq3Ts2T5CZOYb7nvgqz96fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAtdyuzc9EH+hLHY1RSKgnCGWfARsu0Dt7S6hNJXZfoBJKchl45BdC42LUXDxR9o0
         Cj+yfv4OxlG2tDQxCsiuQ0BxgxeF/YD7SMPhy0b2q2CeVA1ApNOE9ixpQOnuqOyeEY
         vPzxf7fks198yABvm0o3ksAtwNjJGg+hCpmnqoyLyJ20RemjpAWqnOZFMC7hZt+DVr
         pPa9Gavp3y1mG1yY0SxEkXNtybVMD1mly81k4BOSfYl7kTZ0SLimaLEzZ2DOWDEQn8
         EJzuH9MRwEZLH6PfM4+mz8fLNnwKyWZMFMRBnHbLLlB289L3NhAaP7B9G+Vy/AR6nB
         woA0sgdr4SZPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 5.10 41/46] net/rds: Avoid potential use after free in rds_send_remove_from_sock
Date:   Mon, 12 Apr 2021 12:23:56 -0400
Message-Id: <20210412162401.314035-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
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
index 071a261fdaab..90ebcfe5fe3b 100644
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
index 985d0b7713ac..fe5264b9d4b3 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -665,7 +665,7 @@ static void rds_send_remove_from_sock(struct list_head *messages, int status)
 unlock_and_drop:
 		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
 		rds_message_put(rm);
-		if (was_on_sock)
+		if (was_on_sock && rm)
 			rds_message_put(rm);
 	}
 
-- 
2.30.2

