Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9052E8367A
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387857AbfHFQMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387843AbfHFQMI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:12:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B63C0208C3;
        Tue,  6 Aug 2019 16:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565107927;
        bh=k6+QiseGhJtm79dtjZq3LChMIoolh6iiDPijKOO1f/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzaLhp/6GBFe2XaOXkL1kSE1TKZbRJvzWTAr6JKuqhX+2WCrX+MdzZlV4q65Y6vjf
         bvj57qYjpWnjacpRfa4g2AH3hDQPjTeDUScSCZMgibM7nNIzE6e56g0/UQi4A47xJs
         InwvEVZYyltedxaCJ6Vl5ejNSmg3msWEAP0hQliE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 04/17] xgbe: no need to check return value of debugfs_create functions
Date:   Tue,  6 Aug 2019 18:11:15 +0200
Message-Id: <20190806161128.31232-5-gregkh@linuxfoundation.org>
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

This cleans up a lot of unneeded code and logic around the debugfs
files, making all of this much simpler and easier to understand.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c | 107 ++++++-------------
 1 file changed, 31 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c b/drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c
index b91143947ed2..b0a6c96b6ef4 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c
@@ -438,7 +438,6 @@ static const struct file_operations xi2c_reg_value_fops = {
 
 void xgbe_debugfs_init(struct xgbe_prv_data *pdata)
 {
-	struct dentry *pfile;
 	char *buf;
 
 	/* Set defaults */
@@ -451,88 +450,48 @@ void xgbe_debugfs_init(struct xgbe_prv_data *pdata)
 		return;
 
 	pdata->xgbe_debugfs = debugfs_create_dir(buf, NULL);
-	if (!pdata->xgbe_debugfs) {
-		netdev_err(pdata->netdev, "debugfs_create_dir failed\n");
-		kfree(buf);
-		return;
-	}
 
-	pfile = debugfs_create_file("xgmac_register", 0600,
-				    pdata->xgbe_debugfs, pdata,
-				    &xgmac_reg_addr_fops);
-	if (!pfile)
-		netdev_err(pdata->netdev, "debugfs_create_file failed\n");
+	debugfs_create_file("xgmac_register", 0600, pdata->xgbe_debugfs, pdata,
+			    &xgmac_reg_addr_fops);
 
-	pfile = debugfs_create_file("xgmac_register_value", 0600,
-				    pdata->xgbe_debugfs, pdata,
-				    &xgmac_reg_value_fops);
-	if (!pfile)
-		netdev_err(pdata->netdev, "debugfs_create_file failed\n");
+	debugfs_create_file("xgmac_register_value", 0600, pdata->xgbe_debugfs,
+			    pdata, &xgmac_reg_value_fops);
 
-	pfile = debugfs_create_file("xpcs_mmd", 0600,
-				    pdata->xgbe_debugfs, pdata,
-				    &xpcs_mmd_fops);
-	if (!pfile)
-		netdev_err(pdata->netdev, "debugfs_create_file failed\n");
+	debugfs_create_file("xpcs_mmd", 0600, pdata->xgbe_debugfs, pdata,
+			    &xpcs_mmd_fops);
 
-	pfile = debugfs_create_file("xpcs_register", 0600,
-				    pdata->xgbe_debugfs, pdata,
-				    &xpcs_reg_addr_fops);
-	if (!pfile)
-		netdev_err(pdata->netdev, "debugfs_create_file failed\n");
+	debugfs_create_file("xpcs_register", 0600, pdata->xgbe_debugfs, pdata,
+			    &xpcs_reg_addr_fops);
 
-	pfile = debugfs_create_file("xpcs_register_value", 0600,
-				    pdata->xgbe_debugfs, pdata,
-				    &xpcs_reg_value_fops);
-	if (!pfile)
-		netdev_err(pdata->netdev, "debugfs_create_file failed\n");
+	debugfs_create_file("xpcs_register_value", 0600, pdata->xgbe_debugfs,
+			    pdata, &xpcs_reg_value_fops);
 
 	if (pdata->xprop_regs) {
-		pfile = debugfs_create_file("xprop_register", 0600,
-					    pdata->xgbe_debugfs, pdata,
-					    &xprop_reg_addr_fops);
-		if (!pfile)
-			netdev_err(pdata->netdev,
-				   "debugfs_create_file failed\n");
-
-		pfile = debugfs_create_file("xprop_register_value", 0600,
-					    pdata->xgbe_debugfs, pdata,
-					    &xprop_reg_value_fops);
-		if (!pfile)
-			netdev_err(pdata->netdev,
-				   "debugfs_create_file failed\n");
+		debugfs_create_file("xprop_register", 0600, pdata->xgbe_debugfs,
+				    pdata, &xprop_reg_addr_fops);
+
+		debugfs_create_file("xprop_register_value", 0600,
+				    pdata->xgbe_debugfs, pdata,
+				    &xprop_reg_value_fops);
 	}
 
 	if (pdata->xi2c_regs) {
-		pfile = debugfs_create_file("xi2c_register", 0600,
-					    pdata->xgbe_debugfs, pdata,
-					    &xi2c_reg_addr_fops);
-		if (!pfile)
-			netdev_err(pdata->netdev,
-				   "debugfs_create_file failed\n");
-
-		pfile = debugfs_create_file("xi2c_register_value", 0600,
-					    pdata->xgbe_debugfs, pdata,
-					    &xi2c_reg_value_fops);
-		if (!pfile)
-			netdev_err(pdata->netdev,
-				   "debugfs_create_file failed\n");
+		debugfs_create_file("xi2c_register", 0600, pdata->xgbe_debugfs,
+				    pdata, &xi2c_reg_addr_fops);
+
+		debugfs_create_file("xi2c_register_value", 0600,
+				    pdata->xgbe_debugfs, pdata,
+				    &xi2c_reg_value_fops);
 	}
 
 	if (pdata->vdata->an_cdr_workaround) {
-		pfile = debugfs_create_bool("an_cdr_workaround", 0600,
-					    pdata->xgbe_debugfs,
-					    &pdata->debugfs_an_cdr_workaround);
-		if (!pfile)
-			netdev_err(pdata->netdev,
-				   "debugfs_create_bool failed\n");
-
-		pfile = debugfs_create_bool("an_cdr_track_early", 0600,
-					    pdata->xgbe_debugfs,
-					    &pdata->debugfs_an_cdr_track_early);
-		if (!pfile)
-			netdev_err(pdata->netdev,
-				   "debugfs_create_bool failed\n");
+		debugfs_create_bool("an_cdr_workaround", 0600,
+				    pdata->xgbe_debugfs,
+				    &pdata->debugfs_an_cdr_workaround);
+
+		debugfs_create_bool("an_cdr_track_early", 0600,
+				    pdata->xgbe_debugfs,
+				    &pdata->debugfs_an_cdr_track_early);
 	}
 
 	kfree(buf);
@@ -546,7 +505,6 @@ void xgbe_debugfs_exit(struct xgbe_prv_data *pdata)
 
 void xgbe_debugfs_rename(struct xgbe_prv_data *pdata)
 {
-	struct dentry *pfile;
 	char *buf;
 
 	if (!pdata->xgbe_debugfs)
@@ -559,11 +517,8 @@ void xgbe_debugfs_rename(struct xgbe_prv_data *pdata)
 	if (!strcmp(pdata->xgbe_debugfs->d_name.name, buf))
 		goto out;
 
-	pfile = debugfs_rename(pdata->xgbe_debugfs->d_parent,
-			       pdata->xgbe_debugfs,
-			       pdata->xgbe_debugfs->d_parent, buf);
-	if (!pfile)
-		netdev_err(pdata->netdev, "debugfs_rename failed\n");
+	debugfs_rename(pdata->xgbe_debugfs->d_parent, pdata->xgbe_debugfs,
+		       pdata->xgbe_debugfs->d_parent, buf);
 
 out:
 	kfree(buf);
-- 
2.22.0

