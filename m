Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD428367D
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387884AbfHFQMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387868AbfHFQMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:12:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8C82216B7;
        Tue,  6 Aug 2019 16:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565107932;
        bh=jIFpVT8zalKSNdzF1RNkxL7M/yNdmeiIRopKihnsVMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4Ai1uOhIJwMVAf4lMoJXtvAYkQUcU6AegJRIgeSEAWqMXxdS33PWimkmL5aBwepd
         sPlyKUAcC+KxDj+1opC1ibR6Qz7s0O9Rurg8aKtBv1/ghFeATuZgcdrjha9R1Wbh4a
         iq/xoB8xfhHuDYAtw7aYz80PVAudvQyNeY+J247g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Casey Leedom <leedom@chelsio.com>
Subject: [PATCH 06/17] cxgb4: no need to check return value of debugfs_create functions
Date:   Tue,  6 Aug 2019 18:11:17 +0200
Message-Id: <20190806161128.31232-7-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806161128.31232-1-gregkh@linuxfoundation.org>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

If a debugfs call fails, it will properly warn in the syslog, there's no
need for all individual drivers to also print a message, so that is one
more reason to not care about checking the return values.

Cc: Vishal Kulkarni <vishal@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Casey Leedom <leedom@chelsio.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  5 ++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  3 ---
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   | 21 +++++++------------
 3 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 02959035ed3f..dd99c55d9a88 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3529,7 +3529,6 @@ int t4_setup_debugfs(struct adapter *adap)
 {
 	int i;
 	u32 size = 0;
-	struct dentry *de;
 
 	static struct t4_debugfs_entry t4_debugfs_files[] = {
 		{ "cim_la", &cim_la_fops, 0400, 0 },
@@ -3640,8 +3639,8 @@ int t4_setup_debugfs(struct adapter *adap)
 		}
 	}
 
-	de = debugfs_create_file_size("flash", 0400, adap->debugfs_root, adap,
-				      &flash_debugfs_fops, adap->params.sf_size);
+	debugfs_create_file_size("flash", 0400, adap->debugfs_root, adap,
+				 &flash_debugfs_fops, adap->params.sf_size);
 	debugfs_create_bool("use_backdoor", 0600,
 			    adap->debugfs_root, &adap->use_bd);
 	debugfs_create_bool("trace_rss", 0600,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 4311ad9c84b2..71854a19cebe 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6269,10 +6269,7 @@ static int __init cxgb4_init_module(void)
 {
 	int ret;
 
-	/* Debugfs support is optional, just warn if this fails */
 	cxgb4_debugfs_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (!cxgb4_debugfs_root)
-		pr_warn("could not create debugfs entry, continuing\n");
 
 	ret = pci_register_driver(&cxgb4_driver);
 	if (ret < 0)
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 6d4cf3d0b2f0..f6fc0875d5b0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -2478,11 +2478,10 @@ static int setup_debugfs(struct adapter *adapter)
 	 * Debugfs support is best effort.
 	 */
 	for (i = 0; i < ARRAY_SIZE(debugfs_files); i++)
-		(void)debugfs_create_file(debugfs_files[i].name,
-				  debugfs_files[i].mode,
-				  adapter->debugfs_root,
-				  (void *)adapter,
-				  debugfs_files[i].fops);
+		debugfs_create_file(debugfs_files[i].name,
+				    debugfs_files[i].mode,
+				    adapter->debugfs_root, (void *)adapter,
+				    debugfs_files[i].fops);
 
 	return 0;
 }
@@ -3257,11 +3256,7 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 		adapter->debugfs_root =
 			debugfs_create_dir(pci_name(pdev),
 					   cxgb4vf_debugfs_root);
-		if (IS_ERR_OR_NULL(adapter->debugfs_root))
-			dev_warn(&pdev->dev, "could not create debugfs"
-				 " directory");
-		else
-			setup_debugfs(adapter);
+		setup_debugfs(adapter);
 	}
 
 	/*
@@ -3486,13 +3481,11 @@ static int __init cxgb4vf_module_init(void)
 		return -EINVAL;
 	}
 
-	/* Debugfs support is optional, just warn if this fails */
+	/* Debugfs support is optional, debugfs will warn if this fails */
 	cxgb4vf_debugfs_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (IS_ERR_OR_NULL(cxgb4vf_debugfs_root))
-		pr_warn("could not create debugfs entry, continuing\n");
 
 	ret = pci_register_driver(&cxgb4vf_driver);
-	if (ret < 0 && !IS_ERR_OR_NULL(cxgb4vf_debugfs_root))
+	if (ret < 0)
 		debugfs_remove(cxgb4vf_debugfs_root);
 	return ret;
 }
-- 
2.22.0

