Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71AF81686EB
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgBUSrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:47:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729397AbgBUSrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:47:08 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01LIkbm3013521
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 10:47:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=y6xHxXrINPtyHszKcYvcqbVpwfXZphLkWrYPRRs9r50=;
 b=OnteiVD/2IZiky9bB7Yh8MKV6+5FN6NMpVDcB9fG8zhZXy+Oq0d4t1il6f+q/wyYxM48
 DXmuYQnoNeajBEtrU0U/DSYT6bWnIWkHL9H+Ton4+VoosoecHp3vV7uaT/l9M9lQYNc5
 Op7kpb7/8pA6T9ApkGqVrv6EgzwsMlZ+3Wc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ya629kru7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 10:47:06 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 21 Feb 2020 10:47:06 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 2EF5529406D6; Fri, 21 Feb 2020 10:47:03 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/4] inet_diag: Move the INET_DIAG_REQ_BYTECODE nlattr to cb->data
Date:   Fri, 21 Feb 2020 10:47:03 -0800
Message-ID: <20200221184703.22967-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200221184650.21920-1-kafai@fb.com>
References: <20200221184650.21920-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-21_06:2020-02-21,2020-02-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 suspectscore=15 adultscore=0 mlxlogscore=999 priorityscore=1501
 phishscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The INET_DIAG_REQ_BYTECODE nlattr is currently re-found every time when
the "dump()" is re-started.

In a latter patch, it will also need to parse the new
INET_DIAG_REQ_SK_BPF_STORAGES nlattr to learn the map_fds. Thus, this
patch takes this chance to store the parsed nlattr in cb->data
during the "start" time of a dump.

By doing this, the "bc" argument also becomes unnecessary
and is removed.  Also, the two copies of the INET_DIAG_REQ_BYTECODE
parsing-audit logic between compat/current version can be
consolidated to one.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/inet_diag.h      |  11 ++--
 include/uapi/linux/inet_diag.h |   3 +-
 net/dccp/diag.c                |   4 +-
 net/ipv4/inet_diag.c           | 117 ++++++++++++++++++++-------------
 net/ipv4/raw_diag.c            |   6 +-
 net/ipv4/tcp_diag.c            |   4 +-
 net/ipv4/udp_diag.c            |  15 +++--
 net/sctp/diag.c                |   2 +-
 8 files changed, 98 insertions(+), 64 deletions(-)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index 6b157ce07d74..1bb94cac265f 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -15,8 +15,7 @@ struct netlink_callback;
 struct inet_diag_handler {
 	void		(*dump)(struct sk_buff *skb,
 				struct netlink_callback *cb,
-				const struct inet_diag_req_v2 *r,
-				struct nlattr *bc);
+				const struct inet_diag_req_v2 *r);
 
 	int		(*dump_one)(struct netlink_callback *cb,
 				    const struct inet_diag_req_v2 *req);
@@ -39,6 +38,11 @@ struct inet_diag_handler {
 	__u16		idiag_info_size;
 };
 
+struct inet_diag_dump_data {
+	struct nlattr *req_nlas[__INET_DIAG_REQ_MAX];
+#define inet_diag_nla_bc req_nlas[INET_DIAG_REQ_BYTECODE]
+};
+
 struct inet_connection_sock;
 int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 		      struct sk_buff *skb, struct netlink_callback *cb,
@@ -46,8 +50,7 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 		      u16 nlmsg_flags, bool net_admin);
 void inet_diag_dump_icsk(struct inet_hashinfo *h, struct sk_buff *skb,
 			 struct netlink_callback *cb,
-			 const struct inet_diag_req_v2 *r,
-			 struct nlattr *bc);
+			 const struct inet_diag_req_v2 *r);
 int inet_diag_dump_one_icsk(struct inet_hashinfo *hashinfo,
 			    struct netlink_callback *cb,
 			    const struct inet_diag_req_v2 *req);
diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index a1ff345b3f33..bab9a9f8da12 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -64,9 +64,10 @@ struct inet_diag_req_raw {
 enum {
 	INET_DIAG_REQ_NONE,
 	INET_DIAG_REQ_BYTECODE,
+	__INET_DIAG_REQ_MAX,
 };
 
-#define INET_DIAG_REQ_MAX INET_DIAG_REQ_BYTECODE
+#define INET_DIAG_REQ_MAX (__INET_DIAG_REQ_MAX - 1)
 
 /* Bytecode is sequence of 4 byte commands followed by variable arguments.
  * All the commands identified by "code" are conditional jumps forward:
diff --git a/net/dccp/diag.c b/net/dccp/diag.c
index 8f1e2a653f6d..8a82c5a2c5a8 100644
--- a/net/dccp/diag.c
+++ b/net/dccp/diag.c
@@ -46,9 +46,9 @@ static void dccp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 }
 
 static void dccp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
-			   const struct inet_diag_req_v2 *r, struct nlattr *bc)
+			   const struct inet_diag_req_v2 *r)
 {
-	inet_diag_dump_icsk(&dccp_hashinfo, skb, cb, r, bc);
+	inet_diag_dump_icsk(&dccp_hashinfo, skb, cb, r);
 }
 
 static int dccp_diag_dump_one(struct netlink_callback *cb,
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index d2ecff3195ba..4bce8a477699 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -495,9 +495,11 @@ static int inet_diag_cmd_exact(int cmd, struct sk_buff *in_skb,
 	if (IS_ERR(handler)) {
 		err = PTR_ERR(handler);
 	} else if (cmd == SOCK_DIAG_BY_FAMILY) {
+		struct inet_diag_dump_data empty_dump_data = {};
 		struct netlink_callback cb = {
 			.nlh = nlh,
 			.skb = in_skb,
+			.data = &empty_dump_data,
 		};
 		err = handler->dump_one(&cb, req);
 	} else if (cmd == SOCK_DESTROY && handler->destroy) {
@@ -863,14 +865,17 @@ static void twsk_build_assert(void)
 
 void inet_diag_dump_icsk(struct inet_hashinfo *hashinfo, struct sk_buff *skb,
 			 struct netlink_callback *cb,
-			 const struct inet_diag_req_v2 *r, struct nlattr *bc)
+			 const struct inet_diag_req_v2 *r)
 {
 	bool net_admin = netlink_net_capable(cb->skb, CAP_NET_ADMIN);
+	struct inet_diag_dump_data *cb_data = cb->data;
 	struct net *net = sock_net(skb->sk);
 	u32 idiag_states = r->idiag_states;
 	int i, num, s_i, s_num;
+	struct nlattr *bc;
 	struct sock *sk;
 
+	bc = cb_data->inet_diag_nla_bc;
 	if (idiag_states & TCPF_SYN_RECV)
 		idiag_states |= TCPF_NEW_SYN_RECV;
 	s_i = cb->args[1];
@@ -1014,15 +1019,14 @@ void inet_diag_dump_icsk(struct inet_hashinfo *hashinfo, struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(inet_diag_dump_icsk);
 
 static int __inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
-			    const struct inet_diag_req_v2 *r,
-			    struct nlattr *bc)
+			    const struct inet_diag_req_v2 *r)
 {
 	const struct inet_diag_handler *handler;
 	int err = 0;
 
 	handler = inet_diag_lock_handler(r->sdiag_protocol);
 	if (!IS_ERR(handler))
-		handler->dump(skb, cb, r, bc);
+		handler->dump(skb, cb, r);
 	else
 		err = PTR_ERR(handler);
 	inet_diag_unlock_handler(handler);
@@ -1032,13 +1036,57 @@ static int __inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 
 static int inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	int hdrlen = sizeof(struct inet_diag_req_v2);
-	struct nlattr *bc = NULL;
+	return __inet_diag_dump(skb, cb, nlmsg_data(cb->nlh));
+}
+
+static int __inet_diag_dump_start(struct netlink_callback *cb, int hdrlen)
+{
+	const struct nlmsghdr *nlh = cb->nlh;
+	struct inet_diag_dump_data *cb_data;
+	struct sk_buff *skb = cb->skb;
+	struct nlattr *nla;
+	int rem, err;
+
+	cb_data = kzalloc(sizeof(*cb_data), GFP_KERNEL);
+	if (!cb_data)
+		return -ENOMEM;
+
+	nla_for_each_attr(nla, nlmsg_attrdata(nlh, hdrlen),
+			  nlmsg_attrlen(nlh, hdrlen), rem) {
+		int type = nla_type(nla);
+
+		if (type < __INET_DIAG_REQ_MAX)
+			cb_data->req_nlas[type] = nla;
+	}
+
+	nla = cb_data->inet_diag_nla_bc;
+	if (nla) {
+		err = inet_diag_bc_audit(nla, skb);
+		if (err) {
+			kfree(cb_data);
+			return err;
+		}
+	}
+
+	cb->data = cb_data;
+	return 0;
+}
+
+static int inet_diag_dump_start(struct netlink_callback *cb)
+{
+	return __inet_diag_dump_start(cb, sizeof(struct inet_diag_req_v2));
+}
+
+static int inet_diag_dump_start_compat(struct netlink_callback *cb)
+{
+	return __inet_diag_dump_start(cb, sizeof(struct inet_diag_req));
+}
 
-	if (nlmsg_attrlen(cb->nlh, hdrlen))
-		bc = nlmsg_find_attr(cb->nlh, hdrlen, INET_DIAG_REQ_BYTECODE);
+static int inet_diag_dump_done(struct netlink_callback *cb)
+{
+	kfree(cb->data);
 
-	return __inet_diag_dump(skb, cb, nlmsg_data(cb->nlh), bc);
+	return 0;
 }
 
 static int inet_diag_type2proto(int type)
@@ -1057,9 +1105,7 @@ static int inet_diag_dump_compat(struct sk_buff *skb,
 				 struct netlink_callback *cb)
 {
 	struct inet_diag_req *rc = nlmsg_data(cb->nlh);
-	int hdrlen = sizeof(struct inet_diag_req);
 	struct inet_diag_req_v2 req;
-	struct nlattr *bc = NULL;
 
 	req.sdiag_family = AF_UNSPEC; /* compatibility */
 	req.sdiag_protocol = inet_diag_type2proto(cb->nlh->nlmsg_type);
@@ -1067,10 +1113,7 @@ static int inet_diag_dump_compat(struct sk_buff *skb,
 	req.idiag_states = rc->idiag_states;
 	req.id = rc->id;
 
-	if (nlmsg_attrlen(cb->nlh, hdrlen))
-		bc = nlmsg_find_attr(cb->nlh, hdrlen, INET_DIAG_REQ_BYTECODE);
-
-	return __inet_diag_dump(skb, cb, &req, bc);
+	return __inet_diag_dump(skb, cb, &req);
 }
 
 static int inet_diag_get_exact_compat(struct sk_buff *in_skb,
@@ -1098,22 +1141,12 @@ static int inet_diag_rcv_msg_compat(struct sk_buff *skb, struct nlmsghdr *nlh)
 		return -EINVAL;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
-		if (nlmsg_attrlen(nlh, hdrlen)) {
-			struct nlattr *attr;
-			int err;
-
-			attr = nlmsg_find_attr(nlh, hdrlen,
-					       INET_DIAG_REQ_BYTECODE);
-			err = inet_diag_bc_audit(attr, skb);
-			if (err)
-				return err;
-		}
-		{
-			struct netlink_dump_control c = {
-				.dump = inet_diag_dump_compat,
-			};
-			return netlink_dump_start(net->diag_nlsk, skb, nlh, &c);
-		}
+		struct netlink_dump_control c = {
+			.start = inet_diag_dump_start_compat,
+			.done = inet_diag_dump_done,
+			.dump = inet_diag_dump_compat,
+		};
+		return netlink_dump_start(net->diag_nlsk, skb, nlh, &c);
 	}
 
 	return inet_diag_get_exact_compat(skb, nlh);
@@ -1129,22 +1162,12 @@ static int inet_diag_handler_cmd(struct sk_buff *skb, struct nlmsghdr *h)
 
 	if (h->nlmsg_type == SOCK_DIAG_BY_FAMILY &&
 	    h->nlmsg_flags & NLM_F_DUMP) {
-		if (nlmsg_attrlen(h, hdrlen)) {
-			struct nlattr *attr;
-			int err;
-
-			attr = nlmsg_find_attr(h, hdrlen,
-					       INET_DIAG_REQ_BYTECODE);
-			err = inet_diag_bc_audit(attr, skb);
-			if (err)
-				return err;
-		}
-		{
-			struct netlink_dump_control c = {
-				.dump = inet_diag_dump,
-			};
-			return netlink_dump_start(net->diag_nlsk, skb, h, &c);
-		}
+		struct netlink_dump_control c = {
+			.start = inet_diag_dump_start,
+			.done = inet_diag_dump_done,
+			.dump = inet_diag_dump,
+		};
+		return netlink_dump_start(net->diag_nlsk, skb, h, &c);
 	}
 
 	return inet_diag_cmd_exact(h->nlmsg_type, skb, h, nlmsg_data(h));
diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index a2933eeabd91..d19cce39be1b 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -138,17 +138,21 @@ static int sk_diag_dump(struct sock *sk, struct sk_buff *skb,
 }
 
 static void raw_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
-			  const struct inet_diag_req_v2 *r, struct nlattr *bc)
+			  const struct inet_diag_req_v2 *r)
 {
 	bool net_admin = netlink_net_capable(cb->skb, CAP_NET_ADMIN);
 	struct raw_hashinfo *hashinfo = raw_get_hashinfo(r);
 	struct net *net = sock_net(skb->sk);
+	struct inet_diag_dump_data *cb_data;
 	int num, s_num, slot, s_slot;
 	struct sock *sk = NULL;
+	struct nlattr *bc;
 
 	if (IS_ERR(hashinfo))
 		return;
 
+	cb_data = cb->data;
+	bc = cb_data->inet_diag_nla_bc;
 	s_slot = cb->args[0];
 	num = s_num = cb->args[1];
 
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index bcd3a26efff1..75a1c985f49a 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -179,9 +179,9 @@ static size_t tcp_diag_get_aux_size(struct sock *sk, bool net_admin)
 }
 
 static void tcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
-			  const struct inet_diag_req_v2 *r, struct nlattr *bc)
+			  const struct inet_diag_req_v2 *r)
 {
-	inet_diag_dump_icsk(&tcp_hashinfo, skb, cb, r, bc);
+	inet_diag_dump_icsk(&tcp_hashinfo, skb, cb, r);
 }
 
 static int tcp_diag_dump_one(struct netlink_callback *cb,
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index 7d65a6a5cd51..93884696abdd 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -89,12 +89,16 @@ static int udp_dump_one(struct udp_table *tbl,
 
 static void udp_dump(struct udp_table *table, struct sk_buff *skb,
 		     struct netlink_callback *cb,
-		     const struct inet_diag_req_v2 *r, struct nlattr *bc)
+		     const struct inet_diag_req_v2 *r)
 {
 	bool net_admin = netlink_net_capable(cb->skb, CAP_NET_ADMIN);
 	struct net *net = sock_net(skb->sk);
+	struct inet_diag_dump_data *cb_data;
 	int num, s_num, slot, s_slot;
+	struct nlattr *bc;
 
+	cb_data = cb->data;
+	bc = cb_data->inet_diag_nla_bc;
 	s_slot = cb->args[0];
 	num = s_num = cb->args[1];
 
@@ -142,9 +146,9 @@ static void udp_dump(struct udp_table *table, struct sk_buff *skb,
 }
 
 static void udp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
-			  const struct inet_diag_req_v2 *r, struct nlattr *bc)
+			  const struct inet_diag_req_v2 *r)
 {
-	udp_dump(&udp_table, skb, cb, r, bc);
+	udp_dump(&udp_table, skb, cb, r);
 }
 
 static int udp_diag_dump_one(struct netlink_callback *cb,
@@ -245,10 +249,9 @@ static const struct inet_diag_handler udp_diag_handler = {
 };
 
 static void udplite_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
-			      const struct inet_diag_req_v2 *r,
-			      struct nlattr *bc)
+			      const struct inet_diag_req_v2 *r)
 {
-	udp_dump(&udplite_table, skb, cb, r, bc);
+	udp_dump(&udplite_table, skb, cb, r);
 }
 
 static int udplite_diag_dump_one(struct netlink_callback *cb,
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index bed6436cd0af..69743a6aaf6f 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -471,7 +471,7 @@ static int sctp_diag_dump_one(struct netlink_callback *cb,
 }
 
 static void sctp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
-			   const struct inet_diag_req_v2 *r, struct nlattr *bc)
+			   const struct inet_diag_req_v2 *r)
 {
 	u32 idiag_states = r->idiag_states;
 	struct net *net = sock_net(skb->sk);
-- 
2.17.1

