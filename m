Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC78D6B622E
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 00:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCKXkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 18:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjCKXjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 18:39:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAD23669B;
        Sat, 11 Mar 2023 15:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=NyzvMGDdE58I8HPSATmgnyV0KqBaQSH9+ozf8EmTmiA=; b=oS4yMIs9QRvW/zUO51HWEeG4Rn
        V/4cVRVP0y3c8hrggtZfRj+HZNPddfYXEsV1xyx3i4GTwBGasNbuXvw8m7LChPeXOU8FR/OSRohME
        Y7B/+oPcwEnz7KNfUtct3ARK8lVkBQqTiYdEOtwZkyUsFVY9MlEmD/piiGsoYFdZM0t2MW50Wv6wF
        1hyqhaFGjiLNF9YZlMbIPStiOAOK9IlJ7S8qy+sclXlow4RTh6ZOYYCzag3PXlQGdnvkjtVTg6jH8
        jZAuV4hfi09B1FbGmgFGN459kfvV60lGo9oItn1cYoJQ0ssPj9qaba0ekXCpsChJI0yVZNRhCBjfn
        jS3y/hDg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pb8oT-001UJo-3W; Sat, 11 Mar 2023 23:39:45 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     chuck.lever@oracle.com, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, linux-nfs@vger.kernel.org
Cc:     ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
        j.granados@samsung.com, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v3 4/5] sunrpc: move sunrpc_table and proc routines above
Date:   Sat, 11 Mar 2023 15:39:43 -0800
Message-Id: <20230311233944.354858-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230311233944.354858-1-mcgrof@kernel.org>
References: <20230311233944.354858-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need to do a forward declaration for sunrpc_table, just move
the sysctls up as everyone else does it. This will make the next
change easier to read. This change produces no functional changes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 net/sunrpc/sysctl.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index 3aad6ef18504..afdfcc5403af 100644
--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -40,25 +40,6 @@ EXPORT_SYMBOL_GPL(nlm_debug);
 
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 
-static struct ctl_table_header *sunrpc_table_header;
-static struct ctl_table sunrpc_table[];
-
-void
-rpc_register_sysctl(void)
-{
-	if (!sunrpc_table_header)
-		sunrpc_table_header = register_sysctl_table(sunrpc_table);
-}
-
-void
-rpc_unregister_sysctl(void)
-{
-	if (sunrpc_table_header) {
-		unregister_sysctl_table(sunrpc_table_header);
-		sunrpc_table_header = NULL;
-	}
-}
-
 static int proc_do_xprt(struct ctl_table *table, int write,
 			void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -142,6 +123,7 @@ proc_dodebug(struct ctl_table *table, int write, void *buffer, size_t *lenp,
 	return 0;
 }
 
+static struct ctl_table_header *sunrpc_table_header;
 
 static struct ctl_table debug_table[] = {
 	{
@@ -190,4 +172,19 @@ static struct ctl_table sunrpc_table[] = {
 	{ }
 };
 
+void
+rpc_register_sysctl(void)
+{
+	if (!sunrpc_table_header)
+		sunrpc_table_header = register_sysctl_table(sunrpc_table);
+}
+
+void
+rpc_unregister_sysctl(void)
+{
+	if (sunrpc_table_header) {
+		unregister_sysctl_table(sunrpc_table_header);
+		sunrpc_table_header = NULL;
+	}
+}
 #endif
-- 
2.39.1

