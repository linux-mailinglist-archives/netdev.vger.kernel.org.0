Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D8D462702
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbhK2XAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 18:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235781AbhK2W7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:59:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0734C08ED84
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 09:56:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ED09CCE13BD
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D1AC53FAD
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:56:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Yar8ocd4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638208614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2netmKfr/Q930og4HTXi2bnMk7IQqUnB8lyoa6lVhqk=;
        b=Yar8ocd4kXEWIbZlSfcRCmh2M6c4h4fulJU0VigfB/+I7sSy96PDDsTykicir5+NuDyv2o
        xkEakexCHgE1Iecd++51BYHxAz0tx2TXR4t34QKt7ZYqCFrAmNjcLQNig4WdjQYq+G9q/d
        DyaOnmpgLxVF+wEa5FiNhkEx1H5FdIc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1885e080 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 29 Nov 2021 17:56:54 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 04/10] wireguard: main: rename 'mod_init' & 'mod_exit' functions to be module-specific
Date:   Mon, 29 Nov 2021 10:39:23 -0500
Message-Id: <20211129153929.3457-5-Jason@zx2c4.com>
In-Reply-To: <20211129153929.3457-1-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Rename module_init & module_exit functions that are named
"mod_init" and "mod_exit" so that they are unique in both the
System.map file and in initcall_debug output instead of showing
up as almost anonymous "mod_init".

This is helpful for debugging and in determining how long certain
module_init calls take to execute.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/main.c b/drivers/net/wireguard/main.c
index 75dbe77b0b4b..ee4da9ab8013 100644
--- a/drivers/net/wireguard/main.c
+++ b/drivers/net/wireguard/main.c
@@ -17,7 +17,7 @@
 #include <linux/genetlink.h>
 #include <net/rtnetlink.h>
 
-static int __init mod_init(void)
+static int __init wg_mod_init(void)
 {
 	int ret;
 
@@ -60,7 +60,7 @@ static int __init mod_init(void)
 	return ret;
 }
 
-static void __exit mod_exit(void)
+static void __exit wg_mod_exit(void)
 {
 	wg_genetlink_uninit();
 	wg_device_uninit();
@@ -68,8 +68,8 @@ static void __exit mod_exit(void)
 	wg_allowedips_slab_uninit();
 }
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(wg_mod_init);
+module_exit(wg_mod_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("WireGuard secure network tunnel");
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
-- 
2.34.1

