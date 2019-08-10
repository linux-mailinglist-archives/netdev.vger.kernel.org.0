Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889A688A97
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 12:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfHJKRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 06:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfHJKRs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 06:17:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E53B217D7;
        Sat, 10 Aug 2019 10:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565432268;
        bh=YXredxS6VuGAA2GZ7NTzDgJWsoabv2GNy155CgHoO1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hH98xGBnl27ZXRs22LnHG0WQcXBdCuEvItPCW9veJcbrdWcgpocwW36NC5yiHIMLq
         sfW56jluNuGDrNds8r8Cn6d0Mg2zm/6rZuvRyi486N0e5ZGbCEesBL4x60k83Q+yhN
         Sg6iH46VCwhsaV9Z4T6L/pwCPqMeYTP5ZM/4TPxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Michael Heimpold <michael.heimpold@i2se.com>,
        Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH v3 11/17] qca: no need to check return value of debugfs_create functions
Date:   Sat, 10 Aug 2019 12:17:26 +0200
Message-Id: <20190810101732.26612-12-gregkh@linuxfoundation.org>
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

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Michael Heimpold <michael.heimpold@i2se.com>
Cc: Yangtao Li <tiny.windzz@gmail.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qualcomm/qca_debug.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
index bcb890b18a94..702aa217a27a 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -131,17 +131,10 @@ DEFINE_SHOW_ATTRIBUTE(qcaspi_info);
 void
 qcaspi_init_device_debugfs(struct qcaspi *qca)
 {
-	struct dentry *device_root;
+	qca->device_root = debugfs_create_dir(dev_name(&qca->net_dev->dev),
+					      NULL);
 
-	device_root = debugfs_create_dir(dev_name(&qca->net_dev->dev), NULL);
-	qca->device_root = device_root;
-
-	if (IS_ERR(device_root) || !device_root) {
-		pr_warn("failed to create debugfs directory for %s\n",
-			dev_name(&qca->net_dev->dev));
-		return;
-	}
-	debugfs_create_file("info", S_IFREG | 0444, device_root, qca,
+	debugfs_create_file("info", S_IFREG | 0444, qca->device_root, qca,
 			    &qcaspi_info_fops);
 }
 
-- 
2.22.0

