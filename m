Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA674C86B
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 09:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbfFTHbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 03:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbfFTHbK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 03:31:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 141742084B;
        Thu, 20 Jun 2019 07:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561015869;
        bh=bnuYCgKUmuvtRTQdc4tFWDGE47kO98WZzTCc0MazlCM=;
        h=Date:From:To:Cc:Subject:From;
        b=TJ5oGd0mHfdNp12K3kbvX/+TO/nh7HGYYsD4HaGPHm3YG1gg2gswe4syU93uhPP6z
         dm37CECwapiz4SPoQ//LM/jTNJJR55sLDqEeGs8MhH0OMB1s57CKFlX9aWZ+Sjq175
         6jMZWCnXtYACjfP8aRTCh4VDfj6u+Kloq+wO5C2M=
Date:   Thu, 20 Jun 2019 09:31:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH] fjes: no need to check return value of debugfs_create
 functions
Message-ID: <20190620073106.GA22356@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Yangtao Li <tiny.windzz@gmail.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/fjes/fjes_debugfs.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/fjes/fjes_debugfs.c b/drivers/net/fjes/fjes_debugfs.c
index 7fed88ea27a5..25599edb4ceb 100644
--- a/drivers/net/fjes/fjes_debugfs.c
+++ b/drivers/net/fjes/fjes_debugfs.c
@@ -67,20 +67,11 @@ DEFINE_SHOW_ATTRIBUTE(fjes_dbg_status);
 void fjes_dbg_adapter_init(struct fjes_adapter *adapter)
 {
 	const char *name = dev_name(&adapter->plat_dev->dev);
-	struct dentry *pfile;
 
 	adapter->dbg_adapter = debugfs_create_dir(name, fjes_debug_root);
-	if (!adapter->dbg_adapter) {
-		dev_err(&adapter->plat_dev->dev,
-			"debugfs entry for %s failed\n", name);
-		return;
-	}
 
-	pfile = debugfs_create_file("status", 0444, adapter->dbg_adapter,
-				    adapter, &fjes_dbg_status_fops);
-	if (!pfile)
-		dev_err(&adapter->plat_dev->dev,
-			"debugfs status for %s failed\n", name);
+	debugfs_create_file("status", 0444, adapter->dbg_adapter, adapter,
+			    &fjes_dbg_status_fops);
 }
 
 void fjes_dbg_adapter_exit(struct fjes_adapter *adapter)
@@ -92,8 +83,6 @@ void fjes_dbg_adapter_exit(struct fjes_adapter *adapter)
 void fjes_dbg_init(void)
 {
 	fjes_debug_root = debugfs_create_dir(fjes_driver_name, NULL);
-	if (!fjes_debug_root)
-		pr_info("init of debugfs failed\n");
 }
 
 void fjes_dbg_exit(void)
-- 
2.22.0

