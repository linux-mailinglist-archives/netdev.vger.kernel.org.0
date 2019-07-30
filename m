Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66BDF7B353
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 21:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388235AbfG3T33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 15:29:29 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:49951 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbfG3T31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 15:29:27 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MYvoW-1hoENq0aOG-00UpSh; Tue, 30 Jul 2019 21:29:18 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Guillaume Nault <g.nault@alphalink.fr>,
        Michal Ostrowski <mostrows@earthlink.net>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Kozlov <xeb@mail.ru>,
        James Chapman <jchapman@katalix.com>, netdev@vger.kernel.org
Subject: [PATCH v5 09/29] compat_ioctl: pppoe: fix PPPOEIOCSFWD handling
Date:   Tue, 30 Jul 2019 21:25:20 +0200
Message-Id: <20190730192552.4014288-10-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190730192552.4014288-1-arnd@arndb.de>
References: <20190730192552.4014288-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:3YXTtGVjvpHiqeCSgT+9dwkwT822H+B7oH9lghcw9plt4dom0iE
 APQkOwjcwtwA3EKmsHcKETdhVjH7U6qPghQVH8AZD73UW0YodpccvoLppADXJ5ua0U3gHbz
 pj2gWLsvaOpaxRCSvemm85ntiKZkBw6aPO1ZxSEyUWWy3oFhJ2OXK1FO5OgH4DGEpa7t6Io
 JGSWJ/Suw7ZFDaYXufyDg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7bjc6xE+V9o=:5Jy3Ds5CnF6lbkmYIWon+8
 VoPUEGuLfFP6+g82eDgc74ZtMgzYBUN2pNg5h5b9tVz/IW2RR+MqKHX5DxolRwft7Arm9q24n
 icqB+kYc+TTLgZQOUKyrW1grWqxiPcEOK204r2ehaf7MSsAbD3zu00zUI1Y2tc9W+0j41FMEZ
 VtepcnXY5sb5H4d7NJFV0XAVePIKpHHT3GPxOYHMULrrW3xlLiq5X5SGYLH105WTiWd64qMcr
 aJkUFKIbMX2yecLDvNXADhDHXLo9FcIru3qkCd2EHIModI7ct/0J1V/3deYSNvr0/QB4xlAAC
 YXFk/Cz/3TUXxJbLDeXajddrZMTkOhZjcYRmftQDkGEHym5w4t5UhJkCRtgCcEN//VdMrDUZ4
 KVX9qaArA6wl2ppj9f7Gf0QoX5GgPpepYEYbTWjlF47dgVKCpMGcE+v7OPLF39X98J0GSoamF
 KbCas1y+oTM6SBeG5k+smo5E+X+epIOAa8puearSXgMSgJwJg9hU+ZHNpqtu1xYtw42LUvF+z
 zxf+rNxURxhszo4dyACuIWYzVZ+hBfI8DoLqkM+RPbLTvqPio3h5dCR6t9BMuDEcCJ+Hh78Vz
 +rowUD1wk8DeyfRM0sS8eZhuijBiuYa684MwafhxlhwLqFcUqNlXgSTsrlLraNeBlYXT3WHYs
 EkYpWQ06PvhhGNTRLhP2g1HTd8pojlqFlRaRNgNEacCiMbT3PR0SKWavM/GsOS4GZyMc0S3C7
 s9C7umPsuUJ3viU5wTiR/UUCzcrSxGZCSZ5QYQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for handling the PPPOEIOCSFWD ioctl in compat mode was added in
linux-2.5.69 along with hundreds of other commands, but was always broken
sincen only the structure is compatible, but the command number is not,
due to the size being sizeof(size_t), or at first sizeof(sizeof((struct
sockaddr_pppox)), which is different on 64-bit architectures.

Guillaume Nault adds:

  And the implementation was broken until 2016 (see 29e73269aa4d ("pppoe:
  fix reference counting in PPPoE proxy")), and nobody ever noticed. I
  should probably have removed this ioctl entirely instead of fixing it.
  Clearly, it has never been used.

Fix it by adding a compat_ioctl handler for all pppoe variants that
translates the command number and then calls the regular ioctl function.

All other ioctl commands handled by pppoe are compatible between 32-bit
and 64-bit, and require compat_ptr() conversion.

This should apply to all stable kernels.

Acked-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ppp/pppoe.c  |  3 +++
 drivers/net/ppp/pppox.c  | 13 +++++++++++++
 drivers/net/ppp/pptp.c   |  3 +++
 fs/compat_ioctl.c        |  3 ---
 include/linux/if_pppox.h |  3 +++
 net/l2tp/l2tp_ppp.c      |  3 +++
 6 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 1d902ecb4aa8..a44dd3c8af63 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -1115,6 +1115,9 @@ static const struct proto_ops pppoe_ops = {
 	.recvmsg	= pppoe_recvmsg,
 	.mmap		= sock_no_mmap,
 	.ioctl		= pppox_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= pppox_compat_ioctl,
+#endif
 };
 
 static const struct pppox_proto pppoe_proto = {
diff --git a/drivers/net/ppp/pppox.c b/drivers/net/ppp/pppox.c
index 5ef422a43d70..08364f10a43f 100644
--- a/drivers/net/ppp/pppox.c
+++ b/drivers/net/ppp/pppox.c
@@ -17,6 +17,7 @@
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/compat.h>
 #include <linux/errno.h>
 #include <linux/netdevice.h>
 #include <linux/net.h>
@@ -98,6 +99,18 @@ int pppox_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 
 EXPORT_SYMBOL(pppox_ioctl);
 
+#ifdef CONFIG_COMPAT
+int pppox_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
+{
+	if (cmd == PPPOEIOCSFWD32)
+		cmd = PPPOEIOCSFWD;
+
+	return pppox_ioctl(sock, cmd, (unsigned long)compat_ptr(arg));
+}
+
+EXPORT_SYMBOL(pppox_compat_ioctl);
+#endif
+
 static int pppox_create(struct net *net, struct socket *sock, int protocol,
 			int kern)
 {
diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index a8e52c8e4128..734de7de03f7 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -623,6 +623,9 @@ static const struct proto_ops pptp_ops = {
 	.recvmsg    = sock_no_recvmsg,
 	.mmap       = sock_no_mmap,
 	.ioctl      = pppox_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = pppox_compat_ioctl,
+#endif
 };
 
 static const struct pppox_proto pppox_pptp_proto = {
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 9ea1c4981332..cec3ec0a1727 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -589,9 +589,6 @@ COMPATIBLE_IOCTL(PPPIOCDISCONN)
 COMPATIBLE_IOCTL(PPPIOCATTCHAN)
 COMPATIBLE_IOCTL(PPPIOCGCHAN)
 COMPATIBLE_IOCTL(PPPIOCGL2TPSTATS)
-/* PPPOX */
-COMPATIBLE_IOCTL(PPPOEIOCSFWD)
-COMPATIBLE_IOCTL(PPPOEIOCDFWD)
 /* Big A */
 /* sparc only */
 /* Big Q for sound/OSS */
diff --git a/include/linux/if_pppox.h b/include/linux/if_pppox.h
index 8b728750a625..69e813bcb947 100644
--- a/include/linux/if_pppox.h
+++ b/include/linux/if_pppox.h
@@ -80,6 +80,9 @@ extern int register_pppox_proto(int proto_num, const struct pppox_proto *pp);
 extern void unregister_pppox_proto(int proto_num);
 extern void pppox_unbind_sock(struct sock *sk);/* delete ppp-channel binding */
 extern int pppox_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
+extern int pppox_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
+
+#define PPPOEIOCSFWD32    _IOW(0xB1 ,0, compat_size_t)
 
 /* PPPoX socket states */
 enum {
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 1d0e5904dedf..c54cb59593ef 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1681,6 +1681,9 @@ static const struct proto_ops pppol2tp_ops = {
 	.recvmsg	= pppol2tp_recvmsg,
 	.mmap		= sock_no_mmap,
 	.ioctl		= pppox_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = pppox_compat_ioctl,
+#endif
 };
 
 static const struct pppox_proto pppol2tp_proto = {
-- 
2.20.0

