Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4761410475
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 08:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240963AbhIRGiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 02:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240317AbhIRGhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 02:37:52 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B0DC061574;
        Fri, 17 Sep 2021 23:36:28 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1631946986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JjE8JbFp2PcQVKbk7Pgj0RU3yJDZrXvZ06dLQn+5PGk=;
        b=vqtLxEGKlxz6HcS+jU+VQKzZ8MFNH99GfrtNgaKwn7CU5QW6lXbac5OeJgcBlFIu03CXxm
        i2DaJELcGqrs5GYvWDza+cCZL/HYTV+i0fpZMGswMNuxhDJ5BjNgUvsAD7r73Jkkv8PCzz
        lUa675CVoQjdPvW0FZaDEi0YXjVQ8es=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: rtnetlink: convert rcu_assign_pointer to RCU_INIT_POINTER
Date:   Sat, 18 Sep 2021 14:36:07 +0800
Message-Id: <20210918063607.23681-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It no need barrier when assigning a NULL value to an RCU protected
pointer. So use RCU_INIT_POINTER() instead for more fast.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/rtnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 972c8cb303a5..327ca6bc6e6d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -301,7 +301,7 @@ int rtnl_unregister(int protocol, int msgtype)
 	}
 
 	link = rtnl_dereference(tab[msgindex]);
-	rcu_assign_pointer(tab[msgindex], NULL);
+	RCU_INIT_POINTER(tab[msgindex], NULL);
 	rtnl_unlock();
 
 	kfree_rcu(link, rcu);
@@ -337,7 +337,7 @@ void rtnl_unregister_all(int protocol)
 		if (!link)
 			continue;
 
-		rcu_assign_pointer(tab[msgindex], NULL);
+		RCU_INIT_POINTER(tab[msgindex], NULL);
 		kfree_rcu(link, rcu);
 	}
 	rtnl_unlock();
-- 
2.32.0

