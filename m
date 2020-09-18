Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF0B26F025
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgIRCLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728609AbgIRCLU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 767B9235F8;
        Fri, 18 Sep 2020 02:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395079;
        bh=2FhpMM7YK2Frh/1hidyqqdIo9NYXx5rasKpjyI38Hmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIYvstmwNx1kNPOdEyX2LOHFK1s0y0y0SPeXjMrO2AZXk8kMGys5xpWqqKVgfRYKN
         JBURXvQYmuOJ9+O1fh62BbpNrUW0T0jLyizT89dnT+t/oKXBLICz6/kFxe/fwfJnss
         Cf7VkPZM+yy3BwJdU1k5p0ly0zMrts3n/vifD8xI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuong Lien <tuong.t.lien@dektech.com.au>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Thang Ngo <thang.h.ngo@dektech.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 162/206] tipc: fix memory leak in service subscripting
Date:   Thu, 17 Sep 2020 22:07:18 -0400
Message-Id: <20200918020802.2065198-162-sashal@kernel.org>
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

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit 0771d7df819284d46cf5cfb57698621b503ec17f ]

Upon receipt of a service subscription request from user via a topology
connection, one 'sub' object will be allocated in kernel, so it will be
able to send an event of the service if any to the user correspondingly
then. Also, in case of any failure, the connection will be shutdown and
all the pertaining 'sub' objects will be freed.

However, there is a race condition as follows resulting in memory leak:

       receive-work       connection        send-work
              |                |                |
        sub-1 |<------//-------|                |
        sub-2 |<------//-------|                |
              |                |<---------------| evt for sub-x
        sub-3 |<------//-------|                |
              :                :                :
              :                :                :
              |       /--------|                |
              |       |        * peer closed    |
              |       |        |                |
              |       |        |<-------X-------| evt for sub-y
              |       |        |<===============|
        sub-n |<------/        X    shutdown    |
    -> orphan |                                 |

That is, the 'receive-work' may get the last subscription request while
the 'send-work' is shutting down the connection due to peer close.

We had a 'lock' on the connection, so the two actions cannot be carried
out simultaneously. If the last subscription is allocated e.g. 'sub-n',
before the 'send-work' closes the connection, there will be no issue at
all, the 'sub' objects will be freed. In contrast the last subscription
will become orphan since the connection was closed, and we released all
references.

This commit fixes the issue by simply adding one test if the connection
remains in 'connected' state right after we obtain the connection lock,
then a subscription object can be created as usual, otherwise we ignore
it.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Reported-by: Thang Ngo <thang.h.ngo@dektech.com.au>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/topsrv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 41f4464ac6cc5..ec9a7137d2677 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -407,7 +407,9 @@ static int tipc_conn_rcv_from_sock(struct tipc_conn *con)
 		return -EWOULDBLOCK;
 	if (ret == sizeof(s)) {
 		read_lock_bh(&sk->sk_callback_lock);
-		ret = tipc_conn_rcv_sub(srv, con, &s);
+		/* RACE: the connection can be closed in the meantime */
+		if (likely(connected(con)))
+			ret = tipc_conn_rcv_sub(srv, con, &s);
 		read_unlock_bh(&sk->sk_callback_lock);
 		if (!ret)
 			return 0;
-- 
2.25.1

