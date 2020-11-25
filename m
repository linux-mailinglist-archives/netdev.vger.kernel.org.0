Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F3A2C47A2
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733077AbgKYS3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:29:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733035AbgKYS3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 13:29:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606328971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vxFsbkr0ZlRNfWHmoQqEmFVEQcmfyLZNp0vYFnnoDGU=;
        b=cL7+sXkwyGVIKQx6sfn6KAFK9+iOH4Ap25das5hczBzSCIiGNv76krwoa11a3GflyuwyB0
        8p6GmNghcHYyvuFwCUN6gvM1EqRgSLZq0ikmHBfwyp7IK4SgaNFmluPi6bOg7dfGOZULO7
        D9Ms9q/IbKX9TxSU7ygjoINz3zOfA+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-otqKudesOC6nX-TKhFGVuA-1; Wed, 25 Nov 2020 13:29:25 -0500
X-MC-Unique: otqKudesOC6nX-TKhFGVuA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E443E1007477;
        Wed, 25 Nov 2020 18:29:23 +0000 (UTC)
Received: from f31.redhat.com (ovpn-113-167.rdu2.redhat.com [10.10.113.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44D2E19C46;
        Wed, 25 Nov 2020 18:29:22 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next v2 2/3] tipc: make node number calculation reproducible
Date:   Wed, 25 Nov 2020 13:29:14 -0500
Message-Id: <20201125182915.711370-3-jmaloy@redhat.com>
In-Reply-To: <20201125182915.711370-1-jmaloy@redhat.com>
References: <20201125182915.711370-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

The 32-bit node number, aka node hash or node address, is calculated
based on the 128-bit node identity when it is not set explicitly by
the user. In future commits we will need to perform this hash operation
on peer nodes while feeling safe that we obtain the same result.

We do this by interpreting the initial hash as a network byte order
number. Whenever we need to use the number locally on a node
we must therefore translate it to host byte order to obtain an
architecure independent result.

Furthermore, given the context where we use this number, we must not
allow it to be zero unless the node identity also is zero. Hence, in
the rare cases when the xor-ed hash value may end up as zero we replace
it with a fix number, knowing that the code anyway is capable of
handling hash collisions.

Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jmaloy@redhat.com>

---
v2: fixed sparse warning reported by kernel test robot <lkp@intel.com>
---
 net/tipc/addr.c |  7 +++----
 net/tipc/addr.h |  1 +
 net/tipc/core.h | 12 ++++++++++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/tipc/addr.c b/net/tipc/addr.c
index 0f1eaed1bd1b..abe29d1aa23a 100644
--- a/net/tipc/addr.c
+++ b/net/tipc/addr.c
@@ -55,12 +55,11 @@ bool tipc_in_scope(bool legacy_format, u32 domain, u32 addr)
 void tipc_set_node_id(struct net *net, u8 *id)
 {
 	struct tipc_net *tn = tipc_net(net);
-	u32 *tmp = (u32 *)id;
 
 	memcpy(tn->node_id, id, NODE_ID_LEN);
 	tipc_nodeid2string(tn->node_id_string, id);
-	tn->trial_addr = tmp[0] ^ tmp[1] ^ tmp[2] ^ tmp[3];
-	pr_info("Own node identity %s, cluster identity %u\n",
+	tn->trial_addr = hash128to32(id);
+	pr_info("Node identity %s, cluster identity %u\n",
 		tipc_own_id_string(net), tn->net_id);
 }
 
@@ -76,7 +75,7 @@ void tipc_set_node_addr(struct net *net, u32 addr)
 	}
 	tn->trial_addr = addr;
 	tn->addr_trial_end = jiffies;
-	pr_info("32-bit node address hash set to %x\n", addr);
+	pr_info("Node number set to %u\n", addr);
 }
 
 char *tipc_nodeid2string(char *str, u8 *id)
diff --git a/net/tipc/addr.h b/net/tipc/addr.h
index 31bee0ea7b3e..1a11831bef62 100644
--- a/net/tipc/addr.h
+++ b/net/tipc/addr.h
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2000-2006, 2018, Ericsson AB
  * Copyright (c) 2004-2005, Wind River Systems
+ * Copyright (c) 2020, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/net/tipc/core.h b/net/tipc/core.h
index df34dcdd0607..03de7b213f55 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2005-2006, 2013-2018 Ericsson AB
  * Copyright (c) 2005-2007, 2010-2013, Wind River Systems
+ * Copyright (c) 2020, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -210,6 +211,17 @@ static inline u32 tipc_net_hash_mixes(struct net *net, int tn_rand)
 	return net_hash_mix(&init_net) ^ net_hash_mix(net) ^ tn_rand;
 }
 
+static inline u32 hash128to32(char *bytes)
+{
+	__be32 *tmp = (__be32 *)bytes;
+	u32 res;
+
+	res = ntohl(tmp[0] ^ tmp[1] ^ tmp[2] ^ tmp[3]);
+	if (likely(res))
+		return res;
+	return  ntohl(tmp[0] | tmp[1] | tmp[2] | tmp[3]);
+}
+
 #ifdef CONFIG_SYSCTL
 int tipc_register_sysctl(void);
 void tipc_unregister_sysctl(void);
-- 
2.25.4

