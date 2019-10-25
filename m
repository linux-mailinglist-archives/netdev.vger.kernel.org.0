Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A154FE4962
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503039AbfJYLIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:08:45 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:34332 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502906AbfJYLIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 07:08:45 -0400
Received: from ramsan ([84.195.182.253])
        by andre.telenet-ops.be with bizsmtp
        id Hn8b2100L5USYZQ01n8bdM; Fri, 25 Oct 2019 13:08:43 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNxSN-0003rD-GA; Fri, 25 Oct 2019 13:08:35 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNw6A-0006ms-Jl; Fri, 25 Oct 2019 11:41:34 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 1/7] debugfs: Add debugfs_create_xul() for hexadecimal unsigned long
Date:   Fri, 25 Oct 2019 11:41:24 +0200
Message-Id: <20191025094130.26033-2-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191025094130.26033-1-geert+renesas@glider.be>
References: <20191025094130.26033-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing debugfs_create_ulong() function supports objects of
type "unsigned long", which are 32-bit or 64-bit depending on the
platform, in decimal form.  To format objects in hexadecimal, various
debugfs_create_x*() functions exist, but all of them take fixed-size
types.

Add a debugfs helper for "unsigned long" objects in hexadecimal format.
This avoids the need for users to open-code the same, or introduce
bugs when casting the value pointer to "u32 *" or "u64 *" to call
debugfs_create_x{32,64}().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - Add kerneldoc,
  - Update Documentation/filesystems/debugfs.txt.
---
 Documentation/filesystems/debugfs.txt |  5 ++++-
 include/linux/debugfs.h               | 21 +++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/debugfs.txt b/Documentation/filesystems/debugfs.txt
index 50e8f91f2421ec04..8c8e60fe8c7deb86 100644
--- a/Documentation/filesystems/debugfs.txt
+++ b/Documentation/filesystems/debugfs.txt
@@ -102,11 +102,14 @@ functions meant to help out in such special cases:
 As might be expected, this function will create a debugfs file to represent
 a variable of type size_t.
 
-Similarly, there is a helper for variables of type unsigned long:
+Similarly, there are helpers for variables of type unsigned long, in decimal
+and hexadecimal:
 
     struct dentry *debugfs_create_ulong(const char *name, umode_t mode,
 					struct dentry *parent,
 					unsigned long *value);
+    void debugfs_create_xul(const char *name, umode_t mode,
+			    struct dentry *parent, unsigned long *value);
 
 Boolean values can be placed in debugfs with:
 
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 33690949b45d6904..af6c2e5b7d3c7afa 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -356,4 +356,25 @@ static inline ssize_t debugfs_write_file_bool(struct file *file,
 
 #endif
 
+/**
+ * debugfs_create_xul - create a debugfs file that is used to read and write an
+ * unsigned long value, formatted in hexadecimal
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this parameter is %NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @value: a pointer to the variable that the file should read to and write
+ *         from.
+ */
+static inline void debugfs_create_xul(const char *name, umode_t mode,
+				      struct dentry *parent,
+				      unsigned long *value)
+{
+	if (sizeof(*value) == sizeof(u32))
+		debugfs_create_x32(name, mode, parent, (u32 *)value);
+	else
+		debugfs_create_x64(name, mode, parent, (u64 *)value);
+}
+
 #endif
-- 
2.17.1

