Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367983F7FE5
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237393AbhHZB2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbhHZB2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:28:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE74C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:27:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a62-20020a254d410000b0290592f360b0ccso1418722ybb.14
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ezec1I4H90P09h79RVbQ3uCzdElICKnF3wN8c7nmOZk=;
        b=iBHkey8i/T0CNWc4iUCR1opeac0+E+IlLoWBD6/iEpE//xGmQ1qFkwdvCviPV2rHdL
         COQIG7PvgdlQscHCRQ5JN8moZvmqQXU/r4zr6mVEuoxQjNnFq/zTGo8FfJT7KcwatwCQ
         aURduY/7LX4tBU99EOBrMIFv2f5kT3IOG0/sIamzitqzqiwchipKtBqanU0fYfnqwVte
         PHix5nXzZPBavz90hbMhnczSdgMX5ZXtPcRkqaJRmsteP+C4j0/ohFWP+p8fF2pRVPfW
         v9QzFodzdqKBLkGM0Qy0H4aGMu3dpX1zumru3nQG8mxeyBr0IX8jPCX62SRKS7iJNSDQ
         NiHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ezec1I4H90P09h79RVbQ3uCzdElICKnF3wN8c7nmOZk=;
        b=ultcbl6BviZ77zRcURm1kA+TbZcWxAVuW+TiIJYbqc25I0+Ncht1C2C0nfhPGfLWvl
         y1mTjCfz76nr0vl2JspVwLC0sE8oFkAX3wDq1FpCrD8vBEzv70EK13z6sMseyrFxqUf2
         mN39d9Akf9vMiee32jJAwO9wKnDWD5fk7DhQ8cMyahPFWs+8XusUck5bXPg+gRODVy13
         FzmjHCXnrxSaNvhc+t0fqbZtQ+sehqS9FjZq/Sl4lDY6iHJxQWL0ThSs+51zkLGJ4VtC
         wsw6vWd9iKf5atj6mJak1RzH7h1WU8YhnpEXR3NcEu3nkjhoE1+YIzfJQeoGoPGf4g8w
         P7mA==
X-Gm-Message-State: AOAM531U7mfrcaaF9Fyk0P7oO01pCfGhx3PU/UAg8TAkcGFR761OOSr0
        cpV/dk/Gkdtasy0LJxVcEKTv/wA=
X-Google-Smtp-Source: ABdhPJwkCu2INY1MJ3PQnt4wvzh4D2iiOlPp6ROmwjTRlZsS94P9Xz6MXcuSNH6u2JvEbZhDhfxOT8w=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:4c58:f8bf:74a9:6e55])
 (user=pcc job=sendgmr) by 2002:a25:1456:: with SMTP id 83mr2003884ybu.440.1629941249562;
 Wed, 25 Aug 2021 18:27:29 -0700 (PDT)
Date:   Wed, 25 Aug 2021 18:27:22 -0700
Message-Id: <20210826012722.3210359-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH] net: don't unconditionally copy_from_user a struct ifreq for
 socket ioctls
From:   Peter Collingbourne <pcc@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Peter Collingbourne <pcc@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A common implementation of isatty(3) involves calling a ioctl passing
a dummy struct argument and checking whether the syscall failed --
bionic and glibc use TCGETS (passing a struct termios), and musl uses
TIOCGWINSZ (passing a struct winsize). If the FD is a socket, we will
copy sizeof(struct ifreq) bytes of data from the argument and return
-EFAULT if that fails. The result is that the isatty implementations
may return a non-POSIX-compliant value in errno in the case where part
of the dummy struct argument is inaccessible, as both struct termios
and struct winsize are smaller than struct ifreq (at least on arm64).

Although there is usually enough stack space following the argument
on the stack that this did not present a practical problem up to now,
with MTE stack instrumentation it's more likely for the copy to fail,
as the memory following the struct may have a different tag.

Fix the problem by adding an early check for whether the ioctl is a
valid socket ioctl, and return -ENOTTY if it isn't.

Fixes: 44c02a2c3dc5 ("dev_ioctl(): move copyin/copyout to callers")
Link: https://linux-review.googlesource.com/id/I869da6cf6daabc3e4b7b82ac979683ba05e27d4d
Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: <stable@vger.kernel.org> # 4.19
---
 include/linux/netdevice.h |  1 +
 net/core/dev_ioctl.c      | 64 ++++++++++++++++++++++++++++++++-------
 net/socket.c              |  6 +++-
 3 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf5bb008aa9..481b90ef0d32 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4012,6 +4012,7 @@ int netdev_rx_handler_register(struct net_device *dev,
 void netdev_rx_handler_unregister(struct net_device *dev);
 
 bool dev_valid_name(const char *name);
+bool is_dev_ioctl_cmd(unsigned int cmd);
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		bool *need_copyout);
 int dev_ifconf(struct net *net, struct ifconf *, int);
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 478d032f34ac..ac807fc64da1 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -368,6 +368,54 @@ void dev_load(struct net *net, const char *name)
 }
 EXPORT_SYMBOL(dev_load);
 
+bool is_dev_ioctl_cmd(unsigned int cmd)
+{
+	switch (cmd) {
+	case SIOCGIFNAME:
+	case SIOCGIFHWADDR:
+	case SIOCGIFFLAGS:
+	case SIOCGIFMETRIC:
+	case SIOCGIFMTU:
+	case SIOCGIFSLAVE:
+	case SIOCGIFMAP:
+	case SIOCGIFINDEX:
+	case SIOCGIFTXQLEN:
+	case SIOCETHTOOL:
+	case SIOCGMIIPHY:
+	case SIOCGMIIREG:
+	case SIOCSIFNAME:
+	case SIOCSIFMAP:
+	case SIOCSIFTXQLEN:
+	case SIOCSIFFLAGS:
+	case SIOCSIFMETRIC:
+	case SIOCSIFMTU:
+	case SIOCSIFHWADDR:
+	case SIOCSIFSLAVE:
+	case SIOCADDMULTI:
+	case SIOCDELMULTI:
+	case SIOCSIFHWBROADCAST:
+	case SIOCSMIIREG:
+	case SIOCBONDENSLAVE:
+	case SIOCBONDRELEASE:
+	case SIOCBONDSETHWADDR:
+	case SIOCBONDCHANGEACTIVE:
+	case SIOCBRADDIF:
+	case SIOCBRDELIF:
+	case SIOCSHWTSTAMP:
+	case SIOCBONDSLAVEINFOQUERY:
+	case SIOCBONDINFOQUERY:
+	case SIOCGIFMEM:
+	case SIOCSIFMEM:
+	case SIOCSIFLINK:
+	case SIOCWANDEV:
+	case SIOCGHWTSTAMP:
+		return true;
+
+	default:
+		return cmd >= SIOCDEVPRIVATE && cmd <= SIOCDEVPRIVATE + 15;
+	}
+}
+
 /*
  *	This function handles all "interface"-type I/O control requests. The actual
  *	'doing' part of this is dev_ifsioc above.
@@ -521,16 +569,10 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 	 *	Unknown or private ioctl.
 	 */
 	default:
-		if (cmd == SIOCWANDEV ||
-		    cmd == SIOCGHWTSTAMP ||
-		    (cmd >= SIOCDEVPRIVATE &&
-		     cmd <= SIOCDEVPRIVATE + 15)) {
-			dev_load(net, ifr->ifr_name);
-			rtnl_lock();
-			ret = dev_ifsioc(net, ifr, cmd);
-			rtnl_unlock();
-			return ret;
-		}
-		return -ENOTTY;
+		dev_load(net, ifr->ifr_name);
+		rtnl_lock();
+		ret = dev_ifsioc(net, ifr, cmd);
+		rtnl_unlock();
+		return ret;
 	}
 }
diff --git a/net/socket.c b/net/socket.c
index 0b2dad3bdf7f..e58886b1882c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1109,7 +1109,7 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
 		rtnl_unlock();
 		if (!err && copy_to_user(argp, &ifc, sizeof(struct ifconf)))
 			err = -EFAULT;
-	} else {
+	} else if (is_dev_ioctl_cmd(cmd)) {
 		struct ifreq ifr;
 		bool need_copyout;
 		if (copy_from_user(&ifr, argp, sizeof(struct ifreq)))
@@ -1118,6 +1118,8 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
 		if (!err && need_copyout)
 			if (copy_to_user(argp, &ifr, sizeof(struct ifreq)))
 				return -EFAULT;
+	} else {
+		err = -ENOTTY;
 	}
 	return err;
 }
@@ -3306,6 +3308,8 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
 	struct ifreq ifreq;
 	u32 data32;
 
+	if (!is_dev_ioctl_cmd(cmd))
+		return -ENOTTY;
 	if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
 		return -EFAULT;
 	if (get_user(data32, &u_ifreq32->ifr_data))
-- 
2.33.0.rc2.250.ged5fa647cd-goog

