Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7EF88A9B
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 12:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfHJKR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 06:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfHJKR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 06:17:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE7AD20B7C;
        Sat, 10 Aug 2019 10:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565432278;
        bh=eZCNw2T0pwR0XZKm3lCuhtzleU2BOFgFGsSlDmTtInU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1WgvDC/7sp4HYce5PcOJuXz/Au/KuY6wYRQkxkIPpCV2pZklWoOEhJhmEl6OmHud
         DtKD8SF55SdINlF/OHolzKcoylMrp8drz7A2I/t+gjPvB2/HZgJ+5SD8QaK4CvSqtb
         Y1ugUPgqjzN6+EAk/qaOEvy8bTpFZeeaE5XrS9YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH v3 15/17] i40e: no need to check return value of debugfs_create functions
Date:   Sat, 10 Aug 2019 12:17:30 +0200
Message-Id: <20190810101732.26612-16-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190810101732.26612-1-gregkh@linuxfoundation.org>
References: <20190810101732.26612-1-gregkh@linuxfoundation.org>
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
 .../net/ethernet/intel/i40e/i40e_debugfs.c    | 22 ++++---------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 55d20acfcf70..41232898d8ae 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -1732,29 +1732,15 @@ static const struct file_operations i40e_dbg_netdev_ops_fops = {
  **/
 void i40e_dbg_pf_init(struct i40e_pf *pf)
 {
-	struct dentry *pfile;
 	const char *name = pci_name(pf->pdev);
-	const struct device *dev = &pf->pdev->dev;
 
 	pf->i40e_dbg_pf = debugfs_create_dir(name, i40e_dbg_root);
-	if (!pf->i40e_dbg_pf)
-		return;
-
-	pfile = debugfs_create_file("command", 0600, pf->i40e_dbg_pf, pf,
-				    &i40e_dbg_command_fops);
-	if (!pfile)
-		goto create_failed;
 
-	pfile = debugfs_create_file("netdev_ops", 0600, pf->i40e_dbg_pf, pf,
-				    &i40e_dbg_netdev_ops_fops);
-	if (!pfile)
-		goto create_failed;
+	debugfs_create_file("command", 0600, pf->i40e_dbg_pf, pf,
+			    &i40e_dbg_command_fops);
 
-	return;
-
-create_failed:
-	dev_info(dev, "debugfs dir/file for %s failed\n", name);
-	debugfs_remove_recursive(pf->i40e_dbg_pf);
+	debugfs_create_file("netdev_ops", 0600, pf->i40e_dbg_pf, pf,
+			    &i40e_dbg_netdev_ops_fops);
 }
 
 /**
-- 
2.22.0

