Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE4521A092
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGINNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:13:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58956 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726819AbgGINNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:13:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594300387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ISzCkSPuw8pvuMsZbW0IS+34qytnGwDF9rN9raK8C7I=;
        b=BfeCI2qw6zODACYuJr7L+9WhLER0ntO9u/u0MZ44+TImhidADSwpeixZ98CgcAfiPNkMZj
        FNDi8EUa4yKzkF+8hZkYUzK1jZthnxjb1lr2sgO4Ahl/KuGu/FObdRHd+w4Q9DdLQ0Mb2u
        8Om5OSIR8kN26TYQEmyNN95Rx7YSirk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-4pxLG8UWMhK06-7K7z1NTg-1; Thu, 09 Jul 2020 09:13:03 -0400
X-MC-Unique: 4pxLG8UWMhK06-7K7z1NTg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AF7380BCA6;
        Thu,  9 Jul 2020 13:13:02 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-239.ams2.redhat.com [10.36.113.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 605272B6DD;
        Thu,  9 Jul 2020 13:13:01 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 3/4] mptcp: add MPTCP socket diag interface
Date:   Thu,  9 Jul 2020 15:12:41 +0200
Message-Id: <7f9e6a085163dcb0669b9dd8aace1c62373279db.1594292774.git.pabeni@redhat.com>
In-Reply-To: <cover.1594292774.git.pabeni@redhat.com>
References: <cover.1594292774.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

exposes basic inet socket attribute, plus some MPTCP socket
fields comprising PM status and MPTCP-level sequence numbers.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/uapi/linux/mptcp.h |  17 ++++
 net/mptcp/Kconfig          |   4 +
 net/mptcp/Makefile         |   2 +
 net/mptcp/mptcp_diag.c     | 169 +++++++++++++++++++++++++++++++++++++
 4 files changed, 192 insertions(+)
 create mode 100644 net/mptcp/mptcp_diag.c

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 5f2c77082d9e..9762660df741 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -86,4 +86,21 @@ enum {
 	__MPTCP_PM_CMD_AFTER_LAST
 };
 
+#define MPTCP_INFO_FLAG_FALLBACK		_BITUL(0)
+#define MPTCP_INFO_FLAG_REMOTE_KEY_RECEIVED	_BITUL(1)
+
+struct mptcp_info {
+	__u8	mptcpi_subflows;
+	__u8	mptcpi_add_addr_signal;
+	__u8	mptcpi_add_addr_accepted;
+	__u8	mptcpi_subflows_max;
+	__u8	mptcpi_add_addr_signal_max;
+	__u8	mptcpi_add_addr_accepted_max;
+	__u32	mptcpi_flags;
+	__u32	mptcpi_token;
+	__u64	mptcpi_write_seq;
+	__u64	mptcpi_snd_una;
+	__u64	mptcpi_rcv_nxt;
+};
+
 #endif /* _UAPI_MPTCP_H */
diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
index af84fce70bb0..698bc3525160 100644
--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -13,6 +13,10 @@ config MPTCP
 
 if MPTCP
 
+config INET_MPTCP_DIAG
+	depends on INET_DIAG
+	def_tristate INET_DIAG
+
 config MPTCP_IPV6
 	bool "MPTCP: IPv6 support for Multipath TCP"
 	select IPV6
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index c53f9b845523..2360cbd27d59 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -4,6 +4,8 @@ obj-$(CONFIG_MPTCP) += mptcp.o
 mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o pm.o diag.o \
 	   mib.o pm_netlink.o
 
+obj-$(CONFIG_INET_MPTCP_DIAG) += mptcp_diag.o
+
 mptcp_crypto_test-objs := crypto_test.o
 mptcp_token_test-objs := token_test.o
 obj-$(CONFIG_MPTCP_KUNIT_TESTS) += mptcp_crypto_test.o mptcp_token_test.o
diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
new file mode 100644
index 000000000000..5f390a97f556
--- /dev/null
+++ b/net/mptcp/mptcp_diag.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0
+/* MPTCP socket monitoring support
+ *
+ * Copyright (c) 2020 Red Hat
+ *
+ * Author: Paolo Abeni <pabeni@redhat.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/net.h>
+#include <linux/inet_diag.h>
+#include <net/netlink.h>
+#include <uapi/linux/mptcp.h>
+#include "protocol.h"
+
+static int sk_diag_dump(struct sock *sk, struct sk_buff *skb,
+			struct netlink_callback *cb,
+			const struct inet_diag_req_v2 *req,
+			struct nlattr *bc, bool net_admin)
+{
+	if (!inet_diag_bc_sk(bc, sk))
+		return 0;
+
+	return inet_sk_diag_fill(sk, inet_csk(sk), skb, cb, req, NLM_F_MULTI,
+				 net_admin);
+}
+
+static int mptcp_diag_dump_one(struct netlink_callback *cb,
+			       const struct inet_diag_req_v2 *req)
+{
+	struct sk_buff *in_skb = cb->skb;
+	struct mptcp_sock *msk = NULL;
+	struct sk_buff *rep;
+	int err = -ENOENT;
+	struct net *net;
+	struct sock *sk;
+
+	net = sock_net(in_skb->sk);
+	msk = mptcp_token_get_sock(req->id.idiag_cookie[0]);
+	if (!msk)
+		goto out_nosk;
+
+	err = -ENOMEM;
+	sk = (struct sock *)msk;
+	rep = nlmsg_new(nla_total_size(sizeof(struct inet_diag_msg)) +
+			inet_diag_msg_attrs_size() +
+			nla_total_size(sizeof(struct mptcp_info)) +
+			nla_total_size(sizeof(struct inet_diag_meminfo)) + 64,
+			GFP_KERNEL);
+	if (!rep)
+		goto out;
+
+	err = inet_sk_diag_fill(sk, inet_csk(sk), rep, cb, req, 0,
+				netlink_net_capable(in_skb, CAP_NET_ADMIN));
+	if (err < 0) {
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(rep);
+		goto out;
+	}
+	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid,
+			      MSG_DONTWAIT);
+	if (err > 0)
+		err = 0;
+out:
+	sock_put(sk);
+
+out_nosk:
+	return err;
+}
+
+static void mptcp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
+			    const struct inet_diag_req_v2 *r)
+{
+	bool net_admin = netlink_net_capable(cb->skb, CAP_NET_ADMIN);
+	struct net *net = sock_net(skb->sk);
+	struct inet_diag_dump_data *cb_data;
+	struct mptcp_sock *msk;
+	struct nlattr *bc;
+
+	cb_data = cb->data;
+	bc = cb_data->inet_diag_nla_bc;
+
+	while ((msk = mptcp_token_iter_next(net, &cb->args[0], &cb->args[1])) !=
+	       NULL) {
+		struct inet_sock *inet = (struct inet_sock *)msk;
+		struct sock *sk = (struct sock *)msk;
+		int ret = 0;
+
+		if (!(r->idiag_states & (1 << sk->sk_state)))
+			goto next;
+		if (r->sdiag_family != AF_UNSPEC &&
+		    sk->sk_family != r->sdiag_family)
+			goto next;
+		if (r->id.idiag_sport != inet->inet_sport &&
+		    r->id.idiag_sport)
+			goto next;
+		if (r->id.idiag_dport != inet->inet_dport &&
+		    r->id.idiag_dport)
+			goto next;
+
+		ret = sk_diag_dump(sk, skb, cb, r, bc, net_admin);
+next:
+		sock_put(sk);
+		if (ret < 0) {
+			/* will retry on the same position */
+			cb->args[1]--;
+			break;
+		}
+		cond_resched();
+	}
+}
+
+static void mptcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
+				void *_info)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_info *info = _info;
+	u32 flags = 0;
+	bool slow;
+	u8 val;
+
+	r->idiag_rqueue = sk_rmem_alloc_get(sk);
+	r->idiag_wqueue = sk_wmem_alloc_get(sk);
+	if (!info)
+		return;
+
+	slow = lock_sock_fast(sk);
+	info->mptcpi_subflows = READ_ONCE(msk->pm.subflows);
+	info->mptcpi_add_addr_signal = READ_ONCE(msk->pm.add_addr_signaled);
+	info->mptcpi_add_addr_accepted = READ_ONCE(msk->pm.add_addr_accepted);
+	info->mptcpi_subflows_max = READ_ONCE(msk->pm.subflows_max);
+	val = READ_ONCE(msk->pm.add_addr_signal_max);
+	info->mptcpi_add_addr_signal_max = val;
+	val = READ_ONCE(msk->pm.add_addr_accept_max);
+	info->mptcpi_add_addr_accepted_max = val;
+	if (test_bit(MPTCP_FALLBACK_DONE, &msk->flags))
+		flags |= MPTCP_INFO_FLAG_FALLBACK;
+	if (READ_ONCE(msk->can_ack))
+		flags |= MPTCP_INFO_FLAG_REMOTE_KEY_RECEIVED;
+	info->mptcpi_flags = flags;
+	info->mptcpi_token = READ_ONCE(msk->token);
+	info->mptcpi_write_seq = READ_ONCE(msk->write_seq);
+	info->mptcpi_snd_una = atomic64_read(&msk->snd_una);
+	info->mptcpi_rcv_nxt = READ_ONCE(msk->ack_seq);
+	unlock_sock_fast(sk, slow);
+}
+
+static const struct inet_diag_handler mptcp_diag_handler = {
+	.dump		 = mptcp_diag_dump,
+	.dump_one	 = mptcp_diag_dump_one,
+	.idiag_get_info  = mptcp_diag_get_info,
+	.idiag_type	 = IPPROTO_MPTCP,
+	.idiag_info_size = sizeof(struct mptcp_info),
+};
+
+static int __init mptcp_diag_init(void)
+{
+	return inet_diag_register(&mptcp_diag_handler);
+}
+
+static void __exit mptcp_diag_exit(void)
+{
+	inet_diag_unregister(&mptcp_diag_handler);
+}
+
+module_init(mptcp_diag_init);
+module_exit(mptcp_diag_exit);
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_NETLINK, NETLINK_SOCK_DIAG, 2-262 /* AF_INET - IPPROTO_MPTCP */);
-- 
2.26.2

