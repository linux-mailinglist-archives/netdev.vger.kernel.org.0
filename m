Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4468DF64
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbfHNUyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:54:37 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:41269 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfHNUyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:54:37 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MCGag-1i7JwP394U-009SLt; Wed, 14 Aug 2019 22:54:19 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrei Vagin <avagin@openvz.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Karsten Graul <kgraul@linux.ibm.com>, netdev@vger.kernel.org
Subject: [PATCH v5 08/18] af_unix: add compat_ioctl support
Date:   Wed, 14 Aug 2019 22:49:20 +0200
Message-Id: <20190814205245.121691-3-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190814204259.120942-1-arnd@arndb.de>
References: <20190814204259.120942-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dUwT27CGBzz/z/iFH7wewdkdSdvlLNShWdUVQTkek3EQgS+uX41
 aO37xQVV8lWb9dpiuE9I0ZERJa0FPqHjpCmKZcj+ir9N0xu8yGVdjouxyfOO1paebssUffr
 qFIHUeVXWToAu8bKY3jH4J6oM4rGBFcXxXSFocM5VlJMwtQfpm55zq71c40+LSOfL0EYM2P
 0XPvByCAI47ETbx9fBHBQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0WxWARh94sE=:Xue4xB86x6UmElprkOCTSD
 B0RU7Mme+fjdmZ+UPPS2sKwrd2CYgFR4rYrhGGPancYREaRFpTTf10oGWOo9c5WzmnNTWPEBW
 W0NUM3i0+I9uW64voo+O98IaKs30Y/134CBA98kYEm2XCWqBejFBQSdkfP+b2qVQXonZ9J63w
 HTPUMSnEU0DwBx7HvTz4xSiEULjGwulNRBHP/60rEY5klusHk0/K3sEPIlFGd8wae9sI/C83O
 IcF2Tq0dKVYgr8ujwHsZQt1lLEYLYD8+Kl6XjG+XWWhVdqV8vdRpn/klbbeCDRvXds5zbE+pT
 6cPvUfJba/JAo/rzo/eu9Lkj8A2ro2Bo3L03C7XgrdMxSVMkGypXj8McDLEAu+NiWKXNgnSa2
 Ea97VnXxEMEC1Q4eOiO5N8qz7cvG9EiCBZs0er/Wi+u6Eit1V8xxVLKUaQjLpXXnmoEmc0PQx
 QU4iW/syVkmeCAqSn5bT/06wb9X6WfEid1nWh/1ffRug8iQlJHLJU9QPqf2NHMP0Bl0J5ZGuN
 att+5GYO+07SYP75QjqK+1zRlgNf8haRXKDxXgXaPa+WwjF7wtOL9m82KWcWOLkq6cAi433rc
 Cgpk8kbUP8rf8H/psu300gdUx+hYbNH9ikM9+I0pOh8++YfRHDVPnteW2ccwiaXSRWTor0W0g
 3qO3beKoId/KctsJlWNQjkXuSzhc4dkBQoujd1kux0Y+Oi3oW6xWZ4d8ZUEtJfAP7Nt70yTz8
 KQSbA0x9pRDYgXWraziR1x2GYMR+eXSaLZ/F0w==
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

