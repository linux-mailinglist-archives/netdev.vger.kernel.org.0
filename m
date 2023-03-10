Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539B26B54D5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbjCJWw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjCJWww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:52:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1004110CEBC;
        Fri, 10 Mar 2023 14:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=5AEXZhFwc3nu6gDvyJ80uX9izlYPfp1V+xq1fr6lUzs=; b=hWaTCXnCUeMj6+QQsXm4vY3590
        pPIGHfDj7JjkgYhreQWe+A97o8Lxlb924FtWqY3GWxFTay3W3zsgv8VzLQ5EWW7JQ8U8Q5UoEytcg
        4eHsN2qzWirjN2PAVNiPRozkJpSIT/7gwmGvK4zuRmtB7GGGRA6VljrRR/xGyvzJ3TE8T4dU/lNQ6
        TIry1vKyTBckVt914lwMeGG8VatiP99arUOGx4DPcOkvF5qvOJezYaPRWV2JRH40QIt5QVXM7CNX0
        E42124ao1F3oOoRxaeHM5/diX610n0Lb5nnfWVS0pcDBl81IUlItRpnXFtNeCmUJGz0eD1jYLtYTi
        QDR8kPHg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1palbL-00GWql-Pa; Fri, 10 Mar 2023 22:52:39 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     chuck.lever@oracle.com, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, linux-nfs@vger.kernel.org
Cc:     ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
        j.granados@samsung.com, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 4/5] sunrpc: move sunrpc_table above
Date:   Fri, 10 Mar 2023 14:52:35 -0800
Message-Id: <20230310225236.3939443-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230310225236.3939443-1-mcgrof@kernel.org>
References: <20230310225236.3939443-1-mcgrof@kernel.org>
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
 net/sunrpc/sysctl.c | 98 ++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 50 deletions(-)

diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index 3aad6ef18504..4120797bf740 100644
--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -41,7 +41,54 @@ EXPORT_SYMBOL_GPL(nlm_debug);
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 
 static struct ctl_table_header *sunrpc_table_header;
-static struct ctl_table sunrpc_table[];
+
+static struct ctl_table debug_table[] = {
+	{
+		.procname	= "rpc_debug",
+		.data		= &rpc_debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dodebug
+	},
+	{
+		.procname	= "nfs_debug",
+		.data		= &nfs_debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dodebug
+	},
+	{
+		.procname	= "nfsd_debug",
+		.data		= &nfsd_debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dodebug
+	},
+	{
+		.procname	= "nlm_debug",
+		.data		= &nlm_debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dodebug
+	},
+	{
+		.procname	= "transports",
+		.maxlen		= 256,
+		.mode		= 0444,
+		.proc_handler	= proc_do_xprt,
+	},
+	{ }
+};
+
+static struct ctl_table sunrpc_table[] = {
+	{
+		.procname	= "sunrpc",
+		.mode		= 0555,
+		.child		= debug_table
+	},
+	{ }
+};
+
 
 void
 rpc_register_sysctl(void)
@@ -141,53 +188,4 @@ proc_dodebug(struct ctl_table *table, int write, void *buffer, size_t *lenp,
 	*ppos += *lenp;
 	return 0;
 }
-
-
-static struct ctl_table debug_table[] = {
-	{
-		.procname	= "rpc_debug",
-		.data		= &rpc_debug,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dodebug
-	},
-	{
-		.procname	= "nfs_debug",
-		.data		= &nfs_debug,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dodebug
-	},
-	{
-		.procname	= "nfsd_debug",
-		.data		= &nfsd_debug,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dodebug
-	},
-	{
-		.procname	= "nlm_debug",
-		.data		= &nlm_debug,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dodebug
-	},
-	{
-		.procname	= "transports",
-		.maxlen		= 256,
-		.mode		= 0444,
-		.proc_handler	= proc_do_xprt,
-	},
-	{ }
-};
-
-static struct ctl_table sunrpc_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= debug_table
-	},
-	{ }
-};
-
 #endif
-- 
2.39.1

