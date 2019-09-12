Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC45B0749
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 05:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbfILDpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 23:45:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2217 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfILDpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 23:45:01 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 035C1B7E71A04F8CF1B3;
        Thu, 12 Sep 2019 11:44:59 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 12 Sep 2019 11:44:52 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>
CC:     <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH v2 net 1/3] sctp: change return type of sctp_get_port_local
Date:   Thu, 12 Sep 2019 12:02:17 +0800
Message-ID: <20190912040219.67517-2-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190912040219.67517-1-maowenan@huawei.com>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
 <20190912040219.67517-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently sctp_get_port_local() returns a long
which is either 0,1 or a pointer casted to long.
It's neither of the callers use the return value since
commit 62208f12451f ("net: sctp: simplify sctp_get_port").
Now two callers are sctp_get_port and sctp_do_bind,
they actually assumend a casted to an int was the same as
a pointer casted to a long, and they don't save the return
value just check whether it is zero or non-zero, so
it would better change return type from long to int for
sctp_get_port_local.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 net/sctp/socket.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9d1f83b10c0a..5e1934c48709 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -309,7 +309,7 @@ static int sctp_bind(struct sock *sk, struct sockaddr *addr, int addr_len)
 	return retval;
 }
 
-static long sctp_get_port_local(struct sock *, union sctp_addr *);
+static int sctp_get_port_local(struct sock *, union sctp_addr *);
 
 /* Verify this is a valid sockaddr. */
 static struct sctp_af *sctp_sockaddr_af(struct sctp_sock *opt,
@@ -7998,7 +7998,7 @@ static void sctp_unhash(struct sock *sk)
 static struct sctp_bind_bucket *sctp_bucket_create(
 	struct sctp_bind_hashbucket *head, struct net *, unsigned short snum);
 
-static long sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
+static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 {
 	struct sctp_sock *sp = sctp_sk(sk);
 	bool reuse = (sk->sk_reuse || sp->reuse);
@@ -8108,7 +8108,7 @@ static long sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 
 			if (sctp_bind_addr_conflict(&ep2->base.bind_addr,
 						    addr, sp2, sp)) {
-				ret = (long)sk2;
+				ret = 1;
 				goto fail_unlock;
 			}
 		}
@@ -8180,7 +8180,7 @@ static int sctp_get_port(struct sock *sk, unsigned short snum)
 	addr.v4.sin_port = htons(snum);
 
 	/* Note: sk->sk_num gets filled in if ephemeral port request. */
-	return !!sctp_get_port_local(sk, &addr);
+	return sctp_get_port_local(sk, &addr);
 }
 
 /*
-- 
2.20.1

