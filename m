Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1DBF8367B
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387862AbfHFQML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387851AbfHFQMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:12:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C32F208C3;
        Tue,  6 Aug 2019 16:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565107929;
        bh=PmCxEM3MCKxEhqxp1HHVGVpStkY9cpnBtSHfAIGmzvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMLUHGU2DCsZb3j22FfdJhU9CbePXgLGRZJCBCBiKv5lSC0RPJdzOf3k9pjkk1B/x
         nukxonXF2RIVbrw7jk7aBFOeuD5qZlS23vCs2OLagGm7SjZDEQFW1c8ey+i8Axv+1E
         E58ohmtPRhfUUYxceQ8Cccrb9QifbuzT5ljc8/xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 05/17] bnxt: no need to check return value of debugfs_create functions
Date:   Tue,  6 Aug 2019 18:11:16 +0200
Message-Id: <20190806161128.31232-6-gregkh@linuxfoundation.org>
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

Cc: Michael Chan <michael.chan@broadcom.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 -
 .../net/ethernet/broadcom/bnxt/bnxt_debugfs.c | 39 ++++++-------------
 2 files changed, 11 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index e3262089b751..1b1610d5b573 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1724,7 +1724,6 @@ struct bnxt {
 	u8			switch_id[8];
 	struct bnxt_tc_info	*tc_info;
 	struct dentry		*debugfs_pdev;
-	struct dentry		*debugfs_dim;
 	struct device		*hwmon_dev;
 };
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_debugfs.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_debugfs.c
index 61393f351a77..156c2404854f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_debugfs.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_debugfs.c
@@ -61,45 +61,30 @@ static const struct file_operations debugfs_dim_fops = {
 	.read = debugfs_dim_read,
 };
 
-static struct dentry *debugfs_dim_ring_init(struct dim *dim, int ring_idx,
-					    struct dentry *dd)
+static void debugfs_dim_ring_init(struct dim *dim, int ring_idx,
+				  struct dentry *dd)
 {
 	static char qname[16];
 
 	snprintf(qname, 10, "%d", ring_idx);
-	return debugfs_create_file(qname, 0600, dd,
-				   dim, &debugfs_dim_fops);
+	debugfs_create_file(qname, 0600, dd, dim, &debugfs_dim_fops);
 }
 
 void bnxt_debug_dev_init(struct bnxt *bp)
 {
 	const char *pname = pci_name(bp->pdev);
-	struct dentry *pdevf;
+	struct dentry *dir;
 	int i;
 
 	bp->debugfs_pdev = debugfs_create_dir(pname, bnxt_debug_mnt);
-	if (bp->debugfs_pdev) {
-		pdevf = debugfs_create_dir("dim", bp->debugfs_pdev);
-		if (!pdevf) {
-			pr_err("failed to create debugfs entry %s/dim\n",
-			       pname);
-			return;
-		}
-		bp->debugfs_dim = pdevf;
-		/* create files for each rx ring */
-		for (i = 0; i < bp->cp_nr_rings; i++) {
-			struct bnxt_cp_ring_info *cpr = &bp->bnapi[i]->cp_ring;
+	dir = debugfs_create_dir("dim", bp->debugfs_pdev);
 
-			if (cpr && bp->bnapi[i]->rx_ring) {
-				pdevf = debugfs_dim_ring_init(&cpr->dim, i,
-							      bp->debugfs_dim);
-				if (!pdevf)
-					pr_err("failed to create debugfs entry %s/dim/%d\n",
-					       pname, i);
-			}
-		}
-	} else {
-		pr_err("failed to create debugfs entry %s\n", pname);
+	/* create files for each rx ring */
+	for (i = 0; i < bp->cp_nr_rings; i++) {
+		struct bnxt_cp_ring_info *cpr = &bp->bnapi[i]->cp_ring;
+
+		if (cpr && bp->bnapi[i]->rx_ring)
+			debugfs_dim_ring_init(&cpr->dim, i, dir);
 	}
 }
 
@@ -114,8 +99,6 @@ void bnxt_debug_dev_exit(struct bnxt *bp)
 void bnxt_debug_init(void)
 {
 	bnxt_debug_mnt = debugfs_create_dir("bnxt_en", NULL);
-	if (!bnxt_debug_mnt)
-		pr_err("failed to init bnxt_en debugfs\n");
 }
 
 void bnxt_debug_exit(void)
-- 
2.22.0

