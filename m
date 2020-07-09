Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364A421A093
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGINNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:13:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26175 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726768AbgGINNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:13:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594300389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uB8DjsLAHkhjUJIFkDAIvjRtKCGMznU2GJaEGiBaBMY=;
        b=UeP8JStv7KHFQ6+ReupGpR+oRqU+sbkzrSTl3jb/qnmku/WURvulVq0yEPq95DyhIZRjnm
        daHPTl9Zt7nB3RgjEUwglxp75Xat4gl+1P3ptY4A8uqO1tXi0zu1zZzJyCqfhQxcXWvfl1
        bAVS7IGGBnp/3BGGb8XCEVJLNXp9W/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-iD_l0Ty8NpKilgv-X5BF3w-1; Thu, 09 Jul 2020 09:13:00 -0400
X-MC-Unique: iD_l0Ty8NpKilgv-X5BF3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 782A280BCA2;
        Thu,  9 Jul 2020 13:12:59 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-239.ams2.redhat.com [10.36.113.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2835D2B6DD;
        Thu,  9 Jul 2020 13:12:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 1/4] inet_diag: support for wider protocol numbers
Date:   Thu,  9 Jul 2020 15:12:39 +0200
Message-Id: <2c52dcb2c5e5af58059714b496d5653c962b0c2a.1594292774.git.pabeni@redhat.com>
In-Reply-To: <cover.1594292774.git.pabeni@redhat.com>
References: <cover.1594292774.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit bf9765145b85 ("sock: Make sk_protocol a 16-bit value")
the current size of 'sdiag_protocol' is not sufficient to represent
the possible protocol values.

This change introduces a new inet diag request attribute to let
user space specify the relevant protocol number using u32 values.

The attribute is parsed by inet diag core on get/dump command
and the extended protocol value, if available, is preferred to
'sdiag_protocol' to lookup the diag handler.

The parse attributed are exposed to all the diag handlers via
the cb->data.

Note that inet_diag_dump_one_icsk() is left unmodified, as it
will not be used by protocol using the extended attribute.

Suggested-by: David S. Miller <davem@davemloft.net>
Co-developed-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/uapi/linux/inet_diag.h |  1 +
 net/core/sock.c                |  1 +
 net/ipv4/inet_diag.c           | 65 +++++++++++++++++++++++++---------
 3 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index e6f183ee8417..5ba122c1949a 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -65,6 +65,7 @@ enum {
 	INET_DIAG_REQ_NONE,
 	INET_DIAG_REQ_BYTECODE,
 	INET_DIAG_REQ_SK_BPF_STORAGES,
+	INET_DIAG_REQ_PROTOCOL,
 	__INET_DIAG_REQ_MAX,
 };
 
diff --git a/net/core/sock.c b/net/core/sock.c
index f5b5fdd61c88..de26fe4ea19f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3566,6 +3566,7 @@ int sock_load_diag_module(int family, int protocol)
 #ifdef CONFIG_INET
 	if (family == AF_INET &&
 	    protocol != IPPROTO_RAW &&
+	    protocol < MAX_INET_PROTOS &&
 	    !rcu_access_pointer(inet_protos[protocol]))
 		return -ENOENT;
 #endif
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 125f4f8a36b4..4a98dd736270 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -52,6 +52,11 @@ static DEFINE_MUTEX(inet_diag_table_mutex);
 
 static const struct inet_diag_handler *inet_diag_lock_handler(int proto)
 {
+	if (proto < 0 || proto >= IPPROTO_MAX) {
+		mutex_lock(&inet_diag_table_mutex);
+		return ERR_PTR(-ENOENT);
+	}
+
 	if (!inet_diag_table[proto])
 		sock_load_diag_module(AF_INET, proto);
 
@@ -181,6 +186,28 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(inet_diag_msg_attrs_fill);
 
+static void inet_diag_parse_attrs(const struct nlmsghdr *nlh, int hdrlen,
+				  struct nlattr **req_nlas)
+{
+	struct nlattr *nla;
+	int remaining;
+
+	nlmsg_for_each_attr(nla, nlh, hdrlen, remaining) {
+		int type = nla_type(nla);
+
+		if (type < __INET_DIAG_REQ_MAX)
+			req_nlas[type] = nla;
+	}
+}
+
+static int inet_diag_get_protocol(const struct inet_diag_req_v2 *req,
+				  const struct inet_diag_dump_data *data)
+{
+	if (data->req_nlas[INET_DIAG_REQ_PROTOCOL])
+		return nla_get_u32(data->req_nlas[INET_DIAG_REQ_PROTOCOL]);
+	return req->sdiag_protocol;
+}
+
 #define MAX_DUMP_ALLOC_SIZE (KMALLOC_MAX_SIZE - SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 
 int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
@@ -198,7 +225,7 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 	void *info = NULL;
 
 	cb_data = cb->data;
-	handler = inet_diag_table[req->sdiag_protocol];
+	handler = inet_diag_table[inet_diag_get_protocol(req, cb_data)];
 	BUG_ON(!handler);
 
 	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
@@ -539,20 +566,25 @@ EXPORT_SYMBOL_GPL(inet_diag_dump_one_icsk);
 
 static int inet_diag_cmd_exact(int cmd, struct sk_buff *in_skb,
 			       const struct nlmsghdr *nlh,
+			       int hdrlen,
 			       const struct inet_diag_req_v2 *req)
 {
 	const struct inet_diag_handler *handler;
-	int err;
+	struct inet_diag_dump_data dump_data;
+	int err, protocol;
 
-	handler = inet_diag_lock_handler(req->sdiag_protocol);
+	memset(&dump_data, 0, sizeof(dump_data));
+	inet_diag_parse_attrs(nlh, hdrlen, dump_data.req_nlas);
+	protocol = inet_diag_get_protocol(req, &dump_data);
+
+	handler = inet_diag_lock_handler(protocol);
 	if (IS_ERR(handler)) {
 		err = PTR_ERR(handler);
 	} else if (cmd == SOCK_DIAG_BY_FAMILY) {
-		struct inet_diag_dump_data empty_dump_data = {};
 		struct netlink_callback cb = {
 			.nlh = nlh,
 			.skb = in_skb,
-			.data = &empty_dump_data,
+			.data = &dump_data,
 		};
 		err = handler->dump_one(&cb, req);
 	} else if (cmd == SOCK_DESTROY && handler->destroy) {
@@ -1103,13 +1135,16 @@ EXPORT_SYMBOL_GPL(inet_diag_dump_icsk);
 static int __inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			    const struct inet_diag_req_v2 *r)
 {
+	struct inet_diag_dump_data *cb_data = cb->data;
 	const struct inet_diag_handler *handler;
 	u32 prev_min_dump_alloc;
-	int err = 0;
+	int protocol, err = 0;
+
+	protocol = inet_diag_get_protocol(r, cb_data);
 
 again:
 	prev_min_dump_alloc = cb->min_dump_alloc;
-	handler = inet_diag_lock_handler(r->sdiag_protocol);
+	handler = inet_diag_lock_handler(protocol);
 	if (!IS_ERR(handler))
 		handler->dump(skb, cb, r);
 	else
@@ -1139,19 +1174,13 @@ static int __inet_diag_dump_start(struct netlink_callback *cb, int hdrlen)
 	struct inet_diag_dump_data *cb_data;
 	struct sk_buff *skb = cb->skb;
 	struct nlattr *nla;
-	int rem, err;
+	int err;
 
 	cb_data = kzalloc(sizeof(*cb_data), GFP_KERNEL);
 	if (!cb_data)
 		return -ENOMEM;
 
-	nla_for_each_attr(nla, nlmsg_attrdata(nlh, hdrlen),
-			  nlmsg_attrlen(nlh, hdrlen), rem) {
-		int type = nla_type(nla);
-
-		if (type < __INET_DIAG_REQ_MAX)
-			cb_data->req_nlas[type] = nla;
-	}
+	inet_diag_parse_attrs(nlh, hdrlen, cb_data->req_nlas);
 
 	nla = cb_data->inet_diag_nla_bc;
 	if (nla) {
@@ -1237,7 +1266,8 @@ static int inet_diag_get_exact_compat(struct sk_buff *in_skb,
 	req.idiag_states = rc->idiag_states;
 	req.id = rc->id;
 
-	return inet_diag_cmd_exact(SOCK_DIAG_BY_FAMILY, in_skb, nlh, &req);
+	return inet_diag_cmd_exact(SOCK_DIAG_BY_FAMILY, in_skb, nlh,
+				   sizeof(struct inet_diag_req), &req);
 }
 
 static int inet_diag_rcv_msg_compat(struct sk_buff *skb, struct nlmsghdr *nlh)
@@ -1279,7 +1309,8 @@ static int inet_diag_handler_cmd(struct sk_buff *skb, struct nlmsghdr *h)
 		return netlink_dump_start(net->diag_nlsk, skb, h, &c);
 	}
 
-	return inet_diag_cmd_exact(h->nlmsg_type, skb, h, nlmsg_data(h));
+	return inet_diag_cmd_exact(h->nlmsg_type, skb, h, hdrlen,
+				   nlmsg_data(h));
 }
 
 static
-- 
2.26.2

