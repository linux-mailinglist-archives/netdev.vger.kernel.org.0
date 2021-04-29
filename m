Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197D336E911
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 12:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240471AbhD2Kvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 06:51:49 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:58827 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233114AbhD2Kvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 06:51:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UXALFKR_1619693458;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UXALFKR_1619693458)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 18:50:59 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     dhowells@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] net: rxrpc: Remove redundant assignment to ret
Date:   Thu, 29 Apr 2021 18:50:56 +0800
Message-Id: <1619693456-111530-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable 'ret' is set to -EOPNOTSUPP but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed.

Clean up the following clang-analyzer warning:

net/rxrpc/af_rxrpc.c:602:2: warning: Value stored to 'ret' is never read
[clang-analyzer-deadcode.DeadStores]

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/rxrpc/af_rxrpc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 41671af..f2d81c5 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -599,7 +599,6 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
 	_enter(",%d,%d,,%d", level, optname, optlen);
 
 	lock_sock(&rx->sk);
-	ret = -EOPNOTSUPP;
 
 	if (level == SOL_RXRPC) {
 		switch (optname) {
-- 
1.8.3.1

