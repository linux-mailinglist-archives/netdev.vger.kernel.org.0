Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D0CD1851
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbfJITNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:13:11 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:53503 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732002AbfJITL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:11:27 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MUY9w-1iiiBV1xEO-00QSut; Wed, 09 Oct 2019 21:11:21 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-ppp@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v6 39/43] compat_ioctl: handle PPPIOCGIDLE for 64-bit time_t
Date:   Wed,  9 Oct 2019 21:10:40 +0200
Message-Id: <20191009191044.308087-40-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191009190853.245077-1-arnd@arndb.de>
References: <20191009190853.245077-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:XaZibNUey55BMqfiAmH+lAmo19jt19/j7KilyEkR7gxnx2Y33W1
 3a5i6NeROriH8Ok/LB7NTaZnJr2J6Fw/pDFTDJQgaTARt9mozuC8avkT3BTC0HjGS6VumMz
 /MZ9ojpq5p9359CpshBcqrt2dQ4ChFiN3xlTgRtfyywfDkMtEK0S+kNjRTR7Lfu2noEo/3w
 AfV/La8tp1l7nZHwLIQ0w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PL42KE+IjLg=:7s4r0dXaWqnQWko3XOcQ8R
 /OoUrwpyOh3OsfZaQLcm+Tx+VSxfm1wA7JBEIkhJXeCV/cJkFO/+UPTxdQwLKXBc61W9/wgYZ
 4ueTSnMkju6bPLamC+I4lkobwbLovbizFAYXydBAIDJVVIgC1V905MdRK8/8BsJgqjm88SX8R
 rF5Rs9+GtM7Aah+Zl7cFILVLLNiP2AyCiZe79QP1ypJAde3sZnjNHrTzxU9T76IHBWhQcsfWH
 NkJkBQ6elM4Kb2YMnYFrzDoxq0OYjSVExtDVhjNEvoFFn8n8dSsr8GWPauYZ7o5kZU+PI6SYW
 kjyBB8+i7HQupnB1C5PPKHAZvygFP7MSD35MdeUvOSo1JdKwepvL12w4D8tWSnE+0uaMGrCj4
 UZAiZVSsZslOzJdXGj2zV5fxn378NAzFbNCYnzbLJ5Jtc5QrQTN80vPzwov/XE9+TF2Kn+WZJ
 dJvFxy3LLX+JqlrwR/yKmK0C8eP4C4DfNhIqVHb2KZbMLGY/B6f1IY9XGHiGSYPfuJKeLEVBs
 1tU31oFQKMHvaRPDE26qtrmJ9Lj6XEyw2kUWpYc1gPcE+4EIPKLU8NvNSrV676yjHkRqfmB+c
 3WpztlrkpQ88d2MUCFopazCJws0eki+cFhtrEDlKn7D6sohzdNqxCkJAbHS7Mz/XpnLIbAOJq
 B1vZQinoPiiXDP9TfpUSstKsbwB62dS9yCMLbg5yi6tUcCp2UECmIg0yd1TzLT+BPEn8Bf6FG
 U9UkBNftW6U7xD7cTWhTlZCMVlBk3gWg3YBD9iYBf4WhkgRnrohTrPAE26yKMQwv42y5tR8lZ
 F0kbR7OxuuR/LQwfKs19CmNyRlhXVE9zfCRnX1UJcNx7DysCZ82x1tBrhwAA96LddEQrnHTXr
 AEfSBrd0VmAUk4FqRSEQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ppp_idle structure is defined in terms of __kernel_time_t, which is
defined as 'long' on all architectures, and this usage is not affected
by the y2038 problem since it transports a time interval rather than an
absolute time.

However, the ppp user space defines the same structure as time_t, which
may be 64-bit wide on new libc versions even on 32-bit architectures.

It's easy enough to just handle both possible structure layouts on
all architectures, to deal with the possibility that a user space ppp
implementation comes with its own ppp_idle structure definition, as well
as to document the fact that the driver is y2038-safe.

Doing this also avoids the need for a special compat mode translation,
since 32-bit and 64-bit kernels now support the same interfaces.  The old
32-bit structure is also available on native 64-bit architectures now,
but this is harmless.

Cc: netdev@vger.kernel.org
Cc: linux-ppp@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/networking/ppp_generic.txt |  2 ++
 drivers/net/ppp/ppp_generic.c            | 19 ++++++++----
 fs/compat_ioctl.c                        | 38 ++++--------------------
 include/uapi/linux/ppp-ioctl.h           |  2 ++
 include/uapi/linux/ppp_defs.h            | 14 +++++++++
 5 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/Documentation/networking/ppp_generic.txt b/Documentation/networking/ppp_generic.txt
index 61daf4b39600..fd563aff5fc9 100644
--- a/Documentation/networking/ppp_generic.txt
+++ b/Documentation/networking/ppp_generic.txt
@@ -378,6 +378,8 @@ an interface unit are:
   CONFIG_PPP_FILTER option is enabled, the set of packets which reset
   the transmit and receive idle timers is restricted to those which
   pass the `active' packet filter.
+  Two versions of this command exist, to deal with user space
+  expecting times as either 32-bit or 64-bit time_t seconds.
 
 * PPPIOCSMAXCID sets the maximum connection-ID parameter (and thus the
   number of connection slots) for the TCP header compressor and
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index fb8e0ac099b8..ce4dd45c541d 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -612,7 +612,8 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct ppp_file *pf;
 	struct ppp *ppp;
 	int err = -EFAULT, val, val2, i;
-	struct ppp_idle idle;
+	struct ppp_idle32 idle32;
+	struct ppp_idle64 idle64;
 	struct npioctl npi;
 	int unit, cflags;
 	struct slcompress *vj;
@@ -735,10 +736,18 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		err = 0;
 		break;
 
-	case PPPIOCGIDLE:
-		idle.xmit_idle = (jiffies - ppp->last_xmit) / HZ;
-		idle.recv_idle = (jiffies - ppp->last_recv) / HZ;
-		if (copy_to_user(argp, &idle, sizeof(idle)))
+	case PPPIOCGIDLE32:
+                idle32.xmit_idle = (jiffies - ppp->last_xmit) / HZ;
+                idle32.recv_idle = (jiffies - ppp->last_recv) / HZ;
+                if (copy_to_user(argp, &idle32, sizeof(idle32)))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCGIDLE64:
+		idle64.xmit_idle = (jiffies - ppp->last_xmit) / HZ;
+		idle64.recv_idle = (jiffies - ppp->last_recv) / HZ;
+		if (copy_to_user(argp, &idle64, sizeof(idle64)))
 			break;
 		err = 0;
 		break;
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 0b5a732d7afd..5e59101ef981 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -52,6 +52,7 @@
 
 #include <linux/sort.h>
 
+#ifdef CONFIG_BLOCK
 static int do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int err;
@@ -63,7 +64,6 @@ static int do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return vfs_ioctl(file, cmd, arg);
 }
 
-#ifdef CONFIG_BLOCK
 struct compat_sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
 	char req_state;
 	char orphan;
@@ -99,33 +99,6 @@ static int sg_grt_trans(struct file *file,
 }
 #endif /* CONFIG_BLOCK */
 
-struct ppp_idle32 {
-	compat_time_t xmit_idle;
-	compat_time_t recv_idle;
-};
-#define PPPIOCGIDLE32		_IOR('t', 63, struct ppp_idle32)
-
-static int ppp_gidle(struct file *file, unsigned int cmd,
-		struct ppp_idle32 __user *idle32)
-{
-	struct ppp_idle __user *idle;
-	__kernel_time_t xmit, recv;
-	int err;
-
-	idle = compat_alloc_user_space(sizeof(*idle));
-
-	err = do_ioctl(file, PPPIOCGIDLE, (unsigned long) idle);
-
-	if (!err) {
-		if (get_user(xmit, &idle->xmit_idle) ||
-		    get_user(recv, &idle->recv_idle) ||
-		    put_user(xmit, &idle32->xmit_idle) ||
-		    put_user(recv, &idle32->recv_idle))
-			err = -EFAULT;
-	}
-	return err;
-}
-
 /*
  * simple reversible transform to make our table more evenly
  * distributed after sorting.
@@ -192,7 +165,8 @@ COMPATIBLE_IOCTL(PPPIOCGDEBUG)
 COMPATIBLE_IOCTL(PPPIOCSDEBUG)
 /* PPPIOCSPASS is translated */
 /* PPPIOCSACTIVE is translated */
-/* PPPIOCGIDLE is translated */
+COMPATIBLE_IOCTL(PPPIOCGIDLE32)
+COMPATIBLE_IOCTL(PPPIOCGIDLE64)
 COMPATIBLE_IOCTL(PPPIOCNEWUNIT)
 COMPATIBLE_IOCTL(PPPIOCATTACH)
 COMPATIBLE_IOCTL(PPPIOCDETACH)
@@ -214,16 +188,14 @@ COMPATIBLE_IOCTL(PPPIOCGL2TPSTATS)
 static long do_ioctl_trans(unsigned int cmd,
 		 unsigned long arg, struct file *file)
 {
+#ifdef CONFIG_BLOCK
 	void __user *argp = compat_ptr(arg);
 
 	switch (cmd) {
-	case PPPIOCGIDLE32:
-		return ppp_gidle(file, cmd, argp);
-#ifdef CONFIG_BLOCK
 	case SG_GET_REQUEST_TABLE:
 		return sg_grt_trans(file, cmd, argp);
-#endif
 	}
+#endif
 
 	return -ENOIOCTLCMD;
 }
diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioctl.h
index 88b5f9990320..7bd2a5a75348 100644
--- a/include/uapi/linux/ppp-ioctl.h
+++ b/include/uapi/linux/ppp-ioctl.h
@@ -104,6 +104,8 @@ struct pppol2tp_ioc_stats {
 #define PPPIOCGDEBUG	_IOR('t', 65, int)	/* Read debug level */
 #define PPPIOCSDEBUG	_IOW('t', 64, int)	/* Set debug level */
 #define PPPIOCGIDLE	_IOR('t', 63, struct ppp_idle) /* get idle time */
+#define PPPIOCGIDLE32	_IOR('t', 63, struct ppp_idle32) /* 32-bit times */
+#define PPPIOCGIDLE64	_IOR('t', 63, struct ppp_idle64) /* 64-bit times */
 #define PPPIOCNEWUNIT	_IOWR('t', 62, int)	/* create new ppp unit */
 #define PPPIOCATTACH	_IOW('t', 61, int)	/* attach to ppp unit */
 #define PPPIOCDETACH	_IOW('t', 60, int)	/* obsolete, do not use */
diff --git a/include/uapi/linux/ppp_defs.h b/include/uapi/linux/ppp_defs.h
index fff51b91b409..0039fa39a358 100644
--- a/include/uapi/linux/ppp_defs.h
+++ b/include/uapi/linux/ppp_defs.h
@@ -142,10 +142,24 @@ struct ppp_comp_stats {
 /*
  * The following structure records the time in seconds since
  * the last NP packet was sent or received.
+ *
+ * Linux implements both 32-bit and 64-bit time_t versions
+ * for compatibility with user space that defines ppp_idle
+ * based on the libc time_t.
  */
 struct ppp_idle {
     __kernel_time_t xmit_idle;	/* time since last NP packet sent */
     __kernel_time_t recv_idle;	/* time since last NP packet received */
 };
 
+struct ppp_idle32 {
+    __s32 xmit_idle;		/* time since last NP packet sent */
+    __s32 recv_idle;		/* time since last NP packet received */
+};
+
+struct ppp_idle64 {
+    __s64 xmit_idle;		/* time since last NP packet sent */
+    __s64 recv_idle;		/* time since last NP packet received */
+};
+
 #endif /* _UAPI_PPP_DEFS_H_ */
-- 
2.20.0

