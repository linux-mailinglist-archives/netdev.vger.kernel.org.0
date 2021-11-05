Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30B444600C
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 08:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhKEHPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 03:15:38 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:39495 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231403AbhKEHPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 03:15:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Uv7vdPe_1636096374;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Uv7vdPe_1636096374)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Nov 2021 15:12:56 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     ap420073@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] amt: Fix NULL but dereferenced coccicheck error
Date:   Fri,  5 Nov 2021 15:12:50 +0800
Message-Id: <1636096370-19862-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:
./drivers/net/amt.c:2795:6-9: ERROR: amt is NULL but dereferenced.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/amt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 896c9e2..cfd6c8c 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2766,7 +2766,7 @@ static int amt_err_lookup(struct sock *sk, struct sk_buff *skb)
 	rcu_read_lock_bh();
 	amt = rcu_dereference_sk_user_data(sk);
 	if (!amt)
-		goto drop;
+		goto out;
 
 	if (amt->mode != AMT_MODE_GATEWAY)
 		goto drop;
@@ -2788,6 +2788,7 @@ static int amt_err_lookup(struct sock *sk, struct sk_buff *skb)
 	default:
 		goto drop;
 	}
+out:
 	rcu_read_unlock_bh();
 	return 0;
 drop:
-- 
1.8.3.1

