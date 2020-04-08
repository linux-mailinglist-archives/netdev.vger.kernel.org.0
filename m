Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D541A24E9
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 17:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgDHPWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 11:22:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39112 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729508AbgDHPWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 11:22:44 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jMCXF-0001BO-9W; Wed, 08 Apr 2020 15:22:37 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>, Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/8] loop: use ns_capable for some loop operations
Date:   Wed,  8 Apr 2020 17:21:46 +0200
Message-Id: <20200408152151.5780-4-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408152151.5780-1-christian.brauner@ubuntu.com>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following  LOOP_GET_STATUS, LOOP_SET_STATUS, and LOOP_SET_BLOCK_SIZE
operations are now allowed in non-initial namespaces. Most other
operations were already possible before.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Tom Gundersen <teg@jklm.no>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christian Kellner <ckellner@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Rheinsberg <david.rheinsberg@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 drivers/block/loop.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a7eda14be639..b1c3436d6e38 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1294,6 +1294,25 @@ void loopfs_remove_locked(struct loop_device *lo)
 	loop_remove(lo);
 	mutex_unlock(&loop_ctl_mutex);
 }
+
+static bool loop_capable(const struct loop_device *lo, int cap)
+{
+	struct super_block *sb;
+	struct user_namespace *ns;
+
+	sb = loopfs_i_sb(lo->lo_loopfs_i);
+	if (sb)
+		ns = sb->s_user_ns;
+	else
+		ns = &init_user_ns;
+
+	return ns_capable(ns, cap);
+}
+#else /* !CONFIG_BLK_DEV_LOOPFS */
+static inline bool loop_capable(const struct loop_device *lo, int cap)
+{
+	return capable(cap);
+}
 #endif /* CONFIG_BLK_DEV_LOOPFS */
 
 static int
@@ -1310,7 +1329,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 		return err;
 	if (lo->lo_encrypt_key_size &&
 	    !uid_eq(lo->lo_key_owner, uid) &&
-	    !capable(CAP_SYS_ADMIN)) {
+	    !loop_capable(lo, CAP_SYS_ADMIN)) {
 		err = -EPERM;
 		goto out_unlock;
 	}
@@ -1441,7 +1460,7 @@ loop_get_status(struct loop_device *lo, struct loop_info64 *info)
 	memcpy(info->lo_crypt_name, lo->lo_crypt_name, LO_NAME_SIZE);
 	info->lo_encrypt_type =
 		lo->lo_encryption ? lo->lo_encryption->number : 0;
-	if (lo->lo_encrypt_key_size && capable(CAP_SYS_ADMIN)) {
+	if (lo->lo_encrypt_key_size && loop_capable(lo, CAP_SYS_ADMIN)) {
 		info->lo_encrypt_key_size = lo->lo_encrypt_key_size;
 		memcpy(info->lo_encrypt_key, lo->lo_encrypt_key,
 		       lo->lo_encrypt_key_size);
@@ -1665,7 +1684,7 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		return loop_clr_fd(lo);
 	case LOOP_SET_STATUS:
 		err = -EPERM;
-		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN)) {
+		if ((mode & FMODE_WRITE) || loop_capable(lo, CAP_SYS_ADMIN)) {
 			err = loop_set_status_old(lo,
 					(struct loop_info __user *)arg);
 		}
@@ -1674,7 +1693,7 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		return loop_get_status_old(lo, (struct loop_info __user *) arg);
 	case LOOP_SET_STATUS64:
 		err = -EPERM;
-		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN)) {
+		if ((mode & FMODE_WRITE) || loop_capable(lo, CAP_SYS_ADMIN)) {
 			err = loop_set_status64(lo,
 					(struct loop_info64 __user *) arg);
 		}
@@ -1684,7 +1703,7 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 	case LOOP_SET_CAPACITY:
 	case LOOP_SET_DIRECT_IO:
 	case LOOP_SET_BLOCK_SIZE:
-		if (!(mode & FMODE_WRITE) && !capable(CAP_SYS_ADMIN))
+		if (!(mode & FMODE_WRITE) && !loop_capable(lo, CAP_SYS_ADMIN))
 			return -EPERM;
 		/* Fall through */
 	default:
-- 
2.26.0

