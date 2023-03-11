Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925136B60A4
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjCKUwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCKUwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:52:04 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E046B30E;
        Sat, 11 Mar 2023 12:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=XIoPX8KdCwgXnvpcDRNW0+6992U8KOWdKG/zQLzC1bo=; b=NWdEVYNyVND64gD2By+ArxWn9i
        GvIMY2HatnEvgFY4p2eqCVZJUQlsVpbQdbGdOj1J5Dcbgj8ZFTg/Gw/9fM4sY/PrT6GVx/BNCMr5a
        ITVp7nxGYvJSYj/okyh/Zw0r5jUxu7iOtwKkWBAu0v1HKQDUcqNK8MF1e/2zkzD3Q7ImqZgXXij67
        x10IZd+p2vuDOiIII9LFdwA+77fZOMfpmU5yE1QE8yFC0xwNMmofXvYQx2COX7eQVH0rS3HS6/oPa
        1f+Jq/it/8POhExEYsnJq1BLbxVr3TSew4CTACPEO4hsSK5u8cBKs1sZ1DZOldqoPrzhzfZbvr5y/
        oqFvrMLg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pb6Bz-001EKA-Qm; Sat, 11 Mar 2023 20:51:51 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     chuck.lever@oracle.com, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, linux-nfs@vger.kernel.org
Cc:     ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
        j.granados@samsung.com, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 1/5] sunrpc: simplify two-level sysctl registration for tsvcrdma_parm_table
Date:   Sat, 11 Mar 2023 12:51:44 -0800
Message-Id: <20230311205148.293375-2-mcgrof@kernel.org>
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

There is no need to declare two tables to just create directories,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma.c b/net/sunrpc/xprtrdma/svc_rdma.c
index 5bc20e9d09cd..f0d5eeed4c88 100644
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -212,24 +212,6 @@ static struct ctl_table svcrdma_parm_table[] = {
 	{ },
 };
 
-static struct ctl_table svcrdma_table[] = {
-	{
-		.procname	= "svc_rdma",
-		.mode		= 0555,
-		.child		= svcrdma_parm_table
-	},
-	{ },
-};
-
-static struct ctl_table svcrdma_root_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= svcrdma_table
-	},
-	{ },
-};
-
 static void svc_rdma_proc_cleanup(void)
 {
 	if (!svcrdma_table_header)
@@ -263,7 +245,8 @@ static int svc_rdma_proc_init(void)
 	if (rc)
 		goto out_err;
 
-	svcrdma_table_header = register_sysctl_table(svcrdma_root_table);
+	svcrdma_table_header = register_sysctl("sunrpc/svc_rdma",
+					       svcrdma_parm_table);
 	return 0;
 
 out_err:
-- 
2.39.1

