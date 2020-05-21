Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3491DC3F4
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgEUAh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbgEUAhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 20:37:25 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42F6C061A0F;
        Wed, 20 May 2020 17:37:24 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jbZD9-00CgeF-6d; Thu, 21 May 2020 00:37:23 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/19] ipv[46]: do compat setsockopt for MCAST_{JOIN,LEAVE}_GROUP directly
Date:   Thu, 21 May 2020 01:37:11 +0100
Message-Id: <20200521003721.3023783-9-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
References: <20200521003657.GE23230@ZenIV.linux.org.uk>
 <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

direct parallel to the way these two are handled in the native
->setsockopt() instances - the helpers that do the real work
are already separated and can be reused as-is in this case.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/ipv4/ip_sockglue.c   | 31 +++++++++++++++++++++++++++++++
 net/ipv6/ipv6_sockglue.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index b6b889b5dacf..34c3a43a9c98 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1282,6 +1282,37 @@ int compat_ip_setsockopt(struct sock *sk, int level, int optname,
 	switch (optname) {
 	case MCAST_JOIN_GROUP:
 	case MCAST_LEAVE_GROUP:
+	{
+		struct compat_group_req __user *gr32 = (void __user *)optval;
+		struct group_req greq;
+		struct sockaddr_in *psin = (struct sockaddr_in *)&greq.gr_group;
+		struct ip_mreqn mreq;
+
+		if (optlen < sizeof(struct compat_group_req))
+			return -EINVAL;
+
+		if (get_user(greq.gr_interface, &gr32->gr_interface) ||
+		    copy_from_user(&greq.gr_group, &gr32->gr_group,
+				sizeof(greq.gr_group)))
+			return -EFAULT;
+
+		if (psin->sin_family != AF_INET)
+			return -EINVAL;
+
+		memset(&mreq, 0, sizeof(mreq));
+		mreq.imr_multiaddr = psin->sin_addr;
+		mreq.imr_ifindex = greq.gr_interface;
+
+		rtnl_lock();
+		lock_sock(sk);
+		if (optname == MCAST_JOIN_GROUP)
+			err = ip_mc_join_group(sk, &mreq);
+		else
+			err = ip_mc_leave_group(sk, &mreq);
+		release_sock(sk);
+		rtnl_unlock();
+		return err;
+	}
 	case MCAST_JOIN_SOURCE_GROUP:
 	case MCAST_LEAVE_SOURCE_GROUP:
 	case MCAST_BLOCK_SOURCE:
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 2b5029df8f1e..209d827950cc 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -976,6 +976,34 @@ int compat_ipv6_setsockopt(struct sock *sk, int level, int optname,
 	switch (optname) {
 	case MCAST_JOIN_GROUP:
 	case MCAST_LEAVE_GROUP:
+	{
+		struct compat_group_req __user *gr32 = (void __user *)optval;
+		struct group_req greq;
+		struct sockaddr_in6 *psin6 = (struct sockaddr_in6 *)&greq.gr_group;
+
+		if (optlen < sizeof(struct compat_group_req))
+			return -EINVAL;
+
+		if (get_user(greq.gr_interface, &gr32->gr_interface) ||
+		    copy_from_user(&greq.gr_group, &gr32->gr_group,
+				sizeof(greq.gr_group)))
+			return -EFAULT;
+
+		if (greq.gr_group.ss_family != AF_INET6)
+			return -EADDRNOTAVAIL;
+
+		rtnl_lock();
+		lock_sock(sk);
+		if (optname == MCAST_JOIN_GROUP)
+			err = ipv6_sock_mc_join(sk, greq.gr_interface,
+						 &psin6->sin6_addr);
+		else
+			err = ipv6_sock_mc_drop(sk, greq.gr_interface,
+						 &psin6->sin6_addr);
+		release_sock(sk);
+		rtnl_unlock();
+		return err;
+	}
 	case MCAST_JOIN_SOURCE_GROUP:
 	case MCAST_LEAVE_SOURCE_GROUP:
 	case MCAST_BLOCK_SOURCE:
-- 
2.11.0

