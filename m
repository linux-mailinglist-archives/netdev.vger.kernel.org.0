Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BBA41054B
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 11:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238010AbhIRJFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 05:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbhIRJFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 05:05:53 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA71C061574;
        Sat, 18 Sep 2021 02:04:30 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1631955868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gpNR9/8KPrecHc3D9k5DESAhJBWWTEnz6U1deJxRqNU=;
        b=YzOVL+0c1++sx274jUEo8EWYWi+x4BRWsta6u1HAzAEpLFouD6E4tBIRRgV5nr9rjLwMIh
        A9RpTJV1H37fNPBujcK/4eB5oJHIIfcfbXgexG+CuP6sb6dluRKblsLxlcWdlfO67Wq32M
        wS/aRc5c397fdBCIGqh5obPsCDcdng0=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: net_namespace: Fix undefined member in key_remove_domain()
Date:   Sat, 18 Sep 2021 17:04:10 +0800
Message-Id: <20210918090410.29772-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The key_domain member in struct net only exists if we define CONFIG_KEYS.
So we should add the define when we used key_domain.

Fixes: 9b242610514f ("keys: Network namespace domain tag")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/net_namespace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a448a9b5bb2d..202fa5eacd0f 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -473,7 +473,9 @@ struct net *copy_net_ns(unsigned long flags,
 
 	if (rv < 0) {
 put_userns:
+#ifdef CONFIG_KEYS
 		key_remove_domain(net->key_domain);
+#endif
 		put_user_ns(user_ns);
 		net_free(net);
 dec_ucounts:
@@ -605,7 +607,9 @@ static void cleanup_net(struct work_struct *work)
 	list_for_each_entry_safe(net, tmp, &net_exit_list, exit_list) {
 		list_del_init(&net->exit_list);
 		dec_net_namespaces(net->ucounts);
+#ifdef CONFIG_KEYS
 		key_remove_domain(net->key_domain);
+#endif
 		put_user_ns(net->user_ns);
 		net_free(net);
 	}
-- 
2.32.0

