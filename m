Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34313B7CDD
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 07:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhF3FOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 01:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbhF3FOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 01:14:06 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A0BC061766;
        Tue, 29 Jun 2021 22:11:37 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1625029894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xugq2Itb92GveGC9lFrpW1MMdYEHoWa1T9rN2HNUDKY=;
        b=MHZr4odTyNS4111aBfmnfJLq5X6M+HczsTMpadbO/67kWKT4gL8lESEOm3RPx2CXT5WPnj
        hNQXX9plwJtCyFyd4nVqTjlBdjgH6LFVpiJ2+7wMNB+op0w8pbyEIo337SAXw2rLa9GQnc
        IPO+vgycuNwp73PpNSm0ooZ2oJM3N6w=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, andriin@fb.com,
        atenart@kernel.org, alobakin@pm.me, ast@kernel.org,
        edumazet@google.com, daniel@iogearbox.net, weiwan@google.com,
        ap420073@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] net: core: Modify alloc_size in alloc_netdev_mqs()
Date:   Wed, 30 Jun 2021 13:11:18 +0800
Message-Id: <20210630051118.2212-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use ALIGN for 'struct net_device', and remove the unneeded
'NETDEV_ALIGN - 1'. This can save a few bytes. and modify
the pr_err content when txqs < 1.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/dev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c253c2aafe97..c42a682a624d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10789,7 +10789,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	BUG_ON(strlen(name) >= sizeof(dev->name));
 
 	if (txqs < 1) {
-		pr_err("alloc_netdev: Unable to allocate device with zero queues\n");
+		pr_err("alloc_netdev: Unable to allocate device with zero TX queues\n");
 		return NULL;
 	}
 
@@ -10798,14 +10798,12 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 		return NULL;
 	}
 
-	alloc_size = sizeof(struct net_device);
+	/* ensure 32-byte alignment of struct net_device*/
+	alloc_size = ALIGN(sizeof(struct net_device), NETDEV_ALIGN);
 	if (sizeof_priv) {
 		/* ensure 32-byte alignment of private area */
-		alloc_size = ALIGN(alloc_size, NETDEV_ALIGN);
-		alloc_size += sizeof_priv;
+		alloc_size += ALIGN(sizeof_priv, NETDEV_ALIGN);
 	}
-	/* ensure 32-byte alignment of whole construct */
-	alloc_size += NETDEV_ALIGN - 1;
 
 	p = kvzalloc(alloc_size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!p)
-- 
2.32.0

