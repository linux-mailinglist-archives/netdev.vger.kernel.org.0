Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4D7A34EE
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 12:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbfH3K0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 06:26:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfH3K0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 06:26:00 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 81BEA308AA11;
        Fri, 30 Aug 2019 10:26:00 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C711419C58;
        Fri, 30 Aug 2019 10:25:58 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     borisp@mellanox.com, jakub.kicinski@netronome.com,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     aviadye@mellanox.com, davejwatson@fb.com, davem@davemloft.net,
        john.fastabend@gmail.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v3 2/3] tcp: ulp: add functions to dump ulp-specific information
Date:   Fri, 30 Aug 2019 12:25:48 +0200
Message-Id: <ba511c4b1e110c36e280825f2b5ed21977b3c6c7.1567158431.git.dcaratti@redhat.com>
In-Reply-To: <cover.1567158431.git.dcaratti@redhat.com>
References: <cover.1567158431.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 30 Aug 2019 10:26:00 +0000 (UTC)
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
 include/net/tcp.h              |  3 ++
 include/uapi/linux/inet_diag.h |  8 ++++++
 net/ipv4/tcp_diag.c            | 52 +++++++++++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 77fe87f7a992..c9a3f9688223 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2122,6 +2122,9 @@ struct tcp_ulp_ops {
 	void (*update)(struct sock *sk, struct proto *p);
 	/* cleanup ulp */
 	void (*release)(struct sock *sk);
+	/* diagnostic */
+	int (*get_info)(const struct sock *sk, struct sk_buff *skb);
+	size_t (*get_info_size)(const struct sock *sk);
 
 	char		name[TCP_ULP_NAME_MAX];
 	struct module	*owner;
diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index e8baca85bac6..e2c6273274f3 100644
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
+	INET_ULP_INFO_UNSPEC,
+	INET_ULP_INFO_NAME,
+	__INET_ULP_INFO_MAX,
+};
+#define INET_ULP_INFO_MAX (__INET_ULP_INFO_MAX - 1)
+
 /* INET_DIAG_MEM */
 
 struct inet_diag_meminfo {
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index a3a386236d93..babc156deabb 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -81,13 +81,42 @@ static int tcp_diag_put_md5sig(struct sk_buff *skb,
 }
 #endif
 
+static int tcp_diag_put_ulp(struct sk_buff *skb, struct sock *sk,
+			    const struct tcp_ulp_ops *ulp_ops)
+{
+	struct nlattr *nest;
+	int err;
+
+	nest = nla_nest_start_noflag(skb, INET_DIAG_ULP_INFO);
+	if (!nest)
+		return -EMSGSIZE;
+
+	err = nla_put_string(skb, INET_ULP_INFO_NAME, ulp_ops->name);
+	if (err)
+		goto nla_failure;
+
+	if (ulp_ops->get_info)
+		err = ulp_ops->get_info(sk, skb);
+	if (err)
+		goto nla_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_failure:
+	nla_nest_cancel(skb, nest);
+	return err;
+}
+
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
@@ -99,11 +128,21 @@ static int tcp_diag_get_aux(struct sock *sk, bool net_admin,
 	}
 #endif
 
+	if (net_admin) {
+		const struct tcp_ulp_ops *ulp_ops;
+
+		ulp_ops = icsk->icsk_ulp_ops;
+		if (ulp_ops)
+			err = tcp_diag_put_ulp(skb, sk, ulp_ops);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
 static size_t tcp_diag_get_aux_size(struct sock *sk, bool net_admin)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	size_t size = 0;
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -124,6 +163,17 @@ static size_t tcp_diag_get_aux_size(struct sock *sk, bool net_admin)
 	}
 #endif
 
+	if (net_admin) {
+		const struct tcp_ulp_ops *ulp_ops;
+
+		ulp_ops = icsk->icsk_ulp_ops;
+		if (ulp_ops) {
+			size += nla_total_size(0) +
+				nla_total_size(TCP_ULP_NAME_MAX);
+			if (ulp_ops->get_info_size)
+				size += ulp_ops->get_info_size(sk);
+		}
+	}
 	return size;
 }
 
-- 
2.20.1

