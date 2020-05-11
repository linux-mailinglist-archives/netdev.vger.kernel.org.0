Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670941CD0ED
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 06:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgEKEp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 00:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728365AbgEKEp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 00:45:58 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFD1C05BD09;
        Sun, 10 May 2020 21:45:58 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY0KC-005jJ9-K9; Mon, 11 May 2020 04:45:56 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/19] atm: move copyin from atm_getnames() into the caller
Date:   Mon, 11 May 2020 05:45:50 +0100
Message-Id: <20200511044553.1365660-16-viro@ZenIV.linux.org.uk>
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
 net/atm/ioctl.c     | 19 ++++++++++++++++++-
 net/atm/resources.c | 19 +------------------
 net/atm/resources.h |  2 +-
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/atm/ioctl.c b/net/atm/ioctl.c
index 0b4b07740fe4..e239cebf48da 100644
--- a/net/atm/ioctl.c
+++ b/net/atm/ioctl.c
@@ -56,6 +56,8 @@ static int do_vcc_ioctl(struct socket *sock, unsigned int cmd,
 	int error;
 	struct list_head *pos;
 	void __user *argp = (void __user *)arg;
+	void __user *buf;
+	int __user *len;
 
 	vcc = ATM_SD(sock);
 	switch (cmd) {
@@ -163,7 +165,22 @@ static int do_vcc_ioctl(struct socket *sock, unsigned int cmd,
 		goto done;
 
 	if (cmd == ATM_GETNAMES) {
-		error = atm_getnames(argp, compat);
+		if (IS_ENABLED(CONFIG_COMPAT) && compat) {
+#ifdef CONFIG_COMPAT
+			struct compat_atm_iobuf __user *ciobuf = argp;
+			compat_uptr_t cbuf;
+			len = &ciobuf->length;
+			if (get_user(cbuf, &ciobuf->buffer))
+				return -EFAULT;
+			buf = compat_ptr(cbuf);
+#endif
+		} else {
+			struct atm_iobuf __user *iobuf = argp;
+			len = &iobuf->length;
+			if (get_user(buf, &iobuf->buffer))
+				return -EFAULT;
+		}
+		error = atm_getnames(buf, len);
 	} else {
 		error = atm_dev_ioctl(cmd, argp, compat);
 	}
diff --git a/net/atm/resources.c b/net/atm/resources.c
index a2ab75929eec..5507cc608969 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -193,30 +193,13 @@ static int fetch_stats(struct atm_dev *dev, struct atm_dev_stats __user *arg,
 	return error ? -EFAULT : 0;
 }
 
-int atm_getnames(void __user *arg, int compat)
+int atm_getnames(void __user *buf, int __user *iobuf_len)
 {
-	void __user *buf;
 	int error, len, size = 0;
 	struct atm_dev *dev;
 	struct list_head *p;
 	int *tmp_buf, *tmp_p;
-	int __user *iobuf_len;
 
-	if (IS_ENABLED(CONFIG_COMPAT) && compat) {
-#ifdef CONFIG_COMPAT
-		struct compat_atm_iobuf __user *ciobuf = arg;
-		compat_uptr_t cbuf;
-		iobuf_len = &ciobuf->length;
-		if (get_user(cbuf, &ciobuf->buffer))
-			return -EFAULT;
-		buf = compat_ptr(cbuf);
-#endif
-	} else {
-		struct atm_iobuf __user *iobuf = arg;
-		iobuf_len = &iobuf->length;
-		if (get_user(buf, &iobuf->buffer))
-			return -EFAULT;
-	}
 	if (get_user(len, iobuf_len))
 		return -EFAULT;
 	mutex_lock(&atm_dev_mutex);
diff --git a/net/atm/resources.h b/net/atm/resources.h
index 18f8e5948ce4..5e2c68d37d63 100644
--- a/net/atm/resources.h
+++ b/net/atm/resources.h
@@ -14,7 +14,7 @@
 extern struct list_head atm_devs;
 extern struct mutex atm_dev_mutex;
 
-int atm_getnames(void __user *arg, int compat);
+int atm_getnames(void __user *buf, int __user *iobuf_len);
 int atm_dev_ioctl(unsigned int cmd, void __user *arg, int compat);
 
 
-- 
2.11.0

