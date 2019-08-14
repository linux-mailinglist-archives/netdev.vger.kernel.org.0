Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A0B8DF7D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbfHNU4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:56:53 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:47397 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729385AbfHNU4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:56:53 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MzR0i-1iBFr30hTU-00vKnH; Wed, 14 Aug 2019 22:56:45 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Mackerras <paulus@samba.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-ppp@vger.kernel.org
Subject: [PATCH v5 14/18] compat_ioctl: handle PPPIOCGIDLE for 64-bit time_t
Date:   Wed, 14 Aug 2019 22:54:49 +0200
Message-Id: <20190814205521.122180-5-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190814204259.120942-1-arnd@arndb.de>
References: <20190814204259.120942-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:YPvpBTFvL5Y424x3E0kBMGJ6zBdgxHHTi8t4BTlVfozQmf4fZBs
 gNWQCBj+noYa2owNFNHhaYWiHeqIuSqzlhOYaXM30oDtyqr9+3pXgJqt6uGkm7wV8fHu9Qb
 w3b9neggVXVruCTqgepQhDDsUAyM9TfJcKPShiSbn9GGE4txA2DhblYD5oJve7Oeh1kbvp4
 3puGfzaXWqPlnzHetdBMw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:enJiRsEo4Z8=:5wsBczWSevpQTgjH3Ir2mZ
 FPt66Ou8IFIN0Dn/7Ees/65xfnK1gxJD2Hq7kDwmc3WI76hI/RbjGCvFmwBXLUUSTy0rTqFNh
 Z6CqHm7xBqO2CckYzFTj6hO96kBuQbbvHle04hV7kikil8KbQ0/biobykbJXhqDt6uDHL7zLJ
 wugSmhc6xm2nRKPQsBb8saQoryrnYRuI3J+3utWhZdCTYK/6YZEJXTxkngZXYcU/cXVZZrpt9
 SYry79DMmxm+niQupn+izUwrhRputcFqsUkeapfKFeOnsLzQhoPoFpN9D/YdivKD9upnKqeZl
 /4jon59vjn7WPti5guejqv9yjpV19uPsXmYUG6xJPttkOZ+BVoYdn/VJpjb5LLpKPVESBWuU2
 nYS8pH9VF4NAq0++cAZLWMbTOrCKryB0t+1pIrb4H+HmcbGs4oyUiE2qPBy7pc3WRnwJKifTW
 e7jlRzITa0YntDssYNX4OnTZBBjNT8WKU4/XWzVNWAVnA8X4z4NEtcLBQgcQ7pBQ+6gJ+CboP
 pwiRWaH8LKVXNX0yCCt5tzC1sEG8tIrEsOx4qa86zHma0gsA9TAABi3Rr4X0xKNzwUaAO/D/m
 UGtZlIf1L3JMoWEK6eEZRlAmPpQUsjxyeqFiZHT+1F3lx7tyWwmORSA1bPr5SFtQRAKS1RsCD
 mB98iATggVu9t7ArnFSpq7GnUMneg1VM19bx/YNApcs8SJVvyrDRF98YTFMA/lyzqcrjZvVZJ
 p/XQOXv+Ybdyc0cgGfIMvu7NqsEtDrfaJ/A2YA==
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/networking/ppp_generic.txt |  2 ++
 drivers/net/ppp/ppp_generic.c            | 19 ++++++++++----
 fs/compat_ioctl.c                        | 32 ++----------------------
 include/uapi/linux/ppp-ioctl.h           |  2 ++
 include/uapi/linux/ppp_defs.h            | 14 +++++++++++
 5 files changed, 34 insertions(+), 35 deletions(-)

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
index 2ab67bad6224..6b4e227cb002 100644
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
index 0b5a732d7afd..f97cf698cfdd 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
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
@@ -217,8 +191,6 @@ static long do_ioctl_trans(unsigned int cmd,
 	void __user *argp = compat_ptr(arg);
 
 	switch (cmd) {
-	case PPPIOCGIDLE32:
-		return ppp_gidle(file, cmd, argp);
 #ifdef CONFIG_BLOCK
 	case SG_GET_REQUEST_TABLE:
 		return sg_grt_trans(file, cmd, argp);
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

