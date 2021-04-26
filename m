Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A05336B15E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 12:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhDZKNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 06:13:55 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:57124 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232103AbhDZKNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 06:13:54 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UWpc3AM_1619431985;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWpc3AM_1619431985)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 26 Apr 2021 18:13:11 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     dhowells@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] rxrpc: rxkad: Remove redundant variable offset
Date:   Mon, 26 Apr 2021 18:13:03 +0800
Message-Id: <1619431983-87222-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable offset is being assigned a value from a calculation
however the variable is never read, so this redundant variable
can be removed.

Cleans up the following clang-analyzer warning:

net/rxrpc/rxkad.c:579:2: warning: Value stored to 'offset' is never read
[clang-analyzer-deadcode.DeadStores].

net/rxrpc/rxkad.c:485:2: warning: Value stored to 'offset' is never read
[clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/rxrpc/rxkad.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index e2e9e9b..08aab5c 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -482,7 +482,6 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 					     RXKADDATALEN);
 		goto protocol_error;
 	}
-	offset += sizeof(sechdr);
 	len -= sizeof(sechdr);
 
 	buf = ntohl(sechdr.data_size);
@@ -576,7 +575,6 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 					     RXKADDATALEN);
 		goto protocol_error;
 	}
-	offset += sizeof(sechdr);
 	len -= sizeof(sechdr);
 
 	buf = ntohl(sechdr.data_size);
-- 
1.8.3.1

