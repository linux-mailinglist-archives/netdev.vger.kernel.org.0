Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB4735CE3C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245441AbhDLQnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245725AbhDLQh7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0396136B;
        Mon, 12 Apr 2021 16:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244884;
        bh=X71mqUhI13FrRualBoEXM2HTWBMdKMt/5yloOHgJxQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMO24C2goPPRk+yYuuil0juDpLChuv1TG2MD8WAojSGtd7pYWJVaZHQmI2vVNwexc
         HbZT2Oh76aImNYmvVKT6QK3KWDh506zESGmxjOS2b39kMzPb5gFPL5iQVRXfevC6Og
         t7DHROaPvtfqamB8iZ0Nasu3xzZsL6uF4dDBKSKpsTAtN9GIRSKxPLKQ3kNtZ0XR/+
         0fKFhB9i1DuYkIQY2FHHGAfdKZ3pZ4xxAPh67h6RbnMKb+1Sq60ZtPsn5C47m6ynMD
         K3uATL7QQefvlWhtqsqjafGIJqMwoEJcIvudAnf4PR0qziDK3hqXDka+9v2JsNUfVg
         7mNdTouBJcI5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 4.4 21/23] net/rds: Avoid potential use after free in rds_send_remove_from_sock
Date:   Mon, 12 Apr 2021 12:27:34 -0400
Message-Id: <20210412162736.316026-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
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
index 756c73729126..decf2ee33c23 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -89,6 +89,7 @@ void rds_message_put(struct rds_message *rm)
 		rds_message_purge(rm);
 
 		kfree(rm);
+		rm = NULL;
 	}
 }
 EXPORT_SYMBOL_GPL(rds_message_put);
diff --git a/net/rds/send.c b/net/rds/send.c
index 1a3c6acdd3f8..1415a296f7b2 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -668,7 +668,7 @@ static void rds_send_remove_from_sock(struct list_head *messages, int status)
 unlock_and_drop:
 		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
 		rds_message_put(rm);
-		if (was_on_sock)
+		if (was_on_sock && rm)
 			rds_message_put(rm);
 	}
 
-- 
2.30.2

