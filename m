Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DD815A567
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 10:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgBLJzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 04:55:16 -0500
Received: from mxhk.zte.com.cn ([63.217.80.70]:48150 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbgBLJzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 04:55:15 -0500
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id 0429CB67386CD6FE23CF;
        Wed, 12 Feb 2020 17:55:14 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notessmtp.zte.com.cn [10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id 01C9sg5i032881;
        Wed, 12 Feb 2020 17:54:42 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2020021217550296-2102571 ;
          Wed, 12 Feb 2020 17:55:02 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        wang.liang82@zte.com.cn, Huang Zijiang <huang.zijiang@zte.com.cn>
Subject: [PATCH] xfrm: Use kmem_cache_zalloc() instead of kmem_cache_alloc() with flag GFP_ZERO.
Date:   Wed, 12 Feb 2020 17:54:36 +0800
Message-Id: <1581501276-5636-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2020-02-12 17:55:03,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2020-02-12 17:54:45,
        Serialize complete at 2020-02-12 17:54:45
X-MAIL: mse-fl1.zte.com.cn 01C9sg5i032881
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huang Zijiang <huang.zijiang@zte.com.cn>

Use kmem_cache_zalloc instead of manually setting kmem_cache_alloc
with flag GFP_ZERO since kzalloc sets allocated memory
to zero.

Change in v2:
     add indation

Signed-off-by: Huang Zijiang <huang.zijiang@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 net/xfrm/xfrm_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index f342356..6ac25f7 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -612,7 +612,7 @@ struct xfrm_state *xfrm_state_alloc(struct net *net)
 {
 	struct xfrm_state *x;
 
-	x = kmem_cache_alloc(xfrm_state_cache, GFP_ATOMIC | __GFP_ZERO);
+	x = kmem_cache_zalloc(xfrm_state_cache, GFP_ATOMIC);
 
 	if (x) {
 		write_pnet(&x->xs_net, net);
-- 
1.9.1

