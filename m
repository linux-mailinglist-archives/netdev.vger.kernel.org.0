Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3833D9EF9
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbhG2HtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:49:14 -0400
Received: from out0.migadu.com ([94.23.1.103]:32110 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234765AbhG2HtM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 03:49:12 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627544947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eYna94/iq9qX8HUpO54fYGtWdCUpTqGssNfyTTxr8DE=;
        b=aVZzuZ+FQ414amE0JQHI7kvZsjymTf1vDhBHiuYXBDPAD93ApZHDWBnt484tkjf8v3yWd/
        DcrEOu1evS4aOj2fWo2Ka9SWZv1nGf0B6FQJMcDidppZ24j5ginTSQ5kuHALVvPKUFnsje
        t7/+gdzmM/0lEhs6C1EnUh7goarw8Cw=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] net: netlink: Remove unused function
Date:   Thu, 29 Jul 2021 15:48:54 +0800
Message-Id: <20210729074854.8968-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lockdep_genl_is_held() and its caller arm not used now, just remove them.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/linux/genetlink.h | 23 -----------------------
 net/netlink/genetlink.c   |  8 --------
 2 files changed, 31 deletions(-)

diff --git a/include/linux/genetlink.h b/include/linux/genetlink.h
index bc738504ab4a..c285968e437a 100644
--- a/include/linux/genetlink.h
+++ b/include/linux/genetlink.h
@@ -8,34 +8,11 @@
 /* All generic netlink requests are serialized by a global lock.  */
 extern void genl_lock(void);
 extern void genl_unlock(void);
-#ifdef CONFIG_LOCKDEP
-extern bool lockdep_genl_is_held(void);
-#endif
 
 /* for synchronisation between af_netlink and genetlink */
 extern atomic_t genl_sk_destructing_cnt;
 extern wait_queue_head_t genl_sk_destructing_waitq;
 
-/**
- * rcu_dereference_genl - rcu_dereference with debug checking
- * @p: The pointer to read, prior to dereferencing
- *
- * Do an rcu_dereference(p), but check caller either holds rcu_read_lock()
- * or genl mutex. Note : Please prefer genl_dereference() or rcu_dereference()
- */
-#define rcu_dereference_genl(p)					\
-	rcu_dereference_check(p, lockdep_genl_is_held())
-
-/**
- * genl_dereference - fetch RCU pointer when updates are prevented by genl mutex
- * @p: The pointer to read, prior to dereferencing
- *
- * Return the value of the specified RCU-protected pointer, but omit
- * the READ_ONCE(), because caller holds genl mutex.
- */
-#define genl_dereference(p)					\
-	rcu_dereference_protected(p, lockdep_genl_is_held())
-
 #define MODULE_ALIAS_GENL_FAMILY(family)\
  MODULE_ALIAS_NET_PF_PROTO_NAME(PF_NETLINK, NETLINK_GENERIC, "-family-" family)
 
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index ae58da608a31..1afca2a6c2ac 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -40,14 +40,6 @@ void genl_unlock(void)
 }
 EXPORT_SYMBOL(genl_unlock);
 
-#ifdef CONFIG_LOCKDEP
-bool lockdep_genl_is_held(void)
-{
-	return lockdep_is_held(&genl_mutex);
-}
-EXPORT_SYMBOL(lockdep_genl_is_held);
-#endif
-
 static void genl_lock_all(void)
 {
 	down_write(&cb_lock);
-- 
2.32.0

