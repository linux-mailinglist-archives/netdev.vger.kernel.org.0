Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A07921C8A2
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 12:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgGLKzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 06:55:05 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59428 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728665AbgGLKyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 06:54:02 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 12 Jul 2020 13:53:19 +0300
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06CArJHc013152;
        Sun, 12 Jul 2020 13:53:19 +0300
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net
Cc:     borisp@mellanox.com, tariqt@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH] tls: add zerocopy device sendpage
Date:   Sun, 12 Jul 2020 13:53:15 +0300
Message-Id: <1594551195-3579-1-git-send-email-borisp@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for zerocopy sendfile when using TLS device offload.
Before this patch, TLS device offload would copy sendfile data to a
bounce buffer. This can be avoided when the user knows that page cache
data is not modified. For example, when a serving static files.
Removing this copy improves performance significaintly, as TLS and TCP
sendfile perform the same operations, and the only overhead is TLS
header/trailer insertion.

This patch adds two configuration knobs to control TLS zerocopy sendfile:
1) socket option named TLS_TX_ZEROCOPY_SENDFILE that enables
applications to use zerocopy sendfile on a per-socket basis.
2) global sysctl named tls_zerocopy_sendfile that defines the default
for the entire system.

Non TLS device enabled sockets are not affected by this option,
and attempts to configure it will fail.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
---
 include/net/netns/ipv4.h   |  4 ++++
 include/net/tls.h          |  1 +
 include/uapi/linux/tls.h   |  1 +
 net/ipv4/sysctl_net_ipv4.c |  9 +++++++
 net/tls/tls_device.c       | 39 ++++++++++++++++++++++--------
 net/tls/tls_main.c         | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 104 insertions(+), 10 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 9e36738c1fe1..bc828d272151 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -196,6 +196,10 @@ struct netns_ipv4 {
 	int sysctl_igmp_llm_reports;
 	int sysctl_igmp_qrv;
 
+#ifdef CONFIG_TLS_DEVICE
+	int sysctl_tls_zerocopy_sendfile;
+#endif
+
 	struct ping_group_range ping_group_range;
 
 	atomic_t dev_addr_genid;
diff --git a/include/net/tls.h b/include/net/tls.h
index e5dac7e74e79..f80985ac55de 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -172,6 +172,7 @@ struct tls_record_info {
 
 struct tls_offload_context_tx {
 	struct crypto_aead *aead_send;
+	bool zerocopy_sendpage;
 	spinlock_t lock;	/* protects records list */
 	struct list_head records_list;
 	struct tls_record_info *open_record;
diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index bcd2869ed472..d6f65f5d206f 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -39,6 +39,7 @@
 /* TLS socket options */
 #define TLS_TX			1	/* Set transmit parameters */
 #define TLS_RX			2	/* Set receive parameters */
+#define TLS_TX_ZEROCOPY_SENDFILE	3	/* transmit zerocopy sendfile */
 
 /* Supported versions */
 #define TLS_VERSION_MINOR(ver)	((ver) & 0xFF)
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 5653e3b011bf..0a0fc29225a2 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1353,6 +1353,15 @@ static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ONE
 	},
+#ifdef CONFIG_TLS_DEVICE
+	{
+		.procname	= "tls_zerocopy_sendfile",
+		.data		= &init_net.ipv4.sysctl_tls_zerocopy_sendfile,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+#endif
 	{ }
 };
 
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 18fa6067bb7f..092b20428c15 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -413,7 +413,8 @@ static int tls_device_copy_data(void *addr, size_t bytes, struct iov_iter *i)
 static int tls_push_data(struct sock *sk,
 			 struct iov_iter *msg_iter,
 			 size_t size, int flags,
-			 unsigned char record_type)
+			 unsigned char record_type,
+			 struct page *zc_page)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
@@ -482,11 +483,21 @@ static int tls_push_data(struct sock *sk,
 		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
 		copy = min_t(size_t, copy, (max_open_record_len - record->len));
 
-		rc = tls_device_copy_data(page_address(pfrag->page) +
-					  pfrag->offset, copy, msg_iter);
-		if (rc)
-			goto handle_error;
-		tls_append_frag(record, pfrag, copy);
+		if (!zc_page) {
+			rc = tls_device_copy_data(page_address(pfrag->page) +
+						  pfrag->offset, copy, msg_iter);
+			if (rc)
+				goto handle_error;
+			tls_append_frag(record, pfrag, copy);
+		} else {
+			struct page_frag _pfrag;
+
+			copy = min_t(size_t, size, (max_open_record_len - record->len));
+			_pfrag.page = zc_page;
+			_pfrag.offset = 0;
+			_pfrag.size = copy;
+			tls_append_frag(record, &_pfrag, copy);
+		}
 
 		size -= copy;
 		if (!size) {
@@ -548,7 +559,7 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	}
 
 	rc = tls_push_data(sk, &msg->msg_iter, size,
-			   msg->msg_flags, record_type);
+			   msg->msg_flags, record_type, NULL);
 
 out:
 	release_sock(sk);
@@ -560,9 +571,10 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 			int offset, size_t size, int flags)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
 	struct iov_iter	msg_iter;
-	char *kaddr = kmap(page);
 	struct kvec iov;
+	char *kaddr;
 	int rc;
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
@@ -576,11 +588,18 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 		goto out;
 	}
 
+	if (ctx->zerocopy_sendpage) {
+		rc = tls_push_data(sk, &msg_iter, size,
+				   flags, TLS_RECORD_TYPE_DATA, page);
+		goto out;
+	}
+
+	kaddr = kmap(page);
 	iov.iov_base = kaddr + offset;
 	iov.iov_len = size;
 	iov_iter_kvec(&msg_iter, WRITE, &iov, 1, size);
 	rc = tls_push_data(sk, &msg_iter, size,
-			   flags, TLS_RECORD_TYPE_DATA);
+			   flags, TLS_RECORD_TYPE_DATA, NULL);
 	kunmap(page);
 
 out:
@@ -654,7 +673,7 @@ static int tls_device_push_pending_record(struct sock *sk, int flags)
 	struct iov_iter	msg_iter;
 
 	iov_iter_kvec(&msg_iter, WRITE, NULL, 0, 0);
-	return tls_push_data(sk, &msg_iter, 0, flags, TLS_RECORD_TYPE_DATA);
+	return tls_push_data(sk, &msg_iter, 0, flags, TLS_RECORD_TYPE_DATA, NULL);
 }
 
 void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index ec10041c6b7d..b95437c91339 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -422,6 +422,27 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 	return rc;
 }
 
+static int do_tls_getsockopt_tx_zc(struct sock *sk, char __user *optval,
+				   int __user *optlen)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_offload_context_tx *ctx;
+	int len;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	len = min_t(unsigned int, len, sizeof(int));
+	if (len < 0)
+		return -EINVAL;
+
+	if (!tls_ctx || tls_ctx->tx_conf != TLS_HW)
+		return -EBUSY;
+
+	ctx = tls_offload_ctx_tx(tls_ctx);
+	return ctx->zerocopy_sendpage;
+}
+
 static int do_tls_getsockopt(struct sock *sk, int optname,
 			     char __user *optval, int __user *optlen)
 {
@@ -431,6 +452,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 	case TLS_TX:
 		rc = do_tls_getsockopt_tx(sk, optval, optlen);
 		break;
+	case TLS_TX_ZEROCOPY_SENDFILE:
+		rc = do_tls_getsockopt_tx_zc(sk, optval, optlen);
+		break;
 	default:
 		rc = -ENOPROTOOPT;
 		break;
@@ -450,6 +474,15 @@ static int tls_getsockopt(struct sock *sk, int level, int optname,
 	return do_tls_getsockopt(sk, optname, optval, optlen);
 }
 
+static void tls_set_tx_zerocopy_sendfile(struct tls_context *tls_ctx,
+					 int val)
+{
+	struct tls_offload_context_tx *ctx;
+
+	ctx = tls_offload_ctx_tx(tls_ctx);
+	ctx->zerocopy_sendpage = val;
+}
+
 static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
 				  unsigned int optlen, int tx)
 {
@@ -533,8 +566,11 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
 		rc = tls_set_device_offload(sk, ctx);
 		conf = TLS_HW;
 		if (!rc) {
+			int zc = sock_net(sk)->ipv4.sysctl_tls_zerocopy_sendfile;
+
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSTXDEVICE);
 			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSCURRTXDEVICE);
+			tls_set_tx_zerocopy_sendfile(ctx, zc);
 		} else {
 			rc = tls_set_sw_offload(sk, ctx, 1);
 			if (rc)
@@ -579,6 +615,25 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
 	return rc;
 }
 
+static int do_tls_setsockopt_tx_zc(struct sock *sk, char __user *optval,
+				   unsigned int optlen)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	int val;
+
+	if (!tls_ctx || tls_ctx->tx_conf != TLS_HW)
+		return -EINVAL;
+
+	if (optlen < sizeof(int))
+		return -EINVAL;
+
+	if (get_user(val, (int __user *)optval))
+		return -EFAULT;
+
+	tls_set_tx_zerocopy_sendfile(tls_ctx, val);
+	return 0;
+}
+
 static int do_tls_setsockopt(struct sock *sk, int optname,
 			     char __user *optval, unsigned int optlen)
 {
@@ -592,6 +647,11 @@ static int do_tls_setsockopt(struct sock *sk, int optname,
 					    optname == TLS_TX);
 		release_sock(sk);
 		break;
+	case TLS_TX_ZEROCOPY_SENDFILE:
+		lock_sock(sk);
+		rc = do_tls_setsockopt_tx_zc(sk, optval, optlen);
+		release_sock(sk);
+		break;
 	default:
 		rc = -ENOPROTOOPT;
 		break;
-- 
1.8.3.1

