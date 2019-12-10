Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B741193DD
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfLJVLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:11:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbfLJVLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60266246A2;
        Tue, 10 Dec 2019 21:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012266;
        bh=SiUpEET3u+eXnAzJ/9n1WjoyrMjKh998f7eWCTivKz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pz941lXcXFdTminYKZyNg1q0sow0yaAcuWsX/6ednGo0+sfdzYahP9xyq9T1MCSWQ
         wkTjpBeR3U033tLccO2nWUecLFiGyW4MNYUimhb5qFqE/VbgUfA3Btifx1CNLV//m3
         qfw4hJfPtQ4i4AbvDfWl4+ZkX14ZMqucAMLwK0bg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 211/350] rfkill: allocate static minor
Date:   Tue, 10 Dec 2019 16:05:16 -0500
Message-Id: <20191210210735.9077-172-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
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
index 3247a3dc79348..b06b75776a32f 100644
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
index f9b08a6d8dbe4..0bf9bf1ceb8f0 100644
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
2.20.1

