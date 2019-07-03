Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A1A5E2F0
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 13:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfGCLkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 07:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbfGCLkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 07:40:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F8E2218A3;
        Wed,  3 Jul 2019 11:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562153999;
        bh=yPpFHNRRdBgJ0+DNe1EWje3Z8TjgSbL103+1FGdUzm0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0QRvG9iVMIPmglxa+Z5e1JKdAhSf8SU7P5d7Pn1IpTCf3+dFCYp8ftZYJYaqp/Rea
         8xLsVQmTHagEThsFmz92h2elAK+t1qBrgxoJ0de4lhanB7MiYfhQifrBo7hlsVJntP
         /vwZgIgm4NUU3OUHvutZiCbFbkRk9lBQndkh5/RY=
Date:   Wed, 3 Jul 2019 13:39:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2] rt2x00: no need to check return value of debugfs_create
 functions
Message-ID: <20190703113956.GA26652@kroah.com>
References: <20190703065631.GA28822@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703065631.GA28822@kroah.com>
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
v2: - rebase against wireless-drivers-next
    - clean up the debugfs "blob" creation logic a bit more, no need to
      care about that return value.

 .../net/wireless/ralink/rt2x00/rt2x00debug.c  | 136 +++++-------------
 1 file changed, 35 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
index ef5f51512212..4d4e3888ef20 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
@@ -65,26 +65,6 @@ struct rt2x00debug_intf {
 	 *     - crypto stats file
 	 */
 	struct dentry *driver_folder;
-	struct dentry *driver_entry;
-	struct dentry *chipset_entry;
-	struct dentry *dev_flags;
-	struct dentry *cap_flags;
-	struct dentry *restart_hw;
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
@@ -596,39 +576,34 @@ static const struct file_operations rt2x00debug_restart_hw = {
 	.llseek = generic_file_llseek,
 };
 
-static struct dentry *rt2x00debug_create_file_driver(const char *name,
-						     struct rt2x00debug_intf
-						     *intf,
-						     struct debugfs_blob_wrapper
-						     *blob)
+static void rt2x00debug_create_file_driver(const char *name,
+					   struct rt2x00debug_intf *intf,
+					   struct debugfs_blob_wrapper *blob)
 {
 	char *data;
 
 	data = kzalloc(3 * MAX_LINE_LENGTH, GFP_KERNEL);
 	if (!data)
-		return NULL;
+		return;
 
 	blob->data = data;
 	data += sprintf(data, "driver:\t%s\n", intf->rt2x00dev->ops->name);
 	data += sprintf(data, "version:\t%s\n", DRV_VERSION);
 	blob->size = strlen(blob->data);
 
-	return debugfs_create_blob(name, 0400, intf->driver_folder, blob);
+	debugfs_create_blob(name, 0400, intf->driver_folder, blob);
 }
 
-static struct dentry *rt2x00debug_create_file_chipset(const char *name,
-						      struct rt2x00debug_intf
-						      *intf,
-						      struct
-						      debugfs_blob_wrapper
-						      *blob)
+static void rt2x00debug_create_file_chipset(const char *name,
+					    struct rt2x00debug_intf *intf,
+					    struct debugfs_blob_wrapper *blob)
 {
 	const struct rt2x00debug *debug = intf->debug;
 	char *data;
 
 	data = kzalloc(9 * MAX_LINE_LENGTH, GFP_KERNEL);
 	if (!data)
-		return NULL;
+		return;
 
 	blob->data = data;
 	data += sprintf(data, "rt chip:\t%04x\n", intf->rt2x00dev->chip.rt);
@@ -654,13 +629,15 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 
 	blob->size = strlen(blob->data);
 
-	return debugfs_create_blob(name, 0400, intf->driver_folder, blob);
+	debugfs_create_blob(name, 0400, intf->driver_folder, blob);
 }
 
 void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 {
 	const struct rt2x00debug *debug = rt2x00dev->ops->debugfs;
 	struct rt2x00debug_intf *intf;
+	struct dentry *queue_folder;
+	struct dentry *register_folder;
 
 	intf = kzalloc(sizeof(struct rt2x00debug_intf), GFP_KERNEL);
 	if (!intf) {
@@ -676,43 +653,27 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	    debugfs_create_dir(intf->rt2x00dev->ops->name,
 			       rt2x00dev->hw->wiphy->debugfsdir);
 
-	intf->driver_entry =
-	    rt2x00debug_create_file_driver("driver", intf, &intf->driver_blob);
+	rt2x00debug_create_file_driver("driver", intf, &intf->driver_blob);
+	rt2x00debug_create_file_chipset("chipset", intf, &intf->chipset_blob);
+	debugfs_create_file("dev_flags", 0400, intf->driver_folder, intf,
+			    &rt2x00debug_fop_dev_flags);
+	debugfs_create_file("cap_flags", 0400, intf->driver_folder, intf,
+			    &rt2x00debug_fop_cap_flags);
+	debugfs_create_file("restart_hw", 0200, intf->driver_folder, intf,
+			    &rt2x00debug_restart_hw);
 
-	intf->chipset_entry =
-	    rt2x00debug_create_file_chipset("chipset",
-					    intf, &intf->chipset_blob);
-
-	intf->dev_flags = debugfs_create_file("dev_flags", 0400,
-					      intf->driver_folder, intf,
-					      &rt2x00debug_fop_dev_flags);
-
-	intf->cap_flags = debugfs_create_file("cap_flags", 0400,
-					      intf->driver_folder, intf,
-					      &rt2x00debug_fop_cap_flags);
-
-	intf->restart_hw = debugfs_create_file("restart_hw", 0200,
-					       intf->driver_folder, intf,
-					       &rt2x00debug_restart_hw);
-
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
 
@@ -724,26 +685,21 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 
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
@@ -758,29 +714,7 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 
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
-	debugfs_remove(intf->restart_hw);
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

