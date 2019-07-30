Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7667B3DA
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfG3UBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:01:08 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:45393 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfG3UBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 16:01:08 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mk0e8-1icaLz2Q9Y-00kT86; Tue, 30 Jul 2019 22:00:59 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 18/29] compat_ioctl: move rfcomm handlers into driver
Date:   Tue, 30 Jul 2019 21:55:34 +0200
Message-Id: <20190730195819.901457-6-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190730195819.901457-1-arnd@arndb.de>
References: <20190730192552.4014288-1-arnd@arndb.de>
 <20190730195819.901457-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:KNUY+ou8651nO/evqeLR4khDAmABirIr+RCPLbKFzTO6f5smDMh
 1tpV8P1jpGNB6ALSmigGLUZLlFHyaaEDufHC/sMHAsJQX00Y4thd3ENOiqljWbJEzD/B0jP
 3FZ1Vg0T8Sp9hiGsegZTX8CUT8bO/ryYKyoVmUdgOtjtrOaEj5ukTDZE/2SQcPjIz+yJF4Z
 cNqFP1tMWqkXErX4a1fsg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+6CEOpAQoyc=:LyOCzZSE4+jayuS467Z4/c
 8st+rNurhs1J6i/XBZ+oNNjgNY4fpj2tE22ZLfhBHQ32BjcQW9V/jq1YJHVnAiBSI9+h+nOmV
 NDfSJ7o3PxNaRCTDKlxhEu8+Gt6T8I0VhW2i7nIhHADGVDjQgfZFhr0GMXtEMywH4CrVC9ryN
 0FlHEExe6sXeQrloA038UPeg4eY926SX11JLvMSMIL3wBKbFopNUg9I2BZC9L8itzGJXyE5Az
 axZfI73Q0ig0PDsLru5Oxso8qza4lo525zyJtq68YgX3c7i0Rq68nsYfR0LlyX+xqG/bCeHPh
 jf/gj9aYU87g1Kp3zxJD/QaE5CRBbUgHlWtA0fiEBhfMRoGwfI98J4N1bzGcFWRnNcZy/naLy
 2qgf3nX9cZWQ3ztX5zm+ub6qfBG/4xjpaDJfx9Q/2tp0MkVfXJ1YbLjjHYTTKch7T8QWOwCDR
 HCcFUUfen+3iIXFWtxKKs04DiMsnR1LPbf2NjuC0p2ZbzZhHYqwSUC/A9b72DoXyabCctaS+C
 GnnL3526Z5SEMHHDWT5SxJM4q/rHqwm/rylEBsp6YakLo44c5xbf+1AjFioUVkvqLlQGZ2djo
 X5uHtMn6/g3qBnxLWcN95L+F6szxHsCa3jWYKdLja7aaj/61jPLNBslLL55QLSQxprFwS54Py
 1y9Tdb5ip6RbxKkA1xY3HwjTSAU/glEcypMCehY5sHzVrLYJDzMAUU/3xUk83Ufz1R9GrhJas
 CGivUsGxb3i8IkbfD9eVTXzNvDmq68u3F8vEsw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All these ioctl commands are compatible, so we can handle
them with a trivial wrapper in rfcomm/sock.c and remove
the listing in fs/compat_ioctl.c.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c           |  6 ------
 net/bluetooth/rfcomm/sock.c | 14 ++++++++++++--
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f3b4179d6dff..8dbef92b10fd 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -42,7 +42,6 @@
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_sock.h>
-#include <net/bluetooth/rfcomm.h>
 
 #ifdef CONFIG_BLOCK
 #include <linux/cdrom.h>
@@ -673,11 +672,6 @@ COMPATIBLE_IOCTL(HCIUARTGETPROTO)
 COMPATIBLE_IOCTL(HCIUARTGETDEVICE)
 COMPATIBLE_IOCTL(HCIUARTSETFLAGS)
 COMPATIBLE_IOCTL(HCIUARTGETFLAGS)
-COMPATIBLE_IOCTL(RFCOMMCREATEDEV)
-COMPATIBLE_IOCTL(RFCOMMRELEASEDEV)
-COMPATIBLE_IOCTL(RFCOMMGETDEVLIST)
-COMPATIBLE_IOCTL(RFCOMMGETDEVINFO)
-COMPATIBLE_IOCTL(RFCOMMSTEALDLC)
 /* Misc. */
 COMPATIBLE_IOCTL(PCIIOC_CONTROLLER)
 COMPATIBLE_IOCTL(PCIIOC_MMAP_IS_IO)
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 90bb53aa4bee..b4eaf21360ef 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -24,7 +24,7 @@
 /*
  * RFCOMM sockets.
  */
-
+#include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/debugfs.h>
 #include <linux/sched/signal.h>
@@ -909,6 +909,13 @@ static int rfcomm_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned lon
 	return err;
 }
 
+#ifdef CONFIG_COMPAT
+static int rfcomm_sock_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
+{
+	return rfcomm_sock_ioctl(sock, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static int rfcomm_sock_shutdown(struct socket *sock, int how)
 {
 	struct sock *sk = sock->sk;
@@ -1042,7 +1049,10 @@ static const struct proto_ops rfcomm_sock_ops = {
 	.gettstamp	= sock_gettstamp,
 	.poll		= bt_sock_poll,
 	.socketpair	= sock_no_socketpair,
-	.mmap		= sock_no_mmap
+	.mmap		= sock_no_mmap,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= rfcomm_sock_compat_ioctl,
+#endif
 };
 
 static const struct net_proto_family rfcomm_sock_family_ops = {
-- 
2.20.0

