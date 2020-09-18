Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C8226EBA2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgIRCGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgIRCGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B41152376F;
        Fri, 18 Sep 2020 02:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394794;
        bh=mQuNhQ2qow8drIVBTh6YiAbV1CoN1qj3OWdYWoENEcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=js3U5nsnGQXf7qXlgCBNsMPD+sqoW+5lxSIzYZDW6cSwzImVRZudwXDm+irePDj/4
         XI6BIAMvdMxl6EQyB55WKh5G3ZOD4qB0g75JzUtx7XFAquoNwMx2MUCi99+/7Gmn+P
         ujBpe3rpePftQiHKMxN4wiAipZ0IZV611f4qKEEs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuong Lien <tuong.t.lien@dektech.com.au>,
        Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Thang Ngo <thang.h.ngo@dektech.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 264/330] tipc: fix memory leak in service subscripting
Date:   Thu, 17 Sep 2020 22:00:04 -0400
Message-Id: <20200918020110.2063155-264-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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
index 73dbed0c4b6b8..931c426673c02 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -400,7 +400,9 @@ static int tipc_conn_rcv_from_sock(struct tipc_conn *con)
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

