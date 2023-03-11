Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A37A6B6224
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 00:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjCKXj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 18:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCKXjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 18:39:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED49636080;
        Sat, 11 Mar 2023 15:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JMrOLqBblBfuXk+q4S5+9mk7xuUL4OAY5iCRONC3a9s=; b=0/v+R9IPFNWntmPcpjlL15fvu0
        M9xKiq+QbXN/d482W6msoOVilIoSDxS6zD+KWQYLwFqAyJFglZ3gUZtDiwfFfduWCLFPaw6VjUeNk
        9f1Kyh2tlwgXefYF7pp9X8Cs4VTBlf9KKyPIGPzNB5o/kLgICWnys1NQ3A+DKX7YPEwxE/Sk7LZEV
        pPtNaqNjM7Req9EYo+ZQz16QrY8zJTGdFaQEwWqWcOe0PBfnZwqyE5ExmRqRJlQOoPoqtA+CibPWs
        BbCxQIELVWbqhsDH2sBlR4rffpOdSv9NltJzxoiZXnDAoM5u19nczIzz72xBuVPWgk83tqM9wc5AR
        jAYCzgIg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pb8oT-001UJm-1w; Sat, 11 Mar 2023 23:39:45 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     chuck.lever@oracle.com, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, linux-nfs@vger.kernel.org
Cc:     ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
        j.granados@samsung.com, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v3 3/5] sunrpc: simplify one-level sysctl registration for xs_tunables_table
Date:   Sat, 11 Mar 2023 15:39:42 -0800
Message-Id: <20230311233944.354858-4-mcgrof@kernel.org>
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

There is no need to declare an extra tables to just create directory,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 net/sunrpc/xprtsock.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index aaa5b2741b79..46bbd6230650 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -77,7 +77,7 @@ static unsigned int xs_tcp_fin_timeout __read_mostly = XS_TCP_LINGER_TO;
 
 /*
  * We can register our own files under /proc/sys/sunrpc by
- * calling register_sysctl_table() again.  The files in that
+ * calling register_sysctl() again.  The files in that
  * directory become the union of all files registered there.
  *
  * We simply need to make sure that we don't collide with
@@ -157,15 +157,6 @@ static struct ctl_table xs_tunables_table[] = {
 	{ },
 };
 
-static struct ctl_table sunrpc_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= xs_tunables_table
-	},
-	{ },
-};
-
 /*
  * Wait duration for a reply from the RPC portmapper.
  */
@@ -3174,7 +3165,7 @@ static struct xprt_class	xs_bc_tcp_transport = {
 int init_socket_xprt(void)
 {
 	if (!sunrpc_table_header)
-		sunrpc_table_header = register_sysctl_table(sunrpc_table);
+		sunrpc_table_header = register_sysctl("sunrpc", xs_tunables_table);
 
 	xprt_register_transport(&xs_local_transport);
 	xprt_register_transport(&xs_udp_transport);
-- 
2.39.1

