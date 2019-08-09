Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5941287A13
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406967AbfHIMb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406946AbfHIMb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 08:31:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A56CE217D7;
        Fri,  9 Aug 2019 12:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565353916;
        bh=YXredxS6VuGAA2GZ7NTzDgJWsoabv2GNy155CgHoO1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xe/pHCAb81gQ0nvxDxi3h0NZ5vnDctrQRzt+kiW5UgpSS6kvplmTUmJeAEe6jpo0p
         sssEuJWsD/iJ0fuPWSoSsEHRS+TKGL0ijssZL3V1j2XlyIIIC1/ELbtpooNx+fmpne
         FP3F/4GMUxtP1JX3s8kp3OVd1OkKQ3csLZapS/iE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Michael Heimpold <michael.heimpold@i2se.com>,
        Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH v2 11/17] qca: no need to check return value of debugfs_create functions
Date:   Fri,  9 Aug 2019 14:31:02 +0200
Message-Id: <20190809123108.27065-12-gregkh@linuxfoundation.org>
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

