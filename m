Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0B16B5542
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 00:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjCJXCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 18:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjCJXCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 18:02:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D11147838;
        Fri, 10 Mar 2023 15:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=eet2vNHP9SJyRytQAXeN8dV9MlcbH4NW2iBs2IrmZDA=; b=D0P+yBFRbDD6Jw9Y3fJhnTPsrq
        l88RCpE421CMXqcRp/zu8zhyDXD+kJD0SPKKMr5xdj+r+PBL4rWOKzpmL4ADiku7It8+dicSWA+bw
        5nSv3/FhwMiiZ8Qs3BCO6P8jWlSmByf6ebJTBPwM8+cdpQH34xs5/HsfavYDfFD5FCTCdYMvpHvb9
        ouAorx54GfC33pUF+eihyGd+4yFtUGNGOEJQMv6wZ44zglX7yyWeEPuJsBiZHS2ax8cVE0U6BJ5pf
        LZXiMI6IuRVZdUi5aHTL0FzKAnkhTIRa0NDDo0ybW8KUsYg13a1d12EQ91jREbJATq+Z2UUTZ7Tv9
        9M0tob/w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1palkh-00GZGm-Vp; Fri, 10 Mar 2023 23:02:20 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, keescook@chromium.org,
        yzaikin@google.com, j.granados@samsung.com,
        patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH] xfs: simplify two-level sysctl registration for xfs_table
Date:   Fri, 10 Mar 2023 15:02:19 -0800
Message-Id: <20230310230219.3948819-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
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

This is not clear to some so I've updated the docs for the sysctl
registration here:

https://lore.kernel.org/all/20230310223947.3917711-1-mcgrof@kernel.org/T/#u     

 fs/xfs/xfs_sysctl.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 546a6cd96729..fade33735393 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -210,28 +210,10 @@ static struct ctl_table xfs_table[] = {
 	{}
 };
 
-static struct ctl_table xfs_dir_table[] = {
-	{
-		.procname	= "xfs",
-		.mode		= 0555,
-		.child		= xfs_table
-	},
-	{}
-};
-
-static struct ctl_table xfs_root_table[] = {
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= xfs_dir_table
-	},
-	{}
-};
-
 int
 xfs_sysctl_register(void)
 {
-	xfs_table_header = register_sysctl_table(xfs_root_table);
+	xfs_table_header = register_sysctl("fs/xfs", xfs_table);
 	if (!xfs_table_header)
 		return -ENOMEM;
 	return 0;
-- 
2.39.1

