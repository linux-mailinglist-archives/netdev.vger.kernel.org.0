Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646B354C365
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242579AbiFOIWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbiFOIWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:22:18 -0400
X-Greylist: delayed 129 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Jun 2022 01:22:16 PDT
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8EF2BB04
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 01:22:15 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id KGK00005;
        Wed, 15 Jun 2022 16:20:05 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201602.home.langchao.com (10.100.2.2) with Microsoft SMTP Server id
 15.1.2308.27; Wed, 15 Jun 2022 16:20:04 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <trond.myklebust@hammerspace.com>, <anna@kernel.org>,
        <chuck.lever@oracle.com>, <jlayton@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Bo Liu <liubo03@inspur.com>
Subject: [PATCH] SUNRPC: Directly use ida_alloc()/free()
Date:   Wed, 15 Jun 2022 04:20:02 -0400
Message-ID: <20220615082002.4441-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   202261516200570aaf07f5269bce998030b4d9891118c
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use ida_alloc()/ida_free() instead of
ida_simple_get()/ida_simple_remove().
The latter is deprecated and more verbose.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 net/sunrpc/clnt.c          | 4 ++--
 net/sunrpc/xprt.c          | 4 ++--
 net/sunrpc/xprtmultipath.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index b6781ada3aa8..614e4a68f4d0 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -345,7 +345,7 @@ static int rpc_alloc_clid(struct rpc_clnt *clnt)
 {
 	int clid;
 
-	clid = ida_simple_get(&rpc_clids, 0, 0, GFP_KERNEL);
+	clid = ida_alloc(&rpc_clids, GFP_KERNEL);
 	if (clid < 0)
 		return clid;
 	clnt->cl_clid = clid;
@@ -354,7 +354,7 @@ static int rpc_alloc_clid(struct rpc_clnt *clnt)
 
 static void rpc_free_clid(struct rpc_clnt *clnt)
 {
-	ida_simple_remove(&rpc_clids, clnt->cl_clid);
+	ida_free(&rpc_clids, clnt->cl_clid);
 }
 
 static struct rpc_clnt * rpc_new_client(const struct rpc_create_args *args,
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 86d62cffba0d..0441e38bcd9a 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1777,7 +1777,7 @@ static int xprt_alloc_id(struct rpc_xprt *xprt)
 {
 	int id;
 
-	id = ida_simple_get(&rpc_xprt_ids, 0, 0, GFP_KERNEL);
+	id = ida_alloc(&rpc_xprt_ids, GFP_KERNEL);
 	if (id < 0)
 		return id;
 
@@ -1787,7 +1787,7 @@ static int xprt_alloc_id(struct rpc_xprt *xprt)
 
 static void xprt_free_id(struct rpc_xprt *xprt)
 {
-	ida_simple_remove(&rpc_xprt_ids, xprt->id);
+	ida_free(&rpc_xprt_ids, xprt->id);
 }
 
 struct rpc_xprt *xprt_alloc(struct net *net, size_t size,
diff --git a/net/sunrpc/xprtmultipath.c b/net/sunrpc/xprtmultipath.c
index 1693f81aae37..3334a5fe4911 100644
--- a/net/sunrpc/xprtmultipath.c
+++ b/net/sunrpc/xprtmultipath.c
@@ -101,7 +101,7 @@ static int xprt_switch_alloc_id(struct rpc_xprt_switch *xps, gfp_t gfp_flags)
 {
 	int id;
 
-	id = ida_simple_get(&rpc_xprtswitch_ids, 0, 0, gfp_flags);
+	id = ida_alloc(&rpc_xprtswitch_ids, gfp_flags);
 	if (id < 0)
 		return id;
 
@@ -111,7 +111,7 @@ static int xprt_switch_alloc_id(struct rpc_xprt_switch *xps, gfp_t gfp_flags)
 
 static void xprt_switch_free_id(struct rpc_xprt_switch *xps)
 {
-	ida_simple_remove(&rpc_xprtswitch_ids, xps->xps_id);
+	ida_free(&rpc_xprtswitch_ids, xps->xps_id);
 }
 
 /**
-- 
2.27.0

