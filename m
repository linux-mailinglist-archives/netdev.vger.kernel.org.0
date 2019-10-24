Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E87CE3A3F
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503910AbfJXRkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:40:49 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:49092 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729458AbfJXRks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:40:48 -0400
Received: from localhost.localdomain (p4FEFC197.dip0.t-ipconnect.de [79.239.193.151])
        by mail.holtmann.org (Postfix) with ESMTPSA id 602ADCECF4;
        Thu, 24 Oct 2019 19:49:47 +0200 (CEST)
From:   Marcel Holtmann <marcel@holtmann.org>
To:     arnd@arndb.de, gregkh@linuxfoundation.org,
        johannes@sipsolutions.net, davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] rfkill: allocate static minor
Date:   Thu, 24 Oct 2019 19:40:42 +0200
Message-Id: <20191024174042.19851-1-marcel@holtmann.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

udev has a feature of creating /dev/<node> device-nodes if it finds
a devnode:<node> modalias. This allows for auto-loading of modules that
provide the node. This requires to use a statically allocated minor
number for misc character devices.

However, rfkill uses dynamic minor numbers and prevents auto-loading
of the module. So allocate the next static misc minor number and use
it for rfkill.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 include/linux/miscdevice.h | 1 +
 net/rfkill/core.c          | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 3247a3dc7934..b06b75776a32 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -57,6 +57,7 @@
 #define UHID_MINOR		239
 #define USERIO_MINOR		240
 #define VHOST_VSOCK_MINOR	241
+#define RFKILL_MINOR		242
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index f9b08a6d8dbe..0bf9bf1ceb8f 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1316,10 +1316,12 @@ static const struct file_operations rfkill_fops = {
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
@@ -1371,3 +1373,6 @@ static void __exit rfkill_exit(void)
 	class_unregister(&rfkill_class);
 }
 module_exit(rfkill_exit);
+
+MODULE_ALIAS_MISCDEV(RFKILL_MINOR);
+MODULE_ALIAS("devname:" RFKILL_NAME);
-- 
2.21.0

