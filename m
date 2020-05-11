Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201DB1CD0F5
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 06:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgEKEqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 00:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728355AbgEKEp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 00:45:58 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56C2C061A0C;
        Sun, 10 May 2020 21:45:57 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY0KC-005jJ3-7c; Mon, 11 May 2020 04:45:56 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/19] atm: separate ATM_GETNAMES handling from the rest of atm_dev_ioctl()
Date:   Mon, 11 May 2020 05:45:49 +0100
Message-Id: <20200511044553.1365660-15-viro@ZenIV.linux.org.uk>
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

atm_dev_ioctl() does copyin in two different ways - one for
ATM_GETNAMES, another for everything else.  Start with separating
the former into a new helper (atm_getnames()).  The next step
will be to lift the copyin into the callers.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/atm/ioctl.c     |  6 +++-
 net/atm/resources.c | 88 +++++++++++++++++++++++++++--------------------------
 net/atm/resources.h |  1 +
 3 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/net/atm/ioctl.c b/net/atm/ioctl.c
index d955b683aa7c..0b4b07740fe4 100644
--- a/net/atm/ioctl.c
+++ b/net/atm/ioctl.c
@@ -162,7 +162,11 @@ static int do_vcc_ioctl(struct socket *sock, unsigned int cmd,
 	if (error != -ENOIOCTLCMD)
 		goto done;
 
-	error = atm_dev_ioctl(cmd, argp, compat);
+	if (cmd == ATM_GETNAMES) {
+		error = atm_getnames(argp, compat);
+	} else {
+		error = atm_dev_ioctl(cmd, argp, compat);
+	}
 
 done:
 	return error;
diff --git a/net/atm/resources.c b/net/atm/resources.c
index 889349c6d90d..a2ab75929eec 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -193,61 +193,63 @@ static int fetch_stats(struct atm_dev *dev, struct atm_dev_stats __user *arg,
 	return error ? -EFAULT : 0;
 }
 
-int atm_dev_ioctl(unsigned int cmd, void __user *arg, int compat)
+int atm_getnames(void __user *arg, int compat)
 {
 	void __user *buf;
-	int error, len, number, size = 0;
+	int error, len, size = 0;
 	struct atm_dev *dev;
 	struct list_head *p;
 	int *tmp_buf, *tmp_p;
-	int __user *sioc_len;
 	int __user *iobuf_len;
 
-	switch (cmd) {
-	case ATM_GETNAMES:
-		if (IS_ENABLED(CONFIG_COMPAT) && compat) {
+	if (IS_ENABLED(CONFIG_COMPAT) && compat) {
 #ifdef CONFIG_COMPAT
-			struct compat_atm_iobuf __user *ciobuf = arg;
-			compat_uptr_t cbuf;
-			iobuf_len = &ciobuf->length;
-			if (get_user(cbuf, &ciobuf->buffer))
-				return -EFAULT;
-			buf = compat_ptr(cbuf);
+		struct compat_atm_iobuf __user *ciobuf = arg;
+		compat_uptr_t cbuf;
+		iobuf_len = &ciobuf->length;
+		if (get_user(cbuf, &ciobuf->buffer))
+			return -EFAULT;
+		buf = compat_ptr(cbuf);
 #endif
-		} else {
-			struct atm_iobuf __user *iobuf = arg;
-			iobuf_len = &iobuf->length;
-			if (get_user(buf, &iobuf->buffer))
-				return -EFAULT;
-		}
-		if (get_user(len, iobuf_len))
+	} else {
+		struct atm_iobuf __user *iobuf = arg;
+		iobuf_len = &iobuf->length;
+		if (get_user(buf, &iobuf->buffer))
 			return -EFAULT;
-		mutex_lock(&atm_dev_mutex);
-		list_for_each(p, &atm_devs)
-			size += sizeof(int);
-		if (size > len) {
-			mutex_unlock(&atm_dev_mutex);
-			return -E2BIG;
-		}
-		tmp_buf = kmalloc(size, GFP_ATOMIC);
-		if (!tmp_buf) {
-			mutex_unlock(&atm_dev_mutex);
-			return -ENOMEM;
-		}
-		tmp_p = tmp_buf;
-		list_for_each(p, &atm_devs) {
-			dev = list_entry(p, struct atm_dev, dev_list);
-			*tmp_p++ = dev->number;
-		}
+	}
+	if (get_user(len, iobuf_len))
+		return -EFAULT;
+	mutex_lock(&atm_dev_mutex);
+	list_for_each(p, &atm_devs)
+		size += sizeof(int);
+	if (size > len) {
 		mutex_unlock(&atm_dev_mutex);
-		error = ((copy_to_user(buf, tmp_buf, size)) ||
-			 put_user(size, iobuf_len))
-			? -EFAULT : 0;
-		kfree(tmp_buf);
-		return error;
-	default:
-		break;
+		return -E2BIG;
 	}
+	tmp_buf = kmalloc(size, GFP_ATOMIC);
+	if (!tmp_buf) {
+		mutex_unlock(&atm_dev_mutex);
+		return -ENOMEM;
+	}
+	tmp_p = tmp_buf;
+	list_for_each(p, &atm_devs) {
+		dev = list_entry(p, struct atm_dev, dev_list);
+		*tmp_p++ = dev->number;
+	}
+	mutex_unlock(&atm_dev_mutex);
+	error = ((copy_to_user(buf, tmp_buf, size)) ||
+		 put_user(size, iobuf_len))
+		? -EFAULT : 0;
+	kfree(tmp_buf);
+	return error;
+}
+
+int atm_dev_ioctl(unsigned int cmd, void __user *arg, int compat)
+{
+	void __user *buf;
+	int error, len, number, size = 0;
+	struct atm_dev *dev;
+	int __user *sioc_len;
 
 	if (IS_ENABLED(CONFIG_COMPAT) && compat) {
 #ifdef CONFIG_COMPAT
diff --git a/net/atm/resources.h b/net/atm/resources.h
index 048232e4d4c6..18f8e5948ce4 100644
--- a/net/atm/resources.h
+++ b/net/atm/resources.h
@@ -14,6 +14,7 @@
 extern struct list_head atm_devs;
 extern struct mutex atm_dev_mutex;
 
+int atm_getnames(void __user *arg, int compat);
 int atm_dev_ioctl(unsigned int cmd, void __user *arg, int compat);
 
 
-- 
2.11.0

