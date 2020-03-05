Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB9D617A553
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgCEMdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:33:21 -0500
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:52808 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbgCEMdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:33:21 -0500
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id ECB732E14F1;
        Thu,  5 Mar 2020 15:33:16 +0300 (MSK)
Received: from sas1-9998cec34266.qloud-c.yandex.net (sas1-9998cec34266.qloud-c.yandex.net [2a02:6b8:c14:3a0e:0:640:9998:cec3])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id xk85bu7IQH-XGJmwi3t;
        Thu, 05 Mar 2020 15:33:16 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1583411596; bh=Wg/Jc9VYYscMJJDmNA87qoan8ux9b8e0VMqhRlX6g0I=;
        h=Message-ID:Subject:To:From:Date:Cc;
        b=B5U5JjSzwwxGmffixRFAS6zSJu57uPu13heeaI4fCzoEM2eHz+MdxwrzJL9NxBePF
         2CB1PEKuqhcI7UfLN21AHMxNcuWrk3AO6prwzJX6Xp7tJtXWoFdphAjNiIDkIgtYKD
         lvXYcZmxuwkTb6RKxB8BSHHZOqVlnc/P7YANRQ60=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:dd96:4e43:5407:4249])
        by sas1-9998cec34266.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id Gp4sEeNVOO-XGWaK4UP;
        Thu, 05 Mar 2020 15:33:16 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Thu, 5 Mar 2020 15:33:12 +0300
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru
Subject: [PATCH net] inet_diag: return classid for all socket types
Message-ID: <20200305123312.GA77699@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 1ec17dbd90f8 ("inet_diag: fix reporting cgroup classid and
fallback to priority") croup classid reporting was fixed. But this works
only for TCP sockets because for other socket types icsk parameter can
be NULL and classid code path is skipped. This change moves classid
handling to inet_diag_msg_attrs_fill() function.

Also inet_diag_msg_attrs_size() helper was added and addends in
nlmsg_new() were reordered to save order from inet_sk_diag_fill().

Fixes: 1ec17dbd90f8 ("inet_diag: fix reporting cgroup classid and fallback to priority")
Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 include/linux/inet_diag.h | 18 ++++++++++++------
 net/ipv4/inet_diag.c      | 44 ++++++++++++++++++++------------------------
 net/ipv4/raw_diag.c       |  5 +++--
 net/ipv4/udp_diag.c       |  5 +++--
 net/sctp/diag.c           |  8 ++------
 5 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index 39faaaf..c91cf2d 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -2,15 +2,10 @@
 #ifndef _INET_DIAG_H_
 #define _INET_DIAG_H_ 1
 
+#include <net/netlink.h>
 #include <uapi/linux/inet_diag.h>
 
-struct net;
-struct sock;
 struct inet_hashinfo;
-struct nlattr;
-struct nlmsghdr;
-struct sk_buff;
-struct netlink_callback;
 
 struct inet_diag_handler {
 	void		(*dump)(struct sk_buff *skb,
@@ -62,6 +57,17 @@ int inet_diag_bc_sk(const struct nlattr *_bc, struct sock *sk);
 
 void inet_diag_msg_common_fill(struct inet_diag_msg *r, struct sock *sk);
 
+static inline size_t inet_diag_msg_attrs_size(void)
+{
+	return	  nla_total_size(1)  /* INET_DIAG_SHUTDOWN */
+		+ nla_total_size(1)  /* INET_DIAG_TOS */
+#if IS_ENABLED(CONFIG_IPV6)
+		+ nla_total_size(1)  /* INET_DIAG_TCLASS */
+		+ nla_total_size(1)  /* INET_DIAG_SKV6ONLY */
+#endif
+		+ nla_total_size(4)  /* INET_DIAG_MARK */
+		+ nla_total_size(4); /* INET_DIAG_CLASS_ID */
+}
 int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 			     struct inet_diag_msg *r, int ext,
 			     struct user_namespace *user_ns, bool net_admin);
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index f11e997..8c83775 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -100,13 +100,9 @@ static size_t inet_sk_attr_size(struct sock *sk,
 		aux = handler->idiag_get_aux_size(sk, net_admin);
 
 	return	  nla_total_size(sizeof(struct tcp_info))
-		+ nla_total_size(1) /* INET_DIAG_SHUTDOWN */
-		+ nla_total_size(1) /* INET_DIAG_TOS */
-		+ nla_total_size(1) /* INET_DIAG_TCLASS */
-		+ nla_total_size(4) /* INET_DIAG_MARK */
-		+ nla_total_size(4) /* INET_DIAG_CLASS_ID */
-		+ nla_total_size(sizeof(struct inet_diag_meminfo))
 		+ nla_total_size(sizeof(struct inet_diag_msg))
+		+ inet_diag_msg_attrs_size()
+		+ nla_total_size(sizeof(struct inet_diag_meminfo))
 		+ nla_total_size(SK_MEMINFO_VARS * sizeof(u32))
 		+ nla_total_size(TCP_CA_NAME_MAX)
 		+ nla_total_size(sizeof(struct tcpvegas_info))
@@ -147,6 +143,24 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 	if (net_admin && nla_put_u32(skb, INET_DIAG_MARK, sk->sk_mark))
 		goto errout;
 
+	if (ext & (1 << (INET_DIAG_CLASS_ID - 1)) ||
+	    ext & (1 << (INET_DIAG_TCLASS - 1))) {
+		u32 classid = 0;
+
+#ifdef CONFIG_SOCK_CGROUP_DATA
+		classid = sock_cgroup_classid(&sk->sk_cgrp_data);
+#endif
+		/* Fallback to socket priority if class id isn't set.
+		 * Classful qdiscs use it as direct reference to class.
+		 * For cgroup2 classid is always zero.
+		 */
+		if (!classid)
+			classid = sk->sk_priority;
+
+		if (nla_put_u32(skb, INET_DIAG_CLASS_ID, classid))
+			goto errout;
+	}
+
 	r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
 	r->idiag_inode = sock_i_ino(sk);
 
@@ -284,24 +298,6 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 			goto errout;
 	}
 
-	if (ext & (1 << (INET_DIAG_CLASS_ID - 1)) ||
-	    ext & (1 << (INET_DIAG_TCLASS - 1))) {
-		u32 classid = 0;
-
-#ifdef CONFIG_SOCK_CGROUP_DATA
-		classid = sock_cgroup_classid(&sk->sk_cgrp_data);
-#endif
-		/* Fallback to socket priority if class id isn't set.
-		 * Classful qdiscs use it as direct reference to class.
-		 * For cgroup2 classid is always zero.
-		 */
-		if (!classid)
-			classid = sk->sk_priority;
-
-		if (nla_put_u32(skb, INET_DIAG_CLASS_ID, classid))
-			goto errout;
-	}
-
 out:
 	nlmsg_end(skb, nlh);
 	return 0;
diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index e35736b..a93e7d1 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -100,8 +100,9 @@ static int raw_diag_dump_one(struct sk_buff *in_skb,
 	if (IS_ERR(sk))
 		return PTR_ERR(sk);
 
-	rep = nlmsg_new(sizeof(struct inet_diag_msg) +
-			sizeof(struct inet_diag_meminfo) + 64,
+	rep = nlmsg_new(nla_total_size(sizeof(struct inet_diag_msg)) +
+			inet_diag_msg_attrs_size() +
+			nla_total_size(sizeof(struct inet_diag_meminfo)) + 64,
 			GFP_KERNEL);
 	if (!rep) {
 		sock_put(sk);
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index 910555a..dccd2286 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -64,8 +64,9 @@ static int udp_dump_one(struct udp_table *tbl, struct sk_buff *in_skb,
 		goto out;
 
 	err = -ENOMEM;
-	rep = nlmsg_new(sizeof(struct inet_diag_msg) +
-			sizeof(struct inet_diag_meminfo) + 64,
+	rep = nlmsg_new(nla_total_size(sizeof(struct inet_diag_msg)) +
+			inet_diag_msg_attrs_size() +
+			nla_total_size(sizeof(struct inet_diag_meminfo)) + 64,
 			GFP_KERNEL);
 	if (!rep)
 		goto out;
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 8a15146..1069d7a 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -237,15 +237,11 @@ static size_t inet_assoc_attr_size(struct sctp_association *asoc)
 		addrcnt++;
 
 	return	  nla_total_size(sizeof(struct sctp_info))
-		+ nla_total_size(1) /* INET_DIAG_SHUTDOWN */
-		+ nla_total_size(1) /* INET_DIAG_TOS */
-		+ nla_total_size(1) /* INET_DIAG_TCLASS */
-		+ nla_total_size(4) /* INET_DIAG_MARK */
-		+ nla_total_size(4) /* INET_DIAG_CLASS_ID */
 		+ nla_total_size(addrlen * asoc->peer.transport_count)
 		+ nla_total_size(addrlen * addrcnt)
-		+ nla_total_size(sizeof(struct inet_diag_meminfo))
 		+ nla_total_size(sizeof(struct inet_diag_msg))
+		+ inet_diag_msg_attrs_size()
+		+ nla_total_size(sizeof(struct inet_diag_meminfo))
 		+ 64;
 }
 
-- 
2.7.4

