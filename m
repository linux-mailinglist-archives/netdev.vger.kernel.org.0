Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91F1D3606E
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbfFEPkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:40:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728200AbfFEPkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 11:40:08 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC70F3082132;
        Wed,  5 Jun 2019 15:39:58 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63A1737DE;
        Wed,  5 Jun 2019 15:39:55 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 1/2] tcp: ulp: add functions to dump ulp-specific information
Date:   Wed,  5 Jun 2019 17:39:22 +0200
Message-Id: <a1feba1a1c03a331047d3a7a3a7acefdbee51735.1559747691.git.dcaratti@redhat.com>
In-Reply-To: <cover.1559747691.git.dcaratti@redhat.com>
References: <cover.1559747691.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 05 Jun 2019 15:40:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

currently, only getsockopt(TCP_ULP) can be invoked to know if a ULP is on
top of a TCP socket. Extend idiag_get_aux() and idiag_get_aux_size(),
introduced by commit b37e88407c1d ("inet_diag: allow protocols to provide
additional data"), to report the ULP name and other information that can
be made available by the ULP through optional functions.

Users having CAP_NET_ADMIN privileges will then be able to retrieve this
information through inet_diag_handler, if they specify INET_DIAG_INFO in
the request.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/net/tcp.h              |  3 +++
 include/uapi/linux/inet_diag.h |  8 ++++++++
 net/ipv4/tcp_diag.c            | 34 ++++++++++++++++++++++++++++++++--
 3 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 0083a14fb64f..94431562c4b4 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2108,6 +2108,9 @@ struct tcp_ulp_ops {
 	int (*init)(struct sock *sk);
 	/* cleanup ulp */
 	void (*release)(struct sock *sk);
+	/* diagnostic */
+	int (*get_info)(struct sock *sk, struct sk_buff *skb);
+	size_t (*get_info_size)(struct sock *sk);
 
 	char		name[TCP_ULP_NAME_MAX];
 	struct module	*owner;
diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index e8baca85bac6..844133de3212 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -153,11 +153,19 @@ enum {
 	INET_DIAG_BBRINFO,	/* request as INET_DIAG_VEGASINFO */
 	INET_DIAG_CLASS_ID,	/* request as INET_DIAG_TCLASS */
 	INET_DIAG_MD5SIG,
+	INET_DIAG_ULP_INFO,
 	__INET_DIAG_MAX,
 };
 
 #define INET_DIAG_MAX (__INET_DIAG_MAX - 1)
 
+enum {
+	ULP_INFO_NAME,
+	__ULP_INFO_MAX,
+};
+
+#define ULP_INFO_MAX (__ULP_INFO_MAX - 1)
+
 /* INET_DIAG_MEM */
 
 struct inet_diag_meminfo {
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index 81148f7a2323..de2e9e75b8e0 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -88,10 +88,12 @@ static int tcp_diag_put_md5sig(struct sk_buff *skb,
 static int tcp_diag_get_aux(struct sock *sk, bool net_admin,
 			    struct sk_buff *skb)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	int err = 0;
+
 #ifdef CONFIG_TCP_MD5SIG
 	if (net_admin) {
 		struct tcp_md5sig_info *md5sig;
-		int err = 0;
 
 		rcu_read_lock();
 		md5sig = rcu_dereference(tcp_sk(sk)->md5sig_info);
@@ -103,11 +105,33 @@ static int tcp_diag_get_aux(struct sock *sk, bool net_admin,
 	}
 #endif
 
-	return 0;
+	if (net_admin && icsk->icsk_ulp_ops) {
+		struct nlattr *nest;
+
+		nest = nla_nest_start_noflag(skb, INET_DIAG_ULP_INFO);
+		if (!nest) {
+			err = -EMSGSIZE;
+			goto nla_failure;
+		}
+		err = nla_put_string(skb, ULP_INFO_NAME,
+				     icsk->icsk_ulp_ops->name);
+		if (err < 0)
+			goto nla_failure;
+		if (icsk->icsk_ulp_ops->get_info)
+			err = icsk->icsk_ulp_ops->get_info(sk, skb);
+		if (err < 0) {
+nla_failure:
+			nla_nest_cancel(skb, nest);
+			return err;
+		}
+		nla_nest_end(skb, nest);
+	}
+	return err;
 }
 
 static size_t tcp_diag_get_aux_size(struct sock *sk, bool net_admin)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	size_t size = 0;
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -128,6 +152,12 @@ static size_t tcp_diag_get_aux_size(struct sock *sk, bool net_admin)
 	}
 #endif
 
+	if (net_admin && icsk->icsk_ulp_ops) {
+		size +=   nla_total_size(0) /* INET_DIAG_ULP_INFO */
+			+ nla_total_size(TCP_ULP_NAME_MAX); /* ULP_INFO_NAME */
+		if (icsk->icsk_ulp_ops->get_info_size)
+			size += icsk->icsk_ulp_ops->get_info_size(sk);
+	}
 	return size;
 }
 
-- 
2.20.1

