Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F2745537
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 09:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbfFNHEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 03:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbfFNHEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 03:04:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B218D2084E;
        Fri, 14 Jun 2019 07:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560495881;
        bh=3WWtnLjJKzl9IXQdtTIEOivozhXBL7N4KD/OswzeK1Y=;
        h=Date:From:To:Cc:Subject:From;
        b=Of8mtxozvfhHAYJlZTd1+bLb+bZWh2JasIO5XWtEz68AyKeT0osw/dY7CHebbz53u
         rWjZK+qZG7Q4Hg4wM3uHegWyupNsuPodRqX3/05Tz6eBUWdRlUdmxDxN6M+4ITbxCj
         rYon+h3z8Rg//J0Dc19MIfHVpQFN2FCrNC6YER+U=
Date:   Fri, 14 Jun 2019 09:04:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Guillaume Nault <g.nault@alphalink.fr>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] l2tp: no need to check return value of debugfs_create
 functions
Message-ID: <20190614070438.GA25351@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Also, there is no need to store the individual debugfs file name, just
remove the whole directory all at once, saving a local variable.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guillaume Nault <g.nault@alphalink.fr>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_debugfs.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 6e2b4b9267e1..35bb4f3bdbe0 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -31,7 +31,6 @@
 #include "l2tp_core.h"
 
 static struct dentry *rootdir;
-static struct dentry *tunnels;
 
 struct l2tp_dfs_seq_data {
 	struct net *net;
@@ -326,32 +325,18 @@ static const struct file_operations l2tp_dfs_fops = {
 
 static int __init l2tp_debugfs_init(void)
 {
-	int rc = 0;
-
 	rootdir = debugfs_create_dir("l2tp", NULL);
-	if (IS_ERR(rootdir)) {
-		rc = PTR_ERR(rootdir);
-		rootdir = NULL;
-		goto out;
-	}
 
-	tunnels = debugfs_create_file("tunnels", 0600, rootdir, NULL, &l2tp_dfs_fops);
-	if (tunnels == NULL)
-		rc = -EIO;
+	debugfs_create_file("tunnels", 0600, rootdir, NULL, &l2tp_dfs_fops);
 
 	pr_info("L2TP debugfs support\n");
 
-out:
-	if (rc)
-		pr_warn("unable to init\n");
-
-	return rc;
+	return 0;
 }
 
 static void __exit l2tp_debugfs_exit(void)
 {
-	debugfs_remove(tunnels);
-	debugfs_remove(rootdir);
+	debugfs_remove_recursive(rootdir);
 }
 
 module_init(l2tp_debugfs_init);
-- 
2.22.0

