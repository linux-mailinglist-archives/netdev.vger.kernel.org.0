Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569B3D184B
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732366AbfJITNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:13:00 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:40875 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732023AbfJITL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:11:29 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M1q8m-1iG5Vf2T6m-002IBj; Wed, 09 Oct 2019 21:11:19 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH v6 33/43] af_unix: add compat_ioctl support
Date:   Wed,  9 Oct 2019 21:10:34 +0200
Message-Id: <20191009191044.308087-34-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191009190853.245077-1-arnd@arndb.de>
References: <20191009190853.245077-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:3hdG2mB6y44B0lENsOLf+2JDxXb3GxKb0/+ZwQvy3N3s/s32/P5
 vsJoA/nDkhpGhYQ9IuXvMf0Od0U3+NdvFgjzguncjWj0z/nmTWr97Eu7GcWyY/BsZJ7IohE
 SMbRsEA/pHwT6+RczHlwA+6AEGP6XoJ45JRmyVUF48tW2+sZZMIbmTegWuZER9d2onWnhfB
 D+6vZRCHykJ9r3s6EFVQw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QExA1yG/mEs=:1iv7z69M91ozcpEzAcJS8N
 D5/hPa9khNPOhB1vQ3baDoXoQNI9zNUTMPFc5/itQLeOe7xPmYf4xU6zlKHp8HVjuApbFlvyO
 THVFT2YBcMFj1kuCAg3KvZB/aowFwzwk5b7sQjQPHBJmF+fxyHQc6moNhH0O8HjJaulu0M+RF
 xXaF5TFpzThh2tNgxcuLb6TvxnjUxvVaiZ27rOxPTPl9YEB4BSAHc7eWfeWNs9jFDK8jNjjMs
 eld/n5aprDQILq4LI+aWbemj9Exx+5G7i8OBPa7twZ+AghEra2W5gD7fPTaX7zFiAY5mdihpK
 FmSBuo18Rd+2SkTpvLkoRfzqr1VZBE9jXUAHXe0dfA3dt3ysA5mq6anQQnQmz5z4cImFOJIXb
 bOxUXbTlkMSi4uNXnKyMMIslYlyIhqAXKqtmnpyzmE4jD03W+1kgSDnp1lVu4HiFLs2oBFi6z
 WEzeBrdM7jZwMv74jcLjqDnMyfcgfLyURFnLVNqVyQNooembPsC0nmMYVJY2d4fX0xSaumoNn
 sz3V4LgAgz2NSzQtfRKp5I5wxGdIbGVrbrQJTrhnzb83hSy4WDExPiLqalLUS/MQoCl9OkiBA
 fnlEQASdMV2M3OVOc7JLjQow8u/zWNMXH3E4sxWixvU+8VDQDmyCJsFb9QFxOWnMutD1dCNU7
 ae6hhCSpKQcRyv2K+af5J2GvLRxgS3UWgAR6EMwyKKmFNp//ISdyMBXzRUiaZLU213o0IcIdJ
 ryA9pBI7Jap+K5zCheTsYPCDOursm+jghdTRfI/3wPN6nUGXzevhieyzjKjwOoRC/1lvnhGYw
 Ix6OlgQFLR3wRUxaP5PWn3D5jJvCfLDTPjsX1hDdkFIxj4gYvuKKifGLDnvk5aUtQPEamMWJh
 nzCyruV5Ic0y0PYj9Cug==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The af_unix protocol family has a custom ioctl command (inexplicibly
based on SIOCPROTOPRIVATE), but never had a compat_ioctl handler for
32-bit applications.

Since all commands are compatible here, add a trivial wrapper that
performs the compat_ptr() conversion for SIOCOUTQ/SIOCINQ.  SIOCUNIXFILE
does not use the argument, but it doesn't hurt to also use compat_ptr()
here.

Fixes: ba94f3088b79 ("unix: add ioctl to open a unix socket file with O_PATH")
Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/unix/af_unix.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 67e87db5877f..e18ca6d9f3d4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -646,6 +646,9 @@ static __poll_t unix_poll(struct file *, struct socket *, poll_table *);
 static __poll_t unix_dgram_poll(struct file *, struct socket *,
 				    poll_table *);
 static int unix_ioctl(struct socket *, unsigned int, unsigned long);
+#ifdef CONFIG_COMPAT
+static int unix_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
+#endif
 static int unix_shutdown(struct socket *, int);
 static int unix_stream_sendmsg(struct socket *, struct msghdr *, size_t);
 static int unix_stream_recvmsg(struct socket *, struct msghdr *, size_t, int);
@@ -687,6 +690,9 @@ static const struct proto_ops unix_stream_ops = {
 	.getname =	unix_getname,
 	.poll =		unix_poll,
 	.ioctl =	unix_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =	unix_compat_ioctl,
+#endif
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
 	.setsockopt =	sock_no_setsockopt,
@@ -710,6 +716,9 @@ static const struct proto_ops unix_dgram_ops = {
 	.getname =	unix_getname,
 	.poll =		unix_dgram_poll,
 	.ioctl =	unix_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =	unix_compat_ioctl,
+#endif
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
 	.setsockopt =	sock_no_setsockopt,
@@ -732,6 +741,9 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.getname =	unix_getname,
 	.poll =		unix_dgram_poll,
 	.ioctl =	unix_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =	unix_compat_ioctl,
+#endif
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
 	.setsockopt =	sock_no_setsockopt,
@@ -2582,6 +2594,13 @@ static int unix_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	return err;
 }
 
+#ifdef CONFIG_COMPAT
+static int unix_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
+{
+	return unix_ioctl(sock, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
+
 static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wait)
 {
 	struct sock *sk = sock->sk;
-- 
2.20.0

