Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08BD1CD0F2
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 06:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgEKEqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 00:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728392AbgEKEp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 00:45:58 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67646C061A0C;
        Sun, 10 May 2020 21:45:58 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY0KD-005jJO-1H; Mon, 11 May 2020 04:45:57 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/19] atm: lift copyin from atm_dev_ioctl()
Date:   Mon, 11 May 2020 05:45:52 +0100
Message-Id: <20200511044553.1365660-18-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
References: <20200511044328.GP23230@ZenIV.linux.org.uk>
 <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/atm/ioctl.c     | 25 ++++++++++++++++++++++++-
 net/atm/resources.c | 35 +++++------------------------------
 net/atm/resources.h |  4 ++--
 3 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/net/atm/ioctl.c b/net/atm/ioctl.c
index fdd0e3434523..52f2c77e656f 100644
--- a/net/atm/ioctl.c
+++ b/net/atm/ioctl.c
@@ -182,7 +182,30 @@ static int do_vcc_ioctl(struct socket *sock, unsigned int cmd,
 		}
 		error = atm_getnames(buf, len);
 	} else {
-		error = atm_dev_ioctl(cmd, argp, compat);
+		int number;
+
+		if (IS_ENABLED(CONFIG_COMPAT) && compat) {
+#ifdef CONFIG_COMPAT
+			struct compat_atmif_sioc __user *csioc = argp;
+			compat_uptr_t carg;
+
+			len = &csioc->length;
+			if (get_user(carg, &csioc->arg))
+				return -EFAULT;
+			buf = compat_ptr(carg);
+			if (get_user(number, &csioc->number))
+				return -EFAULT;
+#endif
+		} else {
+			struct atmif_sioc __user *sioc = argp;
+
+			len = &sioc->length;
+			if (get_user(buf, &sioc->arg))
+				return -EFAULT;
+			if (get_user(number, &sioc->number))
+				return -EFAULT;
+		}
+		error = atm_dev_ioctl(cmd, buf, len, number, compat);
 	}
 
 done:
diff --git a/net/atm/resources.c b/net/atm/resources.c
index 5507cc608969..94bdc6527ee8 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -227,39 +227,14 @@ int atm_getnames(void __user *buf, int __user *iobuf_len)
 	return error;
 }
 
-int atm_dev_ioctl(unsigned int cmd, void __user *arg, int compat)
+int atm_dev_ioctl(unsigned int cmd, void __user *buf, int __user *sioc_len,
+		  int number, int compat)
 {
-	void __user *buf;
-	int error, len, number, size = 0;
+	int error, len, size = 0;
 	struct atm_dev *dev;
-	int __user *sioc_len;
 
-	if (IS_ENABLED(CONFIG_COMPAT) && compat) {
-#ifdef CONFIG_COMPAT
-		struct compat_atmif_sioc __user *csioc = arg;
-		compat_uptr_t carg;
-
-		sioc_len = &csioc->length;
-		if (get_user(carg, &csioc->arg))
-			return -EFAULT;
-		buf = compat_ptr(carg);
-
-		if (get_user(len, &csioc->length))
-			return -EFAULT;
-		if (get_user(number, &csioc->number))
-			return -EFAULT;
-#endif
-	} else {
-		struct atmif_sioc __user *sioc = arg;
-
-		sioc_len = &sioc->length;
-		if (get_user(buf, &sioc->arg))
-			return -EFAULT;
-		if (get_user(len, &sioc->length))
-			return -EFAULT;
-		if (get_user(number, &sioc->number))
-			return -EFAULT;
-	}
+	if (get_user(len, sioc_len))
+		return -EFAULT;
 
 	dev = try_then_request_module(atm_dev_lookup(number), "atm-device-%d",
 				      number);
diff --git a/net/atm/resources.h b/net/atm/resources.h
index 5e2c68d37d63..4a0839e92ff3 100644
--- a/net/atm/resources.h
+++ b/net/atm/resources.h
@@ -15,8 +15,8 @@ extern struct list_head atm_devs;
 extern struct mutex atm_dev_mutex;
 
 int atm_getnames(void __user *buf, int __user *iobuf_len);
-int atm_dev_ioctl(unsigned int cmd, void __user *arg, int compat);
-
+int atm_dev_ioctl(unsigned int cmd, void __user *buf, int __user *sioc_len,
+		  int number, int compat);
 
 #ifdef CONFIG_PROC_FS
 
-- 
2.11.0

