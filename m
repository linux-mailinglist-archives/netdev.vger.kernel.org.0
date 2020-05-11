Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91FE1CD0FD
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 06:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgEKEqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 00:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728224AbgEKEp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 00:45:57 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C072FC061A0C;
        Sun, 10 May 2020 21:45:56 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY0KB-005jIR-8w; Mon, 11 May 2020 04:45:55 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/19] ipv4: take handling of group_source_req options into a helper
Date:   Mon, 11 May 2020 05:45:44 +0100
Message-Id: <20200511044553.1365660-10-viro@ZenIV.linux.org.uk>
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
 net/ipv4/ip_sockglue.c | 83 ++++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 39 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 937f39906419..4f412b0bdda4 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -624,6 +624,49 @@ static int set_mcast_msfilter(struct sock *sk, int ifindex,
 	return -EADDRNOTAVAIL;
 }
 
+static int do_mcast_group_source(struct sock *sk, int optname,
+				 struct group_source_req *greqs)
+{
+	struct ip_mreq_source mreqs;
+	struct sockaddr_in *psin;
+	int omode, add, err;
+
+	if (greqs->gsr_group.ss_family != AF_INET ||
+	    greqs->gsr_source.ss_family != AF_INET)
+		return -EADDRNOTAVAIL;
+
+	psin = (struct sockaddr_in *)&greqs->gsr_group;
+	mreqs.imr_multiaddr = psin->sin_addr.s_addr;
+	psin = (struct sockaddr_in *)&greqs->gsr_source;
+	mreqs.imr_sourceaddr = psin->sin_addr.s_addr;
+	mreqs.imr_interface = 0; /* use index for mc_source */
+
+	if (optname == MCAST_BLOCK_SOURCE) {
+		omode = MCAST_EXCLUDE;
+		add = 1;
+	} else if (optname == MCAST_UNBLOCK_SOURCE) {
+		omode = MCAST_EXCLUDE;
+		add = 0;
+	} else if (optname == MCAST_JOIN_SOURCE_GROUP) {
+		struct ip_mreqn mreq;
+
+		psin = (struct sockaddr_in *)&greqs->gsr_group;
+		mreq.imr_multiaddr = psin->sin_addr;
+		mreq.imr_address.s_addr = 0;
+		mreq.imr_ifindex = greqs->gsr_interface;
+		err = ip_mc_join_group_ssm(sk, &mreq, MCAST_INCLUDE);
+		if (err && err != -EADDRINUSE)
+			return err;
+		greqs->gsr_interface = mreq.imr_ifindex;
+		omode = MCAST_INCLUDE;
+		add = 1;
+	} else /* MCAST_LEAVE_SOURCE_GROUP */ {
+		omode = MCAST_INCLUDE;
+		add = 0;
+	}
+	return ip_mc_source(add, omode, sk, &mreqs, greqs->gsr_interface);
+}
+
 static int do_ip_setsockopt(struct sock *sk, int level,
 			    int optname, char __user *optval, unsigned int optlen)
 {
@@ -1066,9 +1109,6 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	case MCAST_UNBLOCK_SOURCE:
 	{
 		struct group_source_req greqs;
-		struct ip_mreq_source mreqs;
-		struct sockaddr_in *psin;
-		int omode, add;
 
 		if (optlen != sizeof(struct group_source_req))
 			goto e_inval;
@@ -1076,42 +1116,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 			err = -EFAULT;
 			break;
 		}
-		if (greqs.gsr_group.ss_family != AF_INET ||
-		    greqs.gsr_source.ss_family != AF_INET) {
-			err = -EADDRNOTAVAIL;
-			break;
-		}
-		psin = (struct sockaddr_in *)&greqs.gsr_group;
-		mreqs.imr_multiaddr = psin->sin_addr.s_addr;
-		psin = (struct sockaddr_in *)&greqs.gsr_source;
-		mreqs.imr_sourceaddr = psin->sin_addr.s_addr;
-		mreqs.imr_interface = 0; /* use index for mc_source */
-
-		if (optname == MCAST_BLOCK_SOURCE) {
-			omode = MCAST_EXCLUDE;
-			add = 1;
-		} else if (optname == MCAST_UNBLOCK_SOURCE) {
-			omode = MCAST_EXCLUDE;
-			add = 0;
-		} else if (optname == MCAST_JOIN_SOURCE_GROUP) {
-			struct ip_mreqn mreq;
-
-			psin = (struct sockaddr_in *)&greqs.gsr_group;
-			mreq.imr_multiaddr = psin->sin_addr;
-			mreq.imr_address.s_addr = 0;
-			mreq.imr_ifindex = greqs.gsr_interface;
-			err = ip_mc_join_group_ssm(sk, &mreq, MCAST_INCLUDE);
-			if (err && err != -EADDRINUSE)
-				break;
-			greqs.gsr_interface = mreq.imr_ifindex;
-			omode = MCAST_INCLUDE;
-			add = 1;
-		} else /* MCAST_LEAVE_SOURCE_GROUP */ {
-			omode = MCAST_INCLUDE;
-			add = 0;
-		}
-		err = ip_mc_source(add, omode, sk, &mreqs,
-				   greqs.gsr_interface);
+		err = do_mcast_group_source(sk, optname, &greqs);
 		break;
 	}
 	case MCAST_MSFILTER:
-- 
2.11.0

