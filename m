Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A215A1D70F4
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 08:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgERG21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 02:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgERG20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 02:28:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF256C061A0C;
        Sun, 17 May 2020 23:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Aa7pQdQ67QhNGXoh9/Qd974F+iaGAZ34nb6yfYgz4xI=; b=e5jNcFUb55IfIvxRCgBGmLYnSr
        gIeoFy07yY1Ev1jKcBkAWx1s2L2uN6OvpytuPTOK4TU6/9IDxVwFszUTz3iTlt5q75jjPLs149Uus
        oohnMqgE/ZBORMgdxL0TFogCoCB26muYLxBUXZjsOENnKEsSGMIpngFHEFb2HypaU+kEG91nZ/xya
        fc6etDMLRlaisEyKUnqlFcYlhAn0pRKHyAwvC32AG7bRlSz5dhnOGYiMdx329roZcFMkIAO09QjBi
        QfVq4EVl9Wj4sgO3iPH1h7b2Jfz9a6RRTxDLYTM+07V7K7QfUC3bJVGcQOS42NxoRt3obIryxTHgb
        23L+bzzg==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaZGB-0002aI-Al; Mon, 18 May 2020 06:28:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/4] ipv4,appletalk: move SIOCADDRT and SIOCDELRT handling into ->compat_ioctl
Date:   Mon, 18 May 2020 08:28:08 +0200
Message-Id: <20200518062808.756610-5-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518062808.756610-1-hch@lst.de>
References: <20200518062808.756610-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To prepare removing the global routing_ioctl hack start lifting the code
into the ipv4 and appletalk ->compat_ioctl handlers.  Unlike the existing
handler we don't bother copying in the name - there are no compat issues for
char arrays.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/compat.h | 18 +++++++++++++
 net/appletalk/ddp.c  | 49 ++++++++++++++++++++++++++++++----
 net/ipv4/af_inet.c   | 38 ++++++++++++++++++++++-----
 net/socket.c         | 62 --------------------------------------------
 4 files changed, 94 insertions(+), 73 deletions(-)

diff --git a/include/net/compat.h b/include/net/compat.h
index e341260642fee..2b5e1f7ba1533 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -30,6 +30,24 @@ struct compat_cmsghdr {
 	compat_int_t	cmsg_type;
 };
 
+struct compat_rtentry {
+	u32		rt_pad1;
+	struct sockaddr rt_dst;         /* target address               */
+	struct sockaddr rt_gateway;     /* gateway addr (RTF_GATEWAY)   */
+	struct sockaddr rt_genmask;     /* target network mask (IP)     */
+	unsigned short	rt_flags;
+	short		rt_pad2;
+	u32		rt_pad3;
+	unsigned char	rt_tos;
+	unsigned char	rt_class;
+	short		rt_pad4;
+	short		rt_metric;      /* +1 for binary compatibility! */
+	compat_uptr_t	rt_dev;         /* forcing the device at add    */
+	u32		rt_mtu;         /* per route MTU/Window         */
+	u32		rt_window;      /* Window clamping              */
+	unsigned short  rt_irtt;        /* Initial RTT                  */
+};
+
 #else /* defined(CONFIG_COMPAT) */
 /*
  * To avoid compiler warnings:
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 4177a74f65436..15787e8c0629a 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -57,6 +57,7 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/route.h>
+#include <net/compat.h>
 #include <linux/atalk.h>
 #include <linux/highmem.h>
 
@@ -1839,20 +1840,58 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 
 
 #ifdef CONFIG_COMPAT
+static int atalk_compat_routing_ioctl(struct sock *sk, unsigned int cmd,
+		struct compat_rtentry __user *ur)
+{
+	compat_uptr_t rtdev;
+	struct rtentry rt;
+
+	if (copy_from_user(&rt.rt_dst, &ur->rt_dst,
+			3 * sizeof(struct sockaddr)) ||
+	    get_user(rt.rt_flags, &ur->rt_flags) ||
+	    get_user(rt.rt_metric, &ur->rt_metric) ||
+	    get_user(rt.rt_mtu, &ur->rt_mtu) ||
+	    get_user(rt.rt_window, &ur->rt_window) ||
+	    get_user(rt.rt_irtt, &ur->rt_irtt) ||
+	    get_user(rtdev, &ur->rt_dev))
+		return -EFAULT;
+
+	switch (cmd) {
+	case SIOCDELRT:
+		if (rt.rt_dst.sa_family != AF_APPLETALK)
+			return -EINVAL;
+		return atrtr_delete(&((struct sockaddr_at *)
+				      &rt.rt_dst)->sat_addr);
+
+	case SIOCADDRT:
+		rt.rt_dev = compat_ptr(rtdev);
+		return atrtr_ioctl_addrt(&rt);
+	default:
+		return -EINVAL;
+	}
+}
 static int atalk_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
+	void __user *argp = compat_ptr(arg);
+	struct sock *sk = sock->sk;
+
+	switch (cmd) {
+	case SIOCADDRT:
+	case SIOCDELRT:
+		return atalk_compat_routing_ioctl(sk, cmd, argp);
 	/*
 	 * SIOCATALKDIFADDR is a SIOCPROTOPRIVATE ioctl number, so we
 	 * cannot handle it in common code. The data we access if ifreq
 	 * here is compatible, so we can simply call the native
 	 * handler.
 	 */
-	if (cmd == SIOCATALKDIFADDR)
-		return atalk_ioctl(sock, cmd, (unsigned long)compat_ptr(arg));
-
-	return -ENOIOCTLCMD;
+	case SIOCATALKDIFADDR:
+		return atalk_ioctl(sock, cmd, (unsigned long)argp);
+	default:
+		return -ENOIOCTLCMD;
+	}
 }
-#endif
+#endif /* CONFIG_COMPAT */
 
 
 static const struct net_proto_family atalk_family_ops = {
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index fcf0d12a407a9..c35a8b2e0499e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -116,6 +116,7 @@
 #include <linux/mroute.h>
 #endif
 #include <net/l3mdev.h>
+#include <net/compat.h>
 
 #include <trace/events/sock.h>
 
@@ -970,17 +971,42 @@ int inet_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 EXPORT_SYMBOL(inet_ioctl);
 
 #ifdef CONFIG_COMPAT
+static int inet_compat_routing_ioctl(struct sock *sk, unsigned int cmd,
+		struct compat_rtentry __user *ur)
+{
+	compat_uptr_t rtdev;
+	struct rtentry rt;
+
+	if (copy_from_user(&rt.rt_dst, &ur->rt_dst,
+			3 * sizeof(struct sockaddr)) ||
+	    get_user(rt.rt_flags, &ur->rt_flags) ||
+	    get_user(rt.rt_metric, &ur->rt_metric) ||
+	    get_user(rt.rt_mtu, &ur->rt_mtu) ||
+	    get_user(rt.rt_window, &ur->rt_window) ||
+	    get_user(rt.rt_irtt, &ur->rt_irtt) ||
+	    get_user(rtdev, &ur->rt_dev))
+		return -EFAULT;
+
+	rt.rt_dev = compat_ptr(rtdev);
+	return ip_rt_ioctl(sock_net(sk), cmd, &rt);
+}
+
 static int inet_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
+	void __user *argp = compat_ptr(arg);
 	struct sock *sk = sock->sk;
-	int err = -ENOIOCTLCMD;
-
-	if (sk->sk_prot->compat_ioctl)
-		err = sk->sk_prot->compat_ioctl(sk, cmd, arg);
 
-	return err;
+	switch (cmd) {
+	case SIOCADDRT:
+	case SIOCDELRT:
+		return inet_compat_routing_ioctl(sk, cmd, argp);
+	default:
+		if (!sk->sk_prot->compat_ioctl)
+			return -ENOIOCTLCMD;
+		return sk->sk_prot->compat_ioctl(sk, cmd, arg);
+	}
 }
-#endif
+#endif /* CONFIG_COMPAT */
 
 const struct proto_ops inet_stream_ops = {
 	.family		   = PF_INET,
diff --git a/net/socket.c b/net/socket.c
index 6824470757753..80422fc3c836e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3366,65 +3366,6 @@ static int compat_sioc_ifmap(struct net *net, unsigned int cmd,
 	return err;
 }
 
-struct rtentry32 {
-	u32		rt_pad1;
-	struct sockaddr rt_dst;         /* target address               */
-	struct sockaddr rt_gateway;     /* gateway addr (RTF_GATEWAY)   */
-	struct sockaddr rt_genmask;     /* target network mask (IP)     */
-	unsigned short	rt_flags;
-	short		rt_pad2;
-	u32		rt_pad3;
-	unsigned char	rt_tos;
-	unsigned char	rt_class;
-	short		rt_pad4;
-	short		rt_metric;      /* +1 for binary compatibility! */
-	/* char * */ u32 rt_dev;        /* forcing the device at add    */
-	u32		rt_mtu;         /* per route MTU/Window         */
-	u32		rt_window;      /* Window clamping              */
-	unsigned short  rt_irtt;        /* Initial RTT                  */
-};
-
-static int routing_ioctl(struct net *net, struct socket *sock,
-			 unsigned int cmd, void __user *argp)
-{
-	struct rtentry32 __user *ur4 = argp;
-	int ret;
-	void *r = NULL;
-	struct rtentry r4;
-	char devname[16];
-	u32 rtdev;
-	mm_segment_t old_fs = get_fs();
-
-	ret = copy_from_user(&r4.rt_dst, &(ur4->rt_dst),
-				3 * sizeof(struct sockaddr));
-	ret |= get_user(r4.rt_flags, &(ur4->rt_flags));
-	ret |= get_user(r4.rt_metric, &(ur4->rt_metric));
-	ret |= get_user(r4.rt_mtu, &(ur4->rt_mtu));
-	ret |= get_user(r4.rt_window, &(ur4->rt_window));
-	ret |= get_user(r4.rt_irtt, &(ur4->rt_irtt));
-	ret |= get_user(rtdev, &(ur4->rt_dev));
-	if (rtdev) {
-		ret |= copy_from_user(devname, compat_ptr(rtdev), 15);
-		r4.rt_dev = (char __user __force *)devname;
-		devname[15] = 0;
-	} else
-		r4.rt_dev = NULL;
-
-	r = (void *) &r4;
-
-	if (ret) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	set_fs(KERNEL_DS);
-	ret = sock_do_ioctl(net, sock, cmd, (unsigned long) r);
-	set_fs(old_fs);
-
-out:
-	return ret;
-}
-
 /* Since old style bridge ioctl's endup using SIOCDEVPRIVATE
  * for some operations; this forces use of the newer bridge-utils that
  * use compatible ioctls
@@ -3463,9 +3404,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCGIFMAP:
 	case SIOCSIFMAP:
 		return compat_sioc_ifmap(net, cmd, argp);
-	case SIOCADDRT:
-	case SIOCDELRT:
-		return routing_ioctl(net, sock, cmd, argp);
 	case SIOCGSTAMP_OLD:
 	case SIOCGSTAMPNS_OLD:
 		if (!sock->ops->gettstamp)
-- 
2.26.2

