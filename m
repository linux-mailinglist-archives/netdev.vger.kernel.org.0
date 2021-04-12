Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905C035CDBA
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244188AbhDLQiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343631AbhDLQfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:35:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70FB86101B;
        Mon, 12 Apr 2021 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244819;
        bh=LuXvPBRB+cV/CxpnLpPWOlY3a2ln1he/OSJi+cyPhD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvWbdpsUHi5H8L6SVT01ggswKwUxCHq6IRWvJjoNG7pCteG2f5ncLpmQQnVQjaXse
         7HPBmly0D87oC5j4hXsv6CiVLTrd/t6DG8G+mLcH8aZhxyt4PE2+seAwArJM8/vjsA
         EHLV5uZa5z/bqRtxybatghqwEtLdMvdgifOayOQkeFj6j+umaBX0VYFY9qde4RkCns
         7SGVqOju7qMQKPUIIrR6uKCYAumNylSAdEJs+XHKaV1UGrrWUDtw6yxZ+elWWfO7gh
         hWv9Val+8THpEaZCAl36zGXY8SOFd5uclP8Sr4Y4Ukac/P8V+9180AWzK7e5m1DJMk
         1sIfowbPyN9nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 4.14 22/25] net/rds: Avoid potential use after free in rds_send_remove_from_sock
Date:   Mon, 12 Apr 2021 12:26:27 -0400
Message-Id: <20210412162630.315526-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162630.315526-1-sashal@kernel.org>
References: <20210412162630.315526-1-sashal@kernel.org>
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
index 4318cc9b78f7..b6765ead733b 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -91,6 +91,7 @@ void rds_message_put(struct rds_message *rm)
 		rds_message_purge(rm);
 
 		kfree(rm);
+		rm = NULL;
 	}
 }
 EXPORT_SYMBOL_GPL(rds_message_put);
diff --git a/net/rds/send.c b/net/rds/send.c
index 23f2d81e7967..3a8e1f72bf33 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -645,7 +645,7 @@ static void rds_send_remove_from_sock(struct list_head *messages, int status)
 unlock_and_drop:
 		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
 		rds_message_put(rm);
-		if (was_on_sock)
+		if (was_on_sock && rm)
 			rds_message_put(rm);
 	}
 
-- 
2.30.2

