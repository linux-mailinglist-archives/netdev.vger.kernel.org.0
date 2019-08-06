Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD39983676
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387834AbfHFQMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387776AbfHFQMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:12:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98856208C3;
        Tue,  6 Aug 2019 16:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565107922;
        bh=RUsQEza+Ar9N+FJo3L6rYdD5QR6fkUA8bSv2nnoRzf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXoGWGDGXq/8G/xdCG1YQjstwtmXXvLEn5W/QCiyWvlMzkqIe027yjd7SCxyZfSa0
         vptML5/eHaRT6yM8jhrHCFwZNUJnVvhpD4FmBhTxYGymRR9CUnJlzQ2ylK3mFqJx/Y
         4d/20Yt9dCjOm0zDf8pNf2+aONUjYQ7RAsnDVr9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 02/17] bonding: no need to print a message if debugfs_create_dir() fails
Date:   Tue,  6 Aug 2019 18:11:13 +0200
Message-Id: <20190806161128.31232-3-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806161128.31232-1-gregkh@linuxfoundation.org>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The debugfs core now will print a message if this function fails, so
don't duplicate that logic.  Also, no need to change the code logic if
the call fails either, as no debugfs calls should interrupt normal
kernel code for any reason.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_debugfs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/bonding/bond_debugfs.c b/drivers/net/bonding/bond_debugfs.c
index 1360f1ffe070..f3f86ef68ae0 100644
--- a/drivers/net/bonding/bond_debugfs.c
+++ b/drivers/net/bonding/bond_debugfs.c
@@ -55,11 +55,6 @@ void bond_debug_register(struct bonding *bond)
 	bond->debug_dir =
 		debugfs_create_dir(bond->dev->name, bonding_debug_root);
 
-	if (!bond->debug_dir) {
-		netdev_warn(bond->dev, "failed to register to debugfs\n");
-		return;
-	}
-
 	debugfs_create_file("rlb_hash_table", 0400, bond->debug_dir,
 				bond, &bond_debug_rlb_hash_fops);
 }
-- 
2.22.0

