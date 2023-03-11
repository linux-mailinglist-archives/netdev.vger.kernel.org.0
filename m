Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332E06B60AE
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjCKUwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCKUwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:52:05 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FF26B5C5;
        Sat, 11 Mar 2023 12:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uVA5gkd7agM5XGy1IcOl4n0Hi/2VsqP4CuIiylpH99w=; b=2sfCSCCSYqnla7r5cEbjLxX5XG
        mWPsPA4I5aYIaO0CQoU/LuEURbrOXc9ZF4gLI7F/SYYQW0o78LP7XLImsoGftNTTyU0dC774xBLLC
        BDrOkVzyd0vHDmHoLv46OaBxE30K3cOJnhkol/6DRcfHyRmeSVXWBkiGfZLcilHs2BlqA/0kRKPR1
        ZRS8d3LHzh0/NJRLSK8Owz3LfMrxyincMlD1H3am0iLtwtQ7SxY+HW/u2I09ZI1szs0eqJ516mB2e
        7PBXCT6inJayGyV9fiVaJKXKuxw5vLoUaffIO8N8ejLQcrjkunqTvLR4NF5+sLDIe+OZLT5uu00TE
        JmJPQUbA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pb6Bz-001EKG-Ul; Sat, 11 Mar 2023 20:51:51 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     chuck.lever@oracle.com, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, linux-nfs@vger.kernel.org
Cc:     ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
        j.granados@samsung.com, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 4/5] sunrpc: move sunrpc_table and proc routines above
Date:   Sat, 11 Mar 2023 12:51:47 -0800
Message-Id: <20230311205148.293375-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230311205148.293375-1-mcgrof@kernel.org>
References: <20230311205148.293375-1-mcgrof@kernel.org>
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
 net/sunrpc/sysctl.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index 3aad6ef18504..a54438d68d1b 100644
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
@@ -141,7 +122,9 @@ proc_dodebug(struct ctl_table *table, int write, void *buffer, size_t *lenp,
 	*ppos += *lenp;
 	return 0;
 }
+#endif
 
+static struct ctl_table_header *sunrpc_table_header;
 
 static struct ctl_table debug_table[] = {
 	{
@@ -190,4 +173,19 @@ static struct ctl_table sunrpc_table[] = {
 	{ }
 };
 
-#endif
+
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
-- 
2.39.1

