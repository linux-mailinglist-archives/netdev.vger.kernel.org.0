Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CDA7B3D7
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfG3UAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:00:41 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:48805 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfG3UAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 16:00:40 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MnJUy-1ibTt43Pkq-00jM8M; Tue, 30 Jul 2019 22:00:38 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [PATCH v5 17/29] compat_ioctl: move isdn/capi ioctl translation into driver
Date:   Tue, 30 Jul 2019 21:55:33 +0200
Message-Id: <20190730195819.901457-5-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190730195819.901457-1-arnd@arndb.de>
References: <20190730192552.4014288-1-arnd@arndb.de>
 <20190730195819.901457-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:tpmLoTqdinjnsl+Tzj0InbA5QBGlwzwLt6rMTmYy+504j0UdEId
 QiG5+wHtN39MzCfP630K+xBuXw775V5yZ5sxRh47GZLly6s15o8/DAi6Y0gaHsGzGXDiLxz
 WyfcighW8bpWmVwTes1xUXGC8fBfCOUkHMel1RFnxFfIqmwMocdRr75MepWyxvo4NtPz1uy
 58VOEpE9Vynvyxcxr+5/g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1fvi13ynrwg=:EHvBJHlSTgn7k/EsrSt6fp
 AiTI9iMa5W7w7GWQ/w8GCd5qRlGwtNTGgKSfh3mX7jAnd4LOFP50HK4WCSE+olcuJr8W4lmJp
 y7sSrbK4lFtuQVZ6mGSGBzcPuv+6jXzchqzS5yVw0jIHXXHD2nArG6OHpurpdX0Q+otz1X3Os
 cm/w7nHlQFtAhQdbsNjozKZA7lnHoqmF0TyXD3m+ids0RGsj1ex/LRNeEKuTfsaVJqR9bW4B2
 WisznjgEQMmY+Fz4lynYHt5zIuNEMToB/sYVElQHcFUS5qf4vdK9guFzJfS8bkuvJVh5Nsy7h
 bL7YS6KFilyWoah7E1QPFLxOedCCvSQpHbpOxn2x9E+pYpEAHrUDyYzylIX7g54h2MEgGJnhx
 Zax2+mVOvgn2GPkbaFyBI6Da9jsT5ZORR+qbrcYt6RUDJe55nF6dL7Rfv/zDpRWO/Gh+e1xRf
 0IVESsJtR50iffijWNNPVqc7D5LdLV+YMRHpUyVSBDyY4m477WufxZD1UgyEm6I7uMwWIPAYV
 dNP+aFRJmFHPYQExuYojVqMR+Lj4x6PyXhhQKMrqAGII6MwIqHR5F8kuBHsiHXuOIKO3FVt2Z
 phT8iQZbMAgeMYbtBMEml73VQa1uuynXo/0mlt+xk2mKRflv0zjlBYLZ+VU3fuYvA+y2ORxh5
 n5OsHQbXIbCef/uUk4Q256vP21YVjNPgiB94EWFi9J76flLnfjq2eifgX0k8IlLPBNvBpmFnB
 GZYjtUueFsiKdhts1qHeRb7aCajurnSRY3FHAg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neither the old isdn4linux interface nor the newer mISDN stack
ever had working 32-bit compat mode as far as I can tell.

However, the CAPI stack has some ioctl commands that are
correctly listed in fs/compat_ioctl.c.

We can trivially move all of those into the corresponding
file that implement the native handlers by adding a compat_ioctl
redirect to that.

I did notice that treating CAPI_MANUFACTURER_CMD() as compatible
is broken, so I'm also adding a handler for that, realizing that
in all likelyhood, nobody is ever going to call it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/isdn/capi/capi.c | 31 +++++++++++++++++++++++++++++++
 fs/compat_ioctl.c        | 17 -----------------
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 3c3ad42f22bf..3b72fd8104db 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -942,6 +942,34 @@ capi_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+static long
+capi_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	if (cmd == CAPI_MANUFACTURER_CMD) {
+		struct {
+			unsigned long cmd;
+			compat_uptr_t data;
+		} mcmd32;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		if (copy_from_user(&mcmd32, compat_ptr(arg), sizeof(mcmd32)))
+			return -EFAULT;
+
+		mutex_lock(&capi_mutex);
+		ret = capi20_manufacturer(mcmd32.cmd, compat_ptr(mcmd32.data));
+		mutex_unlock(&capi_mutex);
+
+		return ret;
+	}
+
+	return capi_unlocked_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static int capi_open(struct inode *inode, struct file *file)
 {
 	struct capidev *cdev;
@@ -988,6 +1016,9 @@ static const struct file_operations capi_fops =
 	.write		= capi_write,
 	.poll		= capi_poll,
 	.unlocked_ioctl	= capi_unlocked_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= capi_compat_ioctl,
+#endif
 	.open		= capi_open,
 	.release	= capi_release,
 };
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index a4e8fb7da968..f3b4179d6dff 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -44,9 +44,6 @@
 #include <net/bluetooth/hci_sock.h>
 #include <net/bluetooth/rfcomm.h>
 
-#include <linux/capi.h>
-#include <linux/gigaset_dev.h>
-
 #ifdef CONFIG_BLOCK
 #include <linux/cdrom.h>
 #include <linux/fd.h>
@@ -681,20 +678,6 @@ COMPATIBLE_IOCTL(RFCOMMRELEASEDEV)
 COMPATIBLE_IOCTL(RFCOMMGETDEVLIST)
 COMPATIBLE_IOCTL(RFCOMMGETDEVINFO)
 COMPATIBLE_IOCTL(RFCOMMSTEALDLC)
-/* CAPI */
-COMPATIBLE_IOCTL(CAPI_REGISTER)
-COMPATIBLE_IOCTL(CAPI_GET_MANUFACTURER)
-COMPATIBLE_IOCTL(CAPI_GET_VERSION)
-COMPATIBLE_IOCTL(CAPI_GET_SERIAL)
-COMPATIBLE_IOCTL(CAPI_GET_PROFILE)
-COMPATIBLE_IOCTL(CAPI_MANUFACTURER_CMD)
-COMPATIBLE_IOCTL(CAPI_GET_ERRCODE)
-COMPATIBLE_IOCTL(CAPI_INSTALLED)
-COMPATIBLE_IOCTL(CAPI_GET_FLAGS)
-COMPATIBLE_IOCTL(CAPI_SET_FLAGS)
-COMPATIBLE_IOCTL(CAPI_CLR_FLAGS)
-COMPATIBLE_IOCTL(CAPI_NCCI_OPENCOUNT)
-COMPATIBLE_IOCTL(CAPI_NCCI_GETUNIT)
 /* Misc. */
 COMPATIBLE_IOCTL(PCIIOC_CONTROLLER)
 COMPATIBLE_IOCTL(PCIIOC_MMAP_IS_IO)
-- 
2.20.0

