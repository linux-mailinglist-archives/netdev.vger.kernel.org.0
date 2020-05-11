Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C8F1CD100
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 06:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgEKEqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 00:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728260AbgEKEp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 00:45:57 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B63C061A0E;
        Sun, 10 May 2020 21:45:56 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY0KB-005jIY-F6; Mon, 11 May 2020 04:45:55 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/19] ipv6: take handling of group_source_req options into a helper
Date:   Mon, 11 May 2020 05:45:45 +0100
Message-Id: <20200511044553.1365660-11-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
References: <20200511044328.GP23230@ZenIV.linux.org.uk>
 <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/ipv6/ipv6_sockglue.c | 65 +++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index b386a2b3668c..fc525ad9ed3c 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -136,6 +136,41 @@ static bool setsockopt_needs_rtnl(int optname)
 	return false;
 }
 
+static int do_ipv6_mcast_group_source(struct sock *sk, int optname,
+				      struct group_source_req *greqs)
+{
+	int omode, add;
+
+	if (greqs->gsr_group.ss_family != AF_INET6 ||
+	    greqs->gsr_source.ss_family != AF_INET6)
+		return -EADDRNOTAVAIL;
+
+	if (optname == MCAST_BLOCK_SOURCE) {
+		omode = MCAST_EXCLUDE;
+		add = 1;
+	} else if (optname == MCAST_UNBLOCK_SOURCE) {
+		omode = MCAST_EXCLUDE;
+		add = 0;
+	} else if (optname == MCAST_JOIN_SOURCE_GROUP) {
+		struct sockaddr_in6 *psin6;
+		int retv;
+
+		psin6 = (struct sockaddr_in6 *)&greqs->gsr_group;
+		retv = ipv6_sock_mc_join_ssm(sk, greqs->gsr_interface,
+					     &psin6->sin6_addr,
+					     MCAST_INCLUDE);
+		/* prior join w/ different source is ok */
+		if (retv && retv != -EADDRINUSE)
+			return retv;
+		omode = MCAST_INCLUDE;
+		add = 1;
+	} else /* MCAST_LEAVE_SOURCE_GROUP */ {
+		omode = MCAST_INCLUDE;
+		add = 0;
+	}
+	return ip6_mc_source(add, omode, sk, greqs);
+}
+
 static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, unsigned int optlen)
 {
@@ -715,7 +750,6 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 	case MCAST_UNBLOCK_SOURCE:
 	{
 		struct group_source_req greqs;
-		int omode, add;
 
 		if (optlen < sizeof(struct group_source_req))
 			goto e_inval;
@@ -723,34 +757,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 			retv = -EFAULT;
 			break;
 		}
-		if (greqs.gsr_group.ss_family != AF_INET6 ||
-		    greqs.gsr_source.ss_family != AF_INET6) {
-			retv = -EADDRNOTAVAIL;
-			break;
-		}
-		if (optname == MCAST_BLOCK_SOURCE) {
-			omode = MCAST_EXCLUDE;
-			add = 1;
-		} else if (optname == MCAST_UNBLOCK_SOURCE) {
-			omode = MCAST_EXCLUDE;
-			add = 0;
-		} else if (optname == MCAST_JOIN_SOURCE_GROUP) {
-			struct sockaddr_in6 *psin6;
-
-			psin6 = (struct sockaddr_in6 *)&greqs.gsr_group;
-			retv = ipv6_sock_mc_join_ssm(sk, greqs.gsr_interface,
-						     &psin6->sin6_addr,
-						     MCAST_INCLUDE);
-			/* prior join w/ different source is ok */
-			if (retv && retv != -EADDRINUSE)
-				break;
-			omode = MCAST_INCLUDE;
-			add = 1;
-		} else /* MCAST_LEAVE_SOURCE_GROUP */ {
-			omode = MCAST_INCLUDE;
-			add = 0;
-		}
-		retv = ip6_mc_source(add, omode, sk, &greqs);
+		retv = do_ipv6_mcast_group_source(sk, optname, &greqs);
 		break;
 	}
 	case MCAST_MSFILTER:
-- 
2.11.0

