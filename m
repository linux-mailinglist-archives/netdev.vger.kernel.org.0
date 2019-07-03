Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC515DE4F
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 08:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfGCG4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 02:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbfGCG4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 02:56:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0EF21880;
        Wed,  3 Jul 2019 06:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562136993;
        bh=D+MA2jtNWqYOuAIR3MCBDf/Vna+KJK3cvwbmZ+awpT0=;
        h=Date:From:To:Cc:Subject:From;
        b=vSvaUSUDobOkVvp/aO7oOqjpRoK7qG7C1F8hGB5BtnlyVASiu30rbbDUrQOfgM4hG
         uZBYATcUZly7umhbgAydKySW+XSyaP3hDcnxRakaNXoPSiDpBKNRvHF85QbyFA7grW
         +jQ0X33YzKbMoqF0gGfTWb4AuDXlUAz7iR1Siu3o=
Date:   Wed, 3 Jul 2019 08:56:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] rt2x00: no need to check return value of debugfs_create
 functions
Message-ID: <20190703065631.GA28822@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Because we don't need to save the individual debugfs files and
directories, remove the local storage of them and just remove the entire
debugfs directory in a single call, making things a lot simpler.

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../net/wireless/ralink/rt2x00/rt2x00debug.c  | 100 ++++--------------
 1 file changed, 23 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
index aac3aae7afaa..7103904de28a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
@@ -64,25 +64,6 @@ struct rt2x00debug_intf {
 	 *     - crypto stats file
 	 */
 	struct dentry *driver_folder;
-	struct dentry *driver_entry;
-	struct dentry *chipset_entry;
-	struct dentry *dev_flags;
-	struct dentry *cap_flags;
-	struct dentry *register_folder;
-	struct dentry *csr_off_entry;
-	struct dentry *csr_val_entry;
-	struct dentry *eeprom_off_entry;
-	struct dentry *eeprom_val_entry;
-	struct dentry *bbp_off_entry;
-	struct dentry *bbp_val_entry;
-	struct dentry *rf_off_entry;
-	struct dentry *rf_val_entry;
-	struct dentry *rfcsr_off_entry;
-	struct dentry *rfcsr_val_entry;
-	struct dentry *queue_folder;
-	struct dentry *queue_frame_dump_entry;
-	struct dentry *queue_stats_entry;
-	struct dentry *crypto_stats_entry;
 
 	/*
 	 * The frame dump file only allows a single reader,
@@ -631,6 +612,8 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 {
 	const struct rt2x00debug *debug = rt2x00dev->ops->debugfs;
 	struct rt2x00debug_intf *intf;
+	struct dentry *queue_folder;
+	struct dentry *register_folder;
 
 	intf = kzalloc(sizeof(struct rt2x00debug_intf), GFP_KERNEL);
 	if (!intf) {
@@ -646,39 +629,28 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	    debugfs_create_dir(intf->rt2x00dev->ops->name,
 			       rt2x00dev->hw->wiphy->debugfsdir);
 
-	intf->driver_entry =
-	    rt2x00debug_create_file_driver("driver", intf, &intf->driver_blob);
+	rt2x00debug_create_file_driver("driver", intf, &intf->driver_blob);
 
-	intf->chipset_entry =
-	    rt2x00debug_create_file_chipset("chipset",
-					    intf, &intf->chipset_blob);
+	rt2x00debug_create_file_chipset("chipset", intf, &intf->chipset_blob);
 
-	intf->dev_flags = debugfs_create_file("dev_flags", 0400,
-					      intf->driver_folder, intf,
-					      &rt2x00debug_fop_dev_flags);
+	debugfs_create_file("dev_flags", 0400, intf->driver_folder, intf,
+			    &rt2x00debug_fop_dev_flags);
 
-	intf->cap_flags = debugfs_create_file("cap_flags", 0400,
-					      intf->driver_folder, intf,
-					      &rt2x00debug_fop_cap_flags);
+	debugfs_create_file("cap_flags", 0400, intf->driver_folder, intf,
+			    &rt2x00debug_fop_cap_flags);
 
-	intf->register_folder =
-	    debugfs_create_dir("register", intf->driver_folder);
+	register_folder = debugfs_create_dir("register", intf->driver_folder);
 
 #define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)		\
 ({									\
 	if (debug->__name.read) {					\
-		(__intf)->__name##_off_entry =				\
-			debugfs_create_u32(__stringify(__name) "_offset", \
-					   0600,			\
-					   (__intf)->register_folder,	\
-					   &(__intf)->offset_##__name);	\
+		debugfs_create_u32(__stringify(__name) "_offset", 0600,	\
+				   register_folder,			\
+				   &(__intf)->offset_##__name);		\
 									\
-		(__intf)->__name##_val_entry =				\
-			debugfs_create_file(__stringify(__name) "_value", \
-					    0600,			\
-					    (__intf)->register_folder,	\
-					    (__intf),			\
-					    &rt2x00debug_fop_##__name); \
+		debugfs_create_file(__stringify(__name) "_value", 0600,	\
+				    register_folder, (__intf),		\
+				    &rt2x00debug_fop_##__name);		\
 	}								\
 })
 
@@ -690,26 +662,21 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 
 #undef RT2X00DEBUGFS_CREATE_REGISTER_ENTRY
 
-	intf->queue_folder =
-	    debugfs_create_dir("queue", intf->driver_folder);
+	queue_folder = debugfs_create_dir("queue", intf->driver_folder);
 
-	intf->queue_frame_dump_entry =
-		debugfs_create_file("dump", 0400, intf->queue_folder,
-				    intf, &rt2x00debug_fop_queue_dump);
+	debugfs_create_file("dump", 0400, queue_folder, intf,
+			    &rt2x00debug_fop_queue_dump);
 
 	skb_queue_head_init(&intf->frame_dump_skbqueue);
 	init_waitqueue_head(&intf->frame_dump_waitqueue);
 
-	intf->queue_stats_entry =
-		debugfs_create_file("queue", 0400, intf->queue_folder,
-				    intf, &rt2x00debug_fop_queue_stats);
+	debugfs_create_file("queue", 0400, queue_folder, intf,
+			    &rt2x00debug_fop_queue_stats);
 
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
 	if (rt2x00_has_cap_hw_crypto(rt2x00dev))
-		intf->crypto_stats_entry =
-			debugfs_create_file("crypto", 0444, intf->queue_folder,
-					    intf,
-					    &rt2x00debug_fop_crypto_stats);
+		debugfs_create_file("crypto", 0444, queue_folder, intf,
+				    &rt2x00debug_fop_crypto_stats);
 #endif
 
 	return;
@@ -724,28 +691,7 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 
 	skb_queue_purge(&intf->frame_dump_skbqueue);
 
-#ifdef CONFIG_RT2X00_LIB_CRYPTO
-	debugfs_remove(intf->crypto_stats_entry);
-#endif
-	debugfs_remove(intf->queue_stats_entry);
-	debugfs_remove(intf->queue_frame_dump_entry);
-	debugfs_remove(intf->queue_folder);
-	debugfs_remove(intf->rfcsr_val_entry);
-	debugfs_remove(intf->rfcsr_off_entry);
-	debugfs_remove(intf->rf_val_entry);
-	debugfs_remove(intf->rf_off_entry);
-	debugfs_remove(intf->bbp_val_entry);
-	debugfs_remove(intf->bbp_off_entry);
-	debugfs_remove(intf->eeprom_val_entry);
-	debugfs_remove(intf->eeprom_off_entry);
-	debugfs_remove(intf->csr_val_entry);
-	debugfs_remove(intf->csr_off_entry);
-	debugfs_remove(intf->register_folder);
-	debugfs_remove(intf->dev_flags);
-	debugfs_remove(intf->cap_flags);
-	debugfs_remove(intf->chipset_entry);
-	debugfs_remove(intf->driver_entry);
-	debugfs_remove(intf->driver_folder);
+	debugfs_remove_recursive(intf->driver_folder);
 	kfree(intf->chipset_blob.data);
 	kfree(intf->driver_blob.data);
 	kfree(intf);
-- 
2.22.0

