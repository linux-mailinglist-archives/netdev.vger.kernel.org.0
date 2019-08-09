Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E310687A0E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406744AbfHIMbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406940AbfHIMbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 08:31:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8613B208C3;
        Fri,  9 Aug 2019 12:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565353906;
        bh=Yamt36MxKTLlXONhvr/nhw+v6TzIgrl15Bm2HEHzsT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKbUwOrkd9jkelaWhh/cYyODDPi2NAh4Q+qfQjGvc2tjHCXAuSipDpYPF344Utjk/
         SM8cXjvFFpiow30reRZfBwwHitabZdz+z2bRvXA+2Et/JuXVWRNlaLx+3FvxQj06vv
         zl3/sA3r+OXCXFLViVY37bgoGbSHlmleeh6SXPyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 07/17] hns3: no need to check return value of debugfs_create functions
Date:   Fri,  9 Aug 2019 14:30:58 +0200
Message-Id: <20190809123108.27065-8-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809123108.27065-1-gregkh@linuxfoundation.org>
References: <20190809123108.27065-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_debugfs.c  | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index a4b937286f55..2e79380502e9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -372,20 +372,11 @@ static const struct file_operations hns3_dbg_cmd_fops = {
 void hns3_dbg_init(struct hnae3_handle *handle)
 {
 	const char *name = pci_name(handle->pdev);
-	struct dentry *pfile;
 
 	handle->hnae3_dbgfs = debugfs_create_dir(name, hns3_dbgfs_root);
-	if (!handle->hnae3_dbgfs)
-		return;
 
-	pfile = debugfs_create_file("cmd", 0600, handle->hnae3_dbgfs, handle,
-				    &hns3_dbg_cmd_fops);
-	if (!pfile) {
-		debugfs_remove_recursive(handle->hnae3_dbgfs);
-		handle->hnae3_dbgfs = NULL;
-		dev_warn(&handle->pdev->dev, "create file for %s fail\n",
-			 name);
-	}
+	debugfs_create_file("cmd", 0600, handle->hnae3_dbgfs, handle,
+			    &hns3_dbg_cmd_fops);
 }
 
 void hns3_dbg_uninit(struct hnae3_handle *handle)
@@ -397,10 +388,6 @@ void hns3_dbg_uninit(struct hnae3_handle *handle)
 void hns3_dbg_register_debugfs(const char *debugfs_dir_name)
 {
 	hns3_dbgfs_root = debugfs_create_dir(debugfs_dir_name, NULL);
-	if (!hns3_dbgfs_root) {
-		pr_warn("Register debugfs for %s fail\n", debugfs_dir_name);
-		return;
-	}
 }
 
 void hns3_dbg_unregister_debugfs(void)
-- 
2.22.0

