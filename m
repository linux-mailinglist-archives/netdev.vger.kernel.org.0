Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBCA3BF65D
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhGHHlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhGHHlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 03:41:02 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26779C061574;
        Thu,  8 Jul 2021 00:38:21 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1625729895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4zHBxaMAyTXtQ6h+HyhVoICHa4hb51TQtMkMoZjY9QQ=;
        b=ov8Z0rkyn7MGj7v9Z2mO2dCNaOvADpf/PHqvEaB1gEFBcNMOpGMzSZEa14blNHSrxsGGS+
        zXJnAMr4YNq2WL9T4EwfPRYyNYKTJdVTi0vEci/vTiAecsMGKJ8wBQN9z4tzCi+KM0ejAK
        6/Kzt/njNyT1bwzCTHv7D2egZbf8Vsk=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, ryazanov.s.a@gmail.com,
        johannes.berg@intel.com, avagin@gmail.com, vladimir.oltean@nxp.com,
        cong.wang@bytedance.com, roopa@cumulusnetworks.com,
        yajun.deng@linux.dev, zhudi21@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: rtnetlink: Fix rtnl_dereference return value is NULL
Date:   Thu,  8 Jul 2021 15:37:45 +0800
Message-Id: <20210708073745.13797-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtnl_dereference() may be return NULL in rtnl_unregister(),
so add this case handling.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/rtnetlink.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f6af3e74fc44..57ce22669b06 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -289,24 +289,27 @@ int rtnl_unregister(int protocol, int msgtype)
 	struct rtnl_link __rcu **tab;
 	struct rtnl_link *link;
 	int msgindex;
+	int ret = -ENOENT;
 
 	BUG_ON(protocol < 0 || protocol > RTNL_FAMILY_MAX);
 	msgindex = rtm_msgindex(msgtype);
 
 	rtnl_lock();
 	tab = rtnl_dereference(rtnl_msg_handlers[protocol]);
-	if (!tab) {
-		rtnl_unlock();
-		return -ENOENT;
-	}
+	if (!tab)
+		goto unlock;
 
 	link = rtnl_dereference(tab[msgindex]);
-	rcu_assign_pointer(tab[msgindex], NULL);
-	rtnl_unlock();
+	if (!link)
+		goto unlock;
 
+	rcu_assign_pointer(tab[msgindex], NULL);
 	kfree_rcu(link, rcu);
+	ret = 0;
 
-	return 0;
+unlock:
+	rtnl_unlock();
+	return ret;
 }
 EXPORT_SYMBOL_GPL(rtnl_unregister);
 
-- 
2.32.0

