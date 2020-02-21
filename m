Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7086F1686EA
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgBUSrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:47:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15848 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729397AbgBUSrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:47:03 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01LIkQGd030705
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 10:47:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=tHLmuo1nKhBZJQEWaj3itY8Y3i5b4suR1FdYhrWsiUk=;
 b=nz+nOxFPsZfdML23bxtMSBa9JLrAO+WHrDh2TyXsyFGo1IZx4g6PrnM9LSDRXmjjkxJQ
 9OiDtUxP6gbHcfW6QZSY2DdVLCc4GjZNaHMYG5yNjg5+wHxw4MigIYk5YZxI+FBl4Wq8
 zSkXpxzJ1Pvk0g1fOd8eDFx7SZUJuZxA82w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yag5u1hyp-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 10:47:01 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 21 Feb 2020 10:46:58 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id E4C7629406D6; Fri, 21 Feb 2020 10:46:56 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/4] inet_diag: Refactor inet_sk_diag_fill(), dump(), and dump_one()
Date:   Fri, 21 Feb 2020 10:46:56 -0800
Message-ID: <20200221184656.22723-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200221184650.21920-1-kafai@fb.com>
References: <20200221184650.21920-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-21_06:2020-02-21,2020-02-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 spamscore=0 mlxlogscore=422 phishscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=38
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a latter patch, there is a need to update "cb->min_dump_alloc"
in inet_sk_diag_fill() as it learns the diffierent bpf_sk_storages
stored in a sk while dumping all sk(s) (e.g. tcp_hashinfo).

The inet_sk_diag_fill() currently does not take the "cb" as an argument.
One of the reason is inet_sk_diag_fill() is used by both dump_one()
and dump() (which belong to the "struct inet_diag_handler".  The dump_one()
interface does not pass the "cb" along.

This patch is to make dump_one() pass a "cb".  The "cb" is created in
inet_diag_cmd_exact().  The "nlh" and "in_skb" are stored in "cb" as
the dump() interface does.  The total number of args in
inet_sk_diag_fill() is also cut from 10 to 7 and
that helps many callers to pass fewer args.

In particular,
"struct user_namespace *user_ns", "u32 pid", and "u32 seq"
can be replaced by accessing "cb->nlh" and "cb->skb".

A similar argument reduction is also made to
inet_twsk_diag_fill() and inet_req_diag_fill().

inet_csk_diag_dump() and inet_csk_diag_fill() are also removed.
They are mostly equivalent to inet_sk_diag_fill().  Their repeated
usages are very limited.  Thus, inet_sk_diag_fill() is directly used
in those occasions.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/inet_diag.h |  12 ++--
 net/dccp/diag.c           |   5 +-
 net/ipv4/inet_diag.c      | 116 +++++++++++++++-----------------------
 net/ipv4/raw_diag.c       |  18 ++----
 net/ipv4/tcp_diag.c       |   4 +-
 net/ipv4/udp_diag.c       |  26 ++++-----
 net/sctp/diag.c           |   5 +-
 7 files changed, 73 insertions(+), 113 deletions(-)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index 39faaaf843e1..6b157ce07d74 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -18,8 +18,7 @@ struct inet_diag_handler {
 				const struct inet_diag_req_v2 *r,
 				struct nlattr *bc);
 
-	int		(*dump_one)(struct sk_buff *in_skb,
-				    const struct nlmsghdr *nlh,
+	int		(*dump_one)(struct netlink_callback *cb,
 				    const struct inet_diag_req_v2 *req);
 
 	void		(*idiag_get_info)(struct sock *sk,
@@ -42,16 +41,15 @@ struct inet_diag_handler {
 
 struct inet_connection_sock;
 int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
-		      struct sk_buff *skb, const struct inet_diag_req_v2 *req,
-		      struct user_namespace *user_ns,
-		      u32 pid, u32 seq, u16 nlmsg_flags,
-		      const struct nlmsghdr *unlh, bool net_admin);
+		      struct sk_buff *skb, struct netlink_callback *cb,
+		      const struct inet_diag_req_v2 *req,
+		      u16 nlmsg_flags, bool net_admin);
 void inet_diag_dump_icsk(struct inet_hashinfo *h, struct sk_buff *skb,
 			 struct netlink_callback *cb,
 			 const struct inet_diag_req_v2 *r,
 			 struct nlattr *bc);
 int inet_diag_dump_one_icsk(struct inet_hashinfo *hashinfo,
-			    struct sk_buff *in_skb, const struct nlmsghdr *nlh,
+			    struct netlink_callback *cb,
 			    const struct inet_diag_req_v2 *req);
 
 struct sock *inet_diag_find_one_icsk(struct net *net,
diff --git a/net/dccp/diag.c b/net/dccp/diag.c
index 73ef73a218ff..8f1e2a653f6d 100644
--- a/net/dccp/diag.c
+++ b/net/dccp/diag.c
@@ -51,11 +51,10 @@ static void dccp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	inet_diag_dump_icsk(&dccp_hashinfo, skb, cb, r, bc);
 }
 
-static int dccp_diag_dump_one(struct sk_buff *in_skb,
-			      const struct nlmsghdr *nlh,
+static int dccp_diag_dump_one(struct netlink_callback *cb,
 			      const struct inet_diag_req_v2 *req)
 {
-	return inet_diag_dump_one_icsk(&dccp_hashinfo, in_skb, nlh, req);
+	return inet_diag_dump_one_icsk(&dccp_hashinfo, cb, req);
 }
 
 static const struct inet_diag_handler dccp_diag_handler = {
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index f11e997e517b..d2ecff3195ba 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -157,11 +157,9 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(inet_diag_msg_attrs_fill);
 
 int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
-		      struct sk_buff *skb, const struct inet_diag_req_v2 *req,
-		      struct user_namespace *user_ns,
-		      u32 portid, u32 seq, u16 nlmsg_flags,
-		      const struct nlmsghdr *unlh,
-		      bool net_admin)
+		      struct sk_buff *skb, struct netlink_callback *cb,
+		      const struct inet_diag_req_v2 *req,
+		      u16 nlmsg_flags, bool net_admin)
 {
 	const struct tcp_congestion_ops *ca_ops;
 	const struct inet_diag_handler *handler;
@@ -174,8 +172,8 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 	handler = inet_diag_table[req->sdiag_protocol];
 	BUG_ON(!handler);
 
-	nlh = nlmsg_put(skb, portid, seq, unlh->nlmsg_type, sizeof(*r),
-			nlmsg_flags);
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			cb->nlh->nlmsg_type, sizeof(*r), nlmsg_flags);
 	if (!nlh)
 		return -EMSGSIZE;
 
@@ -187,7 +185,9 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 	r->idiag_timer = 0;
 	r->idiag_retrans = 0;
 
-	if (inet_diag_msg_attrs_fill(sk, skb, r, ext, user_ns, net_admin))
+	if (inet_diag_msg_attrs_fill(sk, skb, r, ext,
+				     sk_user_ns(NETLINK_CB(cb->skb).sk),
+				     net_admin))
 		goto errout;
 
 	if (ext & (1 << (INET_DIAG_MEMINFO - 1))) {
@@ -312,30 +312,19 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 }
 EXPORT_SYMBOL_GPL(inet_sk_diag_fill);
 
-static int inet_csk_diag_fill(struct sock *sk,
-			      struct sk_buff *skb,
-			      const struct inet_diag_req_v2 *req,
-			      struct user_namespace *user_ns,
-			      u32 portid, u32 seq, u16 nlmsg_flags,
-			      const struct nlmsghdr *unlh,
-			      bool net_admin)
-{
-	return inet_sk_diag_fill(sk, inet_csk(sk), skb, req, user_ns,
-				 portid, seq, nlmsg_flags, unlh, net_admin);
-}
-
 static int inet_twsk_diag_fill(struct sock *sk,
 			       struct sk_buff *skb,
-			       u32 portid, u32 seq, u16 nlmsg_flags,
-			       const struct nlmsghdr *unlh)
+			       struct netlink_callback *cb,
+			       u16 nlmsg_flags)
 {
 	struct inet_timewait_sock *tw = inet_twsk(sk);
 	struct inet_diag_msg *r;
 	struct nlmsghdr *nlh;
 	long tmo;
 
-	nlh = nlmsg_put(skb, portid, seq, unlh->nlmsg_type, sizeof(*r),
-			nlmsg_flags);
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+			cb->nlh->nlmsg_seq, cb->nlh->nlmsg_type,
+			sizeof(*r), nlmsg_flags);
 	if (!nlh)
 		return -EMSGSIZE;
 
@@ -359,16 +348,16 @@ static int inet_twsk_diag_fill(struct sock *sk,
 }
 
 static int inet_req_diag_fill(struct sock *sk, struct sk_buff *skb,
-			      u32 portid, u32 seq, u16 nlmsg_flags,
-			      const struct nlmsghdr *unlh, bool net_admin)
+			      struct netlink_callback *cb,
+			      u16 nlmsg_flags, bool net_admin)
 {
 	struct request_sock *reqsk = inet_reqsk(sk);
 	struct inet_diag_msg *r;
 	struct nlmsghdr *nlh;
 	long tmo;
 
-	nlh = nlmsg_put(skb, portid, seq, unlh->nlmsg_type, sizeof(*r),
-			nlmsg_flags);
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			cb->nlh->nlmsg_type, sizeof(*r), nlmsg_flags);
 	if (!nlh)
 		return -EMSGSIZE;
 
@@ -397,21 +386,18 @@ static int inet_req_diag_fill(struct sock *sk, struct sk_buff *skb,
 }
 
 static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
+			struct netlink_callback *cb,
 			const struct inet_diag_req_v2 *r,
-			struct user_namespace *user_ns,
-			u32 portid, u32 seq, u16 nlmsg_flags,
-			const struct nlmsghdr *unlh, bool net_admin)
+			u16 nlmsg_flags, bool net_admin)
 {
 	if (sk->sk_state == TCP_TIME_WAIT)
-		return inet_twsk_diag_fill(sk, skb, portid, seq,
-					   nlmsg_flags, unlh);
+		return inet_twsk_diag_fill(sk, skb, cb, nlmsg_flags);
 
 	if (sk->sk_state == TCP_NEW_SYN_RECV)
-		return inet_req_diag_fill(sk, skb, portid, seq,
-					  nlmsg_flags, unlh, net_admin);
+		return inet_req_diag_fill(sk, skb, cb, nlmsg_flags, net_admin);
 
-	return inet_csk_diag_fill(sk, skb, r, user_ns, portid, seq,
-				  nlmsg_flags, unlh, net_admin);
+	return inet_sk_diag_fill(sk, inet_csk(sk), skb, cb, r, nlmsg_flags,
+				 net_admin);
 }
 
 struct sock *inet_diag_find_one_icsk(struct net *net,
@@ -459,10 +445,10 @@ struct sock *inet_diag_find_one_icsk(struct net *net,
 EXPORT_SYMBOL_GPL(inet_diag_find_one_icsk);
 
 int inet_diag_dump_one_icsk(struct inet_hashinfo *hashinfo,
-			    struct sk_buff *in_skb,
-			    const struct nlmsghdr *nlh,
+			    struct netlink_callback *cb,
 			    const struct inet_diag_req_v2 *req)
 {
+	struct sk_buff *in_skb = cb->skb;
 	bool net_admin = netlink_net_capable(in_skb, CAP_NET_ADMIN);
 	struct net *net = sock_net(in_skb->sk);
 	struct sk_buff *rep;
@@ -479,10 +465,7 @@ int inet_diag_dump_one_icsk(struct inet_hashinfo *hashinfo,
 		goto out;
 	}
 
-	err = sk_diag_fill(sk, rep, req,
-			   sk_user_ns(NETLINK_CB(in_skb).sk),
-			   NETLINK_CB(in_skb).portid,
-			   nlh->nlmsg_seq, 0, nlh, net_admin);
+	err = sk_diag_fill(sk, rep, cb, req, 0, net_admin);
 	if (err < 0) {
 		WARN_ON(err == -EMSGSIZE);
 		nlmsg_free(rep);
@@ -509,14 +492,19 @@ static int inet_diag_cmd_exact(int cmd, struct sk_buff *in_skb,
 	int err;
 
 	handler = inet_diag_lock_handler(req->sdiag_protocol);
-	if (IS_ERR(handler))
+	if (IS_ERR(handler)) {
 		err = PTR_ERR(handler);
-	else if (cmd == SOCK_DIAG_BY_FAMILY)
-		err = handler->dump_one(in_skb, nlh, req);
-	else if (cmd == SOCK_DESTROY && handler->destroy)
+	} else if (cmd == SOCK_DIAG_BY_FAMILY) {
+		struct netlink_callback cb = {
+			.nlh = nlh,
+			.skb = in_skb,
+		};
+		err = handler->dump_one(&cb, req);
+	} else if (cmd == SOCK_DESTROY && handler->destroy) {
 		err = handler->destroy(in_skb, req);
-	else
+	} else {
 		err = -EOPNOTSUPP;
+	}
 	inet_diag_unlock_handler(handler);
 
 	return err;
@@ -847,23 +835,6 @@ static int inet_diag_bc_audit(const struct nlattr *attr,
 	return len == 0 ? 0 : -EINVAL;
 }
 
-static int inet_csk_diag_dump(struct sock *sk,
-			      struct sk_buff *skb,
-			      struct netlink_callback *cb,
-			      const struct inet_diag_req_v2 *r,
-			      const struct nlattr *bc,
-			      bool net_admin)
-{
-	if (!inet_diag_bc_sk(bc, sk))
-		return 0;
-
-	return inet_csk_diag_fill(sk, skb, r,
-				  sk_user_ns(NETLINK_CB(cb->skb).sk),
-				  NETLINK_CB(cb->skb).portid,
-				  cb->nlh->nlmsg_seq, NLM_F_MULTI, cb->nlh,
-				  net_admin);
-}
-
 static void twsk_build_assert(void)
 {
 	BUILD_BUG_ON(offsetof(struct inet_timewait_sock, tw_family) !=
@@ -935,8 +906,12 @@ void inet_diag_dump_icsk(struct inet_hashinfo *hashinfo, struct sk_buff *skb,
 				    r->id.idiag_sport)
 					goto next_listen;
 
-				if (inet_csk_diag_dump(sk, skb, cb, r,
-						       bc, net_admin) < 0) {
+				if (!inet_diag_bc_sk(bc, sk))
+					goto next_listen;
+
+				if (inet_sk_diag_fill(sk, inet_csk(sk), skb,
+						      cb, r, NLM_F_MULTI,
+						      net_admin) < 0) {
 					spin_unlock(&ilb->lock);
 					goto done;
 				}
@@ -1014,11 +989,8 @@ void inet_diag_dump_icsk(struct inet_hashinfo *hashinfo, struct sk_buff *skb,
 		res = 0;
 		for (idx = 0; idx < accum; idx++) {
 			if (res >= 0) {
-				res = sk_diag_fill(sk_arr[idx], skb, r,
-					   sk_user_ns(NETLINK_CB(cb->skb).sk),
-					   NETLINK_CB(cb->skb).portid,
-					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					   cb->nlh, net_admin);
+				res = sk_diag_fill(sk_arr[idx], skb, cb, r,
+						   NLM_F_MULTI, net_admin);
 				if (res < 0)
 					num = num_arr[idx];
 			}
diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index e35736b99300..a2933eeabd91 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -87,15 +87,16 @@ static struct sock *raw_sock_get(struct net *net, const struct inet_diag_req_v2
 	return sk ? sk : ERR_PTR(-ENOENT);
 }
 
-static int raw_diag_dump_one(struct sk_buff *in_skb,
-			     const struct nlmsghdr *nlh,
+static int raw_diag_dump_one(struct netlink_callback *cb,
 			     const struct inet_diag_req_v2 *r)
 {
-	struct net *net = sock_net(in_skb->sk);
+	struct sk_buff *in_skb = cb->skb;
 	struct sk_buff *rep;
 	struct sock *sk;
+	struct net *net;
 	int err;
 
+	net = sock_net(in_skb->sk);
 	sk = raw_sock_get(net, r);
 	if (IS_ERR(sk))
 		return PTR_ERR(sk);
@@ -108,10 +109,7 @@ static int raw_diag_dump_one(struct sk_buff *in_skb,
 		return -ENOMEM;
 	}
 
-	err = inet_sk_diag_fill(sk, NULL, rep, r,
-				sk_user_ns(NETLINK_CB(in_skb).sk),
-				NETLINK_CB(in_skb).portid,
-				nlh->nlmsg_seq, 0, nlh,
+	err = inet_sk_diag_fill(sk, NULL, rep, cb, r, 0,
 				netlink_net_capable(in_skb, CAP_NET_ADMIN));
 	sock_put(sk);
 
@@ -136,11 +134,7 @@ static int sk_diag_dump(struct sock *sk, struct sk_buff *skb,
 	if (!inet_diag_bc_sk(bc, sk))
 		return 0;
 
-	return inet_sk_diag_fill(sk, NULL, skb, r,
-				 sk_user_ns(NETLINK_CB(cb->skb).sk),
-				 NETLINK_CB(cb->skb).portid,
-				 cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				 cb->nlh, net_admin);
+	return inet_sk_diag_fill(sk, NULL, skb, cb, r, NLM_F_MULTI, net_admin);
 }
 
 static void raw_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index 0d08f9e2d8d0..bcd3a26efff1 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -184,10 +184,10 @@ static void tcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	inet_diag_dump_icsk(&tcp_hashinfo, skb, cb, r, bc);
 }
 
-static int tcp_diag_dump_one(struct sk_buff *in_skb, const struct nlmsghdr *nlh,
+static int tcp_diag_dump_one(struct netlink_callback *cb,
 			     const struct inet_diag_req_v2 *req)
 {
-	return inet_diag_dump_one_icsk(&tcp_hashinfo, in_skb, nlh, req);
+	return inet_diag_dump_one_icsk(&tcp_hashinfo, cb, req);
 }
 
 #ifdef CONFIG_INET_DIAG_DESTROY
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index 910555a4d9fe..7d65a6a5cd51 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -21,16 +21,15 @@ static int sk_diag_dump(struct sock *sk, struct sk_buff *skb,
 	if (!inet_diag_bc_sk(bc, sk))
 		return 0;
 
-	return inet_sk_diag_fill(sk, NULL, skb, req,
-			sk_user_ns(NETLINK_CB(cb->skb).sk),
-			NETLINK_CB(cb->skb).portid,
-			cb->nlh->nlmsg_seq, NLM_F_MULTI, cb->nlh, net_admin);
+	return inet_sk_diag_fill(sk, NULL, skb, cb, req, NLM_F_MULTI,
+				 net_admin);
 }
 
-static int udp_dump_one(struct udp_table *tbl, struct sk_buff *in_skb,
-			const struct nlmsghdr *nlh,
+static int udp_dump_one(struct udp_table *tbl,
+			struct netlink_callback *cb,
 			const struct inet_diag_req_v2 *req)
 {
+	struct sk_buff *in_skb = cb->skb;
 	int err = -EINVAL;
 	struct sock *sk = NULL;
 	struct sk_buff *rep;
@@ -70,11 +69,8 @@ static int udp_dump_one(struct udp_table *tbl, struct sk_buff *in_skb,
 	if (!rep)
 		goto out;
 
-	err = inet_sk_diag_fill(sk, NULL, rep, req,
-			   sk_user_ns(NETLINK_CB(in_skb).sk),
-			   NETLINK_CB(in_skb).portid,
-			   nlh->nlmsg_seq, 0, nlh,
-			   netlink_net_capable(in_skb, CAP_NET_ADMIN));
+	err = inet_sk_diag_fill(sk, NULL, rep, cb, req, 0,
+				netlink_net_capable(in_skb, CAP_NET_ADMIN));
 	if (err < 0) {
 		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(rep);
@@ -151,10 +147,10 @@ static void udp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	udp_dump(&udp_table, skb, cb, r, bc);
 }
 
-static int udp_diag_dump_one(struct sk_buff *in_skb, const struct nlmsghdr *nlh,
+static int udp_diag_dump_one(struct netlink_callback *cb,
 			     const struct inet_diag_req_v2 *req)
 {
-	return udp_dump_one(&udp_table, in_skb, nlh, req);
+	return udp_dump_one(&udp_table, cb, req);
 }
 
 static void udp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
@@ -255,10 +251,10 @@ static void udplite_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	udp_dump(&udplite_table, skb, cb, r, bc);
 }
 
-static int udplite_diag_dump_one(struct sk_buff *in_skb, const struct nlmsghdr *nlh,
+static int udplite_diag_dump_one(struct netlink_callback *cb,
 				 const struct inet_diag_req_v2 *req)
 {
-	return udp_dump_one(&udplite_table, in_skb, nlh, req);
+	return udp_dump_one(&udplite_table, cb, req);
 }
 
 static const struct inet_diag_handler udplite_diag_handler = {
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 8a15146faaeb..bed6436cd0af 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -432,11 +432,12 @@ static void sctp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 		sctp_get_sctp_info(sk, infox->asoc, infox->sctpinfo);
 }
 
-static int sctp_diag_dump_one(struct sk_buff *in_skb,
-			      const struct nlmsghdr *nlh,
+static int sctp_diag_dump_one(struct netlink_callback *cb,
 			      const struct inet_diag_req_v2 *req)
 {
+	struct sk_buff *in_skb = cb->skb;
 	struct net *net = sock_net(in_skb->sk);
+	const struct nlmsghdr *nlh = cb->nlh;
 	union sctp_addr laddr, paddr;
 	struct sctp_comm_param commp = {
 		.skb = in_skb,
-- 
2.17.1

