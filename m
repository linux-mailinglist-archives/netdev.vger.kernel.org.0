Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD22D83671
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387823AbfHFQL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387815AbfHFQL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:11:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A9D6208C3;
        Tue,  6 Aug 2019 16:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565107916;
        bh=L2KXkheRoHKjYKV85GvatHU+MtUf78ksKzsQO2I9arA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDjpwE9PdzDbPsPn59QMUGotjxFPCYmm6embzFU2ThjKC9AASapY1/+IeZQg6JvrD
         62eHy0ALZUATw5plDFKZvYGQb8nhiKtZ7ZoaJhcnJz2PS76nHbC2+Fxr74TfJh/pZD
         0YEdph8omgJG2xgsyZYTANoMQK/lIkZbnlwAhZro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH 16/17] ixgbe: no need to check return value of debugfs_create functions
Date:   Tue,  6 Aug 2019 18:11:27 +0200
Message-Id: <20190806161128.31232-17-gregkh@linuxfoundation.org>
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

Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../net/ethernet/intel/ixgbe/ixgbe_debugfs.c  | 22 +++++--------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
index 50dfb02fa34c..171cdc552961 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_debugfs.c
@@ -190,22 +190,12 @@ static const struct file_operations ixgbe_dbg_netdev_ops_fops = {
 void ixgbe_dbg_adapter_init(struct ixgbe_adapter *adapter)
 {
 	const char *name = pci_name(adapter->pdev);
-	struct dentry *pfile;
+
 	adapter->ixgbe_dbg_adapter = debugfs_create_dir(name, ixgbe_dbg_root);
-	if (adapter->ixgbe_dbg_adapter) {
-		pfile = debugfs_create_file("reg_ops", 0600,
-					    adapter->ixgbe_dbg_adapter, adapter,
-					    &ixgbe_dbg_reg_ops_fops);
-		if (!pfile)
-			e_dev_err("debugfs reg_ops for %s failed\n", name);
-		pfile = debugfs_create_file("netdev_ops", 0600,
-					    adapter->ixgbe_dbg_adapter, adapter,
-					    &ixgbe_dbg_netdev_ops_fops);
-		if (!pfile)
-			e_dev_err("debugfs netdev_ops for %s failed\n", name);
-	} else {
-		e_dev_err("debugfs entry for %s failed\n", name);
-	}
+	debugfs_create_file("reg_ops", 0600, adapter->ixgbe_dbg_adapter,
+			    adapter, &ixgbe_dbg_reg_ops_fops);
+	debugfs_create_file("netdev_ops", 0600, adapter->ixgbe_dbg_adapter,
+			    adapter, &ixgbe_dbg_netdev_ops_fops);
 }
 
 /**
@@ -224,8 +214,6 @@ void ixgbe_dbg_adapter_exit(struct ixgbe_adapter *adapter)
 void ixgbe_dbg_init(void)
 {
 	ixgbe_dbg_root = debugfs_create_dir(ixgbe_driver_name, NULL);
-	if (ixgbe_dbg_root == NULL)
-		pr_err("init of debugfs failed\n");
 }
 
 /**
-- 
2.22.0

