Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9B2D187D
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731851AbfJITLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:11:16 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:45889 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731144AbfJITLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:11:14 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mzyi6-1hupE6357e-00wzdx; Wed, 09 Oct 2019 21:11:12 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        isdn4linux@listserv.isdn4linux.de
Subject: [PATCH v6 16/43] compat_ioctl: move isdn/capi ioctl translation into driver
Date:   Wed,  9 Oct 2019 21:10:16 +0200
Message-Id: <20191009191044.308087-16-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191009190853.245077-1-arnd@arndb.de>
References: <20191009190853.245077-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:3PgdTLn3Isb1E8QdaS6ssQ4smTcDkiVZALshacjmZB+AtPbu7Xq
 +7o5fh40aOG53PwqC68L1xQv4R2rrEcItv3d09B+15mWfs5dq4Tnu4b8BuUmfRm6UOVmtZd
 zpvGOs+siVVcUrX1Q5s/nr5A9T4WhMwaKm/3W3e/li5neiNanzGsyRWZwZ9MgEx1znyplrR
 z2rwUeFAJ5Ft6735YtEjg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hRo8ARl3Sq8=:RxMdqFFZ5hfQWKhBpuqbgd
 VS0ufeKpg2n65gq107Tujsiiq+j0BdkpZ1R4QKawR0mc5fAuY4/lBYRLNImDpCjMevgpRCMhS
 G+IWYfPMqCzyHXrQgLga8GTWM4/Po7Y7g0TRBTXe2vAC75g2YRgEGafbq7pPLnVrwpBHuDnKE
 hYqyjFb6eMjZstGJaHM+tbsu/QZHUp+gzLmvB3hbOb4Gt3tLwKWyaxJUxJfwl0jPz1Eq2svQr
 5ylyHlpXJhYZjR4dGwBSOa/MP/aORnAVTAvkgegWEnGuDWCmzpiw9kKM3laiA1Z14aKmbe2pI
 DEc6POaYmrmL6VvCpSxUne1lQPdReizm5P3e52Vw2DNbQAkoG6dsj5x5cNWqmVyFas5TbQ8ay
 zvflQxV28Zo3vv5oom91yCx6kBhGNmsLeI/4GWRM+V7Vq+6Hkh7ZR/IMaR71BoH9Mv4yule5F
 OWym6mvP3Rn1qvAONZ3687WR8lb5vtbRq/M/zGS87JoV3dzUACYtw1VnLsmi/wmJW0cGhds6K
 qHzVxrBqquqPb6hpqU1+y0XUTkYjiL7QGeYnRwSTXYEuNF2c73ytZSBEK3xTnkBimnzI0QS34
 twk72LmazvX8sXsXA+PVkFaXABTgjMzMQuiR37IiPVYC1RkysRc1Tj6uatBg436LsDo61CWTP
 BHTQDUsSH76HOsy2WpWeuMpABGuc8yAWabElkrVTAbGFXyZijT6cXb/i69ProMiSWhwKi1m2v
 cVBieHv8EWbJhV0V//EUVyF02xmhqzHOVJ3Ou6Z3eGtBeYHIvxN8PaQODJPhzzftQh+buHYpf
 KNhSm/38Ro+OTlOUHCLCk38lUx+vQSgTFhrUake83fButfk9TTsrL2/tYHCFmJ3/18ZBN7oe6
 FvDmcjfQbzxT2tWV1cgg==
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

Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
Cc: isdn4linux@listserv.isdn4linux.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/isdn/capi/capi.c | 31 +++++++++++++++++++++++++++++++
 fs/compat_ioctl.c        | 17 -----------------
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index c92b405b7646..efce7532513c 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -950,6 +950,34 @@ capi_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
@@ -996,6 +1024,9 @@ static const struct file_operations capi_fops =
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

