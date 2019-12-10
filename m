Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBB9119B85
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbfLJWJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:09:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728925AbfLJWEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 17:04:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C72F621D7D;
        Tue, 10 Dec 2019 22:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015472;
        bh=49bS9orNd3ZL4raZ9exAir3QWp/udIrIFkNDQ3sgHVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKLkdBdzibz5F27Y6USdiTR9LU+EU0wXgVMJp2t9ZCfb9eEs1oRb7CBEwIDHouSL/
         h4tkGfvN50kF/xRhUSfA/QvVkr7gAtCBQaXw+Xur/DMOitzjL1QuWW64eyc+pP091J
         5MHo9ZpRyQzJUNYH4fV7vrfN6RJ+wYSA5n++MN4U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 077/130] rfkill: allocate static minor
Date:   Tue, 10 Dec 2019 17:02:08 -0500
Message-Id: <20191210220301.13262-77-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

[ Upstream commit 8670b2b8b029a6650d133486be9d2ace146fd29a ]

udev has a feature of creating /dev/<node> device-nodes if it finds
a devnode:<node> modalias. This allows for auto-loading of modules that
provide the node. This requires to use a statically allocated minor
number for misc character devices.

However, rfkill uses dynamic minor numbers and prevents auto-loading
of the module. So allocate the next static misc minor number and use
it for rfkill.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Link: https://lore.kernel.org/r/20191024174042.19851-1-marcel@holtmann.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/miscdevice.h | 1 +
 net/rfkill/core.c          | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 4de703d9e21f0..5e1e50b8f8c47 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -56,6 +56,7 @@
 #define UHID_MINOR		239
 #define USERIO_MINOR		240
 #define VHOST_VSOCK_MINOR	241
+#define RFKILL_MINOR		242
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 2064c3a35ef84..99a2e55b01cf3 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1312,10 +1312,12 @@ static const struct file_operations rfkill_fops = {
 	.llseek		= no_llseek,
 };
 
+#define RFKILL_NAME "rfkill"
+
 static struct miscdevice rfkill_miscdev = {
-	.name	= "rfkill",
 	.fops	= &rfkill_fops,
-	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= RFKILL_NAME,
+	.minor	= RFKILL_MINOR,
 };
 
 static int __init rfkill_init(void)
@@ -1367,3 +1369,6 @@ static void __exit rfkill_exit(void)
 	class_unregister(&rfkill_class);
 }
 module_exit(rfkill_exit);
+
+MODULE_ALIAS_MISCDEV(RFKILL_MINOR);
+MODULE_ALIAS("devname:" RFKILL_NAME);
-- 
2.20.1

