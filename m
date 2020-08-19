Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923E524984B
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 10:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgHSIdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 04:33:35 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60512 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726735AbgHSIdc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 04:33:32 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C50E1FCE6321FB2555C7;
        Wed, 19 Aug 2020 16:33:23 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 19 Aug 2020
 16:33:13 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <kafai@fb.com>, <daniel@iogearbox.net>, <jakub@cloudflare.com>,
        <keescook@chromium.org>, <zhang.lin16@zte.com.cn>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH v2] net: Stop warning about SO_BSDCOMPAT usage
Date:   Wed, 19 Aug 2020 04:32:08 -0400
Message-ID: <20200819083208.17825-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We've been warning about SO_BSDCOMPAT usage for many years. We may remove
this code completely now.

Suggested-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/core/sock.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index e4f40b175acb..64d2aec5ed45 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -413,18 +413,6 @@ static int sock_set_timeout(long *timeo_p, sockptr_t optval, int optlen,
 	return 0;
 }
 
-static void sock_warn_obsolete_bsdism(const char *name)
-{
-	static int warned;
-	static char warncomm[TASK_COMM_LEN];
-	if (strcmp(warncomm, current->comm) && warned < 5) {
-		strcpy(warncomm,  current->comm);
-		pr_warn("process `%s' is using obsolete %s SO_BSDCOMPAT\n",
-			warncomm, name);
-		warned++;
-	}
-}
-
 static bool sock_needs_netstamp(const struct sock *sk)
 {
 	switch (sk->sk_family) {
@@ -984,7 +972,6 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_BSDCOMPAT:
-		sock_warn_obsolete_bsdism("setsockopt");
 		break;
 
 	case SO_PASSCRED:
@@ -1387,7 +1374,6 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_BSDCOMPAT:
-		sock_warn_obsolete_bsdism("getsockopt");
 		break;
 
 	case SO_TIMESTAMP_OLD:
-- 
2.19.1

