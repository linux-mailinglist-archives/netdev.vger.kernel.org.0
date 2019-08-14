Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E762F8DF6B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbfHNUze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:55:34 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:41385 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfHNUzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:55:33 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M1YtP-1i12RD37Ot-0037Zk; Wed, 14 Aug 2019 22:55:24 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
Subject: [PATCH v5 10/18] compat_ioctl: move SIOCOUTQ out of compat_ioctl.c
Date:   Wed, 14 Aug 2019 22:54:45 +0200
Message-Id: <20190814205521.122180-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190814204259.120942-1-arnd@arndb.de>
References: <20190814204259.120942-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:v7fqYyRWcR/L7MO3acdXThwZvUt3754+rVJBd6ZPhL9Cl1yCVvn
 gRvBNyPrVt7LggG5Mq05U6BexgSi81BDnlkZvRL/ICitCUpf6PVr5WcQZfsm/JhRu14RonY
 JhpbPU1GooKwIudtCHSrXnUkk/6+lXaSUMxSer9mvbS7NoTAnAgkpn/4YMDl4BnUDFMoKG2
 3BBh2VXHqJZ7obI2kNDLA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OTDXPZE8Xv4=:2E5DZr6+h1yfYpY7TjG80/
 yhaFAIdO01y38tSn7GreEwX8NdvikpQpZfsIESNDvncaZbULO1bAPcmV7icJ5SF6ZOY5MsyPo
 bp3ohRoxLmSPoAFk46duttwNRbrSxWbow3oILp6NpCjLoQ43RgdlvexlnuoF2oQhNLJ7EqSoA
 art5XsD/ibmvn6WAlp5ZZqt89xbypOiHfexeM0nyYEzX/McqmGrhH9RA//+Z6u7dWEk9P6LE/
 95hQqHRWBukJ243V84AIgtuGFTex/EOTfc1W5KxacBjUAQ/3Loe0WD0RLoK9P6g0NxnehY+c7
 e74i2abMntXSY1mZRq6BKdBu3o6oC5cxvvCNw0fLarRGAMnrubCiz2aKARjSrXgFz1WMUryql
 kqAAIz0Vdg/zFfRNwQsuGz8HeMRBzyjpy2pXao8rfrGi4ptSHSRmrFSGJZrukgZpA3hXhPp6u
 K1URqKozcgtOyJMC6t4ScNFuG1XHXfLcZi8ncN8NMY9tjly4eJZZYvvFTBbLtPmNQMmcw5LaX
 JJAMd+2YF4KyljlxlDeZg7HQ9o5dKVHFFsSGWLrZsfoAwhdXqF4MfB2jxnNVgPpNDMR93kaqr
 eovNP8hFJ2xBN76Xez8054dCcmPmcKyGzbl2TrDZ5m6qgQuPXaDwN/HjQeVBMF5lq6scjvnbO
 nEtvlIrfNp8l5TQtY1t0UT48rdEa7JvMFa/eTUvsCEGeMSjmcTopo/HHNxi4o8Yux37kaM8Jl
 3lzVNYUVo/wApcOiXf0Lag2HQHFdDWwtKieNST6f96M53tj9SUkv0sD0Dm5CWHoDkYtRCKc1M
 vUePiAWE6CkZkP9zEkMye3C0e5GDQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All users of this call are in socket or tty code, so handling
it there means we can avoid the table entry in fs/compat_ioctl.c.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/tty/tty_io.c | 1 +
 fs/compat_ioctl.c    | 2 --
 net/socket.c         | 2 ++
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 566728fbaf3c..cee8b69c6f72 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2755,6 +2755,7 @@ static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 	int retval = -ENOIOCTLCMD;
 
 	switch (cmd) {
+	case TIOCOUTQ:
 	case TIOCSTI:
 	case TIOCGWINSZ:
 	case TIOCSWINSZ:
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f279e77df256..d537888f3660 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -198,8 +198,6 @@ static int ppp_scompress(struct file *file, unsigned int cmd,
 
 #define COMPATIBLE_IOCTL(cmd) XFORM((u32)cmd),
 static unsigned int ioctl_pointer[] = {
-/* Little t */
-COMPATIBLE_IOCTL(TIOCOUTQ)
 #ifdef CONFIG_BLOCK
 /* Big S */
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
diff --git a/net/socket.c b/net/socket.c
index a60f48ab2130..371999a024fa 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -100,6 +100,7 @@
 #include <linux/if_tun.h>
 #include <linux/ipv6_route.h>
 #include <linux/route.h>
+#include <linux/termios.h>
 #include <linux/sockios.h>
 #include <net/busy_poll.h>
 #include <linux/errqueue.h>
@@ -3452,6 +3453,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCSARP:
 	case SIOCGARP:
 	case SIOCDARP:
+	case SIOCOUTQ:
 	case SIOCOUTQNSD:
 	case SIOCATMARK:
 		return sock_do_ioctl(net, sock, cmd, arg);
-- 
2.20.0

